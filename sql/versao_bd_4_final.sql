-- ======================================================
-- PROJETO: STUDIO PATTY LEÃO
-- EQUIPE: CSDI STRATEGY (DSM 3º SEMESTRE)
-- DATA ATUALIZADA: 23/03/2026
-- ======================================================
-- NOME DOS INTEGRANTES:

--  Aluno 1: Max Wesley Reis de Godoy
--  Aluno 2: Maycon Lima Teixeira Cavalcante
--  Aluno 3: Luca Simões Dagostinoca 
--  Aluno 4: Alexandre Gianneff Loureiro Alves
--  Aluno 5: Daniel Henrique Leão de Oliveira
--  Aluno 6: Leonardo Monteiro dos Santos
-- ======================================================

DROP DATABASE IF EXISTS studio_patty_leao;
CREATE DATABASE studio_patty_leao;
USE studio_patty_leao;

-- 1. USUARIOS (Controle de Acesso Centralizado)
CREATE TABLE usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  cpf VARCHAR(14) NOT NULL UNIQUE,
  senha_hash VARCHAR(255) NOT NULL,
  tipo_perfil ENUM('ADMIN','CLIENTE', 'PROFISSIONAL') DEFAULT 'CLIENTE',
  flg_ativo TINYINT(1) DEFAULT 1 COMMENT '1 = Ativo, 0 = Inativo'
);

