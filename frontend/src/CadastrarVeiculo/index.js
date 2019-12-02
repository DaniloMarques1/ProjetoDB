import React, {useState, useEffect} from 'react';

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

export default function CadastrarVeiculo() {
    const [placa, setPlaca] = useState('');
    const [ano, setAno] = useState('');
    const [categoria, setCategoria] = useState('');
    const [proprietario, setProprietario] = useState('');
    const [modelo, setModelo] = useState('');
    const [cidade, setCidade] = useState('');
    const [valor, setValor] = useState('');
    
    async function handleCadastrarVeiculo(e) {       
        e.preventDefault();
        try {
            const response = await api.post('/vehicle', {
                placa,
                ano,
                idcategoria: categoria,
                idproprietario: proprietario,
                idmodelo: modelo,
                idcidade: cidade,
                valor
            });
            alert('Veiculo cadastrado com sucesso!');
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
                <Title>Cadastrar veiculo</Title>
                <Form onSubmit={handleCadastrarVeiculo}>
                    <Label>Placa:</Label>
                    <Input value={placa} onChange={(e) => setPlaca(e.target.value)} type='text' placeholder='Placa'/>

                    <Label>Ano:</Label>
                    <Input value={ano} onChange={(e) => setAno(e.target.value)} type='number' placeholder='Ano do carro'/>
                    
                    <Label>Categoria:</Label>
                    <Input value={categoria} onChange={(e) => setCategoria(e.target.value)} type='number' placeholder='Categoria'/>
                    
                    <Label>Proprietario:</Label>
                    <Input value={proprietario} onChange={(e) => setProprietario(e.target.value)} type='number' placeholder='Id do proprietario'/>
                    
                    <Label>modelo:</Label>
                    <Input value={modelo} onChange={(e) => setModelo(e.target.value)} type='number' placeholder='Modelo'/>
                    
                    <Label>Cidade:</Label>
                    <Input value={cidade} onChange={(e) => setCidade(e.target.value)} type='number' placeholder='id da cidade'/>
                    
                    <Label>Valor:</Label>
                    <Input value={valor} onChange={(e) => setValor(e.target.value)} type='number' placeholder='Valor do carro'/>
                    
                    <button type='submit'>Cadastrar</button>
                </Form>
            </Main>
        </>
    );
}