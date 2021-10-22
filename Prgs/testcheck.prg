DECLARE Integer GetSystemDefaultLangID IN Win32Api
nLangId = GetSystemDefaultLangID()
?nLangId   &&十进制
?TRANSFORM(nLangId,"@0")
IF RIGHT(TRANSFORM(nLangId,"@0"),4)='0804'   &&十六进制

lcRemoteUrl="http://translate.google.cn/" 

lcRemoteFile=lcRemoteUrl
lcLocalFile = "transtmp.txt"
Declare Integer DeleteUrlCacheEntry In Wininet.Dll String szUrl
Declare Integer URLDownloadToFile In urlmon.Dll Integer pCaller,String szURL,String szFileName,Integer dwReserved,Integer lpfnCB

=DeleteUrlCacheEntry(lcRemoteUrl) &&清理缓存
If URLDownloadToFile(0,lcRemoteFile,lcLocalFile,0,0)<>0
*!*	    Messagebox('无法打开GOOGLE引擎！',48,'信息提示')
*!*	    thisform.Release 
	RETURN 
Endif
responseText =STRCONV(Filetostr(lcLocalFile),11)
*!*	ERASE lcLocalFile
*p_driver= Strextract(responseText,'<meta name=description content="Google 免费的在线翻译服务可即时翻译文本和网页。 ','"><meta name=robots content=noodp>')
responseText=Strextract(responseText,'<option value=separator disabled>&#8212;</option>')
responseText=Strextract(responseText,'<option value=separator disabled>&#8212;</option>')
responseText=Strextract(responseText,'<option value=separator disabled>&#8212;</option>','</select><div id=')
keytxt=responseText
lsstr=''
lsstrcount=OCCURS('<option value=',responseText )
con=odbc(6)
FOR x=1 TO lsstrcount
	
	x1=Strextract(responseText,'<option value=','</option>')
	responseText=Strextract(responseText,'<option value=')
	lsstr=Strextract(x1,'>')+'['+Strextract(x1,'','>')+']'
	wyy=Strextract(x1,'','>')
	SQLEXEC(con,"select name from treecode where fkey=13 and keyid=2179","tmp1")
	cname=ALLTRIM(name)
	SQLEXEC(con,"select name from treecode where fkey=2179 and name=?lsstr","tmp1")
	

	IF RECCOUNT()<1

		SQLEXEC(con,"select keyid from treecode order by 1 desc","tmp1")
		kk=keyid +1
		SELECT table1
		LOCATE FOR ALLTRIM(dept)==ALLTRIM(wyy)
		IF FOUND()
			lsstr1=ALLTRIM(dateid)
		ELSE 	
			lsstr1=''
		ENDIF 
		SQLEXEC(con,"insert into treecode (keyid,fkey,name,note) values (?kk,2179,?lsstr,?lsstr1)")
		*?kk,cname,lsstr
	ENDIF 

ENDFOR 	
SQLDISCONNECT(con)
ENDIF 