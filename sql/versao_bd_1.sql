-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 14/03/2026 às 22:29
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `studio_patty_leao`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `agendamento`
--

CREATE TABLE `agendamento` (
  `id_agendamento` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `data_hora` datetime NOT NULL,
  `status_agendamento` enum('Agendado','Concluido','Cancelado') DEFAULT 'Agendado'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `agendamento_itens`
--

CREATE TABLE `agendamento_itens` (
  `id_item` int(11) NOT NULL,
  `id_agendamento` int(11) DEFAULT NULL,
  `id_servico` int(11) DEFAULT NULL,
  `id_produto` int(11) DEFAULT NULL,
  `valor_cobrado` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `caixa`
--

CREATE TABLE `caixa` (
  `id_movimento` int(11) NOT NULL,
  `id_agendamento` int(11) DEFAULT NULL,
  `id_tipo_pagto` int(11) DEFAULT NULL,
  `tipo_movimentacao` enum('ENTRADA','SAIDA') DEFAULT NULL,
  `valor_movimentado` decimal(10,2) DEFAULT NULL,
  `data_hora` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `cliente`
--

CREATE TABLE `cliente` (
  `id_cliente` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `nome` varchar(100) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `flg_alergico` tinyint(1) DEFAULT 0,
  `detalhes_alergia` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `estoque`
--

CREATE TABLE `estoque` (
  `id_estoque` int(11) NOT NULL,
  `id_produto` int(11) DEFAULT NULL,
  `quantidade_atual` decimal(10,3) DEFAULT NULL,
  `quantidade_minima` decimal(10,3) DEFAULT NULL,
  `quantidade_maxima` decimal(10,3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `fornecedor`
--

CREATE TABLE `fornecedor` (
  `id_fornecedor` int(11) NOT NULL,
  `razao_social` varchar(100) NOT NULL,
  `cnpj` varchar(18) DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `nf`
--

CREATE TABLE `nf` (
  `id_nf` int(11) NOT NULL,
  `id_movimento` int(11) DEFAULT NULL,
  `numero_nota` varchar(20) DEFAULT NULL,
  `chave_acesso` varchar(44) DEFAULT NULL,
  `status_emissao` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `pedido_compra`
--

CREATE TABLE `pedido_compra` (
  `id_pedido` int(11) NOT NULL,
  `id_fornecedor` int(11) DEFAULT NULL,
  `data_pedido` datetime DEFAULT current_timestamp(),
  `valor_total_pedido` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `produto`
--

CREATE TABLE `produto` (
  `id_produto` int(11) NOT NULL,
  `sku` varchar(50) DEFAULT NULL,
  `descricao` varchar(150) NOT NULL,
  `custo_unitario` decimal(10,2) DEFAULT NULL,
  `preco_venda` decimal(10,2) DEFAULT NULL,
  `lucro_bruto_unitario` decimal(10,2) DEFAULT NULL,
  `unidade_medida` varchar(10) DEFAULT 'un',
  `flg_insumo` tinyint(1) DEFAULT 1,
  `flg_venda` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `servicos`
--

CREATE TABLE `servicos` (
  `id_servico` int(11) NOT NULL,
  `nome_servico` varchar(100) NOT NULL,
  `descricao_servico` text DEFAULT NULL,
  `preco_servico` decimal(10,2) DEFAULT NULL,
  `duracao_estimada_min` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `tipo_pagto`
--

CREATE TABLE `tipo_pagto` (
  `id_tipo_pagto` int(11) NOT NULL,
  `nome_metodo` varchar(50) NOT NULL,
  `taxa_operadora` decimal(5,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuario`
--

CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL,
  `login_cpf` varchar(14) NOT NULL,
  `senha_hash` varchar(255) NOT NULL,
  `tipo_perfil` enum('ADMIN','CLIENTE') DEFAULT 'CLIENTE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `agendamento`
--
ALTER TABLE `agendamento`
  ADD PRIMARY KEY (`id_agendamento`),
  ADD KEY `id_cliente` (`id_cliente`);

--
-- Índices de tabela `agendamento_itens`
--
ALTER TABLE `agendamento_itens`
  ADD PRIMARY KEY (`id_item`),
  ADD KEY `id_agendamento` (`id_agendamento`),
  ADD KEY `id_servico` (`id_servico`),
  ADD KEY `id_produto` (`id_produto`);

--
-- Índices de tabela `caixa`
--
ALTER TABLE `caixa`
  ADD PRIMARY KEY (`id_movimento`),
  ADD KEY `id_agendamento` (`id_agendamento`),
  ADD KEY `id_tipo_pagto` (`id_tipo_pagto`);

--
-- Índices de tabela `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`id_cliente`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Índices de tabela `estoque`
--
ALTER TABLE `estoque`
  ADD PRIMARY KEY (`id_estoque`),
  ADD KEY `id_produto` (`id_produto`);

--
-- Índices de tabela `fornecedor`
--
ALTER TABLE `fornecedor`
  ADD PRIMARY KEY (`id_fornecedor`),
  ADD UNIQUE KEY `cnpj` (`cnpj`);

--
-- Índices de tabela `nf`
--
ALTER TABLE `nf`
  ADD PRIMARY KEY (`id_nf`),
  ADD KEY `id_movimento` (`id_movimento`);

--
-- Índices de tabela `pedido_compra`
--
ALTER TABLE `pedido_compra`
  ADD PRIMARY KEY (`id_pedido`),
  ADD KEY `id_fornecedor` (`id_fornecedor`);

--
-- Índices de tabela `produto`
--
ALTER TABLE `produto`
  ADD PRIMARY KEY (`id_produto`),
  ADD UNIQUE KEY `sku` (`sku`);

--
-- Índices de tabela `servicos`
--
ALTER TABLE `servicos`
  ADD PRIMARY KEY (`id_servico`);

--
-- Índices de tabela `tipo_pagto`
--
ALTER TABLE `tipo_pagto`
  ADD PRIMARY KEY (`id_tipo_pagto`);

--
-- Índices de tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `login_cpf` (`login_cpf`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `agendamento`
--
ALTER TABLE `agendamento`
  MODIFY `id_agendamento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `agendamento_itens`
--
ALTER TABLE `agendamento_itens`
  MODIFY `id_item` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `caixa`
--
ALTER TABLE `caixa`
  MODIFY `id_movimento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `cliente`
--
ALTER TABLE `cliente`
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `estoque`
--
ALTER TABLE `estoque`
  MODIFY `id_estoque` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `fornecedor`
--
ALTER TABLE `fornecedor`
  MODIFY `id_fornecedor` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `nf`
--
ALTER TABLE `nf`
  MODIFY `id_nf` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `pedido_compra`
--
ALTER TABLE `pedido_compra`
  MODIFY `id_pedido` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `produto`
--
ALTER TABLE `produto`
  MODIFY `id_produto` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `servicos`
--
ALTER TABLE `servicos`
  MODIFY `id_servico` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `tipo_pagto`
--
ALTER TABLE `tipo_pagto`
  MODIFY `id_tipo_pagto` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `agendamento`
--
ALTER TABLE `agendamento`
  ADD CONSTRAINT `agendamento_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`);

--
-- Restrições para tabelas `agendamento_itens`
--
ALTER TABLE `agendamento_itens`
  ADD CONSTRAINT `agendamento_itens_ibfk_1` FOREIGN KEY (`id_agendamento`) REFERENCES `agendamento` (`id_agendamento`),
  ADD CONSTRAINT `agendamento_itens_ibfk_2` FOREIGN KEY (`id_servico`) REFERENCES `servicos` (`id_servico`),
  ADD CONSTRAINT `agendamento_itens_ibfk_3` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`);

--
-- Restrições para tabelas `caixa`
--
ALTER TABLE `caixa`
  ADD CONSTRAINT `caixa_ibfk_1` FOREIGN KEY (`id_agendamento`) REFERENCES `agendamento` (`id_agendamento`),
  ADD CONSTRAINT `caixa_ibfk_2` FOREIGN KEY (`id_tipo_pagto`) REFERENCES `tipo_pagto` (`id_tipo_pagto`);

--
-- Restrições para tabelas `cliente`
--
ALTER TABLE `cliente`
  ADD CONSTRAINT `cliente_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`);

--
-- Restrições para tabelas `estoque`
--
ALTER TABLE `estoque`
  ADD CONSTRAINT `estoque_ibfk_1` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`);

--
-- Restrições para tabelas `nf`
--
ALTER TABLE `nf`
  ADD CONSTRAINT `nf_ibfk_1` FOREIGN KEY (`id_movimento`) REFERENCES `caixa` (`id_movimento`);

--
-- Restrições para tabelas `pedido_compra`
--
ALTER TABLE `pedido_compra`
  ADD CONSTRAINT `pedido_compra_ibfk_1` FOREIGN KEY (`id_fornecedor`) REFERENCES `fornecedor` (`id_fornecedor`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
