const express = require("express");
const adminRouter = express.Router();
const admin = require("../middlewares/admin");
const { Product } = require("../models/product");
const Category = require("../models/category");
const Order = require("../models/order");
const { body, validationResult } = require("express-validator");

// ================================
// Add Product
// ================================
adminRouter.post(
  "/admin/add-product",
  admin,
  [
    body("name").notEmpty(),
    body("description").notEmpty(),
    body("images").isArray({ min: 1 }),
    body("quantity").isFloat({ gt: 0 }),
    body("price").isFloat({ gt: 0 }),
    body("category").notEmpty(),
    body("carBrand").notEmpty(),
    body("carModel").notEmpty(),
    body("carYear").notEmpty(),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty())
      return res.status(400).json({ errors: errors.array() });

    try {
      const {
        name,
        description,
        images,
        quantity,
        price,
        category,
        carBrand,
        carModel,
        carYear,
      } = req.body;

      const categoryDoc = await Category.findById(category);
      if (!categoryDoc)
        return res.status(404).json({ error: "Category not found" });

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

// ================================
// Get All Products
// ================================
adminRouter.get("/admin/get-products", admin, async (req, res) => {
  try {
    const products = await Product.find({});
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ================================
// Delete Product
// ================================
adminRouter.post("/admin/delete-product", admin, async (req, res) => {
  try {
    const { id } = req.body;
    const deletedProduct = await Product.findByIdAndDelete(id);
    res.json(deletedProduct);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ================================
// Get All Orders (ADMIN) ✅ FIXED
// ================================
adminRouter.get("/admin/get-orders", admin, async (req, res) => {
  try {
    const orders = await Order.find({}).populate("products.product");
    res.json(orders);
  } catch (e) {
    console.error("❌ Error in admin get-orders:", e);
    res.status(500).json({ error: e.message });
  }
});

// ================================
// Change Order Status
// ================================
adminRouter.post("/admin/change-order-status", admin, async (req, res) => {
  try {
    const { id, status } = req.body;

    const order = await Order.findById(id);
    if (!order) {
      return res.status(404).json({ msg: "Order not found" });
    }

    order.status = status;
    await order.save();

    res.json({ msg: "Order status updated", order });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ================================
// Get Analytics
// ================================
adminRouter.get("/admin/analytics", admin, async (req, res) => {
  try {
    let totalEarnings = 0;

    const earnings = await Order.aggregate([
      { $unwind: "$products" },
      {
        $group: {
          _id: "$products.product.categoryName",
          totalSales: {
            $sum: {
              $multiply: ["$products.quantity", "$products.product.price"]
            }
          }
        }
      }
    ]);

    earnings.forEach((e) => totalEarnings += e.totalSales);

    res.json({
      totalEarnings,
      sales: earnings.map(e => ({
        label: e._id || "Unknown",
        earning: e.totalSales
      }))
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = adminRouter;
