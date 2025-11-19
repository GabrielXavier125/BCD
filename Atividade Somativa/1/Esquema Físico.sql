-- Geração de Modelo físico
-- Sql ANSI 2003 - brModelo.

-- Tabela Alunos
CREATE TABLE Alunos (
    ID_Aluno INT NOT NULL PRIMARY KEY,
    Email_Aluno VARCHAR(100),
    Data_Nascimento DATE NOT NULL,
    Nome_Aluno VARCHAR(100) NOT NULL
);

-- Tabela Cursos
CREATE TABLE Cursos (
    ID_Curso INT NOT NULL PRIMARY KEY,
    Titulo_Curso VARCHAR(100),
    Descricao_Curso VARCHAR(100),
    Carga_Horaria INT,
    Status_Curso BOOLEAN 
);

-- Tabela Inscrições
CREATE TABLE Inscricoes (
    ID_Inscricao INT NOT NULL PRIMARY KEY,
    ID_Aluno INT NOT NULL,
    ID_Curso INT NOT NULL,
    Data_Inscricao DATE NOT NULL,
    FOREIGN KEY (ID_Aluno) REFERENCES Alunos(ID_Aluno),
    FOREIGN KEY (ID_Curso) REFERENCES Cursos(ID_Curso)
);

-- Tabela Avaliações
CREATE TABLE Avaliacoes (
    ID_Avaliacao INT NOT NULL PRIMARY KEY,
    ID_Inscricao INT NOT NULL,
    Nota_Avaliacao FLOAT,
    Comentario_Avaliacao VARCHAR(100),
    FOREIGN KEY (ID_Inscricao) REFERENCES Inscricoes(ID_Inscricao)
);


