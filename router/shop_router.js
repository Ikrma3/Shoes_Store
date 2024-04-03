const express=require('express');
const shopController=require('../controler/shop_controler');
const router=express.Router();
router.post('/login', shopController.adminLoginController);
router.post('/admin/addProduct',shopController.addProductController)
router.get('/homePage', shopController.homePageController);
router.get('/products/:id', shopController.productDetailsController);
router.post('/product/addtocart/:id',shopController.addToCart);
router.post('/cart',shopController.cartScreen);
router.post('/completeorder',shopController.completeOrder);
module.exports=router;