-- 2. ADMIN (Gestão com permissões específicas)
CREATE TABLE admin (
  id_admin INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL,
  nome VARCHAR(60) NOT NULL,
  nivel_permissao ENUM('SUPER_ADMIN', 'GERENTE_ESTOQUE', 'RECEPCAO', 'FINANCEIRO') DEFAULT 'RECEPCAO',
  CONSTRAINT fk_admin_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- 3. CLIENTES
CREATE TABLE cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NULL, --  Permite cliente sem login, atendimento via balcão
  nome VARCHAR(100) NOT NULL,
  telefone VARCHAR(20),
  flg_alergico TINYINT(1) DEFAULT 0 COMMENT '1 = Possui alergias, 0 = Não possui',
  detalhes_alergia TEXT,
  CONSTRAINT fk_cliente_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- 4. PROFISSIONAIS
CREATE TABLE profissional (
  id_profissional INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL,
  nome VARCHAR(100) NOT NULL,
  especialidade VARCHAR(100),
  telefone VARCHAR(20),
  flg_ativo TINYINT(1) DEFAULT 1,
  CONSTRAINT fk_prof_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- 5. FORNECEDORES
CREATE TABLE fornecedor (
  id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
  razao_social VARCHAR(100) NOT NULL,
  cnpj VARCHAR(18) UNIQUE,
  telefone VARCHAR(20),
  email VARCHAR(100),
  cidade VARCHAR(50),
  estado CHAR(2)
);

-- 6. PRODUTOS (Insumos e Venda)
CREATE TABLE produto (
  id_produto INT AUTO_INCREMENT PRIMARY KEY,
  sku VARCHAR(50) UNIQUE,
  descricao VARCHAR(150) NOT NULL,
  custo_unitario DECIMAL(10,2) NOT NULL,
  preco_venda DECIMAL(10,2) NOT NULL,
  unidade_medida VARCHAR(10) DEFAULT 'un',
  flg_insumo TINYINT(1) DEFAULT 1 COMMENT '1 = Usado em serviços, 0 = Apenas venda',
  flg_venda TINYINT(1) DEFAULT 0 COMMENT '1 = Disponível para venda direta, 0 = Uso interno'
);

-- 7. SERVICOS
CREATE TABLE servicos (
  id_servico INT AUTO_INCREMENT PRIMARY KEY,
  nome_servico VARCHAR(100) NOT NULL,
  descricao_servico TEXT,
  preco_servico DECIMAL(10,2) NOT NULL,
  duracao_estimada_min INT NOT NULL COMMENT 'Duração em minutos para cálculo de agenda'
);

-- 8. ESTOQUE
CREATE TABLE estoque (
  id_estoque INT AUTO_INCREMENT PRIMARY KEY,
  id_produto INT NOT NULL,
  quantidade_atual DECIMAL(10,3) DEFAULT 0.000,
  quantidade_minima DECIMAL(10,3) DEFAULT 0.000,
  CONSTRAINT fk_estoque_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

-- 9. TIPO DE PAGAMENTO
CREATE TABLE tipo_pagto (
  id_tipo_pagto INT AUTO_INCREMENT PRIMARY KEY,
  nome_metodo VARCHAR(50) NOT NULL,
  taxa_operadora DECIMAL(5,2) DEFAULT 0.00
);

-- 10. AGENDAMENTO (Cabeçalho)
CREATE TABLE agendamento (
  id_agendamento INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  data_hora_inicio DATETIME NOT NULL,
  status_agendamento ENUM('Agendado','Em Atendimento','Concluido','Cancelado') DEFAULT 'Agendado',
  CONSTRAINT fk_agendamento_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- 11. ITENS DO AGENDAMENTO (Serviços e Profissionais)
CREATE TABLE agendamento_itens (
  id_item INT AUTO_INCREMENT PRIMARY KEY,
  id_agendamento INT NOT NULL,
  id_servico INT NOT NULL,
  id_profissional INT NOT NULL,
  valor_cobrado DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_item_agendamento FOREIGN KEY (id_agendamento) REFERENCES agendamento(id_agendamento),
  CONSTRAINT fk_item_servico FOREIGN KEY (id_servico) REFERENCES servicos(id_servico),
  CONSTRAINT fk_item_profissional FOREIGN KEY (id_profissional) REFERENCES profissional(id_profissional)
);

-- 12. VENDA DIRETA (Venda de balcão sem agendamento)
CREATE TABLE venda (
  id_venda INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NULL COMMENT 'Opcional para vendas rápidas sem cadastro de cliente',
  data_hora_venda DATETIME DEFAULT CURRENT_TIMESTAMP,
  valor_total_venda DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_venda_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- 13. ITENS DA VENDA DIRETA
CREATE TABLE venda_itens (
  id_item_venda INT AUTO_INCREMENT PRIMARY KEY,
  id_venda INT NOT NULL,
  id_produto INT NOT NULL,
  quantidade DECIMAL(10,3) NOT NULL,
  preco_unitario_venda DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_itens_venda FOREIGN KEY (id_venda) REFERENCES venda(id_venda),
  CONSTRAINT fk_itens_produto_venda FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

-- 14. PEDIDO DE COMPRA (Entrada de Insumos/Estoque - B2B)
CREATE TABLE pedido_compra (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  id_fornecedor INT NOT NULL,
  data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
  status_pedido ENUM('Pendente', 'Recebido', 'Cancelado') DEFAULT 'Pendente',
  valor_total_pedido DECIMAL(10,2) DEFAULT 0.00,
  CONSTRAINT fk_pedido_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor)
);

-- 15. ITENS DO PEDIDO DE COMPRA
CREATE TABLE pedido_compra_itens (
  id_item_pedido INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_produto INT NOT NULL,
  quantidade DECIMAL(10,3) NOT NULL,
  custo_unitario DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_itens_pedido FOREIGN KEY (id_pedido) REFERENCES pedido_compra(id_pedido),
  CONSTRAINT fk_itens_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

-- 16. CAIXA (Financeiro Unificado)
CREATE TABLE caixa (
  id_movimento INT AUTO_INCREMENT PRIMARY KEY,
  id_agendamento INT NULL COMMENT 'Preencher se for serviço',
  id_venda INT NULL COMMENT 'Preencher se for venda direta',
  id_tipo_pagto INT NOT NULL,
  tipo_movimentacao ENUM('ENTRADA','SAIDA') NOT NULL,
  valor_movimentado DECIMAL(10,2) NOT NULL,
  data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_caixa_agendamento FOREIGN KEY (id_agendamento) REFERENCES agendamento(id_agendamento),
  CONSTRAINT fk_caixa_venda FOREIGN KEY (id_venda) REFERENCES venda(id_venda),
  CONSTRAINT fk_caixa_tipo_pagto FOREIGN KEY (id_tipo_pagto) REFERENCES tipo_pagto(id_tipo_pagto)
);

-- 17. NOTA FISCAL
CREATE TABLE nf (
  id_nf INT AUTO_INCREMENT PRIMARY KEY,
  id_movimento INT NOT NULL,
  numero_nota VARCHAR(20) NOT NULL,
  chave_acesso VARCHAR(44),
  CONSTRAINT fk_nf_caixa FOREIGN KEY (id_movimento) REFERENCES caixa(id_movimento)
);

-- ======================================================
--  B.I (BUSINESS INTELLIGENCE) VERIFICAÇÃO DE DISPONIBILIDADE DO PROFISSIONAL
-- ======================================================
DELIMITER //

CREATE TRIGGER tg_verificar_conflito_profissional
BEFORE INSERT ON agendamento_itens
FOR EACH ROW
BEGIN
    DECLARE v_inicio DATETIME;
    DECLARE v_duracao INT;
    DECLARE v_fim DATETIME;
    DECLARE v_conflitos INT;

    SELECT data_hora_inicio INTO v_inicio 
    FROM agendamento 
    WHERE id_agendamento = NEW.id_agendamento;

    SELECT duracao_estimada_min INTO v_duracao 
    FROM servicos 
    WHERE id_servico = NEW.id_servico;

    SET v_fim = DATE_ADD(v_inicio, INTERVAL v_duracao MINUTE);

    SELECT COUNT(*) INTO v_conflitos
    FROM agendamento_itens ai
    JOIN agendamento a ON ai.id_agendamento = a.id_agendamento
    JOIN servicos s ON ai.id_servico = s.id_servico
    WHERE ai.id_profissional = NEW.id_profissional
      AND a.status_agendamento IN ('Agendado', 'Em Atendimento')
      AND v_inicio < DATE_ADD(a.data_hora_inicio, INTERVAL s.duracao_estimada_min MINUTE)
      AND v_fim > a.data_hora_inicio;

    IF v_conflitos > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'O profissional selecionado já possui um atendimento neste horário.';
    END IF;
END;
//

-- ======================================================
-- AUTOMAÇÃO (VIEWS E PROCEDURES)
-- ======================================================

-- VIEW: AGENDA DO DIA (Facilita a busca do PHP/Front-end)
CREATE VIEW vw_agenda_do_dia AS
SELECT 
    a.id_agendamento,
    a.data_hora_inicio,
    c.nome AS nome_cliente,
    c.telefone AS telefone_cliente,
    s.nome_servico,
    p.nome AS nome_profissional,
    a.status_agendamento,
    ai.valor_cobrado
FROM agendamento a
JOIN cliente c ON a.id_cliente = c.id_cliente
JOIN agendamento_itens ai ON a.id_agendamento = ai.id_agendamento
JOIN servicos s ON ai.id_servico = s.id_servico
JOIN profissional p ON ai.id_profissional = p.id_profissional;

-- PROCEDURE: FINALIZAR ATENDIMENTO (SERVIÇOS + PRODUTOS RESERVADOS)
CREATE PROCEDURE sp_finalizar_atendimento(
    IN p_id_agendamento INT,
    IN p_id_tipo_pagto INT
)
BEGIN
    DECLARE v_valor_total DECIMAL(10,2);
    
    SELECT SUM(valor_cobrado) INTO v_valor_total
    FROM agendamento_itens
    WHERE id_agendamento = p_id_agendamento;
    
    UPDATE agendamento
    SET status_agendamento = 'Concluido'
    WHERE id_agendamento = p_id_agendamento;
    
    INSERT INTO caixa (id_agendamento, id_tipo_pagto, tipo_movimentacao, valor_movimentado)
    VALUES (p_id_agendamento, p_id_tipo_pagto, 'ENTRADA', v_valor_total);
END;
//

-- PROCEDURE: FINALIZAR VENDA DIRETA (BALCÃO / VITRINE)
CREATE PROCEDURE sp_finalizar_venda_direta(
    IN p_id_venda INT,
    IN p_id_tipo_pagto INT
)
BEGIN
    DECLARE v_valor_venda DECIMAL(10,2);
    
    SELECT valor_total_venda INTO v_valor_venda
    FROM venda
    WHERE id_venda = p_id_venda;
    
    INSERT INTO caixa (id_venda, id_tipo_pagto, tipo_movimentacao, valor_movimentado)
    VALUES (p_id_venda, p_id_tipo_pagto, 'ENTRADA', v_valor_venda);
END;
//

DELIMITER ;