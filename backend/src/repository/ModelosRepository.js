const pool = require('../config/connection');

class ModelosRepository {
	static async findAll() {
		try {
			const result = await pool.query('SELECT * FROM modelo');
			return result.rows;
		} catch(e) {
			throw e;
		}
	}
}

module.exports = ModelosRepository;