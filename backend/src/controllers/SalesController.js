const SalesRepository = require('../repository/SalesRepository');

class SalesController {
    static async index(req, res)  {
        try {
            const result = await SalesRepository.findAll();
            return res.json(result);
        } catch(e) {
            return res.json({message: e.message});
        }
    }
    static async store(req, res) {
        const { renavam, novoCondutor } = req.body;
        console.log(renavam);
        console.log(novoCondutor);
        try {
            const result = await SalesRepository.sale(renavam, novoCondutor);
            return res.json(result);
        } catch(e) {
            return res.status(400).json({message: e.message});
        }
    }
    
    static async showByRenavam(req, res) {
        const { renavam } = req.params;
        try {
            const result = await SalesRepository.findByRenavam(renavam);
            return res.json(result);
        } catch(e) {
            return res.status(404).json({message: e.message});
        }
    }
}

module.exports = SalesController;