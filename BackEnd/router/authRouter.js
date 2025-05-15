const express=require("express")
const router=express.Router()
const {signup,login,updateProfile,logout,deleteAccount}=require('../controller/Authcontroller')
const {authmiddleware,adminmiddleware,Guestmiddleware}=require('../middleware/Authmiddleware')






router.post("/signup",signup)
router.post("/login",login)
router.post("/logout",authmiddleware,logout)
router.put("/updateProfile",authmiddleware,updateProfile)
router.delete("/deleteAccount/:UserId",authmiddleware,deleteAccount)









module.exports=router