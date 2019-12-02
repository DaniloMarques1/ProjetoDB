import styled from 'styled-components';

export const Form = styled.form `
    width: 500px;
    border-radius: 4px;
    padding: 50px 40px;
    background-color: #677EB9;
`;

export const Label = styled.label `
    color: white;
    font-size: 16px;
    margin-bottom: 4px;
    text-align: center;
`;

export const Input = styled.input `
    display: block;
    width: 100%;
    text-align: center;
    padding: 5px;
`;

export const Button = styled.button `
    width: 100%;
    text-align: center;
    background-color: #fff;
    color: #677EB9;
    border: none;
    padding: 5px;
    margin-top: 4px;
    cursor: pointer;
    font-weight: bold;

    :hover {
        background-color: #B0C2F0;
        transition: all .3s;
    }
`;

export const Main = styled.main `
    margin-top: 40px;
    display: flex;
    justify-content: center;
    flex-direction: column;
    align-items: center;
`;

export const Multas = styled.div`
    margin-top: 50px;
`

export const Multa = styled.div `
    border: 1px solid #677EB9;
    padding: 12px;
    border-radius: 3px;
    margin-bottom: 10px;
`; 

export const PagarButton = styled.button `
    background-color: #84B67E;
    padding: 8px;
    border: 0;
    border-radius: 2px;
    display: block;
    cursor: pointer;
    color: white;
    font-weight: bold;
`;