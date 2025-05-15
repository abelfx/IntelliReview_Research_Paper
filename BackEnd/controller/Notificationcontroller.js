const Notification = require("../model/Notificationmodel");
const User = require("../model/Usermodel");





const createNotification = async (req, res) => {
  const { title, message } = req.body;

  if (!title || !message) {
      return res.status(400).json({ error: 'Title and message are required.' });
  }

  try {
      const newNotification = new Notification({
          title,
          message,
          createdAt: new Date().toISOString()
      });

      const savedNotification = await newNotification.save();
      res.status(201).json(savedNotification);
  } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Server error while creating notification' });
  }
};




const notifyNewPaper = async (req, res) => {
  try {
    const users = await User.find();
    const notifications = users.map((user) => ({
      userId: user._id,
      title: "New Paper Added",
      message: "A new paper has been added! Come check it out.",
    }));

    await Notification.insertMany(notifications);
    res.status(200).json({ message: "Notifications sent to all users." });
  } catch (error) {
    res
      .status(500)
      .json({ error: "Failed to send notifications: " + error.message });
  }
};

const getallNotification=async(req,res)=>{
  try {
    const notifications = await Notification.find().sort({ createdAt: -1 });
    res.status(200).json(notifications);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }


}

const notifyInactiveUsers = async (req, res) => {
  try {
    const sevenDaysAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);
    const inactiveUsers = await User.find({ lastLogin: { $lt: sevenDaysAgo } });

    const notifications = inactiveUsers.map((user) => ({
      userId: user._id,
      title: "We Miss You!",
      message:
        "You haven’t logged in for a while. Come back and explore new papers!",
    }));

    await Notification.insertMany(notifications);
    res.status(200).json({ message: "Notifications sent to inactive users." });
  } catch (error) {
    res
      .status(500)
      .json({ error: "Failed to notify inactive users: " + error.message });
  }
};

// Fetch user notifications
const getUserNotifications = async (req, res) => {
  try {
    const userId = req.params.userId;

    const notifications = await Notification.find({ userId }).sort({
      createdAt: -1,
    });
    res.status(200).json(notifications);
  } catch (error) {
    res
      .status(500)
      .json({ error: "Failed to fetch notifications: " + error.message });
  }
};

module.exports = {
  notifyNewPaper,
  notifyInactiveUsers,
  getUserNotifications,
  createNotification,
  getallNotification
};
