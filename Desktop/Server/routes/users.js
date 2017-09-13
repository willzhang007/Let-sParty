var express = require('express');
var user = express.Router();

user.post('/login',function (req,res,next) {
    console.log("user login request");
    req.user=req.body;
    var response=(req.user, 'login succeed')
    res.end(response)
    next();
})

user.get('/login',function (req,res,next) {
    var response=(req.user, 'login succeed')
    res.end(response)
    next();
})

module.exports = user;
