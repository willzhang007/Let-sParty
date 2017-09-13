/**
 * Created by linlinding on 10/3/16.
 */
var express = require('express');
var mysql=require('mysql');
var multiparty=require('multiparty');
var fs=require('fs')
var url = require( "url" );
var party = express.Router();

party.all('/partyList',function (req,res,next) {

    console.log("party list request ");
    GetPartyListFromDB(function(result)
    {
        for(var i=0;i<result.length;i++)
        {
            var partyItem=result[i];
            var name=partyItem['Party_name']
            var holder=partyItem['Party_holder']
            var place=partyItem['Party_place']
            var time=partyItem['Party_time']
            var size=partyItem['Party_size']
            var picture=partyItem['Party_picture']
            //retArray.push({Party_name:name,Party_holder:holder,Party_place:place,Party_time:time,Party_size:size,Party_picture:picture});
            console.log(name,holder,place,time,size,picture);
        }
        res.send(JSON.stringify(result))
        next();
    });
})

party.all('/uploadpic',function(req,res,next)
{
    var form=new multiparty.Form();
    console.log("create form succeed");

    form.on('field',function(name,value)
    {
        console.log("field name is "+name)
        console.log("field value is "+value)

    })

    form.on('file',function(name,file)
    {
        var tmpPath=file.path;
        var fileName=file.originalFilename;
        console.log("tmp path: "+tmpPath);
        var targetPath='./public/images/'+fileName;

        fs.renameSync(tmpPath,targetPath,function(err)
        {
            if(err)
                console.log(err.stack)
        });
    })

    form.on('close',function(){
        res.end("linlin server received");
        console.log('Upload complete!');
    })
    form.parse(req)
})

party.all('/throwParty',function(req,res,next){

    console.log('throw party request');

    ThrowPartyToDatabase(req,function(result)
    {
        res.end(result);
    })
    next();
})

party.all('/writeComment',function(req,res,next){

    console.log('write comment to certain party');

    WriteCommentToDatabase(req,function(result)
    {
        res.end(result);
    })
    next();

})

party.get('/partyInfo',function(req,res,next){

    console.log('party info request');
    var requestParty=req.query.requestParty

    GetPartyItemFromDB(requestParty,function (partyInfo) {

        var name=partyInfo[0]['Party_name']
        var holder=partyInfo[0]['Party_holder']
        var place=partyInfo[0]['Party_place']
        var time=partyInfo[0]['Party_time']
        var size=partyInfo[0]['Party_size']
        var picture=partyInfo[0]['Party_picture']

        var partyItemJson=JSON.stringify(partyInfo);
        console.log(partyItemJson);
       // res.write(partyItemJson);


        GetPartyCommentFromDB(requestParty, function (comments) {
            for(var i=0;i<comments.length;i++) {
                var commentItem = comments[i];
                var commentFrom = commentItem['Comments_From']
                var commentTo = commentItem['Comments_To']
                var commentText = commentItem['Comments_Text']
            }
            var commentsJson=JSON.stringify(comments);
            console.log(commentsJson);
            console.log();
            res.write(commentsJson);
            res.end();
            next();
        })

    });
})

function GetPartyListFromDB(callback)
{
    var connection=mysql.createConnection({
        user : "linlinding",
        password : "13201858855Dll",
        host:"testdb.c1bum6hivcys.us-west-2.rds.amazonaws.com",
        port:3306,
        database: "myDB"
    });

    connection.connect();
    var querySql='SELECT * FROM PartyTable';
    connection.query(querySql,function(err,result,fields)
    {
        if(err)
        {
            console.log('err',err);
            connection.close();
            return;
        }
        callback(result);
    });
}

function ThrowPartyToDatabase(req,callback)
{
    var name=req.body.name;
    var holder=req.body.holder;
    var place=req.body.place;
    var time=req.body.ptime;
    var size=req.body.size;
    var picture=req.body.picture;

    var newParty={Party_name:name,Party_holder:holder,Party_place:place,Party_time:time,Party_size:size,Party_picture:picture}

    var connection=mysql.createConnection({
        user : "linlinding",
        password : "13201858855Dll",
        host:"testdb.c1bum6hivcys.us-west-2.rds.amazonaws.com",
        port:3306,
        database: "myDB"
    });

    connection.connect();

    connection.query('INSERT INTO PartyTable SET ?', newParty, function(err,res)
    {
        if(err)
        {
            console.log(err)
            throw err;
        }
        else
        {
            callback("insert succeed!")
        }

    });
}

function GetPartyItemFromDB(partyName, ItemCallback)
{
    var connection=mysql.createConnection({
        user : "linlinding",
        password : "13201858855Dll",
        host:"testdb.c1bum6hivcys.us-west-2.rds.amazonaws.com",
        port:3306,
        database: "myDB"
    });

    connection.connect();

    var sql ='SELECT * FROM PartyTable WHERE Party_name=?'
    var params=[partyName]

    connection.query(sql, params, function(err, records){
    if(err) throw err;

        ItemCallback(records)});
}

function GetPartyCommentFromDB(commentParty, callback)
{
    var connection=mysql.createConnection
    ({
        user : "linlinding",
        password : "13201858855Dll",
        host:"testdb.c1bum6hivcys.us-west-2.rds.amazonaws.com",
        port:3306,
        database: "myDB"
    });

    connection.connect();

    var sql ='SELECT * FROM CommentTable WHERE Comments_To=?'
    var params=[commentParty]

    connection.query(sql, params, function(err, records)
    {
        if(err) throw err;

        callback(records)});
}

function WriteCommentToDatabase(req,callback)
{
    var from=req.body.From;
    var to=req.body.To;
    var text=req.body.Text;

    console.log(from,to,text);

    var newComment={Comments_From:from,Comments_To:to,Comments_Text:text};

    var connection=mysql.createConnection
    ({
        user : "linlinding",
        password : "13201858855Dll",
        host:"testdb.c1bum6hivcys.us-west-2.rds.amazonaws.com",
        port:3306,
        database: "myDB"
    });

    connection.connect();

    connection.query('INSERT INTO CommentTable SET ?', newComment, function(err,res)
    {
        if(err)
        {
            console.log(err)
            throw err;
        }
        else
        {
            callback("insert succeed!")
        }

    });


}

module.exports = party;


