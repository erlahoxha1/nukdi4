const jwt = require('jsonwebtoken');

const auth = async (req, res, next) => {
    try {
        const token = req.headers('x-auth-token');
        if (!token) {
        return res.status(401).json({ message: 'No token provided' });
        }

        const verified = jwt.verify(token, "passwordKey");
        if (!verified) { return res.status(401).json({ message: 'Token verification failed' }); }

        req.user = verified.id;
        req.token = token;
        next();
    
    } catch (err) {
        return res.status(500).json({ error: err.message });
    }
    
};

module.exports = auth;