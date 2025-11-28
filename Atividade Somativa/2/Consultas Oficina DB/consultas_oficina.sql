-- Consultas SELECT para Oficina Mecânica

-- 1. Veículos da marca Ford
SELECT * FROM Veiculos WHERE marca = 'Ford';

-- 2. Clientes com OS nos últimos 6 meses
SELECT DISTINCT c.*
FROM Clientes c
JOIN Veiculos v ON v.id_cliente = c.id_cliente
JOIN Ordem_Servico os ON os.id_veiculo = v.id_veiculo
WHERE os.data_abertura >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- 3. Mecânicos com especialidade Injeção Eletrônica
SELECT * FROM Mecanicos WHERE especialidade = 'Injeção Eletrônica';

-- 4. OS com status Aguardando Peça
SELECT * FROM Ordem_Servico WHERE status = 'Aguardando Peça';

-- 5. Peças com estoque abaixo de 5
SELECT * FROM Pecas WHERE qtd_estoque < 5;

-- 6. Veículos que tiveram mais de uma OS
SELECT v.*
FROM Veiculos v
WHERE (
    SELECT COUNT(*)
    FROM Ordem_Servico os
    WHERE os.id_veiculo = v.id_veiculo
) > 1;

-- 7. OS executadas por mecânico específico
SELECT DISTINCT os.*
FROM Ordem_Servico os
JOIN OS_Mecanicos osm ON osm.id_os = os.id_os
WHERE osm.id_mecanico = 3;

-- 8. DESAFIO: peças com preco_custo > 200
SELECT descricao, preco_venda
FROM Pecas
WHERE preco_custo > 200.00;
