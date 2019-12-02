import React, {useState} from 'react';

import Navbar from '../components/Navbar/index';
import api from '../services/api';
import {
    Main,
    Form,
    Label,
    Input,
    Select,
    Title
} from './styles';

export default function Venda() {
    const [renavam, setRenavam] = useState('');
    const [idcondutor, setIdCondutor] = useState('');    

    async function handleVenderVeiculo(e) {       
        e.preventDefault();
        try {
            const response = await api.put('/sales', {
                renavam,
                novoCondutor: idcondutor
            });
            alert('Veiculo vendido com sucesso!');
            console.log(response.data)
        } catch(e) {
            console.log('opa')
            console.log(e)
            if (e.response) {
                alert(e.response.message);
            } else {
                alert(e.message);
            }
            
        }
    }
    return (
        <>
            <Navbar />
            <Main>
                <Title>Vender veiculo</Title>
                <Form onSubmit={handleVenderVeiculo}>
                    <Label>Renavam:</Label>
                    <Input value={renavam} onChange={(e) => setRenavam(e.target.value)} type='text' placeholder='Renavam do carro' />
                    <Label>Novo condutor:</Label>
                    <Input value={idcondutor} onChange={(e) => setIdCondutor(e.target.value)} type='number' placeholder='id de cadastro'/>
                    <button type='submit'>Vender</button>
                </Form>
            </Main>
        </>
    );
}