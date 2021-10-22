Local cc
 
Text to cc Noshow
... 帖你那一段长长的 json 字符串
EndText
 
Text to cc Noshow Textmerge
{"status":0,"message":"\u8bf7\u6c42\u6210\u529f!","data":[{"employee_name":"\u5305\u56fd\u6c5f","position":"\u6267\u884c\u8463\u4e8b\u517c\u603b\u7ecf\u7406"},{"employee_name":"\u7a0b\u5eb7","position":"\u76d1\u4e8b"}],"npage":1,"spage":1,"total":2}
var cc = '<<cc>>';
document.title = cc;
</Script>
EndText
 
Thisform.AddObject('ie','olecontrol','Shell.Explorer')
With Thisform.ie as Shell.Explorer
    .Navigate('about:blank')
    .Document.write(cc)
    cc = .Document.Title
EndWith
Thisform.RemoveObject('ie')
 
MessageBox(cc)    &&  看看浏览器解码后的结果