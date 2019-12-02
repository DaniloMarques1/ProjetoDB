const { Router } = require('express');
const VehicleController = require('./controllers/VehicleController');
const TicketController = require('./controllers/TicketController');
const SalesController = require('./controllers/SalesController');
const CondutorController = require('./controllers/CondutorController');
const InfracoesController = require('./controllers/InfracoesController');
const ModeloController = require('./controllers/ModeloController');
const LicenciamentoController = require('./controllers/LicenciamentoController');

const routes = Router();

routes.post('/vehicle', VehicleController.store);
routes.get('/vehicle', VehicleController.index);
routes.get('/vehicle/renavam/:renavam', VehicleController.showByRenavam);

routes.get('/licenciamento', LicenciamentoController.index);

routes.get('/ticket', TicketController.index);
routes.get('/ticket/condutor/:idcondutor', TicketController.showByIdCondutor);
routes.get('/ticket/condutor/group/:idcondutor', TicketController.showByGroupIdCondutor);
routes.post('/ticket', TicketController.store);
routes.post('/ticket/pagamento/:idmulta', TicketController.pagamento);
routes.get('/pontos', TicketController.pontos);
routes.get('/multas/ano', TicketController.multaAno);

routes.get('/sales/:renavam', SalesController.showByRenavam);
routes.put('/sales', SalesController.store);
routes.get('/sales', SalesController.index);

routes.get('/condutor', CondutorController.index);
routes.get('/condutor/:idcadastro', CondutorController.show);


routes.get('/infracoes', InfracoesController.index);

routes.get('/modelos', ModeloController.index);

module.exports = routes;