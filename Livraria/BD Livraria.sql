CREATE DATABASE Livraria;
USE Livraria;

-- Tabela Autores
CREATE TABLE Autores (
    ID_autor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    nacionalidade VARCHAR(150),
    data_nasc_autor DATE
);

-- Tabela Editoras
CREATE TABLE Editoras (
    ID_editora INT AUTO_INCREMENT PRIMARY KEY,
    nome_editora VARCHAR(150) NOT NULL,
    endereco VARCHAR(150),
    contato VARCHAR(150),
    telefone VARCHAR(20),
    cidade VARCHAR(150),
    cnpj VARCHAR(20) UNIQUE
);

-- Tabela Clientes
CREATE TABLE Clientes (
    ID_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome_cliente VARCHAR(150) NOT NULL,
    cpf VARCHAR(25) UNIQUE NOT NULL,
    email VARCHAR(150),
    telefone VARCHAR(20),
    data_nasc_cliente DATE
);

-- Tabela Livros
CREATE TABLE Livros (
    ID_livro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    genero VARCHAR(150),
    preco DECIMAL(10,2) NOT NULL,
    quantidade INT DEFAULT 0,
    ID_autor INT,    
    ID_editora INT,
    FOREIGN KEY (ID_autor) REFERENCES Autores(ID_autor),
    FOREIGN KEY (ID_editora) REFERENCES Editoras(ID_editora)
);

-- Tabela Vendas (aqui cada venda está ligada a 1 cliente e 1 livro)
CREATE TABLE Vendas (
    ID_venda INT AUTO_INCREMENT PRIMARY KEY,
    data_venda DATE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    ID_cliente INT,
    ID_livro INT,
    FOREIGN KEY (ID_cliente) REFERENCES Clientes(ID_cliente),
    FOREIGN KEY (ID_livro) REFERENCES Livros(ID_livro)
);



------ Insert ------
-- Autores
-- Autores
INSERT INTO Autores (nome, nacionalidade, data_nasc_autor)
VALUES
('Carlos Ruiz Zafón', 'Espanhol', '1964-09-25'),
('Isaac Asimov', 'Americano', '1920-01-02'),
('Clarice Lispector', 'Brasileira', '1920-12-10');

-- Editoras
INSERT INTO Editoras (nome_editora, endereco, contato, telefone, cidade, cnpj)
VALUES
('Intrínseca', 'Rua do Livro, 100', 'Julia Martins', '2132323222', 'Rio de Janeiro', '23.456.789/0001-00'),
('Aleph', 'Rua da Ciência, 500', 'Marcos Almeida', '21987654321', 'São Paulo', '12.345.678/0001-99'),
('Editora Record', 'Av. da Cultura, 1500', 'Patricia Oliveira', '1133344556', 'São Paulo', '34.567.890/0001-11');

-- Clientes
INSERT INTO Clientes (nome_cliente, cpf, email, telefone, data_nasc_cliente)
VALUES
('Pedro Souza', '987.654.321-11', 'pedro@email.com', '2196667777', '1987-03-14'),
('Juliana Pereira', '321.654.987-00', 'juliana@email.com', '21988889999', '1993-11-21'),
('Felipe Almeida', '741.852.963-22', 'felipe@email.com', '11997778888', '2002-07-05');

-- Livros
INSERT INTO Livros (titulo, genero, preco, quantidade, ID_autor, ID_editora)
VALUES
('O Jogo do Anjo', 'Suspense', 49.90, 120, 1, 1),
('Fundação', 'Ficção Científica', 89.00, 90, 2, 2),
('A Hora da Estrela', 'Drama', 45.00, 110, 3, 3),
('O Nome da Rosa', 'Mistério', 72.90, 75, 1, 1);

-- Vendas (1 cliente comprando 1 livro por vez)
INSERT INTO Vendas (data_venda, valor_total, ID_cliente, ID_livro)
VALUES
('2025-10-01', 49.90, 1, 1), -- Pedro comprou O Jogo do Anjo
('2025-10-02', 89.00, 2, 2), -- Juliana comprou Fundação
('2025-10-03', 45.00, 3, 3); -- Felipe comprou A Hora da Estrela

START TRANSACTION;
UPDATE LIVROS
SET quantidade = quantidade - 2
WHERE id_livro = 3;

COMMIT;

select * from livros