
PROCEDURE mocta220
CON=ODBC(5)
SQLEXEC(CON,"select TA001,TA002,TA033,TA006,TA034,TA035,CASE WHEN MD001 IS NULL THEN X.MA002 ELSE MD002 END MD002 ,TA011,TA013,MB080,"+;
"CONVERT(varchar(10), CAST(TA009 as datetime), 102) TA009,CONVERT(varchar(10), CAST(TA010 as datetime), 102) TA010,TA015,TA017,"+;
"'['+DATENAME( Wk,CAST( TA010 as datetime) )+'周]'+TA033 AS ZC,case when TA011='1' then '未生产' WHEN TA011='2' THEN '已发料' when TA011='3' THEN '生产中' END ZT "+;
"FROM MOCTA INNER JOIN COPTD ON TA033=RTRIM(TD001)+TD002 AND TA006=TD004 LEFT JOIN CMSMD ON TA021=MD001  LEFT JOIN PURMA X ON X.MA001=TA032 LEFT JOIN INVMB ON MB001=TA006 "+;
"WHERE (datediff(day,TA009,getdate())=-1 or datediff(day,TA009,getdate())=-7) AND TA011<='3' AND LEFT(TA033,3)='220' ORDER BY TA009","TMP1")
SQLDISCONNECT(CON)
SELECT TMP1
IF RECCOUNT()<1
	RETURN
ENDIF	
GO TOP
T=''
DO WHIL .NOT. EOF()
	SELECT TMP1
	IF ALLTRIM(MB080)=='' OR ISNULL(MB080) OR ALLTRIM(MB080)=ALLTRIM(TA006)
		TTD='['+ALLTRIM(TA006)+']'
	ELSE
		TTD='['+ALLTRIM(MB080)+']'+ALLTRIM(TA006)
	ENDIF	
	S=ALLTRIM(STR(RECNO()))+'.'+ALLTRIM(ZC)+'('+ALLTRIM(TA001)+ALLTRIM(TA002)+ALLTRIM(TTD)+':'+ALLTRIM(TA034)+',规格:'+ALLTRIM(TA035)+'['+ALLTRIM(MD002)+']'+ALLTRIM(ZT)+ALLTRIM(STR(TA015-TA017))+'Pcs)预计开工:'+ALLTRIM(TA009)+'-'+ALLTRIM(tA010)+CHR(13)+chr(10)
	IF LEN(ALLTRIM(T+S))<2200
		T=T+S
	ELSE
		T=T+CHR(13)+CHR(10)+'...'
		EXIT
	ENDIF
	SKIP
ENDDO		
mtitle='220试生产订单提醒'
m_note=t+CHR(13)+CHR(10)+'请做好工装夹具，工艺卡，首样准备工作!'

con=odbc(6)
SQLEXEC(CON,"SELECT  NAME FROM TREECODE WHERE fKey in (SELECT  KEYID FROM TREECODE WHERE name='试生产订单通知人' )",'TmpClass')
SQLDISCONNECT(con)
mrev=''
SELECT TmpClass
IF RECCOUNT()>=1
	GO top
	DO whil .not. EOF()
		mrev=mrev+ALLTRIM(NAME )+';'
		SKIP
	ENDDO 	
ENDIF
tmpkeyid=maxinterid("rtxmessage")
keyidid1=ODBC(6)
IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,0)")<0
	WAIT windows '????' nowait
ENDIF 
ENDPROC 

FUNCTION getsmm
XT=getserverdate()
servetime=HOUR(XT)
mt =TTOD(XT)
CON=ODBC(6)
SQLEXEC(con,"select interid from getsmm where  CONVERT(char(19), creatdate, 102)=?mt ") &&(getid=0 or getid=2) and 
SQLDISCONNECT(con)
IF RECCOUNT()>=1
	RETURN 
ENDIF 	
*!*		DECLARE INTEGER InternetOpen IN wininet.DLL STRING, INTEGER, STRING, STRING, INTEGER
*!*		DECLARE INTEGER InternetOpenUrl IN wininet.DLL INTEGER, STRING, STRING, INTEGER, INTEGER, INTEGER
*!*		Declare Integer DeleteUrlCacheEntry In Wininet.Dll String szUrl
*!*		DECLARE short InternetCloseHandle IN wininet.DLL INTEGER
*!*		=DeleteUrlCacheEntry("http://www.smm.cn/") &&清理缓存
*!*		HINTERNETSESSION = INTERNETOPEN("http://www.smm.cn/",0,"","",0)
*!*		IF HINTERNETSESSION = 0
*!*		   WAIT WINDOW "不能建立 Internet 会话期" TIMEOUT 2
*!*			tmpkeyid=maxinterid("rtxmessage")
*!*			keyidid1=ODBC(6)
*!*			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,'姚旭辉;万里斌;周洪;鲁红斌;','鲁红斌',getdate(),'不能建立 Internet 会话期,请立即解决','取SMM数据失败',0)")<0
*!*				WAIT windows '????' nowait
*!*			ENDIF 
*!*			SQLDISCONNECT(con)
*!*		   RETURN -1
*!*		ENDIF
*!*		HURLFILE = INTERNETOPENURL(HINTERNETSESSION,"http://www.smm.cn/","",0,2147483648,0)
*!*		IF HURLFILE = 0
*!*			MESSAGEBOX('无法打开http://www.smm.cn/,请和网络管理员联系!',0+47+1,P_Caption)
*!*			tmpkeyid=maxinterid("rtxmessage")
*!*			keyidid1=ODBC(6)
*!*			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,'姚旭辉;万里斌;周洪;鲁红斌;','鲁红斌',getdate(),'无法打开http://www.smm.cn/,请立即解决!','取SMM数据失败',0)")<0
*!*				WAIT windows '????' nowait
*!*			ENDIF 
*!*			SQLDISCONNECT(con)

*!*		    RETURN -2
*!*		ENDIF
*!*	WAIT WINDOWS 'WHY'
*!*	    = InternetCloseHandle(HINTERNETSESSION)
*!*		= INTERNETCLOSEHANDLE(HURLFILE) 
*run /N ipconfig /flushdns
DECLARE INTEGER InternetOpen IN wininet.DLL STRING, INTEGER, STRING, STRING, INTEGER
DECLARE INTEGER InternetOpenUrl IN wininet.DLL INTEGER, STRING, STRING, INTEGER, INTEGER, INTEGER
Declare Integer DeleteUrlCacheEntry In Wininet.Dll String szUrl
DECLARE short InternetCloseHandle IN wininet.DLL INTEGER
=DeleteUrlCacheEntry("http://www.smm.cn/") &&清理缓存
HINTERNETSESSION = INTERNETOPEN("www.baidu.com",0,"","",0)
IF HINTERNETSESSION = 0
	IF HOUR(DATETIME())=17
		tmpkeyid=maxinterid("rtxmessage")
		keyidid1=ODBC(6)
		IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,'姚旭辉;鲁红斌;','鲁红斌',getdate(),'不能建立 Internet 会话期,助手无法连接互联网,请立即解决!','无法上网',0)")<0
			WAIT windows '??万里斌;周洪;??' nowait
		ENDIF 
		SQLDISCONNECT(keyidid1)
	ENDIF
   RETURN -1
ENDIF
HURLFILE = INTERNETOPENURL(HINTERNETSESSION,"https://www.smm.cn/","",0,2147483648,0)
IF HURLFILE = 0
	IF HOUR(DATETIME())=17
		tmpkeyid=maxinterid("rtxmessage")
		keyidid1=ODBC(6)
		IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,'姚旭辉;鲁红斌;','鲁红斌',getdate(),'助手服务器现在无法登陆http://www.smm.cn/网站,请立即解决!','连SMM失败',0)")<0
			WAIT windows '????万里斌;周洪;' nowait
		ENDIF 
		SQLDISCONNECT(keyidid1)
	ENDIF
	RETURN
ENDIF

 = InternetCloseHandle(HINTERNETSESSION)
= INTERNETCLOSEHANDLE(HURLFILE) 
	lcRemoteUrl="http://www.smm.cn/" 
	lcRemoteFile=lcRemoteUrl
	lcLocalFile = "c:\UTF8格式4.txt"
	Declare Integer DeleteUrlCacheEntry In Wininet.Dll String szUrl
	Declare Integer URLDownloadToFile In urlmon.Dll Integer pCaller,String szURL,;
	    String szFileName,Integer dwReserved,Integer lpfnCB
	=DeleteUrlCacheEntry(lcRemoteUrl) &&清理缓存
	If URLDownloadToFile(0,lcRemoteFile,lcLocalFile,0,0)<>0
		IF URLDownloadToFile(0,lcRemoteFile,lcLocalFile,0,0)<>0
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,'姚旭辉;万里斌;周洪;鲁红斌;','鲁红斌',getdate(),'无法从http://www.smm.cn/获取数据!','取SMM数据失败',0)")<0
				WAIT windows '????' nowait
			ENDIF 
			SQLDISCONNECT(keyidid1)

		    RETURN
		 ENDIF 
	Endif
	COPY file c:\UTF8格式4.txt to DTOC(DATE(),1)+'.txt'

    *2019.12.11变革

	MFILE=DTOC(DATE(),1)+'.txt'
	IF !FILE(MFILE)
		LOOP
	ENDIF	
	XT=FDATE(MFILE,1)
	servetime=HOUR(XT)
	mt =TTOD(XT)
	con=odbc(6)
	SQLEXEC(con,"select interid from getsmm where (getid=0 or getid=2) and  CONVERT(char(19), creatdate, 102)=?mt ")
	SQLDISCONNECT(con)
	IF RECCOUNT()>=1
		LOOP 
	ENDIF
	P_HRDEPT=STREXTRACT(STRCONV(FILETOSTR(MFILE),11),'<td class="c6">日期</td>','<div class="main-top-ads-warp">',1) &&2019.12.11变更,因为从4.1日开始,SMM变更了网站格式,因此重新截取数据
	P_HRDEPT=STRt(P_HRDEPT,' "','"')
	P_HRDEPT=STRt(P_HRDEPT,'" ','"') 
	P_HRDEPT=STRt(P_HRDEPT,CHR(9),'')
	P_HRDEPT=STRt(P_HRDEPT,CHR(13),'')
	P_HRDEPT=STRt(P_HRDEPT,CHR(10),'')
*!*		P_HRDEPT=STRt(P_HRDEPT,STREXTRACT(P_HRDEPT,'<!--','-->',1),'')&&2017.5.1变更,因为从4.1日开始,SMM变更了网站格式,因此重新截取数据
*!*		P_HRDEPT=STRt(P_HRDEPT,STREXTRACT(P_HRDEPT,'<!--','-->',1),'')
	*apiStartTags ='<td class="name"'
	apiStartTags ='https://hq.smm.cn'&&'href="http://hq.smm.cn'&&2017.5.1变更,因为从4.1日开始,SMM变更了网站格式,因此重新截取数据
	i2=occurs(apiStartTags ,P_HRDEPT)
	dateid=XT
	yy=''
	ttd=1
	i3=0
	FOR i1=1 TO i2
		wdd=i1
		xx=yy
		tkeyid=MAXINTERID("getsmm")
		mNote1 =''
		mName = STREXTRACT(STREXTRACT(P_HRDEPT,'class="c1">','</td>',i1),'"rel="nofollow">','</a>',1)
		mName =ALLTRIM(STRt(mName ,'SMM','') )
		yy=ALLTRIM(mname)
		IF yy='升贴水'
			mName =ALLTRIM(xx)+'('+ALLTRIM(yy)+')'
		ENDIF 	
		mNote1 = STREXTRACT(STREXTRACT(P_HRDEPT,'class="c1">','</td>',i1),'declaration">','</div>',1)

		mprice = STREXTRACT(STREXTRACT(P_HRDEPT,'class="c2','/td>',i1),'>','<',1)
		mprice=ALLTRIM(STRt(mprice ,'>',' ') )
		mprice=ALLTRIM(STRt(mprice ,CHR(9),''))
		mprice=ALLTRIM(STRt(mprice ,'$',' ') )
		mprice=ALLTRIM(STRt(mprice ,"style='border-bottom:0px;'",' ') )

		
		maver = STREXTRACT(STREXTRACT(P_HRDEPT,'class="c3','/td>',i1),'>','<',1)
		maver =ALLTRIM(STRt(maver ,'>',' ') )
		maver =ALLTRIM(STRt(maver ,'$',' ') )
		maver =ALLTRIM(STRt(maver ,"style='border-bottom:0px;'",' ') )
		maver =ALLTRIM(STRt(maver ,CHR(9),''))

		
		mchange = STREXTRACT(STREXTRACT(P_HRDEPT,'class="c4','/td>',i1),'>','<',1)
		mchange =ALLTRIM(STRt(mchange ,'>',' ') )		
		mchange =ALLTRIM(STRt(mchange ,'$',' ') )		
		mchange =ALLTRIM(STRt(mchange ,"style='border-bottom:0px;'",' ') )

		mNote1 = mNote1 +'-'+ STREXTRACT(STREXTRACT(P_HRDEPT,'class="c5','/td>',i1),'>','<',1)
		mNote1 =ALLTRIM(STRt(mNote1 ,'>',' ') )		
		mNote1 =ALLTRIM(STRt(mNote1 ,'<div class="price-declaration price_declaration"',' ') )
		mNote1 =ALLTRIM(STRt(mNote1 ,'</i',' ') )		
				
		mtoday= STREXTRACT(STREXTRACT(P_HRDEPT,'class="c6','/td>',i1),'>','<',1)
		mtoday=ALLTRIM(STRt(mtoday,'>',' ') )		
		mtoday=ALLTRIM(STRt(mtoday,'$',' ') )


		IF hour(dateid)>16
			mgetid=0
			IF left(mtoday,2)+SUBSTR(mtoday,4,2)<>SUBSTR(DTOC(TTOD(dateid),1),5,4)
				IF ':'$mtoday=.t. 
					IF  ttd=0
						mgetid=0
					ELSE 	
						mgetid=2
						ttd=1
					ENDIF 	
				ELSE 	
					mgetid=2
					ttd=1
				ENDIF 	
			ELSE 
				ttd=0	
				mgetid=0
			ENDIF 
		ELSE
			mgetid=1
		ENDIF 

		con=odbc(6)
		SQLEXEC(con,"insert into getsmm (interid,creatdate,today,change,aver,price,name,getid,note) values (?tkeyid,?dateid,?mtoday ,?mchange ,?maver ,?mprice ,?mName,?mgetid,?mnote1 )")
		SQLDISCONNECT(con)
	ENDFOR 	


	*P_HRDEPT=STREXTRACT(FILETOSTR("c:\UTF8格式4.txt"),'<th>市场</th>','<div class="tl-price" id="tabs-2" style="display:none">',1)
	*P_HRDEPT=STREXTRACT(STRCONV(FILETOSTR("c:\UTF8格式4.txt"),11),'fifth">日期</td>','<div class="content-left-first-footer">',1) &&2016.10.19变更,因为从10.17日开始,SMM变更了网站格式,因此重新截取数据
	*P_HRDEPT=STREXTRACT(STRCONV(FILETOSTR("c:\UTF8格式4.txt"),11),'div class="box-body"','</tbody>',1)
*	P_HRDEPT=STREXTRACT(STRCONV(FILETOSTR("c:\UTF8格式4.txt"),11),'content-left-first-pirce-table-fifth','</tbody>',1) &&2019.03.13变更网页，2019.06.10发现
*!*		*2018.5.11日就变更了，6.4日发现修正P_HRDEPT=STREXTRACT(STRCONV(FILETOSTR("c:\UTF8格式4.txt"),11),'fifth">日期</td>','</tbody>',1) &&2017.5.1变更,因为从4.1日开始,SMM变更了网站格式,因此重新截取数据
*!*		P_HRDEPT=STRt(P_HRDEPT,' "','"')
*!*		P_HRDEPT=STRt(P_HRDEPT,'" ','"') 
*!*		P_HRDEPT=STRt(P_HRDEPT,CHR(9),'')
*!*		P_HRDEPT=STRt(P_HRDEPT,CHR(13),'')
*!*		P_HRDEPT=STRt(P_HRDEPT,CHR(10),'')
*!*	*!*		P_HRDEPT=STRt(P_HRDEPT,STREXTRACT(P_HRDEPT,'<!--','-->',1),'')&&2017.5.1变更,因为从4.1日开始,SMM变更了网站格式,因此重新截取数据
*!*	*!*		P_HRDEPT=STRt(P_HRDEPT,STREXTRACT(P_HRDEPT,'<!--','-->',1),'')
*!*		*apiStartTags ='<td class="name"'
*!*		apiStartTags ='"https://hq.smm.cn'&&'href="http://hq.smm.cn'&&2017.5.1变更,因为从4.1日开始,SMM变更了网站格式,因此重新截取数据
*!*		i2=occurs(apiStartTags ,P_HRDEPT)
*!*		dateid=getserverdate()
*!*		yy=''
*!*		ttd=1
*!*		i3=0
*!*		FOR i1=1 TO i2
*!*			wdd=i1
*!*			xx=yy
*!*			tkeyid=MAXINTERID("getsmm")
*!*			mName = STREXTRACT(STREXTRACT(P_HRDEPT,'<td class="content-left-first-pirce-table-first"','</td>',i1),'">','</a>',2)
*!*			mName =ALLTRIM(STRt(mName ,'SMM','') )
*!*			yy=ALLTRIM(mname)
*!*			IF yy='升贴水'
*!*				mName =ALLTRIM(xx)+'('+ALLTRIM(yy)+')'
*!*			ENDIF 	
*!*			mprice = STREXTRACT(STREXTRACT(P_HRDEPT,'content-left-first-pirce-table-second','/td>',i1),'>','<',1)
*!*			mprice=ALLTRIM(STRt(mprice ,'>',' ') )
*!*			mprice=ALLTRIM(STRt(mprice ,CHR(9),''))
*!*			mprice=ALLTRIM(STRt(mprice ,'$',' ') )
*!*			mprice=ALLTRIM(STRt(mprice ,"style='border-bottom:0px;'",' ') )
*!*			mtoday=STRt(mprice,'i','0')
*!*			mtoday=STRt(mtoday,'j','1')
*!*			mtoday=STRt(mtoday,'k','2')
*!*			mtoday=STRt(mtoday,'l','3')
*!*			mtoday=STRt(mtoday,'m','4')
*!*			mtoday=STRt(mtoday,'n','5')
*!*			mtoday=STRt(mtoday,'o','6')
*!*			mtoday=STRt(mtoday,'p','7')
*!*			mtoday=STRt(mtoday,'q','8')
*!*			mtoday=STRt(mtoday,'r','9')
*!*			mprice= mtoday
*!*			
*!*			maver = STREXTRACT(STREXTRACT(P_HRDEPT,'content-left-first-pirce-table-third','/td>',i1),'>','<',1)
*!*			maver =ALLTRIM(STRt(maver ,'>',' ') )
*!*			maver =ALLTRIM(STRt(maver ,'$',' ') )
*!*			maver =ALLTRIM(STRt(maver ,"style='border-bottom:0px;'",' ') )
*!*			maver =ALLTRIM(STRt(maver ,CHR(9),''))
*!*			mtoday=STRt(maver ,'i','0')
*!*			mtoday=STRt(mtoday,'j','1')
*!*			mtoday=STRt(mtoday,'k','2')
*!*			mtoday=STRt(mtoday,'l','3')
*!*			mtoday=STRt(mtoday,'m','4')
*!*			mtoday=STRt(mtoday,'n','5')
*!*			mtoday=STRt(mtoday,'o','6')
*!*			mtoday=STRt(mtoday,'p','7')
*!*			mtoday=STRt(mtoday,'q','8')
*!*			mtoday=STRt(mtoday,'r','9')
*!*			maver = mtoday
*!*			
*!*			mchange = STREXTRACT(STREXTRACT(P_HRDEPT,'content-left-first-pirce-table-fourth','/td>',i1),'>','<',1)
*!*			mchange =ALLTRIM(STRt(mchange ,'>',' ') )		
*!*			mchange =ALLTRIM(STRt(mchange ,'$',' ') )		
*!*			mchange =ALLTRIM(STRt(mchange ,"style='border-bottom:0px;'",' ') )
*!*			mtoday=STRt(mchange ,'i','0')
*!*			mtoday=STRt(mtoday,'j','1')
*!*			mtoday=STRt(mtoday,'k','2')
*!*			mtoday=STRt(mtoday,'l','3')
*!*			mtoday=STRt(mtoday,'m','4')
*!*			mtoday=STRt(mtoday,'n','5')
*!*			mtoday=STRt(mtoday,'o','6')
*!*			mtoday=STRt(mtoday,'p','7')
*!*			mtoday=STRt(mtoday,'q','8')
*!*			mtoday=STRt(mtoday,'r','9')
*!*			mchange = VAL(mtoday)
*!*					
*!*			mtoday= STREXTRACT(STREXTRACT(P_HRDEPT,'content-left-first-pirce-table-fifth','/td>',i1),'>','<',1)
*!*			mtoday=ALLTRIM(STRt(mtoday,'>',' ') )		
*!*			mtoday=ALLTRIM(STRt(mtoday,'$',' ') )
*!*			mtoday=STRt(mtoday,'i','0')
*!*			mtoday=STRt(mtoday,'j','1')
*!*			mtoday=STRt(mtoday,'k','2')
*!*			mtoday=STRt(mtoday,'l','3')
*!*			mtoday=STRt(mtoday,'m','4')
*!*			mtoday=STRt(mtoday,'n','5')
*!*			mtoday=STRt(mtoday,'o','6')
*!*			mtoday=STRt(mtoday,'p','7')
*!*			mtoday=STRt(mtoday,'q','8')
*!*			mtoday=STRt(mtoday,'r','9')
*!*			IF hour(dateid)>=16
*!*				mgetid=0
*!*				IF left(mtoday,2)+SUBSTR(mtoday,4,2)<>SUBSTR(DTOC(TTOD(dateid),1),5,4)
*!*					IF ':'$mtoday=.t. 
*!*						IF  ttd=0
*!*							mgetid=0
*!*						ELSE 	
*!*							mgetid=2
*!*							ttd=1
*!*						ENDIF 	
*!*					ELSE 	
*!*						mgetid=2
*!*						ttd=1
*!*					ENDIF 	
*!*				ELSE 
*!*					ttd=0	
*!*					mgetid=0
*!*				ENDIF 
*!*			ELSE
*!*				mgetid=1
*!*			ENDIF 

*!*			con=odbc(6)
*!*			SQLEXEC(con,"insert into getsmm (interid,creatdate,today,change,aver,price,name,getid) values (?tkeyid,?dateid,?mtoday ,?mchange ,?maver ,?mprice ,?mName,?mgetid )")
*!*			SQLDISCONNECT(con)
*!*		ENDFOR 	
ENDFUNC

PROCEDURE JXQ
con=ODBC(5)
SQLEXEC(con,"select YEAR(getdate())*100+CAST(DATENAME( Wk,getdate()) as int)  zz","tmp3")
eend=zz+1
  IF  sqlexec(con,"SELECT TB003,TB012 品名,TB013 规格,"+;
  "SUM(TB004) AS  需用数量,SUM(TB005) AS  已领数量,"+;
	" 0000000 最新结存 ,0000000 配料中转,0000000  as 需采购数量,0000000 在途量, 0000000 请购未采购 ,"+;
	"0000000 调拨未完成,0000000  as 工单需要数,0000000 订单直接采购,INVMB.MB036 提前期,"+;
	"MV002 AS 采购员,CAST(MV002 AS CHAR(250)) PI,CMSMC.MC002,M.MC004,M.MC006  FROM MOCTA MOCTA INNER JOIN MOCTB ON TA001=TB001 AND TA002=TB002 "+;
	" INNER JOIN INVMB ON TB003 = INVMB.MB001 inner JOIN CMSMV ON INVMB.MB067 = CMSMV.MV001 LEFT JOIN  COPTC ON TA033=RTRIM(TC001)+TC002 "+;
		"  LEFT JOIN COPMA ON TC004=COPMA.MA001 "+;
	"left JOIN INVMA CA ON CA.MA002=INVMB.MB006 AND CA.MA001='2'  LEFT JOIN CMSMC AS CMSMC ON INVMB.MB017=CMSMC.MC001  LEFT JOIN INVMC M ON MB017=M.MC002 AND MB001=M.MC001 "+;
	" where year(dateadd(day,0-ISNULL(INVMB.MB036,0),TB015))*100+cast(DATENAME( Wk,dateadd(day,0-ISNULL(INVMB.MB036,0),TB015)) as int)<=?EEND and MOCTA.TA011<='3' AND TA013='Y' "+;
	" and  MOCTA.TA013='Y' AND CA.MA003<>'彩包'  AND INVMB.MB006<>'990050' AND TB003<'A' AND INVMB.MB025='P' and TB004<>TB005 and M.MC001<>'98' "+;
	" AND not exists (select 'x' from MOCTA T INNER JOIN INVMB M ON T.TA006=M.MB001 WHERE T.TA033=MOCTA.TA033 AND T.TA006=TB003 AND (MOCTB.TB004=MOCTB.TB005 OR T.TA015-T.TA017<=M.MB064)) "+;
	"  AND MV002<>'鲁鹤明' And COPMA.MA002 NOT LIKE '%PHILIPS(OEM)%' AND INVMB.MB042<>'2' GROUP BY TB003,TB012 ,TB013,MV002,INVMB.MB036,CMSMC.MC002,M.MC004,M.MC006 " ,"TmpMakeBuy1")<0  
		WAIT WINDOWS 'ERROR'
		RETURN
*		" and not exists (select 'x' from PURTD WHERE MOCTA.TA033=TD024 AND TD004=TB003 AND TD018='Y') AND&&AND MOCTA.UDF56=1MOCTA.UDF03>=?FEND AND  "+;
*	" AND not exists (select 'x' from MOCTA T INNER JOIN INVMB M ON T.TA006=M.MB001 WHERE T.TA033=MOCTA.TA033 AND T.TA006=TB003 AND (MOCTB.TB004=MOCTB.TB005 OR T.TA015-T.TA017<=M.MB064)) "+;

	ENDIF

SQLEXEC(con,"SELECT TB004,SUM(TB007) TB007 FROM INVTB INNER JOIN INVTA ON TA001=TB001 AND TA002=TB002 WHERE  "+;
" TA006='N' AND (TB013='21' OR TB013='23') AND TB018='Y'  GROUP BY TB004","TMWP3") && LEFT(TA003 ,4)+'.'+DATENAME( Wk,CAST(TA003 AS DATETIME))>=?FEND AND AND LEFT(TA003 ,4)+'.'+DATENAME( Wk,CAST(TA003 AS DATETIME))<=?EEND

 SELECT TmpMakeBuy1

lcmsg = '正在整理订单需要的物料...'
 GO TOP
 DO WHILE  .NOT. EOF()
      SELECT TmpMakeBuy1
      a1 = ''
      keytxt = RTRIM(tb003)

		XX=0
		XX1=0
*!*			SQLEXEC(con,"select SUM(TB004-TB005) SS FROM MOCTA INNER JOIN MOCTB ON TA001=TB001 AND TA002=TB002 WHERE TA011<='3' AND TB003=?keytxt AND TA013='Y' AND "+;
*!*			"CAST(LEFT(TB015,4) as int)*100+cast(DATENAME( Wk,CAST(TB015 AS DATETIME)) as int)<=?EEND")
*!*			IF RECCOUNT()=1 AND !ISNULL(SS)
*!*				XX=SS
*!*			ENDIF	

*!*			SQLEXEC(con,"select SUM(A.TA015-A.TA017) SS FROM MOCTA A WHERE A.TA011<='3' AND A.TA006=?keytxt AND A.TA013='Y'  AND "+;
*!*			"CAST(LEFT(A,TA009,4) as int)*100+cast(DATENAME( Wk,CAST(A.TA009 AS DATETIME)) as int)<=?EEND AND "+;
*!*			"NOT EXISTS (SELECT 'X' FROM MOCTA A1  INNER JOIN MOCTB ON A1.TA001=TB001 AND A1.TA002=TB002 WHERE  TB003=A.TA006  AND A.TA033=A1.TA033)")

*!*			IF RECCOUNT()=1 AND !ISNULL(SS)
*!*				XX1=0
*!*			ENDIF	
*!*			SELECT tmpmakebuy1
*!*			REPLACE 需用数量 WITH XX+XX1
		CODE31ID1=0
	  	CODE31ID2=0

		SQLEXEC(con,"SELECT SUM(TB009) TD007 FROM PURTB WHERE TB004=?KEYTXT  AND TB021='N' AND TB025='Y' AND TB020='Y' AND "+;
		"CAST(LEFT(TB019,4) as int)*100+cast(DATENAME( Wk,CAST(TB019 AS DATETIME)) as int)<=?EEND","TMP3")  &&LEFT(TB019,4)+'.'+DATENAME( Wk,CAST(TB019 AS DATETIME))>=?FEND AND 
		IF RECCOUNT()=1  AND !ISNULL(TD007)
			IF ISNULL(TD007)
		  		CODE31ID1=0
		  	ELSE
		  		CODE31ID1=TD007
		  	ENDIF
		ELSE  	
	  		CODE31ID1=0
	  	ENDIF		
		SELECT tmpmakebuy1
		REPLACE 请购未采购 WITH	 CODE31ID1 	
		SQLEXEC(con,"SELECT SUM(TD008) TD007 FROM COPTD WHERE TD004=?KEYTXT  AND TD016='N' AND TD021='Y' AND "+;
		" CAST(LEFT(TD013,4) as int)*100+cast(DATENAME( Wk,CAST(TD013 AS DATETIME)) as int)<=?EEND","TMP3")  &&LEFT(TD013,4)+'.'+DATENAME( Wk,CAST(TD013 AS DATETIME))>=?FEND AND
		IF RECCOUNT()=1  AND !ISNULL(TD007)
			IF ISNULL(TD007)
		  		CODE31ID2=0
		  	ELSE
		  		CODE31ID2=TD007
		  	ENDIF
		ELSE  	
	  		CODE31ID2=0
	  	ENDIF		
		SELECT tmpmakebuy1
		REPLACE 订单直接采购 WITH	 CODE31ID2
		SELECT TMWP3
		LOCATE FOR TB004=KEYTXT
		IF FOUND()
			CODE2ID=TB007 
		ELSE
			CODE2ID=0
		ENDIF
		SELECT tmpmakebuy1
		REPLACE 工单需要数 WITH 需用数量,需用数量 WITH 需用数量+CODE2ID+订单直接采购,调拨未完成 WITH CODE2ID	
		IF SQLEXEC(CON,"SELECT SUM(PURTD.TD008-PURTD.TD015) as 在途量 FROM PURTD WHERE PURTD.TD016='N' AND PURTD.TD018='Y' AND PURTD.TD004=?KEYTXT ","TMP3")<0
			WAIT windows '????????'
		endif	
		MKEYID=0
		SELECT TMP3
		IF RECCOUNT()=1
			IF !ISNULL(在途量)
				MKEYID=在途量
				SQLEXEC(CON,"SELECT MD003/MD004 XS1 FROM  INVMD WHERE MD001=?keytxt ","ctmp1")
				IF RECCOUNT()=1
					MKEYID=MKEYID*xs1
				ENDIF 
			ENDIF
		ENDIF
		SQLEXEC(CON,"SELECT SUM(TA015-TA017+TA018) AS 在途量 FROM MOCTA WHERE TA030='2' AND TA006=?KEYTXT AND CAST(LEFT(TA010,4) as int)*100+"+;
		"cast(DATENAME( Wk,CAST(TA010 AS DATETIME)) as int)<=?EEND AND TA011<='3'  AND TA013='Y'","TMP4")  && and UDF56=1
		IF !ISNULL(在途量)
			MKEYID=在途量+MKEYID
		ENDIF
				
		SELECT TmpMakeBuy1
		REPLACE 在途量 WITH MKEYID


	SQLEXEC(con,"SELECT MC007  FROM INVMC  WHERE MC002='50' AND MC001=?KEYTXT","TMP3")
	SELECT tmp3
	IF RECCOUNT()=1
		IF ISNULL(MC007)
	  		CODEID=0
	  	ELSE
		  	codeid=MC007
	  	ENDIF
		SELECT TmpMakeBuy1
		REPLACE 配料中转 WITH CODEID
		Closedb("TMP3")
	ELSE 
		SELECT TmpMakeBuy1
		REPLACE 配料中转 WITH 0
	ENDIF 

	SQLEXEC(con,"SELECT SUM(MC007) MC007 FROM INVMC WHERE MC001=?KEYTXT AND MC002<>'50' AND  MC002<>'19'  AND MC002<>'21'  AND MC002<>'22'","TMP3")
	SELECT tmp3
	IF RECCOUNT()=1
		IF ISNULL(MC007)
	  		CODEID=0
	  	ELSE
	  		codeid=MC007
	  	ENDIF
		SELECT TmpMakeBuy1
		REPLACE 最新结存 WITH CODEID
		Closedb("TMP3")
	ELSE 
		SELECT TmpMakeBuy1
		REPLACE 最新结存 WITH 0
	ENDIF 

	SELECT TmpMakeBuy1
	replace 需采购数量 WITH  需用数量-已领数量-最新结存-配料中转-在途量

	SELECT TmpMakeBuy1
	skip
 ENDDO    
     
  closedb("TmpMakeBuyBY")
   	SELECT distinct 采购员 FROM TmpMakeBuy1 WHERE 需采购数量>0  INTO CURSOR TmpMake
   	SELECT tmpmake
   	GO top
DO whil .not. EOF()
	xxx=ALLTRIM(采购员)
	closedb("TmpMakeBuyBY")
   	SELECT * FROM TmpMakeBuy1 WHERE 需采购数量>0 AND 采购员=xxx ORDER BY 8 desc INTO CURSOR TmpMakeBuyBY READWRITE 
	SELECT TmpMakeBuyBY
	TT=RECCOUNT()
	mtitle=xxx+'['+ALLTRIM(STR(EEND))+'周前'+ALLTRIM(STR(TT))+']缺料：'
	m_note1=''
*!*		mtitle='第['+ALLTRIM(STR(eend))+']周之前'
*!*		m_note1=xxx+'共有['+ALLTRIM(STR(TT))+']种货品缺料：'
	mrev='王亚萍;'&&+xxx+';'

	GO TOP
	s=''
	DO WHILE .NOT. EOF()
		IF  MC002='包装库'
			IF '顾莹莹;'$mrev=.F.
				mrev=mrev+'顾莹莹;'
			ENDIF	
		ELSE
			IF '夏萍芳;'$mrev=.F.
				mrev=mrev+'夏萍芳;'
			ENDIF	
		ENDIF 
		KEYTXT=ALLT(TB003)
		FD=''

		IF 提前期<>0
			FD='提前['+ALLTRIM(STR(提前期))+'天]'
		ENDIF	
		IF MC004<>0
			FD=FD+'安全量['+ALLTRIM(STR(INT(MC004)))+']'
		ENDIF	
		IF MC006<>0
			FD=FD+'经济批量['+ALLTRIM(STR(INT(MC006)))+']'
		ENDIF
		SQLEXEC(CON,"SELECT distinct TA001+TA002 AS UDF55, convert(char(10),CAST(TB015 as datetime),102) 要求交期,COPMA.MA002 AS 客户名称 "+;
		"FROM MOCTA INNER JOIN MOCTB ON TA001=TB001 and TA002=TB002 LEFT JOIN  COPTC ON TA033=RTRIM(TC001)+TC002 "+;
		"  LEFT JOIN COPMA ON TC004=COPMA.MA001 inner join INVMB ON TB003=MB001 "+;
		"WHERE year(dateadd(day,0-ISNULL(INVMB.MB036,0),TB015))*100+cast(DATENAME( Wk,dateadd(day,0-ISNULL(INVMB.MB036,0),TB015)) as int)<=?EEND and COPMA.MA002 NOT LIKE '%PHILIPS(OEM)%' "+;
		" AND not exists (select 'x' from MOCTA T INNER JOIN INVMB M ON T.TA006=M.MB001 WHERE T.TA033=MOCTA.TA033 AND T.TA006=TB003 AND (MOCTB.TB004=MOCTB.TB005 OR T.TA015-T.TA017<=M.MB064)) "+;
		"AND TB004<>TB005 AND TB003=?KEYTXT AND TB004>TB005 AND MOCTA.TA011<='3'  AND MOCTA.TA013='Y' ORDER BY 2","TMP")  &&and MOCTA.UDF56=1 CAST(LEFT(TB015,4) as int)*100+cast(DATENAME( Wk,CAST(TB015 AS DATETIME)) as int)-ISNULL(INVMB.MB036,0)<=?EEND 
		SELECT TMP
		GO TOP
		DO WHILE .NOT. EOF()
			IF LEN(FD)<210
				IF ISNULL(客户名称)
					FD=FD+ALLTRIM(UDF55)+'('+ALLTRIM(要求交期)+')；'
				ELSE
					FD=FD+ALLTRIM(UDF55)+'('+ALLTRIM(要求交期)+')['+ALLTRIM(客户名称)+']；'
				ENDIF	
			ELSE
				FD=FD+'...'
				EXIT
			ENDIF	
			SKIP
		ENDDO
		SELECT TmpMakeBuyBY
		REPLACE PI WITH FD
		S=S+ALLTRIM(STR(RECNO()))+'.'+ALLTRIM(品名)+ALLTRIM(规格)+'['+ALLTRIM(KEYTXT)+','+ALLTRIM(采购员)+']缺数:'+ALLTRIM(STR(需采购数量))+'='
		IF 工单需要数>0
			s=s+ALLTRIM(STR(工单需要数-已领数量))+'(工单)'
		ENDIF 
		IF 订单直接采购>0
			s=s+'+'+ALLTRIM(STR(订单直接采购))+'(订单)'
		ENDIF 
		IF 调拨未完成>0
			s=s+'+'+ALLTRIM(STR(调拨未完成))+'(调拨)'
		ENDIF 
*!*			IF 已领数量>0
*!*				s=s+'-'+ALLTRIM(STR(已领数量))+'(已领数量)'
*!*			ENDIF 
		IF 在途量>0
			s=s+'-'+ALLTRIM(STR(在途量))+'(在途)'
		ENDIF
		IF 最新结存>0
			s=s+'-'+ALLTRIM(STR(最新结存))+'(主库)'
		ENDIF 
		IF 配料中转>0
			s=s+'-'+ALLTRIM(STR(配料中转))+'(中转)'
		ENDIF		
		IF 请购未采购>0
			s=s+'[请购未采购:'+ALLTRIM(STR(请购未采购))+']'
		ENDIF 
		s=s+'['+ALLTRIM(FD)+']'+CHR(13)+CHR(10)
		SKIP
	ENDDO	
	
	DO CASE 	
		CASE  LEN(ALLTRIM(m_note1+s))<=2200 
			m_note=ALLTRIM(LEFT(m_note1+s,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
		CASE  LEN(ALLTRIM(m_note1+s))>2200  AND LEN(ALLTRIM(m_note1+s))<=4400
			m_note=ALLTRIM(SUBS(m_note1+s,1,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,2201,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
		CASE  LEN(ALLTRIM(m_note1+s))>4400  AND LEN(ALLTRIM(m_note1+s))<=6600
			m_note=ALLTRIM(LEFT(m_note1+s,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,2201,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,4401,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
		CASE  LEN(ALLTRIM(m_note1+s))>6600  AND LEN(ALLTRIM(m_note1+s))<=8800
			m_note=ALLTRIM(LEFT(m_note1+s,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,2201,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,4401,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 	
			m_note=ALLTRIM(SUBS(m_note1+s,6601,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 	
		OTHERWISE 
			m_note=ALLTRIM(LEFT(m_note1+s,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,2201,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,4401,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 	
			m_note=ALLTRIM(SUBS(m_note1+s,6601,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 	
			m_note=ALLTRIM(SUBS(m_note1+s,8801,2200))+'...'
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 			
	ENDCASE	
	SQLDISCONNECT(keyidid1)
	SELECT tmpmake
	SKIP
ENDDO 	


********************************************************************************

con=odbc(5)

  IF  sqlexec(con,"SELECT TD004,TD005 品名,TD006 规格,"+;
  "SUM(TD008-TD015) AS 在途量,"+;
	" 0000000 最新结存 ,0000000 配料中转,0000000  as 需用数量,0000000 需采购数量, 0000000 请购未采购 ,"+;
	"0000000 调拨未完成,0000000  as 工单需要数,0000000 订单直接采购,INVMB.MB036 提前期,"+;
	"MV002 AS 采购员,CAST(MV002 AS CHAR(250)) PI,CMSMC.MC002,isnUll(M.MC004,0) MC004,ISNULL(M.MC006,0) MC006,INVMB.MB410  "+;
	"FROM PURTC AS PURTC INNER JOIN PURTD ON TC001=TD001 AND TC002=TD002 "+;
	" INNER JOIN INVMB ON TD004 = INVMB.MB001 inner JOIN CMSMV ON MB067 = CMSMV.MV001 "+;
	"left JOIN INVMA CA ON CA.MA002=INVMB.MB006 AND CA.MA001='2'  LEFT JOIN CMSMC as CMSMC ON INVMB.MB017=CMSMC.MC001 LEFT JOIN INVMC M ON MB017=M.MC002 AND MB001=M.MC001  "+;
	" where  PURTD.TD016='N' AND PURTD.TD018<>'V' AND TD024 NOT LIKE '227%' and TD026<>'312' "+;
	" AND CA.MA003<>'彩包'  AND INVMB.MB006<>'990050' AND TD004<'A' and CMSMC.MC001<>'98'  and TD008<>0 "+;
	"  AND MV002<>'鲁鹤明'  AND INVMB.MB042<>'2' GROUP BY TD004,TD005,TD006,MV002,INVMB.MB036,CMSMC.MC002,ISNULL(M.MC004,0),ISNULL(M.MC006,0),INVMB.MB410 " ,"TmpMakeBuy1")<0  
		WAIT WINDOWS 'ERROR'
		RETURN
*		" and not exists (select 'x' from PURTD WHERE MOCTA.TA033=TD024 AND TD004=TB003 AND TD018='Y') AND&&AND MOCTA.UDF56=1MOCTA.UDF03>=?FEND AND  "+;
*	" AND not exists (select 'x' from MOCTA T INNER JOIN INVMB M ON T.TA006=M.MB001 WHERE T.TA033=MOCTA.TA033 AND T.TA006=TB003 AND (MOCTB.TB004=MOCTB.TB005 OR T.TA015-T.TA017<=M.MB064)) "+;

	ENDIF

SQLEXEC(con,"SELECT TB004,SUM(TB007) TB007 FROM INVTB INNER JOIN INVTA ON TA001=TB001 AND TA002=TB002 WHERE  "+;
" TA006='N' AND (TB013='21' OR TB013='23') AND TB018='Y'  GROUP BY TB004","TMWP3") && LEFT(TA003 ,4)+'.'+DATENAME( Wk,CAST(TA003 AS DATETIME))>=?FEND AND AND LEFT(TA003 ,4)+'.'+DATENAME( Wk,CAST(TA003 AS DATETIME))<=?EEND

 SELECT TmpMakeBuy1

lcmsg = '正在整理订单需要的物料...'
 GO TOP
 DO WHILE  .NOT. EOF()
      SELECT TmpMakeBuy1
      a1 = ''
      keytxt = RTRIM(TD004)

		XX=0
		XX1=0
		CODE31ID1=0
	  	CODE31ID2=0

		SQLEXEC(con,"SELECT SUM(TB009) TD007 FROM PURTB WHERE TB004=?KEYTXT  AND TB021='N' AND TB025='Y' AND TB020='Y' AND "+;
		"CAST(LEFT(TB019,4) as int)*100+cast(DATENAME( Wk,CAST(TB019 AS DATETIME)) as int)<=?EEND AND TB001<>'312'","TMP3")  &&LEFT(TB019,4)+'.'+DATENAME( Wk,CAST(TB019 AS DATETIME))>=?FEND AND 
		IF RECCOUNT()=1  AND !ISNULL(TD007)
			IF ISNULL(TD007)
		  		CODE31ID1=0
		  	ELSE
		  		CODE31ID1=TD007
		  	ENDIF
		ELSE  	
	  		CODE31ID1=0
	  	ENDIF		
		SELECT tmpmakebuy1
		REPLACE 请购未采购 WITH	 CODE31ID1 	
		SQLEXEC(con,"SELECT SUM(TD008) TD007 FROM COPTD WHERE TD004=?KEYTXT  AND TD016='N' AND TD021='Y' AND "+;
		" CAST(LEFT(TD013,4) as int)*100+cast(DATENAME( Wk,CAST(TD013 AS DATETIME)) as int)<=?EEND","TMP3")  &&LEFT(TD013,4)+'.'+DATENAME( Wk,CAST(TD013 AS DATETIME))>=?FEND AND
		IF RECCOUNT()=1  AND !ISNULL(TD007)
			IF ISNULL(TD007)
		  		CODE31ID2=0
		  	ELSE
		  		CODE31ID2=TD007
		  	ENDIF
		ELSE  	
	  		CODE31ID2=0
	  	ENDIF		
		SELECT tmpmakebuy1
		REPLACE 订单直接采购 WITH	 CODE31ID2
		SELECT TMWP3
		LOCATE FOR TB004=KEYTXT
		IF FOUND()
			CODE2ID=TB007 
		ELSE
			CODE2ID=0
		ENDIF
		SQLEXEC(con,"select SUM(TB004-TB005) SS FROM MOCTA INNER JOIN MOCTB ON TA001=TB001 AND TA002=TB002 WHERE TA011<='3' AND TB003=?keytxt AND TA013='Y'")
		IF RECCOUNT()=1 AND !ISNULL(SS)
			XX=SS
		ELSE 
			XX=0	
		ENDIF	
		SELECT tmpmakebuy1

		REPLACE 工单需要数 WITH XX,需用数量 WITH XX+CODE2ID+订单直接采购,调拨未完成 WITH CODE2ID	

				


	SQLEXEC(con,"SELECT MC007  FROM INVMC  WHERE MC002='50' AND MC001=?KEYTXT","TMP3")
	SELECT tmp3
	IF RECCOUNT()=1
		IF ISNULL(MC007)
	  		CODEID=0
	  	ELSE
		  	codeid=MC007
	  	ENDIF
		SELECT TmpMakeBuy1
		REPLACE 配料中转 WITH CODEID
		Closedb("TMP3")
	ELSE 
		SELECT TmpMakeBuy1
		REPLACE 配料中转 WITH 0
	ENDIF 

	SQLEXEC(con,"SELECT SUM(X.MC007) MC007 FROM INVMC X LEFT JOIN CMSMC Y ON X.MC002=Y.MC001"+;
	" WHERE X.MC001=?KEYTXT AND X.MC002<>'50' AND  X.MC002<>'19'  AND X.MC002<>'21'  AND X.MC002<>'22' AND Y.MC002 NOT LIKE '%现场%'","TMP3")
	SELECT tmp3
	IF RECCOUNT()=1
		IF ISNULL(MC007)
	  		CODEID=0
	  	ELSE
	  		codeid=MC007
	  	ENDIF
		SELECT TmpMakeBuy1
		REPLACE 最新结存 WITH CODEID
		Closedb("TMP3")
	ELSE 
		SELECT TmpMakeBuy1
		REPLACE 最新结存 WITH 0
	ENDIF 

	SELECT TmpMakeBuy1
	replace 需采购数量 WITH 工单需要数*1.03+订单直接采购*1.03+调拨未完成*1.03+MC004-最新结存-配料中转

	SELECT TmpMakeBuy1
	skip
 ENDDO    
     
  closedb("TmpMakeBuyBY")
   	SELECT distinct 采购员 FROM TmpMakeBuy1 WHERE  在途量-需采购数量>MC006 AND 在途量-需采购数量>MB410  INTO CURSOR TmpMake
   	SELECT tmpmake
   	GO top
DO whil .not. EOF()
	xxx=ALLTRIM(采购员)
	closedb("TmpMakeBuyBY")
   	SELECT 在途量-IIF(需采购数量<0,0,需采购数量) TC,* FROM TmpMakeBuy1 WHERE 在途量-需采购数量>MC006  AND 在途量-需采购数量>MB410 AND 采购员=xxx ORDER BY 1 desc INTO CURSOR TmpMakeBuyBY READWRITE 
	SELECT TmpMakeBuyBY
	TT=RECCOUNT()
	mtitle=xxx+'['+ALLTRIM(STR(EEND))+'周前'+ALLTRIM(STR(TT))+']过剩：'
	m_note1=''
	mrev='王亚萍;'&&+xxx+';'

	GO TOP
	s=''
	DO WHILE .NOT. EOF()
		IF  MC002='包装库'
			IF '顾莹莹;'$mrev=.F.
				mrev=mrev+'顾莹莹;'
			ENDIF	
		ELSE
			IF '夏萍芳;'$mrev=.F.
				mrev=mrev+'夏萍芳;'
			ENDIF	
		ENDIF 
		KEYTXT=ALLT(TD004)
		FD=''

		IF 提前期<>0
			FD='需['+ALLTRIM(STR(提前期))+'天]'
		ENDIF	
		IF MC004<>0
			FD=FD+'安全量['+ALLTRIM(STR(INT(MC004)))+']'
		ENDIF	
		IF MC006<>0
			FD=FD+'经济批量['+ALLTRIM(STR(INT(MC006)))+']'
		ENDIF
		IF MB410<>0
			FD=FD+'定量['+ALLTRIM(STR(INT(MB410)))+']'
		ENDIF
		SQLEXEC(CON,"SELECT distinct TD001+RTRIM(TD002)+'-'+TD003 AS UDF55, convert(char(10),CAST(TD012 as datetime),102) 要求交期,TD008-TD015 AS 数量,TD018 "+;
		"FROM PURTC AS PURTC INNER JOIN PURTD ON TC001=TD001 AND TC002=TD002 "+;
		"WHERE   PURTD.TD016='N' AND PURTD.TD018<>'V' AND TD004=?KEYTXT AND TD026<>'312' and TD008<>0 AND TD024 NOT LIKE '227%' ORDER BY 2 desc","TMP") 
		SELECT TMP
		GO TOP
		DO WHILE .NOT. EOF()
			IF LEN(FD)<210
				FD=FD+ALLTRIM(UDF55)+'('+ALLTRIM(要求交期)+')'+TD018+'['+ALLTRIM(STR(INT(数量)))+']；'
			ELSE
				FD=FD+'...'
				EXIT
			ENDIF	
			SKIP
		ENDDO
		SELECT TmpMakeBuyBY
		REPLACE PI WITH FD
		fdddd=工单需要数+订单直接采购+调拨未完成-最新结存-配料中转  &&+MC004
		S=S+ALLTRIM(STR(RECNO()))+'.'+ALLTRIM(品名)+ALLTRIM(规格)+'['+ALLTRIM(KEYTXT)+','+ALLTRIM(采购员)+']过剩:'+ALLTRIM(STR(在途量-IIF(fdddd>0,fdddd,0)))+'='
		IF 在途量>0
			s=s+ALLTRIM(STR(在途量))+'(采购)－'+ALLTRIM(STR(fdddd))+'(缺数)'
		ENDIF
		S=S+',缺数='
		IF 工单需要数>0
			s=s+ALLTRIM(STR(工单需要数))+'(工单)'
		ENDIF 
		IF 订单直接采购>0
			s=s+'+'+ALLTRIM(STR(订单直接采购))+'(订单)'
		ENDIF 
		IF 调拨未完成>0
			s=s+'+'+ALLTRIM(STR(调拨未完成))+'(调拨)'
		ENDIF 
*!*			IF INT(需采购数量*0.03)>0
*!*				s=s+'+'+ALLTRIM(STR(INT(需采购数量*0.03)))+'(损耗)'
*!*			ENDIF 
*!*			IF MC004>0
*!*				s=s+'+'+ALLTRIM(STR(INT(MC004)))+'(安全)'
*!*			ENDIF 

		IF 最新结存>0
			s=s+'-'+ALLTRIM(STR(最新结存))+'(主库)'
		ENDIF 
		IF 配料中转>0
			s=s+'-'+ALLTRIM(STR(配料中转))+'(中转)'
		ENDIF		
		IF 请购未采购>0
			s=s+'[请购未采购:'+ALLTRIM(STR(请购未采购))+']'
		ENDIF 
		s=s+'{'+ALLTRIM(FD)+'}'+CHR(13)+CHR(10)
		SKIP
	ENDDO	
	DO CASE 	
		CASE  LEN(ALLTRIM(m_note1+s))<=2200 
			m_note=ALLTRIM(LEFT(m_note1+s,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
		CASE  LEN(ALLTRIM(m_note1+s))>2200  AND LEN(ALLTRIM(m_note1+s))<=4400
			m_note=ALLTRIM(LEFT(m_note1+s,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,2201,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
		CASE  LEN(ALLTRIM(m_note1+s))>4400  AND LEN(ALLTRIM(m_note1+s))<=6600
			m_note=ALLTRIM(LEFT(m_note1+s,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,2201,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,4401,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
		CASE  LEN(ALLTRIM(m_note1+s))>6600  AND LEN(ALLTRIM(m_note1+s))<=8800
			m_note=ALLTRIM(LEFT(m_note1+s,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,2201,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,4401,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 	
			m_note=ALLTRIM(SUBS(m_note1+s,6601,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 	
		OTHERWISE 
			m_note=ALLTRIM(LEFT(m_note1+s,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,2201,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,4401,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 	
			m_note=ALLTRIM(SUBS(m_note1+s,6601,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 	
			m_note=ALLTRIM(SUBS(m_note1+s,8801,2200))+'...'
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 			
	ENDCASE	
	SQLDISCONNECT(keyidid1)
	SELECT tmpmake
	SKIP
ENDDO 	


  SQLDISCONNECT(CON)

ENDPROC 
PROCEDURE YXHYSK

CON=ODBC(5)
SQLEXEC(CON,"SELECT ACRTA.TA020,CMSMV.MV001,(ACRTA.TA029+ACRTA.TA030-ACRTA.TA031)*(case when ACRTA.TA079='1' then 1 else -1 end)*ACRTA.TA010 CASH,"+;
"CMSMV.MV002,RTRIM(COPMA.MA002)+'('+RTRIM(COPMA.MA001)+')' AS MA002,rtrim(ACRTA.TA001)+rtrim(ACRTA.TA002) AS 单号,CAST('发票:'+RTRIM(ACRTA.TA036)+'/'+RTRIM(ACRTA.TA015)+'['+RTRIM(CMSNA.NA003)+"+;
"']('+RTRIM(str((ACRTA.TA029+ACRTA.TA030-ACRTA.TA031)*(case when ACRTA.TA079='1' then 1 else -1 end),8,2))+ACRTA.TA009+')愈'+"+;
"str(datediff(day,ACRTA.TA020,getdate()),3,0)+'天('+CONVERT(varchar(10), CAST(ACRTA.TA020 as datetime), 102)+DATENAME( weekday, CAST(ACRTA.TA020 as datetime))"+;
"+')'+CASE WHEN ACRTQ.TQ006 IS NULL OR ACRTQ.TQ006='' THEN '' ELSE ACRTQ.TQ006 END+"+;
"CASE WHEN ACRTA.UDF51 IS NULL OR ACRTA.UDF51=0 THEN '' ELSE ',报关差异:'+str(isnull(ACRTA.UDF51,0),7,2) END AS CHAR(200)) AS NOTE "+;
"from ACRTA left join CMSME on ME001=TA070 LEFT JOIN COPMA ON MA001=TA004 left join CMSMV on MV001=COPMA.MA016 "+;
"left join ACRTQ on ACRTQ.TQ002=ACRTA.TA001 and ACRTQ.TQ003=ACRTA.TA002 and ACRTQ.CREATE_DATE=(select max(ACRTQ.CREATE_DATE) "+;
" from ACRTQ where ACRTQ.TQ002=ACRTA.TA001 and ACRTQ.TQ003=ACRTA.TA002) left join CMSNA on CMSNA.NA001='2' and CMSNA.NA002=ACRTA.TA043  "+;
" where (TA029+TA030-TA031)*(case when TA079='1' then 1 else -1 end)<>0 and ACRTA.TA025 = 'Y' and  rtrim(ACRTA.TA001)+rtrim(ACRTA.TA002)"+;
" not in ('665201208003','665201208022')  and datediff(day,ACRTA.TA020,getdate())>=-7  "+;
"union all "+;
"SELECT ACRTK.TK003,CMSMV.MV001,(TK032+TK034-ACRTK.TK037)*ACRTK.TK008,"+;
"CMSMV.MV002,RTRIM(COPMA.MA002)+'('+RTRIM(COPMA.MA001)+')' AS MA002,rtrim(ACRTK.TK001)+rtrim(ACRTK.TK002) AS 单号,"+;
"CAST('预收:'+RTRIM(ACRTK.TK009)+'['+RTRIM(CMSNA.NA003)+']('+RTRIM(str((TK032+TK034-ACRTK.TK037),8,2))+"+;
"ACRTK.TK007+')愈'+str(datediff(day,ACRTK.TK003,getdate()),3,0)+'天('+CONVERT(varchar(10), CAST(ACRTK.TK003 as datetime), 102)+DATENAME( weekday, CAST(ACRTK.TK003 as datetime))+')' AS CHAR(200)) from ACRTK  "+;
"left join COPMA ON COPMA.MA001=ACRTK.TK004 left join CMSMV on CMSMV.MV001=COPMA.MA016 left join CMSNA on CMSNA.NA001='2' and CMSNA.NA002=COPMA.MA083 "+;
"where (ACRTK.TK030 <> '3') AND (ACRTK.TK020 = 'Y') and datediff(day,ACRTK.TK003,getdate())>=30 ","TMP")
SQLDISCONNECT(CON)
REPLACE note WITH STRTRAN(note,	CHR(9), "") ALL
REPLACE note WITH STRTRAN(note, " ", "") ALL

	closedb("TMPSALES")
	SELECT DISTINCT MV002 as 业务员,MV001,MA002 FROM tmp INTO CURSOR TMPSALES
	SELECT TMPSALES
	GO TOP
	DO WHIL .NOT. EOF()
		XXX=ALLTRIM(业务员)
		YYY=ALLTRIM(MV001)
		zzz=ALLTRIM(MA002)
		IF USED("TMPBUYETR")
			SELECT TMPBUYETR
			USE
		ENDIF	

		SELECT * FROM tmp WHERE ALLTRIM(MV002)==XXX AND MA002=ZZZ ORDER BY 6,4,3 DESC  INTO CURSOR TMPBUYETR
		SELECT TMPBUYETR
		SUM cash TO wdet
		TT=RECCOUNT()
		TK0031=ALLTRIM(note)
		
		m_note=ZZZ+':共有['+ALLTRIM(STR(RECCOUNT()))+']张逾期应收与预收,总额('+ALLTRIM(STR(INT(wdet)))+'元)：'
		mtitle='['+ALLTRIM(XXX)++']'+'逾期应收与预收'

		GO TOP
		T=''
		DO WHIL .NOT. EOF()

			IF LEN(ALLTRIM(T+ALLTRIM(note)))<1500
				T=T+ALLTRIM(STR(RECNO()))+'.'+ALLTRIM(单号)+ALLTRIM(note)+CHR(13)+CHR(10)
			ELSE
				T=T+CHR(13)+CHR(10)+'...'
				EXIT
			ENDIF
			SKIP
		ENDDO		
		SELECT TOP 1 TA020 FROM  TMPBUYETR  ORDER BY 1 INTO CURSOR tmpew
		SELECT tmpew
		XTI003=TA020
		USE 
		mrev=ALLTRIM(XXX)+';谢利利;'
		CON=ODBC(11)
		sqlexec(con,"select a.CnName from Employee as a  left join Job as F on A.JobId=F.JobId left join EmployeePartJob as g on A.EmployeeID=g.EmployeeID "+;
		"left join Job as y on g.JobId=y.JobId  where (rTRIM(f.Name)='销售会计' or rTRIM(y.Name)='销售会计' ) AND EmployeeStateId<>'EmployeeState3001'","tmpempinfo")		
		SQLDISCONNECT(CON)
		
		IF RECCOUNT()>=1
			GO TOP 
			DO whil .not. EOF()
				mrev=mrev+ALLTRIM(CnName)+';'
				SKIP
			ENDDO 	
		ENDIF 

		SELECT TMPBUYETR  
		m_note=m_note+CHR(13)+CHR(10)+T+CHR(13)+CHR(10)+'__________________________________________________'+CHR(13)+CHR(10)+'注：应收与预收将到期或已逾期,请及时跟催或校对！超过30天提醒本人；超过45天提醒本人和部门主管。'
		GO TOP 
		CDATE1=DTOC(DATE()-45,1)
		IF XTI003<CDATE1
			CON1=ODBC(11)

			IF SQLEXEC(con1,"select a.code,isnull(b.CnName,'') AS Director,isnull(b.code,'') AS Direc,isnull(j.code,'') as major,Corporation.Name Cropname, E.Floorcode deptid, "+;
			   " isnull(E.Name,'') as Department,e.code as olddeptid,j.name as Parentdept,f.cnname,SUBSTRING(g.jobgradeid,10,3) job,Corporation.ShortName, E.Floorcode "+;
			   " from Employee as A  "+;
		"left join Department as E on A.DepartmentId=E.DepartmentId left join Employee as B on b.EmployeeId =e.Principal  inner join EmployeeState q on b.EmployeeStateId=q.EmployeeStateId"+;
		" AND (q.EmployeeStateTypeId='EmployeeStateType_001' OR q.EmployeeStateTypeId='EmployeeStateType_002')"+;
			   " left join Department as j on E.parentid=j.DepartmentId left join Employee f on  b.DirectorId=f.EmployeeId left join Job as g on A.JobId=g.JobId  "+;
			   "LEFT JOIN  Corporation ON A.CorporationId = Corporation.CorporationId "+;
			   " where A.Code=?YYY","tmpgetdept")<0
				WAIT windows '????'
			ENDIF 
			SQLDISCONNECT(CON1)
			IF ALLTRIM(Director)<>'方毅'
				mrev=mrev+ALLTRIM(Director)+';姚旭辉;'
			ELSE
				mrev=mrev+';姚旭辉;'
			ENDI	
*!*				CDATE2=DTOC(DATE()-60,1)
*!*				IF XTI003<CDATE2 AND !EMPTY(cnname)
*!*					mrev=mrev+ALLTRIM(cnname)+';盛哲辉;'
*!*				ENDIF
*!*				CDATE2=DTOC(DATE()-100,1)
*!*				IF XTI003<CDATE2 
*!*					mrev=mrev+'陈调凤;'
*!*				ENDIF

		ENDIF

		
		tmpkeyid=maxinterid("rtxmessage")
		keyidid1=ODBC(6)

*!*			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,0)")<0
*!*				WAIT windows '????订单超期'+mrev nowait
*!*			ENDIF 
		SQLDISCONNECT(keyidid1)
		SELECT TMPSALES
		SKIP
	ENDDO
*****************************************
ENDPROC 
PROCEDURE YXH
	CDATE=DTOC(DATE()-30,1)
	CON=ODBC(5)
	SQLEXEC(CON,"select PURTJ.TJ001+ PURTJ.TJ002+PURTJ.TJ003+'['+rtrim(PURMA.MA002)+']'+rtrim(INVMB.MB001)+':'+rtrim(INVMB.MB002)+rtrim(INVMB.MB003)+',数量:'+"+;
	"LTRIM(str(PURTJ.TJ048-PURTJ.TJ036,6))+"+;
	"'('+LTRIM(str((PURTJ.TJ032+PURTJ.TJ033)/PURTJ.TJ048*(PURTJ.TJ048-PURTJ.TJ036),10,2))+'元)愈'+lTRIM(str(datediff(day,PURTI.TI003,getdate()),3,0))+'天！' as yxh,PURTI.TI003,"+;
	"CMSMV.MV002,CMSMV.MV001,PURMA.MA002,PURTJ.TJ032+PURTJ.TJ033 cash "+;
	"from DEMO.dbo.PURTI LEFT JOIN PURTJ ON PURTJ.TJ001=PURTI.TI001 AND PURTJ.TJ002=PURTI.TI002 LEFT JOIN PURMA ON PURMA.MA001=PURTI.TI004 "+;
	"LEFT JOIN INVMB on INVMB.MB001=PURTJ.TJ004	left join CMSMV on CMSMV.MV001=INVMB.MB067	where (PURTJ.TJ048-PURTJ.TJ036 <>0) "+;
	"and (PURTI.TI013 = 'Y') and (PURTJ.TJ020='Y' and PURTI.TI003<?cdate) ","TMP")
	SQLEXEC(CON,"select MOCTL.TL001+MOCTL.TL002+MOCTL.TL003+'['+rtrim(PURMA.MA001)+' '+rtrim(PURMA.MA002)+']'+ "+;
	"rtrim(INVMB.MB001)+':'+rtrim(INVMB.MB002)+rtrim(INVMB.MB003)+',数量:'+LTRIM(str(MOCTL.TL009-MOCTL.TL035,5,0))+'('+LTRIM(str((MOCTL.TL031+MOCTL.TL032)"+;
	"/MOCTL.TL009*(MOCTL.TL009-MOCTL.TL035),8,2))+'元)逾'+ "+;
	"lTRIM(str(datediff(day,MOCTK.TK003,getdate()),3,0))+'天！',MOCTK.TK003,CMSMV.MV002,CMSMV.MV001,PURMA.MA002,MOCTL.TL031+MOCTL.TL031 cash "+;
	"FROM MOCTK LEFT JOIN MOCTL ON MOCTK.TK001=MOCTL.TL001 AND MOCTK.TK002=MOCTL.TL002 "+;
	"LEFT JOIN PURMA ON PURMA.MA001=MOCTK.TK004	LEFT JOIN INVMB on INVMB.MB001=MOCTL.TL004	left join CMSMV on CMSMV.MV001=INVMB.MB067 "+;
	"WHERE MOCTL.TL009-MOCTL.TL035 <>0 and (MOCTK.TK021 = 'Y') and (MOCTL.TL024 = 'Y') and MOCTK.TK003>'20110101'  and MOCTK.TK003<?cdate","TMP1")
	SQLDISCONNECT(CON)
	SELECT TMP1
	DO WHIL .NOT. EOF()
		SCATTER TO MLHBW
		SELECT TMP
		APPEND BLANK 
		GATHER FROM MLHBW
		SELECT TMP1
		SKIP
	ENDDO
	SELECT TMP
	TABLEUPDATE(.T.)	
	closedb("TMPSALES")
	SELECT DISTINCT MV002 as 业务员,MV001 FROM tmp INTO CURSOR TMPSALES
	SELECT TMPSALES
	GO TOP
	DO WHIL .NOT. EOF()
		XXX=ALLTRIM(业务员)
		YYY=ALLTRIM(MV001)
		IF USED("TMPBUYETR")
			SELECT TMPBUYETR
			USE
		ENDIF	

		SELECT * FROM tmp WHERE ALLTRIM(MV002)==XXX ORDER BY 5 INTO CURSOR TMPBUYETR
		SELECT TMPBUYETR
		SUM cash TO wdet
		TT=RECCOUNT()
		TK0031=ALLTRIM(yxh)
		
		m_note='共有['+ALLTRIM(STR(RECCOUNT()))+']张未开票的耀泰ERP退货单逾期,总额('+ALLTRIM(STR(INT(wdet)))+'元)：'
		mtitle='['+ALLTRIM(XXX)+']逾期退货单'

		GO TOP
		T=''
		DO WHIL .NOT. EOF()

			IF LEN(ALLTRIM(T+ALLTRIM(yxh)))<1500
				T=T+ALLTRIM(STR(RECNO()))+'.'+ALLTRIM(yxh)+CHR(13)+CHR(10)
			ELSE
				T=T+CHR(13)+CHR(10)+'...'
				EXIT
			ENDIF
			SKIP
		ENDDO		
		SELECT TOP 1 TI003 FROM  TMPBUYETR  ORDER BY 1 INTO CURSOR tmpew
		SELECT tmpew
		XTI003=TI003
		USE 
		CON=ODBC(11)
		sqlexec(con,"select a.CnName from Employee as a  left join Job as F on A.JobId=F.JobId where rTRIM(f.Name)='采购会计' AND EmployeeStateId<>'EmployeeState3001'","tmpempinfo")		
		SQLDISCONNECT(CON)
		IF RECCOUNT()>=1
			mrev=ALLTRIM(XXX)+';'+ALLTRIM(CnName)+';'
		ENDIF 

		SELECT TMPBUYETR  
		m_note=m_note+CHR(13)+CHR(10)+T+CHR(13)+CHR(10)+'__________________________________________________'+CHR(13)+CHR(10)+'注：已超期30天,请及时跟催对方单位开票冲账！超过30天提醒本人；超过45天提醒本人和部门主管,；超过60天提醒本人和部门主管,中心总监；超过100天报公司管理进入稽查。'
		GO TOP 
		CDATE1=DTOC(DATE()-45,1)
		IF XTI003<CDATE1
			CON1=ODBC(11)

			IF SQLEXEC(con1,"select a.code,isnull(b.CnName,'') AS Director,isnull(b.code,'') AS Direc,isnull(j.code,'') as major,Corporation.Name Cropname, E.Floorcode deptid, "+;
			   " isnull(E.Name,'') as Department,e.code as olddeptid,j.name as Parentdept,f.cnname,SUBSTRING(g.jobgradeid,10,3) job,Corporation.ShortName, E.Floorcode "+;
			   " from Employee as A  "+;
		"left join Department as E on A.DepartmentId=E.DepartmentId left join Employee as B on b.EmployeeId =e.Principal  inner join EmployeeState q on b.EmployeeStateId=q.EmployeeStateId"+;
		" AND (q.EmployeeStateTypeId='EmployeeStateType_001' OR q.EmployeeStateTypeId='EmployeeStateType_002')"+;
			   " left join Department as j on E.parentid=j.DepartmentId left join Employee f on  b.DirectorId=f.EmployeeId left join Job as g on A.JobId=g.JobId  "+;
			   "LEFT JOIN  Corporation ON A.CorporationId = Corporation.CorporationId "+;
			   " where A.Code=?YYY","tmpgetdept")<0
				WAIT windows '????'
			ENDIF 
			SQLDISCONNECT(CON1)
			mrev=mrev+ALLTRIM(Director)+';姚旭辉;'
			CDATE2=DTOC(DATE()-60,1)
			IF XTI003<CDATE2 AND !EMPTY(cnname)
				mrev=mrev+ALLTRIM(cnname)+';盛哲辉;'
			ENDIF
			CDATE2=DTOC(DATE()-100,1)
			IF XTI003<CDATE2 
				mrev=mrev+'陈调凤;'
			ENDIF

		ENDIF

		
		tmpkeyid=maxinterid("rtxmessage")
		keyidid1=ODBC(6)

*!*			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,0)")<0
*!*				WAIT windows '????订单超期'+mrev nowait
*!*			ENDIF 
		SQLDISCONNECT(keyidid1)
		SELECT TMPSALES
		SKIP
	ENDDO
*****************************************

	CON=ODBC(5)
	SQLEXEC(CON,"SELECT distinct TK003,MV001,MV002,ME002,TK030-TK035 YE,CAST(TK009 AS CHAR(200)) BZ,TK001,TK002,TK007,CAST(ACPTK.UDF01 AS CHAR(100)) GYS "+;
	" FROM ACPTK INNER JOIN CMSMV ON TK005=MV001 INNER JOIN CMSME ON TK006=ME001 WHERE TK028 <> '3' AND TK020 = 'Y' AND TK003<?CDATE order by 1","TMD1")
	SQLDISCONNECT(CON)
	closedb("TMPSALES")
	SELECT DISTINCT MV002 as 业务员,MV001  FROM TMD1 WHERE LEFT(MV001,1)='Y' INTO CURSOR TMPSALES
	SELECT TMPSALES
	GO TOP
	DO WHIL .NOT. EOF()
		XXX=ALLTRIM(业务员)
		xc=xxx
		YYY=ALLTRIM(MV001)
		IF USED("TMPBUYETR")
			SELECT TMPBUYETR
			USE
		ENDIF	

		SELECT * FROM TMD1 WHERE ALLTRIM(MV002)==XXX ORDER BY 1 INTO CURSOR TMPBUYETR
		SELECT TMPBUYETR
		TT=RECCOUNT()
		TK0031=TK003
		m_note='共有['+ALLTRIM(STR(RECCOUNT()))+']个预付单逾期：'
		mtitle='['+ALLTRIM(XXX)+']逾期预付单'

		GO TOP
		T=''
		DO WHIL .NOT. EOF()
			IF ISNULL(BZ)
				BT=''
			ELSE
				BT=ALLTRIM(BZ)
			ENDIF	
			IF ISNULL(GYS) OR ALLTRIM(GYS)==''
			ELSE
				BT='['+ALLTRIM(GYS)+']'+BT
			ENDIF				
			IF TT=1
				S=SUBSTR(TK003,1,4)+'.'+SUBSTR(TK003,5,2)+'.'+SUBSTR(TK003,7,2)+'('+TK001+ALLTRIM(TK002)+BT+')预付:'+ALLTRIM(STR(INT(YE)))+ALLTRIM(TK007)+CHR(13)+chr(10)
			ELSE
				S=ALLTRIM(STR(RECNO()))+'.'+SUBSTR(TK003,1,4)+'.'+SUBSTR(TK003,5,2)+'.'+SUBSTR(TK003,7,2)+'('+TK001+ALLTRIM(TK002)+BT+')预付:'+ALLTRIM(STR(INT(YE)))+ALLTRIM(TK007)+CHR(13)+chr(10)
			ENDIF
			IF LEN(ALLTRIM(T+S))<1500
				T=T+S
			ELSE
				T=T+CHR(13)+CHR(10)+'...'
				EXIT
			ENDIF
			SKIP
		ENDDO		

		m_note=m_note+CHR(13)+CHR(10)+T+CHR(13)+CHR(10)+'__________________________________________________'+CHR(13)+CHR(10)+'注：已超期30天,请及时跟催对方单位开票冲账！超过30天提醒本人；超过45天提醒本人和部门主管,；超过60天提醒本人和部门主管,中心总监；超过100天报公司管理进入稽查。'
		mrev=ALLTRIM(XXX)+';章玲杰;'
		CON=ODBC(11)
		sqlexec(con,"select a.CnName from Employee as a  left join Job as F on A.JobId=F.JobId left join EmployeePartJob as g on A.EmployeeID=g.EmployeeID "+;
		"left join Job as y on g.JobId=y.JobId  where (rTRIM(f.Name)='采购会计' or rTRIM(y.Name)='采购会计' ) AND EmployeeStateId<>'EmployeeState3001'","tmpempinfo")		
		SQLDISCONNECT(CON)
		
		IF RECCOUNT()>=1
			GO TOP 
			DO whil .not. EOF()
				mrev=mrev+ALLTRIM(CnName)+';'
				SKIP
			ENDDO 	
		ENDIF 
		CDATE1=DTOC(DATE()-45,1)
		IF TK0031<CDATE1
			CON1=ODBC(11)

			IF SQLEXEC(con1,"select a.code,isnull(b.CnName,'') AS Director,isnull(b.code,'') AS Direc,isnull(j.code,'') as major,Corporation.Name Cropname, E.Floorcode deptid, "+;
			   " isnull(E.Name,'') as Department,e.code as olddeptid,j.name as Parentdept,f.cnname,SUBSTRING(g.jobgradeid,10,3) job,Corporation.ShortName, E.Floorcode "+;
			   " from Employee as A  "+;
		"left join Department as E on A.DepartmentId=E.DepartmentId left join Employee as B on b.EmployeeId =e.Principal  inner join EmployeeState q on b.EmployeeStateId=q.EmployeeStateId"+;
		" AND (q.EmployeeStateTypeId='EmployeeStateType_001' OR q.EmployeeStateTypeId='EmployeeStateType_002') "+;
			   " left join Department as j on E.parentid=j.DepartmentId left join Employee f on  b.DirectorId=f.EmployeeId left join Job as g on A.JobId=g.JobId  "+;
			   "LEFT JOIN  Corporation ON A.CorporationId = Corporation.CorporationId "+;
			   " where A.Code=?YYY","tmpgetdept")<0
				WAIT windows '????'
			ENDIF 
			SQLDISCONNECT(CON1)
			mrev=mrev+ALLTRIM(Director)+';罗国静;姚旭辉;'
			IF ALLTRIM(Director)='王文雅'
				mrev=mrev+'张国兰;'
			ENDIF
			mrev=mrev+'王亚萍;'
			CDATE2=DTOC(DATE()-60,1)
			IF TK0031<CDATE2 AND !EMPTY(cnname)
				mrev=mrev+ALLTRIM(cnname)+';盛哲辉;'
			ENDIF
			CDATE2=DTOC(DATE()-100,1)
			IF TK0031<CDATE2 
				mrev=mrev+'陈调凤;'
			ENDIF

		ENDIF

		
		tmpkeyid=maxinterid("rtxmessage")
		keyidid1=ODBC(6)

*!*			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,0)")<0
*!*				WAIT windows '????订单超期'+mrev nowait
*!*			ENDIF 
		SQLDISCONNECT(keyidid1)
		SELECT TMPSALES
		SKIP
	ENDDO
**********************

	CDATE=DTOC(DATE()-30,1)

	CON=ODBC(5)
	SQLEXEC(CON,"SELECT distinct TG003,MV001,MV002,ME002,TG013+TG025 YE,CAST(TG020 AS CHAR(200)) BZ,TG001,TG002,TG011,MA002,SUBSTRING(COPMA.UDF04,8,12) DZ "+;
	" FROM COPTG INNER JOIN CMSMV ON TG006=MV001 INNER JOIN CMSME ON TG005=ME001 INNER JOIN COPMA ON MA001=TG004 "+;
	"inner join COPTH ON TH001=TG001 AND TH002=TG002 WHERE TG023= 'Y' AND TG003<?CDATE  AND TH026='N' AND TG013<>0","TMD1")
	SQLDISCONNECT(CON)
	closedb("TMPSALES")
	SELECT DISTINCT MV002 as 业务员,MV001,DZ  FROM TMD1 INTO CURSOR TMPSALES
	SELECT TMPSALES
	GO TOP
	DO WHIL .NOT. EOF()
		XXX=ALLTRIM(业务员)
		xc=ALLTRIM(DZ)
		YYY=ALLTRIM(MV001)
		IF USED("TMPBUYETR")
			SELECT TMPBUYETR
			USE
		ENDIF	

		SELECT * FROM TMD1 WHERE ALLTRIM(MV002)==XXX AND DZ=XC ORDER BY 1 INTO CURSOR TMPBUYETR
		SELECT TMPBUYETR
		TT=RECCOUNT()
		TK0031=TG003
		m_note='共有['+ALLTRIM(STR(RECCOUNT()))+']个未开票的销货单：'
		mtitle='['+ALLTRIM(XXX)+';'+XC+']逾期销货单'
		IF tt>0
		GO TOP
		T=''
		DO WHIL .NOT. EOF()
			IF ISNULL(BZ) OR EMPTY(BZ)
				BT=ALLTRIM(MA002)
			ELSE
				BT=ALLTRIM(MA002)+','+ALLTRIM(BZ)
			ENDIF	
			X1=TG001
			X2=TG002
			con=odbc(5)
			SQLEXEC(CON,"SELECT distinct TH014,TH015 FROM COPTH WHERE TH001=?X1 AND TH002=?X2","DDS")
			SQLDISCONNECT(con)
			GF=''
			GO top
			DO WHIL .NOT. EOF()
				GF=GF+TH014+ALLTRIM(TH015)+';'
				skip
			ENDDO
			BT=BT+',订单:'+GF
			SELECT TMPBUYETR
			IF TT=1
				S=SUBSTR(TG003,1,4)+'.'+SUBSTR(TG003,5,2)+'.'+SUBSTR(TG003,7,2)+'('+TG001+ALLTRIM(TG002)+BT+')销货:'+ALLTRIM(STR(INT(YE)))+ALLTRIM(TG011)+CHR(13)+chr(10)
			ELSE
				S=ALLTRIM(STR(RECNO()))+'.'+SUBSTR(TG003,1,4)+'.'+SUBSTR(TG003,5,2)+'.'+SUBSTR(TG003,7,2)+'('+TG001+ALLTRIM(TG002)+BT+')销货:'+ALLTRIM(STR(INT(YE)))+ALLTRIM(TG011)+CHR(13)+chr(10)
			ENDIF
			IF LEN(ALLTRIM(T+S))<1500
				T=T+S
			ELSE
				T=T+CHR(13)+CHR(10)+'...'
				EXIT
			ENDIF
			SKIP
		ENDDO		

		mrev=ALLTRIM(XXX)+';'
		CON=ODBC(11)
		sqlexec(con,"select a.CnName from Employee as a  left join Job as F on A.JobId=F.JobId left join EmployeePartJob as g on A.EmployeeID=g.EmployeeID "+;
		"left join Job as y on g.JobId=y.JobId  where (rTRIM(f.Name)='销售会计' or rTRIM(y.Name)='销售会计' ) AND EmployeeStateId<>'EmployeeState3001'","tmpempinfo")		
		SQLDISCONNECT(CON)
		
		IF RECCOUNT()>=1
			GO TOP 
			DO whil .not. EOF()
				mrev=mrev+ALLTRIM(CnName)+';'
				SKIP
			ENDDO 	
		ENDIF 
		IF LEN(XC)>3
			mrev=mrev+ALLTRIM(XC)+';'
		ENDIF
		m_note=m_note+CHR(13)+CHR(10)+T+CHR(13)+CHR(10)+'__________________________________________________'+CHR(13)+CHR(10)+'注：已超期30天，请及时跟催对方单位开票冲账！超过30天提醒本人；超过45天提醒本人和部门主管,；超过60天提醒本人和部门主管,中心总监；超过100天报公司管理进入稽查。'
		SELECT TMPBUYETR

		CDATE1=DTOC(DATE()-45,1)
		IF TK0031<CDATE1
			CON1=ODBC(11)

			IF SQLEXEC(con1,"select a.code,isnull(b.CnName,'') AS Director,isnull(b.code,'') AS Direc,isnull(j.code,'') as major,Corporation.Name Cropname, E.Floorcode deptid, "+;
			   " isnull(E.Name,'') as Department,e.code as olddeptid,j.name as Parentdept,f.cnname,SUBSTRING(g.jobgradeid,10,3) job,Corporation.ShortName, E.Floorcode "+;
			   " from Employee as A  "+;
		"left join Department as E on A.DepartmentId=E.DepartmentId left join Employee as B on b.EmployeeId =e.Principal inner join EmployeeState q on b.EmployeeStateId=q.EmployeeStateId"+;
		" AND (q.EmployeeStateTypeId='EmployeeStateType_001' OR q.EmployeeStateTypeId='EmployeeStateType_002') "+;
			   " left join Department as j on E.parentid=j.DepartmentId left join Employee f on  b.DirectorId=f.EmployeeId left join Job as g on A.JobId=g.JobId  "+;
			   "LEFT JOIN  Corporation ON A.CorporationId = Corporation.CorporationId "+;
			   " where A.Code=?YYY","tmpgetdept")<0
				WAIT windows '????'
			ENDIF 
			SQLDISCONNECT(CON1)
			mrev=mrev+ALLTRIM(Director)+';姚旭辉;'
			CDATE2=DTOC(DATE()-60,1)
			IF TK0031<CDATE2 AND !EMPTY(cnname)
				mrev=mrev+ALLTRIM(cnname)+';盛哲辉;'
			ENDIF
*!*				CDATE2=DTOC(DATE()-100,1)
*!*				IF TK0031<CDATE2 
*!*					mrev=mrev+'陈调凤;'
*!*				ENDIF
		ENDIF

		
		tmpkeyid=maxinterid("rtxmessage")
		keyidid1=ODBC(6)

*!*			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,0)")<0
*!*				WAIT windows '????订单超期'+mrev nowait
*!*			ENDIF 
		SQLDISCONNECT(keyidid1)
		ENDIF 
		SELECT TMPSALES
		SKIP
	ENDDO


**********************

	CDATE=DTOC(DATE()-30,1)

	CON=ODBC(5)
	SQLEXEC(CON,"SELECT distinct TI003,MV001,MV002,ME002,TI010+TI011 YE,CAST(TI020 AS CHAR(200)) BZ,TI001,TI002,TI008,MA002,SUBSTRING(COPMA.UDF04,8,12) DZ "+;
	" FROM COPTI INNER JOIN CMSMV ON TI006=MV001 INNER JOIN CMSME ON TI005=ME001 INNER JOIN COPMA ON MA001=TI004 "+;
	"inner join COPTJ ON TJ001=TI001 AND TJ002=TI002 WHERE TJ021= 'Y' AND TI003<?CDATE  AND TJ024='N' ","TMD1")
	SQLDISCONNECT(CON)
	closedb("TMPSALES")
	SELECT DISTINCT MV002 as 业务员,MV001,DZ  FROM TMD1 INTO CURSOR TMPSALES
	SELECT TMPSALES
	GO TOP
	DO WHIL .NOT. EOF()
		XXX=ALLTRIM(业务员)
		xc=ALLTRIM(DZ)
		YYY=ALLTRIM(MV001)
		IF USED("TMPBUYETR")
			SELECT TMPBUYETR
			USE
		ENDIF	

		SELECT * FROM TMD1 WHERE ALLTRIM(MV002)==XXX AND DZ=XC ORDER BY 1 DESC INTO CURSOR TMPBUYETR
		SELECT TMPBUYETR
		TT=RECCOUNT()
		TK0031=TI003
		m_note='共有['+ALLTRIM(STR(RECCOUNT()))+']个未开票的销退单：'
		mtitle='['+ALLTRIM(XXX)+';'+XC+']逾期销退单'
		IF tt>0
		GO TOP
		T=''
		DO WHIL .NOT. EOF()
			IF ISNULL(BZ) OR EMPTY(BZ)
				BT=ALLTRIM(MA002)
			ELSE
				BT=ALLTRIM(MA002)+','+ALLTRIM(BZ)
			ENDIF	
			X1=TI001
			X2=TI002
			con=odbc(5)
			SQLEXEC(CON,"SELECT distinct TJ018 AS TH014,TJ019 AS TH015 FROM COPTJ WHERE TJ001=?X1 AND TJ002=?X2","DDS")
			SQLDISCONNECT(con)
			GF=''
			GO top
			DO WHIL .NOT. EOF()
				GF=GF+TH014+ALLTRIM(TH015)+';'
				skip
			ENDDO
			BT=BT+',订单:'+GF
			SELECT TMPBUYETR
			IF TT=1
				S=SUBSTR(TI003,1,4)+'.'+SUBSTR(TI003,5,2)+'.'+SUBSTR(TI003,7,2)+'('+TI001+ALLTRIM(TI002)+BT+')销退:'+ALLTRIM(STR(INT(YE)))+ALLTRIM(TI008)+CHR(13)+chr(10)
			ELSE
				S=ALLTRIM(STR(RECNO()))+'.'+SUBSTR(TI003,1,4)+'.'+SUBSTR(TI003,5,2)+'.'+SUBSTR(TI003,7,2)+'('+TI001+ALLTRIM(TI002)+BT+')销退:'+ALLTRIM(STR(INT(YE)))+ALLTRIM(TI008)+CHR(13)+chr(10)
			ENDIF
			IF LEN(ALLTRIM(T+S))<1500
				T=T+S
			ELSE
				T=T+CHR(13)+CHR(10)+'...'
				EXIT
			ENDIF
			SKIP
		ENDDO		

		m_note=m_note+CHR(13)+CHR(10)+T+CHR(13)+CHR(10)+'__________________________________________________'+CHR(13)+CHR(10)+'注：已超期30天，请及时跟催对方单位开票冲账！超过30天提醒本人；超过45天提醒本人和部门主管,；超过60天提醒本人和部门主管,中心总监；超过100天报公司管理进入稽查。'
		mrev=ALLTRIM(XXX)+';谢利利;'
		CON=ODBC(11)
		sqlexec(con,"select a.CnName from Employee as a  left join Job as F on A.JobId=F.JobId left join EmployeePartJob as g on A.EmployeeID=g.EmployeeID "+;
		"left join Job as y on g.JobId=y.JobId  where (rTRIM(f.Name)='销售会计' or rTRIM(y.Name)='销售会计' ) AND EmployeeStateId<>'EmployeeState3001'","tmpempinfo")		
		SQLDISCONNECT(CON)
		
		IF RECCOUNT()>=1
			GO TOP 
			DO whil .not. EOF()
				mrev=mrev+ALLTRIM(CnName)+';'
				SKIP
			ENDDO 	
		ENDIF 

		IF LEN(XC)>3
			IF RECCOUNT()>=1
				mrev=mrev+ALLTRIM(XC)+';'
			ENDIF 
		ENDIF
		CDATE1=DTOC(DATE()-45,1)
		IF TK0031<CDATE1
			CON1=ODBC(11)

			IF SQLEXEC(con1,"select a.code,isnull(b.CnName,'') AS Director,isnull(b.code,'') AS Direc,isnull(j.code,'') as major,Corporation.Name Cropname, E.Floorcode deptid, "+;
			   " isnull(E.Name,'') as Department,e.code as olddeptid,j.name as Parentdept,f.cnname,SUBSTRING(g.jobgradeid,10,3) job,Corporation.ShortName, E.Floorcode "+;
			   " from Employee as A   "+;
		"left join Department as E on A.DepartmentId=E.DepartmentId left join Employee as B on b.EmployeeId =e.Principal inner join EmployeeState q on a.EmployeeStateId=q.EmployeeStateId"+;
		" AND (q.EmployeeStateTypeId='EmployeeStateType_001' OR q.EmployeeStateTypeId='EmployeeStateType_002') "+;
			   " left join Department as j on E.parentid=j.DepartmentId left join Employee f on  b.DirectorId=f.EmployeeId left join Job as g on A.JobId=g.JobId  "+;
			   "LEFT JOIN  Corporation ON A.CorporationId = Corporation.CorporationId "+;
			   " where A.Code=?YYY","tmpgetdept")<0
				WAIT windows '????'
			ENDIF 
			SQLDISCONNECT(CON1)
			mrev=mrev+ALLTRIM(Director)+';姚旭辉;'
			CDATE2=DTOC(DATE()-60,1)
			IF TK0031<CDATE2 AND !EMPTY(cnname)
				mrev=mrev+ALLTRIM(cnname)+';盛哲辉;'
			ENDIF
			CDATE2=DTOC(DATE()-100,1)
*!*				IF TK0031<CDATE2 
*!*					mrev=mrev+'陈调凤;'
*!*				ENDIF
		ENDIF

		
		tmpkeyid=maxinterid("rtxmessage")
		keyidid1=ODBC(6)

*!*			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,0)")<0
*!*				WAIT windows '????订单超期'+mrev nowait
*!*			ENDIF 
		SQLDISCONNECT(keyidid1)
		ENDIF 
		SELECT TMPSALES
		SKIP
	ENDDO
************************************
************************************
***********************************
	mtitle='['+DTOC(DATE())+']日订单商品库存现状:'
*!*		m_note='预计交期:笔数,已入库数,已出货数,库存数,库存金额[预测库存金额](料件)(万元)'+CHR(13)+CHR(10)
*!*		CON=ODBC(5)
*!*		sqlexec(con,"SELECT case when TD013<='2012' THEN '2011年前' ELSE LEFT(TD013,4)+'年' END YEAR,COUNT(*) as 次数,sum(RKSL) as RKSL,sum(DYSL) as DYSL,sum(RKSL-DYSL)  as WDYSL,SUM(CB*RKSL-CB*DYSL) CASH,"+;
*!*		"SUM(CASE WHEN TD004<'A' THEN CB*RKSL-CB*DYSL ELSE 0 END) CASH1,SUM(case when id=1 then CB*RKSL-CB*DYSL else 0 end) yc FROM getgoodsstcokforsales WHERE RKSL-DYSL>0  "+;
*!*		"GROUP BY case when TD013<='2012' THEN '2011年前' ELSE LEFT(TD013,4)+'年' END ORDER BY 1","TmpQC")&&ISNULL(LEFT(TD013,4),'')
*!*		SQLDISCONNECT(CON)
*!*		SELECT TmpQC
*!*		GO TOP
*!*		DO WHIL .NOT. EOF()
*!*			IF INT(yc/10000)>0
*!*				ycx='['+ALLTRIM(STR(INT(yc/10000)))+']'
*!*			ELSE
*!*				ycx=''
*!*			ENDIF 
*!*			IF INT(CASH1/10000)>0
*!*				ycx=ycx+'('+ALLTRIM(STR(INT(CASH1/10000)))+')'
*!*			ELSE
*!*				ycx=ycx+''
*!*			ENDIF
*!*			m_note=m_note+ALLTRIM(YEAR)+':'+ALLTRIM(STR(次数))+','+ALLTRIM(STR(INT(RKSL)))+','+ALLTRIM(STR(INT(DYSL)))+','+ALLTRIM(STR(INT(WDYSL)))+','+ALLTRIM(STR(INT(CASH/10000)))+ycx+CHR(13)+CHR(10)
*!*			SELECT TMPQC
*!*			SKIP
*!*		ENDDO
*!*		SELECT TMPQC
*!*		SUM 次数,WDYSL,CASH,yc,cash1 TO X1,X2,X3,x4,x41
*!*		m_note=m_note+'1.闲置订单库存合计:'+ALLTRIM(STR(INT(x1)))+'笔,库存总数:'+ALLTRIM(STR(INT(x2)))+'只,库存金额:'+ALLTRIM(STR(INT(x3/10000)))+'(其中预测结存:'+ALLTRIM(STR(INT(x4/10000)))+','+ALLTRIM(STR(INT(x4/x3*100)))+'%,料件:'+ALLTRIM(STR(INT(x41/10000)))+','+ALLTRIM(STR(INT(x41/x3*100)))+'%)万元.'
*!*		CON=ODBC(5)
*!*		sqlexec(con,"SELECT  COUNT(*) JS,SUM(COPTD.UDF52-TD009-COPTD.UDF51) zs,SUM((COPTD.UDF52-TD009-COPTD.UDF51)*(MB057+MB058+MB059+MB060)) AS JG,"+;
*!*		"SUM(case when TD004<'A' THEN (COPTD.UDF52-TD009-COPTD.UDF51)*(MB057+MB058+MB059+MB060) ELSE 0 END) AS JG1,"+;
*!*		"SUM(case when LEFT(COPTD.UDF05,1)='2' THEN (COPTD.UDF52-TD009-COPTD.UDF51)*(MB057+MB058+MB059+MB060) ELSE 0 END) AS JG2, "+;
*!*		"SUM(case when LEFT(COPTD.TD015,1)='2' THEN (COPTD.UDF52-TD009-COPTD.UDF51)*(MB057+MB058+MB059+MB060) ELSE 0 END) AS JG3, "+;
*!*		"SUM(case when LEFT(mf002,1)='Y' THEN (COPTD.UDF52-TD009-COPTD.UDF51)*(MB057+MB058+MB059+MB060) ELSE 0 END) AS JG4 "+;
*!*		"FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 INNER JOIN INVMB ON TD004=MB001 LEFT JOIN pidetail on interid=COPTD.UDF56 "+;
*!*		"WHERE TC027='Y' AND TD021='Y' AND TD016='N' AND COPTD.UDF52-TD009-COPTD.UDF51>0","TmpQC")
*!*		BZ=LEFT(DTOC(DATE(),1),4)
*!*		sqlexec(con,"SELECT  COUNT(*) JS,SUM(TH008) zs,SUM(TH008*(MB057+MB058+MB059+MB060)) AS JG,"+;
*!*		"SUM(case when TD004<'A' THEN TH008*(MB057+MB058+MB059+MB060) ELSE 0 END) AS JG1,"+;
*!*		"SUM(case when LEFT(COPTD.UDF05,1)='2' THEN TH008*(MB057+MB058+MB059+MB060) ELSE 0 END) AS JG2, "+;
*!*		"SUM(case when LEFT(COPTD.TD015,1)='2' THEN TH008*(MB057+MB058+MB059+MB060) ELSE 0 END) AS JG3, "+;
*!*		"SUM(case when LEFT(mf002,1)='Y' THEN TH008*(MB057+MB058+MB059+MB060) ELSE 0 END) AS JG4 "+;
*!*		"FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 INNER JOIN INVMB ON TD004=MB001 LEFT JOIN pidetail on interid=COPTD.UDF56 "+;
*!*		"INNER JOIN COPTH ON TH014=TD001 AND TH015=TD002 AND TH016=TD003 INNER JOIN COPTG ON TG001=TH001 AND TG002=TH002 "+;
*!*		"WHERE TC027='Y' AND TD021='Y' AND TH020='Y' AND TH008>0 AND LEFT(TG003,4)=?BZ and TD004<'X'","TmpQC1")
*!*	sqlexec(con,"SELECT  SUM(TG009*TG011*(MB057+MB058+MB059+MB060)) AS JG1 "+;
*!*		"FROM MOCTF INNER JOIN MOCTG ON TG001=TF001 AND TG002=TF002 INNER JOIN MOCTA ON TG014=TA001 AND TG015=TA002 "+;
*!*		"INNER JOIN COPMF ON MF001=TA033 AND MF003=TA006 INNER JOIN INVMB ON MF003=MB001 "+;
*!*		" WHERE TG022='Y' AND TG011>0 AND LEFT(TF003,4)=?BZ AND TG009=1 AND TA001='511' UNION ALL "+;
*!*		"SELECT  SUM(TH007*(MB057+MB058+MB059+MB060)) AS JG1 "+;
*!*		"FROM PURTG INNER JOIN PURTH ON TG001=TH001 AND TG002=TH002 INNER JOIN PURTD Y ON Y.TD001=TH011 AND Y.TD002=TH012 AND Y.TD003=TH013 "+;
*!*		"INNER JOIN COPTD X ON RTRIM(X.TD001)+X.TD002=Y.TD024 AND X.TD003=Y.TD023 INNER JOIN INVMB ON Y.TD004=MB001 "+;
*!*		" WHERE TH030='Y' AND LEFT(TG003,4)=?BZ AND LEFT(X.TD015,1)='2'","TmpQC2")

*!*		SQLDISCONNECT(CON)	

*!*		SELECT TmpQC
*!*		x5=js
*!*		x6=zs
*!*		x7=jg
*!*		X8=JG1
*!*		X9=JG2
*!*		X10=JG3
*!*		X11=X7-X9-X10
*!*		X12=JG4
*!*		SELECT TmpQC1
*!*		Y5=js
*!*		Y6=zs
*!*		Y7=jg
*!*		Y8=JG1
*!*		Y9=JG2
*!*		Y10=JG3
*!*		Y11=Y7-Y9-Y10
*!*		Y12=JG4
*!*		SELECT TmpQC2
*!*		GO TOP 
*!*		Z11=JG1
*!*		SKIP
*!*		Z12=JG1
*!*		SUM JG1 TO Z1
*!*		IF ISNULL(Z1)
*!*			Z1=0
*!*		ENDIF	
*!*		m_note=m_note+CHR(13)+CHR(10)+'2.待销货订单库存合计:'+ALLTRIM(STR(INT(x5)))+'笔,库存总数:'+ALLTRIM(STR(INT(x6)))+'只,库存金额:'+ALLTRIM(STR(INT(x7/10000)))+'万元(总库存:'+ALLTRIM(STR(INT((x3+x7)/10000)))+','+ALLTRIM(STR(INT(x7/(x3+x7)*100)))+'%),其中外购商品总额:'+ALLTRIM(STR(INT((X12)/10000)))+'('+ALLTRIM(STR(INT(x12/X10*100)))+'%)万元.'&&,料件;'+ALLTRIM(STR(INT((x41+x8)/10000)))+','+ALLTRIM(STR(INT(x41/(x3+x7)*100)))+'%)
*!*		m_note=m_note+CHR(13)+CHR(10)+'3.待销货订单库存中调用预测:'+ALLTRIM(STR(INT(X10/10000)))+'('+ALLTRIM(STR(INT(x10/x7*100)))+'%),借用'+ALLTRIM(STR(INT(X9/10000)))+'('+ALLTRIM(STR(INT(x9/x7*100)))+'%),新制造:'+ALLTRIM(STR(INT(X11/10000)))+'('+ALLTRIM(STR(INT(x11/x7*100)))+'%)万元'
*!*		m_note=m_note+CHR(13)+CHR(10)+'4.本年销货调用预测:'+ALLTRIM(STR(INT(Y10/10000)))+'('+ALLTRIM(STR(INT(Y10/Y7*100)))+'%,预测入库:'+ALLTRIM(STR(INT(Z1/10000)))+'[M'+ALLTRIM(STR(INT(Z11/10000)))+',P'+ALLTRIM(STR(INT(Z12/10000)))+']),借用'+ALLTRIM(STR(INT(Y9/10000)))+'('+ALLTRIM(STR(INT(Y9/Y7*100)))+'%),新制造:'+ALLTRIM(STR(INT(Y11/10000)))+'('+ALLTRIM(STR(INT(Y11/Y7*100)))+'%)万元'
***********************************
	mtitle='['+DTOC(DATE())+']日订单商品库存现状:'
	m_note='预计交期:笔数,库存数,库存金额[预测库存金额](料件)(万元)'+CHR(13)+CHR(10)
	CON=ODBC(5)
	?sqlexec(con,"SELECT case when TD013<='2012' OR TD013 IS NULL THEN '2011年前' ELSE LEFT(TD013,4)+'年' END YEAR,COUNT(*) as 次数,sum(INVLA.LA011*INVLA.LA005)  as WDYSL,SUM(CB*INVLA.LA011*INVLA.LA005) CASH,"+;
	"SUM(CASE WHEN TD004<'A' THEN CB*INVLA.LA011*INVLA.LA005 ELSE 0 END) CASH1,SUM(case when id=1 then CB*INVLA.LA011*INVLA.LA005 else 0 end) yc "+;
	"FROM INVLA INNER JOIN getgoodsstcokforsales ON LA016=SUBSTRING(NOID,1,LEN(RTRIM(NOID))-4)  "+;
	"AND LA001=TD004 GROUP BY case when TD013<='2012'  OR TD013  IS NULL THEN '2011年前' ELSE LEFT(TD013,4)+'年' END ORDER BY 1","TmpQC")&&ISNULL(LEFT(TD013,4),'')
	SQLDISCONNECT(CON)
	SELECT TmpQC
	GO TOP
	DO WHIL .NOT. EOF()
		IF INT(yc/10000)>0
			ycx='['+ALLTRIM(STR(INT(yc/10000)))+']'
		ELSE
			ycx=''
		ENDIF 
		IF INT(CASH1/10000)>0
			ycx=ycx+'('+ALLTRIM(STR(INT(CASH1/10000)))+')'
		ELSE
			ycx=ycx+''
		ENDIF
		m_note=m_note+ALLTRIM(YEAR)+':'+ALLTRIM(STR(次数))+','+ALLTRIM(STR(INT(WDYSL)))+','+ALLTRIM(STR(INT(CASH/10000)))+ycx+CHR(13)+CHR(10)
		SELECT TMPQC
		SKIP
	ENDDO
	SELECT TMPQC
	SUM 次数,WDYSL,CASH,yc,cash1 TO X1,X2,X3,x4,x41
	m_note=m_note+'1.闲置订单库存合计:'+ALLTRIM(STR(INT(x1)))+'笔,库存总数:'+ALLTRIM(STR(INT(x2)))+'只,库存金额:'+ALLTRIM(STR(INT(x3/10000)))+'(其中预测结存:'+ALLTRIM(STR(INT(x4/10000)))+','+ALLTRIM(STR(INT(x4/x3*100)))+'%,料件:'+ALLTRIM(STR(INT(x41/10000)))+','+ALLTRIM(STR(INT(x41/x3*100)))+'%)万元.'
	CON=ODBC(5)
	sqlexec(con,"SELECT  COUNT(*) JS,SUM(LA011*LA005) zs,SUM((LA011*LA005)*(MB057+MB058+MB059+MB060)) AS JG,"+;
	"SUM(case when TD004<'A' THEN (LA011*LA005)*(MB057+MB058+MB059+MB060) ELSE 0 END) AS JG1,"+;
	"SUM(case when LEFT(COPTD.UDF05,1)='2' THEN (LA011*LA005)*(MB057+MB058+MB059+MB060) ELSE 0 END) AS JG2, "+;
	"SUM(case when LEFT(COPTD.TD015,1)='2' THEN (LA011*LA005)*(MB057+MB058+MB059+MB060) ELSE 0 END) AS JG3, "+;
	"SUM(case when LEFT(mf002,1)='Y' THEN (LA011*LA005)*(MB057+MB058+MB059+MB060) ELSE 0 END) AS JG4 "+;
	"FROM  INVLA  INNER JOIN COPTD ON RTRIM(TD001)+TD002=LA016 AND TD004=LA001 "+;
	"INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 INNER JOIN INVMB ON TD004=MB001 LEFT JOIN pidetail on interid=COPTD.UDF56 "+;
	" WHERE TC027='Y' AND TD021='Y' AND TD016='N' AND INVLA.LA011*INVLA.LA005<>0","TmpQC")
	BZ=LEFT(DTOC(DATE(),1),4)
	sqlexec(con,"SELECT  COUNT(*) JS,SUM(TH008) zs,SUM(TH008*(MB057+MB058+MB059+MB060)) AS JG,"+;
	"SUM(case when TD004<'A' THEN TH008*(MB057+MB058+MB059+MB060) ELSE 0 END) AS JG1,"+;
	"SUM(case when LEFT(COPTD.UDF05,1)='2' THEN TH008*(MB057+MB058+MB059+MB060) ELSE 0 END) AS JG2, "+;
	"SUM(case when LEFT(COPTD.TD015,1)='2' THEN TH008*(MB057+MB058+MB059+MB060) ELSE 0 END) AS JG3, "+;
	"SUM(case when LEFT(mf002,1)='Y' THEN TH008*(MB057+MB058+MB059+MB060) ELSE 0 END) AS JG4 "+;
	"FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 INNER JOIN INVMB ON TD004=MB001 LEFT JOIN pidetail on interid=COPTD.UDF56 "+;
	"INNER JOIN COPTH ON TH014=TD001 AND TH015=TD002 AND TH016=TD003 INNER JOIN COPTG ON TG001=TH001 AND TG002=TH002 "+;
	"WHERE TC027='Y' AND TD021='Y' AND TH020='Y' AND TH008>0 AND LEFT(TG003,4)=?BZ and TD004<'X'","TmpQC1")
sqlexec(con,"SELECT  SUM(TG009*TG011*(MB057+MB058+MB059+MB060)) AS JG1 "+;
	"FROM MOCTF INNER JOIN MOCTG ON TG001=TF001 AND TG002=TF002 INNER JOIN MOCTA ON TG014=TA001 AND TG015=TA002 "+;
	"INNER JOIN COPMF ON MF001=TA033 AND MF003=TA006 INNER JOIN INVMB ON MF003=MB001 "+;
	" WHERE TG022='Y' AND TG011>0 AND LEFT(TF003,4)=?BZ AND TG009=1 AND TA001='511' UNION ALL "+;
	"SELECT  SUM(TH007*(MB057+MB058+MB059+MB060)) AS JG1 "+;
	"FROM PURTG INNER JOIN PURTH ON TG001=TH001 AND TG002=TH002 INNER JOIN PURTD Y ON Y.TD001=TH011 AND Y.TD002=TH012 AND Y.TD003=TH013 "+;
	"INNER JOIN COPTD X ON RTRIM(X.TD001)+X.TD002=Y.TD024 AND X.TD003=Y.TD023 INNER JOIN INVMB ON Y.TD004=MB001 "+;
	" WHERE TH030='Y' AND LEFT(TG003,4)=?BZ AND LEFT(X.TD015,1)='2' ","TmpQC2")

	SQLDISCONNECT(CON)	

	SELECT TmpQC
	x5=js
	x6=zs
	x7=jg
	X8=JG1
	X9=JG2
	X10=JG3
	X11=X7-X9-X10
	X12=JG4
	SELECT TmpQC1
	Y5=js
	Y6=zs
	Y7=jg
	Y8=JG1
	Y9=JG2
	Y10=JG3
	Y11=Y7-Y9-Y10
	Y12=JG4
	SELECT TmpQC2
	GO TOP 
	Z11=JG1
	SKIP
	Z12=JG1
	SUM JG1 TO Z1
	IF ISNULL(Z1)
		Z1=0
	ENDIF	
	m_note=m_note+CHR(13)+CHR(10)+'2.待销货订单库存合计:'+ALLTRIM(STR(INT(x5)))+'笔,库存总数:'+ALLTRIM(STR(INT(x6)))+'只,库存金额:'+ALLTRIM(STR(INT(x7/10000)))+'万元(总库存:'+ALLTRIM(STR(INT((x3+x7)/10000)))+','+ALLTRIM(STR(INT(x7/(x3+x7)*100)))+'%),其中外购商品总额:'+ALLTRIM(STR(INT((X12)/10000)))+'('+ALLTRIM(STR(INT(x12/X10*100)))+'%)万元.'&&,料件;'+ALLTRIM(STR(INT((x41+x8)/10000)))+','+ALLTRIM(STR(INT(x41/(x3+x7)*100)))+'%)
	m_note=m_note+CHR(13)+CHR(10)+'3.待销货订单库存中调用预测:'+ALLTRIM(STR(INT(X10/10000)))+'('+ALLTRIM(STR(INT(x10/x7*100)))+'%),借用'+ALLTRIM(STR(INT(X9/10000)))+'('+ALLTRIM(STR(INT(x9/x7*100)))+'%),新制造:'+ALLTRIM(STR(INT(X11/10000)))+'('+ALLTRIM(STR(INT(x11/x7*100)))+'%)万元'
	m_note=m_note+CHR(13)+CHR(10)+'4.本年销货调用预测:'+ALLTRIM(STR(INT(Y10/10000)))+'('+ALLTRIM(STR(INT(Y10/Y7*100)))+'%,预测入库:'+ALLTRIM(STR(INT(Z1/10000)))+'[M'+ALLTRIM(STR(INT(Z11/10000)))+',P'+ALLTRIM(STR(INT(Z12/10000)))+']),借用'+ALLTRIM(STR(INT(Y9/10000)))+'('+ALLTRIM(STR(INT(Y9/Y7*100)))+'%),新制造:'+ALLTRIM(STR(INT(Y11/10000)))+'('+ALLTRIM(STR(INT(Y11/Y7*100)))+'%)万元'

	tmpkeyid=maxinterid("rtxmessage")
	keyidid1=ODBC(6)
	mrev='王文雅;周洪;姚旭辉;申屠晓萍;施维君;盛哲辉;方毅;胡亚君;黄丽锋;'
	IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,9)")<0
		WAIT windows '????订单超期'+mrev nowait
	ENDIF 
	SQLDISCONNECT(keyidid1)
	SELECT TmpQC
	USE
	SELECT TmpQC1
	USE
	SELECT TmpQC2
	USE
	
ENDPROC 

PROCEDURE GETOUTMOCTA
	s=''
	CON=ODBC(5)
	SQLEXEC(CON,"SELECT DATENAME( Wk,GETDATE() ) AS ZC")
	IF LEN(ALLTRIM(zc))=1
		MZC='0'+ALLTRIM(ZC)
	ELSE 
		mzc=zc	
	ENDIF 
	A1=ALLTRIM(STR(YEAR(DATE())))+'.'+ALLTRIM(mzc)
*!*		IF sqlexec(con,"SELECT DISTINCT TA033,MV002,CASE WHEN billname is null then '' else RTRIM(billname)+';' end AS BILLNAME,TA033 YWY,CASE WHEN billname is null then 0 else pi.interid end AS PI "+;
*!*			" FROM MOCTA INNER JOIN COPTC ON TA033=RTRIM(TC001)+TC002 LEFT JOIN CMSMV ON TC006=MV001 LEFT JOIN pi ON COPTC.UDF55=interid "+;
*!*			"WHERE  TA011<='3' and TA013='Y' and LEFT(TA010,4)+'.'+CASE WHEN LEN(ltrimDATENAME( Wk,CAST(TA010 AS DATETIME) ))=2 THEN "+;
*!*			" DATENAME( Wk,CAST(TA010 AS DATETIME) ) ELSE '0'+DATENAME( Wk,CAST(TA010 AS DATETIME) ) END<?A1 and TA001='511' ORDER BY 1","TmpO1rder")<0  &&TA016 AS 已领套数,
*!*			WAIT WINDOWS '???'
*!*			RETURN 
*!*		ENDIF
*!*	SQLEXEC(con,"SELECT '批号:'+rtrim(MOCTA.TA033)+'丨'+MOCTA.TA001+ MOCTA.TA002+'丨'+rtrim(MOCTA.TA006)+':'+rtrim(MOCTA.TA034)+'丨'+rtrim(MOCTA.TA035)+'丨'+(case MOCTA.TA011 when '1' then '未生产' when '2' then '已发料' when '3' then '生产中' when 'Y' then '已完工' else '指定完工' end)+'丨预计完工日'+MOCTA.TA010+'逾期('+str(datediff(day,MOCTA.TA010,getdate()),4,0)+')天丨总产量:'+str(MOCTA.TA015,6,0)+'丨未产量('+str(MOCTA.TA015-MOCTA.TA017,6,0)+')丨未产工时(
*!*	'+str((case when MOCTA.TA001 like '52%' then MOCTA.UDF51/3600 else INVMB.MB061/CMSMD.MD009 end)*(MOCTA.TA015-MOCTA.TA017),4,2)+'H)',
*!*	rtrim(MOCTA.TA021)+CMSMD.MD002 as 工作中心
*!*	FROM DEMO.dbo.MOCTA 
*!*	left join  CMSMD on MOCTA.TA021=CMSMD.MD001 
*!*	left join  INVMB on INVMB.MB001=MOCTA.TA006
*!*	WHERE  MOCTA.TA013 = 'Y' and MOCTA.TA011 like '[123]' and MOCTA.TA030='1' and datediff(day,MOCTA.TA010,getdate())>14

	IF sqlexec(con,"SELECT DISTINCT TA033,C.MV002,CASE WHEN billname is null then '' else RTRIM(billname)+';' end AS BILLNAME,TA033 YWY,CASE WHEN billname is null then 0 else pi.interid end AS PI, "+;
	"MOCTA.TA010,datediff(day,MOCTA.TA010,getdate()) as 逾期天数,str(MOCTA.TA015-MOCTA.TA017,6,0)+'/'+str(MOCTA.TA015,6,0) AS CL,"+;
		"(case when MOCTA.TA001 like '52%' then MOCTA.UDF51/3600 else INVMB.MB061/CMSMD.MD009 end)*(MOCTA.TA015-MOCTA.TA017) AS GS,MOCTA.TA001, MOCTA.TA002,"+;
		"case when TA030='1' then CMSMD.MD002  ELSE PURMA.MA002 END AS 工作中心,"+;
		"V.MV002,TA044,MOCTA.TA006,MOCTA.TA034,MOCTA.TA035 "+;
		" FROM MOCTA LEFT JOIN COPTC ON TA033=RTRIM(TC001)+TC002 LEFT JOIN CMSMV C ON TC006=C.MV001 LEFT JOIN pi ON COPTC.UDF55=interid "+;
		"left join  CMSMD on MOCTA.TA021=CMSMD.MD001 left join  PURMA on MOCTA.TA032=PURMA.MA001 LEFT JOIN CMSMV V ON TA041=V.MV001 left join  INVMB on INVMB.MB001=MOCTA.TA006 "+;
		"WHERE  TA011<='3' and TA013='Y'  and MOCTA.TA030='1' and LEFT(TA010,4)+'.'+CASE WHEN LEN(DATENAME( Wk,CAST(TA010 AS DATETIME) ))=2 THEN "+;
		" DATENAME( Wk,CAST(TA010 AS DATETIME) ) ELSE '0'+DATENAME( Wk,CAST(TA010 AS DATETIME) ) END<?A1 ORDER BY 1","TmpO1rder")<0  &&nd datediff(day,MOCTA.TA010,getdate())>14 
		WAIT WINDOWS '???'
		RETURN 
	ENDIF	
	SQLDISCONNECT(CON)
	REPLACE YWY WITH ALLTRIM(MV002)+';'+ALLTRIM(BILLNAME) FOR (ALLTRIM(MV002)+';')<>ALLTRIM(BILLNAME) AND !ISNULL(MV002)
	REPLACE YWY WITH ALLTRIM(MV002)  FOR (ALLTRIM(MV002)+';')=ALLTRIM(BILLNAME)
	REPLACE YWY WITH  ALLTRIM(BILLNAME) FOR ISNULL(MV002)
	replace CL WITH STRt(CL ,' ','') ALL 
	replace CL WITH STRt(CL ,' ','') all
	replace 工作中心 WITH '灯具车间' FOR 工作中心='装配'
	replace 工作中心 WITH '灯具车间' FOR 工作中心='车间现场加工'
	replace 工作中心 WITH '喷涂车间' FOR 工作中心='喷涂'
	replace 工作中心 WITH '喷涂车间' FOR 工作中心='机加工'
	con1=odbc(11)
	SQLEXEC(con1,"select A.CnName boss "+;
	" from Department d LEFT JOIN Employee A ON d.Principal=A.EmployeeID  where D.name='计划部'","tmp2")
	mrev1=ALLTRIM(boss )+';'
	SQLEXEC(con1,"select A.CnName boss "+;
	" from Department d LEFT JOIN Employee A ON d.Principal=A.EmployeeID  where D.name='财务部'","tmp2")
	mrev1=mrev1+ALLTRIM(boss )+';'
	SQLDISCONNECT(Con)
	SELECT DISTINCT  工作中心  as 业务员  FROM TmpO1rder INTO CURSOR TMPSALES
	SELECT TMPSALES
	GO TOP
	DO WHIL .NOT. EOF()
	
		mrev=''
		
		XXX=ALLTRIM(业务员)
		xc=xxx
		IF XXX='样品组'
			mrev='样品组长;'
		ENDIF 	
		IF USED("TMPBUYETR")
			SELECT TMPBUYETR
			USE
		ENDIF	

		SELECT * FROM TmpO1rder WHERE ALLTRIM( 工作中心)==XXX ORDER BY 6 INTO CURSOR TMPBUYETR
		SELECT TMPBUYETR
		TT=RECCOUNT()
		m_note='共有['+ALLTRIM(STR(RECCOUNT()))+']张工单产品逾期：'
		mtitle='['+ALLTRIM(XXX)+']逾期工单'

		GO TOP
		T=''
		s=''
		DO WHIL .NOT. EOF()
*!*				IF pi=0
*!*					S=ALLTRIM(TA033)+':'
*!*				ELSE
*!*					S=ALLTRIM(TA033)+'['+ALLTRIM(STR(pi))+']:'
*!*				ENDIF 	
			
			SELECT TMPBUYETR
			s=ALLTRIM(STR(RECNO()))+'.'+ALLTRIM(ta006)+':'+allt(ta034)+'丨'+ALLTRIM(ta035)+'('+ALLTRIM(ta001)+ALLTRIM(ta002)+'['+ALLTRIM(CL)+;
			iIF(gs=0,'],',','+ALLTRIM(STR(GS))+'h],')+ALLTRIM(TA033)+')'+SUBSTR(ta010,1,4)+'.'+SUBSTR(ta010,5,2)+'.'+SUBSTR(ta010,7,2)+CHR(13)+CHR(10)
			IF LEN(ALLTRIM(T+S))<1500
				T=T+S
			ELSE
				T=T+CHR(13)+CHR(10)+'...'
				EXIT
			ENDIF
			con1=odbc(11)
			SQLEXEC(con1,"select A.CnName boss "+;
			" from Department d LEFT JOIN Employee A ON d.Principal=A.EmployeeID  where D.name=?XXX","tmp2")
			SQLDISCONNECT(con1)

			IF RECCOUNT()=1
				IF ALLTRIM(boss)$mrev=.f.
					mrev=mrev+ALLTRIM(boss)+';'
				ENDIF 	
			ENDIF 
			SELECT TMPBUYETR
			SKIP
		ENDDO		
		m_note=m_note+CHR(13)+CHR(10)+t
		*m_note=m_note+T+CHR(13)+CHR(10)+'__________________________________________________'+CHR(13)+CHR(10)+'注：所有逾期工单必须整理到合法日期范围内，否则后续将不能导入订单，不能排产，不能彩包合并采购...！'
*!*			IF '王文雅'$XC=.T.
*!*				mrev='姚旭辉;申屠晓萍;夏萍芳;刘建宁;王素华;'+xc
*!*			ELSE 	
*!*				mrev='王文雅;姚旭辉;申屠晓萍;夏萍芳;'+xc
*!*			ENDIF 	
		tmpkeyid=maxinterid("rtxmessage")
		keyidid1=ODBC(6)
		mrev=mrev1+mrev
*!*			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,0)")<0
*!*				WAIT windows '????订单'+mrev nowait
*!*			ENDIF 
		SQLDISCONNECT(keyidid1)
		SELECT TMPSALES
		SKIP
	ENDDO


ENDPROC 

PROCEDURE GETMA028
	A11=DTOC(DATE()-366)
	A1=DTOC(DATE()-366,1)
	A2=DTOC(DATE(),1)
	con=odbc(5)
	IF SQLEXEC(CON," SELECT MA001, MA002,MA028, MA065,  "+;
        "  MA065 AS NEW, CAST(MA002 AS CHAR(250)) MAIN, MA065 AS NEW1, "+;
         " SUM(CASE TA079 WHEN '1' THEN TB019 WHEN '2' THEN TB019 * - 1 END) AS 销售, "+;
           "SUM(case when (MB057+MB058+MB059+MB060)*TB022 is null then 0 else (MB057+MB058+MB059+MB060)*TB022 end) AS 标准成本 "+;
		 " ,CAST(SUM(CASE WHEN TA001<>'661' THEN 0 ELSE TB019*0.04 END) AS DEC(18,6)) AS 不予抵扣,9999999999.99 毛利,999999.99 毛利率,MV002 FROM ACRTB LEFT JOIN "+;
           " ACRTA ON TB001 = TA001 AND TB002 = TA002 LEFT JOIN INVMB ON MB001 = TB039 LEFT JOIN COPMA ON MA001 = TA004 LEFT JOIN CMSMV ON MV001=MA016 "+;
			 " WHERE  TB012 <> 'V' AND TA003>=?A1 AND TA003 <=?A2 AND MA022>=?A1 AND MA001<>'0120' GROUP BY MA001, MA002,MA028, MA065,MV002 order by 8 desc","GETLEVEL")<0
			 WAIT WINDOWS '???' &&AND  MA8.MA001='2'AND  MA7.MA001='2' AND  MA5.MA001='2' 
		ENDIF	 
	SQLDISCONNECT(CON)

	SELECT GETLEVEL
	replace 毛利率 WITH 0 all
	REPLACE 毛利 WITH (销售-不予抵扣-标准成本)/10000 all
	replace 毛利率 WITH (销售-不予抵扣-标准成本)/(销售-不予抵扣)*100  FOR 销售-不予抵扣<>0
	REPLACE 销售 WITH (销售-不予抵扣)/10000 all
	REPLACE 不予抵扣 WITH 不予抵扣/10000, 标准成本 WITH 标准成本/10000 all
	REPLACE MA065 WITH MA001 FOR EMPTY(MA065)

	GO TOP
	DO WHIL .NOT. EOF()
		DO CASE
			CASE 销售>=350 AND 毛利率/100>0.25
				REPLACE NEW WITH 'A'
			CASE (销售>=350 AND 毛利率/100<=0.25 AND 毛利率/100>=0.15) OR (销售>=100 AND 销售<350  AND 毛利率/100>=0.25)
				REPLACE NEW WITH 'B'
			CASE (销售>=350 AND 毛利率/100<0.15) OR (销售>=100 AND 销售<350  AND 毛利率/100>=0.15 AND 毛利率/100<=0.25)  OR (销售>=50 AND 销售<100 AND 毛利率/100>0.25)  OR (销售>=10 AND 销售<50 AND 毛利率/100>0.35)
				REPLACE NEW WITH 'C'
			OTHERWISE 
				REPLACE NEW WITH 'D'
		ENDCASE 
		SKIP
	ENDDO
	SELECT GETLEVEL
	REPLACE NEW1 WITH '' ALL
	CLOSEDB("TMPMAIN")
	SELECT MA065,MA065 NEW,SUM(销售) 销售,SUM(标准成本) 标准成本,SUM(不予抵扣) 不予抵扣,9999999999.99 毛利,999999.99 毛利率 FROM GETLEVEL GROUP BY MA065 WHERE MA065>='1' INTO CURSOR TMPMAIN READWRITE 
	SELECT TMPMAIN
	REPLACE 毛利 WITH (销售-标准成本)/10000 all
	replace 毛利率 WITH (销售-标准成本)/销售*100  FOR 销售<>0
	GO TOP 
	DO WHIL .NOT. EOF()
		DO CASE
			CASE 销售>=350 AND 毛利率/100>0.25
				REPLACE NEW WITH 'A'
			CASE (销售>=350 AND 毛利率/100<=0.25 AND 毛利率/100>=0.15) OR (销售>=100 AND 销售<350  AND 毛利率/100>=0.25)
				REPLACE NEW WITH 'B'
			CASE (销售>=350 AND 毛利率/100<0.15) OR (销售>=100 AND 销售<350  AND 毛利率/100>=0.15 AND 毛利率/100<=0.25)  OR (销售>=50 AND 销售<100 AND 毛利率/100>0.25)  OR (销售>=10 AND 销售<50 AND 毛利率/100>0.35)
				REPLACE NEW WITH 'C'
			OTHERWISE 
				REPLACE NEW WITH 'D'
		ENDCASE 
		XX=NEW
		YY=MA065
		SELECT GETLEVEL
		REPLACE NEW1 WITH ALLTRIM(XX) FOR ALLTRIM(MA065)==ALLTRIM(YY) 
		SELECT TMPMAIN
		SKIP
	ENDDO
	SELECT GETLEVEL
	REPLACE MA028 WITH 'D' FOR MA028='E' OR LEN(ALLTRIM(MA028))=0 OR ISNULL(MA028)
	TABLEU(.T.)
	SELECT * FROM GETLEVEL WHERE MA028<>NEW1 ORDER BY MA028 INTO CURSOR GETMYRES READWRITE 
	SELECT GETMYRES 
	GO TOP 
	DO WHIL .NOT. EOF()
		IF MA028<>NEW
			REPLACE MAIN WITH ALLTRIM(MA002)+'['+ALLTRIM(MA001)+']现评级['+ALLTRIM(ma028)+'],销售（'+ALLTRIM(STR(INT(销售)))+'万,毛利率:'+ALLTRIM(STR(INT(毛利率)))+'%)，应评级['+ALLTRIM(NEW)+']'
			IF LEFT(ma065,1)>='0' AND new<>new1
				replace main WITH ALLTRIM(main)+',该客户总公司评级为['+ALLTRIM(NEW1)+']'
			ENDIF 
		ENDIF
		SKIP
	ENDDO
	SELECT GETMYRES 
	IF USED("TMPSALES")
		SELECT TMPSALES
		USE
	ENDIF	
	SELECT DISTINCT MV002 as 业务员  FROM GETMYRES INTO CURSOR TMPSALES
	SELECT TMPSALES
	GO TOP
	DO WHIL .NOT. EOF()
		XXX=ALLTRIM(业务员)
		xc=xxx
		IF USED("TMPBUYETR")
			SELECT TMPBUYETR
			USE
		ENDIF	

		SELECT * FROM GETMYRES WHERE ALLTRIM(MV002)==XXX ORDER BY 1 DESC INTO CURSOR TMPBUYETR
		SELECT TMPBUYETR
		TT=RECCOUNT()
		m_note='共有['+ALLTRIM(STR(RECCOUNT()))+']个客户销售评级待修正：'
		mtitle='['+ALLTRIM(XXX)+']客户销售评级'

		GO TOP
		T=''
		DO WHIL .NOT. EOF()
			S=CHR(13)+CHR(10)+ALLTRIM(STR(RECNO()))+'.'+ ALLTRIM(main)
			IF LEN(ALLTRIM(T+S))<2400
				T=T+S
			ELSE
				T=T+CHR(13)+CHR(10)+'...'
				EXIT
			ENDIF
			SKIP
		ENDDO		
		m_note=m_note+T+CHR(13)+CHR(10)+'__________________________________________________'+CHR(13)+CHR(10)+'注：以上数据来源为'+A11+'日至今的销售发票汇总以及标准成本，请及时修正客户销售评级，该评级影响采购和生产的优先级.'
		IF xc=='王文雅'
			mrev='王文雅;姚旭辉;'
		ELSE 	
			mrev='王文雅;姚旭辉;'+xc+';'
		ENDIF 	
		tmpkeyid=maxinterid("rtxmessage")
		keyidid1=ODBC(6)

		IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,8)")<0
			WAIT windows '????订单超期'+mrev nowait
		ENDIF 
		SQLDISCONNECT(keyidid1)
		SELECT TMPSALES
		SKIP
	ENDDO
ENDPROC 

*!*	FUNCTION GETOA
*!*	LOCAL oWbemLocator, oWMIService, oItems, oItem
*!*	oWbemLocator = CREATEOBJECT("WbemScripting.SWbemLocator")
*!*	oWMIService = oWbemLocator.ConnectServer(".", "root/cimv2")
*!*	oItems = oWMIService.ExecQuery("SELECT * FROM Win32_Process")
*!*	FOR EACH oItem IN oItems
*!*		IF oItem.Name='OAVICE.exe'
*!*			KEYID=1
*!*			EXIT	
*!*		ENDIF
*!*	*依次是：进程ID，进程Name，进程文件路径
*!*	ENDFOR 
*!*	ENDFUNC
PROCEDURE CloseDB
	PARAMETERS tcAliasName
	IF type(tcAliasName)='C'
		IF USED("&tcAliasName")
		   SELECT "&tcAliasName"
		   USE 
		ENDIF
	ELSE
		WAIT WINDOWS tcAliasName nowait	
	ENDIF
	RETURN
ENDPROC 
FUNCTION GetServerDate
	CON5=ODBC(5)
	llReturn=SQLEXEC(CON5,"SELECT Getdate() AS GetSeverDate")
	SQLDISCONNECT(CON5)
	RETURN GetSeverDate
ENDFUNC 


FUNCTION GetCpu
LOCAL oWMI AS OBJECT,oLocal AS OBJECT,oHARDWARE AS OBJECT,object1 AS OBJECT,lcCPUID,LcMAC,lcHDID,lcSerial  
oWMI=CREATEOBJECT("WbemScripting.SWbemLocator")  
oLocal=oWMI.ConnectServer(".",  "root\cimv2")  
oHARDWARE=oLocal.ExecQuery("SELECT * FROM Win32_Processor")  
FOR EACH object1 IN oHARDWARE  
    lcCPUID=object1.Properties_('ProcessorId').VALUE  
    EXIT  
ENDFOR  
oHARDWARE=oLocal.ExecQuery("SELECT * FROM Win32_PhysicalMedia")  
FOR EACH object1 IN oHARDWARE  
    lcHDID=object1.Properties_('SerialNumber').VALUE  
    EXIT  
ENDFOR  
oHARDWARE=oLocal.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration Where IPEnabled=1")  
FOR  EACH  object1  IN  oHARDWARE  
    LcMAC=object1.Properties_('MACAddress').VALUE  
    EXIT  
ENDFOR 

RETURN lcCPUID 
ENDFUNC


PROCEDURE ODBC
	PARAMETERS TL
	IF USED("Buys")
		SELECT buys
		USE
	ENDIF 	
	USE Buys.dbf IN 0 SHARED
	*!*	SQLDISCONNECT(0)
	SELECT BUYS
	DECLARE INTEGER SQLConfigDataSource IN odbccp32 INTEGER, INTEGER, STRING, STRING
	lnWindowHandle=0
	GO tl

	mNote=ALLTRIM(Des)
	IF LEN(ALLTRIM(mNote))<10
		MessageBox('没有设置'+ALLTRIM(NAME)+'数据源，请与系统管理员用Config文件配置正确的odbc！',16,'警告')
		RETURN 
	ENDIF 	
	**先试图修改已有的ODBC，如果不存在，返回0。
	lreturn=SQLConfigDataSource(lnWindowHandle, 2, &mNote)
	SQLSETPROP(0,'DispLogin',3)
	IF lreturn=0 &&不存在，则添加新的ODBC
		lreturn=SQLConfigDataSource(lnWindowHandle, 1, &mNote)
		IF lreturn=0 &&失败
	*!*			MessageBox('添加'+ALLTRIM(NAME)+'数据源失败，请与系统管理员联系！',16,'警告')
		ENDIF
	ENDIF
	&&DRIVER=SQL Server;SERVER=GZAPPSERVER;UID=sa;PWD=hongweilu8341;APP=Microsoft Visual FoxPro;WSID=GZAPPSERVER;Network=DBMSLPCN
	mNote=ALLTRIM(OpenPsd(Note))
	gnConnhandle = SQLSTRINGCONNECT(mNote)
	SQLSETPROP(0,'DispLogin',3)
	SQLSETPROP(0,"IdleTimeout",0) 
	*!*	SQLSETPROP(0,"ConnectTimeOut",300)
	IF gnConnhandle>0
		ODBCOK=0
		* MESSAGEBOX(ALLTRIM(NAME)+'连接成功！')
	ELSE
		IF RECNO()=5 OR RECNO()=12
			*MESSAGEBOX('连接失败，请与系统管理员联系！',16,'警告') 
			*quit &&连接不成功则退出系统。
		ENDIF
		ODBCOK=RECNO()
	ENDIF
	RETURN gnConnhandle
	USE
	ENDPROC
***** End of  ODBC
*****
***** Begin of  ClosePsd
PROCEDURE ClosePsd
PARAMETERS mPassWord
mLenWord=LEN(ALLT(mPassWord))
ML=1
PASS=""
FOR I=1 TO mLenWord
	IF mL>10
		mL=10
	ENDIF	
	nPASSWORD=CHR(ASC(SUBSTR(ALLT(mPassWord),I,1))+ML)
	ML=ML+1
	PASS=PASS+nPASSWORD
ENDFOR
RETURN Pass
ENDPROC
***** End of  ClosePsd

***** Begin of  OpenPsd
PROCEDURE OpenPsd
PARA	mPassWord
mLenWord=LEN(ALLT(mPassWord))
ML=1
PASS=""
FOR I=1 TO mLenWord
	IF mL>10
		mL=10
	ENDIF	
	nPASSWORD=CHR(ASC(SUBSTR(ALLT(mPassWord),I,1))-ML)
	ML=ML+1
	PASS=PASS+nPASSWORD
ENDFOR
RETURN Pass
ENDPROC

FUNCTION OpenDB
LPARAMETERS tcDBFname,tcAliasName,tlOpenExclusive
LOCAL lcErrorHandExp,isNoError,isOpenError,lcErrorMsg
lcErrorHandExp = on("error")

IF !USED('&tcDBFname')
	OPEN DATABASE MyMIS
	USE '&tcDBFname' IN 0
ENDIF	
ENDFUNC 
PROCEDURE errHandler

   PARAMETER merror, mess, mess1, mprog, mlineno

   CLEAR

   ? 'Error number: ' + LTRIM(STR(merror))

   WAIT WINDOWS 'Error message: ' + mess

   ? 'Line of code with error: ' + mess1

   ? 'Line number of error: ' + LTRIM(STR(mlineno))

   ? 'Program with error: ' + mprog
WAIT WINDOWS 'Line of code with error: ' + mess1
ENDPROC
FUNCTION Getmac
LOCAL oWMI AS OBJECT,oLocal AS OBJECT,oHARDWARE AS OBJECT,object1 AS OBJECT,lcCPUID,LcMAC,lcHDID,lcSerial  
oWMI=CREATEOBJECT("WbemScripting.SWbemLocator")  
oLocal=oWMI.ConnectServer(".",  "root\cimv2")  
*!*	oHARDWARE=oLocal.ExecQuery("SELECT * FROM Win32_Processor")  
*!*	FOR EACH object1 IN oHARDWARE  
*!*	    lcCPUID=object1.Properties_('ProcessorId').VALUE  
*!*	    EXIT  
*!*	ENDFOR  
*!*	oHARDWARE=oLocal.ExecQuery("SELECT * FROM Win32_PhysicalMedia")  
*!*	FOR EACH object1 IN oHARDWARE  
*!*	    lcHDID=object1.Properties_('SerialNumber').VALUE  
*!*	    EXIT  
*!*	ENDFOR  
oHARDWARE=oLocal.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration Where IPEnabled=1")  
FOR  EACH  object1  IN  oHARDWARE  
    LcMAC=object1.Properties_('MACAddress').VALUE  
    EXIT  
ENDFOR 

RETURN LcMAC
ENDFUNC

FUNCTION DOMIAN2IP
#DEFINE NULL_IP .NULL.
#DEFINE HOSTENT_SIZE 16
PARAMETERS cDOMAIN
LOCAL cResult

IF VARTYPE(m.cDOMAIN)="C"
    DECLARE INTEGER WSACleanup IN ws2_32
    DECLARE STRING inet_ntoa IN ws2_32 INTEGER in_addr
    DECLARE INTEGER gethostbyname IN ws2_32 STRING host
    DECLARE INTEGER WSAStartup IN ws2_32 INTEGER wVerRq, STRING lpWSAData
    DECLARE RtlMoveMemory IN kernel32 As CopyMemory STRING @Dest, INTEGER Src, INTEGER nLength

    IF WSAStartup(0x202, Repli(Chr(0),512)) = 0     && initiates use of WS2_32.DLL
        m.cResult = GetIP(m.cDOMAIN)
        =WSACleanup()
    ELSE
        m.cResult = NULL_IP
    ENDIF
ELSE
    m.cResult = NULL_IP
ENDIF

RETURN m.cResult
ENDFUNC 


*!*	*** returns IP like 127.0.0.1 for a given host name like www.somewhere.com
FUNCTION GetIP(cServer)
LOCAL nStruct, nSize, cBuffer, nAddr, cIP
m.nStruct = gethostbyname(m.cServer)
IF m.nStruct = 0    && not found in a host database; or not connected etc.
  RETURN NULL_IP
ENDIF

m.cBuffer = Repli(Chr(0), HOSTENT_SIZE)
m.cIP = Repli(Chr(0), 4)

= CopyMemory(@cBuffer, m.nStruct, HOSTENT_SIZE)
= CopyMemory(@cIP, buf2dword(SUBS(m.cBuffer,13,4)),4)
= CopyMemory(@cIP, buf2dword(m.cIP),4)
RETURN inet_ntoa(buf2dword(m.cIP))



FUNCTION buf2dword(lcBuffer)
RETURN Asc(SUBSTR(m.lcBuffer, 1,1)) + ;
        Bitlshift(Asc(SUBS(m.lcBuffer, 2,1)),8) +;
        Bitlshift(Asc(SUBS(m.lcBuffer, 3,1)),16) +;
        Bitlshift(Asc(SUBS(m.lcBuffer, 4,1)),24) 

PROCEDURE getipaddress

* Leave IPSocket public to view all properties in the debug window.
* I stumbled on this routine while trying to find information on subclassing
* the WSH and thought it might be useful.
public IPSocket
crlf=chr(13)+chr(10)

* 显示本地 ip 地址
IPSocket = CreateObject("MSWinsock.Winsock")
if type('IPSocket')='O'
   IPAddress = IPSocket.LocalIP
   localhostname = IPSocket.localhostname
   remotehost = IPSocket.remotehost
   remotehostip = IPSocket.remotehostip
   *MessageBox ("本地 IP = " + IPAddress+crlf+"本地 host = "+localhostname;
+crlf+"Remotehost = "+remotehost+crlf+"Remotehostip = "+remotehostip)
	RETURN IPAddress 
else
   MessageBox ("Winsock 未安装!")
endif 

FUNCTION SaveScreen( tcFile )

#define CF_BITMAP        2
#define VK_SNAPSHOT      0x2C
#define KEYEVENTF_KEYUP  0x0002

LOCAL cFileExtName, cEncoder, iInputBuf, iResult
LOCAL hBitmap, hToken, hGdipBitmap

m.cFileExtName = LOWER( JUSTEXT( m.tcFile ))

decl_api()

keybd_event( VK_SNAPSHOT, 0, 0, 0 )
keybd_event( VK_SNAPSHOT, 0, KEYEVENTF_KEYUP, 0 )
INKEY(0.1)

m.iResult = -1
IF ( 0 != OpenClipboard( 0 ))
    m.hBitmap = GetClipboardData( CF_BITMAP )
    IF ( 0 != m.hBitmap )
        m.hToken = 0
        m.iInputBuf = 0h01 + REPLICATE( CHR(0),15 )
        IF ( 0 == GdiplusStartup( @ m.hToken, @ m.iInputBuf, 0 ))
            m.hGdipBitmap = 0
            IF ( 0 == GdipCreateBitmapFromHBITMAP( ;
                m.hBitmap, 0, @ m.hGdipBitmap ))
                m.cEncoder = ICASE( ;
                'jpg' == m.cFileExtName, 0h01, ;
                'gif' == m.cFileExtName, 0h02, ;
                'tif' == m.cFileExtName, 0h05, ;
                'png' == m.cFileExtName, 0h06, 0h00 ) ;
                + 0hF47C55041AD3119A730000F81EF32E
                m.iResult = GdipSaveImageToFile( ;
                    m.hGdipBitmap, ;
                    STRCONV( m.tcFile+CHR(0), 5 ), ;
                    m.cEncoder, 0 )
                GdipDisposeImage( m.hGdipBitmap )
            ENDIF
            GdiplusShutdown( m.hToken )
        ENDIF
        EmptyClipboard()
        CloseClipboard()
    ENDIF
ENDIF

RETURN ( 0 == m.iResult )
ENDFUNC

FUNCTION decl_api
    DECLARE Long keybd_event IN WIN32API ;
        Long bVk, Long bScan, Long dwFlags, Long dwExtraInfo
    DECLARE Long OpenClipboard IN WIN32API ;
        Long hWndNewOwner
    DECLARE Long EmptyClipboard IN WIN32API
    DECLARE Long CloseClipboard IN WIN32API
    DECLARE Long GetClipboardData IN WIN32API ;
        Long uFormat

    DECLARE Long GdiplusStartup IN gdiplus ;
        Long @ token, String @ inputbuf, Long @ outputbuf
    DECLARE Long GdiplusShutdown IN gdiplus ;
        Long token
    DECLARE Long GdipCreateBitmapFromHBITMAP IN gdiplus ;
        Long hbitmap, Long hpalette, Long @ hGpBitmap
    DECLARE Long GdipDisposeImage IN gdiplus ;
        Long image
    DECLARE Long GdipSaveImageToFile IN gdiplus ;
        Long nImage, String FileName, ;
        String clsIdEncoder, Long encoderParams
ENDFUNC
PROCEDURE send_jsb

conx=odbc(5)
xx=DTOC(DATE()-1,1)
IF SQLEXEC(conx,"select DISTINCT RTRIM(TD001)+TD002 AS 订单号码,CA.MA002 AS 客户名称,N.MV002 as 业务员,CA.MA016,"+;
"CASE WHEN LEFT(TD013,1)='2' THEN CAST( TD013 AS DATETIME ) ELSE '' END AS 预出货日期,CAST(CA.UDF06 AS CHAR(60)) MGDY,pi.interid,"+;
"CASE WHEN pi.po IS NULL then '' ELSE pi.po END po,convert(char(10),CAST(COPTC.TC003 as datetime),102) AS CHKDATE,V1.MV002,TB006,"+;
"CASE WHEN pipro.EXTO IS NULL THEN '' ELSE pipro.EXTO END 验货日,TD015 "+;
" FROM pi inner join pidetail on pi.interid=pidetail.maininterid and pidetail.mf002='N' INNER JOIN COPTD ON pidetail.interid=COPTD.UDF56  "+;
" LEFT JOIN COPMA CA ON pi.customid=CA.MA001 LEFT JOIN CMSMV N ON CA.MA016=N.MV001 INNER JOIN COPTC ON pi.interid=COPTC.UDF55 INNER join ADMTB ON TB007=RTRIM(TC001)+'-'+TC002  "+;
" AND TB002='A'   LEFT JOIN CMSMV V1 ON TB004=V1.MV001 inner JOIN pipro on pi.interid=pipro.interid "+;
"WHERE TD021='Y' AND TD016='N' AND pi.chkid=1  AND TD001<>'227' AND TD004>='A' AND (COPTD.UDF05='' or COPTD.UDF05 IS NULL) "+;
"AND LEFT(TD004,1)<>'Z' AND LEFT(TD004,1)<'X' AND TD020 not like '%打样%' and TB003='COPMI06' AND DATEDIFF(hour,TB006,getdate())>=20 and LEFT(COPTD.TD004,1)<>'X' and "+;
"NOT EXISTS (select 'x' from MOCTA WHERE TA033=RTRIM(COPTD.TD001)+COPTD.TD002) ORDER BY 1,10","TMPX")<0  && AND (TD015='' OR TD015 IS NULL) 
SQLDISCONNECT(conx)
*MESSAGEBOX('技术部???')
WAIT windows '技术部工单' NOWAIT 
RETURN 
ENDIF

IF SQLEXEC(conx,"select DISTINCT RTRIM(TD001)+TD002 AS 订单号码,CA.MA002 AS 客户名称,N.MV002 as 业务员,CA.MA016,"+;
"CASE WHEN LEFT(TD013,1)='2' THEN CAST( TD013 AS DATETIME ) ELSE '' END AS 预出货日期,CAST(CA.UDF06 AS CHAR(60)) MGDY,pi.interid,"+;
"CASE WHEN pi.po IS NULL then '' ELSE pi.po END po,convert(char(10),CAST(COPTC.TC003 as datetime),102) AS CHKDATE,pi.chkname AS  MV002,pi.chkdate TB006,'          ' 验货日,TD015 "+;
" FROM pi inner join pidetail on pi.interid=pidetail.maininterid and pidetail.mf002='N' INNER JOIN COPTD ON pidetail.interid=COPTD.UDF56  "+;
" LEFT JOIN COPMA CA ON pi.customid=CA.MA001 LEFT JOIN CMSMV N ON CA.MA016=N.MV001  INNER JOIN COPTC ON pi.interid=COPTC.UDF55 "+;
"WHERE TD021='V' AND TD016='N' AND pi.chkid=1  AND TD001<>'227' AND TD015=''  AND TD004>='A' "+;
"AND LEFT(TD004,1)<>'Z' AND LEFT(TD004,1)<>'X' AND LEFT(TD004,1)<>'Y' AND TD020 not like '%打样%'  AND DATEDIFF(hour,pi.chkdate,getdate())>=20 and "+;
"NOT EXISTS (select 'x' from MOCTA WHERE TA033=RTRIM(COPTD.TD001)+COPTD.TD002)","TMP")<0
*MESSAGEBOX('???1')
WAIT windows '技术部工单' NOWAIT 
RETURN 
ENDIF



SQLDISCONNECT(conx)
SELECT TMP
DDH='1'
SELECT TMPX
GO TOP
DO WHILE .NOT. EOF()
	SCATTER TO CDSL
	IF 订单号码<>DDH
		SELECT TMP
		APPEND BLANK 
		GATHER FROM CDSL
	ENDIF
	DDH=订单号码
	SELECT TMPX
	SKIP
ENDDO	
SELECT TMP
TABLEUPDATE(.T.)
IF USED("TMPSALES")
	SELECT TMPSALES
	USE
ENDIF	
SELECT 业务员 FROM TMP WHERE LEFT(订单号码,3)='223' GROUP BY 1 INTO CURSOR TMPSALES&&AND LEFT(TD015,1)<>'2'
SELECT TMPSALES
GO TOP
DO WHIL .NOT. EOF()
	XXX=业务员
	
	IF USED("TMPBUYETR")
		SELECT TMPBUYETR
		USE
	ENDIF
	SELECT * FROM TMP WHERE 业务员=XXX  and LEFT(订单号码,3)='223' ORDER BY 5 INTO CURSOR TMPBUYETR
	SELECT TMPBUYETR
	TT=RECCOUNT()
	GO TOP
	X=1
	Y=OCCURS('Y', MGDY)
	Z=''
	IF Y=0
		xmGDY=''
	ELSE
		DO WHIL X<=Y
			SELECT TMPBUYETR
			Z1=SUBSTR(MGDY,AT('Y',MGDY,X),6)
			con=odbc(5)
			SQLEXEC(CON,"SELECT MV002 FROM CMSMV WHERE MV001=?Z1","TMDDDD")
			SQLDISCONNECT(con)

			IF RECCOUNT()=1
				CDSSSS=MV002
				IF CDSSSS$Z=.F.
					Z=Z+ALLTRIM(MV002)+';'
				ENDIF
			ENDIF	
			X=X+1
		ENDDO
		xmGDY=ALLTRIM(Z)
	ENDIF
	
	IF USED("TMDDDD")
		SELECT TMDDDD
		USE
	ENDIF			
	mrev=ALLTRIM(XXX)+';黄艳;'+xmGDY
	
	SELECT TMPBUYETR

	GO TOP

	T=''
	DO WHIL .NOT. EOF()
		IF '黄艳;'$mrev=.f. AND LEFT(订单号码,3)='223'
			mrev='黄艳;'+mrev
		ENDIF 
		IF LEFT(TD015,1)='2'
			IF '样品组长;'$mrev=.f.
				mrev='样品组长;'+mrev
			ENDIF	
		ENDIF 
		IF len(ALLTRIM(po))>0
			S=ALLTRIM(STR(RECNO()))+'.'+ ALLTRIM(订单号码)+'['+ALLTRIM(客户名称)+']'+',PI:'+ALLTRIM(STR(interid))+','+ALLTRIM(MV002)+'于'+TTOC(TB006)+'审核,Po:'+ALLTRIM(po)+',要求交期:'+DTOC(TTOD(预出货日期))
		ELSE
			S=ALLTRIM(STR(RECNO()))+'.'+ ALLTRIM(订单号码)+'['+ALLTRIM(客户名称)+']'+',PI:'+ALLTRIM(STR(interid))+','+ALLTRIM(MV002)+'于'+TTOC(TB006)+'审核,要求交期:'+DTOC(TTOD(预出货日期))
		ENDIF 	
		
		IF len(ALLTRIM(验货日))>=3
			S=S+',验货日:'+ALLTRIM(验货日)
		ENDIF 
		keyid=interid
		CON=ODBC(5)
		SQLEXEC(con,"select top 1 a.ta010 from pidetail p left JOIN pmocta a on p.interid=a.detailinterid LEFT join INVMB ON a.code=MB001 "+;
		" where p.maininterid=?keyid AND a.ta015>INVMB.MB064  AND a.classid<>'512' order by 1","tmpcode")		
		SQLDISCONNECT(con)
		IF RECCOUNT()=1
			IF ta010>=DTOC(DATE()-7,1)
				IF '王文雅;'$mrev=.f. 
					mrev='王文雅;'+mrev
				ENDIF 	
*!*					IF '黄丽锋'$mrev=.f. 
*!*						mrev='黄丽锋;'+mrev
*!*					ENDIF 
				S=S+CHR(13)+CHR(10)+'警告:交期十分紧迫,请立即发放工单,确保采购生产正常进行!'
			ENDIF 
		ENDIF
		IF LEN(ALLTRIM(T+S))<2500
			T=T+S+';'+CHR(13)+CHR(10)
		ELSE
			T=T+CHR(13)+CHR(10)+'...'
			EXIT
		ENDIF
		SELECT TMPBUYETR

		SKIP
	ENDDO		
	m_Note='业务员['+ALLTRIM(XXX)+']'+ALLTRIM(STR(TT))+'张订单没有跑工单:'+CHR(13)+CHR(10)+T	
	mtitle=ALLTRIM(XXX)+DTOC(DATE())+':没有制作工单的订单'

*!*		IF !EMPTY(mGDY)
*!*			mrev=mrev+mGDY
*!*		ENDIF		
	*THISFORM.COMMand1.Click()
	
	tmpkeyid=maxinterid("rtxmessage")
*!*		con1=odbc(6)
*!*		SQLEXEC(con1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,?P_UserName,getdate(),?m_Note,?mtitle,0)")
*!*		SQLDISCONNECT(con1)
	SELECT TMPSALES
	SKIP
ENDDO


IF USED("TMPSALES")
	SELECT TMPSALES
	USE
ENDIF	
SELECT 业务员 FROM TMP WHERE LEFT(订单号码,3)<>'223' GROUP BY 1 INTO CURSOR TMPSALES
SELECT TMPSALES
GO TOP
DO WHIL .NOT. EOF()
	XXX=业务员
	
	IF USED("TMPBUYETR")
		SELECT TMPBUYETR
		USE
	ENDIF
	SELECT * FROM TMP WHERE 业务员=XXX AND LEFT(订单号码,3)<>'223' ORDER BY 5 INTO CURSOR TMPBUYETR
	SELECT TMPBUYETR
	TT=RECCOUNT()
	GO TOP
	X=1
	Y=OCCURS('Y', MGDY)
	Z=''
	IF Y=0
		xmGDY=''
	ELSE
		DO WHIL X<=Y
			SELECT TMPBUYETR
			Z1=SUBSTR(MGDY,AT('Y',MGDY,X),6)
			con=odbc(5)
			SQLEXEC(CON,"SELECT MV002 FROM CMSMV WHERE MV001=?Z1","TMDDDD")
			SQLDISCONNECT(con)

			IF RECCOUNT()=1
				CDSSSS=MV002
				IF CDSSSS$Z=.F.
					Z=Z+ALLTRIM(MV002)+';'
				ENDIF
			ENDIF	
			X=X+1
		ENDDO
		xmGDY=ALLTRIM(Z)
	ENDIF
	
	IF USED("TMDDDD")
		SELECT TMDDDD
		USE
	ENDIF			
	mrev=ALLTRIM(XXX)+';马丽波;陈冲俞;许恒军;'+xmGDY
	
	SELECT TMPBUYETR

	GO TOP

	T=''
	DO WHIL .NOT. EOF()
		IF '黄艳;'$mrev=.f. AND LEFT(订单号码,3)='223'
			mrev='黄艳;'+mrev
		ENDIF 
		IF len(ALLTRIM(po))>0
			S=ALLTRIM(STR(RECNO()))+'.'+ ALLTRIM(订单号码)+'['+ALLTRIM(客户名称)+']'+',PI:'+ALLTRIM(STR(interid))+','+ALLTRIM(MV002)+'于'+TTOC(TB006)+'审核,Po:'+ALLTRIM(po)+',要求交期:'+DTOC(TTOD(预出货日期))
		ELSE
			S=ALLTRIM(STR(RECNO()))+'.'+ ALLTRIM(订单号码)+'['+ALLTRIM(客户名称)+']'+',PI:'+ALLTRIM(STR(interid))+','+ALLTRIM(MV002)+'于'+TTOC(TB006)+'审核,要求交期:'+DTOC(TTOD(预出货日期))
		ENDIF 	
		
		IF len(ALLTRIM(验货日))>=3
			S=S+',验货日:'+ALLTRIM(验货日)
		ENDIF 
		keyid=interid
		CON=ODBC(5)
		SQLEXEC(con,"select top 1 a.ta010 from pidetail p left JOIN pmocta a on p.interid=a.detailinterid LEFT join INVMB ON a.code=MB001 "+;
		" where p.maininterid=?keyid AND a.ta015>INVMB.MB064  AND a.classid<>'512' order by 1","tmpcode")		
		SQLDISCONNECT(con)
		IF RECCOUNT()=1
			IF ta010>=DTOC(DATE()-7,1)
				IF '王文雅;'$mrev=.f. 
					mrev='王文雅;'+mrev
				ENDIF 	
*!*					IF '黄丽锋'$mrev=.f. 
*!*						mrev='黄丽锋;'+mrev
*!*					ENDIF 
				S=S+CHR(13)+CHR(10)+'警告:交期十分紧迫,请立即发放工单,确保采购生产正常进行!'
			ENDIF 
		ENDIF
		IF LEN(ALLTRIM(T+S))<2000
			T=T+S+';'+CHR(13)+CHR(10)
		ELSE
			T=T+CHR(13)+CHR(10)+'...'
			EXIT
		ENDIF
		SELECT TMPBUYETR

		SKIP
	ENDDO		
	m_Note='业务员['+ALLTRIM(XXX)+']'+ALLTRIM(STR(TT))+'张订单没有跑工单:'+CHR(13)+CHR(10)+T	
	mtitle=ALLTRIM(XXX)+DTOC(DATE())+':没有制作工单的订单'

*!*		IF !EMPTY(mGDY)
*!*			mrev=mrev+mGDY
*!*		ENDIF		
	*THISFORM.COMMand1.Click()
	
	tmpkeyid=maxinterid("rtxmessage")
*!*		con1=odbc(6)
*!*		SQLEXEC(con1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,?P_UserName,getdate(),?m_Note,?mtitle,0)")
*!*		SQLDISCONNECT(con1)
	SELECT TMPSALES
	SKIP
ENDDO
IF USED("TMPSALES")
	SELECT TMPSALES
	USE
ENDIF
ENDPROC 
PROCEDURE maxinteridt
PARAMETERS TABLENAME

CON1=ODBC(6)
SQLEXEC(CON1,"SELECT id  FROM sixplusone..tablemaxid WHERE UPPER(tablename)=UPPER('&TABLENAME')" ,'tempinsert')
SELECT tempinsert
T=tempinsert.ID
IF YEAR(DATE())*1000000+MONTH(DATE())*10000>T
	P_ChkBill=YEAR(DATE())*1000000+MONTH(DATE())*10000
	CKEYID=STR(P_ChkBill)
	SQLEXEC(CON1,"UPDATE sixplusone..tablemaxid SET id='&CKEYID' WHERE UPPER(tablename)=UPPER('&TABLENAME') ")
ELSE
	P_ChkBill=T
	CKEYID=STR(P_ChkBill+1)
	SQLEXEC(CON1,"UPDATE sixplusone..tablemaxid SET id='&CKEYID' WHERE UPPER(tablename)=UPPER('&TABLENAME') ")
ENDIF
IF USED("tempinsert")
	SELECT tempinsert
	USE
ENDIF	
SQLDISCONNECT(con1)
RETURN P_ChkBill
ENDPROC


PROCEDURE maxinterid
PARAMETERS TABLENAME

CON1=ODBC(6)
SQLEXEC(CON1,"SELECT id  FROM tablemaxid WHERE UPPER(tablename)=UPPER('&TABLENAME')" ,'tempinsert')
SELECT tempinsert
T=tempinsert.ID
IF YEAR(DATE())*1000000+MONTH(DATE())*10000>T
	P_ChkBill=YEAR(DATE())*1000000+MONTH(DATE())*10000
	CKEYID=STR(P_ChkBill)
	SQLEXEC(CON1,"UPDATE tablemaxid SET id='&CKEYID' WHERE UPPER(tablename)=UPPER('&TABLENAME') ")
ELSE
	P_ChkBill=T
	CKEYID=STR(P_ChkBill+1)
	SQLEXEC(CON1,"UPDATE tablemaxid SET id='&CKEYID' WHERE UPPER(tablename)=UPPER('&TABLENAME') ")
ENDIF
IF USED("tempinsert")
	SELECT tempinsert
	USE
ENDIF	
SQLDISCONNECT(con1)
RETURN P_ChkBill
ENDPROC

PROCEDURE pidetailta010
	con=odbc(5)
	SQLEXEC(con,"select pi.interid from pi inner join pipro p on pi.interid=p.interid where pi.chkid=1 and pi.statusid<>'结案' and LEFT(p.TA040,1)<>'2'","tmp")
	DO whil .not. EOF()
		cc=interid
		SQLEXEC(con,"select interid from pidetail where mf002='N' AND maininterid=?cc")
		IF RECCOUNT()<1
			SQLEXEC(con,"update pipro set TA040='外购无工单' WHERE interid=?cc")
		ENDIF 
		SELECT tmp
		SKIP
	ENDDO 	
	SQLDISCONNECT(con)
	CON=ODBC(5)
	XTA015=0
tcc=0

	IF SQLEXEC(CON,"SELECT DISTINCT pidetail.interid,TD001,TD002,TD003,TD015,TD028,COPTD.UDF05,maininterid,code from pidetail  "+;
	"inner join COPTD on pidetail.interid=COPTD.UDF56 WHERE TD016='N' AND TD008>TD009 order by maininterid desc","tmpPIInfo1")<0
	     WAIT windows '????' nowait&&left join COPTC ON interid=COPTC.UDF55TC027,left join COPTD ON TC001=TD001 AND TC002=TD002AND TD008<TD009
		 SQLDISCONNECT(CON)
	     RETURN
	ENDIF   
	SELECT tmpPIInfo1
	T1=0 
	GO TOP
	DO WHILE .NOT. EOF()
		MBILL =ALLTRIM(TD001)+TD002
		MBILLC =ALLTRIM(MBILL)
		DF=maininterid 
		keyid=DF
		mcode=ALLTRIM(code)
		XCC=interid
		IF LEFT(TD015,1)<'1'
			IF EMPTY(UDF05) OR ISNULL(UDF05)
				SQLEXEC(con,"select TOP 1 UDF56,TA010,UDF03,TA033,TA003,RTRIM(TA001)+'-'+TA002 TA001, "+;
				"case when TA011='1' then '未生产' WHEN TA011='2' THEN '已发料' when TA011='3' THEN '生产中' when TA011='Y' THEN '已完工' when TA011='y' THEN '指定完工' end 生产状态 "+;
				"FROM MOCTA WHERE TA033=?MBILL AND TA013='Y' AND TA006=?mCode ORDER BY 2 DESC,1 ")
				IF RECCOUNT()=1
					MT=TA010
					MTA001=TA001
					IF UDF56=0
						TT=LEFT(MT,4)+'.'+SUBSTR(MT,5,2)+'.'+RIGHT(MT,2)	
					ELSE
						TT=ALLTRIM(UDF03) +'周'
					ENDIF
					xxc='工单:'+ALLTRIM(生产状态)
					XG=LEFT(TA003,4)+'.'+SUBSTR(TA003,5,2)+'.'+RIGHT(TA003,2)	
					SQLEXEC(con,"update pidetail set mf001=?tt,outerbarcode=?xxc where interid=?XCC")
					*SQLEXEC(con,"update pi set statusid='已排产' where interid=?keyid")
					SQLEXEC(con,"select TA017 TG013 FROM MOCTA WHERE TA033=?MBILL AND TA013='Y'  AND TA006=?mCode ")
					IF RECCOUNT()=1 AND !ISNULL(TG013)
						T1=TG013
						SQLEXEC(con,"update COPTD set TD009=?T1 where UDF56=?XCC AND TD021='V'")
					ENDIF	
					sQLEXEC(con,"SELECT TOP 1 TB006 FROM ADMTB  WHERE TB003='MOCI02' AND TB002='A' and TB007=?MTA001 ORDER BY TB006")
					IF RECCOUNT()=1
					GDRQ=TTOC(TB006)
					SQLEXEC(con,"update pipro set UDF56=?tt,TA040=?GDRQ where interid=?keyid")
					ENDIF					
					tcc=1
					SQLEXEC(con,"select top 1 TC003,CASE WHEN TD016='Y' THEN '自动结束' when TD016='y' then '指定结束' else '未结束' end TD "+;
					",LEFT(TD012,4)+'.'+DATENAME( Wk,CAST(TD012 AS DATETIME)) AS ZC ,TD012,RTRIM(TD001)+'-'+TD002 TD001 "+;
					" FROM PURTD INNER JOIN PURTC ON TC001=TD001 AND TC002=TD002 WHERE TD024=?MBILL order by 1 desc") &&and TD004=?mcode
					IF RECCOUNT()=1
						MT=TD012
						xxc ='采购:'+ALLTRIM(TD)
						TT=ALLTRIM(ZC) +'周'
						XG=TC003
						MTA001=TD001
						*SQLEXEC(con,"update pidetail set mf001=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),outerbarcode=?xxc where interid=?XCC") &&
						*SQLEXEC(con,"update pipro set TC003=LEFT(?XG,4)+'.'+SUBSTRING(?XG,5,2)+'.'+RIGHT(?XG,2) where interid=?keyid") &&UDF56=?TT,
*!*							sQLEXEC(con,"SELECT TOP 1 TB006 FROM ADMTB WHERE (TB003='PURI05' OR TB003='PURI07' OR TB003='PURI09')  "+;
*!*							"AND TB002='A' and TB007=?MTA001 ORDER BY TB006")
*!*							IF RECCOUNT()=1
*!*							GDRQ=TTOC(TB006)
*!*							SQLEXEC(con,"update pipro set  TC003=?GDRQ where interid=?keyid")
*!*							ENDIF
						*SQLEXEC(con,"update pi set statusid=?xxc  where interid=?keyid")
						*tcc=2
					ENDIF
				ELSE  	
					SQLEXEC(con,"select top 1 TC003,CASE WHEN TD016='Y' THEN '自动结束' when TD016='y' then '指定结束' else '未结束' end TD "+;
					",LEFT(TD012,4)+'.'+DATENAME( Wk,CAST(TD012 AS DATETIME)) AS ZC ,TD012,RTRIM(TD001)+'-'+TD002 TD001 "+;
					" FROM PURTD INNER JOIN PURTC ON TC001=TD001 AND TC002=TD002 WHERE TD024=?MBILL and TD004=?mcode order by 1 desc")
					IF RECCOUNT()=1
						MT=TD012
						xxc ='外购:'+ALLTRIM(TD)
						TT=ALLTRIM(ZC) +'周'
						XG=TC003
						MTA001=TD001
						SQLEXEC(con,"update pidetail set mf001=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),outerbarcode=?xxc where interid=?XCC")
						SQLEXEC(con,"update pipro set UDF56=?TT,TC003=LEFT(?XG,4)+'.'+SUBSTRING(?XG,5,2)+'.'+RIGHT(?XG,2) where interid=?keyid")
						SQLEXEC(con,"update pi set statusid=?xxc  where interid=?keyid")
*!*							sQLEXEC(con,"SELECT TOP 1 TB006 FROM ADMTB WHERE (TB003='PURI05' OR TB003='PURI07' OR TB003='PURI09')  AND TB002='A' and TB007=?MTA001 ORDER BY TB006")
*!*							IF RECCOUNT()=1
*!*							GDRQ=TTOC(TB006)
*!*							SQLEXEC(con,"update pipro set TC003=?GDRQ where interid=?keyid")
*!*							ENDIF
						tcc=2
					ENDIF
				ENDIF 		
			ELSE
				MBILL=LEFT(UDF05,3)+STREXTRACT(UDF05,',',',',1)
				SQLEXEC(con,"select TOP 1 UDF56,TA010,UDF03,TA033,RTRIM(TA001)+'-'+TA002 TA001, "+;
				"case when TA011='1' then '未生产' WHEN TA011='2' THEN '已发料' when TA011='3' THEN '生产中' when TA011='Y' THEN '已完工' when TA011='y' THEN '指定完工' end 生产状态 "+;
				"FROM MOCTA WHERE TA033=?MBILL AND TA013='Y' AND TA006=?mCode ORDER BY 2 DESC,1 ")
				IF RECCOUNT()=1
						MT=TA010
						IF UDF56=0
							TT=LEFT(MT,4)+'.'+SUBSTR(MT,5,2)+'.'+RIGHT(MT,2)	
						ELSE
							TT=ALLTRIM(UDF03) +'周'
						ENDIF
						MTA001=TA001
						xxc='借订单:'+ALLTRIM(生产状态)
						SQLEXEC(con,"update pidetail set mf001=?tt,outerbarcode=?xxc where interid=?XCC")
						SQLEXEC(con,"update pipro set UDF56=?tt where interid=?keyid")
						*SQLEXEC(con,"update pi set statusid='已排产' where interid=?keyid")
						tcc=1
						
					sQLEXEC(con,"SELECT TOP 1 TB006 FROM ADMTB WHERE TB003='MOCI02' AND TB002='A' and TB007=?MTA001 ORDER BY TB006")
					IF RECCOUNT()=1
					GDRQ=TTOC(TB006)
					SQLEXEC(con,"update pipro set UDF56=?tt,TA040=?GDRQ where interid=?keyid")
					ENDIF
				ELSE  	
					SQLEXEC(con,"select TOP 1 TD012 TC003,CASE WHEN TD016='Y' THEN '自动结束' when TD016='y' then '指定结束' else '未结束' end TD,RTRIM(TD001)+'-'+TD002 TD001 "+;
					" FROM PURTD INNER JOIN PURTC ON TC001=TD001 AND TC002=TD002 WHERE TD024=?MBILL AND TC014='Y' and TD004=?mcode ORDER BY 1 DESC")
					IF RECCOUNT()=1
						MT=TC003
						xxc ='借外购:'+ALLTRIM(TD)
						MTA001=TD001
						SQLEXEC(con,"update pidetail set mf001=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),outerbarcode=?xxc   where interid=?XCC")
						SQLEXEC(con,"update pipro set UDF56=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2) where interid=?keyid")
						SQLEXEC(con,"update pi set statusid=?xxc where interid=?keyid")
*!*							sQLEXEC(con,"SELECT TOP 1 TB006 FROM ADMTB WHERE (TB003='PURI05' OR TB003='PURI07' OR TB003='PURI09')  AND TB002='A' and TB007=?MTA001 ORDER BY TB006")
*!*							IF RECCOUNT()=1
*!*								GDRQ=TTOC(TB006)
*!*								SQLEXEC(con,"update pipro set TC003=?GDRQ where interid=?keyid")
*!*							ENDIF						
						tcc=2
					ENDIF
				ENDIF 
			ENDIF	

		ELSE 
			*mbill=TD015
				SQLEXEC(con,"select TOP 1 UDF56,TA010,UDF03,TA033,TA017,LEFT(TA010,4)+'.'+DATENAME( Wk,CAST(TA010 AS DATETIME)) AS ZC ,RTRIM(TA001)+'-'+TA002 TA001 ,"+;
				"case when TA011='1' then '未生产' WHEN TA011='2' THEN '已发料' when TA011='3' THEN '生产中' when TA011='Y' THEN '已完工' when TA011='y' THEN '指定完工' end 生产状态 "+;
				"FROM MOCTA WHERE TA033=?MBILL AND TA013='Y' AND TA006=?mCode ORDER BY 2 DESC,1 ")
			IF RECCOUNT()=1
				MT=TA010
				xxc='工单'+ALLTRIM(生产状态)
				MTA001=TA001
				IF UDF56=0
					TT=LEFT(MT,4)+'.'+SUBSTR(MT,5,2)+'.'+RIGHT(MT,2)	
				ELSE
					TT=ALLTRIM(UDF03) +'周'
				ENDIF
				XTA015=TA017
				xxc='重工单:'+ALLTRIM(生产状态)
				
				TT=ALLTRIM(ZC) +'周'
				SQLEXEC(con,"update pidetail set mf001=?tt,outerbarcode=?xxc  where interid=?keyid")
				SQLEXEC(con,"update pi set statusid=?xxc where interid=?keyid")
				sQLEXEC(con,"SELECT TOP 1 TB006 FROM ADMTB  WHERE TB003='MOCI02' AND TB002='A' and TB007=?MTA001 ORDER BY TB006")
				IF RECCOUNT()=1
				GDRQ=TTOC(TB006)
				SQLEXEC(con,"update pipro set UDF56=?tt,TA040=?GDRQ where interid=?keyid")
				ENDIF
				tcc=3
			ELSE  	
				XTA015=0

				SQLEXEC(con,"select TOP 1 TC003,CASE WHEN TD016='Y' THEN '自动结束' when TD016='y' then '指定结束' else '未结束' end TD "+;
				",LEFT(TD012,4)+'.'+DATENAME( Wk,CAST(TD012 AS DATETIME)) AS ZC,TD012,RTRIM(TD001)+'-'+TD002 TD001 "+;
				" FROM PURTD INNER JOIN PURTC ON TC001=TD001 AND TC002=TD002 WHERE TD024=?MBILL AND TC014='Y' and TD004=?mcode ORDER BY 1 DESC")
				IF RECCOUNT()=1
					MT=TC003
					xxc ='调外购:'+ALLTRIM(TD)
					MT1=ALLTRIM(ZC)+'周'
					XG=TD012
					MTD001=TD001
					SQLEXEC(con,"update pidetail set mf001=LEFT(?XG,4)+'.'+SUBSTRING(?XG,5,2)+'.'+RIGHT(?XG,2)  where interid=?XCC")
					SQLEXEC(con,"update pipro set UDF56=?MT1,TC003=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2) where interid=?keyid")
					SQLEXEC(con,"update pi set statusid=?xxc  where interid=?keyid")
					tcc=2
				ENDIF
			ENDIF 
		ENDIF 	&&ERP审批
		T1=0	
		IF tcc=1
			SQLEXEC(con,"select TA017 TG013 FROM  MOCTA WHERE TA033=?MBILL AND TA013='Y' AND  TA006=?mCode")
			IF RECCOUNT()=1 AND !ISNULL(TG013)
				T1=TG013
			ENDIF	
		ENDIF	
		IF tcc=2
			SQLEXEC(con,"select TD015 TG013 FROM PURTD WHERE TD024=?MBILL AND TD018='Y' and TD004=?mcode")
			IF RECCOUNT()=1 AND !ISNULL(TG013)
				T1=TG013
			ENDIF	
		ENDIF	
		IF tcc=3
	*!*			SQLEXEC(con,"select SUM(TG013*TG009) TG013 FROM MOCTG INNER JOIN MOCTA ON TG014=TA001 AND TG015=TA002 "+;
	*!*				"WHERE TA033=?MBILL AND TA013='Y' AND (TA021='05' OR TA021='11') AND TG004=?mCode ")
	*!*			IF RECCOUNT()=1 AND !ISNULL(TG013)
	*!*				T1=TG013
	*!*			ENDIF	
			SQLEXEC(con,"select SUM(MF008-MF009) TG013 FROM COPMF WHERE MF001=?MBILL AND MF003=?mCode ")
			IF RECCOUNT()=1 AND !ISNULL(TG013)
				T1=XTA015
			ENDIF	
		ENDIF	
		SQLEXEC(con,"update pidetail set tppcs=?t1 where interid=?XCC")

		SELECT tmpPIInfo1
	   	SKIP
	ENDDO
	SQLEXEC(CON,"update pidetail set outerbarcode=CASE WHEN TD016='Y' THEN '订单自动结束' when TD016='y' then '订单指定结束' end, "+;
	"tppcs=CASE WHEN TD016='Y' THEN quan  end "+;
	"FROM pidetail inner join COPTD on pidetail.interid=COPTD.UDF56 where TD016<>'N' AND outerbarcode<>'已核销'")	
	SQLDISCONNECT(CON)
ENDPROC 
PROCEDURE everyday
PARA mFile,mId,mEditMode
cmac=getmac()
CPUSER=P_UserName+'/'+ALLTRIM(SYS(0))
CON=ODBC(6)
SQLEXEC(CON,"execute everylog '&CPUSER','&mFile','&mId','&mEditMode'",'&cmac')
SQLDISCONNECT(con)
RETURN 

ENDPROC 

Function GetCalendar( tcYYYYMMDD, tcCursName )
 Local lcYYYYMMDD, lcCursName, ldEasterDate
 lcYYYYMMDD = []
 lcYYYYMMDD = iif(Type([tcYYYYMMDD])$[DT], DToS(tcYYYYMMDD), lcYYYYMMDD )
 lcYYYYMMDD = iif(Type([tcYYYYMMDD])==[C], Allt(tcYYYYMMDD), lcYYYYMMDD )
 If empt(lcYYYYMMDD)
  Return .F.
 Else
  lcCursName = iif(Type([tcCursName])=[C] and !empt(tcCursName), tcCursName, [TCalendar_]+lcYYYYMMDD )
  If Used(lcCursName)
   Use in (lcCursName)
  Endif
  If len(lcYYYYMMDD) >= 4
   ldEasterDate = GetEasterDate(Val(Left(lcYYYYMMDD,4)))
   * 字段: d公历,n星期,l闰月,n农历年,n农历月,n农历日,c农历年,c农历月,c农历日,c节气,c生肖,c节日
   Crea Curs (lcCursName) ( dSolar D, nWeek N(1), IsLeap L, ;
    nLunarY N(4), nLunarM N(2), nLunarD N(2), ;
    cLunarY C(4), cLunarM C(4), cLunarD C(4), ;
    cJieQi C(4), cAniName C(2), cStarName C(6), cJieRi C(100) )
   Do case
    Case len(lcYYYYMMDD) = 4
     = InsCalendarFromYear(  lcCursName, lcYYYYMMDD, ldEasterDate )
    Case len(lcYYYYMMDD) = 6
     = InsCalendarFromMonth( lcCursName, lcYYYYMMDD, ldEasterDate )
    Case len(lcYYYYMMDD) = 8
     = InsCalendarFromDate(  lcCursName, lcYYYYMMDD, ldEasterDate )
    Other
   Endcase
  Endif
  Return Used(lcCursName) and Recc(lcCursName)>0
 Endif
Endfunc
*-------------------------------------------------
* 程序: 添加日历年份记录
* 示例: ? InsCalendarFromYear( [TempCalendar], [2003] )
*-------------------------------------------------
Function InsCalendarFromYear( tcCursName, tcYYYY, tdEasterDate )
 If Type([tcCursName])=[C] and Used(tcCursName)
  If Type([tcYYYY])=[C] and !empt(tcYYYY)
   ldEasterDate = iif( Type([tdEasterDate])=[D], tdEasterDate, GetEasterDate(Val(Left(tcYYYY,4))) )
   Local lcYYYY, ldDate
   If Type([tcYYYY])=[C]
    lcYYYY = Padl(tcYYYY,4,[0])
   Else
    If Type([tcYYYY])=[N]
     lcYYYY = Padl(allt(str(cYYYY)),4,[0])
    Endif
   Endif
   ldDate  = CToD( lcYYYY + [.01.01] )
   If !empt(ldDate)
    Local liYear, liMonth, liDay
    Local lnLunarY, lnLunarM, lnLunarD, lnLunarDays
    liYear  = Year(ldDate)
    Store 0 To lnLunarY, lnLunarM, lnLunarD, lnLunarDays
    Do While liYear = Year(ldDate)
     liMonth = Month(ldDate)
     lnLunarD = lnLunarD + 1
     If lnLunarDays < lnLunarD
      = InsCalendarFromDate( tcCursName, ldDate, ldEasterDate )
      Sele (tcCursName)
      lnLunarY = nLunarY
      lnLunarM = nLunarM
      lnLunarD = nLunarD
      llIsLeap  = IsLeap
      If llIsLeap
       lnLunarDays = GetLunarLeapDays( lnLunarY )
      Else
       lnLunarDays = GetLunarMonthDays( lnLunarY, lnLunarM )
      Endif
     Else
      = InsCalendar( tcCursName, ldDate, llIsLeap, lnLunarY, lnLunarM, lnLunarD, ldEasterDate )
     Endif
     ldDate = ldDate + 1
    Enddo
   Endif
  Endif
 Endif
Endfunc
*-------------------------------------------------
* 程序: 添加日历月份记录
* 示例: ? InsCalendarFromMonth( [TempCalendar], [200310] )
*-------------------------------------------------
Function InsCalendarFromMonth( tcCursName, tcYYYYMM, tdEasterDate )
 If Type([tcCursName])=[C] and Used(tcCursName)
  If Type([tcYYYYMM])=[C] and !empt(tcYYYYMM)
   ldEasterDate = iif( Type([tdEasterDate])=[D], tdEasterDate, GetEasterDate(Val(Left(tcYYYYMM,4))) )
   Local ldDate, liYear, liMonth, liDay
   ldDate  = CToD( subs(tcYYYYMM,1,4) + [.] + subs(tcYYYYMM,5,2) + [.01] )
   If !empt(ldDate)
    liYear  = Year(ldDate)
    liMonth = Month(ldDate)
    lnSolarDays  = GetSolarMonthDays( ldDate )
    Local lnLunarY, lnLunarM, lnLunarD, llIsLeap, lnLunarDays
    Store 0 To lnLunarY, lnLunarM, lnLunarD, lnLunarDays
    Do While liMonth = Month(ldDate)
     lnLunarD = lnLunarD + 1
     If lnLunarDays < lnLunarD
      = InsCalendarFromDate( tcCursName, ldDate, ldEasterDate )
      Sele (tcCursName)
      lnLunarY = nLunarY
      lnLunarM = nLunarM
      lnLunarD = nLunarD
      llIsLeap  = IsLeap
      If llIsLeap
       lnLunarDays = GetLunarLeapDays( lnLunarY )
      Else
       lnLunarDays = GetLunarMonthDays( lnLunarY, lnLunarM )
      Endif
     Else
      = InsCalendar( tcCursName, ldDate, llIsLeap, lnLunarY, lnLunarM, lnLunarD, ldEasterDate )
     Endif
     ldDate = ldDate + 1
    Enddo
   Endif
  Endif
 Endif
Endfunc
*-------------------------------------------------
* 程序: 添加日历日期记录
* 示例: ? InsCalendarFromDate( [TempCalendar], Date(2003,10,01) )
*       ? InsCalendarFromDate( [TempCalendar], [20031001] )
*-------------------------------------------------
Function InsCalendarFromDate( tcCursName, tdDate, tdEasterDate )
 If Type([tcCursName])=[C] and Used(tcCursName)
  Local ldDate, lnLunarY, lnLunarM, lnLunarD, llIsLeap
  If Type([tdDate])=[D]
   ldDate = tdDate
  Else
   If Type([tdDate])=[C]
    ldDate = CToD( subs(tdDate,1,4) + [.] + subs(tdDate,5,2) + [.] + subs(tdDate,7,2) )
   Endif
  Endif
  If Type([ldDate])=[D] and !empt(ldDate)
   ldEasterDate = iif( Type([tdEasterDate])=[D], tdEasterDate, GetEasterDate(Year(tdDate)) )
   lnLunarY = Year (ldDate)
   lnLunarM = Month(ldDate)
   lnLunarD = Day  (ldDate)
   llIsLeap = .F.
   = GetLunarFromSolar( @lnLunarY, @lnLunarM, @lnLunarD, @llIsLeap )
   = InsCalendar( tcCursName, ldDate, llIsLeap, lnLunarY, lnLunarM, lnLunarD, ldEasterDate )
  Endif
 Endif
Endfunc
*-------------------------------------------------
* 程序: 添加日期记录
* 示例: ? InsCalendar( [TempCalendar], Date(2003,10,01), .F., 2003, 09, 06 )
*-------------------------------------------------
Function InsCalendar( tcCursName, tdDate, tlIsLeap, tnLunarY, tnLunarM, tnLunarD, tdEasterDate )
 If Type([tcCursName])=[C] and Used(tcCursName) ;
   and Type([tdDate])=[D] and Type([tlIsLeap])=[L] ;
   and Type([tnLunarY])=[N] and Type([tnLunarM])=[N] and Type([tnLunarD])=[N]
  ldEasterDate = iif( Type([tdEasterDate])=[D], tdEasterDate, GetEasterDate(Year(tdDate)) )
  Insert Into (tcCursName) values ( ;
   tdDate, DOW(tdDate,2), tlIsLeap, tnLunarY, tnLunarM, tnLunarD, ;
   GetGanZhiYear(tdDate), GetGanZhiMonth(tdDate), GetGanZhiDay(tdDate), ;
   GetLunarJieQi(tdDate), GetLunarAniName(Mod(tnLunarY-4,12)), GetSolarStarName(tdDate), ;
   GetSolarGalaName(tdDate,ldEasterDate) + GetLunarGalaName(tnLunarY,tnLunarM,tnLunarD,tlIsLeap) )
 Endif
Endfunc
*-------------------------------------------------
* 程序: 求某公历日是否节日
* 示例: ? GetSolarGalaName( Date(2003,10,01) )
*-------------------------------------------------
Function GetSolarGalaName( tdDate, tdEasterDate )
 Local lcRetu, lnInfo, lcSolarInfo, lcSolarGala
 lcRetu = []
 lcSolarInfo = []
 lcSolarGala = []
 If Type([tdDate])=[D] and !empt(tdDate)
  ldEasterDate = iif( Type([tdEasterDate])=[D], tdEasterDate, GetEasterDate(Year(tdDate)) )
  * 日期节日
  lcSolarInfo = lcSolarInfo + [,0101]
  lcSolarInfo = lcSolarInfo + [,0214]
  lcSolarInfo = lcSolarInfo + [,0308,0312.0315,0321,0322,0323]
  lcSolarInfo = lcSolarInfo + [,0401,0404,0407,0422]
  lcSolarInfo = lcSolarInfo + [,0501,0504,0508,0509,0512,0515,0517,0531]
  lcSolarInfo = lcSolarInfo + [,0601,0605,0606,0621,0626]
  lcSolarInfo = lcSolarInfo + [,0701,0704,0707,0711]
  lcSolarInfo = lcSolarInfo + [,0801,0815,0816]
  lcSolarInfo = lcSolarInfo + [,0908,0909,0910,0911,0928]
  lcSolarInfo = lcSolarInfo + [,1001,1004,1006,1009,1010,1016,1024,1028,1031]
  lcSolarInfo = lcSolarInfo + [,1109,1112,1114,1116,1119]
  lcSolarInfo = lcSolarInfo + [,1201,1203,1205,1208,1210,1211,1213,1220,1225,1226,]
  lnInfo = at( subs(DToS(tdDate),5,4), lcSolarInfo )
  If lnInfo > 0
   lnInfo = occu( [,], left(lcSolarInfo,lnInfo) )
   lcSolarGala = lcSolarGala + [,元旦(New Year's Day)]
   lcSolarGala = lcSolarGala + [,情人节(St. Valentine's Day)]
   lcSolarGala = lcSolarGala + [,国际妇女节,中国植树节,国际消费者权益日,世界林业节.国际反种族歧视日,世界水日,世界气象日]
   lcSolarGala = lcSolarGala + [,愚人节(Fool's Day).香港会计年度始,台湾儿童节,世界卫生日,世界地球日]
   lcSolarGala = lcSolarGala + [,国际劳动节,中国青年节,世界红十字日,郝维节,国际护士节,世界助残日.国际家庭日,世界电信日,世界无烟日]
   lcSolarGala = lcSolarGala + [,国际儿童节,世界环境日,台湾教师节,国际反毒品日,国际戒毒日]
   lcSolarGala = lcSolarGala + [,中国共产党成立纪念日(1921年).香港回归纪念日(1997年),美国国庆(1776年Independence Day),卢沟桥事变(1937年中日战争爆发),世界人口日]
   lcSolarGala = lcSolarGala + [,中国人民解放军建军纪念日(1927年南昌起义),日本投降日(1945年中日战争结束),燕衔泥节]
   lcSolarGala = lcSolarGala + [,国际扫盲日,毛泽东逝世纪念(1976年),中国教师节,纽约世贸中心遇袭(2001年),孔子诞辰]
   lcSolarGala = lcSolarGala + [,中华人民共和国建国纪念日(1949年).国际老人日,世界动物日,中国老人节,辛亥革命周年纪念(1911年),世界粮食日,世界邮政日,联合国成立纪念日(1945年),万国儿童日(澳洲),万盛节(Halloween西洋鬼节)]
   lcSolarGala = lcSolarGala + [,泰国四面佛祖诞(正诞),诸总生日,国际糖尿病日,国际宽容日,无线电视台庆(1967年)]
   lcSolarGala = lcSolarGala + [,世界艾滋病日,国际康复日(残疾人),国际义工日,香港沦陷日(1941年),国际人权日,世界哮喘日,南京大屠杀悼念日(1937年),澳门回归纪念日(1999年),圣诞节(Christmas),毛泽东诞辰纪念,]
   lnBeg = at( [,], lcSolarGala, lnInfo ) + 1
   lnEnd = at( [,], lcSolarGala, lnInfo + 1 )
   lcRetu = [.] + subs( lcSolarGala, lnBeg, lnEnd-lnBeg )
  Endif
  * 星期节日
  If Month(tdDate) = 05 and tdDate = GetDateFromYMandWeekNo( subs(DToS(tdDate),1,4)+[05], 2, 7 )
   lcRetu = lcRetu + [.母亲节(Mother's Day)]
  Endif
  If Month(tdDate) = 06 and tdDate = GetDateFromYMandWeekNo( subs(DToS(tdDate),1,4)+[06], 3, 6 )
   lcRetu = lcRetu + [.香港赛马季暑假]
  Endif
  If Month(tdDate) = 06 and tdDate = GetDateFromYMandWeekNo( subs(DToS(tdDate),1,4)+[06], 3, 7 )
   lcRetu = lcRetu + [.父亲节(Father's Day)]
  Endif
  If Month(tdDate) = 07 and tdDate = GetDateFromYMandWeekNo( subs(DToS(tdDate),1,4)+[06], 3, 1 )
   lcRetu = lcRetu + [.香港学生暑假开始]
  Endif
  If Month(tdDate) = 07 and tdDate = GetDateFromYMandWeekNo( subs(DToS(tdDate),1,4)+[06], 3, 6 )
   lcRetu = lcRetu + [.合作节]
  Endif
  If Month(tdDate) = 07 and tdDate = GetDateFromYMandWeekNo( subs(DToS(tdDate),1,4)+[06], 3, 7 )
   lcRetu = lcRetu + [.被奴役国家周]
  Endif
  If Month(tdDate) = 09 and tdDate = GetDateFromYMandWeekNo( subs(DToS(tdDate),1,4)+[06], 1, 1 )
   lcRetu = lcRetu + [.香港赛马季开锣]
  Endif
  If Month(tdDate) = 09 and tdDate = GetDateFromYMandWeekNo( subs(DToS(tdDate),1,4)+[06], 1, 6 )
   lcRetu = lcRetu + [.香港开学日]
  Endif
  If Month(tdDate) = 11 and tdDate = GetDateFromYMandWeekNo( subs(DToS(tdDate),1,4)+[11], 3, 7 )
   lcRetu = lcRetu + [.长者日]
  Endif
  If Month(tdDate) = 11 and tdDate = GetDateFromYMandWeekNo( subs(DToS(tdDate),1,4)+[11], 4, 4 )
   lcRetu = lcRetu + [.感恩节(Thanksgiving Day)]
  Endif
  If Month(tdDate) = 12 and Betw(Day(tdDate),11,20) and DOW(tdDate,2) = 7 and Betw(Day(tdDate-7),1,10)
   lcRetu = lcRetu + [.香港计算机节] && 12月中旬第一个星期日
  Endif
  * 忌日
  If Day(tdDate)=13 and DOW(tdDate,2)=5
   lcRetu = lcRetu + [.黑色星期五]
  Endif
  If ldEasterDate = tdDate
   * 春分后第一次满月(月圆农历15日)后的第一个星期日
   lcRetu = lcRetu + [.复活节(Easter)]
  Else
   If ldEasterDate = tdDate + 2
    * 复活节前的第一个星期五
    lcRetu = lcRetu + [.耶稣受难日(Good Friday)]
   Endif
  Endif
 Endif
 Return lcRetu
Endfunc
*-------------------------------------------------
* 程序: 求某年 复活节(Easter) 日期
* 示例: ? GetEasterDate( 2003 )
*-------------------------------------------------
Function GetEasterDate( tnYear )
 Local ldRetu
 ldRetu = CToD([])
 If Type([tnYear])=[N] and Betw(tnYear,1,9999)
  * 复活节(Easter) = 春分后第一次满月(月圆农历15日)后的第一个星期日,只出现在3或4月
  * 奇怪 - 洋鬼子耶稣也懂中国农历节气
  Local ldSolarChunFeng, lnLunarChunFenY, lnLunarChunFenM, lnLunarChunFenD, llChunFenIsLeap
  Local lnDiffDays, ldSolar15
  ldSolarChunFeng = TtoD(GetTermDateTime(tnYear,6-1)) && 取得春分公历日期
  lnLunarChunFenY = Year (ldSolarChunFeng)
  lnLunarChunFenM = Month(ldSolarChunFeng)
  lnLunarChunFenD = Day  (ldSolarChunFeng)
  llChunFenIsLeap = .F.                               && 取得春分农历日期
  = GetLunarFromSolar( @lnLunarChunFenY, @lnLunarChunFenM, @lnLunarChunFenD, @llChunFenIsLeap )
  If lnLunarChunFenD > 0
   If lnLunarChunFenD < 15                             && 取得春分后下一个月圆的相差天数
    lnDiffDays = 15 - lnLunarChunFenD
   Else
    lnDiffDays = iif( llChunFenIsLeap, GetLunarLeapDays(lnLunarChunFenY), GetLunarMonthDays(lnLunarChunFenY,lnLunarChunFenM) ) - lnLunarChunFenD + 15
   Endif
   ldSolar15 = ldSolarChunFeng + lnDiffDays            && 取得春分后下一个月圆的公历日期
   ldRetu = ldSolar15 + 7 - Mod(DOW(ldSolar15,2),7)    && 取得月圆后的下一个星期日的日期
  Endif
 Endif
 Return ldRetu
Endfunc
*-------------------------------------------------
* 程序: 求某农历日是否节日
* 示例: ? GetLunarGalaName( 2003, 12, 30 )
*-------------------------------------------------
Function GetLunarGalaName( tnYear, tnMonth, tnDay, tlIsLeap )
 Local lcRetu, IsLeap, lnInfo, lcLunarInfo, lcLunarGala
 lcLunarInfo = []
 lcLunarGala = []
 lcRetu = []
 If Type([tnYear])=[N] and Type([tnMonth])=[N] and Type([tnDay])=[N]
  If Betw(tnYear,1,9999) and Betw(tnMonth,1,12) and Betw(tnDay,1,30)
   IsLeap = GetLunarleapMonth( tnYear ) = tnMonth
   tlIsLeap = iif(Type([tlIsLeap])=[L], tlIsLeap, .F.)
   If !IsLeap or !tlIsLeap
    * 非闰月节日
    lcLunarInfo = lcLunarInfo + [,0101,0103,0105,0106,0107,0109,0115,0126]
    lcLunarInfo = lcLunarInfo + [,0202,0208,0209,0213,0215,0219,0221]
    lcLunarInfo = lcLunarInfo + [,0303,0316,0323]
    lcLunarInfo = lcLunarInfo + [,0404,0408]
    lcLunarInfo = lcLunarInfo + [,0505,0513]
    lcLunarInfo = lcLunarInfo + [,0603,0613,0616,0619]
    lcLunarInfo = lcLunarInfo + [,0707,0713,0715,0724,0730]
    lcLunarInfo = lcLunarInfo + [,0815,0816,0822,0823,0828]
    lcLunarInfo = lcLunarInfo + [,0909,0919,0930]
    lcLunarInfo = lcLunarInfo + [,1005]
    lcLunarInfo = lcLunarInfo + [,1107]
    lcLunarInfo = lcLunarInfo + [,1208,1229,]
    lnInfo = at( Padl(allt(str(tnMonth)),2,[0]) + Padl(allt(str(tnDay)),2,[0]), lcLunarInfo )
    If lnInfo > 0
     lnInfo = occu( [,], left(lcLunarInfo,lnInfo) )
     lcLunarGala = lcLunarGala + [,春节.弥勒佛圣诞,车公诞(赤口),接财神,定光佛圣诞,人日,玉皇大帝圣诞,元宵节,观音开库]
     lcLunarGala = lcLunarGala + [,土地公诞,释迦牟尼佛出家,海空上师生日,洪圣诞,释迦牟尼佛涅槃,观世音菩萨圣诞(生日),普贤菩萨圣诞]
     lcLunarGala = lcLunarGala + [,北帝诞,准提菩萨圣诞,天后诞]
     lcLunarGala = lcLunarGala + [,文殊菩萨圣诞,释迦牟尼佛诞生、成道、涅槃]
     lcLunarGala = lcLunarGala + [,端午节,关帝诞辰.伽蓝菩萨圣诞]
     lcLunarGala = lcLunarGala + [,护法韦驮尊天菩萨圣诞,鲁班师傅诞,侯王诞,观世音菩萨成道]
     lcLunarGala = lcLunarGala + [,七夕乞巧节,大势至菩萨圣诞,中元普渡节.盂兰鬼节,龙树菩萨圣诞,地藏菩萨圣诞]
     lcLunarGala = lcLunarGala + [,中秋节,秀茂坪齐天大圣诞,黄大仙诞,燃灯佛圣诞,孔子诞]
     lcLunarGala = lcLunarGala + [,重阳节,观世音菩萨出家纪念日,药师琉璃光如来圣诞]
     lcLunarGala = lcLunarGala + [,达摩祖师圣诞]
     lcLunarGala = lcLunarGala + [,阿弥陀佛圣诞]
     lcLunarGala = lcLunarGala + [,释迦如来成道日,华严菩萨圣诞,]
     lnBeg = at( [,], lcLunarGala, lnInfo ) + 1
     lnEnd = at( [,], lcLunarGala, lnInfo + 1 )
     lcRetu = [.] + subs( lcLunarGala, lnBeg, lnEnd-lnBeg )
    Endif
   Endif
   If !IsLeap or (IsLeap and tlIsLeap)
    If tnMonth=12
     Do Case
      Case tnDay=8
       lcRetu = lcRetu + [.腊八节]
      Case tnDay=16
       lcRetu = lcRetu + [.尾禡]
      Case tnDay=28
       lcRetu = lcRetu + [.洗邋遢]
      Case tnDay=24
       lcRetu = lcRetu + [.小年.灶君节(还神日)]
      Case InList(tnDay,29,30)
       If GetLunarMonthDays( tnYear, tnMonth ) = tnDay
        lcRetu = lcRetu + [.除夕]
       Endif
     Endcase
    Endif
   Endif
  Endif
 Endif
 Return lcRetu
Endfunc
*-------------------------------------------------
* 程序: 求某年农历特征码数
* 示例: ? GetLunarInfo( 2003 )
*-------------------------------------------------
Function GetLunarInfo( tnYear )
 Local lnRetu
 lnRetu = 0
 tnYear = iif( Type([tnYear])=[N], tnYear, 0 )
 If Betw(tnYear,1900,2050)
  Local lcYearInfo, lnNum, lnBeg, lnEnd
  lcYearInfo = [,] ;
   + [0x04bd8,0x04ae0,0x0a570,0x054d5,0x0d260,0x0d950,0x16554,0x056a0,0x09ad0,0x055d2,] ;
   + [0x04ae0,0x0a5b6,0x0a4d0,0x0d250,0x1d255,0x0b540,0x0d6a0,0x0ada2,0x095b0,0x14977,] ;
   + [0x04970,0x0a4b0,0x0b4b5,0x06a50,0x06d40,0x1ab54,0x02b60,0x09570,0x052f2,0x04970,] ;
   + [0x06566,0x0d4a0,0x0ea50,0x06e95,0x05ad0,0x02b60,0x186e3,0x092e0,0x1c8d7,0x0c950,] ;
   + [0x0d4a0,0x1d8a6,0x0b550,0x056a0,0x1a5b4,0x025d0,0x092d0,0x0d2b2,0x0a950,0x0b557,] ;
   + [0x06ca0,0x0b550,0x15355,0x04da0,0x0a5d0,0x14573,0x052b0,0x0a9a8,0x0e950,0x06aa0,] ;
   + [0x0aea6,0x0ab50,0x04b60,0x0aae4,0x0a570,0x05260,0x0f263,0x0d950,0x05b57,0x056a0,] ;
   + [0x096d0,0x04dd5,0x04ad0,0x0a4d0,0x0d4d4,0x0d250,0x0d558,0x0b540,0x0b5a0,0x195a6,] ;
   + [0x095b0,0x049b0,0x0a974,0x0a4b0,0x0b27a,0x06a50,0x06d40,0x0af46,0x0ab60,0x09570,] ;
   + [0x04af5,0x04970,0x064b0,0x074a3,0x0ea50,0x06b58,0x055c0,0x0ab60,0x096d5,0x092e0,] ;
   + [0x0c960,0x0d954,0x0d4a0,0x0da50,0x07552,0x056a0,0x0abb7,0x025d0,0x092d0,0x0cab5,] ;
   + [0x0a950,0x0b4a0,0x0baa4,0x0ad50,0x055d9,0x04ba0,0x0a5b0,0x15176,0x052b0,0x0a930,] ;
   + [0x07954,0x06aa0,0x0ad50,0x05b52,0x04b60,0x0a6e6,0x0a4e0,0x0d260,0x0ea65,0x0d530,] ;
   + [0x05aa0,0x076a3,0x096d0,0x04bd7,0x04ad0,0x0a4d0,0x1d0b6,0x0d250,0x0d520,0x0dd45,] ;
   + [0x0b5a0,0x056d0,0x055b2,0x049b0,0x0a577,0x0a4b0,0x0aa50,0x1b255,0x06d20,0x0ada0,] ;
   + [0x14b63,]
  lnNum = tnYear - 1900 + 1
  lnBeg = at( [,], lcYearInfo, lnNum ) + 1
  lnEnd = at( [,], lcYearInfo, lnNum + 1 )
  lnRetu = EVALUATE( subs( lcYearInfo, lnBeg, lnEnd-lnBeg ) )
 Endif
 Return lnRetu
Endfunc
*-------------------------------------------------
* 程序: 根据 公历日期 求 年柱(以立春日期为界)
*       1900年 立春后为庚子年(60进制36)
* 示例: ? GetGanZhiYear( Date(2003,04,20) )
*-------------------------------------------------
Function GetGanZhiYear( tdDate )
 Local lnYear, lcLunarYear
 lcLunarYear = []
 If Type([tdDate])=[D] and !empt(tdDate)
  lnYear  = Year( tdDate)
  If tdDate < TtoD(GetTermDateTime(lnYear,3-1))
   lcLunarYear = GetLunarGanZhiName( lnYear-1900+36-1 )
  Else
   lcLunarYear = GetLunarGanZhiName( lnYear-1900+36 )
  Endif
 Endif
 Return lcLunarYear
Endfunc
*-------------------------------------------------
* 程序: 根据 公历日期 求 月柱 (以节气日期为界)
*       1900年01月 小寒以前为 丙子月(60进制12)
* 示例: ? GetGanZhiMonth( Date(2003,04,20) )
*-------------------------------------------------
Function GetGanZhiMonth( tdDate )
 Local lnYear, lnMonth, lcLunarMonth
 lcLunarMonth = []
 If Type([tdDate])=[D] and !empt(tdDate)
  lnYear  = Year( tdDate)
  lnMonth = Month(tdDate)
  If tdDate < TToD( GetTermDateTime( lnYear, (lnMonth-1)*2) )
   lcLunarMonth = GetLunarGanZhiName( (lnYear-1900)*12 + lnMonth + 11 )
  Else
   lcLunarMonth = GetLunarGanZhiName( (lnYear-1900)*12 + lnMonth + 12 )
  Endif
 Endif
 Return lcLunarMonth
Endfunc
*-------------------------------------------------
* 程序: 根据 公历日期 求 日柱
*       1900年01月01日 为甲戌日(60进制10)
* 示例: ? GetGanZhiDay( Date(2003,04,20) )
*-------------------------------------------------
Function GetGanZhiDay( tdDate )
 Local lcLunarDay
 lcLunarDay = []
 If Type([tdDate])=[D] and !empt(tdDate)
  lcLunarDay = GetLunarGanZhiName( tdDate - Date(1900,01,01) + 10 )
 Endif
 Return lcLunarDay
Endfunc
*-------------------------------------------------
* 程序: 根据 公历日期 求 节气
* 示例: ? GetLunarJieQi( Date(2003,04,20) )
*-------------------------------------------------
Function GetLunarJieQi( tdDate )
 Local lnYear, lnMonth, lcLunarJieQi
 lcLunarJieQi = []
 If Type([tdDate])=[D] and !empt(tdDate)
  lnYear  = Year( tdDate)
  lnMonth = Month(tdDate)
  If TToD( GetTermDateTime(lnYear,(lnMonth-1)*2) ) = tdDate
   lcLunarJieQi = GetLunarJieQiName((lnMonth-1)*2) + Time( GetTermDateTime(lnYear,(lnMonth-1)*2) )
  Else
   If TToD( GetTermDateTime(lnYear,(lnMonth-1)*2+1) ) = tdDate
    lcLunarJieQi = GetLunarJieQiName((lnMonth-1)*2+1) + Time( GetTermDateTime(lnYear,(lnMonth-1)*2+1) )
   Endif
  Endif
 Endif
 Return lcLunarJieQi
Endfunc
*-------------------------------------------------
* 程序: 求农历干支, 0=甲子
* 示例: ? GetLunarGanZhiName( 0 )
*-------------------------------------------------
Function GetLunarGanZhiName( tnNum )
 Return GetLunarGanName(Mod(tnNum,10)) + GetLunarZhiName(Mod(tnNum,12))
Endfunc
*-------------------------------------------------
* 程序: 求农历干支的 干
* 示例: ? GetLunarGanName( 1 )
*-------------------------------------------------
Function GetLunarGanName( tnGanNo )
 Local lcRetu
 lcRetu = []
 tnGanNo = iif( Type([tnGanNo])=[N], tnGanNo+1, 0 )
 If Betw(tnGanNo,1,10)
  Local lcGanInfo, lnBeg, lnEnd
  lcGanInfo = [,甲,乙,丙,丁,戊,己,庚,辛,壬,癸,]
  lnBeg = at( [,], lcGanInfo, tnGanNo ) + 1
  lnEnd = at( [,], lcGanInfo, tnGanNo + 1 )
  lcRetu = subs( lcGanInfo, lnBeg, lnEnd-lnBeg )
 Endif
 Return lcRetu
Endfunc
*-------------------------------------------------
* 程序: 求农历干支的 支
* 示例: ? GetLunarZhiName( 1 )
*-------------------------------------------------
Function GetLunarZhiName( tnZhiNo )
 Local lcRetu
 lcRetu = []
 tnZhiNo = iif( Type([tnZhiNo])=[N], tnZhiNo+1, 0 )
 If Betw(tnZhiNo,1,12)
  Local lcZhiInfo, lnBeg, lnEnd
  lcZhiInfo = [,子,丑,寅,卯,辰,巳,午,未,申,酉,戌,亥,]
  lnBeg = at( [,], lcZhiInfo, tnZhiNo ) + 1
  lnEnd = at( [,], lcZhiInfo, tnZhiNo + 1 )
  lcRetu = subs( lcZhiInfo, lnBeg, lnEnd-lnBeg )
 Endif
 Return lcRetu
Endfunc
*-------------------------------------------------
* 程序: 求农历属相
* 示例: ? GetLunarAniName( 1 )
*-------------------------------------------------
Function GetLunarAniName( tnAniNo )
 Local lcRetu
 lcRetu = []
 tnAniNo = iif( Type([tnAniNo])=[N], tnAniNo+1, 0 )
 If Betw(tnAniNo,1,12)
  Local lcAniInfo, lnBeg, lnEnd
  lcAniInfo = [,鼠,牛,虎,兔,龙,蛇,马,羊,猴,鸡,狗,猪,]
  lnBeg = at( [,], lcAniInfo, tnAniNo ) + 1
  lnEnd = at( [,], lcAniInfo, tnAniNo + 1 )
  lcRetu = subs( lcAniInfo, lnBeg, lnEnd-lnBeg )
 Endif
 Return lcRetu
Endfunc
*-------------------------------------------------
* 程序: 求农历节气
* 示例: ? GetLunarJieQiName( 0 )
*-------------------------------------------------
Function GetLunarJieQiName( tnJieNo )
 Local lcRetu
 lcRetu = []
 tnJieNo = iif( Type([tnJieNo])=[N], tnJieNo+1, 0 )
 If Betw(tnJieNo,1,24)
  Local lcJieInfo, lnBeg, lnEnd
  lcJieInfo = [,小寒,大寒,立春,雨水,惊蛰,春分,清明,谷雨,立夏,小满,芒种,夏至,小暑,大暑,立秋,处暑,白露,秋分,寒露,霜降,立冬,小雪,大雪,冬至,]
  lnBeg = at( [,], lcJieInfo, tnJieNo ) + 1
  lnEnd = at( [,], lcJieInfo, tnJieNo + 1 )
  lcRetu = subs( lcJieInfo, lnBeg, lnEnd-lnBeg )
 Endif
 Return lcRetu
Endfunc
*-------------------------------------------------
* 程序: 某年的第 N 个节气的公历日期(从0小寒起算)
* 示例: ? GetTermDateTime( 2003, 2 ) && 立春公历日期时间
*-------------------------------------------------
Function GetTermDateTime( tnYear, tnTerm )
 Return Datetime(1900,1,6,2,5,0) + (31556925974.7*(tnYear-1900)+GetLunarTermInfo(tnTerm)*60000)/1000
Endfunc
*-------------------------------------------------
* 程序: 农历年的第N个节气为几日(从0小寒起算)
* 示例: ? GetLunarTermInfo( 2 )
*-------------------------------------------------
Function GetLunarTermInfo( tnTermNo )
 Local lnRetu
 lnRetu = []
 tnTermNo = iif( Type([tnTermNo])=[N], tnTermNo+1, 0 )
 If Betw(tnTermNo,1,24)
  Local lcTermInfo, lnBeg, lnEnd
  lcTermInfo = [,0,21208,42467,63836,85337,107014,128867,150921,173149,195551,218072,240693,263343,285989,308563,331033,353350,375494,397447,419210,440795,462224,483532,504758,]
  lnBeg = at( [,], lcTermInfo, tnTermNo ) + 1
  lnEnd = at( [,], lcTermInfo, tnTermNo + 1 )
  lnRetu = Val( subs( lcTermInfo, lnBeg, lnEnd-lnBeg ) )
 Endif
 Return lnRetu
Endfunc
*-------------------------------------------------
* 程序: 求农历中文日期
* 示例: ? GetLunarDayName( 1 )
*-------------------------------------------------
Function GetLunarDayName( tnDay1No )
 Local lcRetu
 lcRetu = []
 tnDay1No = iif( Type([tnDay1No])=[N], tnDay1No, 0 )
 If Betw(tnDay1No,1,30)
  Local lcDay1Info, lnBeg, lnEnd
  lcDay1Info = [,初一,初二,初三,初四,初五,初六,初七,初八,初九,初十,十一,十二,十三,十四,十五] ;
   + [,十六,十七,十八,十九,二十,廿一,廿二,廿三,廿四,廿五,廿六,廿七,廿八,廿九,三十,]
  lnBeg = at( [,], lcDay1Info, tnDay1No ) + 1
  lnEnd = at( [,], lcDay1Info, tnDay1No + 1 )
  lcRetu = subs( lcDay1Info, lnBeg, lnEnd-lnBeg )
 Endif
 Return lcRetu
Endfunc
*-------------------------------------------------
* 程序: 求农历中文月份
* 示例: ? GetLunarMonthName( 1 )
*-------------------------------------------------
Function GetLunarMonthName( tnMonthNo )
 Local lcRetu
 lcRetu = []
 tnMonthNo = iif( Type([tnMonthNo])=[N], tnMonthNo, 0 )
 If Betw(tnMonthNo,1,12)
  Local lcMonthInfo, lnBeg, lnEnd
  lcMonthInfo = [,元,二,三,四,五,六,七,八,九,十,冬,腊,]
  lnBeg = at( [,], lcMonthInfo, tnMonthNo ) + 1
  lnEnd = at( [,], lcMonthInfo, tnMonthNo + 1 )
  lcRetu = subs( lcMonthInfo, lnBeg, lnEnd-lnBeg )
 Endif
 Return lcRetu
Endfunc
*-------------------------------------------------
* 程序: 求英文月份
* 示例: ? GetEnglishMonthName( 1 )
*-------------------------------------------------
Function GetEnglishMonthName( tnMonthNo, tlIsShort )
 Local lcRetu
 lcRetu = []
 tnMonthNo = iif( Type([tnMonthNo])=[N], tnMonthNo, 0 )
 tlIsShort = iif( Type([tlIsShort])=[L], tlIsShort, .F. )
 If Betw(tnMonthNo,1,12)
  Local lcMonthInfo, lnBeg, lnEnd
  lcMonthInfo = [,January,February,March,April,May,June,July,August,September,October,November,December,]
  lnBeg = at( [,], lcMonthInfo, tnMonthNo ) + 1
  lnEnd = at( [,], lcMonthInfo, tnMonthNo + 1 )
  lcRetu = subs( lcMonthInfo, lnBeg, lnEnd-lnBeg )
  If tlIsShort
   lcRetu = left(lcRetu,3)
  Endif
 Endif
 Return lcRetu
Endfunc
*-------------------------------------------------
* 程序: 求公历中文 年.月.日.星期 汉字
* 示例: ? GetChineseDateName( 1 )
*-------------------------------------------------
Function GetChineseDateName( tnDay0No )
 Local lcRetu
 lcRetu = []
 tnDay0No = iif( Type([tnDay0No])=[N], tnDay0No, 0 )
 If Betw(tnDay0No,1,11)
  Local lcDay0Info, lnBeg, lnEnd
  lcDay0Info = [,一,二,三,四,五,六,七,八,九,十,日,]
  lnBeg = at( [,], lcDay0Info, tnDay0No ) + 1
  lnEnd = at( [,], lcDay0Info, tnDay0No + 1 )
  lcRetu = subs( lcDay0Info, lnBeg, lnEnd-lnBeg )
 Endif
 Return lcRetu
Endfunc
*-------------------------------------------------
* 程序: 求农历 Y 年的总天数
* 示例: ? GetLunarYearDays( 2003 )
*-------------------------------------------------
Function GetLunarYearDays( tnYear )
 Local lnRetu, lnTemp, lnInfo, lnI
 lnRetu = 348
 For lnI = 1 To 12
  lnTemp = 0x8 * 2^(12-lnI+1)
  lnInfo = GetlunarInfo(tnYear)
  lnRetu = lnRetu + iif( bitor(lnInfo, lnTemp)=lnInfo, 1, 0 )
 Endfor
 Return lnRetu + GetLunarLeapDays(tnYear)
Endfunc
*-------------------------------------------------
* 程序: 求农历 Y 年闰月的天数
* 示例: ? GetLunarLeapDays( 2003 )
*-------------------------------------------------
Function GetLunarLeapDays( tnYear )
 Local lnRetu, lnInfo
 lnRetu = 0
 If GetLunarleapMonth(tnYear) > 0
  lnInfo = GetlunarInfo(tnYear)
  lnRetu = iif( bitor(lnInfo, 0x10000)=lnInfo, 30, 29 )
 Endif
 Return lnRetu
Endfunc
*-------------------------------------------------
* 程序: 求农历 Y 年 M 月的总天数
* 示例: ? GetLunarMonthDays( 2003, 10 )
*-------------------------------------------------
Function GetLunarMonthDays( tnYear, tnMonth )
 Local lnRetu, lnTemp, lnInfo
 lnRetu = 0
 lnTemp = 0x8 * 2^(12-tnMonth+1)
 lnInfo = GetlunarInfo(tnYear)
 Return iif( bitor(lnInfo, lnTemp)=lnInfo, 30, 29 )
Endfunc
*-------------------------------------------------
* 程序: 求农历 Y 年闰哪个月 1-12 , 没闰返回 0
* 示例: ? GetLunarleapMonth( 2003 )
*-------------------------------------------------
Function GetLunarleapMonth( tnYear )
 Local lnInfo
 lnInfo = GetlunarInfo(tnYear)
 Return bitand( lnInfo, 0xF )
Endfunc
*-------------------------------------------------
* 程序: 由农历算出公历
* 示例: ? GetSolarFromLunar( 2003, 06, 05, .F. )
*-------------------------------------------------
Function GetSolarFromLunar( tnYear, tnMonth, tnDay, tlLeap )
 Local ldRetu
 ldRetu = CToD([])
 If Type([tnYear])=[N] and Type([tnMonth])=[N] and Type([tnDay])=[N]
  If Betw(tnYear,1900,2050) and Betw(tnMonth,1,12) and Betw(tnDay,1,30)
   Local IsLeap, lnDiffDays, liYear, liMonth
   tlLeap = iif(Type([tlLeap])=[L], tlLeap, .F.)
   IsLeap = GetLunarleapMonth( tnYear ) = tnMonth
   tlLeap = IsLeap and tlLeap
   lnDiffDays = 0
   If tnYear > 1900           && 农历以前年份距 1900.01.01 总天数
    For liYear = 1900 To tnYear - 1
     lnDiffDays = lnDiffDays + GetLunarYearDays( liYear )
    Endfor
   Endif
   If tnMonth = 1 and tlLeap  && 当月为闰元月
    lnDiffDays = lnDiffDays + GetLunarMonthDays( tnYear, 1 )
   Else
    If tnMonth > 1         && 农历当年以前月份距 当年1月1日 总天数
     For liMonth = 1 To iif(tlLeap, tnMonth, tnMonth-1 )
      lnDiffDays = lnDiffDays + GetLunarMonthDays( tnYear, liMonth )
     Endfor
    Endif
    If Betw( GetLunarleapMonth(tnYear), 1, tnMonth-1 )
     * 农历当年以前月份有闰月
     lnDiffDays = lnDiffDays + GetLunarLeapDays( tnYear )
    Endif
   Endif
   lnDiffDays = lnDiffDays + tnDay - 1
   * 农历 1900.01.01 = 公历 1900.01.31
   ldRetu = Date(1900,01,31) + lnDiffDays
  Endif
 Endif
 Return ldRetu
Endfunc
*-------------------------------------------------
* 程序: 由公历算出农历
* 示例:
* ldDate  = Date(2003,10,01)
* lnYear  = Year (ldDate)
* lnMonth = Month(ldDate)
* lnDay   = Day  (ldDate)
* lIsLeap = .F.
* If GetLunarFromSolar( @lnYear, @lnMonth, @lnDay, @lIsLeap )
*  ? [公历:] + DToC(ldDate) + [ -> 农历:] ;
*   + padl(allt(str(lnYear)),4,[0]) +[.]+ padl(allt(str(lnMonth)),2,[0]) +[.]+ padl(allt(str(lnDay)),2,[0]) ;
*   + iif(lIsLeap,[(闰)],[])
* Endif
*-------------------------------------------------
Function GetLunarFromSolar( tnYear, tnMonth, tnDay, tlLeap )
 Local liYear, liMonth, lnLeap, lnTemp, lnDays
 lnLeap = 0
 lnTemp = 0
 lnDays = Date(tnYear, tnMonth, tnDay) - Date(1900,01,31)
 liYear = 1900
 Do While liYear<2050 and lnDays > 0
  lnTemp = GetLunarYearDays(liYear)
  lnDays = lnDays - lnTemp
  liYear = liYear + 1
 Enddo
 If lnDays < 0
  lnDays = lnDays + lnTemp
  liYear = liYear - 1
 Endif
 lnLeap = GetLunarleapMonth(liYear) && 闰哪个月
 tlLeap = .F.
 liMonth = 1
 Do While liMonth<13 and lnDays > 0
  * 闰月
  If lnLeap>0 and liMonth=lnLeap+1 and !tlLeap
   liMonth = liMonth - 1
   tlLeap = .T.
   lnTemp = GetLunarLeapDays(liYear)
  Else
   lnTemp = GetLunarMonthDays(liYear, liMonth)
  Endif
  If tlLeap and liMonth=lnLeap+1
   tlLeap = .F. && 解除闰月
  Endif
  lnDays = lnDays - lnTemp
  liMonth = liMonth + 1
 Enddo
 If lnDays=0 and lnLeap>0 and liMonth=lnLeap+1
  If tlLeap
   tlLeap = .F.
  Else
   tlLeap = .T.
   liMonth = liMonth - 1
  Endif
 Endif
 If lnDays < 0
  lnDays = lnDays + lnTemp
  liMonth = liMonth - 1
 Endif
 tnYear  = iif( Betw(liMonth,1,12), liYear,   0 )
 tnMonth = iif( Betw(liMonth,1,12), liMonth,  0 )
 tnDay   = iif( Betw(liMonth,1,12), lnDays+1, 0 )
 Return Betw(liMonth,1,12)
Endfunc
*-------------------------------------------------
* 程序: 求公历某日西洋星座
* 示例: ? GetSolarStarName( Date(2003,10,31) )
*-----------------------------------------------------
Function GetSolarStarName( tdDate )
 Local lcRetn, lnMonth, lnDay
 lcRetn = []
 If Type([tdDate])=[D] and !empt(tdDate)
  lnMonth = Month(tdDate)
  lnDay   = Day(  tdDate)
  Do Case
   Case (lnMonth=12 and lnDay>20) or (lnMonth=01 and lnDay<20)
    lcRetn = [山羊座]
   Case (lnMonth=01 and lnDay>19) or (lnMonth=02 and lnDay<19)
    lcRetn = [水瓶座]
   Case (lnMonth=02 and lnDay>18) or (lnMonth=03 and lnDay<21)
    lcRetn = [双鱼座]
   Case (lnMonth=03 and lnDay>20) or (lnMonth=04 and lnDay<21)
    lcRetn = [白羊座]
   Case (lnMonth=04 and lnDay>20) or (lnMonth=05 and lnDay<21)
    lcRetn = [金牛座]
   Case (lnMonth=05 and lnDay>20) or (lnMonth=06 and lnDay<21)
    lcRetn = [双子座]
   Case (lnMonth=06 and lnDay>20) or (lnMonth=07 and lnDay<21)
    lcRetn = [天蟹座]
   Case (lnMonth=07 and lnDay>20) or (lnMonth=08 and lnDay<22)
    lcRetn = [狮子座]
   Case (lnMonth=08 and lnDay>21) or (lnMonth=09 and lnDay<23)
    lcRetn = [处女座]
   Case (lnMonth=09 and lnDay>22) or (lnMonth=10 and lnDay<23)
    lcRetn = [天秤座]
   Case (lnMonth=10 and lnDay>22) or (lnMonth=11 and lnDay<23)
    lcRetn = [天蝎座]
   Case (lnMonth=11 and lnDay>22) or (lnMonth=12 and lnDay<21)
    lcRetn = [人马座]
  Endcase
 Endif
 Retu lcRetn
Endfunc
*-------------------------------------------------
* 程序: 求公历某日所在月的天数
* 示例: ? [本月共 ], GetSolarMonthDays( date() ), [ 天]
*-----------------------------------------------------
Function GetSolarMonthDays( lpDdate )
 lpDdate = iif(Type([lpDdate])$[DT],lpDdate,date())
 Return GoMonth(lpDdate,1)-lpDdate
Endfunc
*-------------------------------------------------
* 程序: 求公历某日所在月的最后一天
* 示例: ? [本月最后一天 ], GetSolarMonthLastDate( date() )
*-----------------------------------------------------
Function GetSolarMonthLastDate( lpDdate )
 Local lnThisY, lnThisM, lnNextY, lnNextM
 lpDdate = iif(Type([lpDdate])$[DT],lpDdate,date())
 lnThisY = Year (lpDdate) && 本月年份
 lnThisM = Month(lpDdate) && 本月月份
 lnNextY = IIF( lnThisM=12, lnThisY+1, lnThisY ) && 下月年份
 lnNextM = IIF( lnThisM=12, 01, lnThisM+1 )      && 下月月份
 Return Date(lnNextY, lnNextM, 01)-1
Endfunc
*-----------------------------------------------------
* 程序: 求公历某日上个月的最后一天
* 示例: ? [上月最后一天 ], GetSolarMonthPassDate( date() )
*-----------------------------------------------------
Function GetSolarMonthPassDate( lpDdate )
 lpDdate = iif(Type([lpDdate])$[DT],lpDdate,date())
 Local lnThisY, lnThisM
 lnThisY = Year (lpDdate) && 本月年份
 lnThisM = Month(lpDdate) && 本月月份
 Return Date(lnThisY, lnThisM, 01)-1
Endfunc
*-----------------------------------------------------
* 程序: 求公历某年某月第几个星期几的日期
* 参数: 1、tcYYYYMM  - 公元年月([200310])
*       2、tnNumWeek - 该月第几个星期
*          其中: 1,2,3,4,5 表示顺数第 1,2,3,4,5 个星期
*                6,7,8,9,0 表示倒数第 1,2,3,4,5 个星期
*       3、tnWeekDay - 星期几(1-7)(其中7=星期日)
* 示例: ? [2003年感恩节:], GetDateFromYMandWeekNo([200311],4,4)
*-----------------------------------------------------
Function GetDateFromYMandWeekNo( tcYYYYMM, tnNumWeek, tnWeekDay )
 Local ldRetuDate, ldFirstDate, ldLastDate, lnDiffDay
 ldRetuDate = CToD([])
 If Type([tcYYYYMM])=[C] and Type([tnNumWeek])=[N] and Type([tnWeekDay])=[N]
  If Betw(tnWeekDay,1,7)
   ldFirstDate = CToD(subs(tcYYYYMM,1,4)+[.]+subs(tcYYYYMM,5,2)+[.01])
   ldLastDate  = GoMonth( ldFirstDate,1) - Day(ldFirstDate)
   If InList(tnNumWeek,1,2,3,4,5)
    lnDiffDay = tnWeekDay - DOW(ldFirstDate,2)
    lnDiffDay = iif(lnDiffDay<0, 7+lnDiffDay, lnDiffDay)
    ldRetuDate = ldFirstDate + (tnNumWeek - 1) * 7 + lnDiffDay
   Endif
   If InList(tnNumWeek,6,7,8,9,0)
    tnNumWeek = iif(tnNumWeek=0,10,tnNumWeek) - 5
    lnDiffDay = DOW(ldLastDate,2) - tnWeekDay
    lnDiffDay = iif(lnDiffDay<0, 7+lnDiffDay, lnDiffDay)
    ldRetuDate = ldLastDate - (tnNumWeek - 1) * 7 - lnDiffDay
   Endif
   ldRetuDate = iif( left(DToS(ldRetuDate),6)#tcYYYYMM, CToD([]), ldRetuDate )
  Endif
 Endif
 Return ldRetuDate
ENDFUNC

PROCEDURE calcboard
con=odbc(pk)
con1=odbc(6)
mday=DATE()-CTOD(ALLTRIM(STR(YEAR(DATE())))+'.01.01')
P_USERNAME='鲁红斌'
&&xx=ALLTRIM(THISFORM.cmbjsc.DISPLAYVALUE)&&+'.'+ALLTRIM(THISFORM.cmblink.DISPLAYVALUE)+'.'+ALLTRIM(THISFORM.cmbdetail.DISPLAYVALUE)
XX='主驾驶舱'
*!*		SQLEXEC(CON,"DROP VIEW LHB")
*!*		IF SQLEXEC(CON,"CREATE VIEW LHB AS SELECT COPMA.MA001, COPMA.MA002,COPMA.MA028, CASE WHEN COPTDa.TD001 IS NOT NULL THEN COPTDa.TD001 WHEN COPTDb.TD001 IS NOT NULL "+;
*!*	        " THEN COPTDb.TD001 END AS TD001, CASE WHEN COPTDa.TD002 IS NOT NULL THEN COPTDa.TD002 WHEN COPTDb.TD002 IS NOT NULL  "+;
*!*	        " THEN COPTDb.TD002 END AS TD002, CASE WHEN COPTDa.TD003 IS NOT NULL THEN COPTDa.TD003 WHEN COPTDb.TD003 IS NOT NULL  "+;
*!*	        " THEN COPTDb.TD003 END AS TD003, RTRIM(dbo.ACRTB.TB039) TB039, RTRIM(dbo.INVMB.MB002) MB002, RTRIM(dbo.INVMB.MB003) MB003, CASE WHEN COPTDa.TD008 IS NOT NULL  "+;
*!*	        " THEN COPTDa.TD008 WHEN COPTDb.TD008 IS NOT NULL THEN COPTDb.TD008 END AS TD008, CASE WHEN COPTHa.TH008 IS NOT NULL  "+;
*!*	        " THEN COPTHa.TH008 WHEN COPTHb.TH008 IS NOT NULL THEN COPTHb.TH008 END AS TH008,  "+;
*!*	        " CASE TA079 WHEN '1' THEN ACRTB.TB022 WHEN '2' THEN ACRTB.TB022 * - 1 END AS TB022, dbo.ACRTB.TB023,  "+;
*!*	        " CASE WHEN INVLAa.LA012 IS NOT NULL THEN INVLAa.LA012 WHEN INVLAb.LA012 IS NOT NULL THEN INVLAb.LA012 END AS LA012,  "+;
*!*	         " CASE TA079 WHEN '1' THEN ACRTB.TB019 WHEN '2' THEN ACRTB.TB019 * - 1 END AS TB019, "+;
*!*	         "CASE ACRTA.TA079 WHEN '1' THEN ACRTB.TB019+ACRTB.TB020 WHEN '2' THEN (ACRTB.TB019+ACRTB.TB020) * - 1 END AS TB020,CASE WHEN TA079 = '1' AND  "+;
*!*	          "  INVLAa.LA012 IS NOT NULL THEN ACRTB.TB022 * INVLAa.LA012 WHEN TA079 = '1' AND INVLAb.LA012 IS NOT NULL  "+;
*!*	          "  THEN ACRTB.TB022 * INVLAb.LA012 WHEN TA079 = '2' AND INVLAa.LA012 IS NOT NULL  "+;
*!*	            "  THEN ACRTB.TB022 * INVLAa.LA012 * - 1 WHEN TA079 = '2' AND INVLAb.LA012 IS NOT NULL THEN ACRTB.TB022 * INVLAb.LA012 * - 1 END AS XHCB,  "+;
*!*	          " CASE WHEN TA079 = '1' AND INVLAa.LA012 IS NOT NULL THEN ACRTB.TB019 - INVLAa.LA012 * ACRTB.TB022 WHEN TA079 = '1' AND  "+;
*!*	           " INVLAb.LA012 IS NOT NULL THEN ACRTB.TB019 - INVLAb.LA012 * ACRTB.TB022 WHEN TA079 = '2' AND INVLAa.LA012 IS NOT NULL  "+;
*!*	          " THEN (ACRTB.TB019 - INVLAa.LA012 * ACRTB.TB022) * - 1 WHEN TA079 = '2' AND INVLAb.LA012 IS NOT NULL  "+;
*!*	           " THEN (ACRTB.TB019 - INVLAb.LA012 * ACRTB.TB022) * - 1 END AS MLR, dbo.ACRTA.TA003, dbo.ACRTB.TB001,  CMSME.ME001, CMSME.ME002, "+;
*!*	           "  CMSMV.MV001, CMSMV.MV002,RTRIM(dbo.ACRTB.TB005)+ RTRIM(dbo.ACRTB.TB006) + '-' + dbo.ACRTB.TB007 AS COH,COPTC.TC003,COPTDa.TD038,COPTDa.TD039,C.MR003 AREA,D.MR003 COUNTRY "+;
*!*	           ",TC001,RTRIM(TC001)+TC002 AS TC002,TB005 AS SB001,RTRIM(TB005)+TB006 AS SB002,RTRIM(TB001)+TB002 AS TB002,MA5.MA002+' '+MA5.MA003 AS KJFL, MA6.MA002+' '+MA6.MA003 AS SPFL,"+;
*!*	           "MA7.MA002+' '+MA7.MA003 AS CPXL,MA8.MA002+' '+MA8.MA003 AS YS,TG003,TA009,"+;
*!*	           "(MB057+MB058+MB059+MB060)*TB022 AS BZCB,CASE TA079 WHEN '1' THEN ACRTB.TB017 WHEN '2' THEN ACRTB.TB017 * - 1  END AS TB018,COPTHa.TH007,ACRTA.TA001  "+;
*!*			 " FROM   dbo.ACRTB LEFT OUTER JOIN "+;
*!*	           " dbo.ACRTA ON dbo.ACRTB.TB001 = dbo.ACRTA.TA001 AND dbo.ACRTB.TB002 = dbo.ACRTA.TA002 LEFT OUTER JOIN "+;
*!*	           "  dbo.INVMB ON dbo.INVMB.MB001 = dbo.ACRTB.TB039 LEFT OUTER JOIN "+;
*!*	            " dbo.CMSME AS CMSME ON CMSME.ME001 = dbo.ACRTA.TA070 LEFT OUTER JOIN "+;
*!*	             " dbo.CMSMV AS CMSMV ON CMSMV.MV001 = dbo.ACRTA.TA005 LEFT OUTER JOIN "+;
*!*	              " dbo.COPMA AS COPMA ON COPMA.MA001 = dbo.ACRTA.TA004 LEFT OUTER JOIN "+;
*!*			" dbo.CMSMR C ON C.MR001 = '3' AND C.MR002 = COPMA.MA018 LEFT OUTER JOIN dbo.CMSMR D ON D.MR001 = '4' AND D.MR002 = COPMA.MA019 LEFT OUTER JOIN "+;   
*!*	      "  dbo.COPTJ AS COPTJ ON dbo.ACRTB.TB005 = COPTJ.TJ001 AND dbo.ACRTB.TB006 = COPTJ.TJ002 AND  "+;
*!*	            " dbo.ACRTB.TB007 = COPTJ.TJ003 LEFT OUTER JOIN "+;
*!*	            " dbo.COPTH AS COPTHa ON dbo.ACRTB.TB005 = COPTHa.TH001 AND dbo.ACRTB.TB006 = COPTHa.TH002 AND  "+;
*!*	             " dbo.ACRTB.TB007 = COPTHa.TH003 LEFT OUTER JOIN "+;
*!*	              "  dbo.COPTH AS COPTHb ON COPTJ.TJ015 = COPTHb.TH001 AND COPTJ.TJ016 = COPTHb.TH002 AND COPTJ.TJ017 = COPTHb.TH003 LEFT OUTER JOIN "+;
*!*	               " dbo.COPTD AS COPTDa ON COPTHa.TH014 = COPTDa.TD001 AND COPTHa.TH015 = COPTDa.TD002 AND  "+;
*!*	              "  COPTHa.TH016 = COPTDa.TD003 LEFT OUTER JOIN "+;
*!*	              " dbo.COPTD AS COPTDb ON COPTHb.TH014 = COPTDb.TD001 AND COPTHb.TH015 = COPTDb.TD002 AND  "+;
*!*	              " COPTHb.TH016 = COPTDb.TD003 LEFT OUTER JOIN"+;
*!*	             " dbo.INVLA AS INVLAa ON COPTHa.TH001 = INVLAa.LA006 AND COPTHa.TH002 = INVLAa.LA007 AND COPTHa.TH003 = INVLAa.LA008 LEFT OUTER JOIN "+;
*!*	              "  dbo.INVLA AS INVLAb ON COPTJ.TJ001 = INVLAb.LA006 AND COPTJ.TJ002 = INVLAb.LA007 AND COPTJ.TJ003 = INVLAb.LA008 LEFT JOIN COPTG ON COPTHa.TH001=TG001 AND COPTHa.TH002=TG002 "+;
*!*	              " LEFT JOIN COPTC AS COPTC ON COPTDa.TD001=COPTC.TC001 AND  COPTDa.TD002=COPTC.TC002  LEFT JOIN  INVMA AS  MA5 ON MB005=MA5.MA002 AND  MA5.MA001='1'  "+;
*!*	              " LEFT JOIN  INVMA AS  MA6 ON MB006=MA6.MA002 AND  MA6.MA001='2'  LEFT JOIN  INVMA AS  MA7 ON MB007=MA7.MA002 and MA7.MA001='3'   LEFT JOIN  INVMA AS  MA8 ON MB008=MA8.MA002 AND  MA8.MA001='4'  "+;
*!*				 " WHERE  dbo.ACRTB.TB012<>'V'")<0
*!*				 WAIT WINDOWS '??驾驶舱?'  &&AND  MA8.MA001='2'AND  MA7.MA001='2' AND  MA5.MA001='2'  
*!*			ENDIF	
*!*		
XXXX=DTOC(DATE(),1)
MYEAR=SUBSTR(XXXX,1,4)
MMONTH=SUBSTR(XXXX,1,6)
XXXX1=DTOC(GOMONTH(DATE(),-12),1)
MYEAR1=SUBSTR(XXXX1,1,4)
MMONTH1=SUBSTR(XXXX1,1,6)
		XF=SUBSTR(MMONTH,5,2)

DO CASE
	CASE XX='主驾驶舱'
************主营业务利润率
		SQLEXEC(CON,"SELECT sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND "+;
		"left(LE001,3) like '51[012]' and LE005='2'  ","TMP")
		IF ISNULL(XDS) OR RECCOUNT()<1
			QC=0
		ELSE
			QC=XDS
		ENDIF	
		IF sqlexec(con,"SELECT  SUM( (TB004*TB007))  AS 本期 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE  left(TB005,3) like '51[012]'  AND TB001='920' AND TB002<=?xxxx AND LEFT(TB002,4)=?MYEAR","TmpGroupData1")<0
			WAIT WINDOWS 'DFDS驾驶舱' 
			RETURN
		ENDIF&&		
		IF ISNULL(本期) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=本期 	
		ENDIF	

		m业务利润=QC+CCD
		SQLEXEC(CON,"SELECT sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND "+;
		"left(LE001,3) like '51[012]' and LE005='2'  ","TMP")
		IF ISNULL(XDS) OR RECCOUNT()<1
			QC=0
		ELSE
			QC=XDS
		ENDIF	
		IF sqlexec(con,"SELECT SUM((TB004*TB007)) AS 本期 "+;
		      " FROM ACTTB LEFT JOIN ACTTA ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002 "+;
		      " WHERE left(TB005,3) like '51[012]'  AND TB001='920' AND TB002<=?xxxx1 AND LEFT(TB002,4)=?MYEAR1","TmpGroupData1")<0
			WAIT WINDOWS 'D驾驶舱FDS1' 
			RETURN
		ENDIF&&		
		IF ISNULL(本期) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=本期 	
		ENDIF	

		m业务利润1=QC+CCD
************主营业务

		SQLEXEC(CON,"SELECT sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND "+;
		"left(LE001,3)='510' and LE005='2'  ","TMP")
		IF ISNULL(XDS) OR RECCOUNT()<1
			QC=0
		ELSE
			QC=XDS
		ENDIF	
		IF sqlexec(con,"SELECT  SUM( (TB004*TB007))  AS 本期 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE  left(TB005,3) ='510'  AND TB001='920' AND TB002<=?xxxx AND LEFT(TB002,4)=?MYEAR","TmpGroupData1")<0
			WAIT WINDOWS 'DF驾驶舱DS' 
			RETURN
		ENDIF&&		
		IF ISNULL(本期) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=本期 	
		ENDIF	
		m主营业务=QC+CCD
		SQLEXEC(CON,"SELECT sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND "+;
		"left(LE001,3)='510' and LE005='2'  ","TMP")
		IF ISNULL(XDS) OR RECCOUNT()<1
			QC=0
		ELSE
			QC=XDS
		ENDIF	
		IF sqlexec(con,"SELECT  SUM( (TB004*TB007))  AS 本期 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE  left(TB005,3) ='510'  AND TB001='920' AND TB002<=?xxxx1 AND LEFT(TB002,4)=?MYEAR1","TmpGroupData1")<0
			WAIT WINDOWS 'DFD驾驶舱S' 
			RETURN
		ENDIF&&		
		IF ISNULL(本期) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=本期 	
		ENDIF	

		m主营业务1=QC+CCD

		lrl=m业务利润/m主营业务
		lrl1=m业务利润1/m主营业务1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='主营业务利润率' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?lrl,creatdate=getdate(),preval=?lrl1 where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'主营业务利润率',?lrl,getdate(),?P_USERNAME,?pk)")
		ENDIF
	
************所有者权益
		SQLEXEC(CON,"SELECT SUM(-1 *(LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND left(LE001,1)= '3' ","TMP")
		QC=XDS
		IF sqlexec(con,"SELECT  SUM((case when left(TB005,1) in (1,4) then 1 else -1 end)*(TB004*TB007))  AS 本期 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE  left(TB005 ,1) = '3'  AND TB002<=?xxxx AND LEFT(TB002,4)=?MYEAR","TmpGroupData1")<0
			WAIT WINDOWS 'DFDS  驾驶舱' 
			RETURN
		ENDIF&&		
		IF ISNULL(本期) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=本期 	
		ENDIF	
		m所有者权益=QC+CCD/2
		m所有者权=QC+CCD
		m所有=QC
		SQLEXEC(CON,"SELECT SUM( -1*(LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR1  AND LE003='00' AND left(LE001,1)= '3'")
		QC=XDS
		
		IF sqlexec(con,"SELECT  SUM((case when left(TB005,1) in (1,4) then 1 else -1 end)*(TB004*TB007))  AS 本期 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE  left(TB005 ,1) = '3'   AND TB002<=?xxxx1 AND LEFT(TB002,4)=?MYEAR1","TmpGroupData1")<0

			WAIT WINDOWS '驾驶舱   DFDS' 
			RETURN
		ENDIF&&		
		IF ISNULL(本期) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=本期 	
		ENDIF	
		m所有者权益1=QC+CCD/2
		m所有者权1=QC+CCD
		m所有1=QC

		SQLEXEC(CON1,"SELECT getval,preval from dashboard  where name=?xx and keydate='所有者权益'  AND odbc=?pk","TMP")
		cc=m所有者权益
		dd=m所有者权益1
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='所有者权益'  AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?m所有者权,creatdate=getdate(),preval=?m所有者权1 where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'所有者权益',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF
************资本保值增值率

		SQLEXEC(CON1,"SELECT getval,preval from dashboard  where name=?xx and keydate='资本保值增值率'  AND odbc=?pk ","TMP")
		cc=m所有者权/m所有
		dd=m所有者权1/m所有1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='资本保值增值率'  AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'资本保值增值率',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF
************资本积累率

		SQLEXEC(CON1,"SELECT getval,preval from dashboard  where name=?xx and keydate='资本积累率'  AND odbc=?pk","TMP")
		cc=(m所有者权-m所有)/m所有
		dd=(m所有者权1-m所有1)/m所有1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='资本积累率'  AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'资本积累率',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF

************净资产收益率

		SQLEXEC(CON1,"SELECT getval,preval from dashboard  where name=?xx and keydate='本年毛利'  AND odbc=?pk","TMP")
		cc=getval/m所有者权益
		dd=preval/m所有者权益1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='净资产收益率'  AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'净资产收益率',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF
************利润总额
		SQLEXEC(CON,"SELECT sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND "+;
		"left(LE001,1)='5' AND LE005='2' and left(LE001,4)<>'5241'  ","TMP")
		IF ISNULL(XDS) OR RECCOUNT()<1
			QC=0
		ELSE
			QC=XDS
		ENDIF	
		IF sqlexec(con,"SELECT  SUM( (TB004*TB007))  AS 本期 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE  left(TB005,1)='5' and left(TB005,4)<>'5241'  AND TB001='920' AND TB002<=?xxxx AND LEFT(TB002,4)=?MYEAR","TmpGroupData1")<0
			WAIT WINDOWS 'D驾驶舱  FDS' 
			RETURN
		ENDIF&&		
		IF ISNULL(本期) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=本期 	
		ENDIF	

		m利润总额=QC+CCD
		SQLEXEC(CON,"SELECT sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND "+;
		"left(LE001,1)='5'  AND LE005='2' and left(LE001,4)<>'5241' ","TMP")
		IF ISNULL(XDS)
			QC=0
		ELSE
			QC=XDS
		ENDIF		
		IF sqlexec(con,"SELECT  SUM( (TB004*TB007))  AS 本期 "+;
	      " FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
	      " WHERE   left(TB005,1)='5' and left(TB005,4)<>'5241' AND TB001='920' AND TB002<=?xxxx1 AND LEFT(TB002,4)=?MYEAR1","TmpGroupData1")<0
			WAIT WINDOWS 'DF驾驶舱  DS' 
			RETURN
		ENDIF&&		

		IF ISNULL(本期) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=本期 	
		ENDIF	
		m利润总额1=QC+CCD


		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='利润总额'  AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?m利润总额,creatdate=getdate(),preval=?m利润总额1  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'利润总额',?m利润总额,getdate(),?P_USERNAME,?pk)")
		ENDIF

************总资产
		SQLEXEC(CON,"SELECT sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND left(LE001,1) like '[14]'  ","TMP")
		IF ISNULL(xds) OR RECCOUNT()<1
			qc=0
		else	
			QC=XDS
		ENDIF 	
		nczcc=QC
		IF sqlexec(con,"SELECT  SUM((case when left(TB005,1) in (1,4) then 1 else -1 end)*(TB004*TB007))  AS 本期 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE  left(TB005,1) like '[14]'   AND TB002<=?xxxx AND LEFT(TB002,4)=?MYEAR","TmpGroupData1")<0
			WAIT WINDOWS 'DFD驾驶舱  S' 
			RETURN
		ENDIF&&		
		IF ISNULL(本期) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=本期 	
		ENDIF	
		bczcc=CCD
		m总资产=QC+CCD
		SQLEXEC(CON,"SELECT sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND left(LE001,1) like '[14]' ","TMP")
		QC=XDS
		nczcc1=QC
		
		IF sqlexec(con,"SELECT  SUM((case when left(TB005,1) in (1,4) then 1 else -1 end)*(TB004*TB007))  AS 本期 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE  left(TB005,1) like '[14]' AND TB002<=?xxxx1   AND  LEFT(TB002,4)=?MYEAR1","TmpGroupData1")<0

			WAIT WINDOWS 'DF非驾驶舱DS' 
			RETURN
		ENDIF&&		
		IF ISNULL(本期) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=本期 	
		ENDIF	
		m总资产1=QC+CCD 
		bczcc1=CCD


		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='总资产' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?m总资产,creatdate=getdate(),preval=?m总资产1  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'总资产',?m总资产,getdate(),?P_USERNAME,?pk)")
		ENDIF
************总资产增长率

		cc=bczcc/nczcc
		dd=bczcc1/nczcc1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='总资产增长率' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'总资产增长率',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF

************总资产报酬率

		cc=m利润总额/m总资产
		dd=m利润总额1/m总资产1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='总资产报酬率' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'总资产报酬率',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF
*************	销货	
		IF SQLEXEC(CON,"SELECT SUM(CASE WHEN TG003<=?XXXX AND LEFT(TG003,4)=?MYEAR THEN COPTH.TH037 ELSE 0 END) CY,"+;
			" SUM(CASE WHEN TG003<=?XXXX AND LEFT(TG003,6)=?MMONTH THEN COPTH.TH037 ELSE 0 END) CH,"+;
			"SUM(CASE WHEN TG003<=?XXXX1 AND LEFT(TG003,4)=?MYEAR1 THEN COPTH.TH037 ELSE 0 END) CY1,"+;
			" SUM(CASE WHEN TG003<=?XXXX1 AND LEFT(TG003,6)=?MMONTH1 THEN COPTH.TH037 ELSE 0 END) CH1"+;
			" FROM  COPTG left join COPTH on COPTG.TG001=COPTH.TH001 and COPTG.TG002=COPTH.TH002 "+;
			" WHERE TG023='Y'  UNION ALL SELECT SUM(CASE WHEN TI003<=?XXXX AND LEFT(TI003,4)=?MYEAR THEN -COPTJ.TJ033 ELSE 0 END) CY,"+;
			" SUM(CASE WHEN COPTI.TI003<=?XXXX AND LEFT(TI003,6)=?MMONTH THEN -COPTJ.TJ033 ELSE 0 END) CH,"+;
			"SUM(CASE WHEN TI003<=?XXXX1 AND LEFT(TI003,4)=?MYEAR1 THEN -COPTJ.TJ033 ELSE 0 END) CY1,"+;
			" SUM(CASE WHEN TI003<=?XXXX1 AND LEFT(TI003,6)=?MMONTH1 THEN -COPTJ.TJ033 ELSE 0 END) CH1"+;
			" FROM COPTI left join COPTJ on COPTI.TI001=COPTJ.TJ001 and COPTI.TI002=COPTJ.TJ002 where COPTI.TI019 = 'Y' ","TMP1")<0
				WAIT windows '???驾驶舱12' 
		endif	
		SUM ch,ch1,cy,cy1 TO cc,cc1,dd,dd1
*!*			cc=ch
*!*			cc1=ch1
*!*			dd=cy
*!*			dd1=cy1
		byxhl=cc
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本月销货' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?cc,creatdate=getdate(),preval=?cc1  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,preval,odbc) values (?ffds,?xx,'本月销货',?cc,getdate(),?P_USERNAME,?cc1,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本年销货' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?dd,creatdate=getdate(),preval=?dd1  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,preval,odbc) values (?ffds,?xx,'本年销货',?dd,getdate(),?P_USERNAME,?dd1,?pk)")
		ENDIF

		
************成本费用总额
		IF sqlexec(con,"SELECT SUM(CASE WHEN SUBSTRING(TA003,1,6)= ?mmonth THEN TB019 ELSE 0 END) AS  销售 "+;
		 		" FROM ACRTA INNER JOIN ACRTB ON TA001=TB001 AND TA002=TB002 where SUBSTRING(TA003,1,4)= ?MYEAR ","TmpGroupData1")<0
			WAIT WINDOWS 'D和驾驶舱FDS' 
			RETURN
		ENDIF&&		
 
		BB=销售
 
		RTMD=BB
		IF sqlexec(con,"SELECT Sum(CASE WHEN LEFT(TB002,6)=?MMONTH THEN ACTTB.TB004*ACTTB.TB007 ELSE 0 END) AS '本月费用' "+;
		"FROM ACTTB WHERE ACTTB.TB001<>'920' and left(TB005,1) in ('5')"+;
		" and left(TB005,3) in ('511','513','514','515') and ACTTB.TB016='Y' and left(TB002,4)=?MYEAR","TmpGroupData1")<0
			WAIT windows '到款核销表2' 
		ENDIF 		

		BB23=本月费用

		*SQLEXEC(CON,"SELECT -1*sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND left(LE001,3) = '510'  ","TMP")
		QC=0&&XDS
		IF sqlexec(con,"SELECT  -1*SUM((case when left(TB005,1) in (1,4) then 1 else -1 end)*(TB004*TB007))  AS 本期 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002 inner join CMSMQ ON MQ001=TA001 "+;
		      " WHERE  left(TB005,3) <> '510' and left(TB005,2) = '51' AND LEFT(MQ008,1)<>'4'  AND LEFT(TB002,6)<?MMONTH AND LEFT(TB002,4)=?MYEAR","TmpGroupData1")<0
			WAIT WINDOWS 'D广告歌驾驶舱FDS' 
			RETURN
		ENDIF&&		
		IF ISNULL(本期) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=本期 	
		ENDIF	
		m成本费用总额=CCD+RTMD*0.7+BB23
		SQLEXEC(CON,"SELECT -1*sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND left(LE001,3) = '510' ","TMP")
		QC=XDS
		
		IF sqlexec(con,"SELECT  -1*SUM((case when left(TB005,1) in (1,4) then 1 else -1 end)*(TB004*TB007))  AS 本期 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002 inner join CMSMQ ON MQ001=TA001 "+;
		      " WHERE  left(TB005,3) <> '510' and left(TB005,2) = '51' AND LEFT(MQ008,1)<>'4' AND TB002<=?xxxx1  AND  LEFT(TB002,4)=?MYEAR1","TmpGroupData1")<0

			WAIT WINDOWS 'D非非驾驶舱FDS' 
			RETURN
		ENDIF&&		
		IF ISNULL(本期) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=本期 	
		ENDIF	
		m成本费用总额1=CCD


		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='成本费用总额' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?m成本费用总额,creatdate=getdate(),preval=?m成本费用总额1  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'成本费用总额',?m成本费用总额,getdate(),?P_USERNAME,?pk)")
		ENDIF
		
************成本费用利润率

		cc=m利润总额/m成本费用总额
		dd=m利润总额1/m成本费用总额1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='成本费用利润率' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'成本费用利润率',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF
************息税前利润
		SQLEXEC(CON,"SELECT SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR  AND (left(LE001,1)='5' "+;
		"and left(LE001,4)<>'524' and LE001<>'515103002') and LE005='2'")
		IF ISNULL(xds)  OR RECCOUNT()<1
			qc=0
		else		
			QC=XDS 
		ENDIF 
		WCH=QC
		TCH=(QC)*MONTH(DATE())/12
		jl=WCH
		SQLEXEC(CON,"SELECT SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR1 and LE003<=?XF AND (left(LE001,1)='5' "+;
		"and left(LE001,4)<>'524' and LE001<>'515103002') and LE005='2'")
	*	QC=XDSAND TB001='920' 
		IF ISNULL(xds)  OR RECCOUNT()<1
			qc=0
		else		
			QC=XDS 
		ENDIF 		
		WCH1=QC
		TCH1=(QC)*MONTH(DATE())/12
		jl1=WCH1
************利息
		SQLEXEC(CON,"SELECT -1*SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR  AND LE001='515103002' and LE005='2'")
		IF ISNULL(xds)  OR RECCOUNT()<1
			qc=0
		else		
			QC=XDS 
		ENDIF 
		WCH=QC
		TCH=(QC)*MONTH(DATE())/12
		ljl=WCH
		SQLEXEC(CON,"SELECT -1*SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003<=?XF  AND LE001='515103002' and LE005='2'")
	*	QC=XDSAND TB001='920' 
		IF ISNULL(xds)  OR RECCOUNT()<1
			qc=0
		else		
			QC=XDS 
		ENDIF 
		WCH1=QC
		TCH1=(QC)
		ljl1=WCH1		
************已获利息倍数
		cc=jl/ljl
		dd=jl1/ljl1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='已获利息倍数' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'已获利息倍数',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF	
************经营活动产生的现金净流量
*!*			SQLEXEC(CON1,"SELECT getval,preval from dashboard  where name=?xx and keydate='本年毛利' ","TMP")
*!*			jl=getval
*!*			jl1=preval 
		SQLEXEC(CON,"SELECT -1*sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND left(LE001,3) = '161'  ","TMP")
		QC=XDS
		IF sqlexec(con,"SELECT  -1*SUM((case when left(TB005,1) in (1,4) then 1 else -1 end)*(TB004*TB007))  AS 本期 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE  left(TB005,3) = '161'   AND TB002<=?xxxx AND LEFT(TB002,4)=?MYEAR","TmpGroupData1")<0
			WAIT WINDOWS 'DF查查驾驶舱DS' 
			RETURN
		ENDIF&&		
		IF ISNULL(本期)  OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=本期 	
		ENDIF	
		gdzc=ccd
		m经验现金净流量=CCD+jl
		SQLEXEC(CON,"SELECT -1*sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND left(LE001,3) = '161' ","TMP")
		QC=XDS
		
		IF sqlexec(con,"SELECT  -1*SUM((case when left(TB005,1) in (1,4) then 1 else -1 end)*(TB004*TB007))  AS 本期 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE  left(TB005,3) = '161' AND TB002<=?xxxx1  AND  LEFT(TB002,4)=?MYEAR1","TmpGroupData1")<0

			WAIT WINDOWS 'DFD发到驾驶舱S' 
			RETURN
		ENDIF&&		
		IF ISNULL(本期)  OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=本期 	
		ENDIF	
		m经验现金净流量1=CCD+jl1
		gdzc1=ccd


		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='经验现金净流量' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?m经验现金净流量,creatdate=getdate(),preval=?m经验现金净流量1  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'经验现金净流量',?m经验现金净流量,getdate(),?P_USERNAME,?pk)")
		ENDIF

************盈余现金保障倍数
		m现金保障倍数=m经验现金净流量/jl
		m现金保障倍数1=m经验现金净流量1/jl1
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='现金保障倍数' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?m现金保障倍数,creatdate=getdate(),preval=?m现金保障倍数1  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'现金保障倍数',?m现金保障倍数,getdate(),?P_USERNAME,?pk)")
		ENDIF



************日销售
		SQLEXEC(CON,"SELECT MAX(TB002) AS TB002 FROM ACTTB "+;
		"WHERE ACTTB.TB001='920' and left(TB005,3) in ('510','511','512') and ACTTB.TB016='Y' ","TMP")
		GZR=LEFT(TB002 ,6)
		GZR1=MYEAR1 +SUBSTR(GZR,5,2)
		IF sqlexec(con,"SELECT  SUM(CASE WHEN SUBSTRING(TA003,1,8)= ?XXXX1 THEN (case when ACRTA.TA079='1' then 1 else -1 end)*TB019 ELSE 0 END) AS  日销售,"+;
		"SUM(CASE WHEN SUBSTRING(TA003,1,6)= ?mmonth1 AND TA003<= ?XXXX1 THEN (case when ACRTA.TA079='1' then 1 else -1 end)*TB020 ELSE 0 END) AS  y销售,"+;
		"SUM(CASE WHEN SUBSTRING(TA003,1,6)= ?mmonth1 AND TA003<= ?XXXX1 THEN (case when ACRTA.TA079='1' then 1 else -1 end)*TB019 ELSE 0 END) AS  销售,"+;
		"SUM(CASE WHEN SUBSTRING(TA003,1,6)> ?GZR1 AND TA003<= ?XXXX1 THEN (case when ACRTA.TA079='1' then 1 else -1 end)*TB019 ELSE 0 END) AS  毛利销售,"+;
		"SUM(CASE WHEN TA003<=?XXXX1 THEN (case when ACRTA.TA079='1' then 1 else -1 end)*TB019 ELSE 0 END) AS  年销售 "+;
		 		" FROM ACRTA INNER JOIN ACRTB ON TA001=TB001 AND TA002=TB002 where SUBSTRING(TA003,1,4)= ?MYEAR1 ","TmpGroupData1")<0
			WAIT WINDOWS 'DF都是驾驶舱DS' 
			RETURN
		ENDIF&&		
		cc1=日销售
		BB1=销售
		DDDD1=bb1
		DD1=年销售 
		YSdd1=dd1
		td1=y销售
		MAOLISALE1=毛利销售

		IF sqlexec(con,"SELECT  SUM(CASE WHEN SUBSTRING(TA003,1,8)= ?XXXX THEN (case when ACRTA.TA079='1' then 1 else -1 end)*TB019 ELSE 0 END) AS  日销售,"+;
		"SUM(CASE WHEN SUBSTRING(TA003,1,6)= ?mmonth THEN (case when ACRTA.TA079='1' then 1 else -1 end)*TB020 ELSE 0 END) AS  y销售,"+;
		"SUM(CASE WHEN SUBSTRING(TA003,1,6)= ?mmonth THEN (case when ACRTA.TA079='1' then 1 else -1 end)*TB019 ELSE 0 END) AS  销售,"+;
		"SUM(CASE WHEN SUBSTRING(TA003,1,6)> ?GZR THEN (case when ACRTA.TA079='1' then 1 else -1 end)*TB019 ELSE 0 END) AS  毛利销售,"+;
		"SUM(CASE WHEN TA003<=?XXXX THEN (case when ACRTA.TA079='1' then 1 else -1 end)*TB019 ELSE 0 END) AS  年销售 "+;
		 		" FROM ACRTA INNER JOIN ACRTB ON TA001=TB001 AND TA002=TB002 where SUBSTRING(TA003,1,4)= ?MYEAR ","TmpGroupData1")<0
			WAIT WINDOWS '显示驾驶舱DFDS' 
			RETURN
		ENDIF&&		
		cc=日销售
		BB=销售
		DDDD=bb
		DD=年销售 
		YSdd=dd
		RTMD=BB
		td=y销售
		MAOLISALE=毛利销售
		tt1=ALLTRIM(STR(INT(cc)))+'/'+ALLTRIM(STR(INT(cc1)))
		tt2=ALLTRIM(STR(INT(bb)))+'/'+ALLTRIM(STR(INT(bb1)))
		tt3=ALLTRIM(STR(INT(dd)))+'/'+ALLTRIM(STR(INT(dd1)))
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本月应收' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?td,creatdate=getdate(),preval=?td1  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'本月应收',?cc1,getdate(),?P_USERNAME,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本日销售' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?cc1  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'本日销售',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本月销售' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?bb,creatdate=getdate(),preval=?bb1  where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'本月销售',?bb,getdate(),?P_USERNAME,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本年销售' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?dd,creatdate=getdate(),preval=?dd1  where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'本年销售',?dd,getdate(),?P_USERNAME,?pk)")
		ENDIF
************销售增长率
		gdcc=dd/dd1-1
		XXXX2=DTOC(GOMONTH(DATE(),-24),1)
		MYEAR2 =LEFT(XXXX2,4)
		IF sqlexec(con,"SELECT SUM(CASE WHEN TA003<=?XXXX2 THEN TB019 ELSE 0 END) AS  年销售 "+;
		 		" FROM ACRTA INNER JOIN ACRTB ON TA001=TB001 AND TA002=TB002 where SUBSTRING(TA003,1,4)= ?MYEAR2 ","TmpGroupData1")<0
			WAIT WINDOWS 'D做帐驾驶舱FDS' 
			RETURN
		ENDIF&&		
		DD2=年销售 
		gdcc1=dd1/dd2-1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='销售增长率' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?gdcc,creatdate=getdate(),preval=?gdcc1 where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'销售增长率',?gdcc,getdate(),?P_USERNAME,?pk)")
		ENDIF
		
************资产周转率
		cc=dd/m总资产
		ee=dd1/m总资产1
		ff=mday/ee
		SQLEXEC(CON1,"SELECT interid fro=m dashboard  where name=?xx and keydate='资产周转率' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?ee  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'资产周转率',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF
		c4=mday/(dd/m总资产)


		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='资产周转天数' AND odbc=?pk","TMP")
		SELECT tmp
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?C4,creatdate=getdate(),preval=?ff where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'资产周转天数',?C4,getdate(),?P_USERNAME,?pk)")
		ENDIF
*********************流动资产
		SQLEXEC(CON,"SELECT SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND ( LEFT(LE001 ,2) <='15' OR LEFT(LE001,2 )='41' )")
		IF ISNULL(xds)  OR RECCOUNT()<1
			qc=0
		else		
			QC=XDS 
		ENDIF 
		IF sqlexec(con,"SELECT  SUM(TB004*TB007)  AS 本币余额 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND ( LEFT(TB005 ,2)<='15' OR LEFT(TB005,2)='41') and  TB002<=?XXXX and left(TB002,4)=?MYEAR ","TmpGroupData1")<0
			WAIT WINDOWS 'DF领导驾驶舱DS' 
			RETURN
		ENDIF	
		Cc=本币余额+QC
		zcsd=cc
		c1=cc
		SQLEXEC(CON,"SELECT SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND ( LEFT(LE001 ,2) <='15' OR LEFT(LE001,2 )='41' )")
		IF ISNULL(xds)  OR RECCOUNT()<1
			qc=0
		else		
			QC=XDS 
		ENDIF 
		IF sqlexec(con,"SELECT  SUM(TB004*TB007)  AS 本币余额 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND  ( LEFT(TB005 ,2)<='15' OR LEFT(TB005,2)='41') and TB002<=?XXXX1 AND LEFT(TB002,4)=?MYEAR1","TmpGroupData1")<0  &&eft(TB002,6)=?mmonth1 AND 
			WAIT WINDOWS 'DF本币驾驶舱DS' 
			RETURN
		ENDIF			
		ff=本币余额+QC
		zcsd1=ff
		c2=ff
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='流动资产' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?ff  where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'流动资产',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF		
*********************流动资产周转
		gg=YSdd/c1
		ee=YSdd1/c2

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='流动资产周转率' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?gg,creatdate=getdate(),preval=?ee where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'流动资产周转率',?gg,getdate(),?P_USERNAME,?pk)")
		ENDIF
		r1=mday/(YSdd/c1)
		r2=mday/(YSdd1/c2)

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='流动资产周转天数' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?r1,creatdate=getdate(),preval=?r2  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'流动资产周转天数',?r1,getdate(),?P_USERNAME,?pk)")
		ENDIF

*********************固定资产周转

		gg=YSdd/gdzc
		ee=YSdd1/gdzc1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='固定资产周转率' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?gg,creatdate=getdate(),preval=?ee  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'固定资产周转率',?gg,getdate(),?P_USERNAME,?pk)")
		ENDIF
		r1=mday/(YSdd/gdzc)
		r2=mday/(YSdd1/gdzc1)

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='固定资产周转天数' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?r1,creatdate=getdate(),preval=?r2  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'固定资产周转天数',?r1,getdate(),?P_USERNAME,?pk)")
		ENDIF
*********************存货
		SQLEXEC(CON,"SELECT SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND left(LE001,2) in(14,41)")
		IF ISNULL(xds)  OR RECCOUNT()<1
			qc=0
		else		
			QC=XDS 
		ENDIF 
		IF sqlexec(con,"SELECT  SUM(TB004*TB007)  AS 本币余额 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND left(TB005,2) in ('41','14') and  TB002<=?XXXX and left(TB002,4)=?MYEAR ","TmpGroupData1")<0
			WAIT WINDOWS '退出驾驶舱DFDS' 
			RETURN
		ENDIF	
		WCH=本币余额+QC
		TCH=(本币余额/2+QC)*MONTH(DATE())/12
		chsd=WCH
		SQLEXEC(CON,"SELECT SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND left(LE001,2) in(14,41)")
		IF ISNULL(xds)  OR RECCOUNT()<1
			qc=0
		else		
			QC=XDS 
		ENDIF 

		IF sqlexec(con,"SELECT  SUM(TB004*TB007)  AS 本币余额 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND left(TB005,2) in ('41','14') and TB002<=?XXXX1 AND LEFT(TB002,4)=?MYEAR1","TmpGroupData1")<0  &&eft(TB002,6)=?mmonth1 AND 
			WAIT WINDOWS 'D反而驾驶舱FDS' 
			RETURN
		ENDIF			
		WCH1=本币余额+QC
		TCH1=(本币余额/2+QC)*MONTH(DATE())/12
		chsd1=WCH1
		
*********************存货周转
		gg=m主营业务/WCH
		ee=m主营业务1/WCH1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='存货周转率' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?gg,creatdate=getdate(),preval=?ee  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'存货周转率',?gg,getdate(),?P_USERNAME,?pk)")
		ENDIF
		r1=mday/gg
		r2=mday/ee

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='存货周转天数' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?r1,creatdate=getdate(),preval=?r2  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'存货周转天数',?r1,getdate(),?P_USERNAME,?pk)")
		ENDIF
*********************总负债
		SQLEXEC(CON,"SELECT -1*SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND  left(LE001,1) ='2'")
		IF ISNULL(xds)  OR RECCOUNT()<1
			qc=0
		else		
			QC=XDS 
		ENDIF 
		IF sqlexec(con,"SELECT  -1*SUM(TB004*TB007)  AS 本币余额 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND left(TB005,1)='2'  and  TB002<=?XXXX and left(TB002,4)=?MYEAR ","TmpGroupData1")<0
			WAIT WINDOWS 'DF取法驾驶舱DS' 
			RETURN
		ENDIF	
		WCH=本币余额+QC
		TCH=(本币余额/2+QC)/MONTH(DATE())*12
		SQLEXEC(CON,"SELECT -1*SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND left(LE001,1) ='2'")
		IF ISNULL(xds)  OR RECCOUNT()<1
			qc=0
		else		
			QC=XDS 
		ENDIF 
		IF sqlexec(con,"SELECT  -1*SUM(TB004*TB007)  AS 本币余额 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND left(TB005,1)='2' and TB002<=?XXXX1 AND LEFT(TB002,4)=?MYEAR1","TmpGroupData1")<0  &&eft(TB002,6)=?mmonth1 AND 
			WAIT WINDOWS 'D长度驾驶舱FDS' 
			RETURN
		ENDIF			
		WCH1=本币余额+QC
		TCH1=(本币余额/2+QC)/MONTH(DATE())*12
*********************资产负债率
		gg=WCH/m总资产
		ee=WCH1/m总资产

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='负债周转率' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?gg,creatdate=getdate(),preval=?ee  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,preval,odbc) values (?ffds,?xx,'负债周转率',?gg,getdate(),?P_USERNAME,?ee,?pk)")
		ENDIF
************速动比率
		tk1=(zcsd-chsd)/WCH
		tk2=(zcsd1-chsd1)/WCH1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='速动比率' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?tk1,creatdate=getdate(),preval=?tk2 where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'速动比率',?tk1,getdate(),?P_USERNAME,?pk)")
		ENDIF				
************流动比率
		tk1=(zcsd)/WCH
		tk2=(zcsd1)/WCH1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='流动比率' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?tk1,creatdate=getdate(),preval=?tk2 where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'流动比率',?tk1,getdate(),?P_USERNAME,?pk)")
		ENDIF				

************资产息税前利润率
		gg=jl/dd
		ee=jl1/dd1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='息税前利润率' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?gg,creatdate=getdate(),preval=?ee  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,preval,odbc) values (?ffds,?xx,'息税前利润率',?gg,getdate(),?P_USERNAME,?ee,?pk)")
		ENDIF
		
************日接单
		if SQLEXEC(CON,"select sum( case when TC003=?XXXX then case when  TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 else 0 end) 本日,"+;
			"sum(case when LEFT(TC003,6)=?MMONTH then case when TD016='y'  then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 else 0 end) 本月,"+;
			"SUM(case when TC003<=?XXXX then case when TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 ELSE 0 END) as 本期"+;
			" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,4)=?MYEAR  ","TmpQ2C") <0  &&and TC004<>'90574019'
			WAIT windows '?的驾驶舱??1' 
		endif	
		A2=本日
		A1=本月 
		A3=本期 
		IF ISNULL(A1)
			A1=0
			A2=0
		ENDIF
		IF ISNULL(A2)
			A2=0
		ENDIF
		IF ISNULL(A3)
			A1=0
			A3=0
			A2=0
		ENDIF
*!*			CONX=odbc(15)
*!*			if SQLEXEC(CONX,"select sum( case when TC003=?XXXX then case when  TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 else 0 end) 本日,"+;
*!*				"sum(case when LEFT(TC003,6)=?MMONTH then case when TD016='y'  then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 else 0 end) 本月,"+;
*!*				"SUM(case when TC003<=?XXXX then case when TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 ELSE 0 END) as 本期"+;
*!*				" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,4)=?MYEAR and TC004<>'90574019' ","TmpQ2C") <0
*!*				WAIT windows '???2' 
*!*			endif	
*!*			SQLDISCONNECT(CONX)
*!*			A21=本日
*!*			A11=本月 
*!*			A31=本期 
*!*			IF ISNULL(A11)
*!*				A11=0
*!*				A21=0
*!*			ENDIF
*!*			IF ISNULL(A21)
*!*				A21=0
*!*			ENDIF
*!*			IF ISNULL(A31)
*!*				A11=0
*!*				A31=0
*!*				A21=0
*!*			ENDIF
		cc=A2
		BB=A1
		DD=A3	

		if SQLEXEC(CON,"select sum( case when TC003=?XXXX1 then case when  TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 else 0 end) 本日,"+;
			"sum(case when LEFT(TC003,6)=?MMONTH1 AND TC003<= ?XXXX1 then case when TD016='y'  then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 else 0 end) 本月,"+;
			"SUM(case when TC003<=?XXXX1 then case when TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 ELSE 0 END) as 本期"+;
			" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,4)=?MYEAR1  ","TmpQ2C") <0  &&and TC004<>'90574019'
			WAIT windows '??共和国驾驶舱?1' 
		endif	
		A2=本日
		A1=本月 
		A3=本期 
		IF ISNULL(A1)
			A1=0
			A2=0
		ENDIF
		IF ISNULL(A2)
			A2=0
		ENDIF
		IF ISNULL(A3)
			A1=0
			A3=0
			A2=0
		ENDIF
*!*			CONX=odbc(15)
*!*			if SQLEXEC(CONx,"select sum( case when TC003=?XXXX1 then case when  TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 else 0 end) 本日,"+;
*!*				"sum(case when LEFT(TC003,6)=?MMONTH1 then case when TD016='y'  then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 else 0 end) 本月,"+;
*!*				"SUM(case when TC003<=?XXXX1 then case when TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 ELSE 0 END) as 本期"+;
*!*				" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,4)=?MYEAR1 and TC004<>'90574019' ","TmpQ2C") <0
*!*				WAIT windows '???2' 
*!*			endif
*!*			SQLDISCONNECT(CONX)		
*!*			A21=本日
*!*			A11=本月 
*!*			A31=本期 
*!*			IF ISNULL(A11)
*!*				A11=0
*!*				A21=0
*!*			ENDIF
*!*			IF ISNULL(A21)
*!*				A21=0
*!*			ENDIF
*!*			IF ISNULL(A31)
*!*				A11=0
*!*				A31=0
*!*				A21=0
*!*			ENDIF
		cc1=A2
		BB1=A1
		DD1=A3		


		tt1=ALLTRIM(STR(INT(cc)))+'/'+ALLTRIM(STR(INT(cc1)))
		tt2=ALLTRIM(STR(INT(bb)))+'/'+ALLTRIM(STR(INT(bb1)))
		tt3=ALLTRIM(STR(INT(dd)))+'/'+ALLTRIM(STR(INT(dd1)))

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本日接单' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?cc1  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'本日接单',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本月接单' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?bb,creatdate=getdate(),preval=?bb1  where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'本月接单',?bb,getdate(),?P_USERNAME,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本年接单' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?dd,creatdate=getdate(),preval=?dd1  where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'本年接单',?dd,getdate(),?P_USERNAME,?pk)")
		ENDIF
		************库存商品
		IF sqlexec(con,"SELECT  SUM(TB004*TB007)  AS 金额  "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND  left(TB005,3)='146' and  LEFT(TB002,6)=?MMONTH1 AND TB002<=?xxxx1","TmpGroupData1")<0
			WAIT WINDOWS 'DF储存驾驶舱DS1' 
			RETURN
		ENDIF&&			
		CC=金额 
		IF ISNULL(CC)=.T.
			CC=0
		ENDIF	

		IF SQLEXEC(con,"SELECT SUM((case when left(LE001,1) in(1,4) then 1 else -1 end)*(LE014-LE017)) 金额 FROM ACTLE"+;
		"  where LE002=?MYEAR1 and LE003<?XF and  left(LE001,3)='146'","tmp")<0
			WAIT WINDOWS 'DFDS2' 
			RETURN
		ENDIF&&			
		DD=金额+CC
		IF sqlexec(con,"SELECT  SUM(TB004*TB007)  AS 金额  "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND  left(TB005,3)='146' and  LEFT(TB002,6)=?MMONTH AND TB002<=?xxxx","TmpGroupData1")<0
			WAIT WINDOWS 'DFDS驾驶舱3' 
			RETURN
		ENDIF&&			
		CC=金额 
		IF ISNULL(CC)=.T.
			CC=0
		ENDIF	
		XF=SUBSTR(MMONTH,5,2)
		IF SQLEXEC(con,"SELECT SUM((case when left(LE001,1) in(1,4) then 1 else -1 end)*(LE014-LE017)) 金额 FROM ACTLE"+;
		"  where LE002=?MYEAR and LE003<?XF and  left(LE001,3)='146'","tmp")<0
			WAIT WINDOWS 'DFDS驾驶舱4' 
			RETURN
		ENDIF&&			
		CC1=金额+CC
				
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='库存商品' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?cc1,creatdate=getdate(),preval=?dd  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'库存商品',?dd,getdate(),?P_USERNAME,?pk)")
		ENDIF
		************实收
		SQLEXEC(CON,"DROP VIEW LHB")
		IF SQLEXEC(CON,"CREATE VIEW LHB AS SELECT LB005 AS 客户, SUBSTRING(LB020,1,8) AS 日期, (CASE WHEN LB001 IN ('0', '1', '2') THEN (LB014 + LB019) ELSE 0.0 END) AS 本币应收, "+;
		"(CASE WHEN LB001 IN ('3', '4', '5') THEN LB014 ELSE 0.0 END) AS 本币实收 FROM ACRLB AS ACRLB WHERE (1 = 1 AND LB001 NOT IN ('B', 'C')) UNION ALL "+;
		"SELECT LC006 AS KHID, LC029 AS DAY,  0.0 AS BBYSJE, (CASE WHEN MQ003 IN ('61', '6A', '66', '6B') "+;
		" THEN LC018 ELSE 0.0 END) AS BBSSJE "+;
		" FROM ACRLC  LEFT JOIN CMSMQ AS CMSMQ ON MQ001 = LC003 WHERE (1 = 1 AND (Round(LC018, 3) <> 0.0 OR Round(LC017, 3) <> 0.0)) UNION ALL "+;
		"SELECT LC006 AS KHID,  SUBSTRING(LC029,1,8) AS DAY, 0.0 AS BBYSJE,  LC019 AS BBSSJE  "+;
		" FROM ACRLC WHERE (1 = 1 AND Round(LC019, 3) <> 0.0 ) UNION ALL "+;
		"SELECT LE005 KHID,LD003 DAY,CASE WHEN LE004='3'  THEN 0- LE014 ELSE LE014 END THJE,0 AS SS FROM ACRLD LEFT JOIN ACRLE ON LD001=LE001 AND LD002=LE002")<0
			WAIT windows '视图到款核销表' 
		ENDIF 	

		IF SQLEXEC(CON,"select "+;
			"SUM(CASE WHEN LEFT(日期,6)=?MMONTH AND SUBSTRING(日期,1,4)=?MYEAR THEN 本币应收 ELSE 0.0 END) as 本期应收,SUM( CASE WHEN LEFT(日期,4)=?MYEAR THEN 本币应收 ELSE 0 END) as 本年应收, "+;
			"SUM(CASE WHEN LEFT(日期,6)=?MMONTH THEN 本币实收 ELSE 0.0 END) as 本期实收, SUM( CASE WHEN SUBSTRING(日期,1,4)=?MYEAR THEN 本币实收 ELSE 0 END) as 本年实收, "+;
			"sum(CASE WHEN 日期<=?xxxx THEN 本币应收-本币实收 ELSE 0 END) AS 期末应收 ,SUM(CASE WHEN  日期>=?XXXX and LEFT(日期,4)=?MYEAR THEN 本币实收 ELSE 0.0 END) as 实收 FROM LHB","TmpQC")<0
			WAIT windows '到款核销表1' 
		ENDIF 	
		cc1=本期应收
		dd1=本年应收
		ee1=本期实收
		ff1=本年实收
		GG1=期末应收
		YSdd=dd1
		TCH=期末应收
		IF SQLEXEC(CON,"select "+;
			"SUM(CASE WHEN LEFT(日期,6)=?MMONTH1 AND 日期<=?XXXX1  THEN 本币应收 ELSE 0.0 END) as 本期应收,SUM( CASE WHEN LEFT(日期,4)=?MYEAR1 AND 日期<=?XXXX1 THEN 本币应收 ELSE 0 END) as 本年应收, "+;
			"SUM(CASE WHEN LEFT(日期,6)=?MMONTH1 AND 日期<=?XXXX1  THEN 本币实收 ELSE 0.0 END) as 本期实收,SUM( CASE WHEN LEFT(日期,4)=?MYEAR1 AND 日期<=?XXXX1 THEN 本币实收 ELSE 0 END) as 本年实收, "+;
			"sum(CASE WHEN 日期<=?xxxx1 THEN 本币应收-本币实收 ELSE 0 END) AS 期末应收  ,SUM(CASE WHEN  日期<=?XXXX1 and LEFT(日期,4)=?MYEAR1 THEN 本币实收 ELSE 0.0 END) as 实收 FROM LHB ","TmpQC")<0
			WAIT windows '到款核销表2' 
		ENDIF 	
		cc2=本期应收
		dd2=本年应收
		ee2=本期实收
		ff2=本年实收
		GG2=期末应收
		YSdd1=dd2
		TCH1=期末应收
*!*	*********************应收账款
*!*			SQLEXEC(CON,"SELECT SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR and LE003='00' AND  left(LE001,3) in ('114','113')")
*!*			QC=XDS
*!*			WCH=(TCH+QC)/2
*!*			SQLEXEC(CON,"SELECT SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR1 and LE003='00' AND  left(LE001,3) in ('114','113')")
*!*			QC=XDS
*!*			WCH1=(TCH1+QC)/2
*********************应收账款周转
		gg=YSdd/TCH
		ee=YSdd1/TCH1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='应收账款周转率' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?gg,creatdate=getdate(),preval=?ee where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'应收账款周转率',?gg,getdate(),?P_USERNAME,?pk)")
		ENDIF
		r1=mday*TCH/YSdd
		r2=mday*TCH1/YSdd1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='应收账款周转天数'  AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?r1,creatdate=getdate(),preval=?r2  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'应收账款周转天数',?r1,getdate(),?P_USERNAME,?pk)")
		ENDIF

	*************************应收余额
*!*			SQLEXEC(CON,"select SUM((TA041+TA042-TA098+TA059)*(case when TA079=1 then 1 else -1 end)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end)) as '应收余额' "+;
*!*			"from ACRTA left join CMSMQ on MQ001=TA001 where TA025='Y' and TA029+TA030 <>ACRTA.TA031 and TA020<?xxxx1","tmp")
*!*			cdddd=应收余额
*!*			IF ISNULL(cdddd)
*!*				cdddd=0
*!*			ENDIF	
*!*			DD=cdddd
*!*			SQLEXEC(CON,"select SUM((TA041+TA042-TA098+TA059)*(case when TA079=1 then 1 else -1 end)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end)) as '应收余额' "+;
*!*			"from ACRTA left join CMSMQ on MQ001=TA001 where TA025='Y' and TA029+TA030 <>ACRTA.TA031","tmp")
*!*			cdddd=应收余额
*!*			IF ISNULL(cdddd)
*!*				cdddd=0
*!*			ENDIF	
*!*			cc=cdddd
*!*			tt1=ALLTRIM(STR(INT(cc)))+'/'+ALLTRIM(STR(INT(cc1)))

		IF SQLEXEC(CON,"select  Sum(CASE WHEN ACRTI.TI019<=?XXXX  AND (ACRTI.TI031 = '1')  THEN TI016+TI032 ELSE 0 END)-Sum(CASE WHEN ACRTI.TI019<=?XXXX  "+;
		 "   AND (ACRTI.TI031 = '2')  THEN TI016+TI032 ELSE 0 END) AS 未收总额, Sum(CASE WHEN ACRTI.TI019<=?XXXX1  AND (ACRTI.TI031 = '1')  THEN TI016+TI032 ELSE 0 END)-Sum(CASE WHEN ACRTI.TI019<=?XXXX1  "+;
		 "   AND (ACRTI.TI031 = '2')  THEN TI016+TI032 ELSE 0 END) AS 未收总额1 "+;
		"FROM ACRTI  WHERE TI013='Y' " ,"TmpCustom1")<0
		 WAIT windows '其它应收款'
		 ENDIF 
		GG1=未收总额
		gg2=未收总额1
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='应收余额' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc11=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?GG1,creatdate=getdate(),preval=?GG2 where interid=?cc11")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'应收余额',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF

*!*			SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本月应收' AND odbc=?pk","TMP")
*!*			IF RECCOUNT()=1
*!*				cc12=interid
*!*				SQLEXEC(CON1,"UPDATE dashboard set getval=?cc1,creatdate=getdate(),preval=?cc2  where interid=?cc12")
*!*			ELSE
*!*				SQLDISCONNECT(CON1) 	
*!*				ffds=maxinterid("dashboard")
*!*				CON1=ODBC(6)
*!*				SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'本月应收',?cc1,getdate(),?P_USERNAME,?pk)")
*!*			ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本年应收' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?dd1,creatdate=getdate(),preval=?dd2  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'本年应收',?dd1,getdate(),?P_USERNAME?pk)")
		ENDIF		
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本月实收' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?ee1,creatdate=getdate(),preval=?ee2  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'本月实收',?ee1,getdate(),?P_USERNAME,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本年实收' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?ff1,creatdate=getdate(),preval=?ff2  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'本年实收',?ff1,getdate(),?P_USERNAME,?pk)")
		ENDIF		

*!*	 inner join CMSMQ ON MQ001=TA001 "+;
*!*			      " WHERE  left(TB005,3) <> '510' and left(TB005,2) = '51' AND LEFT(MQ008,1)<>'4'
****************费用
		IF sqlexec(con,"SELECT SUM(CASE WHEN TB002=?XXXX1 THEN ACTTB.TB004*ACTTB.TB007 ELSE 0 END)  '本日费用',"+;
		"Sum(CASE WHEN LEFT(TB002,6)= ?MMONTH1 AND TB002<=?XXXX1 THEN ACTTB.TB004*ACTTB.TB007 ELSE 0 END) AS '本月费用',SUM( ACTTB.TB004*ACTTB.TB007) 本年费用"+;
		",SUM(CASE WHEN TB005 like '514131%02' THEN ACTTB.TB004*ACTTB.TB007 ELSE 0 END)  '研发费用' "+;
		"FROM ACTTB WHERE ACTTB.TB001<>'920' and left(TB005,1) in ('5')"+;
		" and left(TB005,3) in ('511','513','514','515') and ACTTB.TB016='Y' and left(TB002,4)=?MYEAR1 AND TB002<=?XXXX1","TmpGroupData1")<0
			WAIT windows '到款核销表1' 
		ENDIF 	
		cc1=本日费用
		BB123=本月费用
		BB1=本月费用
		fyfy1=bb1
		DD1=本年费用
		DD123=本年费用
		XD1=研发费用
		IF sqlexec(con,"SELECT SUM(CASE WHEN TB002=?XXXX THEN ACTTB.TB004*ACTTB.TB007 ELSE 0 END)  '本日费用' ,"+;
		"Sum(CASE WHEN LEFT(TB002,6)=?MMONTH THEN ACTTB.TB004*ACTTB.TB007 ELSE 0 END) AS '本月费用',SUM( ACTTB.TB004*ACTTB.TB007) 本年费用 "+;
		",SUM(CASE WHEN (TB005 like '514131%02') THEN ACTTB.TB004*ACTTB.TB007 ELSE 0 END)  '研发费用' "+;
		"FROM ACTTB WHERE ACTTB.TB001<>'920' and left(TB005,1) in ('5')"+;
		" and left(TB005,3) in ('511','513','514','515') and ACTTB.TB016='Y' and left(TB002,4)=?MYEAR","TmpGroupData1")<0
			WAIT windows '到款核销表2' 
		ENDIF 		
		cc=本日费用
		BB=本月费用
		BB23=本月费用
		fyfy=bb
		DD=本年费用
		DD23=本年费用
		XD=研发费用
		tt1=ALLTRIM(STR(INT(cc)))+'/'+ALLTRIM(STR(INT(cc1)))
		tt2=ALLTRIM(STR(INT(bb)))+'/'+ALLTRIM(STR(INT(bb1)))
		tt3=ALLTRIM(STR(INT(dd)))+'/'+ALLTRIM(STR(INT(dd1)))		
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='研发费用' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc11=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?XD,creatdate=getdate(),preval=?XD1 where interid=?cc11")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,preval,creatdate,billname,odbc) values (?ffds,?xx,'研发费用',?XD,?XD1,getdate(),?P_USERNAME,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本日费用' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc11=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?cc1   where interid=?cc11")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'本日费用',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本月费用' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?bb23,creatdate=getdate(),preval=?bb123 where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'本月费用',?bb,getdate(),?P_USERNAME,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本年费用' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?DD23 ,creatdate=getdate(),preval=?dd123  where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'本年费用',?DD,getdate(),?P_USERNAME,?pk)")
		ENDIF
		ddXY=MAOLISALE*0.35
		dd=DDDD*0.35
		dd1=dddd1*0.35&&-fyfy1
		DD511=dd
		DD1511=DD1
		ddXY1=MAOLISALE1*0.35
		
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本月毛利' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?DD ,creatdate=getdate(),preval=?dd1 where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'本月毛利',?DD,getdate(),?P_USERNAME,?pk)")
		ENDIF
		gzr2=myear1+SUBSTR(GZR1,5,2)
		SQLEXEC(CON,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '本年毛利' FROM ACTTB inner join CMSMQ ON MQ001=TB001 "+;
		"WHERE LEFT(MQ008,1)='4' and (left(TB005,3) in ('510','511','512')  ) and ACTTB.TB016='Y' and left(TB002,4) =?myear1 AND LEFT(TB002,6)<=?gzr2","TMP")
		bb1=本年毛利+ddXY1&&DD1511
		SQLEXEC(CON,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '本年毛利' FROM ACTTB inner join CMSMQ ON MQ001=TB001 "+;
		"WHERE LEFT(MQ008,1)='4' and (left(TB005,3) in ('510','511','512')) and ACTTB.TB016='Y' and left(TB002,4) =?myear ","TMP")
		bb=本年毛利+ddXY&&本月的
		tt2=ALLTRIM(STR(INT(bb)))+'/'+ALLTRIM(STR(INT(bb1)))

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本年毛利' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?bb,creatdate=getdate(),preval=?bb1 where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'本年毛利',?bb,getdate(),?P_USERNAME,?pk)")
		ENDIF		
		
		SQLEXEC(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '本年净利' FROM ACTTB WHERE ACTTB.TB001='920' and (left(TB005,1) in('5') OR  TB005 like '514131%02' ) and ACTTB.TB016='Y'"+;
		"  and left(TB002,4) =?myear1  AND TB002<=?XXXX1 ","tmp")
		bb1=本年净利+DD1511/2&&少本月的
		SQLEXEC(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '本年净利' FROM ACTTB WHERE ACTTB.TB001='920' and (left(TB005,1) in('5') OR  TB005 like '514131%02' ) and ACTTB.TB016='Y'"+;
		"  and left(TB002,4) =?myear AND TB001='920'","tmp")
		bb=本年净利+ddXY/2
		tt2=ALLTRIM(STR(INT(bb)))+'/'+ALLTRIM(STR(INT(bb1)))

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本年净利' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?bb,creatdate=getdate(),preval=?BB1   where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'本年净利',?bb,getdate(),?P_USERNAME,?pk)")
		ENDIF			


*************************资金
		IF sqlexec(con,"SELECT  SUM(TB004*TB007)  AS 本币余额 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND (LEFT(TB005 ,4)='1101' OR LEFT(TB005 ,4)='1111') and LEFT(TA014,8)<=?XXXX1 ","TmpGroupData1")<0
			WAIT WINDOWS 'DFDS' 
			RETURN
		ENDIF&&		
		ccCC1=本币余额+17759846
		IF sqlexec(con,"SELECT  SUM(TB004*TB007)  AS 本币余额 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND (LEFT(TB005 ,4)='1101' OR LEFT(TB005 ,4)='1111')  ","TmpGroupData1")<0
			WAIT WINDOWS 'DFDS' 
			RETURN
		ENDIF&&		
		ccCCCC=本币余额+17759846
		tt1=ALLTRIM(STR(INT(cc)))+'/'+ALLTRIM(STR(INT(cc1)))

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='现金余额' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc11=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?ccCCCC,creatdate=getdate(),preval=?ccCC1 where interid=?cc11")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'现金余额',?ccCCCC,getdate(),?P_USERNAME,?pk)")
		ENDIF

		*************************本月应付
		SQLEXEC(CON,"DROP VIEW LHB")

		SQLEXEC(CON,"CREATE VIEW LHB AS SELECT LB005 AS 供应商,SUBSTRING(LB020,1,8) AS 日期,"+;
			"(Case when LB001 in ('0','1','2') then LB014 when (LB001='C' AND MQ003 IN ('71','7A','7B','7F')) then LB019  else 0.0 end) as 本币应付,"+;
			"(Case when LB001 in ('3','4','5') then LB014 when (LB001='C' AND MQ003='7C') then LB019 else 0.0 end) as 本币实付 "+;
		 	"From ACPLB  LEFT JOIN CMSMQ AS CMSMQ ON MQ001=LB009  where LB027='1' union all "+;
			"SELECT LC006,SUBSTRING(LC029,1,6) LC029,(Case when MQ003 IN ('71','7A','7F') then (-1)*LC018 else 0 end) as BBYSJE, "+;
		 	" (Case when LC019 <> 0.0 then LC019 else 0.0 end) as BBSSJE "+;
		 	" FROM ACPLC LEFT JOIN CMSMQ AS CMSMQ ON LC003=MQ001 where LC036='1' and (Round(LC019,3)<>0.0 or Round(LC018,3)<>0.0 or Round(LC017,3)<>0.0) UNION ALL "+;
			"SELECT LE005 KHID,LD010 DAY,LE014 THJE,0 SS FROM ACPLD LEFT JOIN ACPLE ON LD001=LE001 AND LD002=LE002")
		IF SQLEXEC(CON,"select   "+;
			"SUM(CASE WHEN LEFT(日期,6)=?MMONTH AND SUBSTRING(日期,1,4)=?MYEAR THEN 本币应付 ELSE 0.0 END) as 本期应付, SUM( CASE WHEN SUBSTRING(日期,1,4)=?MYEAR THEN 本币应付 ELSE 0 END) as 全年应付,"+;
			"SUM(CASE WHEN LEFT(日期,6)=?MMONTH THEN 本币实付 ELSE 0.0 END) as 本期实付, SUM( CASE WHEN SUBSTRING(日期,1,4)=?MYEAR THEN 本币实付 ELSE 0 END) as 全年实付,"+;
			"sum( 本币应付-本币实付 ) AS 期末应付 ,0 到期未付 "+;
			" FROM LHB","TmpQC")<0
			WAIT windows 'yf' 
		ENDIF 
		cc1=本期应付
		dd1=全年应付
		ee1=本期实付
		ff1=全年实付
		GG1=期末应付
		IF SQLEXEC(CON,"select   "+;
			"SUM(CASE WHEN LEFT(日期,6)=?MMONTH1 and 日期<=?xxxx1 THEN 本币应付 ELSE 0.0 END) as 本期应付, SUM( CASE WHEN SUBSTRING(日期,1,4)=?MYEAR1 and 日期<=?xxxx1 THEN 本币应付 ELSE 0 END) as 全年应付,"+;
			"SUM(CASE WHEN LEFT(日期,6)=?MMONTH1 and 日期<=?xxxx1 THEN 本币实付 ELSE 0.0 END) as 本期实付, SUM( CASE WHEN SUBSTRING(日期,1,4)=?MYEAR1 and 日期<=?xxxx1 THEN 本币实付 ELSE 0 END) as 全年实付,"+;
			"sum(CASE WHEN 日期<=?xxxx1 THEN 本币应付-本币实付 ELSE 0 END) AS 期末应付 ,0 到期未付 "+;
			" FROM LHB","TmpQC")<0
			WAIT windows 'yf' 
		ENDIF 
		cc2=本期应付
		dd2=全年应付
		ee2=本期实付
		ff2=全年实付
		GG2=期末应付
		*************************应付余额
*!*			SQLEXEC(CON,"select sum((TA037+TA038-TA085+TA051)*(case when TA079=1 then 1 else -1 end)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end)) as '应付余额' "+;
*!*			"from ACPTA left join CMSMQ on MQ001=TA001 where TA024='Y' and TA028+TA029 <>ACPTA.TA030","tmp")

*!*			dddc=应付余额
*!*			IF ISNULL(dddc)
*!*				dddc=0
*!*			ENDIF
*!*			cc=dddc
*!*			SQLEXEC(CON,"select sum((TA037+TA038-TA085+TA051)*(case when TA079=1 then 1 else -1 end)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end)) as '应付余额' "+;
*!*			"from ACPTA left join CMSMQ on MQ001=TA001 where TA024='Y' and TA028+TA029 <>ACPTA.TA030 and LEFT(TA019,8)<=?XXXX1","tmp")

*!*			dddc=应付余额
*!*			IF ISNULL(dddc)
*!*				dddc=0
*!*			ENDIF
*!*			DD=dddc
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='应付余额' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc11=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?gg1,creatdate=getdate(),preval=?gg1  where interid=?cc11")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'应付余额',?gg1,getdate(),?P_USERNAME,?pk)")
		ENDIF

		****************本币未付金额
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='未付金额' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc11=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?GG1,creatdate=getdate(),preval=?GG2  where interid=?cc11")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'未付金额',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF		

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本月应付' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?cc1,creatdate=getdate(),preval=?cc2  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'本月应付',?cc1,getdate(),?P_USERNAME,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本年应付' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?dd1,creatdate=getdate(),preval=?dd2  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'本年应付',?dd1,getdate(),?P_USERNAME,?pk)")
		ENDIF		
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本月实付' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?ee1,creatdate=getdate(),preval=?ee2  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'本月实付',?ee1,getdate(),?P_USERNAME,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='本年实付' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?ff1,creatdate=getdate(),preval=?ff2  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'本年实付',?ff1,getdate(),?P_USERNAME,?pk)")
		ENDIF		
		**********************预收余额
		SQLEXEC(CON,"select SUM( (TK033+TK035+TK036-TK038+TK041)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end) ) as '预收余额' "+;
		"from ACRTK left join CMSMQ on MQ001=TK001 where TK020='Y' and TK030 <> '3' ","tmp")
		cc=预收余额
		SQLEXEC(CON,"select SUM( (TK033+TK035+TK036+TK041-TK038)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end) ) as '预收余额' "+;
		"from ACRTK left join CMSMQ on MQ001=TK001 where TK020='Y' and TK030 <> '3' AND TK003<=?XXXX1","tmp")
*!*			dd1=预收余额
*!*			SQLEXEC(CON,"select SUM( (TL020+TL022)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end) ) as '预收余额' "+;
*!*			"from ACRTL INNER JOIN ACRTK ON TL001=TK001 AND TL002=TK002 Left join CMSMQ on MQ001=TK001 where TL027='Y' AND TL026<=?XXXX1","tmp")
		DD=预收余额
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='预收余额' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'预收余额',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF
		**********************预付余额1

		SQLEXEC(CON,"select SUM((TK031+TK033+TK034-TK036+TK039)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end)) as '预付余额' "+;
		"from ACPTK left join CMSMQ on MQ001=TK001 where TK020='Y' and ACPTK.TK028 <> '3'","TmpQC")
		cc=预付余额
		SQLEXEC(CON,"select SUM((TK031+TK033+TK034+TK039-TK036)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end)) as '预付余额' "+;
		"from ACPTK left join CMSMQ on MQ001=TK001 where TK020='Y' and ACPTK.TK028 <> '3' and TK003<=?XXXX1 ","TmpQC")
*!*			DD1s=预付余额
*!*			SQLEXEC(CON,"select SUM((TL020+TL022)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end))   as '预付余额' "+;
*!*			"from ACPTL INNER JOIN ACPTK ON TL001=TK001 AND TL002=TK002  left join CMSMQ on MQ001=TK001 where TL027='Y' AND  and  TL026<=?XXXX1 ","TmpQC")
*!*			sds=预付余额
		DD=预付余额
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='预付余额' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'预付余额',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF		
		*********************流动负债
		SQLEXEC(CON,"SELECT -1*SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND ( LEFT(LE001 ,2) in ('21','22') )")
		QC=XDS
		IF sqlexec(con,"SELECT  -1*SUM(TB004*TB007) AS 本币余额  FROM ACTTB LEFT JOIN ACTTA ON TA001 = TB001 AND TA002 = TB002"+;
		      " WHERE TA010='Y' AND LEFT(TB005 ,2) in ('21','22') and  TB002<=?XXXX and left(TB002,4)=?MYEAR","TmpGroupData1")<0
			WAIT WINDOWS 'DFDS' 
			RETURN
		ENDIF 
		BQ=本币余额
		IF ISNULL(BQ)
			BQ=0
		ENDIF	
		CC=	BQ+QC
		WCHfz=CC
		SQLEXEC(CON,"SELECT -1*SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND ( LEFT(LE001 ,2) in ('21','22') )")
		QC=XDS
		IF sqlexec(con,"SELECT  -1*SUM(TB004*TB007)  AS 本币余额 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND ( LEFT(TB005 ,2) in ('21','22') ) and  TB002<=?XXXX1 AND LEFT(TB002,4)=?MYEAR1 ","TmpGroupData1")<0
			WAIT WINDOWS 'DFDS' 
		ENDIF		
		DD=本币余额+QC
		WCHfz1=DD
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='流动负债' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'流动负债',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF		
		************现金比率
		tk1=ccCCCC/WCHfz
		tk2=ccCC1/WCHfz1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='现金比率' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?tk1,creatdate=getdate(),preval=?tk2 where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'现金比率',?tk1,getdate(),?P_USERNAME,?pk)")
		ENDIF				

		************现金流动负债比率
		m现金保障倍数=(m经验现金净流量+ccCCCC)/WCHfz
		m现金保障倍数1=(m经验现金净流量+ccCC1)/WCHfz1
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='现金流动负债比率' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?m现金保障倍数,creatdate=getdate(),preval=?m现金保障倍数1  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'现金流动负债比率',?m现金保障倍数,getdate(),?P_USERNAME,?pk)")
		ENDIF
		*********************非流动资产
		SQLEXEC(CON,"SELECT -1*SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND (left(LE001,2) <>'21' AND left(LE001,2) <>'22') AND left(LE001,2)>'15' "+;
		      "AND left(LE001,2)<>'41' ")
		QC=XDS
		IF sqlexec(con,"SELECT  -1*SUM(TB004*TB007)  AS 本币余额 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND (left(TB005,2) <>'21' AND left(TB005,2) <>'22') AND left(TB005,2)>'15' "+;
		      "AND left(TB005,2)<>'41' and TB002<=?XXXX and left(TB002,4)=?MYEAR AND TB001='920' ","TmpGroupData1")<0
			WAIT WINDOWS 'DFDS1' 
			RETURN
		ENDIF 	
		CC=本币余额+QC
		SQLEXEC(CON,"SELECT -1*SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND (left(LE001,2) <>'21' AND left(LE001,2) <>'22') AND left(LE001,2)>'15' "+;
		      "AND left(LE001,2)<>'41' ")		
		QC=XDS
		IF sqlexec(con,"SELECT  -1*SUM(TB004*TB007)  AS 本币余额 "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND (left(TB005,2) <>'21' AND left(TB005,2) <>'22') AND left(TB005,2)>'15' AND left(TB005,2)<>'41'"+;
		      "  and TB002<=?XXXX1 AND LEFT(TB002,4)=?MYEAR1 AND TB001='920'","TmpGroupData1")<0
			WAIT WINDOWS 'DFDS3' 
			RETURN
		ENDIF			
		DD=本币余额+QC
*!*			IF sqlexec(con,"SELECT sum((case when left(LE001,1) in (1,4) then 1 else -1 end)* (LE014-LE017) ) 金额"+;
*!*				"  FROM ACTLE where (left(LE001,2) <>'21' AND left(LE001,2) <>'22') AND left(LE001,2)>'15' AND left(LE001,2)<>'41' and LE002=?MYEAR1 AND LE003<?XF","TMP")<0
*!*				WAIT WINDOWS 'DFDS4' 
*!*				RETURN
*!*			ENDIF
*!*			QC=金额
*!*			DD=	BQ+QC
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='非流动资产' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'非流动资产',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF	

		************订单外库存额
*!*			IF SQLEXEC(CON,"SELECT SUM(TG013*(MB057+MB058+MB059+MB060)) RK FROM MOCTG   "+;
*!*			" INNER JOIN INVMB ON TG004=MB001 INNER JOIN MOCTF ON TF001=TG001 AND TF002=TG002 "+;
*!*			"WHERE TG022='Y' AND TG009=1 AND TF003<=?XXXX   AND "+;
*!*			"EXISTS (select 'x' from MOCTA  INNER JOIN COPMF ON TA033=MF001 AND TA006=MF003 WHERE TG014=TA001 "+;
*!*			"AND TG015=TA002 AND LEFT(MF001,3)<>'227' and MF003>='A' and TA001='511') ","TMP")<0
*!*				WAIT windows '???13' 
*!*			endif	
*!*			IF RECCOUNT()<1 OR ISNULL(RK)
*!*				RK=0
*!*			ENDIF	
*!*			RK1=RK
		
*!*			IF SQLEXEC(CON,"SELECT SUM(TG013*(MB057+MB058+MB059+MB060)) RK FROM MOCTG   "+;
*!*			" INNER JOIN INVMB ON TG004=MB001 INNER JOIN MOCTF ON TF001=TG001 AND TF002=TG002 "+;
*!*			"WHERE TG022='Y' AND TG009=1 AND TF003<=?XXXX   AND "+;
*!*			"EXISTS (select 'x' from MOCTA  INNER JOIN COPMF ON TA033=MF001 AND TA006=MF003 INNER JOIN COPTD ON TA033=RTRIM(TD001)+TD002 WHERE TG014=TA001 "+;
*!*			"AND TG015=TA002 AND LEFT(MF001,3)<>'227' and MF003>='A' and TA001='511' ) ","TMP")<0
*!*				WAIT windows '???13' 
*!*			endif	
*!*			IF RECCOUNT()<1 OR ISNULL(RK)
*!*				RK=0
*!*			ENDIF	
*!*			RK1=RK
		
*!*			IF SQLEXEC(CON,"SELECT SUM(CASE WHEN TD016='y' THEN TD009*(MB057+MB058+MB059+MB060) ELSE TD008*(MB057+MB058+MB059+MB060) END) CH "+;
*!*			"FROM COPTC INNER JOIN COPTD ON TC001=TD001 AND TC002=TD002  "+;
*!*			" INNER JOIN INVMB ON TD004=MB001 WHERE TD021='Y' AND TC003<=?XXXX AND TC027='Y' AND TD004 >='A' AND "+;
*!*			"EXISTS (select 'x' from MOCTG INNER JOIN MOCTA ON TG014=TA001 "+;
*!*			"AND TG015=TA002 INNER JOIN COPMF ON MF001=TA033 AND MF003=TA006 WHERE TA013='Y' AND  TA006=TD004 AND MF001=TD015 )  "+;
*!*			" ","TMP1")<0
*!*				WAIT windows '???12' 
*!*			endif	
*!*			IF RECCOUNT()<1 OR ISNULL(CH)
*!*				CH=0
*!*			ENDIF	
*!*					
*!*			JC1=CH 

*!*			IF SQLEXEC(CON,"SELECT SUM(CASE WHEN Y.TD016='y' THEN Y.TD009*(MB057+MB058+MB059+MB060) ELSE Y.TD008*(MB057+MB058+MB059+MB060) END) CH "+;
*!*			"FROM COPTC INNER JOIN COPTD Y ON TC001=Y.TD001 AND TC002=Y.TD002  "+;
*!*			"INNER JOIN COPTD X ON X.UDF05=RTRIM(Y.TD001)+','+RTRIM(Y.TD002)+','+RTRIM(Y.TD003) "+;
*!*			" INNER JOIN INVMB ON Y.TD004=MB001  WHERE Y.TD021='Y' AND TC003<=?XXXX AND Y.TD004>='A' AND "+;
*!*			"EXISTS (select 'x' from MOCTA INNER JOIN COPMF ON MF001=TA033 AND MF003=TA006 WHERE TA013='Y' AND MF001=X.TD015 AND MF003=X.TD004 and MF003>='A')  "+;
*!*			" ","TMP1")<0
*!*				WAIT windows '???11' 
*!*			endif	
*!*			IF RECCOUNT()<1 OR ISNULL(CH)
*!*				CH1=0
*!*			ELSE
*!*				ch1=ch	
*!*			ENDIF	

*!*			JC1=CH1+JC1
*!*			IF SQLEXEC(CON,"SELECT SUM(CASE WHEN COPMF.MF009<=COPMF.UDF52 THEN COPMF.MF009*(MB057+MB058+MB059+MB060) ELSE COPMF.UDF52*(MB057+MB058+MB059+MB060) END) CH "+;
*!*			"FROM COPMF COPMF INNER JOIN INVMB ON COPMF.MF003=MB001 WHERE LEFT(MF001,3)<>'227'  AND MF008>0 AND MF003>='A' AND "+;
*!*			"EXISTS (select 'x' from MOCTG INNER JOIN MOCTA ON TG014=TA001 "+;
*!*			"AND TG015=TA002 WHERE MF001=TA033 AND MF003=TA006 AND TA013='Y' AND  MOCTG.CREATE_DATE<=?XXXX  )  "+;
*!*			" ","TMP1")<0
*!*				WAIT windows '???12' 
*!*			endif	
*!*			IF RECCOUNT()<1 OR ISNULL(CH)
*!*				CH=0
*!*			ENDIF	
*!*					
*!*			JC1=CH 
*!*			
*!*			DD=RK1-JC1	
&&&&&&&&&&2015.03.28
*!*			SQLEXEC(CON,"SELECT sum(CASE WHEN COPMF.MF009<=COPMF.UDF52 THEN (COPMF.UDF52-COPMF.MF009)*(MB057+MB058+MB059+MB060) ELSE 0 END) CH "+;
*!*			"  FROM COPMF COPMF INNER JOIN INVMB ON COPMF.MF003=MB001 WHERE LEFT(MF001,3)<>'227'  AND MF008>0 AND MF003>='A' AND "+;
*!*			"EXISTS (select 'x' from MOCTG INNER JOIN MOCTA ON TG014=TA001 "+;
*!*			"AND TG015=TA002 WHERE MF001=TA033 AND MF003=TA006 AND TA013='Y' ) ","TMP1")
*!*			DD=CH		
*!*			IF SQLEXEC(CON,"SELECT SUM(TG013*(MB057+MB058+MB059+MB060)) RK FROM MOCTG   "+;
*!*			" INNER JOIN INVMB ON TG004=MB001 INNER JOIN MOCTF ON TF001=TG001 AND TF002=TG002 INNER JOIN "+;
*!*			"MOCTA ON TG014=TA001 AND TG015=TA002  "+;
*!*			" WHERE TG022='Y' AND TG009=1 AND TF003<=?XXXX1 AND TF003>='2011' and LEFT(TA033,3)>='228'","TMP")<0
*!*				WAIT windows '???1' 
*!*			endif	
*!*			IF RECCOUNT()<1 OR ISNULL(RK)
*!*				RK=0
*!*			ENDIF	
*!*			RK1=RK
&&&&&&&&&&&&END
*!*			IF SQLEXEC(CON,"SELECT SUM(TG007*TH015*TH018) RK FROM PURTG INNER JOIN PURTH ON TG001=TH001 AND TG002=TH002 INNER JOIN  PURTD  ON  "+;
*!*			" TD001=TH011 AND TD002=TH012 AND TD003=TH013  "+;
*!*			"WHERE  TG003<=?XXXX1 AND (TD001>='227' OR TD001='220') ","TMP")<0
*!*				WAIT windows '???1' 
*!*			endif	
*!*			IF RECCOUNT()<1 OR ISNULL(RK)
*!*				RK=0
*!*			ENDIF	
*!*			RK1=RK+RK1
&&&&&&&&&&2015.03.28

*!*			IF SQLEXEC(CON,"SELECT SUM(TD009*(MB057+MB058+MB059+MB060) ) CH "+;
*!*			"FROM COPTC INNER JOIN COPTD ON TC001=TD001 AND TC002=TD002 "+;
*!*			" INNER JOIN MOCTA ON TA033=RTRIM(TC001)+TC002 AND TA006=TD004 INNER JOIN INVMB ON TD004=MB001 "+;
*!*			"WHERE TD021='Y' AND TC003<=?XXXX1 AND TC003>='2011' and LEFT(TD015,3)>='228'","TMP1")<0
*!*				WAIT windows '???2' 
*!*			endif	
*!*			IF RECCOUNT()<1 OR ISNULL(CH)
*!*				CH=0
*!*			ENDIF			
*!*			JC1=CH 
*!*			ch1=0
&&&&&&&END		
*!*			IF SQLEXEC(CON,"SELECT SUM(CASE WHEN Y.TD016<>'N' THEN Y.TD009*(MB057+MB058+MB059+MB060) ELSE Y.TD008*(MB057+MB058+MB059+MB060) END) CH "+;
*!*			"FROM COPTC INNER JOIN COPTD Y ON TC001=Y.TD001 AND TC002=Y.TD002  "+;
*!*			"INNER JOIN COPTD X ON X.UDF05=RTRIM(Y.TD001)+','+RTRIM(Y.TD002)+','+RTRIM(Y.TD003) "+;
*!*			" INNER JOIN INVMB ON Y.TD004=MB001  WHERE Y.TD021='Y' AND TC003<=?XXXX1 AND Y.TD004>='A' AND "+;
*!*			"EXISTS (select 'x' from MOCTA INNER JOIN COPMF ON MF001=TA033 AND MF003=TA006 WHERE TA013='Y' AND MF001=X.TD015 AND MF003=X.TD004 and MF003>='A')  "+;
*!*			" ","TMP1")<0
*!*				WAIT windows '???3' 
*!*			endif	
*!*			
*!*			IF RECCOUNT()<1 OR ISNULL(CH)=.t.
*!*				CH1=0.0000000
*!*			ENDIF	
*!*			GO top
*!*			IF ISNULL(CH)=.t.
*!*				ch1=0
*!*			ELSE
*!*					
*!*			ENDIF 	
*!*			ch1=0
*!*			JC1=CH1+JC1
*!*			IF SQLEXEC(CON,"SELECT SUM(CASE WHEN COPMF.MF009>=COPMF.UDF51 THEN COPMF.MF009*(MB057+MB058+MB059+MB060) ELSE COPMF.UDF52*(MB057+MB058+MB059+MB060) END) CH "+;
*!*				"FROM COPMF COPMF INNER JOIN INVMB ON COPMF.MF003=MB001 WHERE LEFT(MF001,3)<>'227' AND MF008>0 AND "+;
*!*				"EXISTS (select 'x' from MOCTG INNER JOIN MOCTA ON TG014=TA001 "+;
*!*				"AND TG015=TA002 WHERE MF001=TA033 AND MF003=TA006 AND TA013='Y' AND  MOCTG.CREATE_DATE<=?XXXX1)","TMP1")<0
*!*				WAIT windows '???12' 
*!*			endif	
*!*			IF RECCOUNT()<1 OR ISNULL(CH)
*!*				CH=0
*!*			ENDIF	
*!*					
*!*			JC1=CH 
		

		IF SQLEXEC(CON,"SELECT SUM(CASE WHEN LA004<=?XXXX1 THEN LA005*LA011*(MB057+MB058+MB059+MB060) END ) CHV, "+;
		"SUM(CASE WHEN LA004<=?XXXX THEN LA005*LA011*(MB057+MB058+MB059+MB060) END ) DDB FROM INVLA  INNER JOIN INVMB ON LA001=MB001 "+;
		"WHERE LA001<'A'","TMP1")<0
			WAIT windows '???2' 
		endif	
			
		DD=DDB 
		cc1  =CHV

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='订单外库存' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?dd,creatdate=getdate(),preval=?cc1  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'订单外库存',?dd,getdate(),?P_USERNAME,?pk)")
		ENDIF
	ENDCASE
WAIT CLEAR 
SQLDISCONNECT(con)
SQLDISCONNECT(con1)

ENDPROC 

PROCEDURE getstatus


CON=ODBC(5)
XTA015=0
tcc=0

IF SQLEXEC(CON,"SELECT DISTINCT pidetail.interid,TD001,TD002,TD003,TD015,TD028,COPTD.UDF05,maininterid,code,statusid,pi.chkid from pidetail  "+;
"inner join COPTD on pidetail.interid=COPTD.UDF56 inner join pi on pi.interid=pidetail.maininterid where pi.statusid<>'结案' ORDER BY 1 DESC ","tmpPIInfo1")<0  &&
     WAIT windows '?PI状态修正5???' nowait&&left join COPTC ON interid=COPTC.UDF55TC027,left join COPTD ON TC001=TD001 AND TC002=TD002AND TD008<TD009 WHERE TD016='N' AND TD008>TD009
	 SQLDISCONNECT(CON)
     RETURN
ENDIF   
*!*	SQLEXEC(CON,"update pidetail set  mf001=LEFT(TD013,4)+'.'+SUBSTRING(TD013,5,2)+'.'+RIGHT(TD013,2),outerbarcode='订单:预计完工日' "+;
*!*	"FROM pidetail inner join COPTD on pidetail.interid=COPTD.UDF56 where TD016='N'")	
SELECT tmpPIInfo1
T1=0 
GO TOP
DO WHILE .NOT. EOF()
	mclassid=TD001
	MBILL =ALLTRIM(TD001)+TD002
	DF=maininterid 
	keyid=DF
	mcode=ALLTRIM(code)
	XCC=interid
	mst=statusid
	mchk=chkid
	tt=''
	SQLEXEC(con,"select interid from pipro where interid=?df")
	IF RECCOUNT()<1
		SQLEXEC(con,"insert into pipro (interid) values (?df)")
	ENDIF 
	SQLEXEC(con,"select interid from pidetailpro where interid=?XCC")
	IF RECCOUNT()<1
		SQLEXEC(con,"insert into pidetailpro (interid) values (?XCC)")
	ENDIF
	SQLEXEC(con,"select top 1 TC003  "+;
	" FROM PURTD D INNER JOIN PURTC ON TC001=D.TD001 AND TC002=D.TD002 INNER JOIN COPTD C ON RTRIM(C.TD001)+C.TD002=D.TD024 AND C.TD003=D.TD023 "+;
	" WHERE D.TD024=?MBILL AND C.TD004=?mcode order by 1 desc") &&and TD004=?mcode
	IF RECCOUNT()=1
		XG=TC003
		SQLEXEC(con,"update pidetailpro set TC003=LEFT(?XG,4)+'.'+SUBSTRING(?XG,5,2)+'.'+RIGHT(?XG,2) where interid=?XCC") &&UDF56=?TT,
	ENDIF
	
	IF mchk=1 AND mst='终审'
		SQLEXEC(con,"select TOP 1 TC003 FROM COPTC WHERE UDF55=?df AND TC027='Y' ORDER BY 1")
		IF LEFT(TC003,1)='2' AND RECCOUNT()=1
			MT=TC003
			SQLEXEC(con,"update pi set statusid='ERP审核' where interid=?df")  &&erpchk=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),
		*ELSE 	
			*SQLEXEC(con,"update pi set statusid='终审' where interid=?df") 
			SQLEXEC(con,"update pidetail set outerbarcode='ERP审核' where maininterid=?df")
		ENDIF	
	ENDIF 		
	*SQLEXEC(con,"update pipro set TA040 ='',TA010='',UDF56='',TC003=''  where interid=?keyid")
	
	SELECT tmpPIInfo1	
	TT1=''
	tcc=1
	IF LEFT(TD015,1)<'1'
		IF EMPTY(UDF05) OR ISNULL(UDF05)
			SQLEXEC(con,"select TOP 1 UDF56,TA010,UDF03,TA033,TA003,TA012 TA038,TA014 TA039, "+;
			"case when TA011='1' then '未生产' WHEN TA011='2' THEN '已发料' when TA011='3' THEN '生产中' when TA011='Y' THEN '已完工' when TA011='y' THEN '指定完工' end 生产状态 "+;
			"FROM MOCTA WHERE TA033=?MBILL AND TA013='Y' AND TA006=?mCode ORDER BY 2 DESC,1 ")
			IF RECCOUNT()>=1
					MT=TA010
					XA003=lEFT(MT,4)+'.'+SUBSTR(MT,5,2)+'.'+RIGHT(MT,2)	
					XTA003=lEFT(TA003 ,4)+'.'+SUBSTR(TA003 ,5,2)+'.'+RIGHT(TA003 ,2)	
					XTA031=lEFT(TA038 ,4)+'.'+SUBSTR(TA038 ,5,2)+'.'+RIGHT(TA038 ,2)	
					XTA032=lEFT(TA039 ,4)+'.'+SUBSTR(TA039 ,5,2)+'.'+RIGHT(TA039 ,2)	

					IF UDF56=0
						TT=LEFT(MT,4)+'.'+SUBSTR(MT,5,2)+'.'+RIGHT(MT,2)	
					ELSE
						TT=LEFT(MT,4)+'.'+SUBSTR(MT,5,2)+'.'+RIGHT(MT,2)	
						TT1=ALLTRIM(UDF03) +'周'
					ENDIF
					xxc='工单:'+ALLTRIM(生产状态)
					SQLEXEC(con,"update pidetail set mf001=?tt,outerbarcode=?xxc where interid=?XCC")
					SQLEXEC(con,"update pidetailpro set TA040 =?XTA003,TA010=?XA003,UDF56=?tt1,TA038=?XTA031,TA039=?XTA032  where interid=?XCC")

					SQLEXEC(con,"update pipro set TA010=?XA003,UDF56=?tt1,TA038=?XTA031,TA039=?XTA032   where interid=?keyid")  &&TA040 =?XTA003,
					SQLEXEC(con,"update pi set statusid=?xxc where interid=?keyid")
					SQLEXEC(con,"select TA017 TG013 FROM MOCTA WHERE TA033=?MBILL AND TA013='Y'  AND TA006=?mCode ")
					IF RECCOUNT()=1 AND !ISNULL(TG013)
						T1=TG013
						SQLEXEC(con,"update COPTD set TD009=?T1 where UDF56=?XCC AND TD021='V'")
					ENDIF	
					tcc=1
			ELSE  	
				SQLEXEC(con,"select TC003,TD012,CASE WHEN TD016='Y' THEN '自动结束' when TD016='y' then '指定结束' else '未结束' end TD,TD015 "+;
				" FROM PURTD INNER JOIN PURTC ON TC001=TD001 AND TC002=TD002 WHERE TD024=?MBILL and TD004=?mcode")
				IF RECCOUNT()>=1
					MT=TD012
					MT1=TC003
					xxc =TD
					xxc='外购:'+ALLTRIM(xxc)
					T1=TD015
					XTA003=lEFT(MT1 ,4)+'.'+SUBSTR(MT1,5,2)+'.'+RIGHT(MT1,2)	

					SQLEXEC(con,"update pidetail set mf001=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),outerbarcode=?xxc where interid=?XCC")
					SQLEXEC(con,"update pipro set "+;
					"TA010=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),TC003=?XTA003,UDF56=?tt1  where interid=?keyid") &&UDF56=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),
					SQLEXEC(con,"update pidetailpro set "+;
					"TA010=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),TA040 =?XTA003,UDF56=?tt1  where interid=?XCC")

					SQLEXEC(con,"update pi set statusid=?xxc where interid=?keyid")
					SQLEXEC(con,"update COPTD set TD009=?T1 where UDF56=?XCC AND TD021='V'")

					tcc=2
				ENDIF
			ENDIF 		
		ELSE
			MBILL=LEFT(UDF05,3)+STREXTRACT(UDF05,',',',',1)
			SQLEXEC(con,"select TOP 1 UDF56,TA010,UDF03,TA033,TA003,TA012 TA038,TA014 TA039 , "+;
			"case when TA011='1' then '未生产' WHEN TA011='2' THEN '已发料' when TA011='3' THEN '生产中' when TA011='Y' THEN '已完工' when TA011='y' THEN '指定完工' end 生产状态 "+;
			"FROM MOCTA WHERE TA033=?MBILL AND TA013='Y' AND TA006=?mCode ORDER BY 2 DESC,1 ")
			IF RECCOUNT()>=1
					MT=TA010
					XA003=lEFT(MT,4)+'.'+SUBSTR(MT,5,2)+'.'+RIGHT(MT,2)	
					XTA003=lEFT(TA003 ,4)+'.'+SUBSTR(TA003 ,5,2)+'.'+RIGHT(TA003 ,2)	
					XTA031=lEFT(TA038 ,4)+'.'+SUBSTR(TA038 ,5,2)+'.'+RIGHT(TA038 ,2)	
					XTA032=lEFT(TA039 ,4)+'.'+SUBSTR(TA039 ,5,2)+'.'+RIGHT(TA039 ,2)	
					SQLEXEC(con,"update pipro set TA010=?XA003 where interid=?keyid") && TA040 =?XTA003,
					IF UDF56=0
						TT=LEFT(MT,4)+'.'+SUBSTR(MT,5,2)+'.'+RIGHT(MT,2)	
					ELSE
						TT1=ALLTRIM(UDF03) +'周'
					ENDIF
					xxc='借工单:'+ALLTRIM(生产状态)
					SQLEXEC(con,"update pidetail set mf001=?tt,outerbarcode=?xxc where interid=?XCC")
					SQLEXEC(con,"update pipro set UDF56=?tt1,TA038=?XTA031,TA039=?XTA032  where interid=?keyid")
					SQLEXEC(con,"update pidetailpro set UDF56=?tt1,TA038=?XTA031,TA039=?XTA032  where interid=?XCC")
					SQLEXEC(con,"update pi set statusid=?xxc where interid=?keyid")
					tcc=1
			ELSE  	
				SQLEXEC(con,"select TOP 1 TD012 TC003,CASE WHEN TD016='Y' THEN '自动结束' when TD016='y' then '指定结束' else '未结束' end TD,TD012,TD015 "+;
				" FROM PURTD INNER JOIN PURTC ON TC001=TD001 AND TC002=TD002 WHERE TD024=?MBILL AND TC014='Y' and TD004=?mcode ORDER BY 1 DESC")
				IF RECCOUNT()=1
					MT=TD012
					xxc =TD
					xxc='借外购:'+ALLTRIM(xxc)
					T1=TD015
					MT1=TC003
					XTA003=lEFT(MT1 ,4)+'.'+SUBSTR(MT1,5,2)+'.'+RIGHT(MT1,2)	
					SQLEXEC(con,"update pidetail set mf001=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),outerbarcode=?xxc where interid=?XCC")
					SQLEXEC(con,"update pipro set "+;
					"TA010=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),TC003=?XTA003,UDF56=?tt1  where interid=?keyid")
					SQLEXEC(con,"update pidetailpro set "+;
					"TA010=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),TA040 =?XTA003,UDF56=?tt1 where interid=?XCC")
					
					SQLEXEC(con,"update pi set statusid=?xxc where interid=?keyid")
					tcc=2
				ENDIF
			ENDIF 
		ENDIF	

	ELSE 
		*mbill=TD015
		SQLEXEC(con,"select TOP 1 UDF56,TA010,UDF03,TA033,TA015,TA003,LEFT(TA010,4)+'.'+DATENAME( Wk,CAST(TA010 AS DATETIME)) AS ZC ,TA012 TA038,TA014 TA039 ,"+;
		"case when TA011='1' then '未生产' WHEN TA011='2' THEN '已发料' when TA011='3' THEN '生产中' when TA011='Y' THEN '已完工' when TA011='y' THEN '指定完工' end 生产状态 "+;
		"FROM MOCTA WHERE TA033=?MBILL AND TA013='Y' AND TA006=?mCode")
		IF RECCOUNT()>=1
			MT=TA010
			XA003=lEFT(MT,4)+'.'+SUBSTR(MT,5,2)+'.'+RIGHT(MT,2)	
			XTA003=lEFT(TA003 ,4)+'.'+SUBSTR(TA003 ,5,2)+'.'+RIGHT(TA003 ,2)	
			XTA031=lEFT(TA038 ,4)+'.'+SUBSTR(TA038 ,5,2)+'.'+RIGHT(TA038 ,2)	
			XTA032=lEFT(TA039 ,4)+'.'+SUBSTR(TA039 ,5,2)+'.'+RIGHT(TA039 ,2)	
			SQLEXEC(con,"update pipro set TA010=?XA003 where interid=?keyid")  &&TA040 =?XTA003,
			xxc='重工单:'+ALLTRIM(生产状态)

			TT1=ALLTRIM(ZC) +'周'
			XTA015=TA015
			SQLEXEC(con,"update pidetail set mf001=?tt,outerbarcode=?xxc  where interid=?XCC")
			SQLEXEC(con,"update pipro set UDF56=?tt1,TA038=?XTA031,TA039=?XTA032  where interid=?keyid")
			SQLEXEC(con,"update pidetailpro set UDF56=?tt1,TA038=?XTA031,TA039=?XTA032  where interid=?XCC")			
			SQLEXEC(con,"update pi set statusid=?xxc where interid=?keyid")
			tcc=3
		ELSE  	
			SQLEXEC(con,"select TOP 1 CASE WHEN TD016='Y' THEN '自动结束' when TD016='y' then '指定结束' else '未结束' end TD,TD012,TD015,TC003 "+;
			",LEFT(TD012,4)+'.'+DATENAME( Wk,CAST(TD012 AS DATETIME)) AS ZC ,"+;
			" FROM PURTD INNER JOIN PURTC ON TC001=TD001 AND TC002=TD002 WHERE TD024=?MBILL AND TC014='Y' and TD004=?mcode ORDER BY 2 DESC")
			IF RECCOUNT()=1
				MT1=ALLTRIM(ZC)+'周'
				XTA003=lEFT(TC003  ,4)+'.'+SUBSTR(TC003 ,5,2)+'.'+RIGHT(TC003 ,2)	
				MT=TD012
				xxc='调外购:'+ALLTRIM(TD)
				SQLEXEC(con,"update pidetail set mf001=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),outerbarcode=?xxc  where interid=?XCC")
				SQLEXEC(con,"update pidetailpro set "+;
					"TA010=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),TA040 =?XTA003,UDF56=?tt1 where interid=?XCC")				
				SQLEXEC(con,"update pipro set "+;
				"TA010=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),TC003=?XTA003,UDF56=?tt1  where interid=?keyid")  &&UDF56=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),
				SQLEXEC(con,"update pi set statusid=?xxc where interid=?keyid")
				tcc=2
			ENDIF
		ENDIF 
	ENDIF 	&&ERP审批
	T1=0	
	IF tcc=1
		SQLEXEC(con,"select TA017 TG013 FROM  MOCTA WHERE TA033=?MBILL AND TA013='Y' AND  TA006=?mCode")
		IF RECCOUNT()=1 AND !ISNULL(TG013)
			T1=TG013
		ENDIF	
	ENDIF	
	IF tcc=2
		SQLEXEC(con,"select TD015 TG013 FROM PURTD WHERE TD024=?MBILL AND TD018='Y' and TD004=?mcode")
		IF RECCOUNT()=1 AND !ISNULL(TG013)
			T1=TG013
		ENDIF	
	ENDIF	
	IF tcc=3
*!*			SQLEXEC(con,"select SUM(TG013*TG009) TG013 FROM MOCTG INNER JOIN MOCTA ON TG014=TA001 AND TG015=TA002 "+;
*!*				"WHERE TA033=?MBILL AND TA013='Y' AND (TA021='05' OR TA021='11') AND TG004=?mCode ")
*!*			IF RECCOUNT()=1 AND !ISNULL(TG013)
*!*				T1=TG013
*!*			ENDIF	
		SQLEXEC(con,"select SUM(MF008-MF009) TG013  FROM COPMF WHERE MF001=?MBILL AND MF003=?mCode ")
		IF RECCOUNT()=1 AND !ISNULL(TG013)
			T1=TG013+XTA015
		ENDIF	
	ENDIF	
	SQLEXEC(con,"update pidetail set tppcs=?t1 where interid=?XCC")


	IF Sqlexec(con,"select   left(COPTF.CREATE_DATE ,8) CDATE "+;
		"from COPTF INNER JOIN COPTD ON TD001=TF001 AND TD002=TF002 AND TD003=TF004 where COPTD.UDF56=?XCC","TMP1")<0
		WAIT WINDOW '?PI状态修正F6??'  && NOWAIT 
	ENDIF 
	IF RECCOUNT()>=1
		MT=CDATE  
		SQLEXEC(con,"update pipro set TE004=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+SUBSTRING(?MT,7,2)  where interid=?keyid")
		SQLEXEC(con,"update pidetailpro set TE004=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+SUBSTRING(?MT,7,2)  where interid=?XCC")			

	ELSE	
		*SQLEXEC(con,"update pipro set TE004='' where interid=?keyid")
	endif
	IF mclassid<='226' AND mclassid<>'220'
	
		IF SQLEXEC(CON,"SELECT CASE WHEN AA.TA100='1' then '1.未核销' when  AA.TA100='2' then '2.部分核销' when AA.TA100='3' then '3.已核销'   end  AS 核销状态,"+;
			"CASE WHEN EA.TA003 >'1' then CONVERT(VARCHAR(10),CAST(EA.TA003 AS DATETIME),102)  END AS 出货通知日期,"+;
			"case when TG003 IS NOT NULL THEN CONVERT(VARCHAR(10),CAST(TG003 AS DATETIME),102)  end 销货,"+;
	     	"case when AA.TA003 IS NOT NULL THEN CONVERT(VARCHAR(10),CAST(AA.TA003 AS DATETIME),102)  END  发票,TD008-TD009 as  SY FROM COPTD LEFT JOIN COPTH ON "+;
				" TD001=TH014 AND TD002=TH015 AND TD003=TH016 LEFT JOIN COPTG ON TH001=TG001 AND TH002=TG002 LEFT JOIN EPSTB EB ON TD001=EB.TB004 AND TD002=EB.TB005 AND TD003=EB.TB006 "+;
				"LEFT JOIN EPSTA EA ON EA.TA001=EB.TB001 AND EA.TA002=EB.TB002 LEFT JOIN ACRTB AB ON TH001=AB.TB005 and TH002=AB.TB006  and TH003=AB.TB007 "+;
				"LEFT JOIN ACRTA AA ON AA.TA001=AB.TB001 AND AA.TA002=AB.TB002 WHERE COPTD.UDF56=?XCC ORDER BY 1","TMP1")<0 &&结关日期
		    WAIT windows 'EPSTA ???PI状态修正?11'  && NOWAIT 
	    ENDIF 	
	    SELECT TMP1
	    IF RECCOUNT()>=1
	    	GO TOP  
			XXXX1  =销货
			YY2='出货通知'

			IF SY=0
				YY1='销货:全部'
			ELSE
				YY1='销货:部分'
			ENDIF	    	
			XXXX=发票
			YY=核销状态
			XXXX2  =出货通知日期

			IF  !EMPTY(核销状态) AND 1=2

				SQLEXEC(con,"update pi set statusid=?yy  where interid=?keyid")
			ELSE
				IF 销货>='1'
					SQLEXEC(con,"update pi set statusid=?YY1 where interid=?keyid")				
				ELSE
					IF 出货通知日期>='1'
						SQLEXEC(con,"update pi set statusid=?YY2 where interid=?keyid")
					ELSE
						SQLEXEC(CON,"update pidetail set  mf001=LEFT(TD013,4)+'.'+SUBSTRING(TD013,5,2)+'.'+RIGHT(TD013,2),outerbarcode='订单:预计完工日' "+;
						"FROM pidetail inner join COPTD on pidetail.interid=COPTD.UDF56 where interid=?XCC and (statusid='终审' or statusid='')")	
			   		ENDIF &&	开票   
				ENDIF  &&销货
			ENDIF  &&销货
			IF LEFT(xxxx2,1)>='2'
				SQLEXEC(con,"update pipro set ETA003=?XXXX2  where interid=?keyid")
				SQLEXEC(con,"update pidetailpro set ETA003=?XXXX2 where interid=?XCC")			

				SQLEXEC(con,"update pidetail set mf001=?XXXX2,outerbarcode=?YY2 where interid=?XCC")
			ENDIF 

			IF LEFT(xxxx1,1)>='2'
				SQLEXEC(con,"update pipro set CTG003=?XXXX1  where interid=?keyid")
				SQLEXEC(con,"update pidetailpro set CTG003=?XXXX1 where interid=?XCC")			
				
				SQLEXEC(con,"update pidetail set mf001=?XXXX1,outerbarcode=?YY1 where interid=?XCC")
			ENDIF 
			IF LEFT(xxxx,1)>='2'
				SQLEXEC(con,"update pipro set ATA003=?XXXX,ATA100=?yy where interid=?keyid")
				SQLEXEC(con,"update pidetailpro set ATA003=?XXXX,ATA100=?yy  where interid=?XCC")			
				
				SQLEXEC(con,"update pidetail set mf001=?XXXX,innerbarcode=?YY where interid=?XCC")	
			ENDIF 
		ENDIF	
	ENDIF 

	IF SQLEXEC(CON,"SELECT SUM(quan) quan,SUM(price*quan*pi.rate*discount/100) as cash ,SUM(case when price*pi.rate*quan*discount/100-stprice*quan is null then 0 else "+;
		"price*pi.rate*quan*discount/100-stprice*quan end) a11,sum(CASE WHEN MF019 IS NULL OR MF019=0 THEN 0 ELSE MF009/3600+(MF010/MF019/3600)*quan END) gs FROM pidetail INNER JOIN INVMB ON code = MB001 "+;
		" LEFT JOIN BOMMF ON MB010=MF001 AND MB011=MF002 AND (MF005='1' OR MF005 IS NULL) inner join pi on pi.interid=pidetail.maininterid where pidetail.interid=?XCC","tmpdetaifl")<0
		WAIT windows '???d???PI状态修正????'
	ENDIF 	
	a2=cash
	cdsd=quan
	gggs=gs
	XCX=A11
	IF a2<>0
		lv=xcx/a2*100
	ELSE
		lv=0
	ENDIF 	
	IF  mchk=0
		IF a2<>0 
			SQLEXEC(con,"update pidetailpro set profit=?xcx,profitrate=?lv,quan=?cdsd,worktime=?gggs where interid=?XCC ")
		ELSE
			SQLEXEC(con,"update pidetailpro set quan=?cdsd,worktime=?gggs where interid=?XCC")
		ENDIF 
	ENDIF 
	IF SQLEXEC(con,"select SUM(p.long*p.width*p.deep*p.boxnum)/1000000 vol,SUM(p.weight*pd.quan) net,SUM(case when p.wet is null then 0 else p.wet*pd.quan end) wet,"+;
	"SUM(case when p.boxnum is null then 0 else p.boxnum end ) boxnum FROM pidetail pd  "+;
	"inner join packageinfo p on p.interid=pd.interid  where pd.interid=?XCC","TMP")<0
		WAIT windows '??????PI状态修正????'
	ENDIF 	
	IF RECCOUNT()=1 AND !ISNULL(vol)

		xx=net
		IF !ISNULL(WET)
			yy=wet
		ELSE
			YY=0
		ENDIF	
		vold=vol
		IF ISNULL(boxnum)
			mbox=0
		else
			mbox=boxnum
		ENDIF 
	ELSE 	

		mbox=0
		vold=0
		xx =0
		yy=0
	ENDIF 
	SQLEXEC(con,"update pidetailpro set box=?mbox,vol=?vold,net=?xx,wet=?yy  where interid=?XCC")

	SELECT tmpPIInfo1
   	SKIP
ENDDO

SQLEXEC(CON,"update pidetail set outerbarcode=CASE WHEN TD016='Y' THEN '订单:自动结束' when TD016='y' then '订单:指定结束' WHEN TD008<=TD009 THEN '订单:自动结束' end "+;
"FROM pidetail inner join COPTD on pidetail.interid=COPTD.UDF56 where TD016<>'N' ")	

IF SQLEXEC(CON,"SELECT classid,interid from pi INNER JOIN COPTC ON interid=UDF55 where statusid<>'结案' ","tmpPIInfo1")<0
     WAIT windows '??PI状态修正7??' &&left join COPTC ON interid=COPTC.UDF55TC027,left join COPTD ON TC001=TD001 AND TC002=TD002AND TD008<TD009 WHERE TD016='N' AND TD008>TD009
	 SQLDISCONNECT(CON)
     RETURN
ENDIF 
SELECT tmpPIInfo1
DO WHILE .NOT. EOF()
	XX=interid 
	mclassid=classid
	SQLEXEC(CON,"SELECT interid,TD008 from pidetail inner join COPTD ON interid=UDF56 where ((outerbarcode<>'订单:自动结束' and outerbarcode<>'订单:指定结束' and outerbarcode is not null "+;
	" AND outerbarcode <>'3.已核销') or outerbarcode is null or outerbarcode='') and maininterid=?XX and TD008<>0","TNO")
	IF RECCOUNT()<1
		SQLEXEC(con,"update pi set statusid='结案' where interid=?xx and chkid=1")
	ENDIF 
	IF mclassid>='227' OR mclassid='220'
		SQLEXEC(CON,"SELECT interid,TD008 from pidetail inner join COPTD ON interid=UDF56 where ((outerbarcode<>'工单:已完工' and outerbarcode<>'工单:指定完工') "+;
		" or outerbarcode is null or outerbarcode='') and maininterid=?XX and TD008<>0","TNO")
		IF RECCOUNT()<1
			SQLEXEC(con,"update pi set statusid='预测已完工' where interid=?xx and chkid=1")
		ENDIF 
		SQLEXEC(CON,"SELECT interid,TD008 from pidetail inner join COPTD ON interid=UDF56 where TD008>TD009 and maininterid=?XX and TD008<>0","TNO")
		IF RECCOUNT()<1
			SQLEXEC(con,"update pi set statusid='结案' where interid=?xx and chkid=1")
		ENDIF 
	ENDIF 		
	IF SQLEXEC(CON,"SELECT SUM(quan) quan,SUM(price*quan*pi.rate*discount/100) as cash ,SUM(case when price*pi.rate*quan*discount/100-(INVMB.MB057+INVMB.MB058+INVMB.MB059+INVMB.MB060)*quan is null then 0 else "+;
	"price*pi.rate*quan*discount/100-(INVMB.MB057+INVMB.MB058+INVMB.MB059+INVMB.MB060)*quan end) a11,"+;
	"sum(CASE WHEN MF019 IS NULL OR MF019=0 THEN 0 ELSE (MF010/MF019/3600)*quan END) gs FROM pidetail INNER JOIN INVMB ON code = MB001 "+;
	" LEFT JOIN BOMMF ON MB010=MF001 AND MB011=MF002 AND (MF005='1' OR MF005 IS NULL) inner join pi on pi.interid=pidetail.maininterid where maininterid=?xx","tmpdetaifl")<0
		brow
		WAIT windows '???d???PI状态修正????'  &&MF009/3600+
	ENDIF 	
	SELECT tmpdetaifl
	a2=cash
	cdsd=quan
	gggs=gs
	XCX=A11
	IF a2<>0
		lv=xcx/a2*100
	ELSE
		lv=0
	ENDIF 	
	IF mclassid<='226'and mclassid<>'220'
		SQLEXEC(con,"update pipro set quan=?cdsd,worktime=?gggs where interid=?XX")  &&profit=?xcx,profitrate=?lv,
	ELSE
		SQLEXEC(con,"update pipro set quan=?cdsd,worktime=?gggs where interid=?XX")
	ENDIF 


	SELECT tmpPIInfo1
	SKIP
ENDDO


SQLDISCONNECT(CON)
ENDPROC 

PROCEDURE tzl
TRY
TS1=odbc(5)
IF SQLEXEC(TS1,"SELECT login_time,CAST(hostname as char(20)) as hostname,CAST(program_name as char(20)) as program_name,"+;
	"cmd,CAST(nt_username as char(20)) as username,CAST(loginame as char(15)) as login,net_library,net_address FROM master..sysprocesses "+;
	"where  program_name like 'Microsoft SQL Server%' and hostname <>'TS2' AND loginame ='sa'  and hostname <>'LUHONGBIN' ORDER BY 1 DESC ","TEffffMP")<0  &&(cmd like 'DELETE%' OR cmd LIKE 'UPDATE%') AND
	SQLDISCONNECT(TS1) && and hostname <>'TS2'
ELSE 
	SELECT TEffffMP
	tata=RECCOUNT()
	DO WHILE .NOT. EOF() &&and hostname <>'IBM-F830B3770FA' 
		m_Note='主机:'+ALLTRIM(hostname)+CHR(13)+CHR(10)+'登录账户:'+ALLTRIM(login)+CHR(13)+CHR(10)+'登录时间:'+TTOC(login_time)+CHR(13)+CHR(10)+'命令状态:'+ALLTRIM(cmd)+CHR(13)+CHR(10)+'网卡:'+ALLTRIM(net_address)+CHR(13)+CHR(10)+'NT用户名:'+ALLTRIM(TRANSFORM(username))+CHR(13)+CHR(10)+'连接方式:'+ALLTRIM(net_library)
		m_Note=m_Note+CHR(13)+CHR(10)+'助手和ERP相关的处理表放在该服务器上,此人已经完全控制公司ERP数据库,可以任意修改删除数据,已经超出公司授予本人管理权限.'

		mtitle='有人控制ERP服务器'
		mrev='鲁红斌;陈调凤;王文雅;万里斌;周洪;陈彬;'
		CON11=ODBC(6)
		SQLEXEC(CON11,"SELECT interid FROM rtxmessage WHERE note=?m_Note")
		SQLDISCONNECT(CON11)
		IF RECCOUNT()<1&&Cmd='AWAITING COMMAND' AND (Hostname='LENOVO-ZHOUHONG' OR Hostname='OA' OR Hostname='ERP')
			tmpkeyid=maxinterid("rtxmessage")
			TS12=odbc(6)
			SQLEXEC(TS12,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_Note,?mtitle,102)")
			SQLDISCONNECT(TS12)
		ENDIF
		SELECT  TEffffMP
		SKIP
	ENDDO			
ENDIF 
SQLEXEC(TS1,"select COUNT(*) AS X,UDF56 FROM COPMF WHERE UDF56>0 GROUP BY UDF56 HAVING COUNT(*)>1","TMtime1P")
IF RECCOUNT()<1
	SQLEXEC(TS1,"select COUNT(*) AS X,UDF56 FROM COPTD WHERE UDF56>0 GROUP BY UDF56 HAVING COUNT(*)>1","TMtime1P")
ENDIF
SQLDISCONNECT(TS1)
SELECT TMtime1P
IF RECCOUNT()>=1
	XX1=MF001
	XX2=ALLTRIM(STR(INT(UDF56)))
	xx3='%'+xx1+',关键字:'+xx2+'%'
	TS1=odbc(5)
	IF SQLEXEC(TS1,"SELECT login_time,CAST(hostname as char(20)) as hostname,CAST(program_name as char(20)) as program_name,"+;
		"cmd,CAST(nt_username as char(20)) as username,CAST(loginame as char(15)) as login,net_library,net_address FROM master..sysprocesses "+;
		"where program_name<>'易飞ERP系统' and program_name<>'' and program_name not like 'SQLAgent%' and program_name<>'OA助手'"+;
		" and hostname <>'LHB-PC' and program_name<>'易飞ERP助手' and program_name<>'Microsoft Visual Fox' and "+;
		"program_name<>'Symantec Backup Exec' and program_name<>'YiFei' and  program_name not like 'Lumigent%'  ORDER BY 1 desc ","TEffffMP")<0
		SQLDISCONNECT(TS1) && and hostname <>'TS2'
	ELSE 
		SELECT TEffffMP
		tata=RECCOUNT()
		IF tata>=1 &&and hostname <>'IBM-F830B3770FA' 
			m_Note=TTOC(DATETIME())+'报告,预测订单:'+xx1+',关键字:'+xx2+',重复设置'+CHR(13)+CHR(10)+'目前:'+ALLTRIM(STR(tata,3))+'个连接到ERP数据库，'+'可疑主机:'+CHR(13)+CHR(10)
			GO TOP
			DO WHIL .NOT. EOF()
				m_Note=m_Note+ALLTRIM(hostname)+CHR(13)+CHR(10)+'登录账户:'+ALLTRIM(login)+CHR(13)+CHR(10)+'程序名:'+ALLTRIM(program_name)+CHR(13)+CHR(10)+'命令状态:'+ALLTRIM(cmd)+CHR(13)+CHR(10)+'网卡:'+ALLTRIM(net_address)+CHR(13)+CHR(10)+'NT用户名:'+ALLTRIM(username)+CHR(13)+CHR(10)+'连接方式:'+ALLTRIM(net_library)
				SKIP
			ENDDO	
		ELSE 
			m_Note=TTOC(DATETIME())+'报告,预测订单:'+xx1+',关键字:'+xx2+',重复设置'+CHR(13)+CHR(10)+'没有截获到恶意操作主机信息，黑客已经中断连接!'
		ENDIF 	

		TS1=odbc(6)
		SQLEXEC(TS1,"SELECT interid FROM rtxmessage WHERE  mtitle='预测订单数据被修改的致命问题' and note like ?xx3","TEffffMP")
		SQLDISCONNECT(TS1)			
		IF RECCOUNT()<1
			mtitle='预测订单数据被修改的致命问题'
			mrev='鲁红斌;陈调凤;周洪;万里斌;陈彬;王文雅;'

			tmpkeyid=maxinterid("rtxmessage")
*!*				TS1=odbc(6)
*!*				SQLEXEC(TS1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_Note,?mtitle,0)")
*!*				SQLDISCONNECT(TS1)
		ENDIF 	
	ENDIF 
ENDIF

IF USED("TEffffMP")
	SELECT TEffffMP
	USE
ENDIF 	
IF USED("TMtime1P")
	SELECT TMtime1P
	USE
ENDIF 
CATCH
ENDTRY	
ENDPROC 


PROCEDURE coptcw
*IF TIME()>'08:10' AND TIME()<='23:00'
	lu=1
	CON=ODBC(6)
	SQLEXEC(CON,"SELECT item from defaultval where name='COPTC读取时间'","TMP")
	SELECT tmp
	FEND=CTOT(LEFT(item,19))-36000*3
	FEND1=TTOC(CTOT(LEFT(item,19))-36000*3,1)
	SQLDISCONNECT(CON)
	CON=ODBC(5)
	
	IF sQLEXEC(con,"SELECT CAST(TB007 AS CHAR(35)) TB007,"+;
		"CASE WHEN  TB002='0' THEN '修改' WHEN TB002='1' THEN '新增' WHEN  TB002='2' THEN '删除' WHEN TB002='A' THEN '审核' WHEN TB002='B' THEN '取消审核' "+;
		"WHEN TB002='3' THEN '执行SQL' ELSE '无' END AS TB002,V1.MV002,TB006,V2.MV002 as MV001,TC015,MA002,TC200,MA028,TB001,TC012,COPTC.UDF55,COPTC.TC003,"+;
		"CAST(COPMA.UDF06 as char(50)) AS GDY,SUBSTRING(MB004,1,3)+LTRIM(substring(TB005,5,3)) AS TABLENAME,TB005,COPTC.UDF55  "+;
		"FROM ADMTB LEFT JOIN DSCSYS..ADMMB as ADMMB ON TB003=ADMMB.MB001 LEFT JOIN CMSMV V1 ON TB004=V1.MV001 INNER JOIN COPTC ON TB007 like RTRIM(TC001)+'-'+RTRIM(TC002)+'%'  "+;
		"LEFT JOIN COPMA ON TC004=MA001 LEFT JOIN CMSMV V2 ON TC006=V2.MV001 WHERE (LEFT(MB001,3)='COP' OR MB002='录入客户订单(耀华70)') "+;
		"AND ((TB001='1' and TB002='1') OR TB001='2') AND TB006>?fend  and TB005 not like '%单身共  0笔%' ORDER BY 1","TMP")<0 && AND TB002='1'  &&(MB001='COPMI06' OR MB001='COPI06') and TC005<>'512'
		SQLDISCONNECT(con)
		RETURN 
	ENDIF 

	SQLDISCONNECT(con)
	SELECT TMP
	IF USED("TMP1")	
		SELECT TMP1
		USE
	ENDIF
	SELECT * FROM TMP WHERE TB001='2' INTO CURSOR TMP1 	READWRITE 
	XD=''

	SELECT TMP1
	IF RECCOUNT()>=1
		XD=''
		mrev=''
		t=''
		GD=''
		GO TOP
		DO WHIL .NOT. EOF()
			MUDF55=UDF55
			MTC003=TC003
			XUDF55=UDF55
			
			MT=TTOC(TB006)
			sh=ALLTRIM(TB002)
*!*				IF SH='取消审核'
*!*					MT=''
*!*				ENDIF	
			IF UDF55>0
				con=odbc(5)
				IF SH='取消审核'
					SQLEXEC(con,"update pi set statusid=?sh where interid=?XUDF55")
				ELSE
					SQLEXEC(con,"update pi set statusid='ERP审核' where interid=?XUDF55")
				ENDIF	
				SQLDISCONNECT(con)
			ENDIF
			SELECT TMP1
*!*				IF !ISNULL(MV001)
*!*					IF MV001<>MV002
*!*						IF ALLTRIM(MV002)$mrev=.F. AND ALLTRIM(MV001)$mrev=.F. 
*!*							mrev=mrev+ALLT(MV001)+';'+ALLTRIM(MV002)+';'
*!*						ENDIF	
*!*						IF ALLTRIM(MV002)$mrev=.F.
*!*							mrev=mrev+ALLT(MV002)+';'
*!*						ENDIF	
*!*						IF ALLTRIM(MV001)$mrev=.F.
*!*							mrev=mrev+ALLT(MV001)+';'
*!*						ENDIF	
*!*					ELSE
*!*						IF ALLTRIM(MV002)$mrev=.F.
*!*							mrev=mrev+ALLT(MV001)+';'
*!*						ENDIF 	
*!*					ENDIF 
*!*				ELSE
*!*					mrev=''
*!*				ENDIF 
*!*				mGDY=ALLTRIM(GDY)
*!*				X=1

*!*				Y=OCCURS('Y', MGDY)
*!*				Z=''
*!*				IF Y=0
*!*					MGDY=''
*!*				ELSE
*!*					DO WHIL X<=Y
*!*						Z1=SUBSTR(MGDY,AT('Y',MGDY,X),6)
*!*						con=odbc(5)
*!*						SQLEXEC(CON,"SELECT MV002 FROM CMSMV WHERE MV001=?Z1","TMDDDD")
*!*						SQLDISCONNECT(con)
*!*						IF RECCOUNT()=1
*!*							IF ALLTRIM(MV002)$mrev=.F.
*!*								Z=Z+ALLTRIM(MV002)+';'
*!*							ENDIF 	
*!*						ENDIF	
*!*						X=X+1
*!*					ENDDO
*!*				ENDIF
*!*				IF USED("TMDDDD")
*!*					SELECT TMDDDD
*!*					USE 
*!*				ENDIF 	
*!*				mGDY=ALLTRIM(Z)
*!*				mrev=mrev+mGDY
			SELECT TMP1
			JIAOQ=''

			*IF ISNULL(TC015) OR EMPTY(TC015)
				SELECT TMP1
				xxx1x='%'+aLLTRIM(TB007)+ALLTRIM(MV002)+'于'+TTOC(TB006)+ALLTRIM(TB002)+'%'
				CON3=ODBC(6)
				SQLEXEC(CON3,"SELECT 'X' FROM rtxmessage where note like ?xxx1x and title like '%单子已审核%'")
				SQLDISCONNECT(CON3)
				IF RECCOUNT()<1
					SELECT TMP1

						CON=ODBC(5)
						SQLEXEC(con,"select top 1 pi.classid from pidetail inner join pi on pi.interid=pidetail.maininterid where maininterid=?MUDF55 and mf002='N' and code>='A' AND LEFT(code,1)<>'X'")
						IF RECCOUNT()=1 AND classid='223'
							IF '黄艳'$mrev=.F.
								mrev=mrev+'黄艳;'
							ENDIF				
						ENDIF
					SELECT TMP1
					XD=XD+ALLTRIM(STR(lu))+'.'+ALLT(MA002)+JIAOQ+','+ALLTRIM(TB007)+ALLTRIM(MV002)+'于'+TTOC(TB006)+ALLTRIM(TB002)+CHR(13)+CHR(10)
					lu=lu+1
				ENDIF 
			*ELSE	
			*	XD=XD+ALLTRIM(STR(RECNO()))+'.'+ALLT(MA002)+JIAOQ+','+ALLTRIM(TB007)+ALLTRIM(MV002)+'于'+TTOC(TB006)+ALLTRIM(TB002)+CHR(13)+CHR(10)
			*XD=XD+ALLTRIM(STR(RECNO()))+'.'+ALLT(MA002)+JIAOQ+','+ALLTRIM(TB007)+'(注:'+ALLTRIM(TC015)+')'+ALLTRIM(MV002)+'于'+TTOC(TB006)+ALLTRIM(TB002)+CHR(13)+CHR(10)
			*ENDIF
			SELECT TMP1
			IF UDF55>0
				CON=ODBC(5)
				SQLEXEC(con,"select top 1 pi.classid from pidetail inner join pi on pi.interid=pidetail.maininterid where maininterid=?MUDF55 and mf002='N' and code>='A' AND LEFT(code,1)<>'X'")

				SQLEXEC(con,"select interid from pipro where interid=?MUDF55")
				IF RECCOUNT()<1
					SQLEXEC(con,"insert into pipro (interid ) values (?MUDF55)")
				ENDIF
				SQLEXEC(con,"update pipro set erpchk=?mt  where interid=?MUDF55 and (erpchk>=?mt or erpchk is null or erpchk='')")
				SQLEXEC(con,"update pipro set TE004=?mt  where interid=?MUDF55 and (TE004 is null or TE004='' or TE004<=?mt)")

				SQLDISCONNECT(CON)
			ENDIF 
			SELECT TMP1
			SKIP
		ENDDO	
*!*			IF '王文雅'$mrev=.F.
*!*				mrev=mrev+'王文雅;'
*!*			ENDIF
		IF ISNULL(mver)
			mver=''
		ENDIF 
*!*			IF '张国兰'$mrev=.F.
*!*				mrev=mrev+'张国兰;许恒军;'
*!*			ENDIF
			*mrev=mrev+'许恒军;陈冲俞;'

&&		mrev=mrev&&'申屠晓萍;王家君;彭秀娟;陈冲俞;于秀梅;屠青青;王亚萍;罗茜;黄远琼;王丽丽;许恒军;'
		mtitle=TTOC(DATETIME())+':ERP订单有['+ALLTRIM(STR(lu-1))+']张单子已审核'

		m_note=XD
		IF LEN(m_note)>10
			IF LEN(ALLTRIM(m_note))<1500
*				m_note=LEFT(m_note,2000)
				tmpkeyid=maxinterid("rtxmessage")
				keyidid1=ODBC(6)
				IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,4)")<0
					WAIT windows '?PI状态修正3???' nowait
				ENDIF 

			ELSE
				m_note1=LEFT(m_note,1500)
				m_note2=ALLTRIM(SUBSTR(m_note,1501,2000))
				tmpkeyid=maxinterid("rtxmessage")
				keyidid1=ODBC(6)
				IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note1,?mtitle,4)")<0
					WAIT windows '?PI状态修正3???' nowait
				ENDIF 
				SQLDISCONNECT(keyidid1)
				tmpkeyid=maxinterid("rtxmessage")
				keyidid1=ODBC(6)
				IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note2,'续上面的通知',4)")<0
					WAIT windows '?PI状态修正3???' nowait
				ENDIF 
			ENDIF	
			SQLDISCONNECT(keyidid1)
		ENDIF
	ENDIF 
	
ENDPROC 	


PROCEDURE coptc
IF TIME()>'08:10' AND TIME()<='23:00'

	lu=1
	CON=ODBC(6)
	SQLEXEC(CON,"SELECT item from defaultval where name='COPTC读取时间'","TMP")
	SELECT tmp
	FEND=CTOT(LEFT(item,19))-1800
	FEND1=TTOC(CTOT(LEFT(item,19))-1800,1)
	SQLDISCONNECT(CON)
	TRY
	CON=ODBC(5)
	
	IF sQLEXEC(con,"SELECT CAST(TB007 AS CHAR(35)) TB007,"+;
		"CASE WHEN  TB002='0' THEN '修改' WHEN TB002='1' THEN '新增' WHEN  TB002='2' THEN '删除' WHEN TB002='A' THEN '审核' WHEN TB002='B' THEN '取消审核' "+;
		"WHEN TB002='3' THEN '执行SQL' ELSE '无' END AS TB002,V1.MV002,TB006,V2.MV002 as MV001,TC015,MA002,TC200,MA028,TB001,TC012,COPTC.UDF55,COPTC.TC003,"+;
		"CAST(COPMA.UDF06 as char(50)) AS GDY,SUBSTRING(MB004,1,3)+LTRIM(substring(TB005,5,3)) AS TABLENAME,TB005,COPTC.UDF55  "+;
		"FROM ADMTB LEFT JOIN DSCSYS..ADMMB as ADMMB ON TB003=ADMMB.MB001 LEFT JOIN CMSMV V1 ON TB004=V1.MV001 INNER JOIN COPTC ON TB007 like RTRIM(TC001)+'-'+RTRIM(TC002)+'%'  "+;
		"LEFT JOIN COPMA ON TC004=MA001 LEFT JOIN CMSMV V2 ON TC006=V2.MV001 WHERE (LEFT(MB001,3)='COP' OR MB002='录入客户订单(耀华70)') "+;
		"AND ((TB001='1' and TB002='1') OR TB001='2') AND TB006>?fend  and TB005 not like '%单身共  0笔%' ORDER BY TB006","TMP")<0 && AND TB002='1'  &&(MB001='COPMI06' OR MB001='COPI06') and TC005<>'512'
		SQLDISCONNECT(con)
		RETURN 
	ENDIF 

	SQLDISCONNECT(con)
	SELECT TMP
	IF RECCOUNT()>0
*!*			CON=ODBC(5)
*!*			sQLEXEC(con,"SELECT DISTINCT TO001,TO002,TO005,V3.MV002 CHKNAME,V2.MV002 SALES,TC200,TO013,TO113,MA002,COPTC.UDF55,TC001,TC002,TC012,TA006,TA034,TA015,"+;
*!*			" case when TA011='1' then '未生产' WHEN TA011='2' THEN '已发料' when TA011='3' THEN '生产中' when TA011='Y' THEN '已完工' when TA011='y' THEN '指定完工' end STATUS "+;
*!*			"FROM  MOCTO LEFT JOIN COPTC ON TO134=RTRIM(TC001)+TC002 INNER JOIN MOCTA ON TA001=TO001 AND TA002=TO002 INNER JOIN "+;
*!*			" COPMA ON TC004=MA001 LEFT JOIN CMSMV V2 ON TC006=V2.MV001 LEFT JOIN CMSMV V3 ON TO044=V3.MV001 "+;
*!*			"WHERE MOCTO.CREATE_DATE>?FEND1 AND COPTC.UDF55>0 and TO041='Y' AND TO013>TC200 AND TO013>TO113 AND (TO123='07' OR TO123='05' OR TO123='11' OR TO123='12'  OR TO123='02') ORDER BY 1 DESC","TMPTO")
*!*			SQLDISCONNECT(CON)
		SELECT TMP
		GO BOTT
		cFEND=tTOC(TB006)
		CON=ODBC(6)
		SQLEXEC(CON,"update defaultval set item=?cFEND where name='COPTC读取时间'")
		SQLDISCONNECT(con)
	ELSE
*!*			CON=ODBC(5)
*!*			sQLEXEC(con,"SELECT '1' FROM COPTC WHERE 1=2","TMPTO")
*!*			SQLDISCONNECT(CON)
		RETURN	
	ENDIF	
	SELECT TMP
	IF USED("TMP1")	
		SELECT TMP1
		USE
	ENDIF
	SELECT * FROM TMP WHERE TB001='2' INTO CURSOR TMP1 	READWRITE 
	XD=''

	SELECT TMP1
	
	IF RECCOUNT()<1
		WAIT windows 'no' nowait
		SQLDISCONNECT(Con)
		RETURN
	ENDIF  	
	XD=''
	mrev=''
	t=''
	GD=''
	GO TOP
	DO WHIL .NOT. EOF()
		MUDF55=UDF55
		MTC003=TC003
		XUDF55=UDF55
		
		MT=TTOC(TB006)
		sh=ALLTRIM(TB002)
*!*			IF SH='取消审核'
*!*				MT=''
*!*			ENDIF	
		IF UDF55>0
			con=odbc(5)
			IF SH='取消审核'
				SQLEXEC(con,"update pi set statusid=?sh where interid=?XUDF55")
			ELSE
				SQLEXEC(con,"update pi set statusid='ERP审核' where interid=?XUDF55")
			ENDIF	
			SQLDISCONNECT(con)
		ENDIF
		SELECT TMP1
*!*			IF !ISNULL(MV001)
*!*				IF MV001<>MV002
*!*					IF ALLTRIM(MV002)$mrev=.F. AND ALLTRIM(MV001)$mrev=.F. 
*!*						mrev=mrev+ALLT(MV001)+';'+ALLTRIM(MV002)+';'
*!*					ENDIF	
*!*					IF ALLTRIM(MV002)$mrev=.F.
*!*						mrev=mrev+ALLT(MV002)+';'
*!*					ENDIF	
*!*					IF ALLTRIM(MV001)$mrev=.F.
*!*						mrev=mrev+ALLT(MV001)+';'
*!*					ENDIF	
*!*				ELSE
*!*					IF ALLTRIM(MV002)$mrev=.F.
*!*						mrev=mrev+ALLT(MV001)+';'
*!*					ENDIF 	
*!*				ENDIF 
*!*			ELSE
*!*				mrev=''
*!*			ENDIF 
*!*			mGDY=ALLTRIM(GDY)
*!*			X=1

*!*			Y=OCCURS('Y', MGDY)
*!*			Z=''
*!*			IF Y=0
*!*				MGDY=''
*!*			ELSE
*!*				DO WHIL X<=Y
*!*					Z1=SUBSTR(MGDY,AT('Y',MGDY,X),6)
*!*					con=odbc(5)
*!*					SQLEXEC(CON,"SELECT MV002 FROM CMSMV WHERE MV001=?Z1","TMDDDD")
*!*					SQLDISCONNECT(con)
*!*					IF RECCOUNT()=1
*!*						IF ALLTRIM(MV002)$mrev=.F.
*!*							Z=Z+ALLTRIM(MV002)+';'
*!*						ENDIF 	
*!*					ENDIF	
*!*					X=X+1
*!*				ENDDO
*!*			ENDIF
*!*			IF USED("TMDDDD")
*!*				SELECT TMDDDD
*!*				USE 
*!*			ENDIF 	
*!*			mGDY=ALLTRIM(Z)
*!*			mrev=mrev+mGDY
		SELECT TMP1

		JIAOQ=''

		SELECT TMP1
		xxx1x='%'+ALLTRIM(TB007)+ALLTRIM(MV002)+'于'+TTOC(TB006)+ALLTRIM(TB002)+'%'
		CON3=ODBC(6)
		SQLEXEC(CON3,"SELECT interid FROM rtxmessage where note like ?xxx1x and title like '%单子已审核%' and creatdate>?FEND")
		SQLDISCONNECT(CON3)
		IF RECCOUNT()<1
			SELECT TMP1
			IF LEFT(TB007,3)='223'
				CON=ODBC(5)
				SQLEXEC(con,"select top 1 pi.classid from pidetail inner join pi on pi.interid=pidetail.maininterid where maininterid=?MUDF55 and mf002='N' and code>='A' AND LEFT(code,1)<>'X'")
				SQLDISCONNECT(con)
				IF RECCOUNT()=1 AND classid='223'
					IF '黄艳'$mrev=.F.
						mrev=mrev+'黄艳;'
					ENDIF				
				ENDIF
			ENDIF 	
			SELECT TMP1
			XD=XD+ALLTRIM(STR(lu))+'.'+ALLT(MA002)+','+ALLTRIM(TB007)+ALLTRIM(MV002)+'于'+TTOC(TB006)+ALLTRIM(TB002)+CHR(13)+CHR(10)
			lu=lu+1
		ENDIF 
		SELECT TMP1
		IF UDF55>0
			CON=ODBC(5)
 	
			SQLEXEC(con,"select interid from pipro where interid=?MUDF55")
			IF RECCOUNT()<1
				SQLEXEC(con,"insert into pipro (interid ) values (?MUDF55)")
			ENDIF
			SQLEXEC(con,"update pipro set erpchk=?mt  where interid=?MUDF55 and (erpchk>=?mt or erpchk is null or erpchk='')")
			SQLEXEC(con,"update pipro set TE004=?mt  where interid=?MUDF55 and (TE004 is null or TE004='' or TE004<=?mt)")

			SQLDISCONNECT(CON)
		ENDIF 
		SELECT TMP1
		SKIP
	ENDDO	
*!*			IF '王文雅'$mrev=.F.
*!*				mrev=mrev+'王文雅;'
*!*			ENDIF
		IF ISNULL(mver)
			mver=''
		ENDIF 
*!*			IF '张国兰'$mrev=.F.
*!*				mrev=mrev+'张国兰;许恒军;'
*!*			ENDIF
		*	mrev=mrev+'许恒军;陈冲俞;'

&&		mrev=mrev&&'申屠晓萍;王家君;彭秀娟;陈冲俞;于秀梅;屠青青;王亚萍;罗茜;黄远琼;王丽丽;许恒军;'
		mtitle=TTOC(DATETIME())+':ERP订单有['+ALLTRIM(STR(lu-1))+']张单子已审核'

		m_note=XD
		IF LEN(m_note)>10
			IF LEN(ALLTRIM(m_note))<1500
*				m_note=LEFT(m_note,2000)
				tmpkeyid=maxinterid("rtxmessage")
				keyidid1=ODBC(6)
				IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,4)")<0
					WAIT windows '?PI状态修正3???' nowait
				ENDIF 

			ELSE
				m_note1=LEFT(m_note,1500)
				m_note2=ALLTRIM(SUBSTR(m_note,1501,2000))
				tmpkeyid=maxinterid("rtxmessage")
				keyidid1=ODBC(6)
				IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note1,?mtitle,4)")<0
					WAIT windows '?PI状态修正3???' nowait
				ENDIF 
				SQLDISCONNECT(keyidid1)
				tmpkeyid=maxinterid("rtxmessage")
				keyidid1=ODBC(6)
				IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note2,'续上面的通知',4)")<0
					WAIT windows '?PI状态修正3???' nowait
				ENDIF 
			ENDIF	
			SQLDISCONNECT(keyidid1)
		ENDIF
RETURN 
	CATCH
	ENDTRY
	TRY  
	SELECT TMPTO
	IF RECCOUNT()>=1
		GO TOP
		DO WHIL .NOT. EOF()
			SELECT TMPTO
			mtitle='['+ALLTRIM(CHKNAME)+']对'+RTRIM(TO001)+ALLTRIM(TO002)+'进行变更,请确认合法性!'
			con3=odbc(6)
			SQLEXEC(con3,"select interid from rtxmessage where title=?mtitle")
			SQLDISCONNECT(con3)
			IF RECCOUNT()<1
				mrev=ALLTRIM(CHKNAME)+';王文雅;申屠晓萍;刘建宁;王素华;'+ALLTRIM(SALES)
				JIAOQ='PI:'+ALLTRIM(STR(INT(UDF55)))+'('+RTRIM(TC001)+ALLTRIM(TC002)+'),合同交期:'+SUBSTR(TC200,1,4)+'.'+SUBSTR(TC200,5,2)+'.'+SUBSTR(TC200,7,2)
				IF ISNULL(TC012) OR EMPTY(TC012)
					JIAOQ=JIAOQ+','
				ELSE
					JIAOQ=JIAOQ+'(Po:'+ALLTRIM(TC012)+'),'
				ENDIF 
				IF ISNULL(TO005) OR EMPTY(TO005)
					XD=JIAOQ+ALLT(MA002)+'.'+ALLTRIM(TA006)+'['+ALLT(TA034)+','+ALLTRIM(STR(INT(TA015)))+']'+ALLTRIM(STATUS)+CHR(13)+CHR(10)+'变更工单要求完工日[从'+SUBSTR(TO113,1,4)+'.'+SUBSTR(TO113,5,2)+'.'+SUBSTR(TO113,7,2)+'到'+SUBSTR(TO013,1,4)+'.'+SUBSTR(TO013,5,2)+'.'+SUBSTR(TO013,7,2)+']'+CHR(13)+CHR(10)
				ELSE	
					XD=JIAOQ+ALLT(MA002)+').'+ALLTRIM(TA006)+'['+ALLT(TA034)+','+ALLTRIM(STR(INT(TA015)))+']'+ALLTRIM(STATUS)+CHR(13)+CHR(10)+'变更工单要求完工日[从'+SUBSTR(TO113,1,4)+'.'+SUBSTR(TO113,5,2)+'.'+SUBSTR(TO113,7,2)+'到'+SUBSTR(TO013,1,4)+'.'+SUBSTR(TO013,5,2)+'.'+SUBSTR(TO013,7,2)+']'+',注:'+ALLTRIM(TO005)+CHR(13)+CHR(10)
				ENDIF

				m_note=XD&&+'生产要求完成日期大于合同交期时,应先通知业务员首先变更合同交期和订单要求生产完成日期,而且确认产能,确定变更后的周次不会超出工作中心的生产负荷.'
				IF LEN(m_note)>19
					tmpkeyid=maxinterid("rtxmessage")
					m_note=LEFT(m_note,2000)
					keyidid1=ODBC(6)
					IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,0)")<0
						WAIT windows '?PI状态修正4???' nowait
					ENDIF 
					SQLDISCONNECT(keyidid1)
				ENDIF
			ENDIF 	
			SELECT TMPTO

			SKIP
		ENDDO	

	ENDIF 

	CATCH
	ENDTRY

	
	RETURN
	SELECT TMP
	IF USED("TMP1")	
		SELECT TMP1
		USE
	ENDIF
	SELECT * FROM TMP WHERE TB001='1' AND MV001<>MV002 INTO CURSOR TMP1 READWRITE 	
	SELECT TMP1
	IF RECCOUNT()>=1

		GO TOP
		DO WHIL .NOT. EOF()
			IF ISNULL(TC012) OR EMPTY(TC012)
				mtitle='ERP订单'+ALLTRIM(TB007)+TB002
			ELSE
				mtitle='ERP订单'+ALLTRIM(TB007)+'(Po:'+ALLTRIM(TC012)+')'+TB002
			ENDIF 
			XD=''
			mrev=''
			t=''
			GD=''
			IF ALLTRIM(MV002)$mrev=.F. AND ALLTRIM(MV001)$mrev=.F. 
				mrev=mrev+ALLT(MV001)+';'+ALLTRIM(MV002)+';'
			ENDIF
			mGDY=ALLTRIM(GDY)
			X=1

			Y=OCCURS('Y', MGDY)
			Z=''
			IF Y=0
				MGDY=''
			ELSE
				DO WHIL X<=Y
					Z1=SUBSTR(MGDY,AT('Y',MGDY,X),6)
					con=odbc(5)
					SQLEXEC(CON,"SELECT MV002 FROM CMSMV WHERE MV001=?Z1","TMDDDD")
					SQLDISCONNECT(con)
					IF RECCOUNT()=1
						IF ALLTRIM(MV002)$mrev=.F.
							Z=Z+ALLTRIM(MV002)+';'
						ENDIF 	
					ENDIF	
					X=X+1
				ENDDO
			ENDIF
			IF USED("TMDDDD")
				SELECT TMDDDD
				USE 
			ENDIF 	
			mGDY=ALLTRIM(Z)
			mrev=mrev+mGDY
			SELECT TMP1
			IF ISNULL(TC200) OR EMPTY(TC200)
				IF EMPTY(MA028) OR ISNULL(MA028)
					JIAOQ=''
				ELSE	
					JIAOQ='('+ALLTRIM(MA028)+')'
				ENDIF	
			ELSE
				IF EMPTY(MA028) OR ISNULL(MA028)
					JIAOQ=',交期:'+SUBSTR(TC200,1,4)+'.'+SUBSTR(TC200,5,2)+'.'+SUBSTR(TC200,7,2)
				ELSE	
					JIAOQ='('+ALLTRIM(MA028)+')'+',交期:'+SUBSTR(TC200,1,4)+'.'+SUBSTR(TC200,5,2)+'.'+SUBSTR(TC200,7,2)
				ENDIF	
			ENDIF	
			IF ISNULL(TC015) OR EMPTY(TC015)
				XD=ALLT(MA002)+JIAOQ+','+ALLTRIM(TB007)+ALLTRIM(MV002)+'于'+TTOC(TB006)+ALLTRIM(TB002)+CHR(13)+CHR(10)
			ELSE	
				XD=ALLT(MA002)+JIAOQ+','+ALLTRIM(TB007)+'(注:'+ALLTRIM(TC015)+')'+ALLTRIM(MV002)+'于'+TTOC(TB006)+ALLTRIM(TB002)+CHR(13)+CHR(10)
			ENDIF
			IF TB002='新增1'
				dfd=TB007
				con=odbc(5)
				SQLEXEC(CON,"SELECT TD003,TD004,TD005,TD008,TD015,TD202,TD203,UDF05 FROM COPTD WHERE RTRIM(TD001)+'-'+TD002=?DFD ORDER BY 1","DDS")
				SQLDISCONNECT(CON)
				SELECT DDS
				IF RECCOUNT()>10
					FDD='....共计:'+ALLTRIM(STR(RECCOUNT()))+'种产品.'
					IF USED("TMPDDS")
						SELECT TMPDDS
						USE
					ENDIF
					SELECT TOP 10 * FROM DDS  ORDER BY 1 INTO CURSOR TMPDDS	
				ELSE
					FDD=''
					SELECT * FROM DDS  ORDER BY 1 INTO CURSOR TMPDDS	
				ENDIF 
				DO WHIL .NOT. EOF()
					IF TD202>0 AND TD203>0
						XD=XD+SUBS(TD003,3,2)+'.'+ALLTRIM(TD004)+'('+ALLTRIM(TD005)+'):'+ALLTRIM(STR(INT(TD008)))+'只,箱号:'+ALLTRIM(STR(INT(TD202)))+'-'+ALLTRIM(STR(INT(TD203)))
					ELSE 	
						XD=XD+SUBS(TD003,3,2)+'.'+ALLTRIM(TD004)+'('+ALLTRIM(TD005)+'):'+ALLTRIM(STR(INT(TD008)))+'只'
					ENDIF 
					IF !EMPTY(TD015) AND !isnull(TD015)
						xd=xd+',调预测:'+ALLTRIM(TD015)
					ENDIF	
					IF !EMPTY(UDF05) AND !ISNULL(UDF05)
						xd=xd+',借用:'+ALLTRIM(UDF05)
					ENDIF	
					xd=xd+CHR(13)+CHR(10)
					SELECT DDS
					SKIP
				ENDD 
				XD=XD+FDD+CHR(13)+CHR(10)			
				m_note=XD
			ELSE
				CCCCC=TABLENAME
				CCC=SUBSTR(TABLENAME,1,3)
				CON=ODBC(5)
				SQLEXEC(CON,"SELECT MA001,MA002 FROM DSCSYS..ADMMA WHERE MA001=?CCC","TMPB")
				XXX=ALLTRIM(MA002)
				SQLEXEC(CON,"SELECT MC001,MC002 FROM DSCSYS..ADMMC WHERE MC001=?CCCCC","TMPB")
				XXX=XXX+':'+ALLTRIM(MC002)+'('+ALLTRIM(MC001)+')'
				SQLEXEC(CON,"SELECT MD003,MD004 FROM DSCSYS..ADMMD WHERE MD001=?CCCCC","TMPB")
				SQLDISCONNECT(CON)
				SELECT TMPB
				X=RECCOUNT()
				GO TOP 
				DO WHIL .NOT. EOF()
					X1=ALLTRIM(MD003)
					X2=ALLTRIM(MD004)
					SELECT TMP1
					REPLACE TB005 WITH STRTRAN(TB005, X1, X2) 
					SELECT TMPB
					SKIP
				ENDDO
				SELECT TMP1
				XD=XD+ALLTRIM(TB005)+CHR(13)+CHR(10)			
				m_note=XD
			ENDIF 	
			IF LEN(ALLTRIM(mrev))>4
*!*					tmpkeyid=maxinterid("rtxmessage")
*!*					keyidid1=ODBC(6)
*!*					IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,0)")<0
*!*						WAIT windows '????' nowait
*!*					ENDIF 
*!*					SQLDISCONNECT(keyidid1)
			ENDIF 	

			SELECT TMP1
			SKIP
		ENDDO	
	ENDIF
ENDIF
ENDPROC 
PROCEDURE FORCEO

*!*		SQLEXEC(CON,"DROP VIEW LHB")
*!*		IF SQLEXEC(CON,"CREATE VIEW LHB AS SELECT COPMA.MA001, COPMA.MA002,COPMA.MA028, CASE WHEN COPTDa.TD001 IS NOT NULL THEN COPTDa.TD001 WHEN COPTDb.TD001 IS NOT NULL "+;
*!*	        " THEN COPTDb.TD001 END AS TD001, CASE WHEN COPTDa.TD002 IS NOT NULL THEN COPTDa.TD002 WHEN COPTDb.TD002 IS NOT NULL  "+;
*!*	        " THEN COPTDb.TD002 END AS TD002, CASE WHEN COPTDa.TD003 IS NOT NULL THEN COPTDa.TD003 WHEN COPTDb.TD003 IS NOT NULL  "+;
*!*	        " THEN COPTDb.TD003 END AS TD003, RTRIM(ACRTB.TB039) TB039, RTRIM(INVMB.MB002) MB002, RTRIM(INVMB.MB003) MB003, CASE WHEN COPTDa.TD008 IS NOT NULL  "+;
*!*	        " THEN COPTDa.TD008 WHEN COPTDb.TD008 IS NOT NULL THEN COPTDb.TD008 END AS TD008, CASE WHEN COPTHa.TH008 IS NOT NULL  "+;
*!*	        " THEN COPTHa.TH008 WHEN COPTHb.TH008 IS NOT NULL THEN COPTHb.TH008 END AS TH008,  "+;
*!*	        " CASE ACRTA.TA079 WHEN '1' THEN ACRTB.TB022 WHEN '2' THEN ACRTB.TB022 * - 1 END AS TB022, ACRTB.TB023,  "+;
*!*	        " CASE WHEN INVLAa.LA012 IS NOT NULL THEN INVLAa.LA012 WHEN INVLAb.LA012 IS NOT NULL THEN INVLAb.LA012 END AS LA012,  "+;
*!*	         " CASE ACRTA.TA079 WHEN '1' THEN ACRTB.TB019 WHEN '2' THEN ACRTB.TB019 * - 1 END AS TB019, CASE WHEN ACRTA.TA079 = '1' AND  "+;
*!*	          "  INVLAa.LA012 IS NOT NULL THEN ACRTB.TB022 * INVLAa.LA012 WHEN ACRTA.TA079 = '1' AND INVLAb.LA012 IS NOT NULL  "+;
*!*	          "  THEN ACRTB.TB022 * INVLAb.LA012 WHEN ACRTA.TA079 = '2' AND INVLAa.LA012 IS NOT NULL  "+;
*!*	            "  THEN ACRTB.TB022 * INVLAa.LA012 * - 1 WHEN ACRTA.TA079 = '2' AND INVLAb.LA012 IS NOT NULL THEN ACRTB.TB022 * INVLAb.LA012 * - 1 END AS XHCB,  "+;
*!*	          " CASE WHEN ACRTA.TA079 = '1' AND INVLAa.LA012 IS NOT NULL THEN ACRTB.TB019 - INVLAa.LA012 * ACRTB.TB022 WHEN ACRTA.TA079 = '1' AND  "+;
*!*	           " INVLAb.LA012 IS NOT NULL THEN ACRTB.TB019 - INVLAb.LA012 * ACRTB.TB022 WHEN ACRTA.TA079 = '2' AND INVLAa.LA012 IS NOT NULL  "+;
*!*	          " THEN (ACRTB.TB019 - INVLAa.LA012 * ACRTB.TB022) * - 1 WHEN ACRTA.TA079 = '2' AND INVLAb.LA012 IS NOT NULL  "+;
*!*	           " THEN (ACRTB.TB019 - INVLAb.LA012 * ACRTB.TB022) * - 1 END AS MLR, ACRTA.TA003, ACRTB.TB001,  CMSME.ME001, CMSME.ME002, "+;
*!*	           "  CMSMV.MV001, CMSMV.MV002,RTRIM(ACRTB.TB005)+ RTRIM(ACRTB.TB006) + '-' + ACRTB.TB007 AS COH,COPTC.TC003,COPTDa.TD038,COPTDa.TD039,C.MR003 AREA,D.MR003 COUNTRY "+;
*!*	           ",COPTC.TC001,RTRIM(COPTC.TC001)+COPTC.TC002 AS TC002,TB005 AS SB001,RTRIM(TB005)+TB006 AS SB002,RTRIM(TB001)+TB002 AS TB002,MA5.MA002+' '+MA5.MA003 AS KJFL, MA6.MA002+' '+MA6.MA003 AS SPFL,"+;
*!*	           "MA7.MA002+' '+MA7.MA003 AS CPXL,MA8.MA002+' '+MA8.MA003 AS YS,COPTG.TG003,ACRTA.TA009,"+;
*!*	           "(MB057+MB058+MB059+MB060)*TB022 AS BZCB,CASE ACRTA.TA079 WHEN '1' THEN ACRTB.TB017 WHEN '2' THEN ACRTB.TB017 * - 1  END AS TB018,COPTHa.TH007,"+;
*!*	           "ACRTA.TA001 ,PURMA.MA002 as GYS,CMSMD.MD002 AS MAKE,CMSD.MD002 YUCE, MSMD.MD002 AS JMAKE,MSD.MD002 AS JYUC,bincode.package AS PACKAGE,COPMA.MA017,CMSMQ.MQ002 "+;
*!*			 " FROM   ACRTB LEFT JOIN ACRTA ACRTA ON ACRTB.TB001 = ACRTA.TA001 AND ACRTB.TB002 = ACRTA.TA002 LEFT JOIN "+;
*!*	           "  INVMB ON INVMB.MB001 = ACRTB.TB039 LEFT JOIN CMSME AS CMSME ON CMSME.ME001 = ACRTA.TA070 LEFT JOIN "+;
*!*	             " CMSMV AS CMSMV ON CMSMV.MV001 = ACRTA.TA005 LEFT JOIN  COPMA AS COPMA ON COPMA.MA001 = ACRTA.TA004 LEFT JOIN "+;
*!*			" CMSMR C ON C.MR001 = '3' AND C.MR002 = COPMA.MA018 LEFT JOIN CMSMR D ON D.MR001 = '4' AND D.MR002 = COPMA.MA019 LEFT JOIN "+;   
*!*	      "  COPTJ AS COPTJ ON ACRTB.TB005 = COPTJ.TJ001 AND ACRTB.TB006 = COPTJ.TJ002 AND ACRTB.TB007 = COPTJ.TJ003 LEFT JOIN "+;
*!*	            " COPTH AS COPTHa ON ACRTB.TB005 = COPTHa.TH001 AND ACRTB.TB006 = COPTHa.TH002 AND  ACRTB.TB007 = COPTHa.TH003 LEFT JOIN "+;
*!*	              "  COPTH AS COPTHb ON COPTJ.TJ015 = COPTHb.TH001 AND COPTJ.TJ016 = COPTHb.TH002 AND COPTJ.TJ017 = COPTHb.TH003 LEFT JOIN "+;
*!*	               " COPTD AS COPTDa ON COPTHa.TH014 = COPTDa.TD001 AND COPTHa.TH015 = COPTDa.TD002 AND  "+;
*!*	              "  COPTHa.TH016 = COPTDa.TD003 LEFT JOIN  COPTD AS COPTDb ON COPTHb.TH014 = COPTDb.TD001 AND COPTHb.TH015 = COPTDb.TD002 AND  "+;
*!*	              " COPTHb.TH016 = COPTDb.TD003 LEFT JOIN"+;
*!*	             " INVLA AS INVLAa ON COPTHa.TH001 = INVLAa.LA006 AND COPTHa.TH002 = INVLAa.LA007 AND COPTHa.TH003 = INVLAa.LA008 LEFT JOIN "+;
*!*	              "  INVLA AS INVLAb ON COPTJ.TJ001 = INVLAb.LA006 AND COPTJ.TJ002 = INVLAb.LA007 AND COPTJ.TJ003 = INVLAb.LA008 LEFT JOIN COPTG ON COPTHa.TH001=TG001 AND COPTHa.TH002=TG002 "+;
*!*	              " LEFT JOIN COPTC AS COPTC ON COPTDa.TD001=COPTC.TC001 AND  COPTDa.TD002=COPTC.TC002  LEFT JOIN  INVMA AS  MA5 ON MB005=MA5.MA002 AND  MA5.MA001='1'  "+;
*!*	              " LEFT JOIN  INVMA AS  MA6 ON MB006=MA6.MA002 AND  MA6.MA001='2'  LEFT JOIN  INVMA AS  MA7 ON MB007=MA7.MA002 and MA7.MA001='3'   LEFT JOIN  INVMA AS  MA8 ON MB008=MA8.MA002 AND  MA8.MA001='4'  "+;
*!*					"LEFT JOIN PURTD PD ON PD.TD024=RTRIM(COPTDb.TD001)+COPTDb.TD002 AND PD.TD023=COPTDb.TD003 AND PD.TD018='Y'  "+;
*!*	     		  "LEFT JOIN PURTH PH ON PH.TH011=PD.TD001 AND PH.TH012=PD.TD002 AND PH.TH013=PD.TD003 LEFT JOIN PURTC PC ON PC.TC001=PD.TD001 AND PC.TC002=PD.TD002 LEFT JOIN PURMA ON PURMA.MA001=PC.TC004 "+;
*!*	             "LEFT JOIN MOCTA MOCTA ON MOCTA.TA033=RTRIM(COPTDb.TD001)+COPTDb.TD002 AND MOCTA.TA028=COPTDb.TD003 AND MOCTA.TA013='Y' LEFT JOIN CMSMD CMSMD ON MOCTA.TA021=CMSMD.MD001 "+;
*!*	              "LEFT JOIN MOCTA MOCA ON MOCA.TA033=RTRIM(COPTDb.TD015) AND MOCA.TA006=COPTDb.TD004 AND MOCA.TA013='Y' LEFT JOIN CMSMD CMSD ON MOCA.TA021=CMSD.MD001 "+;
*!*	               "LEFT JOIN COPTD COPD ON COPD.UDF05=RTRIM(COPTDb.TD001)+'-'+RTRIM(COPTDb.TD002)+'-'+COPTDb.TD003 "+;
*!*	             "LEFT JOIN MOCTA OCTA ON OCTA.TA033=RTRIM(COPD.TD001)+COPD.TD002 AND OCTA.TA028=COPD.TD003 AND OCTA.TA013='Y' LEFT JOIN CMSMD MSMD ON OCTA.TA021=MSMD.MD001 "+;
*!*	              "LEFT JOIN MOCTA OCA ON OCA.TA033=RTRIM(COPD.TD015) AND OCA.TA006=COPD.TD004 AND OCA.TA013='Y' LEFT JOIN CMSMD MSD ON OCA.TA021=MSD.MD001 "+;
*!*	             "LEFT JOIN bincode ON bincode.code=COPTDb.TD004 LEFT JOIN CMSMQ ON CMSMQ.MQ001=COPTDb.TD001 "+;
*!*	               " WHERE  ACRTB.TB012 <> 'V'")<0
*!*				 WAIT WINDOWS '???' &&AND  MA8.MA001='2'AND  MA7.MA001='2' AND  MA5.MA001='2'  
*!*			ENDIF	
*!*			SQLEXEC(CON,"DROP TABLE fordashboad")            
*!*	       *		
*!*			SQLEXEC(CON,"SELECT DISTINCT * INTO fordashboad FROM LHB")
CON=ODBC(PK)
	SQLEXEC(CON,"DROP VIEW LHB")
	IF SQLEXEC(CON,"CREATE VIEW LHB AS SELECT COPMA.MA001, COPMA.MA002,COPMA.MA028, CASE WHEN COPTDa.TD001 IS NOT NULL THEN COPTDa.TD001 WHEN COPTDb.TD001 IS NOT NULL "+;
        " THEN COPTDb.TD001 END AS TD001, CASE WHEN COPTDa.TD002 IS NOT NULL THEN COPTDa.TD002 WHEN COPTDb.TD002 IS NOT NULL "+;
        " THEN COPTDb.TD002 END AS TD002, CASE WHEN COPTDa.TD003 IS NOT NULL THEN COPTDa.TD003 WHEN COPTDb.TD003 IS NOT NULL  "+;
        " THEN COPTDb.TD003 END AS TD003, RTRIM(ACRTB.TB039) TB039, RTRIM(INVMB.MB002) MB002, RTRIM(INVMB.MB003) MB003, CASE WHEN COPTDa.TD008 IS NOT NULL  "+;
        " THEN COPTDa.TD008 WHEN COPTDb.TD008 IS NOT NULL THEN COPTDb.TD008 END AS TD008,CASE WHEN COPTHa.TH008 IS NOT NULL  "+;
        " THEN COPTHa.TH008 WHEN COPTHb.TH008 IS NOT NULL THEN COPTHb.TH008 END AS TH008,MB080,COPMA.MA065,TB039 AS BILLCLASS,"+;
        " CASE ACRTA.TA079 WHEN '1' THEN ACRTB.TB022 WHEN '2' THEN ACRTB.TB022 * - 1 END AS TB022, ACRTB.TB023,  "+;
        " CASE WHEN INVLAa.LA012 IS NOT NULL THEN INVLAa.LA012 WHEN INVLAb.LA012 IS NOT NULL THEN INVLAb.LA012 END AS LA012,  "+;
        " CASE WHEN INVLAa.LA017 IS NOT NULL THEN INVLAa.LA017 WHEN INVLAb.LA017 IS NOT NULL THEN INVLAb.LA017 END AS LA017,  "+;
        " CASE WHEN INVLAa.LA018 IS NOT NULL THEN INVLAa.LA018 WHEN INVLAb.LA018 IS NOT NULL THEN INVLAb.LA018 END AS LA018,  "+;
        " CASE WHEN INVLAa.LA019 IS NOT NULL THEN INVLAa.LA019 WHEN INVLAb.LA019 IS NOT NULL THEN INVLAb.LA019 END AS LA019,  "+;
        " CASE WHEN INVLAa.LA020 IS NOT NULL THEN INVLAa.LA020 WHEN INVLAb.LA020 IS NOT NULL THEN INVLAb.LA020 END AS LA020,  "+;
        " CASE WHEN INVLAa.LA011 IS NOT NULL THEN INVLAa.LA011 WHEN INVLAb.LA011 IS NOT NULL THEN INVLAb.LA011 END AS LA011 ,  "+;
         " CASE ACRTA.TA079 WHEN '1' THEN ACRTB.TB019 WHEN '2' THEN ACRTB.TB019 * - 1 END AS TB019, "+;
         "CASE ACRTA.TA079 WHEN '1' THEN ACRTB.TB019+ACRTB.TB020 WHEN '2' THEN (ACRTB.TB019+ACRTB.TB020) * - 1 END AS TB020, CASE WHEN ACRTA.TA079 = '1' AND  "+;
          "  INVLAa.LA012 IS NOT NULL THEN ACRTB.TB022 * INVLAa.LA012 WHEN ACRTA.TA079 = '1' AND INVLAb.LA012 IS NOT NULL  "+;
          "  THEN ACRTB.TB022 * INVLAb.LA012 WHEN ACRTA.TA079 = '2' AND INVLAa.LA012 IS NOT NULL  "+;
            "  THEN ACRTB.TB022 * INVLAa.LA012 * - 1 WHEN ACRTA.TA079 = '2' AND INVLAb.LA012 IS NOT NULL THEN ACRTB.TB022 * INVLAb.LA012 * - 1 END AS XHCB,  "+;
          " CASE WHEN ACRTA.TA079 = '1' AND INVLAa.LA012 IS NOT NULL THEN ACRTB.TB019 - INVLAa.LA012 * ACRTB.TB022 WHEN ACRTA.TA079 = '1' AND  "+;
           " INVLAb.LA012 IS NOT NULL THEN ACRTB.TB019 - INVLAb.LA012 * ACRTB.TB022 WHEN ACRTA.TA079 = '2' AND INVLAa.LA012 IS NOT NULL  "+;
          " THEN (ACRTB.TB019 - INVLAa.LA012 * ACRTB.TB022) * - 1 WHEN ACRTA.TA079 = '2' AND INVLAb.LA012 IS NOT NULL  "+;
           " THEN (ACRTB.TB019 - INVLAb.LA012 * ACRTB.TB022) * - 1 END AS MLR, ACRTA.TA003, ACRTB.TB001,  CMSME.ME001, CMSME.ME002, "+;
           "  CMSMV.MV001, CMSMV.MV002,RTRIM(ACRTB.TB005)+ RTRIM(ACRTB.TB006) + '-' + ACRTB.TB007 AS COH,"+;
           "COPTC.TC003,COPTDa.TD038,COPTDa.TD039,C.MR003 AREA,D.MR003 COUNTRY "+;
           ",COPTC.TC001,RTRIM(COPTC.TC001)+COPTC.TC002 AS TC002,TB005 AS SB001,RTRIM(TB005)+TB006 AS SB002,RTRIM(TB001)+TB002 AS TB002,"+;
           "MA5.MA002+' '+MA5.MA003 AS KJFL, MA6.MA002+' '+MA6.MA003 AS SPFL,"+;
           "MA7.MA002+' '+MA7.MA003 AS CPXL,MA8.MA002+' '+MA8.MA003 AS YS,COPTG.TG003,ACRTA.TA009,"+;
           "(MB057+MB058+MB059+MB060)*TB022 AS BZCB,CASE ACRTA.TA079 WHEN '1' THEN ACRTB.TB017 WHEN '2' THEN ACRTB.TB017 * - 1  END AS TB018,COPTHa.TH007,"+;
           "COPMA.MA017,ACRTA.TA001,COPMA.MA002 AS GYS,COPMA.MA002 as MAKE ,COPMA.MA002 as YCMAKE ,TB039  as LEIBIE ,TB039 as MQNAME,bincode.package AS PACKAGE "+;
		 " FROM   ACRTB LEFT JOIN ACRTA ACRTA ON ACRTB.TB001 = ACRTA.TA001 AND ACRTB.TB002 = ACRTA.TA002 LEFT JOIN "+;
           "  INVMB ON INVMB.MB001 = ACRTB.TB039 LEFT JOIN CMSME AS CMSME ON CMSME.ME001 = ACRTA.TA070 LEFT JOIN "+;
             " CMSMV AS CMSMV ON CMSMV.MV001 = ACRTA.TA005 LEFT JOIN  COPMA AS COPMA ON COPMA.MA001 = ACRTA.TA004 LEFT JOIN "+;
		" CMSMR C ON C.MR001 = '3' AND C.MR002 = COPMA.MA018 LEFT JOIN CMSMR D ON D.MR001 = '4' AND D.MR002 = COPMA.MA019 LEFT JOIN "+;   
      "  COPTJ AS COPTJ ON ACRTB.TB005 = COPTJ.TJ001 AND ACRTB.TB006 = COPTJ.TJ002 AND ACRTB.TB007 = COPTJ.TJ003 LEFT JOIN "+;
            " COPTH AS COPTHa ON ACRTB.TB005 = COPTHa.TH001 AND ACRTB.TB006 = COPTHa.TH002 AND  ACRTB.TB007 = COPTHa.TH003 LEFT JOIN "+;
              "  COPTH AS COPTHb ON COPTJ.TJ015 = COPTHb.TH001 AND COPTJ.TJ016 = COPTHb.TH002 AND COPTJ.TJ017 = COPTHb.TH003 LEFT JOIN "+;
               " COPTD AS COPTDa ON COPTHa.TH014 = COPTDa.TD001 AND COPTHa.TH015 = COPTDa.TD002 AND  "+;
              "  COPTHa.TH016 = COPTDa.TD003 LEFT JOIN  COPTD AS COPTDb ON COPTHb.TH014 = COPTDb.TD001 AND COPTHb.TH015 = COPTDb.TD002 AND  "+;
              " COPTHb.TH016 = COPTDb.TD003  LEFT JOIN bincode ON bincode.code=ACRTB.TB039 LEFT JOIN"+;
             " INVLA AS INVLAa ON COPTHa.TH001 = INVLAa.LA006 AND COPTHa.TH002 = INVLAa.LA007 AND COPTHa.TH003 = INVLAa.LA008 LEFT JOIN "+;
              "  INVLA AS INVLAb ON COPTJ.TJ001 = INVLAb.LA006 AND COPTJ.TJ002 = INVLAb.LA007 AND COPTJ.TJ003 = INVLAb.LA008 LEFT JOIN COPTG ON COPTHa.TH001=TG001 AND COPTHa.TH002=TG002 "+;
              " LEFT JOIN COPTC AS COPTC ON COPTDa.TD001=COPTC.TC001 AND  COPTDa.TD002=COPTC.TC002  LEFT JOIN  INVMA AS  MA5 ON MB005=MA5.MA002 AND  MA5.MA001='1'  "+;
              " LEFT JOIN  INVMA AS  MA6 ON MB006=MA6.MA002 AND  MA6.MA001='2'  LEFT JOIN  INVMA AS  MA7 ON MB007=MA7.MA002 and MA7.MA001='3'  "+;
              " LEFT JOIN  INVMA AS  MA8 ON MB008=MA8.MA002 AND  MA8.MA001='4'  "+;
                 " WHERE  ACRTB.TB012 <> 'V'")<0
			 WAIT WINDOWS '???1' NOWAIT  &&AND  MA8.MA001='2'AND  MA7.MA001='2' AND  MA5.MA001='2'  
			 SQLDISCONNECT(con)
			 RETURN 
		ENDIF	
		SQLEXEC(CON,"DROP TABLE fordashboad1")            
		SQLEXEC(CON,"DROP TABLE fordashboad2")            
		SQLEXEC(CON,"DROP TABLE fordashboad3")            
       	X=DTOC(DATE()-300,1)
		SQLEXEC(CON,"SELECT DISTINCT * INTO fordashboad2 FROM fordashboad where TA003<=?X")
		SQLEXEC(CON,"SELECT DISTINCT * INTO fordashboad3 FROM LHB WHERE TA003>?X")  &&where TA003>?X

		SQLEXEC(CON,"update fordashboad3 set LEIBIE='',GYS='',MAKE='',MQNAME=(CASE WHEN MQ.MQ002 IS NULL THEN '无来源' ELSE MQ.MQ002 END) ,"+;
		"YCMAKE=(CASE WHEN fordashboad3.MA065>='0' THEN COPMA.MA002 ELSE fordashboad3.MA002 END),BILLCLASS=(CASE WHEN Q2.MQ002 IS NULL THEN '' ELSE Q2.MQ002 END)  "+;
			"FROM fordashboad3 LEFT JOIN CMSMQ MQ ON LEFT(COH,3)=MQ.MQ001 LEFT JOIN COPMA COPMA ON COPMA.MA001=fordashboad3.MA065 "+;
			"left join CMSMQ Q2 ON fordashboad3.TA001=Q2.MQ001 LEFT JOIN COPMA MA ON MA.MA001=fordashboad3.MA001")
		SQLEXEC(CON,"SELECT TD001,TD002,TD003,COH,TB039,TB002 FROM fordashboad3 where LEFT(COH,1)>='0' AND LEFT(TD001,1)>'0'","TMPFOR")

		SELECT TMPFOR
		DO WHIL .NOT. EOF()
			T1=TD001
			T2=TD002
			T3=TD003
			T4=RTRIM(TD001)+TD002
			T5=TB039
			MCOH=ALLTRIM(coh)+TB002
			TT=''
			TT1=''

			SQLEXEC(CON,"SELECT TD015,TD028,UDF05,TD004 FROM COPTD WHERE TD001=?T1 AND TD002=?T2 AND TD003=?T3 AND (TD015>='1' OR LTRIM(UDF05)>='1')","TMPY")
			IF RECCOUNT()<1
				SQLEXEC(CON,"SELECT MA001 AS MD001,MA002 AS MD002 FROM PURTD INNER JOIN PURTC ON TD001=TC001 AND TD002=TC002 INNER JOIN PURMA ON MA001=TC004 "+;
				"WHERE TD024=?T4 AND TD023=?T3 AND TD018='Y' AND TD004=?T5","TMPX")
				IF RECCOUNT()>0 AND !ISNULL(MD002)
					TT=MD002
					TT1=MD001
					SQLEXEC(CON,"update fordashboad3 set GYS=?TT,LEIBIE='外购',MAKE=?TT1 where rtrim(COH)+TB002=?mcoh")
				ELSE	
					SQLEXEC(CON,"SELECT MD001,MD002 FROM MOCTA INNER JOIN CMSMD ON TA021=MD001 WHERE TA033=?T4 AND TA006=?T5","TMPX")
					IF RECCOUNT()>0 AND !ISNULL(MD002)
						TT=MD002
						TT1=MD001
						SQLEXEC(CON,"update fordashboad3 set GYS=?TT,LEIBIE='自产',MAKE=?TT1 where rtrim(COH)+TB002=?mcoh")
					ELSE	
						SQLEXEC(CON,"update fordashboad3 set GYS='',MAKE='',LEIBIE='不清楚' where rtrim(COH)+TB002=?mcoh")
					ENDIF	
				ENDIF	
			ELSE
				IF TD015>='1'
					T2=TD028
					T1=TD015
					T3=TD004
					SQLEXEC(CON,"SELECT MA001 AS MD001,MA002 AS MD002 FROM PURTD INNER JOIN PURTC ON TD001=TC001 AND TD002=TC002 INNER JOIN PURMA "+;
					"ON MA001=TC004 WHERE TD024=?T1 AND TD023=?T2 AND TD018='Y'  AND TD004=?T5","TMPX")
					IF RECCOUNT()>0 AND !ISNULL(MD002)
						TT=MD002
						TT1=MD001
						SQLEXEC(CON,"update fordashboad3 set GYS=?TT,LEIBIE='外购预测',MAKE=?TT1 where rtrim(COH)+TB002=?mcoh")
					ELSE	
						SQLEXEC(CON,"SELECT MD001,MD002 FROM MOCTA INNER JOIN CMSMD ON TA021=MD001 WHERE TA033=?T1 AND TA006=?T3","TMPX")
						IF RECCOUNT()>0 AND !ISNULL(MD002)
							TT=MD002
							TT1=MD001
							SQLEXEC(CON,"update fordashboad3 set GYS=?TT,LEIBIE='自产预测',MAKE=?TT1 where rtrim(COH)+TB002=?mcoh")
						ELSE	
							SQLEXEC(CON,"update fordashboad3 set LEIBIE='可能自产预测' where rtrim(COH)+TB002=?mcoh")
						ENDIF	
					ENDIF	
				ELSE	
					T1=UDF05
					T3=TD004
					SQLEXEC(CON,"SELECT MA001 AS MD001,MA002 AS MD002 FROM PURTD INNER JOIN PURTC ON TD001=TC001 AND TD002=TC002 INNER JOIN PURMA ON MA001=TC004 "+;
					"WHERE LEFT(TD024,3)+','+RTRIM(SUBSTRING(TD024,4,15))+','+TD023=?T1 AND TD018='Y' AND TD004=?T5","TMPX")
					IF RECCOUNT()>0 AND !ISNULL(MD002)
						TT=MD002
						TT1=MD001
						SQLEXEC(CON,"update fordashboad3 set GYS=?TT,LEIBIE='外购借用',MAKE=?TT1 where rtrim(COH)+TB002=?mcoh")
					ELSE	
						SELECT TMPY
						
						T1=SUBSTR(UDF05,1,3)+STREXTRACT(UDF05,',',',')
						SQLEXEC(CON,"SELECT MD001,MD002 FROM MOCTA INNER JOIN CMSMD ON TA021=MD001 WHERE TA033=?T1 AND TA006=?T3","TMPX")
						IF RECCOUNT()>0 AND !ISNULL(MD002)
							TT=MD002
							TT1=MD001
							SQLEXEC(CON,"update fordashboad3 set GYS=?TT,LEIBIE='自产借用',MAKE=?TT1 where rtrim(COH)+TB002=?mcoh")
						ELSE	
							SQLEXEC(CON,"update fordashboad3 set LEIBIE='可能自产借用' where rtrim(COH)+TB002=?mcoh")
						ENDIF	
					ENDIF	
				ENDIF				
			ENDIF	
			SELECT TMPFOR
			SKIP
		ENDDO 
		SELECT TMPFOR
		USE
		SQLEXEC(CON,"DROP TABLE fordashboad1")            
		SQLEXEC(CON,"SELECT DISTINCT * INTO fordashboad1 FROM fordashboad2")
		IF SQLEXEC(CON,"SELECT DISTINCT * INTO fordashboad1 FROM fordashboad3")>0
			SQLEXEC(CON,"DROP TABLE fordashboad")            
			SQLEXEC(CON,"SELECT DISTINCT * INTO fordashboad FROM fordashboad1")
		ELSE 
			WAIT WINDOWS 'ERROR' NOWAIT
		ENDIF

*		SQLEXEC(CON,"DROP TABLE fordashboad2")            
*		SQLEXEC(CON,"DROP TABLE fordashboad3")  
*!*		IF SQLEXEC(CON,"SELECT distinct fordashboad1.* ,PURMA.MA002 as GYS,CMSMD.MD002 AS MAKE,CMSD.MD002 YUCE, "+;
*!*			"MSMD.MD002 AS JMAKE,MSD.MD002 AS JYUC,bincode.package AS PACKAGE,CMSMQ.MQ002 "+;
*!*			 " INTO fordashboad FROM fordashboad1 LEFT OUTER JOIN COPTD COPTD ON COPTD.TD001=fordashboad1.TD001 AND COPTD.TD002=fordashboad1.TD002 AND COPTD.TD003=fordashboad1.TD003 "+;
*!*					"LEFT OUTER JOIN PURTD PD ON PD.TD024=RTRIM(fordashboad1.TD001)+fordashboad1.TD002 AND PD.TD023=fordashboad1.TD003 AND PD.TD018='Y' "+;
*!*	     		  "  LEFT OUTER JOIN PURTC PC ON PC.TC001=PD.TD001 AND PC.TC002=PD.TD002 LEFT OUTER JOIN PURMA ON PURMA.MA001=PC.TC004 "+;
*!*	             "LEFT OUTER JOIN MOCTA MOCTA ON MOCTA.TA033=RTRIM(fordashboad1.TD001)+fordashboad1.TD002 AND "+;
*!*	             "MOCTA.TA028=fordashboad1.TD003 and MOCTA.TA006=fordashboad1.TB039 AND MOCTA.TA013='Y' LEFT OUTER JOIN CMSMD CMSMD ON MOCTA.TA021=CMSMD.MD001 "+;
*!*	              "LEFT OUTER JOIN MOCTA MOCA ON MOCA.TA033=RTRIM(COPTD.TD015) AND MOCA.TA006=COPTD.TD004 AND MOCA.TA013='Y' LEFT OUTER JOIN CMSMD CMSD ON MOCA.TA021=CMSD.MD001 "+;
*!*	               "LEFT OUTER JOIN COPTD COPD ON COPD.UDF05=RTRIM(fordashboad1.TD001)+'-'+RTRIM(fordashboad1.TD002)+'-'+fordashboad1.TD003 "+;
*!*	             "LEFT OUTER JOIN MOCTA OCTA ON OCTA.TA033=RTRIM(COPD.TD001)+COPD.TD002 AND OCTA.TA028=COPD.TD003 AND OCTA.TA013='Y' "+;
*!*	             " and OCTA.TA006=fordashboad1.TB039  LEFT OUTER JOIN CMSMD MSMD ON OCTA.TA021=MSMD.MD001 "+;
*!*	              "LEFT OUTER JOIN MOCTA OCA ON OCA.TA033=RTRIM(COPD.TD015) AND OCA.TA006=COPD.TD004 AND OCA.TA013='Y' and OCA.TA006=fordashboad1.TB039 LEFT OUTER JOIN CMSMD MSD ON OCA.TA021=MSD.MD001 "+;
*!*	             "LEFT OUTER JOIN bincode ON bincode.code=fordashboad1.TB039  LEFT OUTER JOIN CMSMQ ON CMSMQ.MQ001=fordashboad1.TD001")<0
*!*				 WAIT WINDOWS '???' &&AND  MA8.MA001='2'AND  MA7.MA001='2' AND  MA5.MA001='2'  
*!*			ENDIF	
SQLDISCONNECT(CON)

RETURN 	
ENDPROC 




	
PROCEDURE ceoxxx
con=ODBC(5)
XXXX=DTOC(DATE(),1)
MYEAR=SUBSTR(XXXX,1,4)
MMONTH=SUBSTR(XXXX,1,6)
CDATE=DTOC(DATE(),1)	

XXXX1=DTOC(GOMONTH(DATE(),-12),1)
MYEAR1=SUBSTR(XXXX1,1,4)
MMONTH1=SUBSTR(XXXX1,1,6)
		IF sqlexec(con,"SELECT Sum(CASE WHEN SUBSTRING(TB002,1,6)= ?mmonth THEN 0-ACTTB.TB004*ACTTB.TB007 ELSE 0 END) 今月,"+;
			"Sum(CASE WHEN SUBSTRING(TB002,1,4)= ?mYEAR THEN 0-ACTTB.TB004*ACTTB.TB007 ELSE 0 END) 今年,"+;
			"Sum(CASE WHEN SUBSTRING(TB002,1,6)= ?mmonth1 THEN 0-ACTTB.TB004*ACTTB.TB007 ELSE 0 END) 去月,"+;
			"Sum(CASE WHEN SUBSTRING(TB002,1,4)= ?mYEAR1 and SUBSTRING(TB002,1,6)<= ?mmonth1 THEN 0-ACTTB.TB004*ACTTB.TB007 ELSE 0 END) 去年 "+;
			"FROM ACTMA a LEFT OUTER JOIN ACTTB ON ACTTB.TB005 = a.MA001 left join ACTMA b on left(TB005,1) =b.MA001 "+;
			"WHERE (ACTTB.TB001='920') and (a.MA022<5) and TB005 like '5111%'","TmpGroupData1")<0	
			WAIT WINDOWS 'KS' 
		ENDIF	 
		t1=今月
		t2=今年
		t3=去月
		t4=去年 
		T1=0
		T2=0
		T3=0
		T4=0
	SQLEXEC(CON,"SELECT MAX(TB002) AS TB002 FROM ACTTB "+;
	"WHERE ACTTB.TB001='920' and left(TB005,3) in ('510','511','512') and ACTTB.TB016='Y' ","TMP")
	GZR=LEFT(TB002 ,6)
	IF sqlexec(con,"SELECT  SUM(CASE WHEN SUBSTRING(TA003,1,6)= ?mmonth THEN TB019 ELSE 0 END) AS  销售,SUM(  TB019 ) AS  年销售,"+;
			"SUM(CASE WHEN TA001='661' AND SUBSTRING(TA003,1,6)= ?mmonth THEN  TB019*0.04 else 0 END)  AS 月抵扣,"+;
			"SUM(CASE WHEN TA001<>'661' THEN 0 ELSE TB019*0.04 END)  AS 年抵扣,"+;
	       "SUM(CASE WHEN  SUBSTRING(TA003,1,6)= ?mmonth THEN BZCB ELSE 0 END) AS 实际成本,"+;
	       "SUM( XHCB) AS 年成本 "+;
	 		" FROM LHB where SUBSTRING(TA003,1,4)= ?mYEAR","TmpGroupData1")<0
		WAIT WINDOWS 'DFDS' nowait
		RETURN
	ENDIF&&
	FFFF1=ALLTRIM(STR(INT(销售/10000)))
	IF ISNULL(ffff1)
		ffff1=0
	ENDIF
	FFFF2=ALLTRIM(STR(INT(年销售/10000)))
	xxx=年销售
	dddd=销售
	IF ISNULL(DDDD)
		DDDD=0
	ENDIF
	*FFFF3=ALLTRIM(STR(INT((销售-月抵扣-实际成本)/10000)))+'('+allt(STR(INT((销售-月抵扣-实际成本)/销售*100)))+'%)'
	FFFF3=ALLTRIM(STR(INT((销售*0.35)/10000)))
	sqlexec(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '本月费用' FROM ACTTB WHERE ACTTB.TB001<>'920' and left(TB005,1) in('5')"+;
	" and left(TB005,3) in('513','514','515') and ACTTB.TB016='Y' and left(TB002,6) =?mmonth","tm")	
	IF RECCOUNT()=1 AND !ISNULL(本月费用)
		fyfy=本月费用
	ELSE
		fyfy=0
	ENDIF	
	sqlexec(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '本月费用' FROM ACTTB WHERE ACTTB.TB001<>'920' and left(TB005,1) in('5')"+;
	" and left(TB005,3) in('513','514','515') and ACTTB.TB016='Y' and left(TB002,4) =?myear","tm")	
	IF RECCOUNT()=1 AND !ISNULL(本月费用)
		fyfyy=本月费用
	ELSE
		fyfyy=0
	ENDIF	
	m本月利润=INT((dddd*0.35-fyfy)/10000)
*!*		IF sqlexec(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '金额'	FROM ACTMA a LEFT JOIN ACTTB ON ACTTB.TB005 = a.MA001 left join ACTMA b on left(TB005,1) =b.MA001 "+;
*!*		"WHERE (ACTTB.TB001<>'920') and (a.MA022<5) and (TB005 like '513%' or TB005 like '514%' or TB005 like '515%' ) and  left(ACTTB.TB002,4)  =?myear","TmpGroupData1")<0
*!*			WAIT WINDOWS 'DFfweewrwerDS' 
*!*			RETURN
*!*		ENDIF&&
*!*		XXX2=金额
*!*		IF sqlexec(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '金额' FROM ACTMA a LEFT JOIN ACTTB ON ACTTB.TB005 = a.MA001 left join ACTMA b on left(TB005,1) =b.MA001 "+;
*!*		"WHERE ACTTB.TB001='920' and a.MA022<5 and (TB005 like '510%' or TB005 like '511%' or TB005 like '512%') and left(TB002,4) =?myear","TMP")<0
*!*			WAIT WINDOWS '金额' 
*!*			RETURN
*!*		ENDIF&&

	
	SQLEXEC(CON,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '本年毛利' FROM ACTTB "+;
	"WHERE ACTTB.TB001='920' and left(TB005,3) in ('510','511','512') and ACTTB.TB016='Y' and left(TB002,4) =?myear ","TMP")
*!*		xxx1=金额+dddd
*!*		m本月利润=INT((XXX2-XXX1)/10000)
	ffff4=ALLTRIM(STR(INT(((本年毛利)/10000))))+'('+allt(STR(INT((本年毛利)/(XXX-dddd+t2)*100)))+'%)'

	IF sqlexec(con,"SELECT  SUM(CASE WHEN SUBSTRING(TA003,1,6)= ?mmonth1  THEN TB019 ELSE 0 END) AS  销售,SUM(  TB019 ) AS  年销售,"+;
			"SUM(CASE WHEN TA001='661' AND SUBSTRING(TA003,1,6)= ?mmonth1   THEN  TB019*0.04 else 0 END)  AS 月抵扣,"+;
			"SUM(CASE WHEN TA001<>'661' THEN 0 ELSE TB019*0.04 END)  AS 年抵扣,"+;
	       "SUM(CASE WHEN  SUBSTRING(TA003,1,6)= ?mmonth1  THEN BZCB ELSE 0 END) AS 实际成本,"+;
	       "SUM( XHCB) AS 年成本 "+;
	 		" FROM LHB where  left(TA003,4) =?myear1","TmpGroupData1")<0  &&and SUBSTRING(TA003,1,8)<= ?xxxx1
		WAIT WINDOWS 'DFDS' nowait
		RETURN
	ENDIF&&
	FFFF11=ALLTRIM(STR(INT(销售/10000)))
	IF ISNULL(ffff11)
		ffff11=0
	ENDIF
	FFFF21=ALLTRIM(STR(INT(年销售/10000)))
	xxx1=年销售
	dddd1=销售
	IF ISNULL(dddd1)
		dddd1=0
	ENDIF
	*FFFF3=ALLTRIM(STR(INT((销售-月抵扣-实际成本)/10000)))+'('+allt(STR(INT((销售-月抵扣-实际成本)/销售*100)))+'%)'
	FFFF3=FFFF3+'/'+ALLTRIM(STR(INT((销售*0.35)/10000)))
	sqlexec(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '本月费用' FROM ACTTB WHERE ACTTB.TB001<>'920' and left(TB005,1) in('5')"+;
	" and left(TB005,3) in('513','514','515') and ACTTB.TB016='Y' and left(TB002,8) <=?XXXX1 and left(TB002,6) =?mmonth1 and left(TB002,8) <=?xxxx1","tm")	
	IF RECCOUNT()=1 AND !ISNULL(本月费用)
		fyfy1=本月费用
	ELSE
		fyfy1=0
	ENDIF	
	sqlexec(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '本月费用' FROM ACTTB WHERE ACTTB.TB001<>'920' and left(TB005,1) in('5')"+;
	" and left(TB005,3) in('513','514','515') and ACTTB.TB016='Y' and left(TB002,4) =?myear1  ","tm")	
	IF RECCOUNT()=1 AND !ISNULL(本月费用)
		fyfyy1=本月费用
	ELSE
		fyfyy1=0
	ENDIF	
	m本月利润1=INT((dddd1*0.35-fyfy1-t3)/10000)
*!*		IF sqlexec(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '金额'	FROM ACTMA a LEFT JOIN ACTTB ON ACTTB.TB005 = a.MA001 left join ACTMA b on left(TB005,1) =b.MA001 "+;
*!*		"WHERE (ACTTB.TB001<>'920') and (a.MA022<5) and (TB005 like '513%' or TB005 like '514%' or TB005 like '515%' ) and  left(ACTTB.TB002,4)  =?myear","TmpGroupData1")<0
*!*			WAIT WINDOWS 'DFfweewrwerDS' 
*!*			RETURN
*!*		ENDIF&&
*!*		XXX2=金额
*!*		IF sqlexec(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '金额' FROM ACTMA a LEFT JOIN ACTTB ON ACTTB.TB005 = a.MA001 left join ACTMA b on left(TB005,1) =b.MA001 "+;
*!*		"WHERE ACTTB.TB001='920' and a.MA022<5 and (TB005 like '510%' or TB005 like '511%' or TB005 like '512%') and left(TB002,4) =?myear","TMP")<0
*!*			WAIT WINDOWS '金额' 
*!*			RETURN
*!*		ENDIF&&
	SQLEXEC(CON,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '本年毛利' FROM ACTTB "+;
	"WHERE ACTTB.TB001='920' and left(TB005,3) in ('510','511','512') and ACTTB.TB016='Y' and left(TB002,4) =?myear1 and left(TB002,6) <=?mmonth1","TMP")
*!*		xxx1=金额+dddd
*!*		m本月利润=INT((XXX2-XXX1)/10000)
	ffff4=ffff4+'/'+ALLTRIM(STR(INT(((本年毛利-T2)/10000))))+'('+allt(STR(INT((本年毛利-t4)/(XXX1)*100)))+'%)'	
	*FFFF4=ALLTRIM(STR(INT((年销售-年抵扣-年成本)/10000)))+'('+allt(STR(INT((年销售-年抵扣-年成本)/年销售*100)))+'%)'
SQLEXEC(CON,"DROP VIEW LHB")
SQLEXEC(CON,"select SUM( (TK033+TK035+TK036-TK038+TK041)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end) ) as '预收余额' "+;
"from ACRTK left join CMSMQ on MQ001=TK001 where TK020='Y' and ACRTK.TK030 <> '3' ","tmp")
xxx=预收余额
IF ISNULL(xxx)
xxx=0
ENDIF
SQLEXEC(CON,"CREATE VIEW LHB AS SELECT LB005 AS 客户, SUBSTRING(LB020,1,6) AS 日期, (CASE WHEN LB001 IN ('0', '1', '2') THEN (LB014 + LB019) ELSE 0.0 END) AS 本币应收, "+;
"(CASE WHEN LB001 IN ('3', '4', '5') THEN LB014 ELSE 0.0 END) AS 本币实收 FROM ACRLB AS ACRLB WHERE (1 = 1 AND LB001 NOT IN ('B', 'C')) UNION ALL "+;
"SELECT LC006 AS KHID, LC029 AS DAY,  0.0 AS BBYSJE, (CASE WHEN MQ003 IN ('61', '6A', '66', '6B') "+;
" THEN LC018 ELSE 0.0 END) AS BBSSJE "+;
" FROM ACRLC  LEFT JOIN CMSMQ AS CMSMQ ON MQ001 = LC003 WHERE (1 = 1 AND (Round(LC018, 3) <> 0.0 OR Round(LC017, 3) <> 0.0)) UNION ALL "+;
"SELECT LC006 AS KHID,  SUBSTRING(LC029,1,6) AS DAY, 0.0 AS BBYSJE,  LC019 AS BBSSJE  "+;
" FROM ACRLC WHERE (1 = 1 AND Round(LC019, 3) <> 0.0 ) UNION ALL "+;
"SELECT LE005 KHID,LD003 DAY,CASE WHEN LE004='3'  THEN 0- LE014 ELSE LE014 END THJE,0 AS SS FROM ACRLD LEFT JOIN ACRLE ON LD001=LE001 AND LD002=LE002")

IF SQLEXEC(CON,"SELECT SUM(TB004*TB007)  AS 本币余额 "+;
      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
      " WHERE TA010='Y' AND (LEFT(TB005 ,4)='1101' OR LEFT(TB005 ,4)='1111') ORDER BY 1 ","TmpBank1")<0
		WAIT WINDOWS '本币余额 ' nowait
		RETURN
ENDIF&&
xx2=本币余额 
m存款=INT((17759846+xx2)/10000)
IF ISNULL(xx2)
xx2=0
ENDIF
IF ISNULL(m存款)
m存款=0
ENDIF

IF SQLEXEC(CON,"SELECT SUM(TB004*TB007)  AS 本币余额 "+;
      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
      " WHERE TA010='Y' AND (LEFT(TB005 ,4)='1101' OR LEFT(TB005 ,4)='1111') and LEFT(TA014,8)<=?XXXX1  ORDER BY 1 ","TmpBank1")<0
		WAIT WINDOWS '本币余额 ' nowait
		RETURN
ENDIF&&
xx21=本币余额 
m存款1=INT((17759846+xx21)/10000)
IF ISNULL(xx21)
xx21=0
ENDIF
IF ISNULL(m存款1)
m存款1=0
ENDIF
*!*	SQLEXEC(con,"SELECT SUM(CASE WHEN SUBSTRING(TB002,1,6)=?MMONTH THEN TB004 * TB007 ELSE 0 END) AS '月金额',SUM(TB004 * TB007) 总金额 "+;
*!*	"FROM  ACTMA AS a LEFT JOIN  ACTTB ON ACTTB.TB005 = a.MA001  "+;
*!*	" WHERE (ACTTB.TB001 <> '920') AND (a.MA022 < 5) AND (ACTTB.TB005 LIKE '5%') AND SUBSTRING(TB002,1,4)=?MYEAR","TMP")&&利润

SQLEXEC(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '本年净利' FROM ACTTB WHERE ACTTB.TB001='920' and left(TB005,1) in('5') and ACTTB.TB016='Y'  and left(TB002,4) =?myear","tmp")

*!*	*m本月利润= INT(月金额/10000)
M本年利润= INT(本年净利/10000)
SQLEXEC(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '本年净利' FROM ACTTB WHERE ACTTB.TB001='920' and left(TB005,1) in('5') "+;
"and ACTTB.TB016='Y'  and left(TB002,4) =?myear1  and left(TB002,8) <=?XXXX1 ","tmp")

*!*	*m本月利润= INT(月金额/10000)
M本年利润1= INT(本年净利/10000)

SQLEXEC(CON,"select SUM((TA041+TA042-TA098+TA059)*(case when TA079=1 then 1 else -1 end)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end)) as '应收余额' "+;
"from ACRTA left join CMSMQ on MQ001=TA001 where TA025='Y' and TA029+TA030 <>ACRTA.TA031","tmp")
cdddd=应收余额
IF ISNULL(cdddd)
	cdddd=0
ENDIF	
DATEID=DATE()
SQLEXEC(CON,"select SUM(TA041+TA042+TA059-TA098) AS RMB,SUM( (TA041+TA042+TA059-TA098)*DATEDIFF( DAY,CAST(TA020 AS DATETIME), ?DATEID)) AS TRMB "+;
"FROM ACRTA AS ACRTA  LEFT JOIN CMSMQ AS CMSMQ ON MQ001=TA001  "+;
"WHERE  ( MQ003 IN ('61','6A','66')  AND TA025='Y' AND TA100<>'3'"+;
"  AND (TA020<?CDATE OR TA020 = '')) ","TMPYD")
IF SQLEXEC(CON,"select "+;
	"SUM(CASE WHEN 日期=?MMONTH THEN 本币应收 ELSE 0.0 END) as 本期应收,SUM( CASE WHEN SUBSTRING(日期,1,4)=?MYEAR THEN 本币应收 ELSE 0 END) as 本年应收, "+;
	"SUM(CASE WHEN 日期=?MMONTH  THEN 本币实收 ELSE 0.0 END) as 本期实收, SUM( CASE WHEN SUBSTRING(日期,1,4)=?MYEAR THEN 本币实收 ELSE 0 END) as 本年实收, "+;
	"sum(CASE WHEN 日期<='999999'  THEN 本币应收-本币实收 ELSE 0 END) AS 期末应收 ,0 到期未收   "+;
	" FROM LHB LHB  "+;
	"","TmpQC")<0
	WAIT windows '到款核销表' nowait
ENDIF 	
YSK1='3.本月应收：'+ALLTRIM(STR(INT(本期应收/10000)))+'，本年：'+ALLTRIM(STR(INT(本年应收/10000)))+'，未收：'+ALLTRIM(STR(INT((cdddd)/10000)))+'，预收余额：'+ALLTRIM(STR(INT((xxx)/10000)))
YSK2='；本月实收：'+ALLTRIM(STR(INT(本期实收/10000)))+'，本年：'+ALLTRIM(STR(INT(本年实收/10000)))
*!*	SELECT TMPYD
*!*	IF RECCOUNT()=1 AND !ISNULL(RMB)
*!*		YSK2=''
*!*		*YSK2+'；超期账款：'+ALLTRIM(STR(INT(RMB/10000)))+'，*天数：'+ALLTRIM(STR(INT(TRMB/10000)))
*!*	ENDIF
*!*	IF SQLEXEC(CON,"select SUM(CASE WHEN TK003=?mmonth  AND CMSMQ.MQ003='6D' THEN TK033+TK036+TK035+TK041  ELSE 0 END) AS 本期退款, "+;
*!*	"SUM(CASE WHEN substring(TK003,1,4)=?myear  AND CMSMQ.MQ003='6D' THEN TK033+TK036+TK035+TK041  ELSE 0 END) AS 退款总额   "+;
*!*	" FROM ACRTK ACRTK  LEFT JOIN CMSMQ AS CMSMQ ON MQ001=TK001   "+;
*!*	  "WHERE ( TK020='Y' )  " ,"TmpCustom1")<0
*!*	  WAIT windows '收款单'
*!*	ENDIF   
*!*	IF RECCOUNT()=1 AND !ISNULL(本期退款)
*!*	YSK2=YSK2+'；本月退款：'+ALLTRIM(STR(INT(本期退款/10000)))+'，本年：'+ALLTRIM(STR(INT(退款总额 /10000)))
*!*	ENDIF 
SQLEXEC(CON,"DROP VIEW LHB")

SQLEXEC(CON,"CREATE VIEW LHB AS SELECT LB005 AS 供应商,SUBSTRING(LB020,1,6) AS 日期,"+;
	"(Case when LB001 in ('0','1','2') then LB014 when (LB001='C' AND MQ003 IN ('71','7A','7B','7F')) then LB019  else 0.0 end) as 本币应付,"+;
	"(Case when LB001 in ('3','4','5') then LB014 when (LB001='C' AND MQ003='7C') then LB019 else 0.0 end) as 本币实付 "+;
 	"From ACPLB  LEFT JOIN CMSMQ AS CMSMQ ON MQ001=LB009  where LB027='1' union all "+;
	"SELECT LC006,SUBSTRING(LC029,1,6) LC029,(Case when MQ003 IN ('71','7A','7F') then (-1)*LC018 else 0 end) as BBYSJE, "+;
 	" (Case when LC019 <> 0.0 then LC019 else 0.0 end) as BBSSJE "+;
 	" FROM ACPLC LEFT JOIN CMSMQ AS CMSMQ ON LC003=MQ001 where LC036='1' and (Round(LC019,3)<>0.0 or Round(LC018,3)<>0.0 or Round(LC017,3)<>0.0) UNION ALL "+;
	"SELECT LE005 KHID,LD010 DAY,LE014 THJE,0 SS FROM ACPLD LEFT JOIN ACPLE ON LD001=LE001 AND LD002=LE002")
SQLEXEC(CON,"select sum((TA037+TA038-TA085+TA051)*(case when TA079=1 then 1 else -1 end)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end)) as '应付余额' "+;
"from ACPTA left join CMSMQ on MQ001=TA001 where TA024='Y' and TA028+TA029 <>ACPTA.TA030","tmp")

dddc=应付余额
IF ISNULL(dddc)
	dddc=0
ENDIF
SQLEXEC(CON,"select SUM((TK031+TK033+TK034-TK036+TK039)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end)) as '预付余额' "+;
"from ACPTK left join CMSMQ on MQ001=TK001 where TK020='Y' and ACPTK.TK028 <> '3'","TmpQC")
yyy=预付余额
IF SQLEXEC(CON,"select   "+;
	"SUM(CASE WHEN 日期=?MMONTH THEN 本币应付 ELSE 0.0 END) as 本期应付, SUM( CASE WHEN SUBSTRING(日期,1,4)=?MYEAR THEN 本币应付 ELSE 0 END) as 全年应付,"+;
	"SUM(CASE WHEN 日期=?MMONTH THEN 本币实付 ELSE 0.0 END) as 本期实付, SUM( CASE WHEN SUBSTRING(日期,1,4)=?MYEAR THEN 本币实付 ELSE 0 END) as 全年实付,"+;
	"sum(CASE WHEN 日期<=?MMONTH THEN 本币应付-本币实付 ELSE 0 END) AS 期末应付 ,0 到期未付 "+;
	" FROM LHB","TmpQC")<0
	WAIT windows 'yf' nowait
ENDIF 	
SQLEXEC(CON,"select SUM(TA037 + TA038 + TA051 - TA085) 本币未付金额 "+;
"FROM ACPTA ACPTA LEFT JOIN  CMSMQ CMSMQ ON MQ001 = TA001  "+;
" WHERE TA024 = 'Y' AND TA087 <> '3' AND TA008 = 'RMB' AND (TA019 < ?CDATE)   UNION ALL "+;
"select   SUM( TI016 + TI032 - TI018) 本币未付金额 "+;
"FROM ACPTI ACPTI LEFT JOIN  CMSMQ CMSMQ ON MQ001 = TI001   "+;
"WHERE (TI013 = 'Y' AND TI029 <> '3' AND TI007 = 'RMB' AND (TI010 <?CDATE))","Tmpwf")
IF RECCOUNT()>0 AND !ISNULL(本币未付金额)
	XXX=本币未付金额
	SELECT TMPQC
	REPLACE 到期未付 WITH XXX
ENDIF

SELECT TMPQC
YFK1='4.本月应付：'+ALLTRIM(STR(INT(本期应付/10000)))+'，本年：'+ALLTRIM(STR(INT(全年应付/10000)))+'，未付：'+ALLTRIM(STR(INT((dddc)/10000)))+'，预付余额：'+ALLTRIM(STR(INT((yyy)/10000)))
YFK2='；本月实付：'+ALLTRIM(STR(INT(本期实付/10000)))+'，本年：'+ALLTRIM(STR(INT(全年实付/10000)))+'，到期未付：'+ALLTRIM(STR(INT(到期未付/10000)))

if SQLEXEC(CON,"select sum(case when   TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009) 本月,"+;
	"SUM(CASE WHEN    TD015<>'' THEN TD012*TC009 ELSE 0 END) as 本期"+;
	" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,6)=?MMONTH  and not (TC004='90574019' and TC003>'20120901')","TmpQ2C") <0
	WAIT windows '???' nowait
endif	
A1=本月 
A3=本期 
IF ISNULL(A1)
A1=0
ENDIF
IF ISNULL(A3)
A3=0
ENDIF
if SQLEXEC(CON,"select sum(case when   TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009) 本月,"+;
	"SUM(CASE WHEN    TD015<>'' THEN TD012*TC009 ELSE 0 END) as 本期"+;
	" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,6)=?MMONTH1 and LEFT(TC003,8)<=?XXXX1 and not (TC004='90574019' and TC003>'20120901')","TmpQ2C") <0
	WAIT windows '???' nowait
endif	
A11=本月 
A31=本期 
IF ISNULL(A11)
A11=0
ENDIF
IF ISNULL(A31)
A31=0
ENDIF
 SQLEXEC(CON,"select sum(case when   TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009) 全年 ,"+;
	"SUM(CASE WHEN    TD015<>'' THEN TD012*TC009 ELSE 0 END) as 本年 "+;
	" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,4)=?Myear  and not (TC004='90574019' and TC003>'20120901')","TmpQ2C") 
A2=全年 
A4=本年 
IF ISNULL(A2)
A2=0
ENDIF
IF ISNULL(A4)
A4=0
ENDIF
 SQLEXEC(CON,"select sum(case when   TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009) 全年 ,"+;
	"SUM(CASE WHEN    TD015<>'' THEN TD012*TC009 ELSE 0 END) as 本年 "+;
	" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,4)=?Myear1 "+;
	" and LEFT(TC003,8)<=?XXXX1 and not (TC004='90574019' and TC003>'20120901')","TmpQ2C") 
A21=全年 
A41=本年 
IF ISNULL(A21)
A21=0
ENDIF
IF ISNULL(A41)
A41=0
ENDIF
CON1=odbc(15)
 SQLEXEC(CON1,"select sum(case when   TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009) 本月,"+;
	"SUM(CASE WHEN    TD015<>'' THEN TD012*TC009 ELSE 0 END) as 本期"+;
	" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,6)=?MMONTH  and not (TC004='90574019' and TC003>'20120901')","TmpQ2C") 
IF RECCOUNT()=1 AND !ISNULL(本月)
A1=本月+A1
A3=本期+A3
ENDIF
 SQLEXEC(CON1,"select sum(case when   TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009) 全年 ,"+;
	"SUM(CASE WHEN    TD015<>'' THEN TD012*TC009 ELSE 0 END) as 本年 "+;
	" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,4)=?Myear  and not (TC004='90574019' and TC003>'20120901')","TmpQ2C") 
A2=全年+A2
A4=本年+A4
 SQLEXEC(CON1,"select sum(case when   TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009) 全年 ,"+;
	"SUM(CASE WHEN    TD015<>'' THEN TD012*TC009 ELSE 0 END) as 本年 "+;
	" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,4)=?Myear  and not (TC004='90574019' and TC003>'20120901')","TmpQ2C") 
A21=全年+A21
A41=本年+A41

IF RECCOUNT()=1 AND !ISNULL(A1)  &&'；其中本月调用预测库存：'+ALLTRIM(STR(A3/10000))+'，本年调用预测库存：'+ALLTRIM(STR(A4/10000))+
	DD1='5.本月接单：'+ALLTRIM(str(A1/10000))+'/'+ALLTRIM(str(A11/10000))+'，本年：'+ALLTRIM(str(A2/10000))+'/'+ALLTRIM(str(A21/10000))+'；本月销售额：'+ffff1+'/'+ffff11+'，本年：'+ffff2+'/'+ffff21
ELSE
	DD1=''
ENDIF
con2=odbc(11)
SQLEXEC(con2,"select SUM(plancash) cash from budget b inner join budgetdetail d on b.interid=d.maininterid where b.dateid=?myear and b.classid='年度'","tt")
ysn=cash
SQLEXEC(con2,"select SUM(plancash) cash from budget b inner join budgetdetail d on b.interid=d.maininterid where b.dateid=?MMONTH and b.classid='月度'","tt")
ysm=cash

SQLDISCONNECT(CON2)
SQLDISCONNECT(CON1)
SQLDISCONNECT(con)
*+'(本年预算：'+ALLTRIM(STR(INT(ysn/10000)))+')'*+'(本月预算：'+ALLTRIM(STR(INT(ysm/10000)))+')'
mtitle=DTOC(DATE())+'日财务情况(万元)'
m_note='1.本月销售预计毛利：'+FFFF3+'，本年实际毛利：'+FFFF4+'；本月预计净利润：'+ALLTRIM(str(m本月利润))+'/'+ALLTRIM(str(m本月利润1))+'，本年：'+ALLTRIM(str(m本年利润))+'/'+ALLTRIM(str(m本年利润1))+CHR(13)+CHR(10)
m_note=m_note+'2.本月发生费用：'+ALLTRIM(STR(INT(fyfy/10000)))+'/'+ALLTRIM(STR(INT(fyfy1/10000)))+'，本年：'+ALLTRIM(STR(INT(fyfyy/10000)))+'/'+ALLTRIM(STR(INT(fyfyy1/10000)))+'；现金存款：'+ALLTRIM(STR(m存款))+'/'+ALLTRIM(STR(m存款1))+CHR(13)+CHR(10)
m_note=m_note+YSK1+YSK2+CHR(13)+CHR(10)+YFK1+YFK2+CHR(13)+CHR(10)+DD1
mrev='ceo'
keyidid1=ODBC(6)
tmpkeyid=maxinterid("rtxmessage")
IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'鲁红斌',getdate(),?m_note,?mtitle,2)")<0
	WAIT windows '????' nowait
ENDIF 
SQLDISCONNECT(keyidid1)
ENDPROC 

PROCEDURE quotation
HR_DEPT='信息部'
P_UserName='助手机器人'
CON=ODBC(5)
IF SQLEXEC(CON,"SELECT  interid,name 产品名称,spec as 规格,"+;
	"pricenote,currency 币种, exchangerate 汇率,price 价格,cost 成本,case when price=0 then 0 else (price*exchangerate*discount/100-cost)/(price*exchangerate*discount/100)*100 end 毛利率,note 备注,tosupplyid,supplyid,supplyname,"+;
	" NA003,taxrate 税率,convert(char(10),CAST(begindate as datetime),102) MA021 ,convert(char(10),CAST(enddate as datetime),102) MA022 ,M.MV002 billname,creatdate,"+;
	"chkman,chkdate,customid,MA002,C.MV002,bomman, bomdate,code as ERP品号,itemno 公司货号,customcode 客户品号,color,classid,"+;
	"mb057,mb058,mb059,mb060,customspec 客户规格 ,bomchkid,chkid,moq,MB025 "+;
	" FROM quotation left join CMSNA  on NA001='2' and payment=NA002 "+;
	"LEFT JOIN COPMA ON MA001=customid LEFT JOIN CMSMV C ON C.MV001=MA016 LEFT JOIN CMSMV M ON M.MV001= billname left join INVMB ON MB001=code"+;
	 " WHERE chkid=1","tmp")<0
		SQLDISCONNECT(CON)

	 WAIT windows '出错了'
	 RETURN
ENDIF   
SELECT tmp
DO whil .not. EOF()
	xd=interid
	cdate=DTOC(DATE(),1)
	xd=interid
	MTD004 =ALLTRIM(ERP品号)
	MTC008 =币种
	MTC004 =customid 
	MTD014 =ALLTRIM(客户品号)
	MTD205 =ALLTRIM(color)
	mpricenote=pricenote
	mf=tosupplyid
	MCLASSID=CLASSID
	M0=MB025
	MTC004 =customid
	MMB002=ALLTRIM(产品名称)
	MMB003=ALLTRIM(规格)
	sn=MMB002+':'+MMB003
	yss=ALLTRIM(color)
	sxrq=MA022 
	IF ISNULL(yss)
		yss=''
	ENDIF 
	MCB=成本
	SQLEXEC(CON,"select TOP 1 MG004,MG002  FROM CMSMG WHERE MG001=?MTC008 AND MG002<=?CDATE ORDER BY MG002 DESC")
	IF RECCOUNT()<1
		*MESSAGEBOX('币种不存在',0+47+1,'币种是必须的')
		*RETURN 
	ENDIF	
	WW13=MG004	
	SQLEXEC(con,"UPDATE quotation SET exchangerate=?WW13 WHERE [currency]=?MTC008")
	SQLEXEC(con,"UPDATE quotation SET profit=(price*exchangerate*discount/100-cost)/(price*exchangerate*discount/100)*100 WHERE interid=?XD AND price>0")		

	IF sxrq<DTOC(DATE())
		SQLEXEC(con,"UPDATE quotation SET chkid=0 WHERE interid=?XD")
		sn='失效日期['+sxrq+'],需重新审核'
		ccodeid=maxinterid("piapprove")
		CON1=ODBC(6)
		SQLEXEC(CON1,"INSERT INTO piapprove (interid,note,chkname,chkdate,keyinterid,dept,action,keyorder) values (?ccodeid,?sn, ?P_UserName,GETDATE(), ?XD,?HR_DEPT,'核价单失效',1)")
		SQLDISCONNECT(CON1)
	ENDIF 
	SQLEXEC(CON,"select enddate FROM quotationprice WHERE interid=?XD")
	IF RECCOUNT()=1
		IF enddate <=DTOC(DATE())
			SQLEXEC(con,"UPDATE quotation SET chkid=0 WHERE interid=?XD")
			SQLEXEC(con,"UPDATE quotationprice SET chkid=0 WHERE interid=?XD")
			sn='外购商品核价失效日期['+sxrq+'],需重新审核'
			ccodeid=maxinterid("piapprove")
			CON1=ODBC(6)
			SQLEXEC(CON1,"INSERT INTO piapprove (interid,note,chkname,chkdate,keyinterid,dept,action,keyorder) values (?ccodeid,?sn, ?P_UserName,GETDATE(), ?XD,?HR_DEPT,'外购失效',1)")
			SQLDISCONNECT(CON1)
		ENDIF 
	ENDIF 
	SELECT TMP
	IF mf='N' &&AND bomchkid<>1 &&AND MTD004 >='A'
*!*			IF (bomchkid<>1 OR ISNULL(bomchkid)) AND MTD004 >='A' AND LEFT(MTD004,1)<>'X'
*!*				IF MESSAGEBOX('['+MMB002+':'+MMB003+ ']没有审核BOM，对于自产的商品必须建立审核BOM之后，才能审核核价单！'+CHR(13)+CHR(10)+CHR(13)+CHR(10)+'你可以强制审核，获取的是['+ALLTRIM(MTD004 )+']标准成本,是否继续？',36,'BOM没有审核')<>6
*!*					SQLDISCONNECT(CON)
*!*					RETURN
*!*				ELSE 	
*!*					SQLEXEC(CON,"SELECT MB057+MB058+MB059+MB060 AS COST,MB057,MB058,MB059,MB060 FROM INVMB WHERE MB001=?MTD004")
*!*					m57=mb057
*!*					m58=mb058
*!*					m59=mb059
*!*					m60=mb060
*!*					MCOST=COST
*!*					IF mcost>0 AND mcost<>MCB  
*!*						SQLEXEC(con,"UPDATE quotation SET cost=?MCOST,mb059=?m59,mb058=?m58,mb060=?m60,mb057=?m57 WHERE interid=?XD")
*!*						CON1=ODBC(6)
*!*						SQLEXEC(CON1,"INSERT INTO piapprove (interid,note,chkname,chkdate,keyinterid,dept,action,keyorder) values (?ccodeid,?sn, ?P_UserName,GETDATE(), ?XD,?HR_DEPT,'成本修正',1)")
*!*						SQLDISCONNECT(CON1)
*!*					ENDIF
*!*				ENDIF 	
*!*			ENDIF 
		SELECT TMP

		IF 	bomchkid=1 AND MTD004 >='A' AND LEFT(MTD004,1)<>'X' AND 1=2
			SQLEXEC(CON,"SELECT SUM(MB057*quan/rate) MB057,SUM(MB058*quan/rate) MB058,SUM(MB059*quan/rate) MB059,SUM(MB060*quan/rate) MB060 FROM salebom INNER JOIN INVMB ON code=MB001 where interid=?XD")
			IF RECCOUNT()=1 AND !ISNULL(MB057)
				p=1

				M57=MB057
				m58=MB058
				m59=MB059
				m60=MB060
				MCOST=(M57+m58+m60+m59)
			
				SQLEXEC(CON,"SELECT MB057+MB058+MB059+MB060 AS COST,MB057,MB058,MB059,MB060,MV002,INVMB.MODI_DATE as dateid "+;
				"FROM INVMB LEFT JOIN CMSMV ON INVMB.MODIFIER=MV001 WHERE MB001=?MTD004","tXmp")
				m58=m58+mb061
				m59=mb062+m59
				m60=mb063+m60
				MCOST=COST+MCOST
				mname=MV002				
				mdate=CTOT(LEFT(dateid,4)+'.'+SUBSTR(dateid,5,2)+'.'+SUBSTR(dateid,7,2)+' '+SUBSTR(dateid,9,2)+':'+SUBSTR(dateid,11,2)+':'+SUBSTR(dateid,13,2))
				*AIT WINDOWS TRANSFORM(MCOST)+'sl-'+TRANSFORM(sl)+'dj-'+TRANSFORM((M57+m58+m60+m59))
				SQLEXEC(con,"UPDATE quotation SET cost=?MCOST,mb059=?m59,mb058=?m58,mb060=?m60,mb057=?m57 WHERE interid=?XD and tosupplyid='N'")
				SQLEXEC(con,"UPDATE quotation SET profit=(price*exchangerate*discount/100-cost)/(price*exchangerate*discount/100)*100 WHERE interid=?XD AND price>0")		
				IF mcost>0 AND INT(mcost)<>INT(MCB)  AND MF='N'
					sn='原='+ALLTRIM(STR(mcb,10,2))+',新='+ALLTRIM(STR(mcost,10,2))
					ccodeid=maxinterid("piapprove")

					CON1=ODBC(6)
					SQLEXEC(CON1,"INSERT INTO piapprove (interid,note,chkname,chkdate,keyinterid,dept,action,keyorder) values (?ccodeid,?sn, ?mname,?mname, ?XD,?HR_DEPT,'成本更新',1)")
					SQLDISCONNECT(CON1)
				ENDIF
			ENDIF 	
		ELSE 
			p=0	
		ENDIF 
		IF p=0 AND MF='N'
			IF SQLEXEC(CON,"SELECT MB057+MB058+MB059+MB060 AS COST,MB057,MB058,MB059,MB060,MV002,INVMB.MODI_DATE as dateid "+;
			"FROM INVMB LEFT JOIN CMSMV ON INVMB.MODIFIER=MV001 WHERE MB001=?MTD004","tXmp")<0
				WAIT windows mtd004
			ENDIF 	
			SELECT tXmp
			m57=mb057
			m58=mb058
			m59=mb059
			m60=mb060
			MCOST=COST
			mname=MV002
			mdate=CTOT(LEFT(dateid,4)+'.'+SUBSTR(dateid,5,2)+'.'+SUBSTR(dateid,7,2)+' '+SUBSTR(dateid,9,2)+':'+SUBSTR(dateid,11,2)+':'+SUBSTR(dateid,13,2))
			IF mcost>0 AND INT(mcost)<>INT(MCB)  AND MF='N'
				sn='原='+ALLTRIM(STR(mcb,10,2))+',新='+ALLTRIM(STR(mcost,10,2))
				SQLEXEC(con,"UPDATE quotation SET cost=?MCOST,mb059=?m59,mb058=?m58,mb060=?m60,mb057=?m57 WHERE interid=?XD  and tosupplyid='N'")
				ccodeid=maxinterid("piapprove")

				CON1=ODBC(6)
				SQLEXEC(CON1,"INSERT INTO piapprove (interid,note,chkname,chkdate,keyinterid,dept,action,keyorder) values (?ccodeid,?sn, ?mname,?mdate, ?XD,?HR_DEPT,'成本修正',1)")
				SQLDISCONNECT(CON1)
			ENDIF	
		ENDIF	
	ELSE
		SQLEXEC(CON,"SELECT MB057+MB058+MB059+MB060 AS COST,MB057,MB058,MB059,MB060,MV002,INVMB.MODI_DATE as dateid "+;
			"FROM INVMB LEFT JOIN CMSMV ON INVMB.MODIFIER=MV001 WHERE MB001=?MTD004","tXmp")
		m57=mb057
		m58=mb058
		m59=mb059
		m60=mb060
		MCOST=COST
		mname=MV002
		mdate=CTOT(LEFT(dateid,4)+'.'+SUBSTR(dateid,5,2)+'.'+SUBSTR(dateid,7,2)+' '+SUBSTR(dateid,9,2)+':'+SUBSTR(dateid,11,2)+':'+SUBSTR(dateid,13,2))
		IF MCOST>0 AND INT(MCOST)<>INT(MCB)  AND LEFT(MTD004,1)<>'X' AND MF='N'
			sn='原='+ALLTRIM(STR(mcb,10,2))+',新='+ALLTRIM(STR(mcost,10,2))
			SQLEXEC(con,"UPDATE quotation SET cost=?MCOST,mb059=?m59,mb058=?m58,mb060=?m60,mb057=?m57 WHERE interid=?XD  and tosupplyid='N'")
			ccodeid=maxinterid("piapprove")
			CON1=ODBC(6)
			SQLEXEC(CON1,"INSERT INTO piapprove (interid,note,chkname,chkdate,keyinterid,dept,action,keyorder) values (?ccodeid,?sn, ?mname,?mdate, ?XD,?HR_DEPT,'成本修正',1)")
			SQLDISCONNECT(CON1)
		ENDIF
	ENDIF


	SELECT tmp
	SKIP
ENDDO 
SQLDISCONNECT(Con)	
ENDPROC 	
Function ReduceMemory()

Declare Integer SetProcessWorkingSetSize In kernel32 As SetProcessWorkingSetSize ;
Integer hProcess , ;
Integer dwMinimumWorkingSetSize , ;
Integer dwMaximumWorkingSetSize
Declare Integer GetCurrentProcess In kernel32 As GetCurrentProcess
nProc = GetCurrentProcess()
bb = SetProcessWorkingSetSize(nProc,-1,-1)
RETURN 

ENDFUNC 
FUNCTION urlEncode
		PARAMETERS tcValue, llNoPlus
		LOCAL lcResult, lcChar, lnSize, lnX
		
		*** Do it in VFP Code
		lcResult=""
 
		FOR lnX=1 to len(tcValue)

		   lcChar = SUBSTR(tcValue,lnX,1)
		   IF ATC(lcChar,"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") > 0
		      lcResult=lcResult + lcChar
		      LOOP
		   ENDIF
		   TRY
			   IF lcChar=" " AND !llNoPlus && AND 1=2 && AND  F1<>'中文'&&
			      lcResult = lcResult + "+"
			      LOOP
			   ENDIF
		   CATCH 
		   ENDTRY
		   *** Convert others to Hex equivalents
		   lcResult = lcResult + "%" + RIGHT(transform(ASC(lcChar),"@0"),2)
		ENDFOR
		lcResult=strt(lcResult,'+%20','%20')

		RETURN lcResult