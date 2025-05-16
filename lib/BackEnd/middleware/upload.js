const multer = require("multer");
const { CloudinaryStorage } = require("multer-storage-cloudinary");
const cloudinary = require("../utils/Cloudinary");

const storage = new CloudinaryStorage({
  cloudinary,
  params: {
    folder: "intellReview_research_paper",
    resource_type: "raw",
    format: async (req, file) => "pdf",
    public_id: (req, file) => `${Date.now()}-${file.originalname}`,
    access_mode: "public",
  },
});

const upload = multer({
  storage,
  fileFilter: (req, file, cb) => {
    // Allow only PDFs
    cb(null, file.mimetype === "application/pdf");
  },
  limits: { fileSize: 10 * 1024 * 1024 },
});

module.exports = upload;
