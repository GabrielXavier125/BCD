-- Geração de Modelo físico
-- Sql ANSI 2003 - brModelo.



CREATE TABLE Cliente (
ID_Cliente Int not null auto_increment PRIMARY KEY,
Endereco_Cliete varchar (150),
Telefone_Cliente varchar (20),
CPF_Cliente varchar (14),
Nome_Cliente varchar (100),
Email_Cliente varchar (100),
ID_Veiculo Int not null auto_increment
)

CREATE TABLE Veiculo (
ID_Veiculo Int not null auto_increment PRIMARY KEY,
Cor_Veiculo varchar (30),
Placa_Veiculo varchar (10),
Ano_Veiculo smallint,
Modelo_Veiculo varchar (60),
ID_OS Int not null auto_incremnt
)

CREATE TABLE Mecanico (
ID_Mecanico Int not null auto_increment PRIMARY KEY,
Nome_Mecanico varchar (100),
Especialidade_Mecanico varchar (80)
)

CREATE TABLE Servico (
ID_Servico Int not null auto_increment PRIMARY KEY,
Descricao_Servico varchar (200),
Valor_Servico decimal (10,2)
)

CREATE TABLE Peca (
ID_Peca Int not null auto_increment PRIMARY KEY,
Descricao_Peca varchar (100),
Valor_Peca decimal (10,2),
Estoque_Peca int
)

CREATE TABLE Ordem_De_Servico (
ID_OS Int not null auto_incremnt PRIMARY KEY,
Data_Abertura date not null,
Data_Fechamento date,
Observacoes_OS varchar (500),
Status_OS varchar (20)
)

CREATE TABLE Responsavel (
ID_Mecanico Int not null auto_increment,
ID_OS Int not null auto_incremnt,
FOREIGN KEY(ID_Mecanico) REFERENCES Mecanico (ID_Mecanico),
FOREIGN KEY(ID_OS) REFERENCES Ordem_De_Servico (ID_OS)
)

CREATE TABLE Inclui (
ID_OS Int not null auto_incremnt,
ID_Servico Int not null auto_increment,
FOREIGN KEY(ID_OS) REFERENCES Ordem_De_Servico (ID_OS),
FOREIGN KEY(ID_Servico) REFERENCES Servico (ID_Servico)
)

CREATE TABLE Utiliza (
ID_Peca Int not null auto_increment,
ID_OS Int not null auto_incremnt,
FOREIGN KEY(ID_Peca) REFERENCES Peca (ID_Peca)/*falha: chave estrangeira*/
)

ALTER TABLE Cliente ADD FOREIGN KEY(ID_Veiculo) REFERENCES Veiculo (ID_Veiculo)
ALTER TABLE Veiculo ADD FOREIGN KEY(ID_OS) REFERENCES Ordem_De_Servico (ID_OS)
