const shopModule=require('../module/shop_module');
const User = require('../module/user_module');
const cart = require('../module/cart_module');
const nodemailer = require('nodemailer');
const Product=shopModule;
exports.adminLoginController = async (req, res) => {
    try {
        // Extract username and password from the request body
        const { name, password } = req.body;
            console.log(name);
            console.log(password);
        // Check if username and password match in the database
        const user = await User.findOne({ name, password });

        if (!user) {
            console.log("not find");
            // If no matching user found, return false indicating authentication failure
            return res.json({ authenticated: false });
        }
            console.log("find");
        // If authentication successful, return true indicating authentication success
        res.json({ authenticated: true });
    } catch (error) {
        // If an error occurs, handle it appropriately
        console.error('Error during admin login:', error);
        console.log(error);
        res.status(500).send('Internal Server Error');
    }
};

exports.addProductController = async (req, res) => {
    try {
        // Extract product details from the request body
        const { name, price, description, imageUrl } = req.body;

        // Create a new product instance using the Product model
        const newProduct = new Product({
            name,
            price,
            description,
            imageUrl
            // Add more fields as needed
        });
        
        // Save the new product to the database
        await newProduct.save();
        console.log("saved");

        // Redirect the admin to a page indicating successful product addition
        res.redirect('/admin/products'); // Assuming you have a route for admin products page
    } catch (error) {
        // If an error occurs, handle it appropriately
        console.error('Error adding product:', error);
        res.status(500).send('Internal Server Error');
    }
};

exports.homePageController = async (req, res) => {
    try {
        const userIp = req.ip; // Fetch user's IP address
        const products = await Product.find();

        // Render the home page and pass the products data and user IP to the frontend
        res.json({ products, userIp });
    } catch (error) {
        // If an error occurs, handle it appropriately
        console.error('Error fetching products:', error);
        res.status(500).send('Internal Server Error');
    }
};
exports.productDetailsController = async (req, res) => {
    try {
        // Get the product ID from the request parameters
        const productId = req.params.id;
        console.log("id");
            console.log(productId);
        // Fetch the product details from the database using the ID
        const product = await Product.findById(productId);

        // If the product is not found, return a 404 error
        if (!product) {
            return res.status(404).send('Product not found');
        }

        // Render the product details page and pass the product data to the view
        res.status(200).json(product);
    } catch (error) {
        // If an error occurs, handle it appropriately
        console.error('Error fetching product details:', error);
        res.status(500).send('Internal Server Error');
    }
};
let carts = {};
exports.addToCart = async (req, res) => {
    try {
        // Parse user ID and product ID from request body
        const { userId, productId } = req.body;
        // Fetch product details based on product ID
        const product = await Product.findById(productId);
        if (!product) {
            return res.status(404).json({ success: false, message: 'Product not found' });
        }
      const newCart= new cart({
            uId: userId,
            name: product.name,
            price: product.price.toString(),
            imageUrl: product.imageUrl,
            description: product.description
        });
             // Save the updated cart to the database
        await newCart.save();

        // Return success response
        res.json({ success: true, message: 'Product added to cart successfully', cart });
    } catch (error) {
        console.error('Error adding product to cart:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
};
exports.cartScreen = async (req, res) => {
    try {
        // Parse user ID from request body
        const { userId } = req.body;

        // Find cart items associated with the user ID
        const cartItems = await cart.find({ uId: userId });
        console.log(userId);
        // Return the cart items
        res.json({ success: true, cartItems });
    } catch (error) {
        console.error('Error fetching cart items:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
};
exports.completeOrder = async (req, res) => {
    try {
        const { userId, name, address, email } = req.body;
        console.log("User Id= ",userId);
        
        // Find the cart items associated with the user ID
        const cartItems = await cart.find({ uId: userId });
        if (cartItems.length === 0) {
            return res.status(404).json({ success: false, message: 'No cart items found for the user' });
        }
                try {
                    await cart.deleteMany({ uId: userId });
                    res.json({ success: true, message: 'Order completed successfully' });
                } catch (err) {
                    console.error('Error deleting cart items:', err);
                    res.status(500).json({ success: false, message: 'Error deleting cart items' });
                }
            }
     catch (error) {
        console.error('Error completing order:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
};