const jwt = require("jsonwebtoken");
const User = require("../models/user");

const admin = async (req, res, next) => {
  try {
    const token = req.get('x-auth-token'); // ✅ FIXED
    if (!token) {
      return res.status(401).json({ message: 'No token provided' });
    }

    const verified = jwt.verify(token, "passwordKey");
    if (!verified) {
      return res.status(401).json({ message: 'Token verification failed' });
    }

    const user = await User.findById(verified.id);
    if (user.type === 'user') {
      return res.status(401).json({ message: 'You are not an admin!' });
    }

    req.user = verified.id;
    req.token = token;
    next();

  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
};

module.exports = admin;