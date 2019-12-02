import React, {useEffect, useState} from 'react';
import api from '../services/api';

import Navbar from '../components/Navbar/index';

import {
    Main,
    Form,
    Label,
    Input,
    Button,
    Multas,
    Multa,
    PagarButton
} from './styles';

export default function PagarMulta() {
    const [idcondutor, setIdCondutor] = useState('');
    const [multas, setMultas] = useState([]);

    async function getMultas(idCondutor) {
        try {
            const response = await api.get(`/ticket/condutor/${idcondutor}`);
            setMultas(response.data);
        } catch(e) {
            if (e.response) {
                alert(e.response.data.message);
            }
        }
    }

    async function handleMultas(e) {
        e.preventDefault();
        getMultas(idcondutor);
    }

    async function pagarMulta(idMulta) {
        try {
            const response = await api.post(`/ticket/pagamento/${idMulta}`);
            alert('Multa paga com sucesso!')
            getMultas(idcondutor);
        } catch(e) {

        }
    }

    return (
        <>
            <Navbar />
            <Main>
                <Form onSubmit={handleMultas}>
                    <Label>
                        Id do condutor:
                    </Label>
                    <Input type='number' value={idcondutor} onChange={(e) => setIdCondutor(e.target.value)} placeholder='Id de cadastro'/>
                    <Button>Procurar</Button>
                </Form>
                <Multas>
                    {multas.map(multa => (
                        <Multa key={multa.idmulta}>
                            <h4>Multa no carro: {multa.renavam}</h4>
                            <p>Valor: {multa.valor}</p>
                            <p>Infracao: {multa.infracao}</p>
                            <p>Juros: {multa.juros}</p>
                            <span>Data da infracao: {multa.datainfracao.slice(0, 10)}. Data do vencimento: {multa.datavencimento.slice(0, 10)}</span>
                            <p>Paga: {multa.pago}</p>
                            {multa.valorfinal !== '0' ? (<p>Valor pago: R$: {multa.valorfinal.toLocaleString('pt-br')}</p>) : ''}
                            {multa.pago === 'N' ? <PagarButton onClick={() => pagarMulta(multa.idmulta)}>Pagar</PagarButton> : ''}
                            {multa.datapagamento ? (<p>Data pagamento: {multa.datapagamento.slice(0, 10)}</p>) : ''}
                        </Multa>
                    ))}
                </Multas>
            </Main>
        </>
    );
}
