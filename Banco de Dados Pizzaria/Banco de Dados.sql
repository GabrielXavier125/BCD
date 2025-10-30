create table pizza (
id_pizza int primary key,
preço char (5),
sabor_pizza char (20),
ingredientes char (50)
);

create table cliente (
cpf char (11),
nome_cliente char (50),
endereço char (70),
pedido char (100)
);

create table funcionario (
id_funcionario int primary key,
nome_funcionario char (50),
cpf char (11),
cargo char (20)
);