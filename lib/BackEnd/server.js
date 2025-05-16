require("dotenv").config();
const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");

const authRouter = require("./router/authRouter");
const paperRouter = require("./router/paperRouter");
const reviewRouter = require("./router/ReviewRouter");
const categoryRouter = require("./router/CategoryRouter");
const notificationRouter = require("./router/NotificationRouter");
const adminRouter = require("./router/adminRouter");
const { MongoDBconfig } = require("./utils/mongoconfig");

const app = express();

// 1) Parse JSON bodies
app.use(express.json());

// 2) Parse URL‑encoded form bodies
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// 3) Enable CORS if needed
app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST", "PUT", "DELETE"],
    credentials: true,
  })
);

// 4) Mount routers after body parsing middleware
app.use("/api/auth", authRouter);
app.use("/api/paper", paperRouter);
app.use("/api/review", reviewRouter);
app.use("/api/category", categoryRouter);
app.use("/api/notification", notificationRouter);
app.use("/api/admin", adminRouter);
// 5) Start server and connect to MongoDB
const PORT = process.env.PORT || 3003;
app.listen(PORT, async () => {
  try {
    await MongoDBconfig();
    console.log(`Listening on port ${PORT}...`);
  } catch (err) {
    console.error("Failed to connect to MongoDB:", err);
  }
});
