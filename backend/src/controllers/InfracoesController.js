const InfracoesRepository = require('../repository/InfracoesRepository');

class InfracoesController {
	static async index(req, res) {
		try {
			const result = await InfracoesRepository.findAll();
			return res.json(result);
		} catch(e) {
			return res.json({message: e.message});
		}
	}
}

module.exports = InfracoesController;