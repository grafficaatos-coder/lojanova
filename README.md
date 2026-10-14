# LojaNova

Plataforma própria de lojas virtuais, em construção.

## Versão atual
Demonstração visual: apresentação, painel de módulos e vitrine ilustrativa.

**Não está pronta para vendas reais.** Ainda faltam autenticação, banco de dados multiempresa, cadastro de produtos, estoque, pedidos, checkout e pagamentos.

## Módulos planejados
Loja virtual, catálogo, produtos, pedidos, clientes, checkout, frete, marketing (cupons, carrinho abandonado, upsell, order bump, cashback), relatórios, integrações, equipes, planos e painel do proprietário.

## Executar
`npm install` e `npm run dev`.

### Segurança
Não incorporar chaves secretas no frontend. Antes do lançamento, implementar autorização por loja, RLS no Supabase, idempotência de pagamentos e validação de webhooks.
