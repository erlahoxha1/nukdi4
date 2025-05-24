const express = require('express');
const multer = require('multer');
const { v4: uuid } = require('uuid');
const Category = require('../models/category');
const { uploadToCloudinary } = require('../utils/cloudinary');

const categoryRouter = express.Router();  // ✅ renamed to categoryRouter
const upload = multer({ storage: multer.memoryStorage() });

// ✅ GET all categories
categoryRouter.get('/', async (req, res) => {
  try {
    const categories = await Category.find().sort('name');
    res.json(categories);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch categories', details: err.message });
  }
});

// ✅ POST create a new category (with image upload)
categoryRouter.post('/', upload.single('image'), async (req, res) => {
  try {
    const { name } = req.body;
    if (!name) return res.status(400).json({ error: 'Category name is required' });
    if (!req.file) return res.status(400).json({ error: 'Image file is required' });

    const { secure_url } = await uploadToCloudinary(req.file.buffer, `categories/${uuid()}`);

    const cat = new Category({ name, imageUrl: secure_url });
    await cat.save();

    res.status(201).json(cat);
  } catch (err) {
    res.status(500).json({ error: 'Failed to create category', details: err.message });
  }
});

// ✅ DELETE a category by ID
categoryRouter.delete('/:id', async (req, res) => {
  try {
    const deleted = await Category.findByIdAndDelete(req.params.id);
    if (!deleted) return res.status(404).json({ error: 'Category not found' });

    res.sendStatus(204);
  } catch (err) {
    res.status(500).json({ error: 'Failed to delete category', details: err.message });
  }
});

module.exports = categoryRouter;  // ✅ consistent export
