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
    const [categorias, setCategorias] = useState([]);
    const [selectedCategoria, setSelectedCategoria] = useState('');
    const [proprietario, setProprietario] = useState('');
    const [modelos, setModelos] = useState([]);
    const [selectedModelo, setSelectedModelo] = useState('');
    const [cidades, setCidades] = useState([]);
    const [selectedCidade, setSelectedCidade] = useState('');
    const [estados, setEstados] = useState([])
    
    const [valor, setValor] = useState('');
    
    useEffect(() => {
        async function getCategorias() {
            try {
                const response = await api.get('/category');
                setCategorias(response.data)
            } catch(e) {
                console.log(e);
            }
        }
        getCategorias();
    }, []);

    useEffect(() => {
        async function getModelos() {
            try {
                const response = await api.get('/modelos');
                setModelos(response.data);
            } catch(e) {
                console.log(e);
            }
        }
        getModelos();
    }, []);

    useEffect(() => {
        async function getStates() {
            try {
                const response = await api.get('/state');
                setEstados(response.data);
            } catch(e) {
                console.log(e);
            }
        }
        getStates();
    }, []);
    
    async function handleGetCity(e) {
        const estado = e.target.value;
        try {
            const response = await api.get(`/city/${estado}`);
            setCidades(response.data);
        } catch(e) {
            console.log(e);
        }
    }

    async function handleCadastrarVeiculo(e) {       
        e.preventDefault();
        try {
            const response = await api.post('/vehicle', {
                placa,
                ano,
                idcategoria: selectedCategoria,
                idproprietario: proprietario,
                idmodelo: selectedModelo,
                idcidade: selectedCidade,
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
                    
                    <Label>Proprietario:</Label>
                    <Input value={proprietario} onChange={(e) => setProprietario(e.target.value)} type='number' placeholder='Id do proprietario'/>


                    <Label>Categoria:</Label>
                    <Select value={selectedCategoria} onChange={(e) => setSelectedCategoria(e.target.value)}>
                        <option value='-1'>Selecione uma das opcoes!</option>
                        {categorias.map(categoria => (
                            <option key={categoria.idcategoria} value={categoria.idcategoria}>{categoria.descricao}</option>
                        ))}
                    </Select>
                    
                    
                    <Label>modelo:</Label>
                    <Select value={selectedModelo} onChange={(e) => setSelectedModelo(e.target.value)}>
                            <option value='-1'>Selecione uma das opcoes!</option>
                            {modelos.map(modelo => (
                                <option key={modelo.idmodelo} value={modelo.idmodelo}>{modelo.denominacao}</option>
                            ))}
                    </Select>

                    <Label>Estados:</Label>
                    <Select onChange={handleGetCity}>
                            <option value='-1'>Selecione uma das opcoes!</option>
                            {estados.map(estado => (
                                <option key={estado.uf} value={estado.uf}>{estado.nome}</option>
                            ))}
                    </Select>

                    <Label>Cidade:</Label>
                    <Select  onChange={(e) => setSelectedCidade(e.target.value)}>
                            <option value='-1'>Selecione uma das opcoes!</option>
                            {cidades.map(cidade => (
                                <option key={cidade.idcidade} value={cidade.idcidade}>{cidade.nome}</option>
                            ))}
                    </Select>


                    <Label>Valor:</Label>
                    <Input value={valor} onChange={(e) => setValor(e.target.value)} type='number' placeholder='Valor do carro'/>
                    
                    <button type='submit'>Cadastrar</button>
                </Form>
            </Main>
        </>
    );
}