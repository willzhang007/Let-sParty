/**
 * Created by linlinding on 10/2/16.
 */
/**
 * Created by linlinding on 10/2/16.
 */
var mysql =require('mysql')

// var connection=mysql.createConnection({
//     user : "linlin",
//     password : 120628,
//     database: "myDB"
// })

var connection=mysql.createConnection({
    user : "root",
    password : 199328,
    database: "myDB"
})

// connection.query('CREATE TABLE UserTable (' +
//     ' User_name VARCHAR(100),' +
//     ' User_Password VARCHAR(100),' +
//     ' User_Image VARCHAR(100),' +
//     ' PRIMARY KEY(User_name))', function(err, result)
//     {
//         if(err)
//         {
//             console.log(err);
//         }
//         else
//         {
//         console.log("Table UserTable Created");
//         }
//     })
connection.connect(function(err){
    if(err){
        console.log('Database connection error');
        console.log('error '+err);
    }else{
        console.log('Database connection successful');
    }
});



connection.query('CREATE TABLE PartyTable (' +
    ' Party_name VARCHAR(100),' +
    ' Party_holder VARCHAR(100),' +
    ' Party_place VARCHAR(100),' +
    ' Party_time VARCHAR(100),' +
    ' Party_size VARCHAR(100),' +
    ' Party_picture VARCHAR(100),' +
    ' PRIMARY KEY(Party_name))', function(err, result)
    {
        if(err)
        {
            console.log(err);
        }
        else
        {
        console.log("Table PartyTable Created");
        }
    })



connection.query('CREATE TABLE CommentTable (' +
    ' Comments_Id INT NOT NULL AUTO_INCREMENT,' +
    ' Comments_From VARCHAR(100),' +
    ' Comments_To VARCHAR(100),' +
    ' Comments_Text VARCHAR(100),' +
    ' PRIMARY KEY(Comments_Id))', function(err, result)
{
    if(err)
    {
        console.log(err);
    }
    else
    {
        console.log("Table CommentTable Created");
    }
})

var comment1={Comments_From:'linlin',Comments_To:'lichaoParty',Comments_Text:'this party is amazing'}
var comment2={Comments_From:'mama',Comments_To:'lichaoParty',Comments_Text:'so cool'}
var comment3={Comments_From:'lichao',Comments_To:'linlinParty',Comments_Text:'welcome everyone join us'}

var party1={Party_name:'linlinParty',Party_holder:'linlin',Party_place:'sunderland',Party_time:'12/06/2016',Party_size:'10',Party_picture:'linlinParty.jpg'}
var party2={Party_name:'lichaoParty',Party_holder:'lichao',Party_place:'brandywine',Party_time:'11/15/2016',Party_size:'3',Party_picture:'lichaoParty.jpg'}


var user1={User_name:'linlinDing',User_Password:'29741480',User_Image:'linlinDing.jpg'}
var user2={User_name:'lichaoZhang',User_Password:'29741479',User_Image:'lichaoZhang.jpg'}

connection.query('INSERT INTO PartyTable SET ?', party1, function(err,res)
{
    if(err)
        throw err;
    console.log('Last record insert id:', res.insertId);
});
connection.query('INSERT INTO PartyTable SET ?', party2, function(err,res)
{
    if(err)
        throw err;
    console.log('Last record insert id:', res.insertId);
});


connection.query('INSERT INTO CommentTable SET ?', comment1, function(err,res)
{
    if(err)
        throw err;
    console.log('Last record insert id:', res.insertId);
});

connection.query('INSERT INTO CommentTable SET ?', comment2, function(err,res)
{
    if(err)
        throw err;
    console.log('Last record insert id:', res.insertId);
});



connection.query('INSERT INTO CommentTable SET ?', comment3, function(err,res)
{
    if(err)
        throw err;
    console.log('Last record insert id:', res.insertId);
});


// connection.query('SELECT * FROM CommentTable',function(err, records){
//     if(err) throw err;
//
//     console.log('Data received from Db:n');
//     console.log(records);
// });


// connection.query('SELECT * FROM CommentTable WHERE Comments_To = "lichaoParty" ',function(err, records){
//     if(err) throw err;
//
//     console.log('Data received from Db:n');
//     console.log(records);
// });


// connection.query('DROP TABLE test',function (err) {
//     console.log('Drop Table succeed');
//
// })



// connection.query('DELETE FROM PartyTable WHERE Party_name = "babaParty" ' ,function(err,records){
//     console.log('delete succeed')
// })

connection.end(function(err) {
    // Function to close database connection
    console.log("database is closed")
});