const pool = require('../config/connection');

class VehicleRepository {
    // static async findAll() {
    //     try {
    //         const result = await pool.query('SELECT v.renavam, v.placa, v.ano, ca.descricao "categoria_veiculo", p.idcadastro "id_proprietario", p.nome Proprietario, m.denominacao Modelo, c.nome Cidade, v.datacompra, v.dataaquisicao, v.valor, v.situacao FROM veiculo as v join Condutor as p on v.idproprietario = p.idcadastro join modelo as m on v.idmodelo = m.idmodelo join cidade c on v.idcidade = c.idcidade join categoria_veiculos ca on v.idcategoria = ca.idcategoria order by(v.renavam)');
    //         return result.rows;
    //     } catch(e) {
    //         throw e;
    //     }
    // }

    static async findAll() {
        try {
            const result = await pool.query('SELECT * from veiculo_proprietario order by(renavam)');
            return result.rows;
        } catch(e) {
            throw e;
        }
    }

    // static async findByRenavam(renavam) {
    //     console.log(typeof renavam);
    //     try {
    //         const result = await pool.query(`SELECT v.renavam, v.placa, v.ano, ca.descricao "categoria_veiculo", p.idcadastro "id_proprietario", p.nome Proprietario, m.denominacao Modelo, c.nome Cidade, v.datacompra, v.dataaquisicao, v.valor, v.situacao FROM veiculo as v join Condutor as p on v.idproprietario = p.idcadastro join modelo as m on v.idmodelo = m.idmodelo join cidade c on v.idcidade = c.idcidade join categoria_veiculos ca on v.idcategoria = ca.idcategoria where v.renavam = '${renavam}' order by(v.renavam) `);
    //         if (result.rows.length > 0) {
    //             return result.rows[0];
    //         }
    //         throw new Error('Veiculo com renavam passado nao encontrado')
    //     } catch(e) {
    //         throw e;
    //     }
    // }

    static async findByRenavam(renavam) {
        console.log(typeof renavam);
        try {
            const result = await pool.query(`SELECT * from veiculo_proprietario where renavam = '${renavam}' order by(renavam) `);
            if (result.rows.length > 0) {
                return result.rows[0];
            }
            throw new Error('Veiculo com renavam passado nao encontrado')
        } catch(e) {
            throw e;
        }
    }

    static async create(placa, ano, idcategoria, idproprietario, idmodelo, idcidade, valor) {
        try {
            const result = await pool.query(`INSERT INTO veiculo(placa, ano, idcategoria, idproprietario, idmodelo, idcidade, valor, datacompra, dataaquisicao, situacao) VALUES('${placa}', ${ano}, ${idcategoria}, ${idproprietario}, ${idmodelo}, ${idcidade}, ${valor}, current_date, current_date, 'R') RETURNING *`);
            if (result.rows.length > 0) {
                return result.rows[0];
            }
            throw new Error('Erro ao inserir')
        } catch(e) {
            throw e;
        }
    }
}

module.exports = VehicleRepository;