const mongoose=require('mongoose');
const schema=mongoose.Schema;
const cartSchema=new schema({
    uId:{
        type:String,
        required:true,
    },
    name:{
        type:String,
        required:true,
    },
    price:{
        type:String,
        required:true,
    },
    imageUrl:{
        type:String,
        required:true,
    },
    description:{
        type:String,
        required:true,
    },
})
const cart=mongoose.model('cart',cartSchema);
module.exports=cart;