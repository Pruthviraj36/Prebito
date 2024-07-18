const http = require('http');
const fs = require('fs');

const port = 3089;

const server = http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/html' });
    fs.readFile('index.html', (err, data) => {
        res.end(data);
    });
});

server.listen(port, () => {
    console.log(`\nServer started on port ${port}`);
    console.log(`type this in chrome\n`);
    console.log(`localhost:${port}`);
});