import styled from 'styled-components';

export const Nav = styled.nav `
    display: flex;
    padding: 10px;
    background-color: #677EB9;
    h2 {
        color: white;
    }
    div {
       align-self: center;
       margin-left: auto;
    }
    div ul li{
        display: inline;
        margin: 4px;
        
    }
    div ul li a{
        color: white;
    }
`;