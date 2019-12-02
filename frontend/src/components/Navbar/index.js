import React from 'react';

import {Link} from 'react-router-dom';


import {
    Nav
} from './styles';

export default function Navbar() {
    return (
        <Nav>
            <h2>BNT</h2>
            <div>
                <ul>
                    <li><Link to='/'>Veiculos</Link></li>
                    <li><Link to='/cadastrar/veiculo'>Cadastrar veiculo</Link></li>
                    <li><Link to='/licenciamento'>Licenciamento</Link></li>
                    <li><Link to='/multas'>Multas</Link></li>
                    <li><Link to='/cadastrar/multa'>Cadastrar multa</Link></li>
                    <li><Link to='/pagar/multas'>Pagar multa</Link></li>
                    <li><Link  to='/condutor'>Condutores</Link></li>
                    <li><Link to='/pontos'>Condutor e pontos</Link></li>
                    <li><Link to='/multas/ano'>Multas por ano/mes</Link></li>
                    <li><Link to='/transferencia'>Historico de compra e venda</Link></li>
                    <li><Link to='/venda'>Venda</Link></li>
                </ul>
            </div>
        </Nav>
    )
}
