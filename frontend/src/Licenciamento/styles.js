import styled from 'styled-components';


export const Main = styled.main `
    display: table;
    margin: 0 auto;
    margin-top: 80px;
    margin-bottom: 10px;
    span {
        font-size: 14px;
    }
`

export const Table = styled.table `
    border-collapse: collapse;
    border-spacing: 0px;
    table, th, td
    {
    padding: 10px;
    border: 1px solid black;
    }
    th, td {
        font-size: 16px;
    }
`;

export const Title = styled.h2 `
    text-align: center;
    color: #677EB9;
    margin-bottom: 40px;
`;

export const InputRenavam = styled.div `
    display: block;
    margin: 10px 0;
    input {
        padding: 3px;
    }
    button {
        padding: 6px;
        margin-left: 3px;
        outline: none;
 
    }
`;

export const Procurar = styled.button `
        padding: 10px;
        margin-left: 3px;
        background-color: #677EB9;
        color: white;
        border: none;
        cursor: pointer;
`

export const Limpar = styled.button `
    background-color: #fff;
    cursor: pointer;
    border: 1px solid #677EB9;
`