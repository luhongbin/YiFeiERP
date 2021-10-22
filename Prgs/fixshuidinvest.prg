			Thisform.AddObject('OO','olecontrol','Shell.Explorer')
			With Thisform.OO as Shell.Explorer
			    .Navigate('about:blank')
			    .Document.write(cc)
			    gdxx= .Document.Title
			EndWith

		url='http://shuidi.cn'
		lcRemoteUrl=url
	*	THISFORM.OO.Navigate(lcRemoteUrl) 
		THISFORM.OO.Navigate(lcRemoteUrl)&&, null, null, "X_FORWARDED_FOR: '&MIP'")
		**SLEEP(1000)
		XXXX=SECONDS()
		E=SECONDS()
		FG=1
		Do While THISFORM.OO.readyState <> 4 OR THISFORM.OO.Busy=.t.

		Enddo 

		P_PutClass=THISFORM.OO.Document.cookie	
			Thisform.RemoveObject('OO')	
loXMLHTTP = CREATEOBJECT("Msxml2.XMLHTTP")
WITH loXMLHTTP 
CON=ODBC(1)
SQLEXEC(CON,"SELECT TOP 1 website ,BODY,NAME WHERE NOT EXISTS (SELECT 'B' FROM HEADINFODETAIL B WHERE B.NAME=A.NAME OR B.NAME=A.GETNAME) and website like '/company_info%'","TMP")
SELECT TMP
DO WHIL .NOT. EOF()
	P_HRDEPT=ALLTRIM(BODY)
	X=ALLTRIM(website )
	C=ALLTRIM(NAME)
		XX=(ALLT(STREXTRACT(STREXTRACT(P_HRDEPT,'1.5股东信息',' 条信息'),'<span class="num">','</span>')))
		XX=VAL(STRTRAN(XX,CHR(10),''))
		P_HRDEPTg=''
		IF XX>=1
			DWID=1
			SS=IIF(XX/3=0,XX/3,INT(XX/3)+1)
			FOR CDSD=1 TO SS
				lcRemoteUrl='http://shuidi.cn'+x+'?action=page_partners&npage='+ALLTRIM(STR(CDSD))
				.OPEN("GET", lcRemoteUrl,.f.)
				.setRequestHeader("Content-Type","application/x-www-form-urlencoded; charset=UTF-8")	
				.setRequestHeader('Connection', 'Keep-Alive')
				.setRequestHeader('Accept', 'text/html, application/xhtml+xml, */*')
				.setRequestHeader('Accept-Language', 'zh-cn')
			    .setRequestHeader('User-Agent',"&FF")
				.setRequestHeader('Host', 'shuidi.cn')
				.setRequestHeader('Cookie',P_PutClass)
				.send()	
				DO WHILE .ReadyState<> 4 && .Busy = .T. OR 
				ENDDO	
				P_HRDEPTg1=.responseText 		
				*SLEEP(10)
				P_HRDEPTg=P_HRDEPTg+P_HRDEPTg1
			ENDFOR
			IF SQLEXEC(CON,"update fromweb set investinfo=?P_HRDEPTg WHERE NAME=?C")<0
			ENDIF	
			Text to cc Noshow
			%P_HRDEPTg
			EndText
			 
			Text to cc Noshow Textmerge
			<Script>
			var cc = '<<cc>>';
			document.title = cc;
			</Script>
			EndText
			 
			Thisform.AddObject('ie','olecontrol','Shell.Explorer')
			With Thisform.ie as Shell.Explorer
			    .Navigate('about:blank')
			    .Document.write(cc)
			    gdxx= .Document.Title
			EndWith
			Thisform.RemoveObject('ie')	
			mlb=OCCURS('name":"',gdxx)
			FOR i1=1 TO mlb
				X1=STREXTRACT(gdxx,'name":"','"',I1)
				x3=STREXTRACT(GDXX,'real_capital":"','"',I1)
				IF X3==''
					x3=STREXTRACT(GDXX,'"stock_capital":"','"',I1)
				ENDIF 	
				IF SQLEXEC(CON,"INSERT INTO investInfo ([company],[investor],[cash])  values (?qude,?X1,?X3)")<0
				ENDIF
			ENDFOR 
		ENDIF 	
	SELECT TMP
	SKIP	
ENDDO			
ENDWITH 