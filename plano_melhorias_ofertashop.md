# Análise Completa do Projeto OfertaShop

## 🚨 CORREÇÃO APLICADA: Problema de Recarregamento Automático

**Problema relatado**: A página recarregava automaticamente ao trocar de aba, minimizar/maximizar a janela.

**Causa identificada**: Configuração do React Query que permitia refetch automático em alguns cenários, mesmo com `refetchOnWindowFocus: false`.

**Solução implementada** (commit atual):
1. ✅ Aumentado `staleTime` de 5 para 10 minutos
2. ✅ Adicionado `refetchOnMount: false` e `refetchOnReconnect: false`
3. ✅ Aumentado `gcTime` (cache) para 30 minutos
4. ✅ Configurado `networkMode: 'always'` para usar cache offline
5. ✅ Criado hook `usePageVisibility` que cancela queries quando página fica oculta
6. ✅ Ajustado Vite HMR para desenvolvimento mais estável
7. ✅ Adicionado hook de debug `useQueryDebug` para monitorar queries (temporário)

**Arquivos modificados**:
- `src/App.tsx` - Nova configuração do QueryClient + hooks integrados
- `src/hooks/usePageVisibility.ts` - Novo hook criado
- `src/hooks/useQueryDebug.ts` - Novo hook de debug criado
- `vite.config.ts` - Ajustes no HMR

**Teste**: Após as mudanças, a página NÃO deve mais recarregar automaticamente ao trocar de aba ou minimizar/maximizar.

**Diagnóstico adicional**: Se ainda houver loading momentâneo, use o hook `useQueryDebug` no `App.tsx` para identificar quais queries estão sendo disparadas inesperadamente.

---

## 1. RESUMO EXECUTIVO

O **OfertaShop** é uma plataforma completa de agregador de ofertas e cupons, desenvolvida com stack moderna e bem estruturada. O sistema funciona como um marketplace de ofertas onde usuários podem:

- Navegar e buscar produtos/ofertas de múltiplas plataformas (Shopee, Mercado Livre, etc.)
- Avaliar produtos e votar na confiabilidade das ofertas
- Salvar produtos em lista de desejos
- Acompanhar histórico de preços
- Utilizar cupons de desconto
- Interagir via reviews e sistema de likes

**Backoffice completo** para administradores gerenciarem todo o conteúdo, usuários, produtos, banners, newsletters e integrações.

---

## 2. ARQUITETURA E TECNOLOGIAS

### Stack Principal
- **Frontend**: React 18 + TypeScript + Vite
- **UI Components**: shadcn/ui (Radix UI) + Tailwind CSS
- **Animações**: Framer Motion
- **State Management**: TanStack Query (React Query) v5
- **Roteamento**: React Router v6
- **Backend/Database**: Supabase (PostgreSQL)
- **Autenticação**: Supabase Auth
- **Editor de texto**: React Quill
- **Drag & Drop**: @dnd-kit
- **Gráficos**: Recharts
- **Deploy**: Vercel/Netlify (configurado)

### Padrões Arquiteturais
- ✅ Component-based architecture
- ✅ Custom hooks para lógica de negócio
- ✅ Context API para autenticação
- ✅ Query hooks para gerenciamento de dados
- ✅ TypeScript com tipos gerados do Supabase
- ✅ Responsivo (mobile-first)

---

## 3. ESTRUTURA DO PROJETO

