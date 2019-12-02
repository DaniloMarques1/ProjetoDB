const pool = require('../config/connection');

class SalesRepository {
    static async findAll() {
        try {
            const result = await pool.query('SELECT * FROM historicoVenda() order by(datavenda)');
            return result.rows;
        } catch(e) {
            throw e;
        }
    }
    static async sale(renavam, novoCondutor) {
        try {
            const result = await pool.query(`UPDATE veiculo set idproprietario = ${novoCondutor}, dataaquisicao = current_date WHERE renavam = '${renavam}' RETURNING *`);
            if (result.rows.length > 0) {
                return result.rows[0];
            }
            throw new Error('Renavam ou conduro nao existente');
        } catch(e) {
            throw e;
        }
    }

    static async findByRenavam(renavam) {
        try {
            const result = await pool.query(`SELECT * FROM historicoVendaByRenavam('${renavam}')`);
            return result.rows;
        } catch(e) {
            throw e;
        }
    }
}

module.exports = SalesRepository;