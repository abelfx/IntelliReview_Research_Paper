const express = require("express");
const router = express.Router();
const stats = require("../controller/admincontroller");

router.get("/stats", stats);

module.exports = router;
