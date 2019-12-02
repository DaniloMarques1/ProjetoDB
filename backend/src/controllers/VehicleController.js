const VehicleRepository = require('../repository/VehicleRepository');

class VehicleController {
    static async index(req, res) {
        try {
            const vehicles = await VehicleRepository.findAll();
            return res.json(vehicles);
        } catch(e) {
            return res.json({message: e.message});
        }
    }

    static async showByRenavam(req, res) {
        const { renavam } = req.params
        try {
            const result = await VehicleRepository.findByRenavam(renavam);
            return res.json(result);

        } catch(e) {
            return res.status(404).json({message: e.message});
        }   
    }

    static async store(req, res) {
        const { placa, ano, idcategoria, idproprietario, idmodelo, idcidade, valor } = req.body;
        try {
            const result = await VehicleRepository.create(placa, ano, idcategoria, idproprietario, idmodelo, idcidade, valor);
            return res.json(result);
        } catch(e) {
            return res.json({message: e.message});
        }
    }
}

module.exports = VehicleController;