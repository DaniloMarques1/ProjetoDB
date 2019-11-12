CREATE DATABASE project;
\c project	



--TABELA ESTADO
CREATE TABLE Estado(
	uf char(2) NOT NULL,
	nome varchar(40) NOT NULL,
	CONSTRAINT PK_uf PRIMARY KEY(uf)
);

--NOME É PK E FK????
CREATE TABLE Cidade(
	idCidade char(3) NOT NULL,
	nome varchar(50) NOT NULL,
	uf char(2) NOT NULL,
	CONSTRAINT pk_cidade PRIMARY KEY(idCidade),
	CONSTRAINT fk_estado FOREIGN KEY(uf) REFERENCES Estado
);

-- NA TABELA PROPRIETARIO O ID DA CATEGORIA CNH ESTA INTEIRO
CREATE TABLE categoria_cnh(
	idCategoriaCNH char(3) NOT NULL,
	descricao text NOT NULL,
	CONSTRAINT pk_categoriaCnh PRIMARY KEY(idCategoriaCNH)
);

-- Tabela proprietario - todos que ja foram ou são proprietarios de veiculos

--O CAMPO ESTADO É NECESSARIO CONSIDERANDO QUE ELE ESTA PRESENTE NA TABELA DA CIDADE? (E ja temos o id da cidade)
CREATE TABLE Proprietario(
	idCadastro SERIAL NOT NULL,
	cpf char(11) NOT NULL,
	nome varchar(50) NOT NULL,
	datanasc date NOT NULL,
	idCategoriaCNH char(3) NOT NULL,
	endereco varchar(50) NOT NULL,
	bairro varchar(30) NOT NULL,
	idCidade char(3) NOT NULL,
	situacaoCNH char(1) NOT NULL DEFAULT 'R',
	CONSTRAINT pk_proprietario_cadastro PRIMARY KEY(idCadastro),
	CONSTRAINT ck_cpf CHECK(cpf ~ '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	CONSTRAINT fk_categoria FOREIGN KEY(idCategoriaCNH) REFERENCES categoria_cnh,
	CONSTRAINT fk_cidade FOREIGN KEY(idCidade) REFERENCES cidade,
	CONSTRAINT ck_situacaoCNH CHECK(situacaoCNH = 'R' or situacaoCNH = 'S')
);

-- NO DICIONARIO É UM INTEIRO MAS ESTA SENDO USADO (NO DICIONARIO) COMO FOREIGN KEY COMO CHAR
CREATE TABLE categoria_veiculos(
	idCategoria serial NOT NULL,
	nome varchar(30) NOT NULL,
	CONSTRAINT pk_categoriaVeiculo PRIMARY KEY(idCategoria)
);

--Especifica a categoria de veiculos
CREATE TABLE especie(
	idEspecie serial NOT NULL,
	descricao varchar(30) NOT NULL,
	CONSTRAINT pk_especie PRIMARY KEY(idEspecie)
);

CREATE TABLE tipo(
	idTipo SERIAL NOT NULL,
	descricao varchar(30),
	CONSTRAINT pk_tipo PRIMARY KEY(idtipo)
);

CREATE TABLE marca(
	idmarca SERIAL NOT NULL,
	nome varchar(40) NOT NULL,
	origem varchar(40) NOT NULL,
	CONSTRAINT pk_marca PRIMARY KEY(idmarca)
);

CREATE TABLE modelo(
	idmodelo SERIAL NOT NULL,
	denominacao varchar(40) NOT NULL,
	idMarca int NOT NULL,
	idTipo INT NOT NULL,
	CONSTRAINT pk_modelo PRIMARY KEY(idmodelo),
	CONSTRAINT fk_modelo_marca FOREIGN KEY(idMarca) REFERENCES marca,
	CONSTRAINT fk_modelo_tipo FOREIGN KEY(idTipo) REFERENCES tipo
);

--Descricao da tabela esta incorreta! esta igual ao da tabela de pk_especie
-- ID CATEGORIA ESTA INTEIRO (dicionario de dados) PORÉM O ID DA CATEGORIA É UM CHAR(3)
-- VALOR SERIA DO TIPO FLOAT (DICIONARIO) PORÉM ESSE TIPO NAO EXISTE NO POSTGRES
CREATE TABLE veiculos(
	renavam char(13) NOT NULL,
	placa char(7) NOT NULL,
	ano int NOT NULL,
	idCategoria int NOT NULL,
	idProprietario int NOT NULL,
	idModelo int NOT NULL,
	idCidade char(3) NOT NULL,
	datacadastro date NOT NULL,
	dataaquisicao date NOT NULL,
	valor real NOT NULL,
	situacao char(1) DEFAULT 'R',
	CONSTRAINT pk_renavem PRIMARY KEY(renavam),
	CONSTRAINT fk_veiculo_categoria FOREIGN KEY(idCategoria) REFERENCES categoria_veiculos,
	CONSTRAINT fk_veiculo_proprietario FOREIGN KEY(idProprietario) REFERENCES Proprietario,
	CONSTRAINT fk_veiculo_modelo FOREIGN KEY(idModelo) REFERENCES modelo,
	CONSTRAINT fk_veiculo_cidade FOREIGN KEY(idCidade) REFERENCES cidade,
	CONSTRAINT ck_veiculo_situacao CHECK(situacao = 'R' or situacao = 'I' or situacao = 'B')
);

CREATE TABLE licenciamento(
	ano int NOT NULL,
	renavam char(13) NOT NULL,
	datavenc date,
	pago CHAR(1) DEFAULT 'N',
	CONSTRAINT pk_licenciamento PRIMARY KEY(ano, renavam),
	CONSTRAINT fk_licenciamneto_renavam FOREIGN KEY(renavam) REFERENCES veiculos,
	CONSTRAINT ck_licenciamento_pago CHECK(pago = 'S' or pago = 'N')
);

CREATE TABLE infracao(
	idinfracao serial NOT NULL,
	descricao varchar(50) NOT NULL,
	valor numeric NOT NULL,
	pontos int NOT NULL,
	CONSTRAINT pk_infracao PRIMARY KEY(idinfracao)
);

--idcondutor é estrangeira para a tabela proprietario
CREATE TABLE multa(
	idmulta serial NOT NULL,
	renavam char(13) NOT NULL,
	idinfracao int NOT NULL,
	idcondutor int NOT NULL,
	dataInfracao date NOT NULL,
	dataVencimento date NOT NULL,
	valor numeric NOT NULL,
	juros numeric NOT NULL DEFAULT 0,
	valorFinal numeric NOT NULL DEFAULT 0, -- valor calculado, um trigger? funcao? FICA AI A REFLEXÃO!
	pago char(1) DEFAULT 'S',
	CONSTRAINT pk_multa PRIMARY KEY(idmulta),
	CONSTRAINT fk_multa_renavem FOREIGN KEY(renavam) REFERENCES veiculos,
	CONSTRAINT fk_multa_infracao FOREIGN KEY(idinfracao) REFERENCES infracao,
	CONSTRAINT fk_multa_proprietario FOREIGN KEY(idcondutor) REFERENCES Proprietario,
	CONSTRAINT ck_multa_pago CHECK(pago = 'S' or pago = 'N')
);

CREATE TABLE transferencia(
	idhistorico int NOT NULL,
	renavam char(13) NOT NULL,
	idProprietario int NOT NULL,
	dataCompra date NOT NULL,
	dataVenda date,
	CONSTRAINT pk_historico PRIMARY KEY(idhistorico),
	CONSTRAINT fk_transferencia_renavem FOREIGN KEY(renavam) REFERENCES veiculos,
	CONSTRAINT fk_transferencia_proprietario FOREIGN KEY(idProprietario) REFERENCES Proprietario
); 


INSERT INTO estado VALUES('PE', 'Pernambuco');
INSERT INTO estado VALUES('PB', 'Paraiba');
INSERT INTO estado VALUES('CE', 'Ceará');
INSERT INTO estado VALUES('BA', 'Bahia');
INSERT INTO estado VALUES('SP', 'São Paulo');

