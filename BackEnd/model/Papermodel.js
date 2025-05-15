const mongoose = require("mongoose");

const paperSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
  },
  authors: {
    type: [String],
    required: true,
  },
  year: {
    type: Number,
    required: true,
    default: 0,
  },
  pdfUrl: {
    type: String,
    required: true,
  },
  // Store uploader name or identifier as plain string (optional)
  uploadedBy: {
    type: String,
    default: "",
  },
  category: {
    type: String,
    default: "",
  },
  averageRating: {
    type: Number,
    default: 0,
    required: true,
  },
  reviewCount: {
    type: Number,
    default: 0,
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
    required: true,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
    required: true,
  },
});

module.exports = mongoose.model("Paper", paperSchema);
