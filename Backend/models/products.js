const db = require('../config/db'); // Import the initialized db connection

// Create a new product
exports.createProduct = async (product) => {
  const { name, description, price, category_id, stock_quantity, image_url } = product;
  const query = `
    INSERT INTO products (name, description, price, category_id, stock_quantity, image_url)
    VALUES (?, ?, ?, ?, ?, ?)
  `;
  try {
    const connection = await db;  // Wait for the DB connection to resolve
    const [result] = await connection.execute(query, [
      name,
      description || null,
      price,
      category_id || null,
      stock_quantity || 0,
      image_url || null,
    ]);
    return result.insertId;
  } catch (error) {
    console.error('Error creating product:', error);
    throw error;
  }
};

/// Get all products with category names
// Get all products with category names
exports.getAllProducts = async () => {
  const query = `
    SELECT p.product_id, p.name, p.price, p.image_url, c.category_name
    FROM products p
    JOIN categories c ON p.category_id = c.category_id;
  `;
  try {
    const connection = await db;  // Wait for the DB connection to resolve
    const [rows] = await connection.execute(query);  // Execute the query
    return rows;  // Return the rows (products with category_name)
  } catch (error) {
    console.error('Error fetching all products:', error);
    throw error;  // Propagate the error
  }
};


// Get a single product by ID
exports.getProductById = async (product_id) => {
  const query = 'SELECT * FROM products WHERE product_id = ?';
  try {
    const connection = await db;  // Wait for the DB connection to resolve
    const [rows] = await connection.execute(query, [product_id]);
    return rows[0];  // Return the first row (product)
  } catch (error) {
    console.error('Error fetching product by ID:', error);
    throw error;
  }
};

// Update a product
exports.updateProduct = async (product_id, updates) => {
  const { name, description, price, category_id, stock_quantity, image_url } = updates;
  const query = `
    UPDATE products
    SET name = ?, description = ?, price = ?, category_id = ?, stock_quantity = ?, image_url = ?
    WHERE product_id = ?
  `;
  try {
    const connection = await db;  // Wait for the DB connection to resolve
    const [result] = await connection.execute(query, [
      name,
      description,
      price,
      category_id,
      stock_quantity,
      image_url,
      product_id,
    ]);
    return result.affectedRows > 0;  // Return whether the update was successful
  } catch (error) {
    console.error('Error updating product:', error);
    throw error;
  }
};

// Delete a product
exports.deleteProduct = async (product_id) => {
  const query = 'DELETE FROM products WHERE product_id = ?';
  try {
    const connection = await db;  // Wait for the DB connection to resolve
    const [result] = await connection.execute(query, [product_id]);
    return result.affectedRows > 0;  // Return whether the deletion was successful
  } catch (error) {
    console.error('Error deleting product:', error);
    throw error;
  }
};
