--Dado um renavam como argumento de entrada, recuperar todo o histórico de transação de compra e venda de um veículo, contendo, no mínimo, os campos renavam, modelo, marca, ano, proprietario, data da compra e data da venda, ordenado em ordem cronológica das transações

CREATE OR REPLACE FUNCTION historicoVendaByRenavam(r varchar(13))
RETURNS TABLE (renavam char(13), modelo varchar(40), marca varchar(40), ano int, proprietario varchar(50), dataCompra date, dataVenda date )
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
RETURNS TABLE (renavam char(13), modelo varchar(40), marca varchar(40), ano int, proprietario varchar(50), dataCompra date, dataVenda date )
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