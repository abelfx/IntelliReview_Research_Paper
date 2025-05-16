const Paper = require("../model/Papermodel");
const User = require("../model/Usermodel");

const stats = async (req, res) => {
  try {
    const [paperCount, userCount] = await Promise.all([
      Paper.countDocuments(),
      User.countDocuments(),
    ]);

    res.json({
      stats: {
        papers: paperCount,
        users: userCount,
      },
    });
  } catch (err) {
    console.error("Error while getting admin stats", err);
    res.status(500).json({
      message: "Error fetching statistics",
    });
  }
};

module.exports = stats;
