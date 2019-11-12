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



--Especifica a categoria de veiculos
CREATE TABLE especie(
	idEspecie serial NOT NULL,
	descricao varchar(30) NOT NULL,
	CONSTRAINT pk_especie PRIMARY KEY(idEspecie)
);

-- NO DICIONARIO É UM INTEIRO MAS ESTA SENDO USADO (NO DICIONARIO) COMO FOREIGN KEY COMO CHAR
CREATE TABLE categoria_veiculos(
	idCategoria serial NOT NULL,
	descricao varchar(30) NOT NULL,
	idEspecie int NOT NULL,
	CONSTRAINT pk_categoriaVeiculo PRIMARY KEY(idCategoria),
	CONSTRAINT fk_categoria_veiculos_especie PRIMARY KEY(idEspecie)
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

--ESTADOS
INSERT INTO estado VALUES('PE', 'Pernambuco');
INSERT INTO estado VALUES('PB', 'Paraiba');
INSERT INTO estado VALUES('CE', 'Ceará');
INSERT INTO estado VALUES('BA', 'Bahia');
INSERT INTO estado VALUES('SP', 'São Paulo');

--CIDADES
INSERT INTO cidade VALUES(1, 'Recife', 'PE');
INSERT INTO cidade VALUES(2, 'Goiana', 'PE');
INSERT INTO cidade VALUES(3, 'João Pessoa', 'PB');
INSERT INTO cidade VALUES(4, 'São Paulo', 'SP');
INSERT INTO cidade VALUES(5, 'Sapé', 'PB');
INSERT INTO cidade VALUES(6, 'Olinda', 'PE');
INSERT INTO cidade VALUES(7, 'Osasco', 'SP');
INSERT INTO cidade VALUES(8, 'Porto Seguro', 'BA');
INSERT INTO cidade VALUES(9, 'Ilhéus', 'BA');
INSERT INTO cidade VALUES(10, 'Feira de Santana', 'BA');
INSERT INTO cidade VALUES(11, 'Fortaleza', 'CE');
INSERT INTO cidade VALUES(12, 'Juazeiro do Norte', 'CE');

--CATEGORIAS
INSERT INTO categoria_cnh VALUES('AAC', 'Habilita pessoas conduzam veículos de duas rodas com até 50 cm3 de cilindrada, as conhecidas “cinquentinhas”.');
INSERT INTO categoria_cnh VALUES('A', 'abilita a conduzir veículos de duas ou três rodas, com mais que 50 de cilindrada. Além disso, também é possível conduzir os ciclomotores da categoria ACC');
INSERT INTO categoria_cnh VALUES('B', 'Habilita o condutor a conduzir veículos de quatro rodas com até 3,5 toneladas de peso bruto total e capacidade para até oito passageiros, além do motorista (nove ocupantes no total). Quadriciclos estão inclusos nesta classe.
');
INSERT INTO categoria_cnh VALUES('C', 'Habilita o condutor a dirigir todos os tipos de automóveis da categoria B, e também os veículos de carga, não articulados, com mais de 3,5 toneladas de peso bruto total. São exemplos os caminhões, tratores, máquinas agrícolas e de movimentação de carga.');
INSERT INTO categoria_cnh VALUES('D', 'Habilita o condutor a dirigir veículos para o transporte de passageiros que acomodem mais de 8 passageiros. Aqui, entram os ônibus, micro-ônibus e vans. Com ela, o condutor também pode comandar todos os veículos inclusos nos tipos de CNH B e C.
');
INSERT INTO categoria_cnh VALUES('E', 'todos os veículos inclusos nos tipos de CNH B, C e D. Além disso, ele também pode dirigir veículos com unidades acopladas que excedam 6 toneladas. Aqui estão as carretas e caminhões com reboques e semirreboques articulados. Por fim, é necessário ter a carteira E para conduzir carros puxando trailers.
');

--FABRICANTES
INSERT INTO marca VALUES(1, 'Chevrolet', 'Estados Unidos');
INSERT INTO marca VALUES(2, 'Cadillac', 'Estados Unidos');
INSERT INTO marca VALUES(3, 'Holden', 'Australia');
INSERT INTO marca VALUES(4, 'Pontiac', 'Estados Unidos');

--TIPOS
INSERT INTO tipo VALUES(1, 'automóvel');
INSERT INTO tipo VALUES(2, 'motocicleta');
INSERT INTO tipo VALUES(3, 'motoneta');
INSERT INTO tipo VALUES(4, 'triciclo');
INSERT INTO tipo VALUES(5, 'quadriciclo');
INSERT INTO tipo VALUES(6, 'microônibus');
INSERT INTO tipo VALUES(7, 'ônibus');
INSERT INTO tipo VALUES(8, 'reboque');
INSERT INTO tipo VALUES(9, 'charrete');
INSERT INTO tipo VALUES(10, 'caminhonete');
INSERT INTO tipo VALUES(11, 'caminhão');
INSERT INTO tipo VALUES(12, 'carroça');
INSERT INTO tipo VALUES(13, 'trator de rodas');
INSERT INTO tipo VALUES(14, 'trator de esteira');
INSERT INTO tipo VALUES(15, 'trator misto');
INSERT INTO tipo VALUES(16, 'furgão');


-- MODELO DE CARRO! QUE DIABO É ISSO
-- ....



--ESPECIE DE VEICULOS
INSERT INTO especie VALUES(1, 'De passageiros');
INSERT INTO especie VALUES(2, 'De carga');
INSERT INTO especie VALUES(3, 'Misto');
INSERT INTO especie VALUES(4, 'De competição');
INSERT INTO especie VALUES(5, 'De Tração');
INSERT INTO especie VALUES(6, 'Especial');
INSERT INTO especie VALUES(7, 'De coleção');

--CATEGORIA DE VEICULOS
INSERT INTO categoria_veiculos VALUES(1, 'Particular', 6);
INSERT INTO categoria_veiculos VALUES(2, 'Oficial', 1);
INSERT INTO categoria_veiculos VALUES(3, 'Aprendizagem', 3);
INSERT INTO categoria_veiculos VALUES(4, 'Aluguel', 6);
INSERT INTO categoria_veiculos VALUES(5, 'Representação Diplomática', 6);
