const express = require("express");
const userRouter = express.Router();
const auth = require("../middlewares/auth");
const Order = require("../models/order");
const { Product } = require("../models/product");
const User = require("../models/user");

// ✅ Add to cart
userRouter.post("/api/add-to-cart", auth, async (req, res) => {
  try {
    const { id, quantity } = req.body;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    const existingItemIndex = user.cart.findIndex((item) =>
      item.product._id.equals(product._id)
    );

    const incomingQuantity = Number(quantity) || 1;

    if (existingItemIndex >= 0) {
      user.cart[existingItemIndex].quantity =
        Number(user.cart[existingItemIndex].quantity || 0) + incomingQuantity;
    } else {
      user.cart.push({ product, quantity: incomingQuantity });
    }

    user = await user.save();
    res.json(user);
  } catch (e) {
    console.error('❌ Error in add-to-cart:', e);
    res.status(500).json({ error: e.message });
  }
});

// ✅ Remove from cart
userRouter.delete("/api/remove-from-cart/:id", auth, async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    for (let i = 0; i < user.cart.length; i++) {
      if (user.cart[i].product._id.equals(product._id)) {
        if (user.cart[i].quantity == 1) {
          user.cart.splice(i, 1);
        } else {
          user.cart[i].quantity = Number(user.cart[i].quantity || 0) - 1;
        }
      }
    }

    user = await user.save();
    res.json(user);
  } catch (e) {
    console.error('❌ Error in remove-from-cart:', e);
    res.status(500).json({ error: e.message });
  }
});

// ✅ Save user address
userRouter.post("/api/save-user-address", auth, async (req, res) => {
  try {
    const { address } = req.body;
    let user = await User.findById(req.user);
    user.address = address;
    user = await user.save();
    res.json(user);
  } catch (e) {
    console.error('❌ Error in save-user-address:', e);
    res.status(500).json({ error: e.message });
  }
});

// ✅ Place real order (with cart check)
userRouter.post("/api/order", auth, async (req, res) => {
  try {
    const { cart, totalPrice, address } = req.body;
    let products = [];

    for (let i = 0; i < cart.length; i++) {
      let product = await Product.findById(cart[i].product._id);
      const orderedQuantity = Number(cart[i].quantity) || 0;

      if (product.quantity >= orderedQuantity) {
        product.quantity -= orderedQuantity;
        products.push({ product, quantity: orderedQuantity });
        await product.save();
      } else {
        return res
          .status(400)
          .json({ msg: `${product.name} is out of stock!` });
      }
    }

    let user = await User.findById(req.user);
    user.cart = [];
    user = await user.save();

    let order = new Order({
      products,
      totalPrice,
      address,
      userId: req.user,
      orderedAt: new Date().getTime(),
    });
    order = await order.save();
    res.json(order);
  } catch (e) {
    console.error('❌ Error in order:', e);
    res.status(500).json({ error: e.message });
  }
});

// ✅ Get user orders
userRouter.get("/api/orders/me", auth, async (req, res) => {
  try {
    const orders = await Order.find({ userId: req.user });
    res.json(orders);
  } catch (e) {
    console.error('❌ Error in get-orders:', e);
    res.status(500).json({ error: e.message });
  }
});

// ✅ FAKE PayPal save-order endpoint (fixed)
// ✅ FAKE PayPal save-order endpoint (Option B)
userRouter.post("/api/save-order", auth, async (req, res) => {
  try {
    const { totalPrice, address, status, orderedAt } = req.body;

    // 1️⃣ Pull the user WITH their cart (products already embedded)
    let user = await User.findById(req.user).populate("cart.product");

    // 2️⃣ Reduce stock for every item in the cart
    for (const item of user.cart) {
      const product = await Product.findById(item.product._id);

      if (product.quantity < item.quantity) {
        return res
          .status(400)
          .json({ msg: `${product.name} is out of stock or insufficient quantity!` });
      }

      product.quantity -= item.quantity;
      await product.save();
    }

    // 3️⃣ Create the order using the cart we just processed
    const order = await new Order({
      userId:   req.user,
      products: user.cart,       // same schema shape
      totalPrice,
      address,
      status,                    // e.g. 1 (Paid)
      orderedAt,
    }).save();

    // 4️⃣ Clear the cart after successful “payment”
    user.cart = [];
    await user.save();

    res.json(order);
  } catch (e) {
    console.error("❌ Error in save-order:", e);
    res.status(500).json({ error: e.message });
  }
});


module.exports = userRouter;