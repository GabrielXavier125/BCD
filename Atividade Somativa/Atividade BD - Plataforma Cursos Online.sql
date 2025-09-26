-- Geração de Modelo físico
-- Sql ANSI 2003 - brModelo.

CREATE DATABASE PlataformaCursos;
USE PlataformaCursos;

-- Tabela Alunos
CREATE TABLE Alunos (
    ID_Aluno INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Email_Aluno VARCHAR(100),
    Data_Nascimento DATE NOT NULL,
    Nome_Aluno VARCHAR(100) NOT NULL
);

-- Tabela Cursos
CREATE TABLE Cursos (
    ID_Curso INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Titulo_Curso VARCHAR(100),
    Descricao_Curso VARCHAR(100),
    Carga_Horaria INT,
    Status_Curso BOOLEAN 
);

-- Tabela Inscrições
CREATE TABLE Inscricoes (
    ID_Inscricao INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_Aluno INT NOT NULL,
    ID_Curso INT NOT NULL,
    Data_Inscricao DATE NOT NULL,
    FOREIGN KEY (ID_Aluno) REFERENCES Alunos(ID_Aluno),
    FOREIGN KEY (ID_Curso) REFERENCES Cursos(ID_Curso)
);

-- Tabela Avaliações
CREATE TABLE Avaliacoes (
    ID_Avaliacao INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_Inscricao INT NOT NULL,
    Nota_Avaliacao FLOAT,
    Comentario_Avaliacao VARCHAR(100),
    FOREIGN KEY (ID_Inscricao) REFERENCES Inscricoes(ID_Inscricao)
);

-- Inserir 5 alunos
INSERT INTO Alunos (Nome_Aluno, Email_Aluno, Data_Nascimento) VALUES
('João Silva', 'joao.silva@email.com', '1995-06-15'),
('Maria Oliveira', 'maria.oliveira@email.com', '1992-11-22'),
('Carlos Souza', 'carlos.souza@email.com', '2000-05-30'),
('Ana Costa', 'ana.costa@email.com', '1998-07-12'),
('Pedro Lima', 'pedro.lima@email.com', '1997-03-03');

-- Inserir 5 cursos (um com status 'inativo')
INSERT INTO Cursos (Titulo_Curso, Descricao_Curso, Carga_Horaria, Status_Curso) VALUES
('Curso de Java', 'Curso básico de programação em Java', 40, '1'),
('Curso de Python', 'Introdução à programação com Python', 30, '1'),
('Curso de Banco de Dados', 'Fundamentos de bancos de dados relacionais', 60, '1'),
('Curso de Web Development', 'Desenvolvimento web com HTML, CSS, JS', 45, '1'),
('Curso de Cloud Computing', 'Introdução ao uso de cloud computing', 50, '0');  -- curso inativo

-- Inserir 5 inscrições
INSERT INTO Inscricoes (ID_Aluno, ID_Curso, Data_Inscricao) VALUES
(1, 1, '2024-01-15'),
(2, 2, '2024-02-20'),
(3, 3, '2024-03-10'),
(4, 4, '2024-04-05'),
(5, 5, '2024-05-25');

-- Inserir 3 avaliações
INSERT INTO Avaliacoes (ID_Inscricao, Nota_Avaliacao, Comentario_Avaliacao) VALUES
(1, 9.5, 'Excelente curso, muito bom!'),
(2, 8.0, 'Bom curso, mas poderia ser mais prático.'),
(3, 9.0, 'Curso bem completo, aprendi bastante.');

-- Update do e-mail de Aluno
UPDATE Alunos
SET Email_Aluno = 'joao.silva2025@email.com'
WHERE ID_Aluno = 1;

-- Update carga horaria do Curso
UPDATE Cursos
SET Carga_Horaria = 35
WHERE ID_Curso = 2;

-- Update Nome de Aluno
UPDATE Alunos
SET Nome_Aluno = 'Carlos A. Souza'
WHERE ID_Aluno = 3;

-- Update Status de Curso
UPDATE Cursos
SET Status_Curso = 1
WHERE ID_Curso = 5;

-- Update nota de Avaliação
UPDATE Avaliacoes
SET Nota_Avaliacao = 8.5
WHERE ID_Avaliacao = 2;

-- Excluir avaliações relacionadas às inscrições de cursos inativos
DELETE a FROM Avaliacoes a
JOIN Inscricoes i ON a.ID_Inscricao = i.ID_Inscricao
JOIN Cursos c ON i.ID_Curso = c.ID_Curso
WHERE c.Status_Curso = 0;

-- Excluir inscrições relacionadas a cursos inativos
DELETE i FROM Inscricoes i
JOIN Cursos c ON i.ID_Curso = c.ID_Curso
WHERE c.Status_Curso = 0;

-- Excluir os cursos inativos (se desejar)
DELETE FROM Cursos
WHERE Status_Curso = 0;

-- Listar todos os alunos cadastrados
SELECT * FROM Alunos;

-- Exibir apenas os nomes e e-mails dos alunos
SELECT Nome_Aluno, Email_Aluno FROM Alunos;

-- Listar cursos com carga horária maior que 30 horas
SELECT * FROM Cursos
WHERE Carga_Horaria > 30;

-- Exibir cursos que estão inativos (Status_Curso = 0)
SELECT * FROM Cursos
WHERE Status_Curso = 0;

-- Buscar alunos nascidos após o ano 1995
SELECT * FROM Alunos
WHERE Data_Nascimento > '1995-12-31';

-- Exibir avaliações com nota acima de 9
SELECT * FROM Avaliacoes
WHERE Nota_Avaliacao > 9;

-- Contar quantos cursos estão cadastrados
SELECT COUNT(*) AS Total_Cursos FROM Cursos;

-- Listar os 3 cursos com maior carga horária
SELECT * FROM Cursos
ORDER BY Carga_Horaria DESC
LIMIT 3;

-- Criar índice para busca rápida por email de aluno
CREATE INDEX idx_email_aluno ON Alunos(Email_Aluno);
