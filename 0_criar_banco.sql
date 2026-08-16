-- 1. Remocao preventiva de tabelas (Idempotencia)
DROP TABLE IF EXISTS silver_trecho CASCADE;
DROP TABLE IF EXISTS silver_pagamento CASCADE;
DROP TABLE IF EXISTS silver_passagem CASCADE;
DROP TABLE IF EXISTS silver_viagem CASCADE;

DROP TABLE IF EXISTS raw_trecho CASCADE;
DROP TABLE IF EXISTS raw_pagamento CASCADE;
DROP TABLE IF EXISTS raw_passagem CASCADE;
DROP TABLE IF EXISTS raw_viagem CASCADE;


-- 2. Camada RAW (Ingestao de dados brutos)

CREATE TABLE raw_viagem (
    id_viagem VARCHAR(50),
    orgao_solicitante TEXT,
    nome_proposto TEXT,
    cargo_proposto TEXT,pytho
    motivo_viagem TEXT,
    data_inicio VARCHAR(50),
    data_fim VARCHAR(50),
    valor_diarias VARCHAR(50),
    valor_passagens VARCHAR(50),
    valor_outros VARCHAR(50),
    valor_total VARCHAR(50),
    situacao TEXT
);

CREATE TABLE raw_passagem (
    id_passagem VARCHAR(50),
    id_viagem VARCHAR(50),
    meio_transporte TEXT,
    empresa_aerea TEXT,
    valor_passagem VARCHAR(50),
    taxa_servico VARCHAR(50),
    data_emissao VARCHAR(50)
);

CREATE TABLE raw_pagamento (
    id_pagamento VARCHAR(50),
    id_viagem VARCHAR(50),
    tipo_pagamento TEXT,
    valor_pagamento VARCHAR(50),
    data_pagamento VARCHAR(50)
);

CREATE TABLE raw_trecho (
    id_trecho VARCHAR(50),
    id_viagem VARCHAR(50),
    origem TEXT,
    destino TEXT,
    data_partida VARCHAR(50),
    data_chegada VARCHAR(50),
    meio_transporte TEXT
);


-- 3. Camada SILVER (Dados limpos, tipados e validados)

CREATE TABLE silver_viagem (
    id_viagem INT PRIMARY KEY,
    orgao_solicitante TEXT NOT NULL,
    nome_proposto TEXT NOT NULL,
    cargo_proposto TEXT,
    motivo_viagem TEXT,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    valor_diarias NUMERIC(12, 2) NOT NULL DEFAULT 0.00 CHECK (valor_diarias >= 0),
    valor_passagens NUMERIC(12, 2) NOT NULL DEFAULT 0.00 CHECK (valor_passagens >= 0),
    valor_outros NUMERIC(12, 2) NOT NULL DEFAULT 0.00 CHECK (valor_outros >= 0),
    valor_total NUMERIC(12, 2) NOT NULL DEFAULT 0.00 CHECK (valor_total >= 0),
    situacao VARCHAR(100) NOT NULL,
    CONSTRAINT chk_datas_viagem CHECK (data_fim >= data_inicio)
);

CREATE TABLE silver_passagem (
    id_passagem INT PRIMARY KEY,
    id_viagem INT NOT NULL REFERENCES silver_viagem(id_viagem) ON DELETE CASCADE,
    meio_transporte VARCHAR(100) NOT NULL,
    empresa_aerea VARCHAR(150),
    valor_passagem NUMERIC(12, 2) NOT NULL DEFAULT 0.00 CHECK (valor_passagem >= 0),
    taxa_servico NUMERIC(12, 2) DEFAULT 0.00 CHECK (taxa_servico >= 0),
    data_emissao DATE NOT NULL
);

CREATE TABLE silver_pagamento (
    id_pagamento INT PRIMARY KEY,
    id_viagem INT NOT NULL REFERENCES silver_viagem(id_viagem) ON DELETE CASCADE,
    tipo_pagamento VARCHAR(100) NOT NULL,
    valor_pagamento NUMERIC(12, 2) NOT NULL DEFAULT 0.00 CHECK (valor_pagamento >= 0),
    data_pagamento DATE NOT NULL
);

CREATE TABLE silver_trecho (
    id_trecho INT PRIMARY KEY,
    id_viagem INT NOT NULL REFERENCES silver_viagem(id_viagem) ON DELETE CASCADE,
    origem VARCHAR(150) NOT NULL,
    destino VARCHAR(150) NOT NULL,
    data_partida DATE NOT NULL,
    data_chegada DATE NOT NULL,
    meio_transporte VARCHAR(100) NOT NULL,
    CONSTRAINT chk_datas_trecho CHECK (data_chegada >= data_partida)
);


-- 4. Indices para otimizacao de buscas

CREATE INDEX idx_passagem_viagem ON silver_passagem(id_viagem);
CREATE INDEX idx_pagamento_viagem ON silver_pagamento(id_viagem);
CREATE INDEX idx_trecho_viagem ON silver_trecho(id_viagem);