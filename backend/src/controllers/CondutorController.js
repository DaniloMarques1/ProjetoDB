const CondutorRepository = require('../repository/CondutorRepository');

class CondutorController {
    static async index(req, res) {
        try {
            const result = await CondutorRepository.findAll();
            return res.json(result);
        } catch(e) {
            return res.json({message: e.message});
        }
    }

    static async show(req, res) {
        const {idcadastro} = req.params;
        try {
            const result = await CondutorRepository.findById(idcadastro);
            return res.json(result);
        } catch(e) {
            return res.json({message: e.message});
        }
    }
}

module.exports = CondutorController;