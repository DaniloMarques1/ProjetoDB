import React, { useEffect, useState } from 'react';

import api from '../services/api';

import Navbar from '../components/Navbar/index';

import {
    Table,
    Title,
    Main,
} from './styles';

export default function Licenciamento() {
    const [licenciamentos, setLicenciamentos] = useState([]);
    // const [renavam, setRenavam] = useState('');

    async function getLicenciamentos() {
        try {
            const response = await api.get('/licenciamento');
            console.log(response.data);
            // setRenavam('');
            setLicenciamentos(response.data);
        }catch(e) {
            console.log(e.response);
        }
        
    }
    useEffect(() => {
        getLicenciamentos();
    }, [])
    

    return (
        <>
        <Navbar />
        <Main>
            <Title>Licenciamentos</Title>
            <Table>
                <thead>
                    <tr>
                        <th>Ano</th>
                        <th>renavam</th>
                        <th>data vencimento</th>
                        <th>pago</th>
                    </tr>
                </thead>
                <tbody>
                    {licenciamentos.map(licenciamento => (<tr>
                        <td>{licenciamento.ano}</td>
                        <td>{licenciamento.renavam}</td>
                        <td>{licenciamento.datavenc}</td>
                        <td>{licenciamento.pago}</td>
                    </tr>))}
                </tbody>
            </Table>
        </Main>
        </>
    )
}