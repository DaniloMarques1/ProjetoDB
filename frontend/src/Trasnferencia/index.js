import React, {useEffect, useState} from 'react';

import Navbar from '../components/Navbar/index';
import api from '../services/api';
import {
    Main,
    Table,
    Title,
    InputIdCadastro,
    Limpar,
    Procurar
} from './styles';

export default function Transferencia() {
    const [transfers, setTransfers] = useState([]);
    const [renavam, setRenavam] = useState('');

    async function getTransfers() {
        try {
            const response = await api.get('/sales');
            setTransfers(response.data);
        } catch(e) {
            console.log(e);
        }
    }

    useEffect(() => {
        getTransfers();
    }, []);

    async function handleSearchByRenavam() {
        try {
            const response = await api.get(`/sales/${renavam}`);
            setTransfers(response.data);
            setRenavam('');
        } catch(e) {
            console.log(e);
        }
    }

    return (
        <>
        <Navbar />
        <Main>
            <Title>Transferencias</Title>
            <span>Total de Transferencias: {transfers.length}</span>
            <InputIdCadastro>
                <label>Renavam: </label>
                <input value={renavam} onChange={(e) => setRenavam(e.target.value)} type='text' placeholder='renavam' />
                <Procurar onClick={handleSearchByRenavam}>Procurar</Procurar>
                <Limpar onClick={() => getTransfers()}>Limpar</Limpar>
            </InputIdCadastro>
            <Table>
                <thead>
                    <tr>
                        <th>Renavam</th>
                        <th>Denominacao</th>
                        <th>Marca</th>
                        <th>Ano</th>
                        <th>proprietario</th>
                        <th>Data compra</th>
                        <th>Data venda</th>
                    </tr>
                </thead>
                <tbody>
                    {transfers.map(transfer => (<tr>
                        <td>{transfer.renavam}</td>
                        <td>{transfer.modelo}</td>
                        <td>{transfer.marca}</td>
                        <td>{transfer.ano}</td>
                        <td>{transfer.proprietario}</td>
                        <td>{transfer.datacompra.slice(0, 10)}</td>
                        <td>{transfer.datavenda.slice(0, 10)}</td>
                    </tr>))}
                </tbody>
            </Table>
        </Main>
        </>
    );
}