const pool = require('../config/connection');

class TicketRepository {
    static async findAll() {
        try {
            const result = await pool.query('SELECT * FROM multa order by(idmulta)');
            return result.rows;
        } catch(e) {
            throw e;
        }
    }

    static async findByIdCondutor(idcondutor) {
        try {
            const result = await pool.query(`SELECT m.idmulta, m.renavam, i.descricao Infracao, c.nome Condutor, m.datainfracao, m.datavencimento, m.datapagamento, m.valor, m.juros, m.valorfinal, m.pago FROM multa as m join Condutor as c on m.idcondutor = c.idcadastro join infracao as i on m.idinfracao = i.idinfracao where m.idcondutor = ${idcondutor} order by(m.datainfracao)`);
            if (result.rows.length > 0) {
                return result.rows;
            }
            throw new Error('Condutor passado nao possui multas')
        } catch(e) {
            throw e;
        }
    }

    static async findByGroupIdCondutor(idcondutor) {
        try {
            const result = await pool.query(`SELECT m.idmulta multa, c.idcadastro, c.nome Condutor, sum(i.valor) Valor, sum(i.pontos) Pontos, date_part('year', m.datainfracao) "Ano infracao" from multa as m join infracao as i on m.idinfracao = i.idinfracao join condutor as c on m.idcondutor = c.idcadastro where idcondutor = ${idcondutor} group by(date_part('year', m.datainfracao), c.nome, c.idcadastro , m.idmulta) order by(date_part('year', m.datainfracao))`);
            if (result.rows.length > 0) {
                return result.rows;
            }
            throw new Error('Condutor passado nao possui multas')
        } catch(e) {
            throw e;
        }
    }

    static async create(renavam, idinfracao, datainfracao, datavencimento) {
        try {
            const result = await pool.query(`INSERT INTO multa(renavam, idinfracao, datainfracao) VALUES('${renavam}', ${idinfracao}, '${datainfracao}') RETURNING *`);
            return result.rows[0];
        } catch(e) {
            throw e
        }
    }

    static async pay(idmulta) {
        console.log('Opa');
        try {
            const result = await pool.query(`UPDATE multa set pago = 'S' WHERE idmulta = ${idmulta} RETURNING *`);
            if (result.rows.length === 0) {
                throw new Error('Multa nao existe!');
            }
            return result.rows[0];
        } catch(e) {
            throw e;
        }
    }

    static async condutorPontos() {
        try {
            const result = await pool.query('SELECT * FROM condutor_pontos');
            return result.rows;
        } catch(e) {
            throw e;
        }
    }

    static async pontosAno() {
        try {
            const result = await pool.query('SELECT * FROM multa_valor');
            return result.rows;
        } catch(e) {
            throw e;
        }
    }
}

module.exports = TicketRepository;