```
src/
├── components/
│   ├── ui/                    # Componentes shadcn/ui (40+ componentes)
│   ├── CouponItem.tsx
│   ├── FilterSidebar.tsx      # Filtros avançados
│   ├── HeroCarousel.tsx
│   ├── NavLink.tsx
│   ├── ProductCard.tsx
│   ├── SiteFooter.tsx
│   ├── SiteHeader.tsx
├── data/
│   └── products.ts           # Dados mock (aparentemente não usado)
├── hooks/
│   ├── useAuth.tsx           # Autenticação e roles
│   ├── useBanners.ts
│   ├ useEntities.ts          # CRUD de entidades (500+ linhas)
│   ├── useProducts.ts        # CRUD de produtos + reviews
│   ├── useVisitorSession.ts
├── integrations/
│   └── supabase/
│       ├── client.ts
│       └── types.ts          # Tipos TypeScript gerados
├── lib/
│   └── utils.ts
├── pages/
│   ├── Index.tsx             # Home com catálogo
│   ├── ProductDetail.tsx     # Página de detalhe (693 linhas)
│   ├── Login.tsx
│   ├── UserProfile.tsx
│   ├── InstitutionalPage.tsx
│   ├── SpecialPage.tsx
│   ├── NotFound.tsx
│   └── admin/                # 15 páginas administrativas
├── App.tsx
└── main.tsx
```

---

## 4. BANCO DE DADOS (Supabase)

### Tabelas Principais
- `products` - Produtos/ofertas
- `categories` - Categorias
- `brands` - Marcas
- `models` - Modelos
- `platforms` - Plataformas (Shopee, ML, etc.)
- `reviews` - Avaliações de usuários
- `product_likes` - Curtidas
- `product_trust_votes` - Votos de confiança
- `product_clicks` - Rastreamento de cliques
- `wishlists` - Lista de desejos
- `price_history` - Histórico de preços
- `coupons` - Cupons de desconto
- `coupon_votes` - Votos em cupons
- `banners` - Banners rotativos
- `newsletters` - Newsletters
- `reports` - Denúncias de ofertas
- `institutional_pages` - Páginas institucionais
- `special_pages` - Páginas especiais
- `whatsapp_groups` - Grupos de WhatsApp
- `profiles` - Perfis de usuários
- `user_roles` - Papéis (admin, editor, viewer)

### Recursos Avançados
- Row Level Security (RLS) configurado
- Views materializadas (`admin_users_view`)
- Funções RPC personalizadas
- Triggers para auditoria
- Storage policies

---

## 5. PONTOS FORTES IDENTIFICADOS

### ✅ **Código e Arquitetura**
1. **TypeScript bem configurado** com tipos gerados automaticamente do Supabase
2. **Separação de responsabilidades** clara (hooks, components, pages)
3. **React Query** implementado corretamente com cache e invalidação
4. **Custom hooks** bem estruturados e reutilizáveis
5. **Componentes acessíveis** usando Radix UI
6. **Design system** consistente com Tailwind + shadcn/ui
7. **Animações suaves** com Framer Motion
8. **SEO** implementado com react-helmet-async

### ✅ **Funcionalidades**
1. **Sistema completo de reviews** com rating
2. **Votação de confiança** (trust votes) para combater fraudes
3. **Rastreamento de cliques** e métricas
4. **Histórico de preços** com gráfico Recharts
5. **Filtros avançados** (categoria, preço, rating, loja)
6. **Paginacão client-side** funcional
7. **Busca por texto** integrada
8. **Wishlist** persistida
9. **Sistema de cupons** com votação de utilidade
10. **Integração com múltiplas plataformas** (Shopee, ML)
11. **Upload de imagens** com drag-and-drop
12. **Editor HTML** (React Quill) para descrições
13. **Banners gerenciáveis**
14. **Newsletter** com produtos em destaque
15. **Denúncias** de ofertas expiradas

### ✅ **Admin**
1. **Painel administrativo completo** com 15 seções
2. **CRUD para todas as entidades**
3. **Gerenciamento de usuários e roles**
4. **Sidebar responsiva** com collapse
5. **Upload de imagens** integrado
6. **Ordenação por drag-and-drop** na galeria

---

## 6. PROBLEMAS E OPORTUNIDADES DE MELHORIA

### 🔴 **CRÍTICOS - Performance**

