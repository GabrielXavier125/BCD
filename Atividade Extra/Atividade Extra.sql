-- Criação do banco de dados
CREATE DATABASE REMOTERC;
USE REMOTERC;

-- Criação da tabela PRODUTOS
CREATE TABLE PRODUTOS (
    CProd INT PRIMARY KEY,
    Descricao VARCHAR(100),
    Peso VARCHAR(10),
    ValorUnit DECIMAL(10, 2)
);

-- Inserção de dados na tabela PRODUTOS
INSERT INTO PRODUTOS (CProd, Descricao, Peso, ValorUnit) VALUES
(1, 'Teclado', 'KG', 35.00),
(2, 'Mouse', 'KG', 25.00),
(3, 'HD', 'KG', 350.00);

-- Criação da tabela VENDEDOR
CREATE TABLE VENDEDOR (
    CVend INT PRIMARY KEY,
    Nome VARCHAR(100),
    Salario DECIMAL(10, 2),
    FSalario INT
);

-- Inserção de dados na tabela VENDEDOR
INSERT INTO VENDEDOR (CVend, Nome, Salario, FSalario) VALUES
(1, 'Ronaldo', 3512.00, 1),
(2, 'Robertson', 3225.00, 2),
(3, 'Clodoaldo', 4350.00, 3);

-- Criação da tabela CLIENTE
CREATE TABLE CLIENTE (
    CCli INT PRIMARY KEY,
    Nome VARCHAR(100),
    Endereco VARCHAR(150),
    Cidade VARCHAR(100),
    UF CHAR(2)
);

-- Inserção de dados na tabela CLIENTE
INSERT INTO CLIENTE (CCli, Nome, Endereco, Cidade, UF) VALUES
(11, 'Bruno', 'Rua 1 456', 'Rio Claro', 'SP'),
(12, 'Cláudio', 'Rua Quadrada 234', 'Campinas', 'SP'),
(13, 'Cremilda', 'Rua das Flores 66', 'São Paulo', 'SP');
