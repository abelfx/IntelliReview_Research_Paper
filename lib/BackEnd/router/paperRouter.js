const express = require("express");
const router = express.Router();
const upload = require("../middleware/upload");
const {
  uploadPaper,
  deletePaper,
  updatePaper,
  viewPaper,
} = require("../controller/Papercontroller");

router.post("/upload", upload.single("pdf"), uploadPaper);
router.delete("/delete/:id", deletePaper);
router.put("/update/:id", upload.single("pdf"), updatePaper);
router.get("/viewPapers", viewPaper);

module.exports = router;
