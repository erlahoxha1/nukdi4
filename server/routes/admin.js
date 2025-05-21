const express = require("express");
const adminRouter = express.Router();
const admin = require("../middlewares/admin");
const { Product } = require("../models/product");
const Order = require("../models/order");
const { body, validationResult } = require("express-validator"); // ✅ Added for validation

// ✅ Add product with validation
adminRouter.post(
  "/admin/add-product",
  admin,
  [
    body("name").notEmpty().withMessage("Product name is required"),
    body("description").notEmpty().withMessage("Description is required"),
    body("images").isArray({ min: 1 }).withMessage("At least one image is required"),
    body("quantity").isFloat({ gt: 0 }).withMessage("Quantity must be greater than 0"),
    body("price").isFloat({ gt: 0 }).withMessage("Price must be greater than 0"),
    body("category").notEmpty().withMessage("Category is required"),
    body("carBrand").notEmpty().withMessage("Car brand is required"),
    body("carModel").notEmpty().withMessage("Car model is required"),
    body("carYear").notEmpty().withMessage("Car year is required"),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

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

      let product = new Product({
        name,
        description,
        images,
        quantity,
        price,
        category,
        carBrand,
        carModel,
        carYear,
      });

      product = await product.save();
      res.json(product);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  }
);

// ✅ Get all your products
adminRouter.get("/admin/get-products", admin, async (req, res) => {
  try {
    const products = await Product.find({});
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ✅ Delete the product
adminRouter.post("/admin/delete-product", admin, async (req, res) => {
  try {
    const { id } = req.body;
    let product = await Product.findByIdAndDelete(id);
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ✅ Get all orders
adminRouter.get("/admin/get-orders", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    res.json(orders);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ✅ Change order status
adminRouter.post("/admin/change-order-status", admin, async (req, res) => {
  try {
    const { id, status } = req.body;
    let order = await Order.findById(id);
    order.status = status;
    order = await order.save();
    res.json(order);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ✅ Analytics
adminRouter.get("/admin/analytics", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    let totalEarnings = 0;

    for (let i = 0; i < orders.length; i++) {
      for (let j = 0; j < orders[i].products.length; j++) {
        totalEarnings +=
          orders[i].products[j].quantity *
          orders[i].products[j].product.price;
      }
    }

    let controllerEarnings = await fetchCategoryWiseProduct("Controller");
    let evChargerEarnings = await fetchCategoryWiseProduct("EV Charger");
    let motorEarnings = await fetchCategoryWiseProduct("Motor");
    let chargerEarnings = await fetchCategoryWiseProduct("Charger");
    let batteryEarnings = await fetchCategoryWiseProduct("Battery");

    let earnings = {
      totalEarnings,
      controllerEarnings,
      evChargerEarnings,
      motorEarnings,
      chargerEarnings,
      batteryEarnings,
    };

    res.json(earnings);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

async function fetchCategoryWiseProduct(category) {
  let earnings = 0;
  let categoryOrders = await Order.find({
    "products.product.category": category,
  });

  for (let i = 0; i < categoryOrders.length; i++) {
    for (let j = 0; j < categoryOrders[i].products.length; j++) {
      earnings +=
        categoryOrders[i].products[j].quantity *
        categoryOrders[i].products[j].product.price;
    }
  }
  return earnings;
}

module.exports = adminRouter;
