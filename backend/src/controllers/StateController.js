const StateRepository = require('../repository/StateRepository');

class StateController {
    static async index(req, res) {
        try {
            const result = await StateRepository.findAll();
            return res.json(result);
        } catch(e) {
            return resjson({message: e.message});
        }
    }
}

module.exports = StateController;