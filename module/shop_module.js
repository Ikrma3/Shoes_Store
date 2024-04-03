const mongoose = require('mongoose');

// Define the schema for products
const productSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    price: {
        type: Number,
        required: true
    },
    description: {
        type: String,
        required: true
    },
    imageUrl: {
        type: String,
        required: true
    },
    // You can add more fields as per your requirement
    // For example, category, brand, etc.
});

// Create a model based on the schema
const Product = mongoose.model('Product', productSchema);

// Export the model to be used in other parts of the application
module.exports = Product;
