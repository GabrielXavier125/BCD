-- Modelo Físico Corrigido
-- SQL ANSI 2003
-- Cria um banco de dados chamado "livraria"
CREATE DATABASE livraria;

-- Usa o banco de dados "livraria"
USE livraria;  -- No MySQL

-- Tabela de Editoras
CREATE TABLE editoras (
    nome_editora VARCHAR(255) NOT NULL PRIMARY KEY,
    cnpj VARCHAR(18),
    contato VARCHAR(255),
    telefone VARCHAR(15),
    endereco VARCHAR(255),
    cidade VARCHAR(100)
);

-- Tabela de Autores
CREATE TABLE autores (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255),
    data_nascimento DATE,
    nacionalidade VARCHAR(100)
);

-- Tabela de Clientes
CREATE TABLE clientes (
    cpf_cliente VARCHAR(14) NOT NULL PRIMARY KEY,
    nome_cliente VARCHAR(100),
    email VARCHAR(100),
    telefone VARCHAR(15),
    data_nascimento_cliente DATE
);

-- Tabela de Livros
CREATE TABLE livros (
    id_livro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200),
    genero VARCHAR(100),
    preco DECIMAL(10,2),
    quantidade INT,
    nome_editora VARCHAR(255) NOT NULL,
    id_autor INT NOT NULL,
    FOREIGN KEY (nome_editora) REFERENCES editoras(nome_editora),
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor)
);

-- Tabela de Vendas
CREATE TABLE vendas (
    id_venda INT PRIMARY KEY,
    data_venda DATE,
    quantidade_venda INT,
    valor_total DECIMAL(10,2),
    cpf_cliente VARCHAR(14) NOT NULL,
    FOREIGN KEY (cpf_cliente) REFERENCES clientes(cpf_cliente)
);

-- Tabela de Itens da Venda (relação entre livros e vendas)
CREATE TABLE itens_venda (
    id_venda INT NOT NULL,
    id_livro INT NOT NULL,
    quantidade INT,
    preco_unitario DECIMAL(10,2),
    PRIMARY KEY (id_venda, id_livro),
    FOREIGN KEY (id_venda) REFERENCES vendas(id_venda),
    FOREIGN KEY (id_livro) REFERENCES livros(id_livro)
);
