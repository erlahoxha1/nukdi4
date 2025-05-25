const express = require("express");
const productRouter = express.Router();
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");

// 🔹 Get products by category
productRouter.get("/api/products", auth, async (req, res) => {
  try {
    const categoryId = req.query.categoryId;

    let products;
    if (categoryId) {
      products = await Product.find({ categoryId: categoryId });
    } else {
      products = await Product.find({});
    }

    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


// 🔹 Search products by name
productRouter.get("/api/products/search/:name", auth, async (req, res) => {
  try {
    const products = await Product.find({
      name: { $regex: req.params.name, $options: "i" },
    });

    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// 🔹 Rate a product
productRouter.post("/api/rate-product", auth, async (req, res) => {
  try {
    const { id, rating } = req.body;
    let product = await Product.findById(id);

    for (let i = 0; i < product.ratings.length; i++) {
      if (product.ratings[i].userId == req.user) {
        product.ratings.splice(i, 1);
        break;
      }
    }

    const ratingSchema = {
      userId: req.user,
      rating,
    };

    product.ratings.push(ratingSchema);
    product = await product.save();
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// 🔹 Deal of the day
productRouter.get("/api/deal-of-day", auth, async (req, res) => {
  try {
    let products = await Product.find({});

    products = products.sort((a, b) => {
      let aSum = 0;
      let bSum = 0;

      for (let i = 0; i < a.ratings.length; i++) {
        aSum += a.ratings[i].rating;
      }

      for (let i = 0; i < b.ratings.length; i++) {
        bSum += b.ratings[i].rating;
      }
      return aSum < bSum ? 1 : -1;
    });

    res.json(products[0]);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// 🔹 NEW: Filter products by brand, model, and year
productRouter.get("/api/products/filter", auth, async (req, res) => {
  try {
    const { brand, model, year } = req.query;

    let filter = {};
    if (brand) filter["carBrand"] = brand;
    if (model) filter["carModel"] = model;
    if (year) filter["carYear"] = year;

    const products = await Product.find(filter);
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = productRouter;