xURL = "http://wapmail.10086.cn/index.htm"  && 139邮箱短信基础版地址
apIE = Createobject("internetExplorer.Application")
apIE.Visible = .T.   && 建议调试时打开它
*!*	apIE.FullScreen=.t.

apIE.Navigate(xURL)
Do While apIE.busy Or apIE.readystate#4
Enddo
apIE.Document.getElementById("ur").Value = "13958356141"   && 请输入别名或手机号码
apIE.Document.getElementById("pw").Value = "hongweilu776868"  && 请输入邮箱密码
xURL = "javascript:login1();"
apIE.Navigate(xURL)
Do While  apIE.busy Or apIE.readystate#4
    =Inkey(1)
Enddo

*!*    2.打开发短信页面
*!*    第六个 Item(I) 连接是发送短信的地址
XXX=apIE.LocationURL
*xURL ="http://m.mail.10086.cn/bv12/" + apIE.Document.Links.Item(6).toString  &&'http://m.mail.10086.cn/bv12/sendsms.html?&sid=MTM5Njk0MTc1NTAwMDcyOTkwNDg3MwAA000004&vn=306&vid=&cmd=40'&& 
xURL ="http://m.mail.10086.cn/bv12/sendsms.html?&sid=" + STREXTRACT(XXX,'sid=','&realVer')+'&vn=306&vid=&cmd=40'
apIE.Navigate(xURL)
Do While  apIE.busy Or apIE.readystate#4
    =Inkey(1)
Enddo
*!*    3.自动填表
*!*	apIE.Document.All.reciever.setActive()

*!*	apIE.Document.All.reciever.select()
apIE.Document.All.reciever.focus()
*!*	mykeybd(0x1)
*!*	mykeybd(0xba)
*!*	apIE.Document.All.reciever.focus()
*!*	xURL = 'javascript:void(document.all("reciever").value="13958356141;" + Chr(13));'
*!*	apIE.Navigate(xURL)
oShell = Createobject("WScript.Shell")
If oShell.AppActivate(apIE.Document.Title)
    For I = 1 To 11  && Tab 键走 52 次，定位到：接收手机栏
        Wait Window Timeout .1 ""
        oShell.SendKeys("{TAB}")
    Endfor
*!*	    oShell.SendKeys("13958356141")  && 电话号后一定要跟分号
Endif
*!*	apIE.Document.All.reciever.Value='13429263487;' + Chr(13)  && 输入手机号码
*!*	*!*	*!*	mykeybd(0x1)
*!*	apIE.Document.All.reciever.Value='13958356141;' + Chr(13)  && 输入手机号码
*!*	apIE.Document.All.reciever.focus()

Xx='13429263487' 
FOR I=1 TO 11
	CC='0x'+ALLTRIM(STR(VAL(SUBSTR(XX,I,1))+30))
	mykeybd(&CC)
NEXT
*!*		mykeybd(0xba)
 oShell.SendKeys("{TAB}")

*=Inkey(1)
apIE.Document.All.content.Value='短信：小姚下班了.'   && 短信内容
=Inkey(1)
apIE.Document.All.content.focus()
=Inkey(1)
apIE.Navigate('javascript:sms_send()')  && 发送
*!*	Do While  apIE.busy Or apIE.readystate#4
*!*	    =Inkey(1)
*!*	Enddo
*!*	*4.关闭 IE
*!*	Wait Window "按任意键关闭 IE"
*!*	apIE.Quit()

*!*	RETURN

