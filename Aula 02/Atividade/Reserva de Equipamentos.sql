use reserva;
CREATE TABLE Usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    cpf VARCHAR(11)
);

CREATE TABLE Equipamento (
    id_equipamento INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    quantidade INT NOT NULL,
    status ENUM('disponível', 'reservado', 'manutenção') DEFAULT 'disponível'
);

CREATE TABLE Reserva (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_equipamento INT NOT NULL,
    data_reserva DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_retirada DATETIME,
    data_devolucao DATETIME,
    status_reserva ENUM('ativa', 'concluída', 'cancelada') DEFAULT 'ativa',
    
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_equipamento) REFERENCES Equipamento(id_equipamento)
);
