CREATE DATABASE "BaseNacionaldeTransito";
\c BaseNacionaldeTransito

--TABELA ESTADO
CREATE TABLE estado(
	uf char(2) NOT NULL,
	nome varchar(40) NOT NULL,
	CONSTRAINT PK_uf PRIMARY KEY(uf)
);

CREATE TABLE cidade(
	idCidade SERIAL NOT NULL,
	nome varchar(50) NOT NULL,
	uf char(2) NOT NULL,
	CONSTRAINT pk_cidade PRIMARY KEY(idCidade),
	CONSTRAINT fk_estado FOREIGN KEY(uf) REFERENCES Estado
);

CREATE TABLE categoria_cnh(
	idCategoriaCNH char(3) NOT NULL,
	descricao text NOT NULL,
	CONSTRAINT pk_categoriaCnh PRIMARY KEY(idCategoriaCNH)
);

CREATE TABLE marca(
	idmarca SERIAL NOT NULL,
	nome varchar(40) NOT NULL,
	origem varchar(40) NOT NULL,
	CONSTRAINT pk_marca PRIMARY KEY(idmarca)
);

CREATE TABLE tipo(
	idTipo SERIAL NOT NULL,
	descricao varchar(30),
	CONSTRAINT pk_tipo PRIMARY KEY(idtipo)
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


CREATE TABLE condutor(
	idCadastro SERIAL NOT NULL,
	cpf char(11) NOT NULL,
	nome varchar(50) NOT NULL,
	datanasc date NOT NULL,
	idCategoriaCNH char(3) NOT NULL,
	endereco varchar(50) NOT NULL,
	bairro varchar(30) NOT NULL,
	idCidade int NOT NULL,
	situacaoCNH char(1) NOT NULL DEFAULT 'R',
	CONSTRAINT pk_proprietario_cadastro PRIMARY KEY(idCadastro),
	CONSTRAINT ck_cpf CHECK(cpf ~ '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	CONSTRAINT fk_categoria FOREIGN KEY(idCategoriaCNH) REFERENCES categoria_cnh,
	CONSTRAINT fk_cidade FOREIGN KEY(idCidade) REFERENCES cidade,
	CONSTRAINT ck_situacaoCNH CHECK(situacaoCNH = 'R' or situacaoCNH = 'S')
);

CREATE TABLE especie(
	idEspecie serial NOT NULL,
	descricao varchar(30) NOT NULL,
	CONSTRAINT pk_especie PRIMARY KEY(idEspecie)
);

CREATE TABLE categoria_veiculos(
	idCategoria serial NOT NULL,
	descricao varchar(30) NOT NULL,
	idEspecie int NOT NULL,
	CONSTRAINT pk_categoriaVeiculo PRIMARY KEY(idCategoria),
	CONSTRAINT fk_categoria_veiculos_especie FOREIGN KEY(idEspecie) REFERENCES especie
);

CREATE TABLE veiculo(
	renavam char(13) NOT NULL,
	placa char(7) NOT NULL,
	ano int NOT NULL,
	idCategoria int NOT NULL,
	idProprietario int NOT NULL,
	idModelo int NOT NULL,
	idCidade int NOT NULL,
	datacompra date NOT NULL,
	dataaquisicao date NOT NULL,
	valor real NOT NULL,
	situacao char(1) DEFAULT 'R',
	CONSTRAINT pk_renavem PRIMARY KEY(renavam),
	CONSTRAINT fk_veiculo_categoria FOREIGN KEY(idCategoria) REFERENCES categoria_veiculos,
	CONSTRAINT fk_veiculo_proprietario FOREIGN KEY(idProprietario) REFERENCES Condutor,
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
	CONSTRAINT fk_licenciamneto_renavam FOREIGN KEY(renavam) REFERENCES veiculo,
	CONSTRAINT ck_licenciamento_pago CHECK(pago = 'S' or pago = 'N')
);

CREATE TABLE infracao(
	idinfracao serial NOT NULL,
	descricao varchar(50) NOT NULL,
	valor numeric NOT NULL,
	pontos int NOT NULL,
	CONSTRAINT pk_infracao PRIMARY KEY(idinfracao)
);

CREATE TABLE multa(
	idmulta serial NOT NULL,
	renavam char(13) NOT NULL,
	idinfracao int NOT NULL,
	idcondutor int NOT NULL,
	dataInfracao date NOT NULL,
	dataVencimento date NOT NULL,
	datapagamento date,
	juros numeric NOT NULL DEFAULT 0,
	valorFinal numeric NOT NULL DEFAULT 0,
	pago char(1) DEFAULT 'N',
	CONSTRAINT pk_multa PRIMARY KEY(idmulta),
	CONSTRAINT fk_multa_renavem FOREIGN KEY(renavam) REFERENCES veiculo,
	CONSTRAINT fk_multa_infracao FOREIGN KEY(idinfracao) REFERENCES infracao,
	CONSTRAINT fk_multa_proprietario FOREIGN KEY(idcondutor) REFERENCES condutor,
	CONSTRAINT ck_multa_pago CHECK(pago = 'S' or pago = 'N')
);

CREATE TABLE transferencia(
	idhistorico serial NOT NULL,
	renavam char(13) NOT NULL,
	idProprietario int NOT NULL,
	dataCompra date NOT NULL,
	dataVenda date,
	CONSTRAINT pk_historico PRIMARY KEY(idhistorico),
	CONSTRAINT fk_transferencia_renavem FOREIGN KEY(renavam) REFERENCES veiculo,
	CONSTRAINT fk_transferencia_proprietario FOREIGN KEY(idProprietario) REFERENCES condutor
);

create sequence seq start 1000;

--RENAVAN TRIGGER
CREATE OR REPLACE FUNCTION funcRevam()
RETURNS TRIGGER AS $$
DECLARE
	fator_mult char(10) := '3298765432';
	seq varchar(11) := LPAD(nextval('seq')::varchar(10), 10, '0');
	size int := 10;
	i int := 1;
	fm int := '0'; -- valor do fator_mult
	sq int := '0'; -- valor do seq
	tot int := 0;  -- soma da mutiplicacao do seq pelo fator_mult
BEGIN
	WHILE i < size LOOP
		-- RAISE NOTICE '% ', i;
		fm := SUBSTRING(fator_mult, i, 1)::int;
		sq := SUBSTRING(seq, i, 1);
		tot = tot + (fm * sq);
		i := i + 1;
	END LOOP;
	tot := tot * 10;
	tot := MOD(tot, 11);

	IF tot = 10 THEN
		tot := 0;
	END IF;

	NEW.renavam = CONCAT(seq, tot);
	return NEW;
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER renavam
BEFORE INSERT ON veiculo
FOR EACH ROW
EXECUTE PROCEDURE funcRevam();



CREATE OR REPLACE FUNCTION fLicenciamento()
RETURNS TRIGGER AS  $$
DECLARE 	
	placa integer := SUBSTRING(new.placa, char_length(new.placa), 1)::int;
BEGIN
IF(TG_OP='INSERT') THEN
	-- no insert sempre deve ser criado com situacao regular
	INSERT INTO licenciamento date_part('year', current_date), new.renavam, fDataVencimento(placa, date_part('year', current_date)), 'S';
ELSIF (TG_OP='UPDATE') THEN
	IF (NEW.situacao = 'R') THEN
		UPDATE licenciamento
		SET pago = 'S'
		WHERE renavam = new.renavam;
	ELSE
		UPDATE licenciamento
		SET pago = 'N'
		WHERE renavam = new.renavam;
	END IF;
END IF;
RETURN NEW;
END;$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fDataVencimento(placa integer, ano integer)
RETURNS date AS $$
BEGIN
	CASE placa
		WHEN 1,7 THEN
			RETURN to_date(CONCAT('28-',placa + 2,'-',ano), 'DD-MM-YYYY');
		WHEN 2,3,9 THEN
			RETURN to_date(CONCAT('30-',placa + 2,'-',ano), 'DD-MM-YYYY');
		WHEN 5,6,8 THEN
			RETURN to_date(CONCAT('31-',placa + 2,'-',ano), 'DD-MM-YYYY');
		WHEN 4 THEN 
			RETURN to_date(CONCAT('29-',placa + 2,'-',ano), 'DD-MM-YYYY');
		ELSE 
			RETURN to_date(CONCAT('28-12','-',ano), 'DD-MM-YYYY'); -- CASO A PLACA SEJA 0 O DIA DEVE SER 12
	END CASE;
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER tLicenciamento
AFTER INSERT OR UPDATE ON veiculos
FOR EACH ROW
EXECUTE PROCEDURE fLicenciamento();
