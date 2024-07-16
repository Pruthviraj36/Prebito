const path = require('path');

///////////////////////////path/////////////////

// const ans = path.normalize('/abc/../xyz/../uvw/../viraj');
// console.log(ans);


// filePath = "D:\\viraj\\NODE-js\\Modul.js"

// ans1 = path.dirname(filePath);
// console.log('The DIRECTORY NAME is :', ans1);

// ans2 = path.basename(filePath);
// console.log('The file name  NAME is :', ans2);

// ans3 = path.extname(filePath);
// console.log('The extension NAME is :', ans3);

// ans4 = path.posix;
// console.log('The extension NAME is :', ans4);

///////////////////////FILEPATH/////////////////////

const fs = require('fs');

// fs.exists("D:\\viraj\\NODE-js\\Modul.js",(data) => {
//     console.log(data);
// });
// console.log("Hal Bhura AAVJE !!!!!!");

// fs.stat("D:\\viraj\\NODE-js\\Modul.js",(err,data) => {
//     console.log(data);
//     console.log(err);
// });
// console.log("bhur0 STAT ma ho  baki  kai ghate !!!!!!!!!!!!omphooo");
 

// fs.readFile("D:\\viraj\\NODE-js\\Modul.js",(err,data) => {
//     console.log(data.toString());
// });

fs.readFile("D:\\viraj\\NODE-js\\Modul.js",(err,data) => {
    
    fs.writeFile("copyFileDemo.js",data,(err,data1) => {
        console.log(err);

    });
});
