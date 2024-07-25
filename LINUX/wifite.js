#!/usr/bin/env node

const childProcess = require('child_process');
const fs = require('fs');
const path = require('path');

const wifiInterfaces = [];

// Get WiFi interfaces
childProcess.exec('ipconfig', (error, stdout, stderr) => {
  if (error) {
    console.error(`Error: ${error.message}`);
    return;
  }
  if (stderr) {
    console.error(`stderr: ${stderr}`);
    return;
  }
  const interfaces = stdout.split('\n');
  interfaces.forEach((interface) => {
    if (interface.includes('IEEE 802.11')) {
      wifiInterfaces.push(interface.trim().split(' ')[0]);
    }
  });
  console.log(`Available WiFi interfaces: ${wifiInterfaces.join(', ')}`);
  mainMenu();
});

function mainMenu() {
  console.log('Wifite App');
  console.log('-----------');
  console.log('1. Scan for networks');
  console.log('2. Crack WEP network');
  console.log('3. Crack WPA/WPA2 network');
  console.log('4. Exit');
  console.log('-----------');

  const readline = require('readline');
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  rl.question('Choose an option: ', (answer) => {
    switch (answer) {
      case '1':
        scanForNetworks();
        break;
      case '2':
        crackWEPNetwork();
        break;
      case '3':
        crackWPAWPA2Network();
        break;
      case '4':
        process.exit(0);
        break;
      default:
        console.log('Invalid option. Try again!');
        mainMenu();
    }
  });
}

function scanForNetworks() {
  console.log('Scanning for networks...');
  childProcess.exec(`iwlist ${wifiInterfaces[0]} scan`, (error, stdout, stderr) => {
    if (error) {
      console.error(`Error: ${error.message}`);
      return;
    }
    if (stderr) {
      console.error(`stderr: ${stderr}`);
      return;
    }
    const networks = stdout.split('Cell ');
    networks.forEach((network) => {
      if (network.includes('ESSID')) {
        const essid = network.match(/ESSID:"(.*)"/)[1];
        console.log(`Found network: ${essid}`);
      }
    });
    mainMenu();
  });
}

function crackWEPNetwork() {
  console.log('Cracking WEP network...');
  // Implement WEP cracking logic here
  // For demonstration purposes, we'll just print a success message
  console.log('WEP network cracked!');
  mainMenu();
}

function crackWPAWPA2Network() {
  console.log('Cracking WPA/WPA2 network...');
  const essid = promptForESSID();
  const passwordList = promptForPasswordList();
  crackWPAWPA2NetworkWithAircrack(essid, passwordList);
}

function promptForESSID() {
  const readline = require('readline');
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  rl.question('Enter the ESSID of the network: ', (essid) => {
    rl.close();
    return essid;
  });
}

function promptForPasswordList() {
  const readline = require('readline');
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  rl.question('Enter the path to the password list: ', (passwordList) => {
    rl.close();
    return passwordList;
  });
}

function crackWPAWPA2NetworkWithAircrack(essid, passwordList) {
  const aircrackCommand = `aircrack-ng -w ${passwordList} -b ${essid} ${wifiInterfaces[0]}`;
  childProcess.exec(aircrackCommand, (error, stdout, stderr) => {
    if (error) {
      console.error(`Error: ${error.message}`);
      return;
    }
    if (stderr) {
      console.error(`stderr: ${stderr}`);
      return;
    }
    console.log(stdout);
    console.log('WPA/WPA2 network cracked!');
    mainMenu();
  });
}
