const Category = require("../model/Categorymodel");

module.exports.createCategory = async (req, res) => {
  try {
    const { name, description } = req.body;
    const category = new Category({ name, description });
    await category.save();
    console.log("category created");
    res.status(201).json(category);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

module.exports.getAllCategories = async (req, res) => {
  try {
    const categories = await Category.find();
    res.json(categories);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports.getCategoryById = async (req, res) => {
  try {
    const category = await Category.findById(req.params.id);
    if (!category) return res.status(404).json({ error: "Category not found" });
    res.json(category);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports.updateCategory = async (req, res) => {
  try {
    const { name, description } = req.body;
    const { CategoryId } = req.params;
    console.log(CategoryId);
    
    const category = await Category.findByIdAndUpdate(
      CategoryId,
      { name, description, updatedAt: Date.now() },
      { new: true, runValidators: true }
    );
    if (!category) return res.status(404).json({ error: "Category not found" });
    res.json(category);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

module.exports.deleteCategory = async (req, res) => {
  try {
    const { CategoryId } = req.params;
    const category = await Category.findByIdAndDelete(CategoryId);
    console.log(CategoryId);
    if (!category) return res.status(404).json({ error: "Category not found" });
    res.json({ message: "Category deleted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
