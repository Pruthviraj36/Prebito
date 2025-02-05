const readline = require('readline');
const child_process = require('child_process');
const os = require('os');
const fs = require('fs');
const axios = require('axios');
const net = require('net');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

console.log('\n🛠️ Cybersecurity & System Toolkit');
console.log('1. Get WiFi Password');
console.log('2. Show System Info');
console.log('3. Show CPU & Memory Usage');
console.log('4. Show IP Address & Network Info');
console.log('5. List Available WiFi Networks');
console.log('6. Get Public IP Address');
console.log('7. Scan Open Ports');
console.log('8. Ping a Target');
console.log('9. Whois Lookup');
console.log('10. Traceroute');
console.log('11. List All Files in Directory');
console.log('12. Create/Delete a File');
console.log('13. List Running Processes');
console.log('14. Kill a Process');
console.log('15. Show Active Users');
console.log('16. Check Firewall Status');
console.log('17. Shutdown / Restart System');
console.log('18. Exit\n');

function askQuestion() {
    rl.question('What do you want to do: ', async (command) => {
        if (command == 1) {
            rl.question('Enter WiFi Name: ', (wifiName) => {
                child_process.exec(`netsh wlan show profile name="${wifiName}" key=clear`, (err, stdout, stderr) => {
                    if (err) console.log('Error:', err.message);
                    else console.log(stdout);
                    askQuestion();
                });
            });
        } else if (command == 2) {
            console.log('OS:', os.platform(), os.release(), os.arch());
            console.log('System Uptime:', os.uptime(), 'seconds');
            askQuestion();
        } else if (command == 3) {
            console.log('CPU:', os.cpus()[0].model);
            console.log('Total Memory:', (os.totalmem() / 1e9).toFixed(2), 'GB');
            console.log('Free Memory:', (os.freemem() / 1e9).toFixed(2), 'GB');
            askQuestion();
        } else if (command == 4) {
            console.log('Network Interfaces:', os.networkInterfaces());
            axios.get('https://api64.ipify.org?format=json')
                .then(response => {
                    console.log('Your Public IP:', response.data.ip);
                    askQuestion();
                })
                .catch(err => {
                    console.log('Error:', err.message);
                    askQuestion();
                });
        } else if (command == 5) {
            child_process.exec('netsh wlan show networks', (err, stdout, stderr) => {
                if (err) console.log('Error:', err.message);
                else console.log(stdout);
                askQuestion();
            });
        } else if (command == 6) {
            axios.get('https://api64.ipify.org?format=json')
                .then(response => {
                    console.log('Your Public IP:', response.data.ip);
                    askQuestion();
                })
                .catch(err => {
                    console.log('Error:', err.message);
                    askQuestion();
                });
        } else if (command == 7) {
            rl.question('Enter Target IP/Domain: ', (host) => {
                rl.question('Enter Port Range (e.g., 20-100): ', (range) => {
                    const [start, end] = range.split('-').map(Number);
                    for (let port = start; port <= end; port++) {
                        const socket = new net.Socket();
                        socket.setTimeout(200);
                        socket.connect(port, host, () => {
                            console.log(`Port ${port} is OPEN on ${host}`);
                            socket.destroy();
                        });
                        socket.on('error', () => socket.destroy());
                    }
                    askQuestion();
                });
            });
        } else if (command == 8) {
            rl.question('Enter Target: ', (target) => {
                child_process.exec(`ping -c 3 ${target}`, (err, stdout, stderr) => {
                    if (err) console.log('Ping failed.');
                    else console.log(stdout);
                    askQuestion();
                });
            });
        } else if (command == 9) {
            rl.question('Enter Domain: ', (domain) => {
                child_process.exec(`whois ${domain}`, (err, stdout, stderr) => {
                    if (err) console.log('Error:', err.message);
                    else console.log(stdout);
                    askQuestion();
                });
            });
        } else if (command == 10) {
            rl.question('Enter Target: ', (target) => {
                child_process.exec(`tracert ${target}`, (err, stdout, stderr) => {
                    if (err) console.log('Error:', err.message);
                    else console.log(stdout);
                    askQuestion();
                });
            });
        } else if (command == 11) {
            console.log('Files in Directory:', fs.readdirSync('.'));
            askQuestion();
        } else if (command == 12) {
            rl.question('Enter Action (create/delete): ', (action) => {
                rl.question('Enter File Name: ', (fileName) => {
                    if (action === 'create') {
                        fs.writeFileSync(fileName, '');
                        console.log(`File "${fileName}" created.`);
                    } else if (action === 'delete') {
                        if (fs.existsSync(fileName)) {
                            fs.unlinkSync(fileName);
                            console.log(`File "${fileName}" deleted.`);
                        } else {
                            console.log('File not found.');
                        }
                    } else {
                        console.log('Invalid action.');
                    }
                    askQuestion();
                });
            });
        } else if (command == 13) {
            child_process.exec(os.platform() === 'win32' ? 'tasklist' : 'ps aux', (err, stdout, stderr) => {
                if (err) console.log('Error:', err.message);
                else console.log(stdout);
                askQuestion();
            });
        } else if (command == 14) {
            rl.question('Enter Process ID: ', (pid) => {
                child_process.exec(os.platform() === 'win32' ? `taskkill /PID ${pid} /F` : `kill -9 ${pid}`, (err, stdout, stderr) => {
                    if (err) console.log('Error:', err.message);
                    else console.log(stdout);
                    askQuestion();
                });
            });
        } else if (command == 15) {
            child_process.exec(os.platform() === 'win32' ? 'query user' : 'who', (err, stdout, stderr) => {
                if (err) console.log('Error:', err.message);
                else console.log(stdout);
                askQuestion();
            });
        } else if (command == 16) {
            child_process.exec(os.platform() === 'win32' ? 'netsh advfirewall show allprofiles' : 'sudo ufw status', (err, stdout, stderr) => {
                if (err) console.log('Error:', err.message);
                else console.log(stdout);
                askQuestion();
            });
        } else if (command == 17) {
            rl.question('Enter action (shutdown/restart): ', (action) => {
                if (action === 'shutdown') {
                    child_process.exec(os.platform() === 'win32' ? 'shutdown /s /t 0' : 'sudo shutdown now', () => process.exit());
                } else if (action === 'restart') {
                    child_process.exec(os.platform() === 'win32' ? 'shutdown /r /t 0' : 'sudo reboot', () => process.exit());
                } else {
                    console.log('Invalid action.');
                    askQuestion();
                }
            });
        } else if (command == 18) {
            console.log('Exiting...');
            rl.close();
        } else {
            console.log('Invalid option. Try again.');
            askQuestion();
        }
    });
}

// Start the program loop
askQuestion();
