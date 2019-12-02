import React, { useEffect, useState } from 'react';

import api from '../services/api';

import Navbar from '../components/Navbar/index';

import {
    Table,
    Title,
    Main,
} from './styles';

export default function Multas() {
    const [multas, setMultas] = useState([]);
    // const [renavam, setRenavam] = useState('');

    async function getMultas() {
        try {
            const response = await api.get('/ticket');
            console.log(response.data);
            // setRenavam('');
            setMultas(response.data);
        }catch(e) {
            console.log(e.response);
        }
        
    }
    useEffect(() => {
        getMultas();
    }, [])
    

    return (
        <>
        <Navbar />
        <Main>
            <Title>Multas</Title>
            <span>Total de multas: {multas.length}</span>
            <Table>
                <thead>
                    <tr>
                        <th>idmulta</th>
                        <th>Renavm</th>
                        <th>Infracao</th>
                        <th>Condutor</th>
                        <th>Data infracao</th>
                        <th>Data vencimento</th>
                        <th>Data pagamento</th>
                        <th>Valor</th>
                        <th>Juros</th>
                        <th>Valor final</th>
                        <th>Pago</th>
                    </tr>
                </thead>
                <tbody>
                    {multas.map(multa => (<tr key={multa.idmulta}>
                        <td>{multa.idmulta}</td>
                        <td>{multa.renavam}</td>
                        <td>{multa.idinfracao}</td>
                        <td>{multa.idcondutor}</td>
                        <td>{multa.datainfracao.slice(0, 10)}</td>
                        <td>{multa.datavencimento.slice(0, 10)}</td>
                        <td>{multa.datapagamento ? multa.datapagamento.slice(0, 10) : multa.datapagamento}</td>
                        <td>{multa.valor}</td>
                        <td>{multa.juros.slice(0, 10)}</td>
                        <td>R$ {multa.valorfinal.toLocaleString('pt-br')}</td>
                        <td>{multa.pago}</td>
                    </tr>))}
                </tbody>
            </Table>
        </Main>
        </>
    )
}