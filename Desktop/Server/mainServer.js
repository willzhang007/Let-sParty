/**
 * Created by linlinding on 10/2/16.
 */
var http=require('http')
var express=require("express")
var bodyParser = require('body-parser')
var fs=require('fs')
var multiparty = require('multiparty')
var util=require('util')

var partys = require('./routes/party');
var users = require('./routes/users');

var app=express()

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }))
app.use("/",express.static(__dirname+"/public"+"/images"));

app.use("/",users);
app.use("/",partys);

http.createServer(app).listen(3000,function (err) {

    if(err)
    {
        console.log("server launch fail...");
    }
    else
    {
        console.log("server launch succeed...");
    }
});


// app.post('/login',function (req,res,next) {
//     console.log("user login request");
//     req.user=req.body;
//     next();
// })

// app.all('/login',function (req,res) {
//     console.log(req.user)
// })

