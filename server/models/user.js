const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    name: {
        required: true,
        type: String,
        trim: true,   
    },
    email: {
        type: String,
        required: true,
        trim: true,
        validate:{
            validator: (value) => {
                const re = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
                return value.match(re);
            },
            message: 'Plase enter a valid email address'
        },
    },
    password: {
        type: String,
        required: true,
        validate:{
            validator: (value) => {
                return value.length > 6;
            },
            message: 'Plase enter a longer password'
        },
    },
    address: {
        type: String,
        default: '',
    },
    type: {
        type: String,
        default: 'user',
    },  
});

const User = mongoose.model('User', userSchema);
module.exports = User; 