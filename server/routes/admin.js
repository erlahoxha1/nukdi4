const express = require("express");
const adminRouter = express.Router();
const admin = require("../middlewares/admin");
const { Product } = require("../models/product");
const Category = require("../models/category");
const Order = require("../models/order");
const { body, validationResult } = require("express-validator");

// Add product (store categoryId + categoryName)
adminRouter.post(
  "/admin/add-product",
  admin,
  [
    body("name").notEmpty(),
    body("description").notEmpty(),
    body("images").isArray({ min: 1 }),
    body("quantity").isFloat({ gt: 0 }),
    body("price").isFloat({ gt: 0 }),
    body("category").notEmpty(), // categoryId
    body("carBrand").notEmpty(),
    body("carModel").notEmpty(),
    body("carYear").notEmpty(),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });

    try {
      const {
        name, description, images, quantity, price,
        category, carBrand, carModel, carYear,
      } = req.body;

      const categoryDoc = await Category.findById(category);
      if (!categoryDoc) return res.status(404).json({ error: "Category not found" });

      const product = new Product({
        name,
        description,
        images,
        quantity,
        price,
        categoryId: category,
        categoryName: categoryDoc.name,
        carBrand,
        carModel,
        carYear,
      });

      const savedProduct = await product.save();
      res.json(savedProduct);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  }
);

adminRouter.get("/admin/get-products", admin, async (req, res) => {
  try {
    const products = await Product.find({});
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

adminRouter.post("/admin/delete-product", admin, async (req, res) => {
  try {
    const { id } = req.body;
    const deletedProduct = await Product.findByIdAndDelete(id);
    res.json(deletedProduct);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = adminRouter;