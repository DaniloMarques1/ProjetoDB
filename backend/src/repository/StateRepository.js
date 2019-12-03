const pool = require('../config/connection');

class StateRepository {
	static async findAll() {
		try {
			const result = await pool.query('SELECT * FROM estado');
			return result.rows;
		} catch(e) {
			throw e;
		}
	}
}

module.exports = StateRepository;