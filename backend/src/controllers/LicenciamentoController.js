const LicenciamentoRepository = require('../repository/LicenciamentoRepository');

class LicenciamentoController {
	static async index(req, res) {
		try {
			const result = await LicenciamentoRepository.findAll();
			return res.json(result);
		} catch(e) {
			return res.json({message: e.message});
		}
	}
}

module.exports = LicenciamentoController;