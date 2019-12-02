const express = require('express');
const server = express();
const routes = require('./routes');
const cors = require('cors');

server.use(cors());
server.use(express.json());
server.use(routes);

server.listen(5000);