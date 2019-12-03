const CategoryRepository = require('../repository/CategoryRepository');

class CategoryController {
    static async index(req, res) {
        try {
            const result = await CategoryRepository.findAll();
            return res.json(result);
        } catch(e) {
            return resjson({message: e.message});
        }
    }
}

module.exports = CategoryController;