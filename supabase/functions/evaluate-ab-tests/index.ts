import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-supabase-client-platform, x-supabase-client-platform-version, x-supabase-client-runtime, x-supabase-client-runtime-version",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: corsHeaders });

  try {
    const sb = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    // Get all running tests
    const { data: tests, error: testsError } = await sb
      .from("ai_ab_tests")
      .select("*")
      .eq("status", "RUNNING");

    if (testsError) throw testsError;
    if (!tests || tests.length === 0) {
      return new Response(
        JSON.stringify({ success: true, message: "Nenhum teste A/B em execução.", evaluated: 0 }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    let evaluated = 0;

    for (const test of tests) {
      if (!test.product_id) continue;

      // Get analytics events for this product
      const { data: events } = await sb
        .from("ai_analytics_events")
        .select("*")
        .eq("product_id", test.product_id)
        .order("date", { ascending: false })
        .limit(100);

      if (!events || events.length < 2) continue;

      // Calculate metrics for each variant
      const variantAEvents = events.filter(
        (e: any) => e.metrics?.variant === test.variant_a_id || e.metrics?.variant === "A",
      );
      const variantBEvents = events.filter(
        (e: any) => e.metrics?.variant === test.variant_b_id || e.metrics?.variant === "B",
      );

      const calcMetrics = (evts: any[]) => {
        const clicks = evts.filter((e: any) => e.event_type === "clicks").length;
        const conversions = evts.filter((e: any) => e.event_type === "conversions").length;
        const views = evts.filter((e: any) => e.event_type === "views").length;
        const ctr = views > 0 ? (clicks / views) * 100 : 0;
        const conversionRate = clicks > 0 ? (conversions / clicks) * 100 : 0;
        return { clicks, conversions, views, ctr: Math.round(ctr * 100) / 100, conversionRate: Math.round(conversionRate * 100) / 100 };
      };

      const metricsA = calcMetrics(variantAEvents);
      const metricsB = calcMetrics(variantBEvents);

      // Determine winner based on conversion rate, then CTR
      let winnerId: string | null = null;
      if (metricsA.conversionRate > metricsB.conversionRate) {
        winnerId = test.variant_a_id;
      } else if (metricsB.conversionRate > metricsA.conversionRate) {
        winnerId = test.variant_b_id;
      } else if (metricsA.ctr > metricsB.ctr) {
        winnerId = test.variant_a_id;
      } else if (metricsB.ctr > metricsA.ctr) {
        winnerId = test.variant_b_id;
      }

      // Only complete if we have enough data (at least 10 total events)
      const totalEvents = variantAEvents.length + variantBEvents.length;
      if (totalEvents >= 10 && winnerId) {
        await sb
          .from("ai_ab_tests")
          .update({
            winner_id: winnerId,
            status: "COMPLETED",
            metrics: {
              variant_a: { id: test.variant_a_id, ...metricsA },
              variant_b: { id: test.variant_b_id, ...metricsB },
              total_events: totalEvents,
              evaluated_at: new Date().toISOString(),
            },
          })
          .eq("id", test.id);
        evaluated++;
      } else {
        // Update metrics without completing
        await sb
          .from("ai_ab_tests")
          .update({
            metrics: {
              variant_a: { id: test.variant_a_id, ...metricsA },
              variant_b: { id: test.variant_b_id, ...metricsB },
              total_events: totalEvents,
              last_check: new Date().toISOString(),
            },
          })
          .eq("id", test.id);
      }
    }

    return new Response(
      JSON.stringify({ success: true, evaluated, total_tests: tests.length }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  } catch (err: any) {
    console.error("evaluate-ab-tests error:", err);
    return new Response(JSON.stringify({ error: err.message || "Erro interno" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