#### 6.1. Paginação Client-Side em Grande Escala
**Problema**: No `Index.tsx` (linhas 12-18), a nota de dívida técnica alerta:
```typescript
// NOTA DE DÍVIDA TÉCNICA:
// A paginação atual é client-side (slice do array local), o que significa
// que toda a coleção de produtos é carregada de uma vez via useProducts().
```

**Impacto**: Com milhares de produtos, o carregamento inicial será lento e o consumo de memória alto.

**Solução**: Implementar paginação server-side:
```typescript
// No useProducts.ts
queryFn: async ({ pageParam = 1 }) => {
  const limit = 20;
  const offset = (pageParam - 1) * limit;
  
  const { data, count } = await supabase
    .from("products")
    .select("*", { count: "exact" })
    .eq("is_active", true)
    .order("created_at", { ascending: false })
    .range(offset, offset + limit - 1);
  
  return { data, count, page: pageParam };
},
```

#### 6.2. N+1 Query Problem
**Problema**: Em `ProductDetail.tsx`, múltiplas queries separadas:
- `useProduct(id)` - 1 query
- `useReviews(id)` - 1 query por produto
- `usePriceHistory(id)` - 1 query
- `usePlatforms()` - shared, mas chamada em cada produto

**Solução**: Usar joins no Supabase ou React Query `dependent queries`:
```typescript
// Em useProducts.ts, adicionar query com joins
const { data: productWithDetails } = useQuery({
  queryKey: ["product_detail", id],
  queryFn: async () => {
    const { data } = await supabase
      .from("products")
      .select(`
        *,
        platforms (*),
        categories (*),
        brands (*),
        models (*),
        reviews (rating, comment, created_at, user_name),
        price_history (*)
      `)
      .eq("id", id)
      .maybeSingle();
    return data;
  },
  enabled: !!id,
});
```

#### 6.3. React Query Configuração
**Problema**: Configuração muito básica no `App.tsx`:
```typescript
staleTime: 1000 * 60 * 5, // 5 minutos
```

**Sugestão**: Ajustar por tipo de dado:
- Produtos: 1-2 minutos (muda frequentemente)
- Categorias/Marcas: 10-15 minutos (quase estático)
- Reviews: 30 segundos (tempo real)

---

### 🔴 **CRÍTICOS - Segurança**

#### 6.4. Row Level Security (RLS) Não Verificado
**Problema**: Não há evidência de que RLS está ativo nas tabelas. O schema mostra `row_security = off` no dump.

**Risco**: Qualquer usuário poderia acessar/modificar dados de outros.

**Ação Imediata**:
```sql
-- Habilitar RLS em todas as tabelas
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
-- ... todas as tabelas

-- Criar policies
CREATE POLICY "Users can view active products" ON products
  FOR SELECT USING (is_active = true);
  
CREATE POLICY "Users can insert own reviews" ON reviews
  FOR INSERT WITH CHECK (auth.uid() = user_id);
```

#### 6.5. Validação de Input Ausente
**Problema**: Em várias páginas admin, não há validação robusta:
- `AdminProducts.tsx`: URLs de afiliado não validadas
- `AdminCoupons.tsx`: Códigos de cupom sem formato
- Upload de imagens sem verificar tipo/tamanho

**Solução**: Implementar validação com Zod:
```typescript
import { z } from "zod";

const productSchema = z.object({
  title: z.string().min(1).max(200),
  price: z.number().positive(),
  affiliate_url: z.string().url(),
  image_url: z.string().url().optional(),
  // ...
});
```

#### 6.6. Exposição de Chaves de API
**Problema**: Verificar se há chaves hardcoded em algum lugar.

**Ação**: Garantir que todas as variáveis de ambiente estão em `.env` e no `.gitignore`.

---

### 🟡 **ALTOS - Código e Manutenibilidade**

#### 6.7. Componente ProductDetail Muito Grande
**Problema**: `ProductDetail.tsx` tem **693 linhas** - God Component.

