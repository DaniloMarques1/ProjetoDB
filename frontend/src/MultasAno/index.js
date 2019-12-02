import React, { useEffect, useState } from 'react';

import api from '../services/api';

import Navbar from '../components/Navbar/index';

import {
    Table,
    Title,
    Main,
} from './styles';

export default function MultasAno() {
    const [multas, setMultas] = useState([]);
    // const [renavam, setRenavam] = useState('');

    async function getMultas() {
        try {
            const response = await api.get('/multas/ano');
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
            <Title>Multas agrupadas por ano e mes</Title>
            <span>Total de multas: {multas.length}</span>
            <Table>
                <thead>
                    <tr>
                        <th>Data</th>
                        <th>Total de multas</th>
                        <th>Valor</th>
                    </tr>
                </thead>
                <tbody>
                    {multas.map(multa => (<tr key={multa.idmulta}>
                        <td>{multa.Data}</td>
                        <td>{multa.total_multas}</td>
                        <td>{multa.valor}</td>
                    </tr>))}
                </tbody>
            </Table>
        </Main>
        </>
    )
}