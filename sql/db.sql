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
	renavam char(11) NOT NULL,
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
	renavam char(11) NOT NULL,
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
	renavam char(11) NOT NULL,
	idinfracao int NOT NULL,
	idcondutor int NOT NULL,
	dataInfracao date NOT NULL,
	dataVencimento date NOT NULL,
	datapagamento date,
	valor numeric NOT NULL,
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
	renavam char(11) NOT NULL,
	idProprietario int NOT NULL,
	dataCompra date NOT NULL,
	dataVenda date,
	CONSTRAINT pk_historico PRIMARY KEY(idhistorico),
	CONSTRAINT fk_transferencia_renavem FOREIGN KEY(renavam) REFERENCES veiculo,
	CONSTRAINT fk_transferencia_proprietario FOREIGN KEY(idProprietario) REFERENCES condutor
);


--- TRIGGER PARA O RENAVAM

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

-- TRIGGER PARA TRANSFERENCIA DE VEICULOS
CREATE OR REPLACE FUNCTION fTransferencia()
RETURNS TRIGGER AS $$
BEGIN
IF(TG_OP = 'UPDATE') THEN
	IF (old.idproprietario != new.idproprietario) THEN
		INSERT INTO transferencia(renavam, idproprietario, datacompra, datavenda) values(new.renavam, old.idproprietario, old.dataaquisicao, current_date);
		RETURN new;
	END IF;
END IF;
RETURN new;
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER tTransferencia
AFTER UPDATE ON veiculo
FOR ROW 
EXECUTE PROCEDURE fTransferencia();

--TRIGGER PARA O LICENCIAMENTO DE VEICULOS
CREATE OR REPLACE FUNCTION fLicenciamento()
RETURNS TRIGGER AS  $$
DECLARE 	
	placa integer := SUBSTRING(new.placa, char_length(new.placa), 1)::int+2;
	anoL integer := EXTRACT(year from now());
	dataVn date := fDataVencimento(placa,anoL);
BEGIN
IF(TG_OP='INSERT') THEN
	IF (NEW.situacao = 'R') THEN
		INSERT INTO licenciamento SELECT anoL, new.renavam, dataVn, 'S';
	END IF;
ELSIF (TG_OP='UPDATE') THEN
	IF (NEW.situacao = 'R') THEN
		UPDATE licenciamento SET pago = 'S', ano = anoL, dataVenc = dataVn WHERE renavam = new.renavam;
	ELSE
		UPDATE licenciamento SET pago = 'N', ano = anoL, dataVenc = dataVn WHERE renavam = new.renavam;
	END IF;
END IF;
RETURN NEW;
END;$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fDataVencimento(placa integer, ano integer)
RETURNS date AS $$
BEGIN
	IF (placa = 2) THEN
		placa := 12;
	END IF;
	CASE placa
		WHEN 3,9,12 THEN
			RETURN to_date(CONCAT('28-',placa,'-',ano+1), 'DD-MM-YYYY');
		WHEN 4,5,11 THEN
			RETURN to_date(CONCAT('30-',placa,'-',ano+1), 'DD-MM-YYYY');
		WHEN 7,8,10 THEN
			RETURN to_date(CONCAT('31-',placa,'-',ano+1), 'DD-MM-YYYY');
		ELSE 
			RETURN to_date(CONCAT('29-',placa,'-',ano+1), 'DD-MM-YYYY');
	END CASE;
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER tLicenciamento
AFTER INSERT OR UPDATE ON veiculo
FOR EACH ROW
EXECUTE PROCEDURE fLicenciamento();

--Falta fazer o job

-- FUNCOES QUE RETORNAM O HISTORICO DE COMPRA E VENDA (TABELA)
CREATE OR REPLACE FUNCTION historicoVendaByRenavam(r varchar(11))
RETURNS TABLE (renavam char(11), modelo varchar(40), marca varchar(40), ano int, proprietario varchar(50), dataCompra date, dataVenda date )
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
	select t.renavam, m.denominacao "Modelo", mc.nome "Marca", v.ano "Ano do carro", p.nome Proprietario, t.dataCompra "Data compra", t.dataVenda "Data Venda" 
	FROM transferencia as t join veiculo as v on t.renavam = v.renavam
	JOIN modelo as m on v.idmodelo = m.idmodelo
	JOIN marca as mc on m.idmarca = mc.idmarca
	JOIN condutor as p on t.idproprietario = p.idcadastro
	WHERE t.renavam = r
	order by(t.idhistorico);
END $$;


