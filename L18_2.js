const child_process = require('child_process');

child_process.exec('netsh wlan show profiles name="DU_LAB" key=clear', (err, stdout, stdin) => {
    console.log('the error is : ', err);
    console.log(stdout);
});