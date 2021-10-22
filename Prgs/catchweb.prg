RELEASE    mindex,datefrom,dateto,mcount,i,j,mInxdex,MyData,x,data1,mcountrelate,y,mid,MyDatax,conu

PUBLIC   mindex,datefrom,dateto,mcount,i,j,mInxdex,MyData,x,data1,mcountrelate,y,mid,MyDatax,conu,MBEGIN
Declare Integer InternetGetConnectedState In wininet.Dll Integer @lpdwFlags, Integer dwReservednReserved,MBEGIN
internetgetconnectedstate(7, 0)
If internetgetconnectedstate(7, 0) = 0
	 RETURN 
ENDIF
LOCAL   loXMLHTTP AS "MSXML2.XMLHTTP"
loXMLHTTP = CREATEOBJECT("MSXML2.XMLHTTP")
LOCAL oIE as internetexplorer.application
oIE = createobject( "internetexplorer.application" ) 
header1="'User-Agent':'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0; Trident/5.0)'"
url='http://wenshu.court.gov.cn/List/ListContent'

conu=odbc(6)

SQLEXEC(conu,"select caseno,courtname,id,casetype from sixplusone..wenshu WHERE mainbody is null ORDER BY 1 DESC","TMP")

WITH loXMLHTTP AS MSXML2.XMLHTTP
DO whil .not. EOF()
	SELECT TMP
	mid=id 
	mcaseno=caseno
	mcourtname=courtname
	mcasetype=casetype
	urltext='http://wenshu.court.gov.cn/CreateContentJS/CreateContentJS.aspx?DocID='+mid&&&&***************判决正文
	.OPEN("POST", urltext,.f.)
	.setRequestHeader("Content-Length",Len(urltext))	
	.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded")
	.send()	
	DO WHILE .ReadyState<> 4
		=Inkey(1)
	ENDDO
	=Inkey(1)
	MyDatax=.responseText
	xm=STREXTRACT(.responseText,'\"PubDate\":\"','\",\"Html')
	IF MyDatax='"remind"'&&&*******			MESSAGEBOX("请输入验证码,数据处理需要,否则无法正常工作")
		urltext1='http://wenshu.court.gov.cn/User/ValidateCode'
		.OPEN("POST", urltext1,.f.)
		.setRequestHeader("Content-Length",Len(urltext1))	
		.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded")
		.send()	
		DO WHILE .ReadyState<> 4
			=Inkey(1)
		ENDDO
		LHB=.responseBody
		
		STRTOFILE(LHB,'D:\LHB.JPEG')
*		SET DEFAULT TO D:\OCR
		RUN /N D:\OCR\TESSERACT D:\LHB.JPEG LHB
		ERASE D:\LHB.JPEG
		YZM=ALLTRIM(FILETOSTR("LHB.TXT"))
		URLBB='http://wenshu.court.gov.cn/Content/CheckVisitCode?'
		.OPEN("POST", URLBB,.f.)
		.setRequestHeader("Content-Length",Len(URLBB))	
		.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded")
		.send("ValidateCode="+YZM)			
		DO WHILE .ReadyState<> 4
			=Inkey(1)
		ENDDO
		
		urltext='http://wenshu.court.gov.cn/CreateContentJS/CreateContentJS.aspx?DocID='+mid&&&&***************判决正文
		.OPEN("POST", urltext,.f.)
		.setRequestHeader("Content-Length",Len(urltext))	
		.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded")
		.send()	
		DO WHILE .ReadyState<> 4
			=Inkey(1)
		ENDDO
		=Inkey(1)
		MyDatax=.responseText
		xm=STREXTRACT(.responseText,'\"PubDate\":\"','\",\"Html')
	ENDIF
