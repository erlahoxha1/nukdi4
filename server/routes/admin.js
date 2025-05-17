const express = require('express');
const adminRouter = express.Router();
const admin = require('../middlewares/admin');
const Product = require('../models/product'); // ✅ import model

// Add product
adminRouter.post('/admin/add-product', admin, async (req, res) => {
  try {
    const { name, description, images, quantity, price, category } = req.body;

    const product = new Product({
      name,
      description,
      images,
      quantity,
      price,
      category,
    });

    const savedProduct = await product.save();
    res.status(201).json(savedProduct);
  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
});

// Get all products
adminRouter.get('/admin/get-products', admin, async (req, res) => {
  try {
    const products = await Product.find({});
    res.json(products);
  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
});

adminRouter.post('/admin/delete-product', admin, async (req, res) => {
  const { id } = req.body;
  console.log("🟥 Incoming delete request ID:", id);

  if (!id) {
    return res.status(400).json({ error: 'No ID provided' });
  }

  const product = await Product.findByIdAndDelete(id);
  if (!product) {
    return res.status(404).json({ error: 'Product not found' });
  }

  res.json({ message: 'Deleted', deleted: product });
});



module.exports = adminRouter;