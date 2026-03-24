-- ======================================================
-- PROJETO: STUDIO PATTY LEÃO
-- EQUIPE: CSDI STRATEGY (DSM 3º SEMESTRE)
-- DATA: 17/03/2026
-- ======================================================

DROP DATABASE IF EXISTS studio_patty_leao;
CREATE DATABASE studio_patty_leao;
USE studio_patty_leao;

-- 1. USUARIOS (Controle de Acesso)
CREATE TABLE usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  login_cpf VARCHAR(14) NOT NULL UNIQUE,
  senha_hash VARCHAR(255) NOT NULL,
  tipo_perfil ENUM('ADMIN','CLIENTE', 'PROFISSIONAL') DEFAULT 'CLIENTE',
  flg_ativo BOOLEAN DEFAULT 1
);

-- 2. CLIENTES
CREATE TABLE cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NULL,
  nome VARCHAR(100) NOT NULL,
  telefone VARCHAR(20),
  email VARCHAR(100),
  flg_alergico BOOLEAN DEFAULT 0,
  detalhes_alergia TEXT,
  CONSTRAINT fk_cliente_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- 3. PROFISSIONAIS (Pessoas que executam os serviços)
CREATE TABLE profissional (
  id_profissional INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NULL,
  nome VARCHAR(100) NOT NULL,
  especialidade VARCHAR(100),
  telefone VARCHAR(20),
  flg_ativo BOOLEAN DEFAULT 1
  -- Nota: A dona do salão deve ser cadastrada aqui para aparecer no agendamento.
);

-- 4. FORNECEDORES
CREATE TABLE fornecedor (
  id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
  razao_social VARCHAR(100) NOT NULL,
  cnpj VARCHAR(18) UNIQUE,
  telefone VARCHAR(20),
  email VARCHAR(100),
  logradouro VARCHAR(150),
  numero VARCHAR(10),
  bairro VARCHAR(50),
  cidade VARCHAR(50),
  estado CHAR(2),
  cep VARCHAR(9)
);

-- 5. PRODUTOS E INSUMOS
CREATE TABLE produto (
  id_produto INT AUTO_INCREMENT PRIMARY KEY,
  sku VARCHAR(50) UNIQUE,
  descricao VARCHAR(150) NOT NULL,
  custo_unitario DECIMAL(10,2) NOT NULL,
  preco_venda DECIMAL(10,2),
  unidade_medida VARCHAR(10) DEFAULT 'un',
  flg_insumo BOOLEAN DEFAULT 1,
  flg_venda BOOLEAN DEFAULT 0
);

-- 6. SERVICOS (Catálogo de serviços do salão)
CREATE TABLE servicos (
  id_servico INT AUTO_INCREMENT PRIMARY KEY,
  nome_servico VARCHAR(100) NOT NULL,
  descricao_servico TEXT,
  preco_servico DECIMAL(10,2) NOT NULL,
  duracao_estimada_min INT NOT NULL
);

-- 7. ESTOQUE (Controle de quantidades)
CREATE TABLE estoque (
  id_estoque INT AUTO_INCREMENT PRIMARY KEY,
  id_produto INT NOT NULL,
  quantidade_atual DECIMAL(10,3) DEFAULT 0.000,
  quantidade_minima DECIMAL(10,3) DEFAULT 0.000,
  quantidade_maxima DECIMAL(10,3) DEFAULT 0.000,
  CONSTRAINT fk_estoque_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

-- 8. TIPO DE PAGAMENTO
CREATE TABLE tipo_pagto (
  id_tipo_pagto INT AUTO_INCREMENT PRIMARY KEY,
  nome_metodo VARCHAR(50) NOT NULL,
  taxa_operadora DECIMAL(5,2) DEFAULT 0.00
);

-- 9. AGENDAMENTO (Cabeçalho)
CREATE TABLE agendamento (
  id_agendamento INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  data_hora_inicio DATETIME NOT NULL,
  status_agendamento ENUM('Agendado','Em Atendimento','Concluido','Cancelado') DEFAULT 'Agendado',
  CONSTRAINT fk_agendamento_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- 10. ITENS DO AGENDAMENTO (Serviços e Profissionais escolhidos)
CREATE TABLE agendamento_itens (
  id_item INT AUTO_INCREMENT PRIMARY KEY,
  id_agendamento INT NOT NULL,
  id_servico INT,
  id_produto INT, -- Para venda de produtos casada com serviço
  id_profissional INT NOT NULL,
  valor_cobrado DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_item_agendamento FOREIGN KEY (id_agendamento) REFERENCES agendamento(id_agendamento),
  CONSTRAINT fk_item_servico FOREIGN KEY (id_servico) REFERENCES servicos(id_servico),
  CONSTRAINT fk_item_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
  CONSTRAINT fk_item_profissional FOREIGN KEY (id_profissional) REFERENCES profissional(id_profissional)
);

-- 11. PEDIDO DE COMPRA (Entrada de Insumos)
CREATE TABLE pedido_compra (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  id_fornecedor INT NOT NULL,
  data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
  status_pedido ENUM('Pendente', 'Recebido', 'Cancelado') DEFAULT 'Pendente',
  valor_total_pedido DECIMAL(10,2) DEFAULT 0.00,
  CONSTRAINT fk_pedido_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor)
);

-- 12. ITENS DO PEDIDO DE COMPRA
CREATE TABLE pedido_compra_itens (
  id_item_pedido INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_produto INT NOT NULL,
  quantidade DECIMAL(10,3) NOT NULL,
  custo_unitario DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_itens_pedido FOREIGN KEY (id_pedido) REFERENCES pedido_compra(id_pedido),
  CONSTRAINT fk_itens_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

-- 13. CAIXA (Financeiro)
CREATE TABLE caixa (
  id_movimento INT AUTO_INCREMENT PRIMARY KEY,
  id_agendamento INT NULL,
  id_tipo_pagto INT NOT NULL,
  tipo_movimentacao ENUM('ENTRADA','SAIDA') NOT NULL,
  valor_movimentado DECIMAL(10,2) NOT NULL,
  data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_caixa_agendamento FOREIGN KEY (id_agendamento) REFERENCES agendamento(id_agendamento),
  CONSTRAINT fk_caixa_tipo_pagto FOREIGN KEY (id_tipo_pagto) REFERENCES tipo_pagto(id_tipo_pagto)
);

-- 14. NOTA FISCAL (NF)
CREATE TABLE nf (
  id_nf INT AUTO_INCREMENT PRIMARY KEY,
  id_movimento INT NOT NULL,
  numero_nota VARCHAR(20) NOT NULL,
  chave_acesso VARCHAR(44),
  status_emissao VARCHAR(50),
  CONSTRAINT fk_nf_caixa FOREIGN KEY (id_movimento) REFERENCES caixa(id_movimento)
);