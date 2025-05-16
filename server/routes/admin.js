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

module.exports = adminRouter;
