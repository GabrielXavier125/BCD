use solar;
create table if not exists CLIENTES (
COD_CLIENTES int not null,
NOME_CLIENTE varchar(100) not null,
CPF varchar(14) not null,
ENDERECO varchar(100),
CELULAR varchar(19),
primary key (COD_CLIENTES)
);

create table if not exists PRODUTO (
COD_PRODUTO int not null,
NOME_PRODUTO varchar(100) not null,
VALOR decimal(5,2) not null,
DESCRICAO varchar(200),
QUANTIDADE int not null,
primary key (COD_PRODUTO)
);

create table if not exists FORNECEDOR (
ID_FORNECEDOR int not null,
NOME_FORNECEDOR varchar(100) not null,
CNPJ varchar(18) not null,
ENDERECO varchar(100),
TELEFONE varchar(20) not null,
CIDADE varchar(100),
ESTADO varchar(2),
primary key (ID_FORNECEDOR)
);

create table VENDA (
COD_VENDA int primary key auto_increment not null,
COD_PRODUTO int not null,
COD_FORNECEDOR int not null,
foreign key (COD_PRODUTO) references PRODUTO (COD_PRODUTO),
foreign key (COD_FORNECEDOR) references FORNECEDOR (ID_FORNECEDOR)
);

create table FUNCIONARIO (
COD_FUNCIONARIO int primary key auto_increment not null,
NOME_FUNCIONARIO varchar(100) not null,
CARGO_FUNCIONARIO varchar(20),
CPF_FUNCIONARIO varchar(14) not null,
DATA_NASCIMENTO_FUNCIONARIO datetime,
COD_DEPARTAMENTO int not null,
foreign key (COD_DEPARTAMENTO) references DEPARTAMENTO (COD_DEPARTAMENTO)
);

create table DEPARTAMENTO (
COD_DEPARTAMENTO int auto_increment not null,
NOME_DEPARTAMENTO varchar(20) not null,
RESPONSAVEL varchar(100) not null,
SETOR varchar(50) not null,
primary key (COD_DEPARTAMENTO)
);

create table TIPO_PRODUTO (
COD_TIPO_PRODUTO int auto_increment primary key,
TIPO_PRODUTO varchar(255) not null,
index (COD_TIPO_PRODUTO)
);

alter table FUNCIONARIO
rename to EMPREGADO;

alter table EMPREGADO
change CPF_FUNCIONARIO CIC_FUNCIONARIO varchar(18);

alter table EMPREGADO
modify column NOME_FUNCIONARIO varchar(200);

alter table FORNECEDOR
modify column ESTADO char(2) default 'MG';

alter table EMPREGADO
add primary key (CPF_FUNCIONARIO);

alter table EMPREGADO modify CPF_FUNCIONARIO int not null;
alter table EMPREGADO drop primary key;

alter table EMPREGADO
add primary key (COD_FUNCIONARIO,CPF_FUNCIONARIO);

create table TIPO_PRODUTOS 
COD_TIPO_PRODUTOS int auto_increment primary key not null;