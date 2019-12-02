const pool = require('../config/connection');

class InfracoesRepository {
	static async findAll() {
		try {
			const result = await pool.query('SELECT * FROM infracao');
			return result.rows;
		} catch(e) {
			throw e;
		}
	}
}

module.exports = InfracoesRepository;