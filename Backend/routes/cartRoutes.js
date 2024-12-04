const express = require('express');
const router = express.Router();
const db = require('../config/db'); // Import the initialized db connection



// POST /cart/add
router.post('/add', async (req, res) => {
    const { user_id, product_id, quantity } = req.body;
    
    try {
      const query = 'INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)';
      const [result] = await db.execute(query, [user_id, product_id, quantity]);
  
      res.status(200).json({ message: 'Product added to cart successfully', cart_id: result.insertId });
    } catch (error) {
      console.error('Error adding to cart:', error);
      res.status(500).json({ error: 'Error adding product to cart' });
    }
  });
  

// DELETE /cart/remove
router.delete('/remove', async (req, res) => {
    const { cart_id } = req.body;
  
    try {
      const query = 'DELETE FROM cart WHERE cart_id = ?';
      await db.execute(query, [cart_id]);
  
      res.status(200).json({ message: 'Product removed from cart successfully' });
    } catch (error) {
      console.error('Error removing from cart:', error);
      res.status(500).json({ error: 'Error removing product from cart' });
    }
  });
  
  // GET /cart
router.get('/all', async (req, res) => {
    const { user_id } = req.query;
  
    try {
      const query = 'SELECT * FROM cart WHERE user_id = ?';
      const [cartItems] = await db.execute(query, [user_id]);
  
      res.status(200).json(cartItems);
    } catch (error) {
      console.error('Error fetching cart:', error);
      res.status(500).json({ error: 'Error fetching user cart' });
    }
  });
 
  module.exports = router;