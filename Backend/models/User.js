const db = require('../config/db');

class User {
    static async findUserByEmail(email) {
        try {
            // Wait for the database connection to be established
            const connection = await db; 
            const [results] = await connection.execute('SELECT * FROM users WHERE email = ?', [email]);
            return results[0]; // Return the first result (user)
        } catch (err) {
            throw err;
        }
    }

    static async createUser(username, email, password_hash, role) {
        try {
            // Wait for the database connection to be established
            const connection = await db;
            const [results] = await connection.execute(
                'INSERT INTO users (username, email, password_hash, role) VALUES (?, ?, ?, ?)', 
                [username, email, password_hash, role]
            );
            return results.insertId; // Return the inserted user ID
        } catch (err) {
            throw err;
        }
    }
}

module.exports = User;
