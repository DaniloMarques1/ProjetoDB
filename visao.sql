--Visão 2: ‘tabela’ que apresenta a relação dos veiculos/proprietários na base.
--renavam/placa/Nome do proprietario/modelo/marca/cidade/estado/tipo

-- renava me placa tabela veiculo
-- Join no proprietario para saber o nome do proprietario
-- Join na cidade para saber o nome/ estado
-- join com modelo para saber o nome do modelo e marca e o tipo

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

SELECT * FROM veiculo_proprietario;
SELECT * FROM veiculo_proprietario WHERE estado = 'Tocantins';

--Visão 1: ‘tabela’ que indique a relação de condutores com pontos na carteira (de acordo com as infrações cometidas), agrupados por ano:
--idCadastro/Nome do Condutor/categoria_cnh/ano/total de pontos de infração

select m.renavam, i.valor valor, c.nome 
from multa m 
join infracao i on m.idinfracao = i.idinfracao
join condutor c on m.idcondutor = c.idCadastro;


select c.idcadastro, c.nome, sum(i.valor) Valor, sum(i.pontos) Pontos, date_part('year', m.datainfracao) Ano
from multa m 
join infracao i on m.idinfracao = i.idinfracao
join condutor c on m.idcondutor = c.idCadastro
group by(date_part('year', m.datainfracao), c.nome, c.idcadastro);

--Visão 3: ‘tabela’ que apresente o número de infrações e valores em multas registrados por ano e mês.
--numero de infracoes AKA COUNT
-- valores de multas aka sum
--agrupados por ano e mes (date_part)
select concat(LPAD(date_part('year', m.datainfracao)::varchar, 	4, '0'),'-', LPAD(date_part('month', m.datainfracao)::varchar, '2', '0')), count(m.idmulta) "Total de multas", sum(m.valor) Valor from multa m group by(date_part('year', m.datainfracao), date_part('month', m.datainfracao)) order by(date_part('year', m.datainfracao), date_part('month', m.datainfracao)); 

CREATE OR REPLACE VIEW multa_valor AS 
select concat(LPAD(date_part('year', m.datainfracao)::varchar, 4, '0'), '-', LPAD(date_part('month', m.datainfracao)::varchar, 2, '0')) as "Data",
count(m.idmulta) "total_multas", 
sum(m.valor) Valor 
from multa m 
group by(date_part('year', m.datainfracao), date_part('month', m.datainfracao)) 
order by(date_part('year', m.datainfracao), date_part('month', m.datainfracao)); 