**Impacto**: Difícil de testar, manter, entender.

**Solução**: Extrair em subcomponentes:
- `ProductGallery` (carrossel de imagens)
- `ProductInfo` (título, preço, rating)
- `ProductActions` (like, wishlist, share)
- `ProductTrust` (votos de confiança)
- `ProductReviews` (lista e formulário)
- `ProductPriceHistory` (gráfico)
- `ProductRelated` (produtos relacionados)
- `ProductCoupons` (cupons da plataforma)

#### 6.8. Hook useEntities.ts Muito Longo
**Problema**: 574 linhas com dezenas de hooks.

**Solução**: Separar em módulos:
```
hooks/
├── useBrands.ts
├── useModels.ts
├── usePlatforms.ts
├── useCategories.ts
├── useCoupons.ts
├── useSpecialPages.ts
└── useEntities.ts  (re-export todos)
```

#### 6.9. TypeScript: Uso Excessivo de `any`
**Problema**: Vários places com `as any`:
- `useEntities.ts`: `(supabase as any).from(...)`
- `ProductDetail.tsx`: `productAny = product as any`

**Causa**: Tipos do Supabase não cobrem todas as tabelas/views.

**Solução**: 
1. Estender tipos em `src/integrations/supabase/types.ts`:
```typescript
declare module "@/integrations/supabase/types" {
  export interface Database {
    public: {
      Tables: {
        // ... adicionar todas as tabelas manualmente se necessário
      };
      Views: {
        admin_users_view: {
          Row: { /* estrutura */ };
        };
      };
    };
  }
}
```
2. Criar tipos locais para views específicas.

#### 6.10. Tratamento de Erros Inconsistente
**Problema**: Algumas mutations têm `onError` com toast, outras não.

**Solução**: Criar wrapper para mutations:
```typescript
const useSafeMutation = (mutationFn: any, options: any) => {
  return useMutation({
    mutationFn,
    onError: (error) => {
      toast.error(error.message || "Erro desconhecido");
      console.error(error);
    },
    ...options,
  });
};
```

#### 6.11. Loading States Repetitivos
**Problema**: Muitos componentes têm lógica similar de loading.

**Solução**: Criar componente genérico:
```typescript
const WithLoading = <T,>({ query, render }: { query: UseQueryResult<T>; render: (data: T) => JSX.Element }) => {
  if (query.isLoading) return <SkeletonLoader />;
  if (query.isError) return <ErrorMessage />;
  return render(query.data!);
};
```

---

### 🟢 **MÉDIOS - UX/UI**

#### 6.12. Feedback de Ação Insuficiente
**Problema**: Ao clicar em "Acessar Oferta", o clique é rastreado mas não há feedback visual imediato.

**Solução**: Adicionar loading state no botão:
```typescript
const [accessing, setAccessing] = useState(false);
const handleAccessOffer = async () => {
  setAccessing(true);
  await handleAccessOfferLogic();
  setAccessing(false);
};
```

#### 6.13. Mobile: Filtros Ocultos
**Problema**: No mobile, filtros ficam escondidos atrás de botão - OK, mas não há contador de filtros ativos.

**Solução**: Mostrar badge no botão "Filtros" com quantidade de filtros ativos.

#### 6.14. Validação de Formulários
**Problema**: Formulário de review em `ProductDetail.tsx` permite enviar sem validação robusta.

**Solução**: Usar react-hook-form + zod:
```typescript
const reviewSchema = z.object({
  rating: z.number().min(1).max(5),
  comment: z.string().max(500).optional(),
});
```

#### 6.15. Acessibilidade
**Problema**: Alguns elementos sem `aria-label` ou roles apropriados.

**Solução**: Auditoria comaxe/lighthouse e corrigir:
- Botões de filtro precisam de `aria-expanded`
- Carrossel precisa de `aria-roledescription`
- Ícones decorativos precisam de `aria-hidden="true"`

---

