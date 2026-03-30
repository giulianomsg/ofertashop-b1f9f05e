import { createClient, SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2";

// ----------------------------------------------------------
// CORS headers for browser-based testing / preflight
// ----------------------------------------------------------
const corsHeaders: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-api-key",
  "Access-Control-Allow-Methods": "GET, OPTIONS",
};

// ----------------------------------------------------------
// Types
// ----------------------------------------------------------
interface ApiClient {
  id: string;
  client_name: string;
  api_key: string;
  webhook_url: string | null;
  webhook_events: string[];
  is_active: boolean;
}

interface ProductRow {
  id: string;
  title: string;
  original_price: number | null;
  price: number;
  discount_percentage: number | null;
  affiliate_url: string;
  gallery_urls: string[] | null;
  image_url: string | null;
  is_active: boolean;
  platforms: { name: string } | null;
  categories: { name: string } | null;
}

interface GerashopOffer {
  external_id: string;
  name: string;
  platform: string;
  category: string;
  original_price: number | null;
  promotional_price: number;
  discount_percentage: number | null;
  affiliate_link: string;
  image_urls: string[];
  stock: number;
}

interface PaginatedResponse {
  success: boolean;
  data: GerashopOffer[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    pages: number;
  };
}

// ----------------------------------------------------------
// Helpers
// ----------------------------------------------------------
function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

function errorResponse(message: string, status: number): Response {
  return jsonResponse({ success: false, error: message }, status);
}

/**
 * Validates the x-api-key header against the api_clients table.
 * Returns the matching ApiClient row or null.
 */
async function authenticateRequest(
  sb: SupabaseClient,
  apiKey: string | null,
): Promise<ApiClient | null> {
  if (!apiKey) return null;

  const { data, error } = await sb
    .from("api_clients")
    .select("id, client_name, api_key, webhook_url, webhook_events, is_active")
    .eq("api_key", apiKey)
    .maybeSingle();

  if (error || !data) return null;
  if (!data.is_active) return null;

  return data as ApiClient;
}

/**
 * Maps a raw product row to the Gerashop offer contract.
 */
function mapToGerashopOffer(row: ProductRow): GerashopOffer {
  const imageUrls: string[] = [];

  // Prefer gallery_urls; fall back to image_url
  if (row.gallery_urls && Array.isArray(row.gallery_urls) && row.gallery_urls.length > 0) {
    imageUrls.push(...row.gallery_urls);
  } else if (row.image_url) {
    imageUrls.push(row.image_url);
  }

  return {
    external_id: row.id,
    name: row.title,
    platform: row.platforms?.name ?? "Desconhecida",
    category: row.categories?.name ?? "Sem Categoria",
    original_price: row.original_price,
    promotional_price: row.price,
    discount_percentage: row.discount_percentage,
    affiliate_link: row.affiliate_url,
    image_urls: imageUrls,
    stock: 999, // Ofertashop does NOT track stock — static value per requirement
  };
}

// ----------------------------------------------------------
// Route: GET /offers
// ----------------------------------------------------------
async function handleGetOffers(
  sb: SupabaseClient,
  url: URL,
): Promise<Response> {
  const page = Math.max(1, parseInt(url.searchParams.get("page") ?? "1", 10));
  const limit = Math.min(
    100,
    Math.max(1, parseInt(url.searchParams.get("limit") ?? "50", 10)),
  );
  const offset = (page - 1) * limit;

  // 1. Get total count
  const { count, error: countError } = await sb
    .from("products")
    .select("id", { count: "exact", head: true })
    .eq("is_active", true);

  if (countError) {
    console.error("Count error:", countError);
    return errorResponse("Erro interno ao contar produtos.", 500);
  }

  const total = count ?? 0;
  const pages = Math.ceil(total / limit);

  // 2. Fetch paginated products with joins
  const { data: products, error: fetchError } = await sb
    .from("products")
    .select(
      "id, title, original_price, price, discount_percentage, affiliate_url, gallery_urls, image_url, is_active, platforms(name), categories(name)",
    )
    .eq("is_active", true)
    .order("created_at", { ascending: false })
    .range(offset, offset + limit - 1);

  if (fetchError) {
    console.error("Fetch error:", fetchError);
    return errorResponse("Erro interno ao buscar produtos.", 500);
  }

  const offers: GerashopOffer[] = (products ?? []).map((p: any) =>
    mapToGerashopOffer(p as ProductRow),
  );

  const response: PaginatedResponse = {
    success: true,
    data: offers,
    pagination: { page, limit, total, pages },
  };

  return jsonResponse(response);
}

// ----------------------------------------------------------
// Main Server
// ----------------------------------------------------------
Deno.serve(async (req: Request): Promise<Response> => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 204, headers: corsHeaders });
  }

  try {
    // Initialise Supabase with service role (bypasses RLS)
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!supabaseUrl || !serviceRoleKey) {
      return errorResponse("Configuração de servidor incompleta.", 500);
    }

    const sb = createClient(supabaseUrl, serviceRoleKey);

    // Authenticate via x-api-key header
    const apiKey = req.headers.get("x-api-key");
    const client = await authenticateRequest(sb, apiKey);

    if (!apiKey) {
      return errorResponse(
        "Cabeçalho x-api-key é obrigatório.",
        401,
      );
    }

    if (!client) {
      return errorResponse(
        "API Key inválida ou cliente desativado.",
        403,
      );
    }

    // Parse the URL path
    const url = new URL(req.url);
    const pathname = url.pathname;

    // Extract the function-relative path
    // Supabase Edge Functions are served under /api-integration/...
    // The path after the function name is the route
    const routeMatch = pathname.match(/\/api-integration(\/.*)?/);
    const route = routeMatch?.[1] ?? "/";

    // Route dispatching
    if (req.method === "GET" && (route === "/offers" || route === "/offers/")) {
      return await handleGetOffers(sb, url);
    }

    // Health-check / root
    if (req.method === "GET" && (route === "/" || route === "")) {
      return jsonResponse({
        success: true,
        message: "Ofertashop Adapter API",
        version: "1.0.0",
        client: client.client_name,
      });
    }

    return errorResponse("Rota não encontrada.", 404);
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : "Erro interno desconhecido.";
    console.error("api-integration error:", err);
    return errorResponse(message, 500);
  }
});
