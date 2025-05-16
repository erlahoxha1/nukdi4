const express = require('express');
const adminRouter = express.Router();
const admin = require('../middlewares/admin');

//add product
adminRouter.post('/admin/add-product', admin, async (req, res) => {
  try {
    //they should match to product
    const { name, descriptions, images, quantity, price, category } = req.body;
    let product = new Product({
      name,
      descriptions,
      images,
      quantity,
      price,
      category
    });
    product = await product.save();
    res.json(product);
  }
  catch(err) {
    return res.status(500).json({ error: err.message });
  }
});
