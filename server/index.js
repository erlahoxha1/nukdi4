//import form packages
const express = require("express");
const mongoose = require("mongoose");   // faster
//import from files

const authRouter = require('./routes/auth');
//init
const PORT = 3000;
const app = express();
const DB = "mongodb+srv://erla:test123@cluster0.jy4zpgd.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

//middleware
app.use(express.json());
app.use(authRouter);

//connections
mongoose.connect(DB).then(() => {
    console.log("Connected to MongoDB");
}).catch((err) => {
    console.log("Error connecting to MongoDB", err);
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`Connected to port ${PORT}`);

});