# LojaNova

SaaS de lojas virtuais em desenvolvimento.

## Implementado no código
- Demonstração pública da LojaNova e painel planejado.
- /gestao: autenticação por e-mail/senha (Supabase Auth), criação de lojas e cadastro/exclusão de produtos.
- /loja/[slug]: vitrine pública alimentada pelo banco.
- Estrutura SQL com isolamento por proprietário via RLS: lojas, produtos, clientes, pedidos, itens.

## Ativação obrigatória
1. Criar **novo projeto Supabase exclusivamente para LojaNova**. Nunca usar projetos de outro sistema.
2. Executar SQL em supabase/migrations/20261014_initial_commerce.sql.
3. Configurar NEXT_PUBLIC_SUPABASE_URL e NEXT_PUBLIC_SUPABASE_ANON_KEY na Vercel (Production/Preview) e reimplantar.
4. Configurar URLs de autenticação e confirmação de e-mail no Supabase.
5. Testar cadastro de dois lojistas distintos e confirmar que cada um vê apenas seus dados.

## Não está pronto para pagamentos
Pedidos, clientes e order_items têm somente política de leitura dos proprietários. Não habilitar escrita pelo cliente até implementar checkout com backend seguro, validação de valores, reserva transacional de estoque, gateway homologado, webhooks validados, idempotência e testes.
