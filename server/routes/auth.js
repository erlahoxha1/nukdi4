const express = require("express");
const User = require("../models/user");
const bcryptjs = require("bcryptjs");
const authRouter = express.Router();
const jwt = require("jsonwebtoken");
const auth = require("../middlewares/auth");

// SIGN UP
authRouter.post("/api/signup", async (req, res) => {
  try {
    const { firstName, lastName, email, password, phone } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ msg: "User with same email already exists!" });
    }

    const hashedPassword = await bcryptjs.hash(password, 8);

    let user = new User({
      firstName,
      lastName,
      name: `${firstName} ${lastName}`,
      email,
      password: hashedPassword,
      phone,
    });

    user = await user.save();
    res.json({ ...user._doc, name: `${user.firstName} ${user.lastName}` });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// SIGN IN
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ msg: "User with this email does not exist!" });
    }

    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Incorrect password." });
    }

    const token = jwt.sign({ id: user._id }, "passwordKey");
    res.json({ token, ...user._doc, name: `${user.firstName} ${user.lastName}` });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// VALIDATE TOKEN
authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);
    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// GET USER
authRouter.get("/", auth, async (req, res) => {
  const user = await User.findById(req.user);
  res.json({
    ...user._doc,
    name: `${user.firstName} ${user.lastName}`,
    token: req.token,
  });
});

// UPDATE PROFILE
authRouter.put("/api/update-profile", auth, async (req, res) => {
  try {
    const { firstName, lastName, email, phone } = req.body;
    const fullName = `${firstName} ${lastName}`;

    const updatedUser = await User.findByIdAndUpdate(
      req.user,
      {
        firstName,
        lastName,
        name: fullName,
        email,
        phone,
      },
      { new: true }
    );

    res.json({
      ...updatedUser._doc,
      name: `${updatedUser.firstName} ${updatedUser.lastName}`,
      token: req.token,
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ✅ UPDATE ADDRESS
authRouter.put("/api/update-address", auth, async (req, res) => {
  try {
    const { address } = req.body;

    const updatedUser = await User.findByIdAndUpdate(
      req.user,
      { address },
      { new: true }
    );

    res.json({
      ...updatedUser._doc,
      name: `${updatedUser.firstName} ${updatedUser.lastName}`,
      token: req.token,
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = authRouter;
