const CityRepository = require('../repository/CityRepository');

class CityController {
    static async index(req, res) {
        const { estado } = req.params;
        console.log(estado);
        try {
            const result = await CityRepository.findOne(estado.toUpperCase());
            return res.json(result);
        } catch(e) {
            return res.json({message: e.message});
        }
    }
}

module.exports = CityController;