*	 	
	SQLEXEC(conu,"update sixplusone..wenshu set pubdate=?xm  where caseno=?mcaseno and id=?mid") &&&&***************判决正文发布日期
	STRTOFILE(STREXTRACT(.responseText,'"Html\":\"','\"}"'),"D:\liuplusone.HTML")

	oIE.Visible = .f. 
	oIE.Navigate( "D:\liuplusone.HTML" ) 
	DO WHILE oIE.Busy() 
	ENDDO 
	oDoc = oIE.Document 
	lcText = oDoc.documentElement.innerText 
	maddr=STREXTRACT(lcText ,'','人民法院')+'人民法院'

	SQLEXEC(conu,"update sixplusone..wenshu set mainbody=?lcText,address=?maddr,getid=1 where caseno=?mcaseno and id=?mid ")

	url2='http://wenshu.court.gov.cn/List/GetAllRelateFiles?'&&&***************关联文件
	data1="caseInfoAll"+mid+"|"+mcourtname+"|"+mcaseno+"|"+mcasetype
	.OPEN("POST", url2,.f.)
	.setRequestHeader("Content-Length",Len(data1))	
	.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded")
	.send(data1)	
	DO WHILE .ReadyState<> 4
		=Inkey(1)
	ENDDO
	=Inkey(1)
	MyDatax=.responseText
	IF MyDatax='"remind"'&&&*******			MESSAGEBOX("请输入验证码,数据处理需要,否则无法正常工作")
		urltext1='http://wenshu.court.gov.cn/User/ValidateCode'
		.OPEN("POST", urltext1,.f.)
		.setRequestHeader("Content-Length",Len(urltext1))	
		.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded")
		.send()	
		DO WHILE .ReadyState<> 4
			=Inkey(1)
		ENDDO
		LHB=.responseBody
		
		STRTOFILE(LHB,'D:\LHB.JPEG')
*		SET DEFAULT TO D:\OCR
		RUN /N D:\OCR\TESSERACT D:\LHB.JPEG LHB
		ERASE D:\LHB.JPEG
		YZM=ALLTRIM(FILETOSTR("LHB.TXT"))
		URLBB='http://wenshu.court.gov.cn/Content/CheckVisitCode?'
		.OPEN("POST", URLBB,.f.)
		.setRequestHeader("Content-Length",Len(URLBB))	
		.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded")
		.send("ValidateCode="+YZM)			
		DO WHILE .ReadyState<> 4
			=Inkey(1)
		ENDDO
		url2='http://wenshu.court.gov.cn/List/GetAllRelateFiles?'&&&***************关联文件
		data1="caseInfoAll"+mid+"|"+mcourtname+"|"+mcaseno+"|"+mcasetype
		.OPEN("POST", url2,.f.)
		.setRequestHeader("Content-Length",Len(data1))	
		.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded")
		.send(data1)	
		DO WHILE .ReadyState<> 4
			=Inkey(1)
		ENDDO
		=Inkey(1)
		MyDatax=.responseText
	ENDIF 

	mcountrelate=OCCURS('文书ID\":\"',MyDatax)	
	FOR y=1 TO mcountrelate
    	mid=STREXTRACT(MyDatax,'文书ID\":\"','\"',y)
    	IF LEN(mid)<10
    		EXIT
    		LOOP
    	ENDIF 
    	SQLEXEC(conu,"select interid from [sixplusone..relatecase] where caseno=?mcaseno and id=?mid ")
    	IF RECCOUNT()=1
    		minter=interid 
    	ELSE
*!*				    		minter=maxinteridx("relatecase")
    		SQLEXEC(conu,"insert into sixplusone..relatecase (id,caseno) values (?mid,?mcaseno )")
    		SQLEXEC(conu,"select interid from [sixplusone..relatecase] where caseno=?mcaseno and id=?mid ")
    		minter=interid 
    	ENDIF 	
    	mdateid=DTOC(CTOD(STREXTRACT(MyDatax,'裁判日期\":\"','\",',y)),1)
    	mcloseway=STREXTRACT(MyDatax,'结案方式\":\"','\",',y)
    	mprogram=STREXTRACT(MyDatax,'审判程序\":\"','\",',y)
    	mcaseno=ALLTRIM(STREXTRACT(MyDatax,'案号\":\"','\",',y))
    	mcourtname=ALLTRIM(STREXTRACT(MyDatax,'审理法院\":\"','\"',y))		
		IF SQLEXEC(conu,"update [sixplusone..relatecase] set interid=?minter,dateid=?mdateid,program=?mprogram,courtname=?mcourtname where caseno=?mcaseno and id=?mid")<0
		ENDIF 			    		    	
    ENDFOR 		
	SELECT TMP
	SKIP
ENDDO
SQLDISCONNECT(conu)

ENDWITH
loXMLHTTP = NULL
oIE.quit
