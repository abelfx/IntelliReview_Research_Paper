const express = require("express");
const router = express.Router();
const {
  createNotification,
  getallNotification,
} = require("../controller/Notificationcontroller");

router.post("/createNotification", createNotification);
router.get("/getAllNotification", getallNotification);

module.exports = router;
