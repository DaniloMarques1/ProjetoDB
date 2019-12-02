import React, { useEffect, useState } from 'react';

import api from '../services/api';

import Navbar from '../components/Navbar/index';

import {
    Table,
    Title,
    Main,
} from './styles';

export default function Pontos() {
    const [pontos, setPontos] = useState([]);
    // const [renavam, setRenavam] = useState('');

    async function getPontos() {
        try {
            const response = await api.get('/pontos');
            console.log(response.data);
            // setRenavam('');
            setPontos(response.data);
        }catch(e) {
            console.log(e.response);
        }
        
    }
    useEffect(() => {
        getPontos();
    }, [])
    

    return (
        <>
        <Navbar />
        <Main>
            <Title>Condutores com pontos agrupados pelo ano</Title>
            <Table>
                <thead>
                    <tr>
                        <th>Id cadastro</th>
                        <th>Nome</th>
                        <th>Valor</th>
                        <th>Pontos</th>
                        <th>Ano</th>
                    </tr>
                </thead>
                <tbody>
                    {pontos.map(ponto => (<tr>
                        <td>{ponto.idcadastro}</td>
                        <td>{ponto.nome}</td>
                        <td>{ponto.valor}</td>
                        <td>{ponto.pontos}</td>
                        <td>{ponto.ano}</td>
                    </tr>))}
                </tbody>
            </Table>
        </Main>
        </>
    )
}