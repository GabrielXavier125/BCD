Projeto Oficina Mecânica - Layout HTML/CSS integrado com PHP + MySQL

1) Importe o arquivo database.sql no seu MySQL (phpMyAdmin, Workbench, etc.).
   - Ele cria o banco de dados 'oficina', todas as tabelas e insere dados de exemplo.

2) Coloque todos estes arquivos em uma pasta do seu servidor PHP, por exemplo:
   - C:\xampp\htdocs\oficina
   ou
   - /var/www/html/oficina

3) Ajuste as credenciais de acesso ao banco em config.php, se necessário:
   - $DB_HOST, $DB_USER, $DB_PASS

4) Inicie o servidor (Apache/MySQL no XAMPP, WAMP, etc.).

5) Acesse no navegador:
   http://localhost/oficina/index.php

Funcionalidades:
- Dashboard com contagem de Clientes, Veículos, Mecânicos e Ordens de Serviço.
- CRUD de Clientes.
- CRUD de Veículos (vinculados a clientes).
- CRUD de Mecânicos.
- CRUD de Serviços.
- CRUD de Peças (com estoque).
- Cadastro e listagem de Ordens de Serviço (modelo simplificado:
  1 veículo, 1 mecânico opcional, 1 serviço opcional e 1 peça opcional),
  com totais calculados de serviços, peças e geral.

Layout idêntico ao painel HTML/CSS original, mas agora com backend real em PHP + MySQL.
