const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

exports.signup = async (req, res) => {
    try {
        const { username, email, password, role = 'customer' } = req.body;

        // Validate role
        if (!['customer', 'admin'].includes(role)) {
            return res.status(400).json({ message: 'Invalid role specified' });
        }

        // Check if the user already exists
        const existingUser = await User.findUserByEmail(email);
        if (existingUser) {
            return res.status(400).json({ message: 'User with this email already exists' });
        }

        // Hash the password
        const hashedPassword = await bcrypt.hash(password, 10);

        // Create the user with the specified role
        const userId = await User.createUser(username, email, hashedPassword, role);

        // Generate a JWT token
        const token = jwt.sign({ userId, email, role }, process.env.JWT_SECRET, { expiresIn: '1h' });

        // Respond with the token and role
        res.status(201).json({ message: 'User registered successfully', token, role });
    } catch (error) {
        console.error('Error during signup:', error);
        res.status(500).json({ error: error.message });
    }
};

exports.signin = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ message: 'Email and password are required' });
        }

        // Fetch user by email
        const user = await User.findUserByEmail(email);

        if (user && await bcrypt.compare(password, user.password_hash)) {
            if (!process.env.JWT_SECRET) {
                console.error('JWT_SECRET is not defined');
                return res.status(500).json({ error: 'Server configuration error' });
            }

            // Generate a JWT token
            const token = jwt.sign(
                { userId: user.user_id, email: user.email, role: user.role },
                process.env.JWT_SECRET,
                { expiresIn: '1h' }
            );

            res.json({ 
                message: 'Login successful', 
                token, 
                role: user.role ,
                email:user.email,
                id:user.user_id

            });
        } else {
            res.status(401).json({ message: 'Invalid email or password' });
        }
    } catch (error) {
        console.error('Error during signin:', error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
