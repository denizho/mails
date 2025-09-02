module.exports = {
    client: 'pg',
    connection: {
        host: 'localhost',
        user: 'postgres',
        password: 'postgres',
        database: 'mails',
    },
    pool: { min: 0, max: 7 },
};