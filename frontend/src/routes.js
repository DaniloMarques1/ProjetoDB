import React from 'react';
import { Route, Switch, BrowserRouter} from 'react-router-dom'

import Home from './Home/index';
import Condutor from './Condutor/index';
import CadastrarMulta from './/CadastrarMulta/index';
import Multas from './/Multas/index';
import PagarMulta from './PagarMulta/index';
import Transferencia from './Trasnferencia/index';
import Pontos from './Pontos/index';
import MultasAno from './MultasAno/index';
import Venda from './Venda/index';
import CadastrarVeiculo from './CadastrarVeiculo/index';
import Licenciamento from './Licenciamento';

export default function Routes() {
    return (
        <BrowserRouter>
            <Switch>
                <Route path='/' exact component={Home} />
                <Route path='/condutor' component={Condutor} />
                <Route path='/cadastrar/multa' exact component={CadastrarMulta} />
                <Route path='/multas' exact component={Multas} />
                <Route path='/pagar/multas' exact component={PagarMulta} />
                <Route path='/transferencia' exact component={Transferencia} />
                <Route path='/pontos' exact component={Pontos} />
                <Route path='/multas/ano' exact component={MultasAno} />
                <Route path='/venda' exact component={Venda} />
                <Route path='/cadastrar/veiculo' exact component={CadastrarVeiculo} />
                <Route path='/licenciamento' exact component={Licenciamento} />
            </Switch>
        </BrowserRouter>
    )
}