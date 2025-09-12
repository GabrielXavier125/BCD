-- Geração de Modelo físico
-- Sql ANSI 2003 - brModelo.

CREATE DATABASE Empresa_Solar;
USE Empresa_Solar;
SELECT DATABASE();

CREATE TABLE Clientes (
ID_Cliente int primary key auto_increment not null PRIMARY KEY,
Nome_Cliente varchar(100)
);

CREATE TABLE Produtos (
ID_Produto int primary key auto_increment not null PRIMARY KEY,
Nome_Produto varchar(100)
);

CREATE TABLE Compra (
ID_Compra int auto_increment PRIMARY KEY not null,
ID_Produto int,
ID_CLiente int,
FOREIGN KEY(ID_Produto) REFERENCES Produtos (ID_Produto),
FOREIGN KEY(ID_Cliente) REFERENCES Clientes (ID_Cliente)
);

CREATE TABLE VENDEDOR (
ID_Vendedor INT AUTO_INCREMENT PRIMARY KEY,
Nome_Vendedor varchar(100),
Salario DECIMAL(7,2),
fsalarial char(1)
);

INSERT INTO CLIENTES (Nome_Cliente) VALUES ('Gabriel');
INSERT INTO PRODUTOS VALUES (2, 'Teclado');
INSERT INTO VENDEDOR (Nome_Vendedor, Salario, fsalarial) VALUES ('Vendedor1', 1000,1);
INSERT INTO VENDEDOR (Nome_Vendedor, Salario, fsalarial) VALUES ('Vendedor2', 1200,1);

UPDATE PRODUTOS SET Nome_Produto = 'Mouse'
WHERE ID_Produto = 2;

SELECT * FROM cliente;

-- AUTORIZAR UPDATE --
SET SQL_SAFE_UPDATES = 0;