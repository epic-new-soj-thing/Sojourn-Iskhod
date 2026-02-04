const fs = require('fs');
const path = 'C:\\Program Files (x86)\\BYOND\\bin\\dm.exe';
console.log('Path:', path);
try {
    console.log('Is file:', fs.statSync(path).isFile());
} catch (e) {
    console.log('Error:', e.message);
}
