const express = require("express");
const mongoose = require("mongoose");
require('dotenv').config();

// IMPORT ROUTES
const authRouter = require('./routes/auth');
const adminRouter = require('./routes/admin');
const productRouter = require('./routes/product');
const userRouter = require('./routes/user');
const categoryRouter = require('./routes/category');
const paypalRoutes = require('./routes/paypal');


const app = express();
const PORT = process.env.PORT || 3000;

// MongoDB connection
const DB = "mongodb+srv://emezuraj22:test123@cluster0.gksm89z.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

// MIDDLEWARE
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);
app.use("/api/categories", categoryRouter); 
app.use(paypalRoutes);
 // ✅ category routes under /api/categories

// CONNECTION
mongoose.connect(DB)
  .then(() => {
    console.log("MongoDB connection successful");
  })
  .catch((e) => {
    console.error("MongoDB connection error:", e);
  });

// SERVER START
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on port ${PORT}`);
});