const User = require("../model/Usermodel");
const bcrypt = require("bcryptjs");
const express = require("express");
const generateToken = require("../utils/Tokengenerator");
const bodyParser = require("body-parser");
const app = express();
const Cloundinary = require("../utils/Cloudinary");

app.use(express.json());
app.use(bodyParser.json()); // for parsing application/json
app.use(bodyParser.urlencoded({ extended: true })); // for parsing application/x-www-form-urlencoded

module.exports.signup = async (req, res) => {
  try {
    // Destructure the required fields from req.body
    const { name, email, password, country, role } = req.body;
    console.log(name);
    console.log(email);
    console.log(password);
    console.log(country);
    console.log(role);

    // Check for missing fields
    if (!name || !email || !password || !country || !role) {
      return res.status(400).json({ error: "All fields are required" });
    }

    // Check if the user already exists
    const duplicatedUser = await User.findOne({ email });
    if (duplicatedUser) {
      return res.status(400).json({ error: "User already exists" });
    }

    // Hash the password
    const hashedpassword = await bcrypt.hash(password, 10);

    // Create a new user
    const newUser = new User({
      name,
      email,
      country,
      password: hashedpassword,
      role, // Role can be 'user', 'admin', or 'guest'
      ProfilePic: "", // Default ProfilePic is empty
    });

    // Save the user to the database
    const savedUser = await newUser.save();

    // Generate a token for the new user (assuming generateToken is defined elsewhere)
    const token = await generateToken(savedUser, res);

    // Send a response back to the client
    res.status(201).json({
      message: "Signup successful",
      user: {
        id: savedUser._id,
        name: savedUser.name,
        email: savedUser.email,
        role: savedUser.role,
        ProfilePic: savedUser.ProfilePic,
        token,
      },
    });
  } catch (error) {
    console.error("Error during signup:", error.message);
    res.status(400).json({ error: "Error during signup: " + error.message });
  }
};

module.exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const ipAddress = req.ip;
    const duplicatedUser = await User.findOne({ email });

    if (!duplicatedUser) {
      return res.status(400).json({ error: "No user found" });
    }

    const hasedpassword = await bcrypt.compare(
      password,
      duplicatedUser.password
    );

    if (!hasedpassword) {
      return res.status(400).json({ message: "Invalid credentials" });
    }

    const token = await generateToken(duplicatedUser, res);

    return res.status(201).json({
      message: "login successfully",
      user: {
        id: duplicatedUser.id,
        name: duplicatedUser.name,
        email: duplicatedUser.email,
        role: duplicatedUser.role,
        ProfilePic: duplicatedUser.ProfilePic,
        token,
      },
    });
  } catch (error) {
    res.status(400).json({
      error: "Error in login to the page",
    });
  }
};

module.exports.logout = async (req, res) => {
  try {
    res.cookie("Inventorymanagmentsystem", "", { maxAge: 0 });
    res.status(200).json({ message: "Logged out successfully" });
  } catch (error) {
    res.status(500).json({
      message: "An error occurred during logout. Please try again.",
      error: error.message,
    });
  }
};

module.exports.updateProfile = async (req, res) => {
  try {
    const { ProfilePic, userId } = req.body;

    if (!userId) {
      return res.status(400).json({ message: "User not authenticated" });
    }

    if (ProfilePic) {
      try {
        const uploadResponse = await Cloundinary.uploader.upload(ProfilePic, {
          folder: "profile_inventory_system",
          upload_preset: "upload",
        });

        const updatedUser = await User.findOneAndUpdate(
          { _id: userId },
          { ProfilePic: uploadResponse.secure_url },
          { new: true }
        );

        if (!updatedUser) {
          return res.status(404).json({ message: "User not found" });
        }

        return res.status(200).json({
          message: "Profile updated successfully",
          updatedUser,
        });
      } catch (cloudinaryError) {
        console.error("Cloudinary upload failed:", cloudinaryError);
        return res.status(500).json({
          message: "Image upload failed",
          error: cloudinaryError.message,
        });
      }
    } else {
      return res.status(400).json({ message: "No profile picture provided" });
    }
  } catch (error) {
    console.error("Error in update profile Controller", error.message);
    res.status(500).json({ message: "Internal Server Error", error });
  }
};

module.exports.deleteAccount = async (req, res) => {
  try {
    const { UserId } = req.params;

    const deleteAccount = await User.findByIdAndDelete(UserId);

    res.json({ message: "Account deleted successfully " });
  } catch (error) {
    console.error("Error in delete Controller", error.message);
    res.status(500).json({ message: "Internal Server Error", error });
  }
};
