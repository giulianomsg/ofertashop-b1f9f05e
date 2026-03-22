# Mercado Livre Scraping Integration

Este guia documenta o processo de manutenção da integração do Mercado Livre utilizando o proxy **ScrapingBee** e parsing de HTML via **Cheerio**.

## Como Funciona
A atual busca do ML (`ml-search-products`) não utiliza a API oficial restritiva, mas sim uma raspagem de dados (web scraping) na página de resultados oficial do ML (`https://lista.mercadolivre.com.br/`). Para evitar bloqueios de IP e resolver desafios de extração, utilizamos o **ScrapingBee**.

Arquivos principais afetados:
- \`supabase/functions/ml-search-products/index.ts\`: Realiza a busca paginada com ScrapingBee.
- \`supabase/functions/ml-import-product/index.ts\`: Recupera detalhes adicionais do produto e os salva no DB utilizando validação Zod e `upsert`.
- \`AdminMercadoLivre.tsx\`: Interface de front-end.

## Passos de Manutenção

### 1. Atualizar Seletores de Scraping (`ml-search-products`)
Caso o Mercado Livre mude a estrutura do HTML de resposta, alguns campos deixarão de ser salvos. Para corrigir:
1. Acesse o arquivo `supabase/functions/ml-search-products/index.ts`.
2. Localize o trecho com a variável `$` (`cheerio.load(html)`).
3. Atualize os clássicos seletores. Hoje, são tipicamente parecidos com:
   - Wrapper: `.ui-search-layout__item`
   - Título: `.ui-search-item__title`
   - Preço (Fração): `.price-tag-fraction` e `.price-tag-cents`
   - Link: `.ui-search-link`
   - Imagem: `img.ui-search-result-image__element`

### 2. Testar o Scraper
Você pode executar o arquivo de testes unitários para certificar que seus novos seletores recuperam a informação de um HTML mockado sem gastar créditos do ScrapingBee:
```bash
deno test --allow-all scraper.test.ts
```

### 3. Ajuste de Taxas e Limites (ScrapingBee)
Se observar os logs acusando `ScrapingBee API Key inválida ou limite excedido` (código HTTP 403), isso indica que os créditos Premium da conta esgotaram.
No código, utilizamos a flag `premium_proxy="true"` para garantir que as buscas não sejam bloqueadas. O ScrapingBee executa rotação de proxy e cabeçalhos User-Agent a cada requisição automaticamente.
Em caso constante de falhas de proxy estressados (HTTP 500 no SB), o script conta com **Retry Exponencial e Backoff**, tentando no máximo 3 vezes com esperas de 1s, 2s e 4s.

### 4. Importação e Validação Zod (`ml-import-product`)
Ao clicar em importar, a função `ml-import-product` valida a estrutura do produto utilizando um schema do pacote estrito do **Zod**.
Quaisquer atualizações dos dados recebidos no front-end em AdminMercadoLivre devem ter seus correspondentes modificados nesse arquivo `index.ts`, especificamente nas constantes `ItemSchema` e `RequestSchema`. Além disso o salvamento usa Upsert com a cláusula de conflito `ml_item_id` da base de dados local para impedir duplicatas independentes de delay de rede.
