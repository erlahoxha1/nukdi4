const express = require('express');
const multer = require('multer');
const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');

const router = express.Router();

// Configure multer to store uploads in 'uploads/' folder
const upload = multer({ dest: 'uploads/' });

// POST /api/predict
router.post('/api/predict', upload.single('image'), (req, res) => {
    if (!req.file) {
        return res.status(400).json({ error: 'No image uploaded' });
    }

    const imagePath = path.resolve(req.file.path);

    const python = spawn('python', ['predict.py', imagePath]);

    let result = '';
    python.stdout.on('data', (data) => {
        result += data.toString();
    });

    python.stderr.on('data', (data) => {
        console.error(`Python error: ${data}`);
    });

    python.on('close', (code) => {
        console.log(`Python process exited with code ${code}`);

        fs.unlinkSync(imagePath); // cleanup

        try {
            const jsonResult = JSON.parse(result);
            res.json(jsonResult);
        } catch (err) {
            res.status(500).json({ error: 'Failed to parse Python output' });
        }
    });
});

module.exports = router;
