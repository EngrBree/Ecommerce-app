const express = require('express');

const router = express.Router();
const productController = require("../controllers/products");
const categoryController = require("../controllers/categories")
const db = require('../config/db'); 
const multer = require('multer');
const path = require('path');



// Configure multer for file uploads
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
      cb(null, path.join(__dirname, '../public/uploads'));
    },
    filename: (req, file, cb) => {
      cb(null, `${Date.now()}-${file.originalname}`);
    },
  });
  
  const upload = multer({ storage });
  
  // Routes
  router.post('/add', upload.single('image'), productController.createProduct);
  router.get('/all', productController.getAllProducts);
  router.get('/one:id', productController.getProductById);
  router.put('/edit:id', upload.single('image'), productController.updateProduct);
  router.delete('/delete:id', productController.deleteProduct);



router.get('/allCategories', async (req, res) => {
    try {
        const connection = await db; // Wait for the DB connection
        const [rows] = await connection.execute('SELECT category_id, category_name FROM categories');
        if (rows.length === 0) {
            return res.status(404).json({ error: 'No categories found' });
        }
        res.json(rows); 
    } catch (error) {
        console.error('Error fetching categories:', error);
        res.status(500).json({ error: 'Failed to fetch categories' });
    }
});




router.post('/addcategories', categoryController.addCategory);


module.exports=router;