### 🟢 **MÉDIOS - SEO e Marketing**

#### 6.16. OG Tags Dinâmicas
**Problema**: `ProductDetail.tsx` usa `Helmet` mas a imagem OG pode quebrar se produto não tiver imagem.

**Solução**: Fallback mais robusto:
```typescript
const ogImage = product.image_url 
  || (product.gallery_urls?.[0] || defaultImage);
```

#### 6.17. Sitemap e robots.txt
**Problema**: `public/robots.txt` existe mas não há sitemap dinâmico.

**Solução**: Criar rota `/sitemap.xml` que gera sitemap dinâmico de produtos ativos.

#### 6.18. Structured Data (Schema.org)
**Problema**: Não há JSON-LD para produtos.

**Solução**: Adicionar em `ProductDetail.tsx`:
```typescript
<script type="application/ld+json">
{JSON.stringify({
  "@context": "https://schema.org/",
  "@type": "Product",
  "name": product.title,
  "image": product.image_url,
  "description": plainDescription,
  "offers": {
    "@type": "Offer",
    "price": product.price,
    "priceCurrency": "BRL",
    "availability": "https://schema.org/InStock"
  }
})}
</script>
```

---

### 🟢 **BAIXOS - Infraestrutura**

#### 6.19. Monitoramento e Logs
**Problema**: Não há sistema de logs ou monitoramento de erros (Sentry, LogRocket).

**Solução**: Adicionar Sentry:
```typescript
import * as Sentry from "@sentry/react";
Sentry.init({ dsn: import.meta.env.VITE_SENTRY_DSN });
```

#### 6.20. Testes
**Problema**: Apenas 1 arquivo de teste (`example.test.ts`). Cobertura quase zero.

**Solução**: Implementar testes:
- Unitários: hooks puros (useFilter, usePagination)
- Integração: componentes simples (ProductCard)
- E2E: fluxos críticos (login, busca, checkout)

#### 6.21. Environment Variables
**Problema**: `.env` existe mas não há `.env.example` documentado.

**Solução**: Criar `.env.example`:
```
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_PUBLISHABLE_KEY=your_anon_key
VITE_SITE_URL=https://ofertashop.com.br
VITE_OG_PROXY_URL=/functions/v1/og-proxy
```

#### 6.22. CI/CD
**Problema**: Sem configuração de GitHub Actions/GitLab CI.

**Solução**: Adicionar `.github/workflows/ci.yml`:
- Lint
- Testes
- Build
- Deploy preview (Vercel/Netlify)

---

## 7. FUNCIONALIDADES FALTANTES (Oportunidades)

### 7.1. **PWA (Progressive Web App)**
- Service Worker para cache offline
- Manifest para instalação
- Push notifications para promoções

### 7.2. **Sistema de Alertas de Preço**
- Usuários podem configurar alertas de preço
- Notificação por email quando preço cair

### 7.3. **Comparador de Preços Avançado**
- Gráfico comparativo entre plataformas
- Histórico de preço por loja

### 7.4. **API Pública**
- Endpoint para parceiros consultarem ofertas
- Webhooks para atualizações

### 7.5. **Importação Automática**
- Conectores automáticos para Shopee/ML APIs
- Sincronização periódica de ofertas

### 7.6. **Sistema de Afiliados**
- Dashboard de comissões
- Tracking de conversões

### 7.7. **Multi-idioma**
- i18n para inglês/espanhol
- Tradução de conteúdo

### 7.8. **Dark Mode Aprimorado**
- Transição suave
- Preferência do sistema

---

## 8. PLANO DE AÇÃO PRIORIZADO

### FASE 1: Críticos de Performance e Segurança (1-2 semanas)

**Prioridade 1 - Segurança:**
1. ✅ Revisar e habilitar RLS em todas as tabelas
2. ✅ Implementar validação com Zod em formulários
3. ✅ Auditoria de variáveis de ambiente
4. ✅ Adicionar rate limiting (se disponível no Supabase)

