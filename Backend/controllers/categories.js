const dbPromise = require('../config/db');

// Add new category
exports.addCategory = async (req, res) => {
  try {
    const { category_name, description } = req.body;

    if (!category_name || typeof category_name !== 'string') {
      return res.status(400).json({ error: 'Category name is required and must be a string.' });
    }

    const db = await dbPromise; // Wait for the database connection
    const query = 'INSERT INTO categories (category_name, description) VALUES (?, ?)';
    const [result] = await db.execute(query, [category_name, description || null]);

    res.status(201).json({ message: 'Category created successfully', categoryId: result.insertId });
  } catch (error) {
    console.error('Error adding category:', error);
    res.status(500).json({ error: error.message });
  }
};
