const mysql = require('mysql2');
const dotenv = require('dotenv');

dotenv.config();

// Create connection pool
const pool = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'library_db',
    port: process.env.DB_PORT || 3306,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Test connection
pool.getConnection((err, connection) => {
    if (err) {
        console.error('Error connecting to database:', err.message);
        console.log('Please make sure:');
        console.log('1. MySQL is running');
        console.log('2. Database credentials in .env are correct');
        console.log('3. Database "library_db" exists (or create it)');
    } else {
        console.log('✓ Database connected successfully');
        connection.release();
    }
});

// Export promise-based pool
module.exports = pool.promise();

