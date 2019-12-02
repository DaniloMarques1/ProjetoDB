const pool = require('../config/connection');

class LicenciamentoRepository {
	static async findAll() {
		try {
			const result = await pool.query('SELECT * FROM licenciamento');
			return result.rows;
		} catch(e) {
			throw e;
		}
	}
}

module.exports = LicenciamentoRepository;