const ModelosRepository = require('../repository/ModelosRepository');

class ModeloController {
	static async index(req, res) {
		try {
			const result = await ModelosRepository.findAll();
			return res.json(result);
		} catch(e) {
			return res.json({message: e.message});
		}
	}
}

module.exports = ModeloController;