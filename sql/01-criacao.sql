CREATE DATABASE IF NOT EXISTS hotel_nebula
  CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE hotel_nebula;

CREATE TABLE hospedes (
    id_hospede INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    cpf VARCHAR(14) UNIQUE,
    telefone VARCHAR(20),
    data_nascimento DATE,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE quartos (
    id_quarto INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(10) NOT NULL UNIQUE,
    tipo VARCHAR(50) NOT NULL,
    capacidade INT NOT NULL CHECK (capacidade > 0),
    preco_diaria DECIMAL(10,2) NOT NULL CHECK (preco_diaria > 0),
    status VARCHAR(20) NOT NULL DEFAULT 'operacional'
        CHECK (status IN ('operacional','manutencao','inativo')),
    andar INT NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE reservas (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_hospede INT NOT NULL,
    id_quarto INT NOT NULL,
    data_checkin DATE NOT NULL,
    data_checkout DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'confirmada'
        CHECK (status IN ('confirmada','cancelada','concluida')),
    quantidade_hospedes INT NOT NULL DEFAULT 1 CHECK (quantidade_hospedes > 0),
    diaria_contratada DECIMAL(10,2) NOT NULL CHECK (diaria_contratada > 0),
    criada_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cancelada_em DATETIME,
    FOREIGN KEY (id_hospede) REFERENCES hospedes(id_hospede),
    FOREIGN KEY (id_quarto) REFERENCES quartos(id_quarto),
    CHECK (data_checkout > data_checkin),
    CHECK ((status = 'cancelada') = (cancelada_em IS NOT NULL)),
    INDEX idx_reserva_periodo (id_quarto, status, data_checkin, data_checkout)
) ENGINE=InnoDB;

CREATE TABLE hospedagens (
    id_hospedagem INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva INT NOT NULL UNIQUE,
    checkin_real DATETIME NOT NULL,
    checkout_real DATETIME,
    observacoes VARCHAR(255),
    FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva),
    CHECK (checkout_real IS NULL OR checkout_real > checkin_real)
) ENGINE=InnoDB;

CREATE TABLE pagamentos (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_hospedagem INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL CHECK (valor > 0),
    metodo VARCHAR(30) NOT NULL CHECK (metodo IN ('pix','credito','debito','dinheiro')),
    status VARCHAR(20) NOT NULL DEFAULT 'pendente'
        CHECK (status IN ('pendente','confirmado','cancelado')),
    pago_em DATETIME,
    FOREIGN KEY (id_hospedagem) REFERENCES hospedagens(id_hospedagem),
    CHECK ((status = 'confirmado') = (pago_em IS NOT NULL)),
    INDEX idx_pagamento_faturamento (status, pago_em)
) ENGINE=InnoDB;

CREATE TABLE funcionarios (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    data_admissao DATE NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE CHECK (ativo IN (0,1))
) ENGINE=InnoDB;

CREATE TABLE servicos (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao VARCHAR(255),
    preco_atual DECIMAL(10,2) NOT NULL CHECK (preco_atual >= 0),
    ativo BOOLEAN NOT NULL DEFAULT TRUE CHECK (ativo IN (0,1))
) ENGINE=InnoDB;

CREATE TABLE consumos_servicos (
    id_consumo INT AUTO_INCREMENT PRIMARY KEY,
    id_hospedagem INT NOT NULL,
    id_servico INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario >= 0),
    consumido_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_hospedagem) REFERENCES hospedagens(id_hospedagem),
    FOREIGN KEY (id_servico) REFERENCES servicos(id_servico)
) ENGINE=InnoDB;

CREATE TABLE atendimentos (
    id_hospedagem INT NOT NULL,
    id_funcionario INT NOT NULL,
    atendido_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_hospedagem, id_funcionario),
    FOREIGN KEY (id_hospedagem) REFERENCES hospedagens(id_hospedagem),
    FOREIGN KEY (id_funcionario) REFERENCES funcionarios(id_funcionario)
) ENGINE=InnoDB;

CREATE TABLE feedbacks (
    id_feedback INT AUTO_INCREMENT PRIMARY KEY,
    id_hospedagem INT NOT NULL UNIQUE,
    nota INT NOT NULL CHECK (nota BETWEEN 1 AND 5),
    comentario VARCHAR(1000),
    avaliado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_hospedagem) REFERENCES hospedagens(id_hospedagem)
) ENGINE=InnoDB;
