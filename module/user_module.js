const mongoose=require('mongoose');
const schema=mongoose.Schema;
const userSchema=new schema({
    name:{
        type:String,
        required:true,
    },
    password:{
        type:String,
        required:true,
    }
})
const user=mongoose.model('user',userSchema);
module.exports=user;