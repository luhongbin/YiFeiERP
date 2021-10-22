LOCAL   loXMLHTTP AS "MSXML2.XMLHTTP"
loXMLHTTP = CREATEOBJECT("MSXML2.XMLHTTP")
conu=odbc(6)
*!*	SQLEXEC(conu,"delete from sixplusone..IPPROXY","TMP")

SQLEXEC(conu,"select COUNT(*) from sixplusone..IPPROXY1","TMP")
IF 1=1
	WITH loXMLHTTP AS MSXML2.XMLHTTP
	FOR I=1 TO 100
		url='http://www.xicidaili.com/nt/'

		lcRemoteUrl=url+ALLTRIM(STR(I))
		.OPEN("GET", lcRemoteUrl,.f.)
		.setRequestHeader('Accept', '*/*')
		.setRequestHeader('Accept-Language', 'zh-CN,zh;q=0.8')
		.setRequestHeader('User-Agent', 'Mozilla/5.0 (X11; Fedora; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36')
		.setRequestHeader('Hosts', 'hm.baidu.com')
		.setRequestHeader('Referer', 'http://www.xicidaili.com/wt')
		.setRequestHeader('Connection', 'keep-alive')
*!*			.setRequestHeader("Content-Length",Len(data1))	
		.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded")
		.send()	
		DO WHILE .ReadyState<> 4
			=Inkey(1)
		Enddo
		=Inkey(3)
		P_HRDEPT=.responseText
		MyDatax=P_HRDEPT
		xm=STREXTRACT(P_HRDEPT,'验证时间','<div class="pagination">')
		MPAGE=OCCURS('<td class="country"><img src="',xm)
		FOR J=1 TO MPAGE
			MIP=STREXTRACT(xm,'<td class="country"><img src="','<a href="',J)
			IPADD=STREXTRACT(MIP,'<td>','</td>',1)+':'+STREXTRACT(MIP,'<td>','</td>',2)
			SQLEXEC(conu,"SELECT IP FROM sixplusone..IPPROXY1   where IP=?IPADD")
			IF RECCOUNT()<1
				SQLEXEC(conu,"INSERT INTO sixplusone..IPPROXY1 (IP) VALUES (?IPADD)")
			ENDIF
	    ENDFOR 		
	ENDFOR
	FOR I=1 TO 100
		url='http://www.xicidaili.com/wn/'

		lcRemoteUrl=url+ALLTRIM(STR(I))
		.OPEN("GET", lcRemoteUrl,.f.)
		.setRequestHeader('Accept', '*/*')
		.setRequestHeader('Accept-Language', 'zh-CN,zh;q=0.8')
		.setRequestHeader('User-Agent', 'Mozilla/5.0 (X11; Fedora; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36')
		.setRequestHeader('Hosts', 'hm.baidu.com')
		.setRequestHeader('Referer', 'http://www.xicidaili.com/nt')
		.setRequestHeader('Connection', 'keep-alive')
*!*			.setRequestHeader("Content-Length",Len(data1))	
		.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded")
		.send()	
		DO WHILE .ReadyState<> 4
			=Inkey(1)
		Enddo
		=Inkey(3)
		P_HRDEPT=.responseText
		MyDatax=P_HRDEPT
		xm=STREXTRACT(P_HRDEPT,'验证时间','<div class="pagination">')
		MPAGE=OCCURS('<td class="country"><img src="',xm)
		FOR J=1 TO MPAGE
			MIP=STREXTRACT(xm,'<td class="country"><img src="','<a href="',J)
			IPADD=STREXTRACT(MIP,'<td>','</td>',1)+':'+STREXTRACT(MIP,'<td>','</td>',2)
			SQLEXEC(conu,"SELECT IP FROM sixplusone..IPPROXY1   where IP=?IPADD")
			IF RECCOUNT()<1
				SQLEXEC(conu,"INSERT INTO sixplusone..IPPROXY1 (IP) VALUES (?IPADD)")
			ENDIF
	    ENDFOR 		
	ENDFOR

	ENDWITH
ENDIF
SQLDISCONNECT(conu)
loXMLHTTP = NULL