CREATE OR REPLACE FUNCTION historicoVenda()
RETURNS TABLE (renavam char(11), modelo varchar(40), marca varchar(40), ano int, proprietario varchar(50), dataCompra date, dataVenda date )
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
	select t.renavam, m.denominacao "Modelo", mc.nome "Marca", v.ano "Ano do carro", p.nome Proprietario, t.dataCompra "Data compra", t.dataVenda "Data Venda" 
	FROM transferencia as t join veiculo as v on t.renavam = v.renavam
	JOIN modelo as m on v.idmodelo = m.idmodelo
	JOIN marca as mc on m.idmarca = mc.idmarca
	JOIN condutor as p on t.idproprietario = p.idcadastro
	order by(t.idhistorico);
END $$;

--VISOES

CREATE VIEW veiculo_proprietario AS SELECT v.placa, v.renavam, p.nome Condutor, c.nome Cidade, e.nome Estado, m.denominacao Modelo, mc.nome Marca, t.descricao Tipo
FROM veiculo as v
JOIN Condutor as p on v.idProprietario = p.idCadastro
JOIN cidade as c on v.idCidade = c.idCidade
JOIN estado as e on c.uf = e.uf
JOIN modelo as m on v.idmodelo = m.idmodelo
JOIN marca as mc on m.idmarca = mc.idmarca
JOIN tipo as t on m.idtipo = t.idtipo;


CREATE OR REPLACE VIEW condutor_pontos AS select c.idcadastro, c.nome, sum(i.valor) Valor, sum(i.pontos) Pontos, date_part('year', m.datainfracao) Ano
from multa m 
join infracao i on m.idinfracao = i.idinfracao
join condutor c on m.idcondutor = c.idCadastro
group by(date_part('year', m.datainfracao), c.nome, c.idcadastro)
ORDER BY (date_part('year', m.datainfracao));

CREATE OR REPLACE VIEW multa_valor AS 
select concat(LPAD(date_part('year', m.datainfracao)::varchar, 4, '0'), '-', LPAD(date_part('month', m.datainfracao)::varchar, 2, '0')) as "Data",
count(m.idmulta) "total_multas", 
sum(m.valor) Valor 
from multa m 
group by(date_part('year', m.datainfracao), date_part('month', m.datainfracao)) 
order by(date_part('year', m.datainfracao), date_part('month', m.datainfracao)); 


--FUNCAO QUE RETORNA A QUANTIDA DE PONTOS NA CARTEIRA DE UM CONDUTOR
CREATE OR REPLACE FUNCTION getCnhPoints(condutor int, y int) 
RETURNS int AS $$
DECLARE
	p int := 0;
BEGIN
	SELECT pontos into p FROM condutor_pontos where idcadastro = condutor AND ano = y;
	return p;
END ; $$
LANGUAGE plpgsql;


--FUNÇÂO: Inserção na tabela Multa
CREATE OR REPLACE FUNCTION fmultaADD()
RETURNS TRIGGER AS $$
DECLARE
	valorInf integer := (SELECT valor FROM infracao WHERE idInfracao = new.idInfracao)::integer;
	dVencimento date := new.dataInfracao + 40;
BEGIN		
	CASE EXTRACT(dow from dVencimento)	--Checa se caiu em um sabado ou domingo
		WHEN 6 THEN
			dVencimento := dVencimento +2;
		WHEN 0 THEN
			dVencimento := dVencimento +1;
	END CASE;
	IF (TG_OP = 'INSERT') THEN
		new.idCondutor = (SELECT idCondutor FROM veiculos WHERE renavam = new.renavam);
		new.dataVencimento = dVencimento;
		new.valor = valorInf;
		new.valorFinal = valorInf + jurosADD(new.dataPagamento, dVencimento, valorInf);
	END IF;
	RETURN new;
END; $$
LANGUAGE plpgsql;

--FUNÇÂO: Update na tabela Multa
CREATE OR REPLACE FUNCTION fCNH()
RETURNS TRIGGER AS $$
BEGIN
IF(getCnhPoints(new.idCondutor, date_part('year', current_date)) >= 20) THEN
	IF(TG_OP = 'INSERT') THEN
		UPDATE condutor SET situacaoCNH = 'S' WHERE idCondutor = new.idCondutor;
		RETURN new;
	END IF;
END IF;
RETURN new;
END; $$
LANGUAGE plpgsql;

--TRIGGERs
CREATE TRIGGER tMultaADD
BEFORE INSERT ON multa
FOR ROW
EXECUTE PROCEDURE fmultaADD();

CREATE TRIGGER tCNH
AFTER INSERT ON multa
FOR ROW
EXECUTE PROCEDURE fCNH();

--POVOAMENTO