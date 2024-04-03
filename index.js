const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require("mongoose");
const cors = require('cors');
const shop_route = require('./router/shop_router');

const app = express();
const port = process.env.PORT || 4000;

app.use(bodyParser.json());
app.use(cors());
app.use('/', shop_route);

// Connect to MongoDB and start the server
mongoose.connect('mongodb+srv://ikrmaiftikhar3:oNF1IFEPd6YZPDQH@cluster0.uo5jmyx.mongodb.net/shop?retryWrites=true&w=majority&appName=Cluster0')
    .then(() => {
        console.log("Connected to MongoDB");
        app.listen(port, () => {
            console.log("Server running on port", port);
        });
    })
    .catch(error => {
        console.error("Error connecting to MongoDB:", error);
    });
    console.error();