**Prioridade 2 - Performance:**
5. ✅ Implementar paginação server-side
6. ✅ Otimizar queries com joins (reduzir N+1)
7. ✅ Ajustar staleTime do React Query por tipo
8. ✅ Implementar infinite scroll ou virtualização se necessário

**Prioridade 3 - Código:**
9. ✅ Refatorar ProductDetail (dividir em componentes)
10. ✅ Separar useEntities em módulos menores
11. ✅ Corrigir tipos `any` (criar tipos para views)
12. ✅ Padronizar tratamento de erros

---

### FASE 2: Melhorias UX/UI e SEO (2-3 semanas)

**Prioridade 1 - UX:**
1. ✅ Melhorar feedback visual (loading states)
2. ✅ Contador de filtros ativos no mobile
3. ✅ Validação de formulários com react-hook-form
4. ✅ Melhorar acessibilidade (ARIA labels)

**Prioridade 2 - SEO:**
5. ✅ Adicionar structured data (Schema.org)
6. ✅ Gerar sitemap dinâmico
7. ✅ Otimizar OG images (usar og-proxy)
8. ✅ Melhorar meta descriptions

**Prioridade 3 - UI:**
9. ✅ Skeleton components mais elaborados
10. ✅ Animações de entrada consistentes
11. ✅ Responsividade em telas muito pequenas

---

### FASE 3: Infraestrutura e Monitoramento (1-2 semanas)

1. ✅ Configurar Sentry para error tracking
2. ✅ Adicionar analytics (Google Analytics/Plausible)
3. ✅ Implementar testes básicos (80%+ cobertura)
4. ✅ Configurar CI/CD
5. ✅ Documentar API com Swagger/OpenAPI (se houver API própria)
6. ✅ Criar .env.example documentado

---

### FASE 4: Funcionalidades Avançadas (3-4 semanas)

1. ⚠️ Sistema de alertas de preço
2. ⚠️ Comparador de preços entre plataformas
3. ⚠️ PWA (service worker, manifest)
4. ⚠️ Dashboard de afiliados
5. ⚠️ Importação automática via APIs
6. ⚠️ Multi-idioma (i18n)

---

## 9. MÉTRICAS DE SUCESSO

Após implementações:

### Performance
- ⚡ LCP < 2.5s
- ⚡ FCP < 1.5s
- ⚡ TTI < 3.5s
- 📦 Bundle size < 500KB gzip

### Qualidade
- 🧪 Cobertura de testes > 80%
- 🐛 Zero erros críticos no Sentry
- ♿ Acessibilidade: WCAG AA

### SEO
- 📈 Score Lighthouse > 90
- 🗺️ Sitemap indexado
- ✅ Structured data validado

### Segurança
- 🔒 RLS ativo em 100% das tabelas
- ✅ Validação em 100% dos inputs
- 🔐 Chaves de API never exposed

---

## 10. CONCLUSÃO

O **OfertaShop** é um projeto **extremamente bem estruturado** e com **funcionalidades avançadas** para um agregador de ofertas. A arquitetura é moderna, o código está bem organizado e há uma visão clara de produto.

**Pontos de atenção imediatos:**
1. **Segurança**: RLS e validação precisam de atenção urgente
2. **Performance**: Paginação client-side não escala
3. **Manutenibilidade**: Componentes muito grandes precisam ser refatorados

**Potencial de crescimento**: O projeto tem base sólida para escalar para milhões de produtos e usuários, bastando implementar as melhorias sugeridas.

**Recomendação**: Começar pela **Fase 1** (segurança + performance) antes de lançar em produção com volume significativo.

---

**Próximos passos sugeridos:**
1. Aprovar este plano
2. Criar issues no GitHub com cada tarefa
3. Atribuir prioridades e prazos
4. Implementar em squads (frontend/backend)
5. Testar em staging
6. Deploy em produção com monitoramento
