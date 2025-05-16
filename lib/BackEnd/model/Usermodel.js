const mongoose = require("mongoose");

const UserSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true, // corrected `require` to `required`
    },
    email: {
      type: String,
      required: true, // corrected `require` to `required`
      unique: true,
    },
    password: {
      type: String,
      required: true, // corrected `require` to `required`
    },
    country: {
      type: String,
      required: true, // corrected `require` to `required`
    },
    role: {
      type: String,
      enum: ["admin", "user", "guest"],
      default: "user",
    },
    ProfilePic: {
      type: String,
      default: "", // Set default value to an empty string or null
    },
    createdAt: {
      type: Date,
      default: Date.now,
    },
    updatedAt: {
      type: Date,
      default: Date.now,
    },
  },
  { timestamps: true }
);

const User = mongoose.model("User", UserSchema);

module.exports = User;
