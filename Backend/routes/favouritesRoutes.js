// routes/favouritesRoutes.js
const express = require('express');
const router = express.Router();
const db = require('../config/db');

// Add to Favorites route
router.post('/add', async (req, res) => {
  const { userId, productId } = req.body;

  if (!userId || !productId) {
    return res.status(400).json({ message: 'User ID and Product ID are required.' });
  }

  try {
    // Get the database connection
    const connection=await db;  // Calling the function to get the DB connection

    // Execute the query to insert the favorite
    const [rows] = await connection.execute(
      'INSERT INTO favorites (user_id, product_id) VALUES (?, ?)',
      [userId, productId]
    );

    // Respond with success message
    if (rows.affectedRows > 0) {
        const favoriteId = rows.insertId;
        res.status(200).json({
            message: 'Product added to favorites successfully!',
            favorite_id: favoriteId, // Include favoriteId in the response
          });
    } else {
      res.status(500).json({ message: 'Failed to add product to favorites.' });
    }

    // Close the database connection
    await db.end();
  } catch (error) {
    console.error('Error adding to favorites:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

module.exports = router;



  
  // DELETE /favorites/remove
router.delete('/remove', async (req, res) => {
    const { favorite_id } = req.body;
  
    try {
      const query = 'DELETE FROM favorites WHERE favorite_id = ?';
      await db.execute(query, [favorite_id]);
  
      res.status(200).json({ message: 'Product removed from favorites successfully' });
    } catch (error) {
      console.error('Error removing from favorites:', error);
      res.status(500).json({ error: 'Error removing product from favorites' });
    }
  });
  
// GET /favorites
router.get('/all', async (req, res) => {
    const { user_id } = req.query;
  
    try {
      const query = 'SELECT * FROM favorites WHERE user_id = ?';
      const [favoriteItems] = await db.execute(query, [user_id]);
  
      res.status(200).json(favoriteItems);
    } catch (error) {
      console.error('Error fetching favorites:', error);
      res.status(500).json({ error: 'Error fetching user favorites' });
    }
  });
  module.exports = router;