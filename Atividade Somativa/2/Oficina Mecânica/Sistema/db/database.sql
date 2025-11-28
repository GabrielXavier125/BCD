-- Script de criação do banco de dados OFICINA (MySQL)
DROP DATABASE IF EXISTS oficina;
CREATE DATABASE oficina
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE oficina;

-- TABELAS

CREATE TABLE clientes (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome       VARCHAR(100) NOT NULL,
  telefone   VARCHAR(20),
  email      VARCHAR(100),
  cpf        VARCHAR(14),
  endereco   VARCHAR(150)
) ENGINE=InnoDB;

CREATE TABLE veiculos (
  id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  placa      VARCHAR(10) NOT NULL UNIQUE,
  modelo     VARCHAR(60) NOT NULL,
  ano        SMALLINT,
  cor        VARCHAR(30),
  CONSTRAINT fk_veiculo_cliente
    FOREIGN KEY (id_cliente)
    REFERENCES clientes (id_cliente)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE mecanicos (
  id_mecanico  INT AUTO_INCREMENT PRIMARY KEY,
  nome         VARCHAR(100) NOT NULL,
  especialidade VARCHAR(80)
) ENGINE=InnoDB;

CREATE TABLE servicos (
  id_servico INT AUTO_INCREMENT PRIMARY KEY,
  descricao  VARCHAR(100) NOT NULL,
  valor      DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE pecas (
  id_peca   INT AUTO_INCREMENT PRIMARY KEY,
  descricao VARCHAR(100) NOT NULL,
  valor     DECIMAL(10,2) NOT NULL,
  estoque   INT NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE ordens_servico (
  id_os           INT AUTO_INCREMENT PRIMARY KEY,
  id_veiculo      INT NOT NULL,
  data_abertura   DATE NOT NULL,
  data_fechamento DATE NULL,
  status          ENUM('ABERTA','EM_ANDAMENTO','CONCLUIDA','CANCELADA')
                  DEFAULT 'ABERTA',
  observacoes     TEXT,
  CONSTRAINT fk_os_veiculo
    FOREIGN KEY (id_veiculo)
    REFERENCES veiculos (id_veiculo)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE os_mecanicos (
  id_os       INT NOT NULL,
  id_mecanico INT NOT NULL,
  PRIMARY KEY (id_os, id_mecanico),
  CONSTRAINT fk_osm_os
    FOREIGN KEY (id_os)
    REFERENCES ordens_servico (id_os)
    ON DELETE CASCADE,
  CONSTRAINT fk_osm_mecanico
    FOREIGN KEY (id_mecanico)
    REFERENCES mecanicos (id_mecanico)
    ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE os_servicos (
  id_os        INT NOT NULL,
  id_servico   INT NOT NULL,
  quantidade   INT NOT NULL,
  valor_unitario DECIMAL(10,2) NOT NULL,
  subtotal     DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id_os, id_servico),
  CONSTRAINT fk_oss_os
    FOREIGN KEY (id_os)
    REFERENCES ordens_servico (id_os)
    ON DELETE CASCADE,
  CONSTRAINT fk_oss_servico
    FOREIGN KEY (id_servico)
    REFERENCES servicos (id_servico)
    ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE os_pecas (
  id_os        INT NOT NULL,
  id_peca      INT NOT NULL,
  quantidade   INT NOT NULL,
  valor_unitario DECIMAL(10,2) NOT NULL,
  subtotal     DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id_os, id_peca),
  CONSTRAINT fk_osp_os
    FOREIGN KEY (id_os)
    REFERENCES ordens_servico (id_os)
    ON DELETE CASCADE,
  CONSTRAINT fk_osp_peca
    FOREIGN KEY (id_peca)
    REFERENCES pecas (id_peca)
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- DADOS DE EXEMPLO

INSERT INTO clientes (id_cliente, nome, telefone, email, cpf, endereco) VALUES
(1, 'João Silva',   '(11) 98888-0001', 'joao.silva@mail.com',   '123.456.789-01', 'Rua A, 100'),
(2, 'Maria Souza',  '(11) 97777-0002', 'maria.souza@mail.com',  '987.654.321-00', 'Rua B, 200'),
(3, 'Carlos Lima',  '(11) 96666-0003', 'carlos.lima@mail.com',  '111.222.333-44', 'Av. Central, 300');

INSERT INTO veiculos (id_veiculo, id_cliente, placa, modelo, ano, cor) VALUES
(1, 1, 'ABC1D23', 'Fiat Uno',      2012, 'Prata'),
(2, 1, 'EFG4H56', 'VW Gol',        2017, 'Branco'),
(3, 2, 'IJK7L89', 'Honda Civic',   2020, 'Preto'),
(4, 3, 'MNO0P12', 'Chevrolet Onix',2019, 'Vermelho');

INSERT INTO mecanicos (id_mecanico, nome, especialidade) VALUES
(1, 'Pedro Mecânico',  'Suspensão'),
(2, 'Ana Torres',      'Elétrica'),
(3, 'Roberto Santos',  'Motor');

INSERT INTO servicos (id_servico, descricao, valor) VALUES
(1, 'Troca de óleo',          120.00),
(2, 'Alinhamento e balanceamento', 150.00),
(3, 'Revisão elétrica',       200.00),
(4, 'Limpeza de bicos',       180.00);

INSERT INTO pecas (id_peca, descricao, valor, estoque) VALUES
(1, 'Filtro de óleo',        35.00, 50),
(2, 'Pastilha de freio',     120.00, 20),
(3, 'Velas de ignição (jogo)', 90.00, 30),
(4, 'Bateria 60Ah',          350.00, 10);

INSERT INTO ordens_servico
(id_os, id_veiculo, data_abertura, data_fechamento, status, observacoes)
VALUES
(1, 1, '2025-11-10', '2025-11-10', 'CONCLUIDA', 'Troca de óleo e verificação geral.'),
(2, 3, '2025-11-11', NULL,          'EM_ANDAMENTO', 'Cliente relatou barulho na suspensão.'),
(3, 4, '2025-11-12', NULL,          'ABERTA', 'Agendada revisão elétrica completa.');

INSERT INTO os_mecanicos (id_os, id_mecanico) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 3),
(3, 2);

INSERT INTO os_servicos
(id_os, id_servico, quantidade, valor_unitario, subtotal) VALUES
(1, 1, 1, 120.00, 120.00),
(1, 2, 1, 150.00, 150.00),
(2, 2, 1, 150.00, 150.00),
(2, 4, 1, 180.00, 180.00),
(3, 3, 1, 200.00, 200.00);

INSERT INTO os_pecas
(id_os, id_peca, quantidade, valor_unitario, subtotal) VALUES
(1, 1, 1, 35.00, 35.00),
(2, 2, 1, 120.00, 120.00),
(2, 3, 1, 90.00, 90.00),
(3, 4, 1, 350.00, 350.00);
