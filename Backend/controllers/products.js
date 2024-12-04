const productsModel = require('../models/products');
const path = require('path');
const fs = require('fs');

// Create a new product
exports.createProduct = async (req, res) => {
    console.log('Request Body:', req.body);
  try {
    const { name, description, price, category_id, stock_quantity } = req.body;
    const image_url = req.file ? `/uploads/${req.file.filename}` : null;

    const productId = await productsModel.createProduct({
      name,
      description,
      price,
      category_id,
      stock_quantity,
      image_url,
    });
    console.log('Request Body:', req.body);

    res.status(201).json({ message: 'Product created successfully', productId });
    console.log('Request Body:', req.body);
  } catch (error) {
    console.error('Error creating product:', error);
    res.status(500).json({ error: error.message });
  }
};

// Get all products
exports.getAllProducts = async (req, res) => {
  try {
    // Fetch all products from the model
    const products = await productsModel.getAllProducts();

    // Map through products to add full image URL
    const fullUrlProducts = products.map(product => ({
      ...product, // Spread other product properties
      image_url: product.image_url
        ? `${req.protocol}://${req.get('host')}${product.image_url}`
        : null, // Handle cases where image_url is null or undefined
    }));

    // Send the modified products list with full image URLs
    res.status(200).json(fullUrlProducts);
  } catch (error) {
    console.error('Error fetching products:', error);
    res.status(500).json({ error: error.message });
  }
};


// Get a product by ID
exports.getProductById = async (req, res) => {
  try {
    const { id } = req.params;
    const product = await productsModel.getProductById(id);

    if (!product) {
      return res.status(404).json({ error: 'Product not found' });
    }

    res.status(200).json(product);
  } catch (error) {
    console.error('Error fetching product:', error);
    res.status(500).json({ error: error.message });
  }
};

// Update a product
exports.updateProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const updates = { ...req.body };

    if (req.file) {
      updates.image_url = `/uploads/${req.file.filename}`;
    }

    const success = await productsModel.updateProduct(id, updates);

    if (!success) {
      return res.status(404).json({ error: 'Product not found or no changes made' });
    }

    res.status(200).json({ message: 'Product updated successfully' });
  } catch (error) {
    console.error('Error updating product:', error);
    res.status(500).json({ error: error.message });
  }
};

// Delete a product
exports.deleteProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const success = await productsModel.deleteProduct(id);

    if (!success) {
      return res.status(404).json({ error: 'Product not found' });
    }

    res.status(200).json({ message: 'Product deleted successfully' });
  } catch (error) {
    console.error('Error deleting product:', error);
    res.status(500).json({ error: error.message });
  }
};
