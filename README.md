# 如何解析Excel表格的内容
## 初衷
```
其实主要原因就是因为懒，但是不得不承认，就是因为懒才发现了这个捷径。
当项目中需要用到一些资源的时候，比如地址(例子中是用的地址)。一般产品这边都会给你一个Excel表格，
如果东西少的话还可以，但是如果有好多呢？一个一个的复制，组装，重建是不是太麻烦？
```
## 知识点
```
其实也没什么知识点，就是结合了两种语言来实现了自己的业务。用到的语言： nodeJS ，OC
当然，前提是要对 node 和 oc 具有一定的了解， 当然起本次的主角就是node了，
当然为啥要使用oc呢，自然是因为node使用的不是太熟练，所以后序的东西我就借助了oc的知识进行补充！
```
## ExcelToJson
    在这个目录下 存放着js文件 ExcelToJson.js 和 存放地址信息的Excel 可自行命名 
    代码中是用的address.xlsx(另当前只支持xlsx格式的) node_modules 文件夹为当前js所用的库
    核心代码如下
```
var parseXlsx = require('excel');
var fs = require('fs');

parseXlsx('address.xlsx', function(err, data) {
if(err) throw err;
fs.writeFileSync('./address.json',JSON.stringify(data));//导出json文件
});
```
## 使用
   * 打开终端 cd 到 ExcelToJson
   * 执行 npm install  fs   npm install excel
   * 执行 node ExcelToJson.js  执行后可以看到文件夹下多出来一个address.json 这个是由Excel直接导出来的json组合，查看代码可知就是把表格的一行的内容组合成了数组
   * 然后把得到的 json文件拖入到xcode工程中 使用模拟器运行
   * 点击APP右上角的解析 即可生成一份重新编排过的 json文件可以共享给三端开发人员使用

## 总结
    nothing...
## 参考
    node官方链接  https://www.npmjs.com/package/excel

