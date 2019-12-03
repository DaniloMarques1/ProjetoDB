import styled from 'styled-components';

export const Main = styled.main `
    display: flex;
    height: 100vh;
    margin-top: 80px;
    flex-direction: column;
    justify-content: center;
    align-items: center;
`;

export const Form = styled.form `
    width: 500px;
    padding: 70px 30px;
    background-color: #677EB9;
    color: white;
    border-radius: 6px;
    button {
        margin-top: 8px;
        padding: 10px;
        border: none;
        background-color: #fff;
        cursor: pointer;
        color: #677EB9;
        font-weight: bold;
        width: 100%;
    }

    button:hover {
        background-color: #B0C2F0;
        transition: all .3s;
    }
`;

export const Label = styled.label `
    font-size: 16px;
    margin-top: 2px;
    margin-bottom: 2px;
`;

export const Input = styled.input `
    padding: 7px;
    width: 100%;
    margin-bottom: 5px;
`

export const Select = styled.select `
    width: 100%;
    padding: 4px;
    margin-bottom: 5px;
    border: none;
    background-color: #fff;
`;

export const Title = styled.h2 `
    margin-bottom: 20px;
    color: #677EB9;
`;