-- 0. Limpeza preventiva das tabelas antigas
DROP TABLE IF EXISTS silver.silver_trecho CASCADE;
DROP TABLE IF EXISTS silver.silver_passagem CASCADE;
DROP TABLE IF EXISTS silver.silver_pagamento CASCADE;
DROP TABLE IF EXISTS silver.silver_viagem CASCADE;

DROP TABLE IF EXISTS raw.raw_trecho CASCADE;
DROP TABLE IF EXISTS raw.raw_passagem CASCADE;
DROP TABLE IF EXISTS raw.raw_pagamento CASCADE;
DROP TABLE IF EXISTS raw.raw_viagem CASCADE;

-- 1. Criação dos Schemas
CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS silver;

-- 2. Camada RAW
CREATE TABLE raw.raw_viagem (
    id_viagem VARCHAR,
    num_proposta VARCHAR,
    situacao VARCHAR,
    viagem_urgente VARCHAR,
    cod_orgao_superior VARCHAR,
    nome_orgao_superior VARCHAR,
    nome_viajante VARCHAR,
    cargo VARCHAR,
    data_inicio VARCHAR,
    data_fim VARCHAR,
    destinos VARCHAR,
    motivo VARCHAR,
    valor_diarias VARCHAR,
    valor_passagens VARCHAR,
    valor_devolucao VARCHAR,
    valor_outros_gastos VARCHAR,
    cpf_viajante VARCHAR,
    funcao VARCHAR
);

CREATE TABLE raw.raw_passagem (
    id_viagem VARCHAR,
    meio_transporte VARCHAR,
    pais_origem_ida VARCHAR,
    uf_origem_ida VARCHAR,
    cidade_origem_ida VARCHAR,
    pais_destino_ida VARCHAR,
    uf_destino_ida VARCHAR,
    cidade_destino_ida VARCHAR,
    valor_passagem VARCHAR,
    taxa_servico VARCHAR,
    data_emissao VARCHAR,
    dados_volta VARCHAR
);

CREATE TABLE raw.raw_pagamento (
    id_viagem VARCHAR,
    num_proposta VARCHAR,
    nome_orgao_pagador VARCHAR,
    nome_ug_pagadora VARCHAR,
    tipo_pagamento VARCHAR,
    valor VARCHAR
);

CREATE TABLE raw.raw_trecho (
    id_viagem VARCHAR,
    sequencia_trecho VARCHAR,
    origem_data VARCHAR,
    origem_uf VARCHAR,
    origem_cidade VARCHAR,
    destino_data VARCHAR,
    destino_uf VARCHAR,
    destino_cidade VARCHAR,
    meio_transporte VARCHAR,
    numero_diarias VARCHAR
);

-- 3. Camada SILVER
CREATE TABLE silver.silver_viagem (
    id_viagem VARCHAR(20) PRIMARY KEY NOT NULL,
    num_proposta VARCHAR(20),
    situacao VARCHAR(50),
    viagem_urgente VARCHAR(5),
    cod_orgao_superior VARCHAR(20),
    nome_orgao_superior VARCHAR(255) NOT NULL,
    nome_viajante VARCHAR(255),
    cargo VARCHAR(255),
    data_inicio DATE,
    data_fim DATE,
    destinos VARCHAR(4000),
    motivo VARCHAR(4000),
    valor_diarias DECIMAL(10,2) CHECK (valor_diarias >= 0),
    valor_passagens DECIMAL(10,2),
    valor_devolucao DECIMAL(10,2),
    valor_outros_gastos DECIMAL(10,2),
    valor_total DECIMAL(12,2),
    duracao_dias INT
);

CREATE TABLE silver.silver_pagamento (
    id_pagamento SERIAL PRIMARY KEY,
    id_viagem VARCHAR(20) NOT NULL,
    num_proposta VARCHAR(20),
    nome_orgao_pagador VARCHAR(255),
    nome_ug_pagadora VARCHAR(255),
    tipo_pagamento VARCHAR(50) NOT NULL,
    valor DECIMAL(10,2) CHECK (valor >= 0),
    CONSTRAINT fk_viagem_pagamento FOREIGN KEY (id_viagem) REFERENCES silver.silver_viagem(id_viagem)
);

CREATE TABLE silver.silver_passagem (
    id_passagem SERIAL PRIMARY KEY,
    id_viagem VARCHAR(20) NOT NULL,
    meio_transporte VARCHAR(50),
    pais_origem_ida VARCHAR(60),
    uf_origem_ida VARCHAR(40),
    cidade_origem_ida VARCHAR(80),
    pais_destino_ida VARCHAR(60),
    uf_destino_ida VARCHAR(40),
    cidade_destino_ida VARCHAR(80),
    valor_passagem DECIMAL(10,2) CHECK (valor_passagem >= 0),
    taxa_servico DECIMAL(10,2) CHECK (taxa_servico >= 0),
    data_emissao DATE,
    CONSTRAINT fk_viagem_passagem FOREIGN KEY (id_viagem) REFERENCES silver.silver_viagem(id_viagem)
);

CREATE TABLE silver.silver_trecho (
    id_trecho SERIAL PRIMARY KEY,
    id_viagem VARCHAR(20) NOT NULL,
    sequencia_trecho INT,
    origem_data DATE,
    origem_uf VARCHAR(40),
    origem_cidade VARCHAR(80),
    destino_data DATE,
    destino_uf VARCHAR(40),
    destino_cidade VARCHAR(80),
    meio_transporte VARCHAR(50),
    numero_diarias DECIMAL(10,2) CHECK (numero_diarias >= 0),
    CONSTRAINT fk_viagem_trecho FOREIGN KEY (id_viagem) REFERENCES silver.silver_viagem(id_viagem),
    CONSTRAINT unique_viagem_sequencia UNIQUE (id_viagem, sequencia_trecho)
);