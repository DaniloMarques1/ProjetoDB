const pool = require('../config/connection');

class CategoryRepository {
    static async findAll() {
        try {
            const result = await pool.query("SELECT * FROM categoria_veiculos");
            return result.rows;
        } catch(e) {
            throw e;
        }
    }
}

module.exports = CategoryRepository;