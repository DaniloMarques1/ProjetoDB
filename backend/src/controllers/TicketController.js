const TicketRepository = require('../repository/TicketRepository');

class VehicleController {
    static async index(req, res) {
        try {
            const vehicles = await TicketRepository.findAll();
            return res.json(vehicles);
        } catch(e) {
            return res.status(400).json({message: e.message});
        }
    }

    static async showByIdCondutor(req, res) {
        const { idcondutor } = req.params
        try {
            const result = await TicketRepository.findByIdCondutor(idcondutor);
            return res.json(result);

        } catch(e) {
            return res.status(404).json({message: e.message});
        }   
    }

    static async showByGroupIdCondutor(req, res) {
        const { idcondutor } = req.params
        try {
            const result = await TicketRepository.findByGroupIdCondutor(idcondutor);
            return res.json(result);

        } catch(e) {
            return res.status(404).json({message: e.message});
        }   
    }

    static async store(req, res) {
        const { renavam, idinfracao, datainfracao } = req.body;
        try {
            const result = await TicketRepository.create(renavam, idinfracao, datainfracao);
            return res.json(result);
        } catch(e) {
            return res.json({message: e.message});
        }
    }

    static async pagamento(req, res) {
        const { idmulta } = req.params;
        try {
            const result = await TicketRepository.pay(idmulta);
            return res.json(result);
        } catch(e) {
            return res.json({message: e.message});
        }
    }

    static async pontos(req, res) {
        try {
            const result = await TicketRepository.condutorPontos();
            return res.json(result);
        } catch(e) {
            return res.status(400).json({message: e.message});
        }
    }

    static async multaAno(req, res) {
        try {
            const result = await TicketRepository.pontosAno();
            return res.json(result);
        } catch(e) {
            return res.status(400).json({message: e.message});
        }
    }
}

module.exports = VehicleController;