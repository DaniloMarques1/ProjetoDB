const { Pool } = require('pg')

const pool = new Pool({
  host: 'localhost',
  user: 'danilo',
  database: 'BaseNacionaldeTransito',
  password: '1234',
  port: '5433'
});

module.exports = pool;
