const express = require("express");
const router = express.Router();
const {
  createCategory,
  getAllCategories,
  getCategoryById,
  updateCategory,
  deleteCategory,
} = require("../controller/Categorycontroller");

router.post("/createCategory", createCategory);
router.get("/getalCategory", getAllCategories);
router.get("/getsingleCategory/:CategoryId", getCategoryById);
router.put("/updateCategory/:CategoryId", updateCategory);
router.delete("/deleteCategory/:CategoryId", deleteCategory);

module.exports = router;
