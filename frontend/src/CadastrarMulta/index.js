import React, {useEffect, useState} from 'react';

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

export default function CadastrarMulta() {
    const [infracoes, setInfracoes] = useState([{idinfracao: -1, descricao: '--Selecione uma das opcoes--'}]);
    const [selectInfracao, setSelectInfracao] = useState('');
    const [renavam, setRenavam] = useState('');
    const [data, setData] = useState('');
    
    useEffect(() => {
        async function getInfracoes() {
            try {
                const response = await api.get('/infracoes');
                setInfracoes([...infracoes, ...response.data]);
            } catch(e) {
                // alert(e.response.message);
            }
        }
        getInfracoes()
    }, [])

    async function handleCadastrarMulta(e) {        
        e.preventDefault();
        try {
            if (!selectInfracao || selectInfracao === '-1') throw new Error('Selecione uma infracao!');
            const response = await api.post('/ticket', {
                renavam,
                idinfracao: selectInfracao,
                datainfracao: data
            });
            alert('Multa cadastrada com sucesso!');
            console.log(response.data)
        } catch(e) {
            console.log('opa')
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
                <Title>Cadastrar multa</Title>
                <Form onSubmit={handleCadastrarMulta}>
                    <Label>Renavam:</Label>
                    <Input value={renavam} onChange={(e) => setRenavam(e.target.value)} type='text' placeholder='Renavam do carro' />
                    <Label>Tipo da infracao:</Label>
                    <Select value={selectInfracao}  onChange={(e) => setSelectInfracao(e.target.value)}>
                        {infracoes.map(infracao => (
                            <option value={infracao.idinfracao} key={infracao.idinfracao}>{infracao.descricao}</option>
                        ))}
                    </Select>
                    <Label>Data da infracao: </Label>
                    <Input type='date' value={data} onChange={(e) => setData(e.target.value)} />
                    <button>Cadastrar</button>
                </Form>
            </Main>
        </>
    );
}