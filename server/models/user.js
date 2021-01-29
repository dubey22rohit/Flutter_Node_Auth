const mongoose = require('mongoose')

var userSchema = mongoose.Schema({
    email : {
        type : String,
        required : true
    },
    password : {
        type : String,
        required : true
    }
})

let User = mongoose.model("User",userSchema)
module.exports = User