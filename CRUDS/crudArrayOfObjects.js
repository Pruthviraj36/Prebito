const express = require('express');
const bodyParser = require('body-parser');
const app = express();
app.use(bodyParser.urlencoded()); 

    students = [
        {
            id:1,
            name:'pruthviraj',
            age:'18'
        },
        {
            id:2,
            name:'viraj',
            age:'19'
        },
        {
            id:3,
            name:'harshil',
            age:'19'
        },
        {
            id:4,
            name:'jasmin',
            age:'05'
        }
    ];

    app.get('/students', (req,res) => {
        res.send(students);
    });

    app.post('/students', (req,res) => {
        students.push(req.body);
        res.send("Student added");
    });
    app.patch('/students/:id',(req,res) => {
        const toEdit = students.findIndex((stu) => {
            if(stu.id == req.params.id){
                return true;
            }
        }); 
        students[toEdit] = req.body;
        res.send("DONE !!");
    });

   

    app.delete('/students/:id',(req,res) => {
        const toEdit = students.findIndex((stu) => {
            if(stu.id == req.params.id){
                return true;
            }
        });
        students.splice(toEdit,1);
        res.send("DELETED!!");
    });

    app.listen(4040,() => {
        console.log("The server startes at @4040..");
    });
