import React, { useEffect, useState } from 'react';

import api from '../services/api';

import Navbar from '../components/Navbar/index';

import {
    Table,
    Title,
    Main,
    InputRenavam,
    Procurar,
    Limpar
} from './styles';

export default function Home() {
    const [cars, setCars] = useState([]);
    const [renavam, setRenavam] = useState('');

    async function getCars() {
        try {
            const response = await api.get('/vehicle');
            console.log(response.data);
            setRenavam('');
            setCars(response.data);
        }catch(e) {
            console.log(e.response);
        }
        
    }
    useEffect(() => {
        getCars();
    }, [])
    
    async function searchByRenavam() {
        try {
            const response = await api.get(`/vehicle/renavam/${renavam}`);
            setRenavam('');
            setCars([response.data]);
        } catch(e) {
            alert(e.response.data.message);
            console.log(e.response.data.message);
        }
    }

    return (
        <>
        <Navbar />
        <Main>
            <Title>Veiculos</Title>
            <span>Total de carros: {cars.length}</span>
            <InputRenavam>
                <input value={renavam} onChange={(e) => setRenavam(e.target.value)} placeholder='Procurar carro pelo renavam' type='text' />
                <Procurar onClick={searchByRenavam}>Procurar</Procurar>
                <Limpar onClick={getCars}>Limpar</Limpar>
            </InputRenavam>
            <Table>
                <thead>
                    <tr>
                    <th>Placa</th>
                    <th>Renavam</th>
                    <th>Condutor</th>
                    <th>Cidade</th>
                    <th>Estado</th>
                    <th>Modelo</th>
                    <th>Marca</th>
                    <th>Tipo</th>
                    </tr>
                </thead>
                <tbody>
                    {cars.map(car => (<tr key={car.renavam}>
                        <td>{car.placa}</td>
                        <td>{car.renavam}</td>
                        <td>{car.condutor}</td>
                        <td>{car.cidade}</td>
                        <td>{car.estado}</td>
                        <td>{car.modelo}</td>
                        <td>{car.marca}</td>
                        <td>{car.tipo}</td>
                    </tr>))}
                </tbody>
            </Table>
        </Main>
        </>
    )
}