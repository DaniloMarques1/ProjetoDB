const pool = require('../config/connection');

class CityRepository {
	static async findOne(estado) {
		try {
			const result = await pool.query(`SELECT * FROM cidade WHERE uf = '${estado}'`);
			return result.rows;
		} catch(e) {
			throw e;
		}
	}
}

module.exports = CityRepository;