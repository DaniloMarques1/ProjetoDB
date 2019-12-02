import React, { useEffect, useState } from 'react';

import api from '../services/api';

import Navbar from '../components/Navbar/index';

import {
    Table,
    Title,
    Main,
    InputIdCadastro,
    Procurar,
    Limpar
} from './styles';

export default function Condutor() {
    const [condutores, setCondutores] = useState([]);
    const [idcadastro, setIdCadastro] = useState('');

    async function getCondutores() {
        try {
            const response = await api.get('/condutor');
            console.log(response.data);
            setIdCadastro('');
            setCondutores(response.data);
        }catch(e) {
            console.log(e.response);
        }
        
    }
    useEffect(() => {
        getCondutores();
    }, [])
    
    async function searchCondutor() {
        try {
            if (!idcadastro) throw new Error('Digite um numero valido!')
            const response = await api.get(`/condutor/${idcadastro}`);
            setIdCadastro('');
            setCondutores([response.data]);
        } catch(e) {
            if (e.response) {
                alert(e.response.data.message);
            } else {
                alert(e.message);
            }
        }
    }

    return (
        <>
        <Navbar />
        <Main>
            <Title>Condutores</Title>
            <span>Total de condutores: {condutores.length}</span>
            <InputIdCadastro>
                <input value={idcadastro} onChange={(e) => setIdCadastro(e.target.value)} placeholder='Procurar condutor pelo cadastro' type='number' />
                <Procurar onClick={searchCondutor}>Procurar</Procurar>
                <Limpar onClick={getCondutores}>Limpar</Limpar>
            </InputIdCadastro>
            <Table>
                <thead>
                    <tr>
                        <th>Id cadastro</th>
                        <th>Cpf</th>
                        <th>Nome</th>
                        <th>Data nascimento</th>
                        <th>Categoria cnh</th>
                        <th>Endereco</th>
                        <th>Bairro</th>
                        <th>Cidade</th>
                        <th>Situacao cnh</th>
                    </tr>
                </thead>
                <tbody>
                    {condutores.map(condutor => (<tr key={condutor.idcadastro}>
                        <td>{condutor.idcadastro}</td>
                        <td>{condutor.cpf}</td>
                        <td>{condutor.nome}</td>
                        <td>{condutor.datanasc}</td>
                        <td>{condutor.idcategoriacnh}</td>
                        <td>{condutor.endereco}</td>
                        <td>{condutor.bairro}</td>
                        <td>{condutor.cidade}</td>
                        <td>{condutor.situacaocnh === 'S' ? 'Suspensa' : 'Regular'}</td>
                    </tr>))}
                </tbody>
            </Table>
        </Main>
        </>
    )
}