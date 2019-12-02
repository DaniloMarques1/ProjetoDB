const pool = require('../config/connection');

class CondutorRepository {
    static async findAll() {
        try {
            const result = await pool.query('SELECT c.idcadastro, c.cpf, c.nome, c.datanasc, c.idcategoriacnh, c.endereco, c.bairro, ci.nome Cidade, c.situacaocnh FROM condutor c join cidade ci on c.idcidade = ci.idcidade order by(idcadastro)');
            return result.rows;
        } catch(e) {
            throw e;
        }
    }

    static async findById(id) {
        try {
            const result = await pool.query(`SELECT c.idcadastro, c.cpf, c.nome, c.datanasc, c.idcategoriacnh, c.endereco, c.bairro, ci.nome Cidade, c.situacaocnh FROM condutor c join cidade ci on c.idcidade = ci.idcidade WHERE idcadastro = ${id} order by(idcadastro)`);
            if (result.rows.length >0) {
                return result.rows[0];
            }
            throw new Error('Condutor nao existe')
        } catch(e) {
            throw e;
        }
    }

    

}

module.exports = CondutorRepository;