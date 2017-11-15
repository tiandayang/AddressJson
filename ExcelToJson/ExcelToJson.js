var parseXlsx = require('excel');
var fs = require('fs');

parseXlsx('address.xlsx', function(err, data) {
  if(err) throw err;
  fs.writeFileSync('./address.json',JSON.stringify(data));   
  });
