const mongoose=require("mongoose")


const categorySchema = new mongoose.Schema({
    name: {
        type:String,
        required:true

    },
    description:{
        type:String,
        required:true

    },
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now }
  });
  
  module.exports = mongoose.model('Category', categorySchema);