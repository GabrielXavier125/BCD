create database limpeza;

use limpeza;

CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    email_cliente VARCHAR(100),
    endereco_cliente VARCHAR(150),
    telefone_cliente VARCHAR(20),
    nome_cliente VARCHAR(100)
);

CREATE TABLE Produtos (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    categoria_produto VARCHAR(50),
    estoque_produto INT,
    preco_produto DECIMAL(10,2),
    nome_produto VARCHAR(100)
);

CREATE TABLE Vendas (
    id_venda INT PRIMARY KEY AUTO_INCREMENT,
    data_venda DATE,
    forma_pagamento VARCHAR(20),
    valor_total DECIMAL(10,2),
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE Processos (
    id_processo INT PRIMARY KEY AUTO_INCREMENT,
    data_inicio_processo DATE,
    quantidade_produzida INT,
    data_fim_manutencao DATE,
    id_produto INT,
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

CREATE TABLE Manutencao (
    id_manutencao INT PRIMARY KEY AUTO_INCREMENT,
    data_inicio_manutencao DATE,
    data_fim_manutencao DATE,
    custo DECIMAL(10,2),
    id_processo INT,
    FOREIGN KEY (id_processo) REFERENCES Processos(id_processo)
);
