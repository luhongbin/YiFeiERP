
PROCEDURE mocta220
CON=ODBC(5)
SQLEXEC(CON,"select TA001,TA002,TA033,TA006,TA034,TA035,CASE WHEN MD001 IS NULL THEN X.MA002 ELSE MD002 END MD002 ,TA011,TA013,MB080,"+;
"CONVERT(varchar(10), CAST(TA009 as datetime), 102) TA009,CONVERT(varchar(10), CAST(TA010 as datetime), 102) TA010,TA015,TA017,"+;
"'['+DATENAME( Wk,CAST( TA010 as datetime) )+'��]'+TA033 AS ZC,case when TA011='1' then 'δ����' WHEN TA011='2' THEN '�ѷ���' when TA011='3' THEN '������' END ZT "+;
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
	S=ALLTRIM(STR(RECNO()))+'.'+ALLTRIM(ZC)+'('+ALLTRIM(TA001)+ALLTRIM(TA002)+ALLTRIM(TTD)+':'+ALLTRIM(TA034)+',���:'+ALLTRIM(TA035)+'['+ALLTRIM(MD002)+']'+ALLTRIM(ZT)+ALLTRIM(STR(TA015-TA017))+'Pcs)Ԥ�ƿ���:'+ALLTRIM(TA009)+'-'+ALLTRIM(tA010)+CHR(13)+chr(10)
	IF LEN(ALLTRIM(T+S))<2200
		T=T+S
	ELSE
		T=T+CHR(13)+CHR(10)+'...'
		EXIT
	ENDIF
	SKIP
ENDDO		
mtitle='220��������������'
m_note=t+CHR(13)+CHR(10)+'�����ù�װ�оߣ����տ�������׼������!'

con=odbc(6)
SQLEXEC(CON,"SELECT  NAME FROM TREECODE WHERE fKey in (SELECT  KEYID FROM TREECODE WHERE name='����������֪ͨ��' )",'TmpClass')
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
IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,0)")<0
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
*!*		=DeleteUrlCacheEntry("http://www.smm.cn/") &&������
*!*		HINTERNETSESSION = INTERNETOPEN("http://www.smm.cn/",0,"","",0)
*!*		IF HINTERNETSESSION = 0
*!*		   WAIT WINDOW "���ܽ��� Internet �Ự��" TIMEOUT 2
*!*			tmpkeyid=maxinterid("rtxmessage")
*!*			keyidid1=ODBC(6)
*!*			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,'Ҧ���;�����;�ܺ�;³���;','³���',getdate(),'���ܽ��� Internet �Ự��,���������','ȡSMM����ʧ��',0)")<0
*!*				WAIT windows '????' nowait
*!*			ENDIF 
*!*			SQLDISCONNECT(con)
*!*		   RETURN -1
*!*		ENDIF
*!*		HURLFILE = INTERNETOPENURL(HINTERNETSESSION,"http://www.smm.cn/","",0,2147483648,0)
*!*		IF HURLFILE = 0
*!*			MESSAGEBOX('�޷���http://www.smm.cn/,����������Ա��ϵ!',0+47+1,P_Caption)
*!*			tmpkeyid=maxinterid("rtxmessage")
*!*			keyidid1=ODBC(6)
*!*			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,'Ҧ���;�����;�ܺ�;³���;','³���',getdate(),'�޷���http://www.smm.cn/,���������!','ȡSMM����ʧ��',0)")<0
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
=DeleteUrlCacheEntry("http://www.smm.cn/") &&������
HINTERNETSESSION = INTERNETOPEN("www.baidu.com",0,"","",0)
IF HINTERNETSESSION = 0
	IF HOUR(DATETIME())=17
		tmpkeyid=maxinterid("rtxmessage")
		keyidid1=ODBC(6)
		IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,'Ҧ���;³���;','³���',getdate(),'���ܽ��� Internet �Ự��,�����޷����ӻ�����,���������!','�޷�����',0)")<0
			WAIT windows '??�����;�ܺ�;??' nowait
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
		IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,'Ҧ���;³���;','³���',getdate(),'���ַ����������޷���½http://www.smm.cn/��վ,���������!','��SMMʧ��',0)")<0
			WAIT windows '????�����;�ܺ�;' nowait
		ENDIF 
		SQLDISCONNECT(keyidid1)
	ENDIF
	RETURN
ENDIF

 = InternetCloseHandle(HINTERNETSESSION)
= INTERNETCLOSEHANDLE(HURLFILE) 
	lcRemoteUrl="http://www.smm.cn/" 
	lcRemoteFile=lcRemoteUrl
	lcLocalFile = "c:\UTF8��ʽ4.txt"
	Declare Integer DeleteUrlCacheEntry In Wininet.Dll String szUrl
	Declare Integer URLDownloadToFile In urlmon.Dll Integer pCaller,String szURL,;
	    String szFileName,Integer dwReserved,Integer lpfnCB
	=DeleteUrlCacheEntry(lcRemoteUrl) &&������
	If URLDownloadToFile(0,lcRemoteFile,lcLocalFile,0,0)<>0
		IF URLDownloadToFile(0,lcRemoteFile,lcLocalFile,0,0)<>0
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,'Ҧ���;�����;�ܺ�;³���;','³���',getdate(),'�޷���http://www.smm.cn/��ȡ����!','ȡSMM����ʧ��',0)")<0
				WAIT windows '????' nowait
			ENDIF 
			SQLDISCONNECT(keyidid1)

		    RETURN
		 ENDIF 
	Endif
	COPY file c:\UTF8��ʽ4.txt to DTOC(DATE(),1)+'.txt'

    *2019.12.11���

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
	P_HRDEPT=STREXTRACT(STRCONV(FILETOSTR(MFILE),11),'<td class="c6">����</td>','<div class="main-top-ads-warp">',1) &&2019.12.11���,��Ϊ��4.1�տ�ʼ,SMM�������վ��ʽ,������½�ȡ����
	P_HRDEPT=STRt(P_HRDEPT,' "','"')
	P_HRDEPT=STRt(P_HRDEPT,'" ','"') 
	P_HRDEPT=STRt(P_HRDEPT,CHR(9),'')
	P_HRDEPT=STRt(P_HRDEPT,CHR(13),'')
	P_HRDEPT=STRt(P_HRDEPT,CHR(10),'')
*!*		P_HRDEPT=STRt(P_HRDEPT,STREXTRACT(P_HRDEPT,'<!--','-->',1),'')&&2017.5.1���,��Ϊ��4.1�տ�ʼ,SMM�������վ��ʽ,������½�ȡ����
*!*		P_HRDEPT=STRt(P_HRDEPT,STREXTRACT(P_HRDEPT,'<!--','-->',1),'')
	*apiStartTags ='<td class="name"'
	apiStartTags ='https://hq.smm.cn'&&'href="http://hq.smm.cn'&&2017.5.1���,��Ϊ��4.1�տ�ʼ,SMM�������վ��ʽ,������½�ȡ����
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
		IF yy='����ˮ'
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


	*P_HRDEPT=STREXTRACT(FILETOSTR("c:\UTF8��ʽ4.txt"),'<th>�г�</th>','<div class="tl-price" id="tabs-2" style="display:none">',1)
	*P_HRDEPT=STREXTRACT(STRCONV(FILETOSTR("c:\UTF8��ʽ4.txt"),11),'fifth">����</td>','<div class="content-left-first-footer">',1) &&2016.10.19���,��Ϊ��10.17�տ�ʼ,SMM�������վ��ʽ,������½�ȡ����
	*P_HRDEPT=STREXTRACT(STRCONV(FILETOSTR("c:\UTF8��ʽ4.txt"),11),'div class="box-body"','</tbody>',1)
*	P_HRDEPT=STREXTRACT(STRCONV(FILETOSTR("c:\UTF8��ʽ4.txt"),11),'content-left-first-pirce-table-fifth','</tbody>',1) &&2019.03.13�����ҳ��2019.06.10����
*!*		*2018.5.11�վͱ���ˣ�6.4�շ�������P_HRDEPT=STREXTRACT(STRCONV(FILETOSTR("c:\UTF8��ʽ4.txt"),11),'fifth">����</td>','</tbody>',1) &&2017.5.1���,��Ϊ��4.1�տ�ʼ,SMM�������վ��ʽ,������½�ȡ����
*!*		P_HRDEPT=STRt(P_HRDEPT,' "','"')
*!*		P_HRDEPT=STRt(P_HRDEPT,'" ','"') 
*!*		P_HRDEPT=STRt(P_HRDEPT,CHR(9),'')
*!*		P_HRDEPT=STRt(P_HRDEPT,CHR(13),'')
*!*		P_HRDEPT=STRt(P_HRDEPT,CHR(10),'')
*!*	*!*		P_HRDEPT=STRt(P_HRDEPT,STREXTRACT(P_HRDEPT,'<!--','-->',1),'')&&2017.5.1���,��Ϊ��4.1�տ�ʼ,SMM�������վ��ʽ,������½�ȡ����
*!*	*!*		P_HRDEPT=STRt(P_HRDEPT,STREXTRACT(P_HRDEPT,'<!--','-->',1),'')
*!*		*apiStartTags ='<td class="name"'
*!*		apiStartTags ='"https://hq.smm.cn'&&'href="http://hq.smm.cn'&&2017.5.1���,��Ϊ��4.1�տ�ʼ,SMM�������վ��ʽ,������½�ȡ����
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
*!*			IF yy='����ˮ'
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
  IF  sqlexec(con,"SELECT TB003,TB012 Ʒ��,TB013 ���,"+;
  "SUM(TB004) AS  ��������,SUM(TB005) AS  ��������,"+;
	" 0000000 ���½�� ,0000000 ������ת,0000000  as ��ɹ�����,0000000 ��;��, 0000000 �빺δ�ɹ� ,"+;
	"0000000 ����δ���,0000000  as ������Ҫ��,0000000 ����ֱ�Ӳɹ�,INVMB.MB036 ��ǰ��,"+;
	"MV002 AS �ɹ�Ա,CAST(MV002 AS CHAR(250)) PI,CMSMC.MC002,M.MC004,M.MC006  FROM MOCTA MOCTA INNER JOIN MOCTB ON TA001=TB001 AND TA002=TB002 "+;
	" INNER JOIN INVMB ON TB003 = INVMB.MB001 inner JOIN CMSMV ON INVMB.MB067 = CMSMV.MV001 LEFT JOIN  COPTC ON TA033=RTRIM(TC001)+TC002 "+;
		"  LEFT JOIN COPMA ON TC004=COPMA.MA001 "+;
	"left JOIN INVMA CA ON CA.MA002=INVMB.MB006 AND CA.MA001='2'  LEFT JOIN CMSMC AS CMSMC ON INVMB.MB017=CMSMC.MC001  LEFT JOIN INVMC M ON MB017=M.MC002 AND MB001=M.MC001 "+;
	" where year(dateadd(day,0-ISNULL(INVMB.MB036,0),TB015))*100+cast(DATENAME( Wk,dateadd(day,0-ISNULL(INVMB.MB036,0),TB015)) as int)<=?EEND and MOCTA.TA011<='3' AND TA013='Y' "+;
	" and  MOCTA.TA013='Y' AND CA.MA003<>'�ʰ�'  AND INVMB.MB006<>'990050' AND TB003<'A' AND INVMB.MB025='P' and TB004<>TB005 and M.MC001<>'98' "+;
	" AND not exists (select 'x' from MOCTA T INNER JOIN INVMB M ON T.TA006=M.MB001 WHERE T.TA033=MOCTA.TA033 AND T.TA006=TB003 AND (MOCTB.TB004=MOCTB.TB005 OR T.TA015-T.TA017<=M.MB064)) "+;
	"  AND MV002<>'³����' And COPMA.MA002 NOT LIKE '%PHILIPS(OEM)%' AND INVMB.MB042<>'2' GROUP BY TB003,TB012 ,TB013,MV002,INVMB.MB036,CMSMC.MC002,M.MC004,M.MC006 " ,"TmpMakeBuy1")<0  
		WAIT WINDOWS 'ERROR'
		RETURN
*		" and not exists (select 'x' from PURTD WHERE MOCTA.TA033=TD024 AND TD004=TB003 AND TD018='Y') AND&&AND MOCTA.UDF56=1MOCTA.UDF03>=?FEND AND  "+;
*	" AND not exists (select 'x' from MOCTA T INNER JOIN INVMB M ON T.TA006=M.MB001 WHERE T.TA033=MOCTA.TA033 AND T.TA006=TB003 AND (MOCTB.TB004=MOCTB.TB005 OR T.TA015-T.TA017<=M.MB064)) "+;

	ENDIF

SQLEXEC(con,"SELECT TB004,SUM(TB007) TB007 FROM INVTB INNER JOIN INVTA ON TA001=TB001 AND TA002=TB002 WHERE  "+;
" TA006='N' AND (TB013='21' OR TB013='23') AND TB018='Y'  GROUP BY TB004","TMWP3") && LEFT(TA003 ,4)+'.'+DATENAME( Wk,CAST(TA003 AS DATETIME))>=?FEND AND AND LEFT(TA003 ,4)+'.'+DATENAME( Wk,CAST(TA003 AS DATETIME))<=?EEND

 SELECT TmpMakeBuy1

lcmsg = '������������Ҫ������...'
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
*!*			REPLACE �������� WITH XX+XX1
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
		REPLACE �빺δ�ɹ� WITH	 CODE31ID1 	
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
		REPLACE ����ֱ�Ӳɹ� WITH	 CODE31ID2
		SELECT TMWP3
		LOCATE FOR TB004=KEYTXT
		IF FOUND()
			CODE2ID=TB007 
		ELSE
			CODE2ID=0
		ENDIF
		SELECT tmpmakebuy1
		REPLACE ������Ҫ�� WITH ��������,�������� WITH ��������+CODE2ID+����ֱ�Ӳɹ�,����δ��� WITH CODE2ID	
		IF SQLEXEC(CON,"SELECT SUM(PURTD.TD008-PURTD.TD015) as ��;�� FROM PURTD WHERE PURTD.TD016='N' AND PURTD.TD018='Y' AND PURTD.TD004=?KEYTXT ","TMP3")<0
			WAIT windows '????????'
		endif	
		MKEYID=0
		SELECT TMP3
		IF RECCOUNT()=1
			IF !ISNULL(��;��)
				MKEYID=��;��
				SQLEXEC(CON,"SELECT MD003/MD004 XS1 FROM  INVMD WHERE MD001=?keytxt ","ctmp1")
				IF RECCOUNT()=1
					MKEYID=MKEYID*xs1
				ENDIF 
			ENDIF
		ENDIF
		SQLEXEC(CON,"SELECT SUM(TA015-TA017+TA018) AS ��;�� FROM MOCTA WHERE TA030='2' AND TA006=?KEYTXT AND CAST(LEFT(TA010,4) as int)*100+"+;
		"cast(DATENAME( Wk,CAST(TA010 AS DATETIME)) as int)<=?EEND AND TA011<='3'  AND TA013='Y'","TMP4")  && and UDF56=1
		IF !ISNULL(��;��)
			MKEYID=��;��+MKEYID
		ENDIF
				
		SELECT TmpMakeBuy1
		REPLACE ��;�� WITH MKEYID


	SQLEXEC(con,"SELECT MC007  FROM INVMC  WHERE MC002='50' AND MC001=?KEYTXT","TMP3")
	SELECT tmp3
	IF RECCOUNT()=1
		IF ISNULL(MC007)
	  		CODEID=0
	  	ELSE
		  	codeid=MC007
	  	ENDIF
		SELECT TmpMakeBuy1
		REPLACE ������ת WITH CODEID
		Closedb("TMP3")
	ELSE 
		SELECT TmpMakeBuy1
		REPLACE ������ת WITH 0
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
		REPLACE ���½�� WITH CODEID
		Closedb("TMP3")
	ELSE 
		SELECT TmpMakeBuy1
		REPLACE ���½�� WITH 0
	ENDIF 

	SELECT TmpMakeBuy1
	replace ��ɹ����� WITH  ��������-��������-���½��-������ת-��;��

	SELECT TmpMakeBuy1
	skip
 ENDDO    
     
  closedb("TmpMakeBuyBY")
   	SELECT distinct �ɹ�Ա FROM TmpMakeBuy1 WHERE ��ɹ�����>0  INTO CURSOR TmpMake
   	SELECT tmpmake
   	GO top
DO whil .not. EOF()
	xxx=ALLTRIM(�ɹ�Ա)
	closedb("TmpMakeBuyBY")
   	SELECT * FROM TmpMakeBuy1 WHERE ��ɹ�����>0 AND �ɹ�Ա=xxx ORDER BY 8 desc INTO CURSOR TmpMakeBuyBY READWRITE 
	SELECT TmpMakeBuyBY
	TT=RECCOUNT()
	mtitle=xxx+'['+ALLTRIM(STR(EEND))+'��ǰ'+ALLTRIM(STR(TT))+']ȱ�ϣ�'
	m_note1=''
*!*		mtitle='��['+ALLTRIM(STR(eend))+']��֮ǰ'
*!*		m_note1=xxx+'����['+ALLTRIM(STR(TT))+']�ֻ�Ʒȱ�ϣ�'
	mrev='����Ƽ;'&&+xxx+';'

	GO TOP
	s=''
	DO WHILE .NOT. EOF()
		IF  MC002='��װ��'
			IF '��ӨӨ;'$mrev=.F.
				mrev=mrev+'��ӨӨ;'
			ENDIF	
		ELSE
			IF '��Ƽ��;'$mrev=.F.
				mrev=mrev+'��Ƽ��;'
			ENDIF	
		ENDIF 
		KEYTXT=ALLT(TB003)
		FD=''

		IF ��ǰ��<>0
			FD='��ǰ['+ALLTRIM(STR(��ǰ��))+'��]'
		ENDIF	
		IF MC004<>0
			FD=FD+'��ȫ��['+ALLTRIM(STR(INT(MC004)))+']'
		ENDIF	
		IF MC006<>0
			FD=FD+'��������['+ALLTRIM(STR(INT(MC006)))+']'
		ENDIF
		SQLEXEC(CON,"SELECT distinct TA001+TA002 AS UDF55, convert(char(10),CAST(TB015 as datetime),102) Ҫ����,COPMA.MA002 AS �ͻ����� "+;
		"FROM MOCTA INNER JOIN MOCTB ON TA001=TB001 and TA002=TB002 LEFT JOIN  COPTC ON TA033=RTRIM(TC001)+TC002 "+;
		"  LEFT JOIN COPMA ON TC004=COPMA.MA001 inner join INVMB ON TB003=MB001 "+;
		"WHERE year(dateadd(day,0-ISNULL(INVMB.MB036,0),TB015))*100+cast(DATENAME( Wk,dateadd(day,0-ISNULL(INVMB.MB036,0),TB015)) as int)<=?EEND and COPMA.MA002 NOT LIKE '%PHILIPS(OEM)%' "+;
		" AND not exists (select 'x' from MOCTA T INNER JOIN INVMB M ON T.TA006=M.MB001 WHERE T.TA033=MOCTA.TA033 AND T.TA006=TB003 AND (MOCTB.TB004=MOCTB.TB005 OR T.TA015-T.TA017<=M.MB064)) "+;
		"AND TB004<>TB005 AND TB003=?KEYTXT AND TB004>TB005 AND MOCTA.TA011<='3'  AND MOCTA.TA013='Y' ORDER BY 2","TMP")  &&and MOCTA.UDF56=1 CAST(LEFT(TB015,4) as int)*100+cast(DATENAME( Wk,CAST(TB015 AS DATETIME)) as int)-ISNULL(INVMB.MB036,0)<=?EEND 
		SELECT TMP
		GO TOP
		DO WHILE .NOT. EOF()
			IF LEN(FD)<210
				IF ISNULL(�ͻ�����)
					FD=FD+ALLTRIM(UDF55)+'('+ALLTRIM(Ҫ����)+')��'
				ELSE
					FD=FD+ALLTRIM(UDF55)+'('+ALLTRIM(Ҫ����)+')['+ALLTRIM(�ͻ�����)+']��'
				ENDIF	
			ELSE
				FD=FD+'...'
				EXIT
			ENDIF	
			SKIP
		ENDDO
		SELECT TmpMakeBuyBY
		REPLACE PI WITH FD
		S=S+ALLTRIM(STR(RECNO()))+'.'+ALLTRIM(Ʒ��)+ALLTRIM(���)+'['+ALLTRIM(KEYTXT)+','+ALLTRIM(�ɹ�Ա)+']ȱ��:'+ALLTRIM(STR(��ɹ�����))+'='
		IF ������Ҫ��>0
			s=s+ALLTRIM(STR(������Ҫ��-��������))+'(����)'
		ENDIF 
		IF ����ֱ�Ӳɹ�>0
			s=s+'+'+ALLTRIM(STR(����ֱ�Ӳɹ�))+'(����)'
		ENDIF 
		IF ����δ���>0
			s=s+'+'+ALLTRIM(STR(����δ���))+'(����)'
		ENDIF 
*!*			IF ��������>0
*!*				s=s+'-'+ALLTRIM(STR(��������))+'(��������)'
*!*			ENDIF 
		IF ��;��>0
			s=s+'-'+ALLTRIM(STR(��;��))+'(��;)'
		ENDIF
		IF ���½��>0
			s=s+'-'+ALLTRIM(STR(���½��))+'(����)'
		ENDIF 
		IF ������ת>0
			s=s+'-'+ALLTRIM(STR(������ת))+'(��ת)'
		ENDIF		
		IF �빺δ�ɹ�>0
			s=s+'[�빺δ�ɹ�:'+ALLTRIM(STR(�빺δ�ɹ�))+']'
		ENDIF 
		s=s+'['+ALLTRIM(FD)+']'+CHR(13)+CHR(10)
		SKIP
	ENDDO	
	
	DO CASE 	
		CASE  LEN(ALLTRIM(m_note1+s))<=2200 
			m_note=ALLTRIM(LEFT(m_note1+s,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
		CASE  LEN(ALLTRIM(m_note1+s))>2200  AND LEN(ALLTRIM(m_note1+s))<=4400
			m_note=ALLTRIM(SUBS(m_note1+s,1,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,2201,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
		CASE  LEN(ALLTRIM(m_note1+s))>4400  AND LEN(ALLTRIM(m_note1+s))<=6600
			m_note=ALLTRIM(LEFT(m_note1+s,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,2201,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,4401,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
		CASE  LEN(ALLTRIM(m_note1+s))>6600  AND LEN(ALLTRIM(m_note1+s))<=8800
			m_note=ALLTRIM(LEFT(m_note1+s,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,2201,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,4401,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 	
			m_note=ALLTRIM(SUBS(m_note1+s,6601,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 	
		OTHERWISE 
			m_note=ALLTRIM(LEFT(m_note1+s,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,2201,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,4401,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 	
			m_note=ALLTRIM(SUBS(m_note1+s,6601,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 	
			m_note=ALLTRIM(SUBS(m_note1+s,8801,2200))+'...'
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 			
	ENDCASE	
	SQLDISCONNECT(keyidid1)
	SELECT tmpmake
	SKIP
ENDDO 	


********************************************************************************

con=odbc(5)

  IF  sqlexec(con,"SELECT TD004,TD005 Ʒ��,TD006 ���,"+;
  "SUM(TD008-TD015) AS ��;��,"+;
	" 0000000 ���½�� ,0000000 ������ת,0000000  as ��������,0000000 ��ɹ�����, 0000000 �빺δ�ɹ� ,"+;
	"0000000 ����δ���,0000000  as ������Ҫ��,0000000 ����ֱ�Ӳɹ�,INVMB.MB036 ��ǰ��,"+;
	"MV002 AS �ɹ�Ա,CAST(MV002 AS CHAR(250)) PI,CMSMC.MC002,isnUll(M.MC004,0) MC004,ISNULL(M.MC006,0) MC006,INVMB.MB410  "+;
	"FROM PURTC AS PURTC INNER JOIN PURTD ON TC001=TD001 AND TC002=TD002 "+;
	" INNER JOIN INVMB ON TD004 = INVMB.MB001 inner JOIN CMSMV ON MB067 = CMSMV.MV001 "+;
	"left JOIN INVMA CA ON CA.MA002=INVMB.MB006 AND CA.MA001='2'  LEFT JOIN CMSMC as CMSMC ON INVMB.MB017=CMSMC.MC001 LEFT JOIN INVMC M ON MB017=M.MC002 AND MB001=M.MC001  "+;
	" where  PURTD.TD016='N' AND PURTD.TD018<>'V' AND TD024 NOT LIKE '227%' and TD026<>'312' "+;
	" AND CA.MA003<>'�ʰ�'  AND INVMB.MB006<>'990050' AND TD004<'A' and CMSMC.MC001<>'98'  and TD008<>0 "+;
	"  AND MV002<>'³����'  AND INVMB.MB042<>'2' GROUP BY TD004,TD005,TD006,MV002,INVMB.MB036,CMSMC.MC002,ISNULL(M.MC004,0),ISNULL(M.MC006,0),INVMB.MB410 " ,"TmpMakeBuy1")<0  
		WAIT WINDOWS 'ERROR'
		RETURN
*		" and not exists (select 'x' from PURTD WHERE MOCTA.TA033=TD024 AND TD004=TB003 AND TD018='Y') AND&&AND MOCTA.UDF56=1MOCTA.UDF03>=?FEND AND  "+;
*	" AND not exists (select 'x' from MOCTA T INNER JOIN INVMB M ON T.TA006=M.MB001 WHERE T.TA033=MOCTA.TA033 AND T.TA006=TB003 AND (MOCTB.TB004=MOCTB.TB005 OR T.TA015-T.TA017<=M.MB064)) "+;

	ENDIF

SQLEXEC(con,"SELECT TB004,SUM(TB007) TB007 FROM INVTB INNER JOIN INVTA ON TA001=TB001 AND TA002=TB002 WHERE  "+;
" TA006='N' AND (TB013='21' OR TB013='23') AND TB018='Y'  GROUP BY TB004","TMWP3") && LEFT(TA003 ,4)+'.'+DATENAME( Wk,CAST(TA003 AS DATETIME))>=?FEND AND AND LEFT(TA003 ,4)+'.'+DATENAME( Wk,CAST(TA003 AS DATETIME))<=?EEND

 SELECT TmpMakeBuy1

lcmsg = '������������Ҫ������...'
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
		REPLACE �빺δ�ɹ� WITH	 CODE31ID1 	
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
		REPLACE ����ֱ�Ӳɹ� WITH	 CODE31ID2
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

		REPLACE ������Ҫ�� WITH XX,�������� WITH XX+CODE2ID+����ֱ�Ӳɹ�,����δ��� WITH CODE2ID	

				


	SQLEXEC(con,"SELECT MC007  FROM INVMC  WHERE MC002='50' AND MC001=?KEYTXT","TMP3")
	SELECT tmp3
	IF RECCOUNT()=1
		IF ISNULL(MC007)
	  		CODEID=0
	  	ELSE
		  	codeid=MC007
	  	ENDIF
		SELECT TmpMakeBuy1
		REPLACE ������ת WITH CODEID
		Closedb("TMP3")
	ELSE 
		SELECT TmpMakeBuy1
		REPLACE ������ת WITH 0
	ENDIF 

	SQLEXEC(con,"SELECT SUM(X.MC007) MC007 FROM INVMC X LEFT JOIN CMSMC Y ON X.MC002=Y.MC001"+;
	" WHERE X.MC001=?KEYTXT AND X.MC002<>'50' AND  X.MC002<>'19'  AND X.MC002<>'21'  AND X.MC002<>'22' AND Y.MC002 NOT LIKE '%�ֳ�%'","TMP3")
	SELECT tmp3
	IF RECCOUNT()=1
		IF ISNULL(MC007)
	  		CODEID=0
	  	ELSE
	  		codeid=MC007
	  	ENDIF
		SELECT TmpMakeBuy1
		REPLACE ���½�� WITH CODEID
		Closedb("TMP3")
	ELSE 
		SELECT TmpMakeBuy1
		REPLACE ���½�� WITH 0
	ENDIF 

	SELECT TmpMakeBuy1
	replace ��ɹ����� WITH ������Ҫ��*1.03+����ֱ�Ӳɹ�*1.03+����δ���*1.03+MC004-���½��-������ת

	SELECT TmpMakeBuy1
	skip
 ENDDO    
     
  closedb("TmpMakeBuyBY")
   	SELECT distinct �ɹ�Ա FROM TmpMakeBuy1 WHERE  ��;��-��ɹ�����>MC006 AND ��;��-��ɹ�����>MB410  INTO CURSOR TmpMake
   	SELECT tmpmake
   	GO top
DO whil .not. EOF()
	xxx=ALLTRIM(�ɹ�Ա)
	closedb("TmpMakeBuyBY")
   	SELECT ��;��-IIF(��ɹ�����<0,0,��ɹ�����) TC,* FROM TmpMakeBuy1 WHERE ��;��-��ɹ�����>MC006  AND ��;��-��ɹ�����>MB410 AND �ɹ�Ա=xxx ORDER BY 1 desc INTO CURSOR TmpMakeBuyBY READWRITE 
	SELECT TmpMakeBuyBY
	TT=RECCOUNT()
	mtitle=xxx+'['+ALLTRIM(STR(EEND))+'��ǰ'+ALLTRIM(STR(TT))+']��ʣ��'
	m_note1=''
	mrev='����Ƽ;'&&+xxx+';'

	GO TOP
	s=''
	DO WHILE .NOT. EOF()
		IF  MC002='��װ��'
			IF '��ӨӨ;'$mrev=.F.
				mrev=mrev+'��ӨӨ;'
			ENDIF	
		ELSE
			IF '��Ƽ��;'$mrev=.F.
				mrev=mrev+'��Ƽ��;'
			ENDIF	
		ENDIF 
		KEYTXT=ALLT(TD004)
		FD=''

		IF ��ǰ��<>0
			FD='��['+ALLTRIM(STR(��ǰ��))+'��]'
		ENDIF	
		IF MC004<>0
			FD=FD+'��ȫ��['+ALLTRIM(STR(INT(MC004)))+']'
		ENDIF	
		IF MC006<>0
			FD=FD+'��������['+ALLTRIM(STR(INT(MC006)))+']'
		ENDIF
		IF MB410<>0
			FD=FD+'����['+ALLTRIM(STR(INT(MB410)))+']'
		ENDIF
		SQLEXEC(CON,"SELECT distinct TD001+RTRIM(TD002)+'-'+TD003 AS UDF55, convert(char(10),CAST(TD012 as datetime),102) Ҫ����,TD008-TD015 AS ����,TD018 "+;
		"FROM PURTC AS PURTC INNER JOIN PURTD ON TC001=TD001 AND TC002=TD002 "+;
		"WHERE   PURTD.TD016='N' AND PURTD.TD018<>'V' AND TD004=?KEYTXT AND TD026<>'312' and TD008<>0 AND TD024 NOT LIKE '227%' ORDER BY 2 desc","TMP") 
		SELECT TMP
		GO TOP
		DO WHILE .NOT. EOF()
			IF LEN(FD)<210
				FD=FD+ALLTRIM(UDF55)+'('+ALLTRIM(Ҫ����)+')'+TD018+'['+ALLTRIM(STR(INT(����)))+']��'
			ELSE
				FD=FD+'...'
				EXIT
			ENDIF	
			SKIP
		ENDDO
		SELECT TmpMakeBuyBY
		REPLACE PI WITH FD
		fdddd=������Ҫ��+����ֱ�Ӳɹ�+����δ���-���½��-������ת  &&+MC004
		S=S+ALLTRIM(STR(RECNO()))+'.'+ALLTRIM(Ʒ��)+ALLTRIM(���)+'['+ALLTRIM(KEYTXT)+','+ALLTRIM(�ɹ�Ա)+']��ʣ:'+ALLTRIM(STR(��;��-IIF(fdddd>0,fdddd,0)))+'='
		IF ��;��>0
			s=s+ALLTRIM(STR(��;��))+'(�ɹ�)��'+ALLTRIM(STR(fdddd))+'(ȱ��)'
		ENDIF
		S=S+',ȱ��='
		IF ������Ҫ��>0
			s=s+ALLTRIM(STR(������Ҫ��))+'(����)'
		ENDIF 
		IF ����ֱ�Ӳɹ�>0
			s=s+'+'+ALLTRIM(STR(����ֱ�Ӳɹ�))+'(����)'
		ENDIF 
		IF ����δ���>0
			s=s+'+'+ALLTRIM(STR(����δ���))+'(����)'
		ENDIF 
*!*			IF INT(��ɹ�����*0.03)>0
*!*				s=s+'+'+ALLTRIM(STR(INT(��ɹ�����*0.03)))+'(���)'
*!*			ENDIF 
*!*			IF MC004>0
*!*				s=s+'+'+ALLTRIM(STR(INT(MC004)))+'(��ȫ)'
*!*			ENDIF 

		IF ���½��>0
			s=s+'-'+ALLTRIM(STR(���½��))+'(����)'
		ENDIF 
		IF ������ת>0
			s=s+'-'+ALLTRIM(STR(������ת))+'(��ת)'
		ENDIF		
		IF �빺δ�ɹ�>0
			s=s+'[�빺δ�ɹ�:'+ALLTRIM(STR(�빺δ�ɹ�))+']'
		ENDIF 
		s=s+'{'+ALLTRIM(FD)+'}'+CHR(13)+CHR(10)
		SKIP
	ENDDO	
	DO CASE 	
		CASE  LEN(ALLTRIM(m_note1+s))<=2200 
			m_note=ALLTRIM(LEFT(m_note1+s,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
		CASE  LEN(ALLTRIM(m_note1+s))>2200  AND LEN(ALLTRIM(m_note1+s))<=4400
			m_note=ALLTRIM(LEFT(m_note1+s,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,2201,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
		CASE  LEN(ALLTRIM(m_note1+s))>4400  AND LEN(ALLTRIM(m_note1+s))<=6600
			m_note=ALLTRIM(LEFT(m_note1+s,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,2201,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,4401,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
		CASE  LEN(ALLTRIM(m_note1+s))>6600  AND LEN(ALLTRIM(m_note1+s))<=8800
			m_note=ALLTRIM(LEFT(m_note1+s,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,2201,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,4401,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 	
			m_note=ALLTRIM(SUBS(m_note1+s,6601,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 	
		OTHERWISE 
			m_note=ALLTRIM(LEFT(m_note1+s,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,2201,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 
			m_note=ALLTRIM(SUBS(m_note1+s,4401,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 	
			m_note=ALLTRIM(SUBS(m_note1+s,6601,2200))
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
				WAIT windows '????' nowait
			ENDIF 	
			m_note=ALLTRIM(SUBS(m_note1+s,8801,2200))+'...'
			tmpkeyid=maxinterid("rtxmessage")
			keyidid1=ODBC(6)
			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,10)")<0
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
"CMSMV.MV002,RTRIM(COPMA.MA002)+'('+RTRIM(COPMA.MA001)+')' AS MA002,rtrim(ACRTA.TA001)+rtrim(ACRTA.TA002) AS ����,CAST('��Ʊ:'+RTRIM(ACRTA.TA036)+'/'+RTRIM(ACRTA.TA015)+'['+RTRIM(CMSNA.NA003)+"+;
"']('+RTRIM(str((ACRTA.TA029+ACRTA.TA030-ACRTA.TA031)*(case when ACRTA.TA079='1' then 1 else -1 end),8,2))+ACRTA.TA009+')��'+"+;
"str(datediff(day,ACRTA.TA020,getdate()),3,0)+'��('+CONVERT(varchar(10), CAST(ACRTA.TA020 as datetime), 102)+DATENAME( weekday, CAST(ACRTA.TA020 as datetime))"+;
"+')'+CASE WHEN ACRTQ.TQ006 IS NULL OR ACRTQ.TQ006='' THEN '' ELSE ACRTQ.TQ006 END+"+;
"CASE WHEN ACRTA.UDF51 IS NULL OR ACRTA.UDF51=0 THEN '' ELSE ',���ز���:'+str(isnull(ACRTA.UDF51,0),7,2) END AS CHAR(200)) AS NOTE "+;
"from ACRTA left join CMSME on ME001=TA070 LEFT JOIN COPMA ON MA001=TA004 left join CMSMV on MV001=COPMA.MA016 "+;
"left join ACRTQ on ACRTQ.TQ002=ACRTA.TA001 and ACRTQ.TQ003=ACRTA.TA002 and ACRTQ.CREATE_DATE=(select max(ACRTQ.CREATE_DATE) "+;
" from ACRTQ where ACRTQ.TQ002=ACRTA.TA001 and ACRTQ.TQ003=ACRTA.TA002) left join CMSNA on CMSNA.NA001='2' and CMSNA.NA002=ACRTA.TA043  "+;
" where (TA029+TA030-TA031)*(case when TA079='1' then 1 else -1 end)<>0 and ACRTA.TA025 = 'Y' and  rtrim(ACRTA.TA001)+rtrim(ACRTA.TA002)"+;
" not in ('665201208003','665201208022')  and datediff(day,ACRTA.TA020,getdate())>=-7  "+;
"union all "+;
"SELECT ACRTK.TK003,CMSMV.MV001,(TK032+TK034-ACRTK.TK037)*ACRTK.TK008,"+;
"CMSMV.MV002,RTRIM(COPMA.MA002)+'('+RTRIM(COPMA.MA001)+')' AS MA002,rtrim(ACRTK.TK001)+rtrim(ACRTK.TK002) AS ����,"+;
"CAST('Ԥ��:'+RTRIM(ACRTK.TK009)+'['+RTRIM(CMSNA.NA003)+']('+RTRIM(str((TK032+TK034-ACRTK.TK037),8,2))+"+;
"ACRTK.TK007+')��'+str(datediff(day,ACRTK.TK003,getdate()),3,0)+'��('+CONVERT(varchar(10), CAST(ACRTK.TK003 as datetime), 102)+DATENAME( weekday, CAST(ACRTK.TK003 as datetime))+')' AS CHAR(200)) from ACRTK  "+;
"left join COPMA ON COPMA.MA001=ACRTK.TK004 left join CMSMV on CMSMV.MV001=COPMA.MA016 left join CMSNA on CMSNA.NA001='2' and CMSNA.NA002=COPMA.MA083 "+;
"where (ACRTK.TK030 <> '3') AND (ACRTK.TK020 = 'Y') and datediff(day,ACRTK.TK003,getdate())>=30 ","TMP")
SQLDISCONNECT(CON)
REPLACE note WITH STRTRAN(note,	CHR(9), "") ALL
REPLACE note WITH STRTRAN(note, " ", "") ALL

	closedb("TMPSALES")
	SELECT DISTINCT MV002 as ҵ��Ա,MV001,MA002 FROM tmp INTO CURSOR TMPSALES
	SELECT TMPSALES
	GO TOP
	DO WHIL .NOT. EOF()
		XXX=ALLTRIM(ҵ��Ա)
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
		
		m_note=ZZZ+':����['+ALLTRIM(STR(RECCOUNT()))+']������Ӧ����Ԥ��,�ܶ�('+ALLTRIM(STR(INT(wdet)))+'Ԫ)��'
		mtitle='['+ALLTRIM(XXX)++']'+'����Ӧ����Ԥ��'

		GO TOP
		T=''
		DO WHIL .NOT. EOF()

			IF LEN(ALLTRIM(T+ALLTRIM(note)))<1500
				T=T+ALLTRIM(STR(RECNO()))+'.'+ALLTRIM(����)+ALLTRIM(note)+CHR(13)+CHR(10)
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
		mrev=ALLTRIM(XXX)+';л����;'
		CON=ODBC(11)
		sqlexec(con,"select a.CnName from Employee as a  left join Job as F on A.JobId=F.JobId left join EmployeePartJob as g on A.EmployeeID=g.EmployeeID "+;
		"left join Job as y on g.JobId=y.JobId  where (rTRIM(f.Name)='���ۻ��' or rTRIM(y.Name)='���ۻ��' ) AND EmployeeStateId<>'EmployeeState3001'","tmpempinfo")		
		SQLDISCONNECT(CON)
		
		IF RECCOUNT()>=1
			GO TOP 
			DO whil .not. EOF()
				mrev=mrev+ALLTRIM(CnName)+';'
				SKIP
			ENDDO 	
		ENDIF 

		SELECT TMPBUYETR  
		m_note=m_note+CHR(13)+CHR(10)+T+CHR(13)+CHR(10)+'__________________________________________________'+CHR(13)+CHR(10)+'ע��Ӧ����Ԥ�ս����ڻ�������,�뼰ʱ���߻�У�ԣ�����30�����ѱ��ˣ�����45�����ѱ��˺Ͳ������ܡ�'
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
			IF ALLTRIM(Director)<>'����'
				mrev=mrev+ALLTRIM(Director)+';Ҧ���;'
			ELSE
				mrev=mrev+';Ҧ���;'
			ENDI	
*!*				CDATE2=DTOC(DATE()-60,1)
*!*				IF XTI003<CDATE2 AND !EMPTY(cnname)
*!*					mrev=mrev+ALLTRIM(cnname)+';ʢ�ܻ�;'
*!*				ENDIF
*!*				CDATE2=DTOC(DATE()-100,1)
*!*				IF XTI003<CDATE2 
*!*					mrev=mrev+'�µ���;'
*!*				ENDIF

		ENDIF

		
		tmpkeyid=maxinterid("rtxmessage")
		keyidid1=ODBC(6)

*!*			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,0)")<0
*!*				WAIT windows '????��������'+mrev nowait
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
	SQLEXEC(CON,"select PURTJ.TJ001+ PURTJ.TJ002+PURTJ.TJ003+'['+rtrim(PURMA.MA002)+']'+rtrim(INVMB.MB001)+':'+rtrim(INVMB.MB002)+rtrim(INVMB.MB003)+',����:'+"+;
	"LTRIM(str(PURTJ.TJ048-PURTJ.TJ036,6))+"+;
	"'('+LTRIM(str((PURTJ.TJ032+PURTJ.TJ033)/PURTJ.TJ048*(PURTJ.TJ048-PURTJ.TJ036),10,2))+'Ԫ)��'+lTRIM(str(datediff(day,PURTI.TI003,getdate()),3,0))+'�죡' as yxh,PURTI.TI003,"+;
	"CMSMV.MV002,CMSMV.MV001,PURMA.MA002,PURTJ.TJ032+PURTJ.TJ033 cash "+;
	"from DEMO.dbo.PURTI LEFT JOIN PURTJ ON PURTJ.TJ001=PURTI.TI001 AND PURTJ.TJ002=PURTI.TI002 LEFT JOIN PURMA ON PURMA.MA001=PURTI.TI004 "+;
	"LEFT JOIN INVMB on INVMB.MB001=PURTJ.TJ004	left join CMSMV on CMSMV.MV001=INVMB.MB067	where (PURTJ.TJ048-PURTJ.TJ036 <>0) "+;
	"and (PURTI.TI013 = 'Y') and (PURTJ.TJ020='Y' and PURTI.TI003<?cdate) ","TMP")
	SQLEXEC(CON,"select MOCTL.TL001+MOCTL.TL002+MOCTL.TL003+'['+rtrim(PURMA.MA001)+' '+rtrim(PURMA.MA002)+']'+ "+;
	"rtrim(INVMB.MB001)+':'+rtrim(INVMB.MB002)+rtrim(INVMB.MB003)+',����:'+LTRIM(str(MOCTL.TL009-MOCTL.TL035,5,0))+'('+LTRIM(str((MOCTL.TL031+MOCTL.TL032)"+;
	"/MOCTL.TL009*(MOCTL.TL009-MOCTL.TL035),8,2))+'Ԫ)��'+ "+;
	"lTRIM(str(datediff(day,MOCTK.TK003,getdate()),3,0))+'�죡',MOCTK.TK003,CMSMV.MV002,CMSMV.MV001,PURMA.MA002,MOCTL.TL031+MOCTL.TL031 cash "+;
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
	SELECT DISTINCT MV002 as ҵ��Ա,MV001 FROM tmp INTO CURSOR TMPSALES
	SELECT TMPSALES
	GO TOP
	DO WHIL .NOT. EOF()
		XXX=ALLTRIM(ҵ��Ա)
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
		
		m_note='����['+ALLTRIM(STR(RECCOUNT()))+']��δ��Ʊ��ҫ̩ERP�˻�������,�ܶ�('+ALLTRIM(STR(INT(wdet)))+'Ԫ)��'
		mtitle='['+ALLTRIM(XXX)+']�����˻���'

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
		sqlexec(con,"select a.CnName from Employee as a  left join Job as F on A.JobId=F.JobId where rTRIM(f.Name)='�ɹ����' AND EmployeeStateId<>'EmployeeState3001'","tmpempinfo")		
		SQLDISCONNECT(CON)
		IF RECCOUNT()>=1
			mrev=ALLTRIM(XXX)+';'+ALLTRIM(CnName)+';'
		ENDIF 

		SELECT TMPBUYETR  
		m_note=m_note+CHR(13)+CHR(10)+T+CHR(13)+CHR(10)+'__________________________________________________'+CHR(13)+CHR(10)+'ע���ѳ���30��,�뼰ʱ���߶Է���λ��Ʊ���ˣ�����30�����ѱ��ˣ�����45�����ѱ��˺Ͳ�������,������60�����ѱ��˺Ͳ�������,�����ܼࣻ����100�챨��˾���������顣'
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
			mrev=mrev+ALLTRIM(Director)+';Ҧ���;'
			CDATE2=DTOC(DATE()-60,1)
			IF XTI003<CDATE2 AND !EMPTY(cnname)
				mrev=mrev+ALLTRIM(cnname)+';ʢ�ܻ�;'
			ENDIF
			CDATE2=DTOC(DATE()-100,1)
			IF XTI003<CDATE2 
				mrev=mrev+'�µ���;'
			ENDIF

		ENDIF

		
		tmpkeyid=maxinterid("rtxmessage")
		keyidid1=ODBC(6)

*!*			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,0)")<0
*!*				WAIT windows '????��������'+mrev nowait
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
	SELECT DISTINCT MV002 as ҵ��Ա,MV001  FROM TMD1 WHERE LEFT(MV001,1)='Y' INTO CURSOR TMPSALES
	SELECT TMPSALES
	GO TOP
	DO WHIL .NOT. EOF()
		XXX=ALLTRIM(ҵ��Ա)
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
		m_note='����['+ALLTRIM(STR(RECCOUNT()))+']��Ԥ�������ڣ�'
		mtitle='['+ALLTRIM(XXX)+']����Ԥ����'

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
				S=SUBSTR(TK003,1,4)+'.'+SUBSTR(TK003,5,2)+'.'+SUBSTR(TK003,7,2)+'('+TK001+ALLTRIM(TK002)+BT+')Ԥ��:'+ALLTRIM(STR(INT(YE)))+ALLTRIM(TK007)+CHR(13)+chr(10)
			ELSE
				S=ALLTRIM(STR(RECNO()))+'.'+SUBSTR(TK003,1,4)+'.'+SUBSTR(TK003,5,2)+'.'+SUBSTR(TK003,7,2)+'('+TK001+ALLTRIM(TK002)+BT+')Ԥ��:'+ALLTRIM(STR(INT(YE)))+ALLTRIM(TK007)+CHR(13)+chr(10)
			ENDIF
			IF LEN(ALLTRIM(T+S))<1500
				T=T+S
			ELSE
				T=T+CHR(13)+CHR(10)+'...'
				EXIT
			ENDIF
			SKIP
		ENDDO		

		m_note=m_note+CHR(13)+CHR(10)+T+CHR(13)+CHR(10)+'__________________________________________________'+CHR(13)+CHR(10)+'ע���ѳ���30��,�뼰ʱ���߶Է���λ��Ʊ���ˣ�����30�����ѱ��ˣ�����45�����ѱ��˺Ͳ�������,������60�����ѱ��˺Ͳ�������,�����ܼࣻ����100�챨��˾���������顣'
		mrev=ALLTRIM(XXX)+';�����;'
		CON=ODBC(11)
		sqlexec(con,"select a.CnName from Employee as a  left join Job as F on A.JobId=F.JobId left join EmployeePartJob as g on A.EmployeeID=g.EmployeeID "+;
		"left join Job as y on g.JobId=y.JobId  where (rTRIM(f.Name)='�ɹ����' or rTRIM(y.Name)='�ɹ����' ) AND EmployeeStateId<>'EmployeeState3001'","tmpempinfo")		
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
			mrev=mrev+ALLTRIM(Director)+';�޹���;Ҧ���;'
			IF ALLTRIM(Director)='������'
				mrev=mrev+'�Ź���;'
			ENDIF
			mrev=mrev+'����Ƽ;'
			CDATE2=DTOC(DATE()-60,1)
			IF TK0031<CDATE2 AND !EMPTY(cnname)
				mrev=mrev+ALLTRIM(cnname)+';ʢ�ܻ�;'
			ENDIF
			CDATE2=DTOC(DATE()-100,1)
			IF TK0031<CDATE2 
				mrev=mrev+'�µ���;'
			ENDIF

		ENDIF

		
		tmpkeyid=maxinterid("rtxmessage")
		keyidid1=ODBC(6)

*!*			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,0)")<0
*!*				WAIT windows '????��������'+mrev nowait
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
	SELECT DISTINCT MV002 as ҵ��Ա,MV001,DZ  FROM TMD1 INTO CURSOR TMPSALES
	SELECT TMPSALES
	GO TOP
	DO WHIL .NOT. EOF()
		XXX=ALLTRIM(ҵ��Ա)
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
		m_note='����['+ALLTRIM(STR(RECCOUNT()))+']��δ��Ʊ����������'
		mtitle='['+ALLTRIM(XXX)+';'+XC+']����������'
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
			BT=BT+',����:'+GF
			SELECT TMPBUYETR
			IF TT=1
				S=SUBSTR(TG003,1,4)+'.'+SUBSTR(TG003,5,2)+'.'+SUBSTR(TG003,7,2)+'('+TG001+ALLTRIM(TG002)+BT+')����:'+ALLTRIM(STR(INT(YE)))+ALLTRIM(TG011)+CHR(13)+chr(10)
			ELSE
				S=ALLTRIM(STR(RECNO()))+'.'+SUBSTR(TG003,1,4)+'.'+SUBSTR(TG003,5,2)+'.'+SUBSTR(TG003,7,2)+'('+TG001+ALLTRIM(TG002)+BT+')����:'+ALLTRIM(STR(INT(YE)))+ALLTRIM(TG011)+CHR(13)+chr(10)
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
		"left join Job as y on g.JobId=y.JobId  where (rTRIM(f.Name)='���ۻ��' or rTRIM(y.Name)='���ۻ��' ) AND EmployeeStateId<>'EmployeeState3001'","tmpempinfo")		
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
		m_note=m_note+CHR(13)+CHR(10)+T+CHR(13)+CHR(10)+'__________________________________________________'+CHR(13)+CHR(10)+'ע���ѳ���30�죬�뼰ʱ���߶Է���λ��Ʊ���ˣ�����30�����ѱ��ˣ�����45�����ѱ��˺Ͳ�������,������60�����ѱ��˺Ͳ�������,�����ܼࣻ����100�챨��˾���������顣'
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
			mrev=mrev+ALLTRIM(Director)+';Ҧ���;'
			CDATE2=DTOC(DATE()-60,1)
			IF TK0031<CDATE2 AND !EMPTY(cnname)
				mrev=mrev+ALLTRIM(cnname)+';ʢ�ܻ�;'
			ENDIF
*!*				CDATE2=DTOC(DATE()-100,1)
*!*				IF TK0031<CDATE2 
*!*					mrev=mrev+'�µ���;'
*!*				ENDIF
		ENDIF

		
		tmpkeyid=maxinterid("rtxmessage")
		keyidid1=ODBC(6)

*!*			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,0)")<0
*!*				WAIT windows '????��������'+mrev nowait
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
	SELECT DISTINCT MV002 as ҵ��Ա,MV001,DZ  FROM TMD1 INTO CURSOR TMPSALES
	SELECT TMPSALES
	GO TOP
	DO WHIL .NOT. EOF()
		XXX=ALLTRIM(ҵ��Ա)
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
		m_note='����['+ALLTRIM(STR(RECCOUNT()))+']��δ��Ʊ�����˵���'
		mtitle='['+ALLTRIM(XXX)+';'+XC+']�������˵�'
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
			BT=BT+',����:'+GF
			SELECT TMPBUYETR
			IF TT=1
				S=SUBSTR(TI003,1,4)+'.'+SUBSTR(TI003,5,2)+'.'+SUBSTR(TI003,7,2)+'('+TI001+ALLTRIM(TI002)+BT+')����:'+ALLTRIM(STR(INT(YE)))+ALLTRIM(TI008)+CHR(13)+chr(10)
			ELSE
				S=ALLTRIM(STR(RECNO()))+'.'+SUBSTR(TI003,1,4)+'.'+SUBSTR(TI003,5,2)+'.'+SUBSTR(TI003,7,2)+'('+TI001+ALLTRIM(TI002)+BT+')����:'+ALLTRIM(STR(INT(YE)))+ALLTRIM(TI008)+CHR(13)+chr(10)
			ENDIF
			IF LEN(ALLTRIM(T+S))<1500
				T=T+S
			ELSE
				T=T+CHR(13)+CHR(10)+'...'
				EXIT
			ENDIF
			SKIP
		ENDDO		

		m_note=m_note+CHR(13)+CHR(10)+T+CHR(13)+CHR(10)+'__________________________________________________'+CHR(13)+CHR(10)+'ע���ѳ���30�죬�뼰ʱ���߶Է���λ��Ʊ���ˣ�����30�����ѱ��ˣ�����45�����ѱ��˺Ͳ�������,������60�����ѱ��˺Ͳ�������,�����ܼࣻ����100�챨��˾���������顣'
		mrev=ALLTRIM(XXX)+';л����;'
		CON=ODBC(11)
		sqlexec(con,"select a.CnName from Employee as a  left join Job as F on A.JobId=F.JobId left join EmployeePartJob as g on A.EmployeeID=g.EmployeeID "+;
		"left join Job as y on g.JobId=y.JobId  where (rTRIM(f.Name)='���ۻ��' or rTRIM(y.Name)='���ۻ��' ) AND EmployeeStateId<>'EmployeeState3001'","tmpempinfo")		
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
			mrev=mrev+ALLTRIM(Director)+';Ҧ���;'
			CDATE2=DTOC(DATE()-60,1)
			IF TK0031<CDATE2 AND !EMPTY(cnname)
				mrev=mrev+ALLTRIM(cnname)+';ʢ�ܻ�;'
			ENDIF
			CDATE2=DTOC(DATE()-100,1)
*!*				IF TK0031<CDATE2 
*!*					mrev=mrev+'�µ���;'
*!*				ENDIF
		ENDIF

		
		tmpkeyid=maxinterid("rtxmessage")
		keyidid1=ODBC(6)

*!*			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,0)")<0
*!*				WAIT windows '????��������'+mrev nowait
*!*			ENDIF 
		SQLDISCONNECT(keyidid1)
		ENDIF 
		SELECT TMPSALES
		SKIP
	ENDDO
************************************
************************************
***********************************
	mtitle='['+DTOC(DATE())+']�ն�����Ʒ�����״:'
*!*		m_note='Ԥ�ƽ���:����,�������,�ѳ�����,�����,�����[Ԥ������](�ϼ�)(��Ԫ)'+CHR(13)+CHR(10)
*!*		CON=ODBC(5)
*!*		sqlexec(con,"SELECT case when TD013<='2012' THEN '2011��ǰ' ELSE LEFT(TD013,4)+'��' END YEAR,COUNT(*) as ����,sum(RKSL) as RKSL,sum(DYSL) as DYSL,sum(RKSL-DYSL)  as WDYSL,SUM(CB*RKSL-CB*DYSL) CASH,"+;
*!*		"SUM(CASE WHEN TD004<'A' THEN CB*RKSL-CB*DYSL ELSE 0 END) CASH1,SUM(case when id=1 then CB*RKSL-CB*DYSL else 0 end) yc FROM getgoodsstcokforsales WHERE RKSL-DYSL>0  "+;
*!*		"GROUP BY case when TD013<='2012' THEN '2011��ǰ' ELSE LEFT(TD013,4)+'��' END ORDER BY 1","TmpQC")&&ISNULL(LEFT(TD013,4),'')
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
*!*			m_note=m_note+ALLTRIM(YEAR)+':'+ALLTRIM(STR(����))+','+ALLTRIM(STR(INT(RKSL)))+','+ALLTRIM(STR(INT(DYSL)))+','+ALLTRIM(STR(INT(WDYSL)))+','+ALLTRIM(STR(INT(CASH/10000)))+ycx+CHR(13)+CHR(10)
*!*			SELECT TMPQC
*!*			SKIP
*!*		ENDDO
*!*		SELECT TMPQC
*!*		SUM ����,WDYSL,CASH,yc,cash1 TO X1,X2,X3,x4,x41
*!*		m_note=m_note+'1.���ö������ϼ�:'+ALLTRIM(STR(INT(x1)))+'��,�������:'+ALLTRIM(STR(INT(x2)))+'ֻ,�����:'+ALLTRIM(STR(INT(x3/10000)))+'(����Ԥ����:'+ALLTRIM(STR(INT(x4/10000)))+','+ALLTRIM(STR(INT(x4/x3*100)))+'%,�ϼ�:'+ALLTRIM(STR(INT(x41/10000)))+','+ALLTRIM(STR(INT(x41/x3*100)))+'%)��Ԫ.'
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
*!*		m_note=m_note+CHR(13)+CHR(10)+'2.�������������ϼ�:'+ALLTRIM(STR(INT(x5)))+'��,�������:'+ALLTRIM(STR(INT(x6)))+'ֻ,�����:'+ALLTRIM(STR(INT(x7/10000)))+'��Ԫ(�ܿ��:'+ALLTRIM(STR(INT((x3+x7)/10000)))+','+ALLTRIM(STR(INT(x7/(x3+x7)*100)))+'%),�����⹺��Ʒ�ܶ�:'+ALLTRIM(STR(INT((X12)/10000)))+'('+ALLTRIM(STR(INT(x12/X10*100)))+'%)��Ԫ.'&&,�ϼ�;'+ALLTRIM(STR(INT((x41+x8)/10000)))+','+ALLTRIM(STR(INT(x41/(x3+x7)*100)))+'%)
*!*		m_note=m_note+CHR(13)+CHR(10)+'3.��������������е���Ԥ��:'+ALLTRIM(STR(INT(X10/10000)))+'('+ALLTRIM(STR(INT(x10/x7*100)))+'%),����'+ALLTRIM(STR(INT(X9/10000)))+'('+ALLTRIM(STR(INT(x9/x7*100)))+'%),������:'+ALLTRIM(STR(INT(X11/10000)))+'('+ALLTRIM(STR(INT(x11/x7*100)))+'%)��Ԫ'
*!*		m_note=m_note+CHR(13)+CHR(10)+'4.������������Ԥ��:'+ALLTRIM(STR(INT(Y10/10000)))+'('+ALLTRIM(STR(INT(Y10/Y7*100)))+'%,Ԥ�����:'+ALLTRIM(STR(INT(Z1/10000)))+'[M'+ALLTRIM(STR(INT(Z11/10000)))+',P'+ALLTRIM(STR(INT(Z12/10000)))+']),����'+ALLTRIM(STR(INT(Y9/10000)))+'('+ALLTRIM(STR(INT(Y9/Y7*100)))+'%),������:'+ALLTRIM(STR(INT(Y11/10000)))+'('+ALLTRIM(STR(INT(Y11/Y7*100)))+'%)��Ԫ'
***********************************
	mtitle='['+DTOC(DATE())+']�ն�����Ʒ�����״:'
	m_note='Ԥ�ƽ���:����,�����,�����[Ԥ������](�ϼ�)(��Ԫ)'+CHR(13)+CHR(10)
	CON=ODBC(5)
	?sqlexec(con,"SELECT case when TD013<='2012' OR TD013 IS NULL THEN '2011��ǰ' ELSE LEFT(TD013,4)+'��' END YEAR,COUNT(*) as ����,sum(INVLA.LA011*INVLA.LA005)  as WDYSL,SUM(CB*INVLA.LA011*INVLA.LA005) CASH,"+;
	"SUM(CASE WHEN TD004<'A' THEN CB*INVLA.LA011*INVLA.LA005 ELSE 0 END) CASH1,SUM(case when id=1 then CB*INVLA.LA011*INVLA.LA005 else 0 end) yc "+;
	"FROM INVLA INNER JOIN getgoodsstcokforsales ON LA016=SUBSTRING(NOID,1,LEN(RTRIM(NOID))-4)  "+;
	"AND LA001=TD004 GROUP BY case when TD013<='2012'  OR TD013  IS NULL THEN '2011��ǰ' ELSE LEFT(TD013,4)+'��' END ORDER BY 1","TmpQC")&&ISNULL(LEFT(TD013,4),'')
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
		m_note=m_note+ALLTRIM(YEAR)+':'+ALLTRIM(STR(����))+','+ALLTRIM(STR(INT(WDYSL)))+','+ALLTRIM(STR(INT(CASH/10000)))+ycx+CHR(13)+CHR(10)
		SELECT TMPQC
		SKIP
	ENDDO
	SELECT TMPQC
	SUM ����,WDYSL,CASH,yc,cash1 TO X1,X2,X3,x4,x41
	m_note=m_note+'1.���ö������ϼ�:'+ALLTRIM(STR(INT(x1)))+'��,�������:'+ALLTRIM(STR(INT(x2)))+'ֻ,�����:'+ALLTRIM(STR(INT(x3/10000)))+'(����Ԥ����:'+ALLTRIM(STR(INT(x4/10000)))+','+ALLTRIM(STR(INT(x4/x3*100)))+'%,�ϼ�:'+ALLTRIM(STR(INT(x41/10000)))+','+ALLTRIM(STR(INT(x41/x3*100)))+'%)��Ԫ.'
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
	m_note=m_note+CHR(13)+CHR(10)+'2.�������������ϼ�:'+ALLTRIM(STR(INT(x5)))+'��,�������:'+ALLTRIM(STR(INT(x6)))+'ֻ,�����:'+ALLTRIM(STR(INT(x7/10000)))+'��Ԫ(�ܿ��:'+ALLTRIM(STR(INT((x3+x7)/10000)))+','+ALLTRIM(STR(INT(x7/(x3+x7)*100)))+'%),�����⹺��Ʒ�ܶ�:'+ALLTRIM(STR(INT((X12)/10000)))+'('+ALLTRIM(STR(INT(x12/X10*100)))+'%)��Ԫ.'&&,�ϼ�;'+ALLTRIM(STR(INT((x41+x8)/10000)))+','+ALLTRIM(STR(INT(x41/(x3+x7)*100)))+'%)
	m_note=m_note+CHR(13)+CHR(10)+'3.��������������е���Ԥ��:'+ALLTRIM(STR(INT(X10/10000)))+'('+ALLTRIM(STR(INT(x10/x7*100)))+'%),����'+ALLTRIM(STR(INT(X9/10000)))+'('+ALLTRIM(STR(INT(x9/x7*100)))+'%),������:'+ALLTRIM(STR(INT(X11/10000)))+'('+ALLTRIM(STR(INT(x11/x7*100)))+'%)��Ԫ'
	m_note=m_note+CHR(13)+CHR(10)+'4.������������Ԥ��:'+ALLTRIM(STR(INT(Y10/10000)))+'('+ALLTRIM(STR(INT(Y10/Y7*100)))+'%,Ԥ�����:'+ALLTRIM(STR(INT(Z1/10000)))+'[M'+ALLTRIM(STR(INT(Z11/10000)))+',P'+ALLTRIM(STR(INT(Z12/10000)))+']),����'+ALLTRIM(STR(INT(Y9/10000)))+'('+ALLTRIM(STR(INT(Y9/Y7*100)))+'%),������:'+ALLTRIM(STR(INT(Y11/10000)))+'('+ALLTRIM(STR(INT(Y11/Y7*100)))+'%)��Ԫ'

	tmpkeyid=maxinterid("rtxmessage")
	keyidid1=ODBC(6)
	mrev='������;�ܺ�;Ҧ���;������Ƽ;ʩά��;ʢ�ܻ�;����;���Ǿ�;������;'
	IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,9)")<0
		WAIT windows '????��������'+mrev nowait
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
*!*			" DATENAME( Wk,CAST(TA010 AS DATETIME) ) ELSE '0'+DATENAME( Wk,CAST(TA010 AS DATETIME) ) END<?A1 and TA001='511' ORDER BY 1","TmpO1rder")<0  &&TA016 AS ��������,
*!*			WAIT WINDOWS '???'
*!*			RETURN 
*!*		ENDIF
*!*	SQLEXEC(con,"SELECT '����:'+rtrim(MOCTA.TA033)+'ح'+MOCTA.TA001+ MOCTA.TA002+'ح'+rtrim(MOCTA.TA006)+':'+rtrim(MOCTA.TA034)+'ح'+rtrim(MOCTA.TA035)+'ح'+(case MOCTA.TA011 when '1' then 'δ����' when '2' then '�ѷ���' when '3' then '������' when 'Y' then '���깤' else 'ָ���깤' end)+'حԤ���깤��'+MOCTA.TA010+'����('+str(datediff(day,MOCTA.TA010,getdate()),4,0)+')��ح�ܲ���:'+str(MOCTA.TA015,6,0)+'حδ����('+str(MOCTA.TA015-MOCTA.TA017,6,0)+')حδ����ʱ(
*!*	'+str((case when MOCTA.TA001 like '52%' then MOCTA.UDF51/3600 else INVMB.MB061/CMSMD.MD009 end)*(MOCTA.TA015-MOCTA.TA017),4,2)+'H)',
*!*	rtrim(MOCTA.TA021)+CMSMD.MD002 as ��������
*!*	FROM DEMO.dbo.MOCTA 
*!*	left join  CMSMD on MOCTA.TA021=CMSMD.MD001 
*!*	left join  INVMB on INVMB.MB001=MOCTA.TA006
*!*	WHERE  MOCTA.TA013 = 'Y' and MOCTA.TA011 like '[123]' and MOCTA.TA030='1' and datediff(day,MOCTA.TA010,getdate())>14

	IF sqlexec(con,"SELECT DISTINCT TA033,C.MV002,CASE WHEN billname is null then '' else RTRIM(billname)+';' end AS BILLNAME,TA033 YWY,CASE WHEN billname is null then 0 else pi.interid end AS PI, "+;
	"MOCTA.TA010,datediff(day,MOCTA.TA010,getdate()) as ��������,str(MOCTA.TA015-MOCTA.TA017,6,0)+'/'+str(MOCTA.TA015,6,0) AS CL,"+;
		"(case when MOCTA.TA001 like '52%' then MOCTA.UDF51/3600 else INVMB.MB061/CMSMD.MD009 end)*(MOCTA.TA015-MOCTA.TA017) AS GS,MOCTA.TA001, MOCTA.TA002,"+;
		"case when TA030='1' then CMSMD.MD002  ELSE PURMA.MA002 END AS ��������,"+;
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
	replace �������� WITH '�ƾ߳���' FOR ��������='װ��'
	replace �������� WITH '�ƾ߳���' FOR ��������='�����ֳ��ӹ�'
	replace �������� WITH '��Ϳ����' FOR ��������='��Ϳ'
	replace �������� WITH '��Ϳ����' FOR ��������='���ӹ�'
	con1=odbc(11)
	SQLEXEC(con1,"select A.CnName boss "+;
	" from Department d LEFT JOIN Employee A ON d.Principal=A.EmployeeID  where D.name='�ƻ���'","tmp2")
	mrev1=ALLTRIM(boss )+';'
	SQLEXEC(con1,"select A.CnName boss "+;
	" from Department d LEFT JOIN Employee A ON d.Principal=A.EmployeeID  where D.name='����'","tmp2")
	mrev1=mrev1+ALLTRIM(boss )+';'
	SQLDISCONNECT(Con)
	SELECT DISTINCT  ��������  as ҵ��Ա  FROM TmpO1rder INTO CURSOR TMPSALES
	SELECT TMPSALES
	GO TOP
	DO WHIL .NOT. EOF()
	
		mrev=''
		
		XXX=ALLTRIM(ҵ��Ա)
		xc=xxx
		IF XXX='��Ʒ��'
			mrev='��Ʒ�鳤;'
		ENDIF 	
		IF USED("TMPBUYETR")
			SELECT TMPBUYETR
			USE
		ENDIF	

		SELECT * FROM TmpO1rder WHERE ALLTRIM( ��������)==XXX ORDER BY 6 INTO CURSOR TMPBUYETR
		SELECT TMPBUYETR
		TT=RECCOUNT()
		m_note='����['+ALLTRIM(STR(RECCOUNT()))+']�Ź�����Ʒ���ڣ�'
		mtitle='['+ALLTRIM(XXX)+']���ڹ���'

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
			s=ALLTRIM(STR(RECNO()))+'.'+ALLTRIM(ta006)+':'+allt(ta034)+'ح'+ALLTRIM(ta035)+'('+ALLTRIM(ta001)+ALLTRIM(ta002)+'['+ALLTRIM(CL)+;
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
		*m_note=m_note+T+CHR(13)+CHR(10)+'__________________________________________________'+CHR(13)+CHR(10)+'ע���������ڹ������������Ϸ����ڷ�Χ�ڣ�������������ܵ��붩���������Ų������ܲʰ��ϲ��ɹ�...��'
*!*			IF '������'$XC=.T.
*!*				mrev='Ҧ���;������Ƽ;��Ƽ��;������;���ػ�;'+xc
*!*			ELSE 	
*!*				mrev='������;Ҧ���;������Ƽ;��Ƽ��;'+xc
*!*			ENDIF 	
		tmpkeyid=maxinterid("rtxmessage")
		keyidid1=ODBC(6)
		mrev=mrev1+mrev
*!*			IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,0)")<0
*!*				WAIT windows '????����'+mrev nowait
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
         " SUM(CASE TA079 WHEN '1' THEN TB019 WHEN '2' THEN TB019 * - 1 END) AS ����, "+;
           "SUM(case when (MB057+MB058+MB059+MB060)*TB022 is null then 0 else (MB057+MB058+MB059+MB060)*TB022 end) AS ��׼�ɱ� "+;
		 " ,CAST(SUM(CASE WHEN TA001<>'661' THEN 0 ELSE TB019*0.04 END) AS DEC(18,6)) AS ����ֿ�,9999999999.99 ë��,999999.99 ë����,MV002 FROM ACRTB LEFT JOIN "+;
           " ACRTA ON TB001 = TA001 AND TB002 = TA002 LEFT JOIN INVMB ON MB001 = TB039 LEFT JOIN COPMA ON MA001 = TA004 LEFT JOIN CMSMV ON MV001=MA016 "+;
			 " WHERE  TB012 <> 'V' AND TA003>=?A1 AND TA003 <=?A2 AND MA022>=?A1 AND MA001<>'0120' GROUP BY MA001, MA002,MA028, MA065,MV002 order by 8 desc","GETLEVEL")<0
			 WAIT WINDOWS '???' &&AND  MA8.MA001='2'AND  MA7.MA001='2' AND  MA5.MA001='2' 
		ENDIF	 
	SQLDISCONNECT(CON)

	SELECT GETLEVEL
	replace ë���� WITH 0 all
	REPLACE ë�� WITH (����-����ֿ�-��׼�ɱ�)/10000 all
	replace ë���� WITH (����-����ֿ�-��׼�ɱ�)/(����-����ֿ�)*100  FOR ����-����ֿ�<>0
	REPLACE ���� WITH (����-����ֿ�)/10000 all
	REPLACE ����ֿ� WITH ����ֿ�/10000, ��׼�ɱ� WITH ��׼�ɱ�/10000 all
	REPLACE MA065 WITH MA001 FOR EMPTY(MA065)

	GO TOP
	DO WHIL .NOT. EOF()
		DO CASE
			CASE ����>=350 AND ë����/100>0.25
				REPLACE NEW WITH 'A'
			CASE (����>=350 AND ë����/100<=0.25 AND ë����/100>=0.15) OR (����>=100 AND ����<350  AND ë����/100>=0.25)
				REPLACE NEW WITH 'B'
			CASE (����>=350 AND ë����/100<0.15) OR (����>=100 AND ����<350  AND ë����/100>=0.15 AND ë����/100<=0.25)  OR (����>=50 AND ����<100 AND ë����/100>0.25)  OR (����>=10 AND ����<50 AND ë����/100>0.35)
				REPLACE NEW WITH 'C'
			OTHERWISE 
				REPLACE NEW WITH 'D'
		ENDCASE 
		SKIP
	ENDDO
	SELECT GETLEVEL
	REPLACE NEW1 WITH '' ALL
	CLOSEDB("TMPMAIN")
	SELECT MA065,MA065 NEW,SUM(����) ����,SUM(��׼�ɱ�) ��׼�ɱ�,SUM(����ֿ�) ����ֿ�,9999999999.99 ë��,999999.99 ë���� FROM GETLEVEL GROUP BY MA065 WHERE MA065>='1' INTO CURSOR TMPMAIN READWRITE 
	SELECT TMPMAIN
	REPLACE ë�� WITH (����-��׼�ɱ�)/10000 all
	replace ë���� WITH (����-��׼�ɱ�)/����*100  FOR ����<>0
	GO TOP 
	DO WHIL .NOT. EOF()
		DO CASE
			CASE ����>=350 AND ë����/100>0.25
				REPLACE NEW WITH 'A'
			CASE (����>=350 AND ë����/100<=0.25 AND ë����/100>=0.15) OR (����>=100 AND ����<350  AND ë����/100>=0.25)
				REPLACE NEW WITH 'B'
			CASE (����>=350 AND ë����/100<0.15) OR (����>=100 AND ����<350  AND ë����/100>=0.15 AND ë����/100<=0.25)  OR (����>=50 AND ����<100 AND ë����/100>0.25)  OR (����>=10 AND ����<50 AND ë����/100>0.35)
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
			REPLACE MAIN WITH ALLTRIM(MA002)+'['+ALLTRIM(MA001)+']������['+ALLTRIM(ma028)+'],���ۣ�'+ALLTRIM(STR(INT(����)))+'��,ë����:'+ALLTRIM(STR(INT(ë����)))+'%)��Ӧ����['+ALLTRIM(NEW)+']'
			IF LEFT(ma065,1)>='0' AND new<>new1
				replace main WITH ALLTRIM(main)+',�ÿͻ��ܹ�˾����Ϊ['+ALLTRIM(NEW1)+']'
			ENDIF 
		ENDIF
		SKIP
	ENDDO
	SELECT GETMYRES 
	IF USED("TMPSALES")
		SELECT TMPSALES
		USE
	ENDIF	
	SELECT DISTINCT MV002 as ҵ��Ա  FROM GETMYRES INTO CURSOR TMPSALES
	SELECT TMPSALES
	GO TOP
	DO WHIL .NOT. EOF()
		XXX=ALLTRIM(ҵ��Ա)
		xc=xxx
		IF USED("TMPBUYETR")
			SELECT TMPBUYETR
			USE
		ENDIF	

		SELECT * FROM GETMYRES WHERE ALLTRIM(MV002)==XXX ORDER BY 1 DESC INTO CURSOR TMPBUYETR
		SELECT TMPBUYETR
		TT=RECCOUNT()
		m_note='����['+ALLTRIM(STR(RECCOUNT()))+']���ͻ�����������������'
		mtitle='['+ALLTRIM(XXX)+']�ͻ���������'

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
		m_note=m_note+T+CHR(13)+CHR(10)+'__________________________________________________'+CHR(13)+CHR(10)+'ע������������ԴΪ'+A11+'����������۷�Ʊ�����Լ���׼�ɱ����뼰ʱ�����ͻ�����������������Ӱ��ɹ������������ȼ�.'
		IF xc=='������'
			mrev='������;Ҧ���;'
		ELSE 	
			mrev='������;Ҧ���;'+xc+';'
		ENDIF 	
		tmpkeyid=maxinterid("rtxmessage")
		keyidid1=ODBC(6)

		IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,8)")<0
			WAIT windows '????��������'+mrev nowait
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
*!*	*�����ǣ�����ID������Name�������ļ�·��
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
		MessageBox('û������'+ALLTRIM(NAME)+'����Դ������ϵͳ����Ա��Config�ļ�������ȷ��odbc��',16,'����')
		RETURN 
	ENDIF 	
	**����ͼ�޸����е�ODBC����������ڣ�����0��
	lreturn=SQLConfigDataSource(lnWindowHandle, 2, &mNote)
	SQLSETPROP(0,'DispLogin',3)
	IF lreturn=0 &&�����ڣ�������µ�ODBC
		lreturn=SQLConfigDataSource(lnWindowHandle, 1, &mNote)
		IF lreturn=0 &&ʧ��
	*!*			MessageBox('���'+ALLTRIM(NAME)+'����Դʧ�ܣ�����ϵͳ����Ա��ϵ��',16,'����')
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
		* MESSAGEBOX(ALLTRIM(NAME)+'���ӳɹ���')
	ELSE
		IF RECNO()=5 OR RECNO()=12
			*MESSAGEBOX('����ʧ�ܣ�����ϵͳ����Ա��ϵ��',16,'����') 
			*quit &&���Ӳ��ɹ����˳�ϵͳ��
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

* ��ʾ���� ip ��ַ
IPSocket = CreateObject("MSWinsock.Winsock")
if type('IPSocket')='O'
   IPAddress = IPSocket.LocalIP
   localhostname = IPSocket.localhostname
   remotehost = IPSocket.remotehost
   remotehostip = IPSocket.remotehostip
   *MessageBox ("���� IP = " + IPAddress+crlf+"���� host = "+localhostname;
+crlf+"Remotehost = "+remotehost+crlf+"Remotehostip = "+remotehostip)
	RETURN IPAddress 
else
   MessageBox ("Winsock δ��װ!")
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
IF SQLEXEC(conx,"select DISTINCT RTRIM(TD001)+TD002 AS ��������,CA.MA002 AS �ͻ�����,N.MV002 as ҵ��Ա,CA.MA016,"+;
"CASE WHEN LEFT(TD013,1)='2' THEN CAST( TD013 AS DATETIME ) ELSE '' END AS Ԥ��������,CAST(CA.UDF06 AS CHAR(60)) MGDY,pi.interid,"+;
"CASE WHEN pi.po IS NULL then '' ELSE pi.po END po,convert(char(10),CAST(COPTC.TC003 as datetime),102) AS CHKDATE,V1.MV002,TB006,"+;
"CASE WHEN pipro.EXTO IS NULL THEN '' ELSE pipro.EXTO END �����,TD015 "+;
" FROM pi inner join pidetail on pi.interid=pidetail.maininterid and pidetail.mf002='N' INNER JOIN COPTD ON pidetail.interid=COPTD.UDF56  "+;
" LEFT JOIN COPMA CA ON pi.customid=CA.MA001 LEFT JOIN CMSMV N ON CA.MA016=N.MV001 INNER JOIN COPTC ON pi.interid=COPTC.UDF55 INNER join ADMTB ON TB007=RTRIM(TC001)+'-'+TC002  "+;
" AND TB002='A'   LEFT JOIN CMSMV V1 ON TB004=V1.MV001 inner JOIN pipro on pi.interid=pipro.interid "+;
"WHERE TD021='Y' AND TD016='N' AND pi.chkid=1  AND TD001<>'227' AND TD004>='A' AND (COPTD.UDF05='' or COPTD.UDF05 IS NULL) "+;
"AND LEFT(TD004,1)<>'Z' AND LEFT(TD004,1)<'X' AND TD020 not like '%����%' and TB003='COPMI06' AND DATEDIFF(hour,TB006,getdate())>=20 and LEFT(COPTD.TD004,1)<>'X' and "+;
"NOT EXISTS (select 'x' from MOCTA WHERE TA033=RTRIM(COPTD.TD001)+COPTD.TD002) ORDER BY 1,10","TMPX")<0  && AND (TD015='' OR TD015 IS NULL) 
SQLDISCONNECT(conx)
*MESSAGEBOX('������???')
WAIT windows '����������' NOWAIT 
RETURN 
ENDIF

IF SQLEXEC(conx,"select DISTINCT RTRIM(TD001)+TD002 AS ��������,CA.MA002 AS �ͻ�����,N.MV002 as ҵ��Ա,CA.MA016,"+;
"CASE WHEN LEFT(TD013,1)='2' THEN CAST( TD013 AS DATETIME ) ELSE '' END AS Ԥ��������,CAST(CA.UDF06 AS CHAR(60)) MGDY,pi.interid,"+;
"CASE WHEN pi.po IS NULL then '' ELSE pi.po END po,convert(char(10),CAST(COPTC.TC003 as datetime),102) AS CHKDATE,pi.chkname AS  MV002,pi.chkdate TB006,'          ' �����,TD015 "+;
" FROM pi inner join pidetail on pi.interid=pidetail.maininterid and pidetail.mf002='N' INNER JOIN COPTD ON pidetail.interid=COPTD.UDF56  "+;
" LEFT JOIN COPMA CA ON pi.customid=CA.MA001 LEFT JOIN CMSMV N ON CA.MA016=N.MV001  INNER JOIN COPTC ON pi.interid=COPTC.UDF55 "+;
"WHERE TD021='V' AND TD016='N' AND pi.chkid=1  AND TD001<>'227' AND TD015=''  AND TD004>='A' "+;
"AND LEFT(TD004,1)<>'Z' AND LEFT(TD004,1)<>'X' AND LEFT(TD004,1)<>'Y' AND TD020 not like '%����%'  AND DATEDIFF(hour,pi.chkdate,getdate())>=20 and "+;
"NOT EXISTS (select 'x' from MOCTA WHERE TA033=RTRIM(COPTD.TD001)+COPTD.TD002)","TMP")<0
*MESSAGEBOX('???1')
WAIT windows '����������' NOWAIT 
RETURN 
ENDIF



SQLDISCONNECT(conx)
SELECT TMP
DDH='1'
SELECT TMPX
GO TOP
DO WHILE .NOT. EOF()
	SCATTER TO CDSL
	IF ��������<>DDH
		SELECT TMP
		APPEND BLANK 
		GATHER FROM CDSL
	ENDIF
	DDH=��������
	SELECT TMPX
	SKIP
ENDDO	
SELECT TMP
TABLEUPDATE(.T.)
IF USED("TMPSALES")
	SELECT TMPSALES
	USE
ENDIF	
SELECT ҵ��Ա FROM TMP WHERE LEFT(��������,3)='223' GROUP BY 1 INTO CURSOR TMPSALES&&AND LEFT(TD015,1)<>'2'
SELECT TMPSALES
GO TOP
DO WHIL .NOT. EOF()
	XXX=ҵ��Ա
	
	IF USED("TMPBUYETR")
		SELECT TMPBUYETR
		USE
	ENDIF
	SELECT * FROM TMP WHERE ҵ��Ա=XXX  and LEFT(��������,3)='223' ORDER BY 5 INTO CURSOR TMPBUYETR
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
	mrev=ALLTRIM(XXX)+';����;'+xmGDY
	
	SELECT TMPBUYETR

	GO TOP

	T=''
	DO WHIL .NOT. EOF()
		IF '����;'$mrev=.f. AND LEFT(��������,3)='223'
			mrev='����;'+mrev
		ENDIF 
		IF LEFT(TD015,1)='2'
			IF '��Ʒ�鳤;'$mrev=.f.
				mrev='��Ʒ�鳤;'+mrev
			ENDIF	
		ENDIF 
		IF len(ALLTRIM(po))>0
			S=ALLTRIM(STR(RECNO()))+'.'+ ALLTRIM(��������)+'['+ALLTRIM(�ͻ�����)+']'+',PI:'+ALLTRIM(STR(interid))+','+ALLTRIM(MV002)+'��'+TTOC(TB006)+'���,Po:'+ALLTRIM(po)+',Ҫ����:'+DTOC(TTOD(Ԥ��������))
		ELSE
			S=ALLTRIM(STR(RECNO()))+'.'+ ALLTRIM(��������)+'['+ALLTRIM(�ͻ�����)+']'+',PI:'+ALLTRIM(STR(interid))+','+ALLTRIM(MV002)+'��'+TTOC(TB006)+'���,Ҫ����:'+DTOC(TTOD(Ԥ��������))
		ENDIF 	
		
		IF len(ALLTRIM(�����))>=3
			S=S+',�����:'+ALLTRIM(�����)
		ENDIF 
		keyid=interid
		CON=ODBC(5)
		SQLEXEC(con,"select top 1 a.ta010 from pidetail p left JOIN pmocta a on p.interid=a.detailinterid LEFT join INVMB ON a.code=MB001 "+;
		" where p.maininterid=?keyid AND a.ta015>INVMB.MB064  AND a.classid<>'512' order by 1","tmpcode")		
		SQLDISCONNECT(con)
		IF RECCOUNT()=1
			IF ta010>=DTOC(DATE()-7,1)
				IF '������;'$mrev=.f. 
					mrev='������;'+mrev
				ENDIF 	
*!*					IF '������'$mrev=.f. 
*!*						mrev='������;'+mrev
*!*					ENDIF 
				S=S+CHR(13)+CHR(10)+'����:����ʮ�ֽ���,���������Ź���,ȷ���ɹ�������������!'
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
	m_Note='ҵ��Ա['+ALLTRIM(XXX)+']'+ALLTRIM(STR(TT))+'�Ŷ���û���ܹ���:'+CHR(13)+CHR(10)+T	
	mtitle=ALLTRIM(XXX)+DTOC(DATE())+':û�����������Ķ���'

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
SELECT ҵ��Ա FROM TMP WHERE LEFT(��������,3)<>'223' GROUP BY 1 INTO CURSOR TMPSALES
SELECT TMPSALES
GO TOP
DO WHIL .NOT. EOF()
	XXX=ҵ��Ա
	
	IF USED("TMPBUYETR")
		SELECT TMPBUYETR
		USE
	ENDIF
	SELECT * FROM TMP WHERE ҵ��Ա=XXX AND LEFT(��������,3)<>'223' ORDER BY 5 INTO CURSOR TMPBUYETR
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
	mrev=ALLTRIM(XXX)+';������;�³���;����;'+xmGDY
	
	SELECT TMPBUYETR

	GO TOP

	T=''
	DO WHIL .NOT. EOF()
		IF '����;'$mrev=.f. AND LEFT(��������,3)='223'
			mrev='����;'+mrev
		ENDIF 
		IF len(ALLTRIM(po))>0
			S=ALLTRIM(STR(RECNO()))+'.'+ ALLTRIM(��������)+'['+ALLTRIM(�ͻ�����)+']'+',PI:'+ALLTRIM(STR(interid))+','+ALLTRIM(MV002)+'��'+TTOC(TB006)+'���,Po:'+ALLTRIM(po)+',Ҫ����:'+DTOC(TTOD(Ԥ��������))
		ELSE
			S=ALLTRIM(STR(RECNO()))+'.'+ ALLTRIM(��������)+'['+ALLTRIM(�ͻ�����)+']'+',PI:'+ALLTRIM(STR(interid))+','+ALLTRIM(MV002)+'��'+TTOC(TB006)+'���,Ҫ����:'+DTOC(TTOD(Ԥ��������))
		ENDIF 	
		
		IF len(ALLTRIM(�����))>=3
			S=S+',�����:'+ALLTRIM(�����)
		ENDIF 
		keyid=interid
		CON=ODBC(5)
		SQLEXEC(con,"select top 1 a.ta010 from pidetail p left JOIN pmocta a on p.interid=a.detailinterid LEFT join INVMB ON a.code=MB001 "+;
		" where p.maininterid=?keyid AND a.ta015>INVMB.MB064  AND a.classid<>'512' order by 1","tmpcode")		
		SQLDISCONNECT(con)
		IF RECCOUNT()=1
			IF ta010>=DTOC(DATE()-7,1)
				IF '������;'$mrev=.f. 
					mrev='������;'+mrev
				ENDIF 	
*!*					IF '������'$mrev=.f. 
*!*						mrev='������;'+mrev
*!*					ENDIF 
				S=S+CHR(13)+CHR(10)+'����:����ʮ�ֽ���,���������Ź���,ȷ���ɹ�������������!'
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
	m_Note='ҵ��Ա['+ALLTRIM(XXX)+']'+ALLTRIM(STR(TT))+'�Ŷ���û���ܹ���:'+CHR(13)+CHR(10)+T	
	mtitle=ALLTRIM(XXX)+DTOC(DATE())+':û�����������Ķ���'

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
	SQLEXEC(con,"select pi.interid from pi inner join pipro p on pi.interid=p.interid where pi.chkid=1 and pi.statusid<>'�᰸' and LEFT(p.TA040,1)<>'2'","tmp")
	DO whil .not. EOF()
		cc=interid
		SQLEXEC(con,"select interid from pidetail where mf002='N' AND maininterid=?cc")
		IF RECCOUNT()<1
			SQLEXEC(con,"update pipro set TA040='�⹺�޹���' WHERE interid=?cc")
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
				"case when TA011='1' then 'δ����' WHEN TA011='2' THEN '�ѷ���' when TA011='3' THEN '������' when TA011='Y' THEN '���깤' when TA011='y' THEN 'ָ���깤' end ����״̬ "+;
				"FROM MOCTA WHERE TA033=?MBILL AND TA013='Y' AND TA006=?mCode ORDER BY 2 DESC,1 ")
				IF RECCOUNT()=1
					MT=TA010
					MTA001=TA001
					IF UDF56=0
						TT=LEFT(MT,4)+'.'+SUBSTR(MT,5,2)+'.'+RIGHT(MT,2)	
					ELSE
						TT=ALLTRIM(UDF03) +'��'
					ENDIF
					xxc='����:'+ALLTRIM(����״̬)
					XG=LEFT(TA003,4)+'.'+SUBSTR(TA003,5,2)+'.'+RIGHT(TA003,2)	
					SQLEXEC(con,"update pidetail set mf001=?tt,outerbarcode=?xxc where interid=?XCC")
					*SQLEXEC(con,"update pi set statusid='���Ų�' where interid=?keyid")
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
					SQLEXEC(con,"select top 1 TC003,CASE WHEN TD016='Y' THEN '�Զ�����' when TD016='y' then 'ָ������' else 'δ����' end TD "+;
					",LEFT(TD012,4)+'.'+DATENAME( Wk,CAST(TD012 AS DATETIME)) AS ZC ,TD012,RTRIM(TD001)+'-'+TD002 TD001 "+;
					" FROM PURTD INNER JOIN PURTC ON TC001=TD001 AND TC002=TD002 WHERE TD024=?MBILL order by 1 desc") &&and TD004=?mcode
					IF RECCOUNT()=1
						MT=TD012
						xxc ='�ɹ�:'+ALLTRIM(TD)
						TT=ALLTRIM(ZC) +'��'
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
					SQLEXEC(con,"select top 1 TC003,CASE WHEN TD016='Y' THEN '�Զ�����' when TD016='y' then 'ָ������' else 'δ����' end TD "+;
					",LEFT(TD012,4)+'.'+DATENAME( Wk,CAST(TD012 AS DATETIME)) AS ZC ,TD012,RTRIM(TD001)+'-'+TD002 TD001 "+;
					" FROM PURTD INNER JOIN PURTC ON TC001=TD001 AND TC002=TD002 WHERE TD024=?MBILL and TD004=?mcode order by 1 desc")
					IF RECCOUNT()=1
						MT=TD012
						xxc ='�⹺:'+ALLTRIM(TD)
						TT=ALLTRIM(ZC) +'��'
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
				"case when TA011='1' then 'δ����' WHEN TA011='2' THEN '�ѷ���' when TA011='3' THEN '������' when TA011='Y' THEN '���깤' when TA011='y' THEN 'ָ���깤' end ����״̬ "+;
				"FROM MOCTA WHERE TA033=?MBILL AND TA013='Y' AND TA006=?mCode ORDER BY 2 DESC,1 ")
				IF RECCOUNT()=1
						MT=TA010
						IF UDF56=0
							TT=LEFT(MT,4)+'.'+SUBSTR(MT,5,2)+'.'+RIGHT(MT,2)	
						ELSE
							TT=ALLTRIM(UDF03) +'��'
						ENDIF
						MTA001=TA001
						xxc='�趩��:'+ALLTRIM(����״̬)
						SQLEXEC(con,"update pidetail set mf001=?tt,outerbarcode=?xxc where interid=?XCC")
						SQLEXEC(con,"update pipro set UDF56=?tt where interid=?keyid")
						*SQLEXEC(con,"update pi set statusid='���Ų�' where interid=?keyid")
						tcc=1
						
					sQLEXEC(con,"SELECT TOP 1 TB006 FROM ADMTB WHERE TB003='MOCI02' AND TB002='A' and TB007=?MTA001 ORDER BY TB006")
					IF RECCOUNT()=1
					GDRQ=TTOC(TB006)
					SQLEXEC(con,"update pipro set UDF56=?tt,TA040=?GDRQ where interid=?keyid")
					ENDIF
				ELSE  	
					SQLEXEC(con,"select TOP 1 TD012 TC003,CASE WHEN TD016='Y' THEN '�Զ�����' when TD016='y' then 'ָ������' else 'δ����' end TD,RTRIM(TD001)+'-'+TD002 TD001 "+;
					" FROM PURTD INNER JOIN PURTC ON TC001=TD001 AND TC002=TD002 WHERE TD024=?MBILL AND TC014='Y' and TD004=?mcode ORDER BY 1 DESC")
					IF RECCOUNT()=1
						MT=TC003
						xxc ='���⹺:'+ALLTRIM(TD)
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
				"case when TA011='1' then 'δ����' WHEN TA011='2' THEN '�ѷ���' when TA011='3' THEN '������' when TA011='Y' THEN '���깤' when TA011='y' THEN 'ָ���깤' end ����״̬ "+;
				"FROM MOCTA WHERE TA033=?MBILL AND TA013='Y' AND TA006=?mCode ORDER BY 2 DESC,1 ")
			IF RECCOUNT()=1
				MT=TA010
				xxc='����'+ALLTRIM(����״̬)
				MTA001=TA001
				IF UDF56=0
					TT=LEFT(MT,4)+'.'+SUBSTR(MT,5,2)+'.'+RIGHT(MT,2)	
				ELSE
					TT=ALLTRIM(UDF03) +'��'
				ENDIF
				XTA015=TA017
				xxc='�ع���:'+ALLTRIM(����״̬)
				
				TT=ALLTRIM(ZC) +'��'
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

				SQLEXEC(con,"select TOP 1 TC003,CASE WHEN TD016='Y' THEN '�Զ�����' when TD016='y' then 'ָ������' else 'δ����' end TD "+;
				",LEFT(TD012,4)+'.'+DATENAME( Wk,CAST(TD012 AS DATETIME)) AS ZC,TD012,RTRIM(TD001)+'-'+TD002 TD001 "+;
				" FROM PURTD INNER JOIN PURTC ON TC001=TD001 AND TC002=TD002 WHERE TD024=?MBILL AND TC014='Y' and TD004=?mcode ORDER BY 1 DESC")
				IF RECCOUNT()=1
					MT=TC003
					xxc ='���⹺:'+ALLTRIM(TD)
					MT1=ALLTRIM(ZC)+'��'
					XG=TD012
					MTD001=TD001
					SQLEXEC(con,"update pidetail set mf001=LEFT(?XG,4)+'.'+SUBSTRING(?XG,5,2)+'.'+RIGHT(?XG,2)  where interid=?XCC")
					SQLEXEC(con,"update pipro set UDF56=?MT1,TC003=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2) where interid=?keyid")
					SQLEXEC(con,"update pi set statusid=?xxc  where interid=?keyid")
					tcc=2
				ENDIF
			ENDIF 
		ENDIF 	&&ERP����
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
	SQLEXEC(CON,"update pidetail set outerbarcode=CASE WHEN TD016='Y' THEN '�����Զ�����' when TD016='y' then '����ָ������' end, "+;
	"tppcs=CASE WHEN TD016='Y' THEN quan  end "+;
	"FROM pidetail inner join COPTD on pidetail.interid=COPTD.UDF56 where TD016<>'N' AND outerbarcode<>'�Ѻ���'")	
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
   * �ֶ�: d����,n����,l����,nũ����,nũ����,nũ����,cũ����,cũ����,cũ����,c����,c��Ф,c����
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
* ����: ���������ݼ�¼
* ʾ��: ? InsCalendarFromYear( [TempCalendar], [2003] )
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
* ����: ��������·ݼ�¼
* ʾ��: ? InsCalendarFromMonth( [TempCalendar], [200310] )
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
* ����: ����������ڼ�¼
* ʾ��: ? InsCalendarFromDate( [TempCalendar], Date(2003,10,01) )
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
* ����: ������ڼ�¼
* ʾ��: ? InsCalendar( [TempCalendar], Date(2003,10,01), .F., 2003, 09, 06 )
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
* ����: ��ĳ�������Ƿ����
* ʾ��: ? GetSolarGalaName( Date(2003,10,01) )
*-------------------------------------------------
Function GetSolarGalaName( tdDate, tdEasterDate )
 Local lcRetu, lnInfo, lcSolarInfo, lcSolarGala
 lcRetu = []
 lcSolarInfo = []
 lcSolarGala = []
 If Type([tdDate])=[D] and !empt(tdDate)
  ldEasterDate = iif( Type([tdEasterDate])=[D], tdEasterDate, GetEasterDate(Year(tdDate)) )
  * ���ڽ���
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
   lcSolarGala = lcSolarGala + [,Ԫ��(New Year's Day)]
   lcSolarGala = lcSolarGala + [,���˽�(St. Valentine's Day)]
   lcSolarGala = lcSolarGala + [,���ʸ�Ů��,�й�ֲ����,����������Ȩ����,������ҵ��.���ʷ�����������,����ˮ��,����������]
   lcSolarGala = lcSolarGala + [,���˽�(Fool's Day).��ۻ�����ʼ,̨���ͯ��,����������,���������]
   lcSolarGala = lcSolarGala + [,�����Ͷ���,�й������,�����ʮ����,��ά��,���ʻ�ʿ��,����������.���ʼ�ͥ��,���������,����������]
   lcSolarGala = lcSolarGala + [,���ʶ�ͯ��,���绷����,̨���ʦ��,���ʷ���Ʒ��,���ʽ䶾��]
   lcSolarGala = lcSolarGala + [,�й�����������������(1921��).��ۻع������(1997��),��������(1776��Independence Day),¬�����±�(1937������ս������),�����˿���]
   lcSolarGala = lcSolarGala + [,�й������ž�����������(1927���ϲ�����),�ձ�Ͷ����(1945������ս������),�������]
   lcSolarGala = lcSolarGala + [,����ɨä��,ë����������(1976��),�й���ʦ��,ŦԼ��ó������Ϯ(2001��),���ӵ���]
   lcSolarGala = lcSolarGala + [,�л����񹲺͹�����������(1949��).����������,���綯����,�й����˽�,���������������(1911��),������ʳ��,����������,���Ϲ�����������(1945��),�����ͯ��(����),��ʢ��(Halloween������)]
   lcSolarGala = lcSolarGala + [,̩��������浮(����),��������,����������,���ʿ�����,���ߵ���̨��(1967��)]
   lcSolarGala = lcSolarGala + [,���簬�̲���,���ʿ�����(�м���),�����幤��,���������(1941��),������Ȩ��,����������,�Ͼ�����ɱ������(1937��),���Żع������(1999��),ʥ����(Christmas),ë�󶫵�������,]
   lnBeg = at( [,], lcSolarGala, lnInfo ) + 1
   lnEnd = at( [,], lcSolarGala, lnInfo + 1 )
   lcRetu = [.] + subs( lcSolarGala, lnBeg, lnEnd-lnBeg )
  Endif
  * ���ڽ���
  If Month(tdDate) = 05 and tdDate = GetDateFromYMandWeekNo( subs(DToS(tdDate),1,4)+[05], 2, 7 )
   lcRetu = lcRetu + [.ĸ�׽�(Mother's Day)]
  Endif
  If Month(tdDate) = 06 and tdDate = GetDateFromYMandWeekNo( subs(DToS(tdDate),1,4)+[06], 3, 6 )
   lcRetu = lcRetu + [.����������]
  Endif
  If Month(tdDate) = 06 and tdDate = GetDateFromYMandWeekNo( subs(DToS(tdDate),1,4)+[06], 3, 7 )
   lcRetu = lcRetu + [.���׽�(Father's Day)]
  Endif
  If Month(tdDate) = 07 and tdDate = GetDateFromYMandWeekNo( subs(DToS(tdDate),1,4)+[06], 3, 1 )
   lcRetu = lcRetu + [.���ѧ����ٿ�ʼ]
  Endif
  If Month(tdDate) = 07 and tdDate = GetDateFromYMandWeekNo( subs(DToS(tdDate),1,4)+[06], 3, 6 )
   lcRetu = lcRetu + [.������]
  Endif
  If Month(tdDate) = 07 and tdDate = GetDateFromYMandWeekNo( subs(DToS(tdDate),1,4)+[06], 3, 7 )
   lcRetu = lcRetu + [.��ū�۹�����]
  Endif
  If Month(tdDate) = 09 and tdDate = GetDateFromYMandWeekNo( subs(DToS(tdDate),1,4)+[06], 1, 1 )
   lcRetu = lcRetu + [.�����������]
  Endif
  If Month(tdDate) = 09 and tdDate = GetDateFromYMandWeekNo( subs(DToS(tdDate),1,4)+[06], 1, 6 )
   lcRetu = lcRetu + [.��ۿ�ѧ��]
  Endif
  If Month(tdDate) = 11 and tdDate = GetDateFromYMandWeekNo( subs(DToS(tdDate),1,4)+[11], 3, 7 )
   lcRetu = lcRetu + [.������]
  Endif
  If Month(tdDate) = 11 and tdDate = GetDateFromYMandWeekNo( subs(DToS(tdDate),1,4)+[11], 4, 4 )
   lcRetu = lcRetu + [.�ж���(Thanksgiving Day)]
  Endif
  If Month(tdDate) = 12 and Betw(Day(tdDate),11,20) and DOW(tdDate,2) = 7 and Betw(Day(tdDate-7),1,10)
   lcRetu = lcRetu + [.��ۼ������] && 12����Ѯ��һ��������
  Endif
  * ����
  If Day(tdDate)=13 and DOW(tdDate,2)=5
   lcRetu = lcRetu + [.��ɫ������]
  Endif
  If ldEasterDate = tdDate
   * ���ֺ��һ������(��Բũ��15��)��ĵ�һ��������
   lcRetu = lcRetu + [.�����(Easter)]
  Else
   If ldEasterDate = tdDate + 2
    * �����ǰ�ĵ�һ��������
    lcRetu = lcRetu + [.Ү��������(Good Friday)]
   Endif
  Endif
 Endif
 Return lcRetu
Endfunc
*-------------------------------------------------
* ����: ��ĳ�� �����(Easter) ����
* ʾ��: ? GetEasterDate( 2003 )
*-------------------------------------------------
Function GetEasterDate( tnYear )
 Local ldRetu
 ldRetu = CToD([])
 If Type([tnYear])=[N] and Betw(tnYear,1,9999)
  * �����(Easter) = ���ֺ��һ������(��Բũ��15��)��ĵ�һ��������,ֻ������3��4��
  * ��� - �����Ү��Ҳ���й�ũ������
  Local ldSolarChunFeng, lnLunarChunFenY, lnLunarChunFenM, lnLunarChunFenD, llChunFenIsLeap
  Local lnDiffDays, ldSolar15
  ldSolarChunFeng = TtoD(GetTermDateTime(tnYear,6-1)) && ȡ�ô��ֹ�������
  lnLunarChunFenY = Year (ldSolarChunFeng)
  lnLunarChunFenM = Month(ldSolarChunFeng)
  lnLunarChunFenD = Day  (ldSolarChunFeng)
  llChunFenIsLeap = .F.                               && ȡ�ô���ũ������
  = GetLunarFromSolar( @lnLunarChunFenY, @lnLunarChunFenM, @lnLunarChunFenD, @llChunFenIsLeap )
  If lnLunarChunFenD > 0
   If lnLunarChunFenD < 15                             && ȡ�ô��ֺ���һ����Բ���������
    lnDiffDays = 15 - lnLunarChunFenD
   Else
    lnDiffDays = iif( llChunFenIsLeap, GetLunarLeapDays(lnLunarChunFenY), GetLunarMonthDays(lnLunarChunFenY,lnLunarChunFenM) ) - lnLunarChunFenD + 15
   Endif
   ldSolar15 = ldSolarChunFeng + lnDiffDays            && ȡ�ô��ֺ���һ����Բ�Ĺ�������
   ldRetu = ldSolar15 + 7 - Mod(DOW(ldSolar15,2),7)    && ȡ����Բ�����һ�������յ�����
  Endif
 Endif
 Return ldRetu
Endfunc
*-------------------------------------------------
* ����: ��ĳũ�����Ƿ����
* ʾ��: ? GetLunarGalaName( 2003, 12, 30 )
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
    * �����½���
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
     lcLunarGala = lcLunarGala + [,����.���շ�ʥ��,������(���),�Ӳ���,�����ʥ��,����,��ʴ��ʥ��,Ԫ����,��������]
     lcLunarGala = lcLunarGala + [,���ع���,����Ĳ������,������ʦ����,��ʥ��,����Ĳ�������,����������ʥ��(����),��������ʥ��]
     lcLunarGala = lcLunarGala + [,���۵�,׼������ʥ��,���]
     lcLunarGala = lcLunarGala + [,��������ʥ��,����Ĳ��������ɵ�������]
     lcLunarGala = lcLunarGala + [,�����,�ص۵���.٤������ʥ��]
     lcLunarGala = lcLunarGala + [,����Τ����������ʥ��,³��ʦ����,������,�����������ɵ�]
     lcLunarGala = lcLunarGala + [,��Ϧ���ɽ�,����������ʥ��,��Ԫ�նɽ�.�������,��������ʥ��,�ز�����ʥ��]
     lcLunarGala = lcLunarGala + [,�����,��ïƺ�����ʥ��,�ƴ��ɵ�,ȼ�Ʒ�ʥ��,���ӵ�]
     lcLunarGala = lcLunarGala + [,������,�������������Ҽ�����,ҩʦ����������ʥ��]
     lcLunarGala = lcLunarGala + [,��Ħ��ʦʥ��]
     lcLunarGala = lcLunarGala + [,�����ӷ�ʥ��]
     lcLunarGala = lcLunarGala + [,���������ɵ���,��������ʥ��,]
     lnBeg = at( [,], lcLunarGala, lnInfo ) + 1
     lnEnd = at( [,], lcLunarGala, lnInfo + 1 )
     lcRetu = [.] + subs( lcLunarGala, lnBeg, lnEnd-lnBeg )
    Endif
   Endif
   If !IsLeap or (IsLeap and tlIsLeap)
    If tnMonth=12
     Do Case
      Case tnDay=8
       lcRetu = lcRetu + [.���˽�]
      Case tnDay=16
       lcRetu = lcRetu + [.β�M]
      Case tnDay=28
       lcRetu = lcRetu + [.ϴ����]
      Case tnDay=24
       lcRetu = lcRetu + [.С��.�����(������)]
      Case InList(tnDay,29,30)
       If GetLunarMonthDays( tnYear, tnMonth ) = tnDay
        lcRetu = lcRetu + [.��Ϧ]
       Endif
     Endcase
    Endif
   Endif
  Endif
 Endif
 Return lcRetu
Endfunc
*-------------------------------------------------
* ����: ��ĳ��ũ����������
* ʾ��: ? GetLunarInfo( 2003 )
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
* ����: ���� �������� �� ����(����������Ϊ��)
*       1900�� ������Ϊ������(60����36)
* ʾ��: ? GetGanZhiYear( Date(2003,04,20) )
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
* ����: ���� �������� �� ���� (�Խ�������Ϊ��)
*       1900��01�� С����ǰΪ ������(60����12)
* ʾ��: ? GetGanZhiMonth( Date(2003,04,20) )
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
* ����: ���� �������� �� ����
*       1900��01��01�� Ϊ������(60����10)
* ʾ��: ? GetGanZhiDay( Date(2003,04,20) )
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
* ����: ���� �������� �� ����
* ʾ��: ? GetLunarJieQi( Date(2003,04,20) )
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
* ����: ��ũ����֧, 0=����
* ʾ��: ? GetLunarGanZhiName( 0 )
*-------------------------------------------------
Function GetLunarGanZhiName( tnNum )
 Return GetLunarGanName(Mod(tnNum,10)) + GetLunarZhiName(Mod(tnNum,12))
Endfunc
*-------------------------------------------------
* ����: ��ũ����֧�� ��
* ʾ��: ? GetLunarGanName( 1 )
*-------------------------------------------------
Function GetLunarGanName( tnGanNo )
 Local lcRetu
 lcRetu = []
 tnGanNo = iif( Type([tnGanNo])=[N], tnGanNo+1, 0 )
 If Betw(tnGanNo,1,10)
  Local lcGanInfo, lnBeg, lnEnd
  lcGanInfo = [,��,��,��,��,��,��,��,��,��,��,]
  lnBeg = at( [,], lcGanInfo, tnGanNo ) + 1
  lnEnd = at( [,], lcGanInfo, tnGanNo + 1 )
  lcRetu = subs( lcGanInfo, lnBeg, lnEnd-lnBeg )
 Endif
 Return lcRetu
Endfunc
*-------------------------------------------------
* ����: ��ũ����֧�� ֧
* ʾ��: ? GetLunarZhiName( 1 )
*-------------------------------------------------
Function GetLunarZhiName( tnZhiNo )
 Local lcRetu
 lcRetu = []
 tnZhiNo = iif( Type([tnZhiNo])=[N], tnZhiNo+1, 0 )
 If Betw(tnZhiNo,1,12)
  Local lcZhiInfo, lnBeg, lnEnd
  lcZhiInfo = [,��,��,��,î,��,��,��,δ,��,��,��,��,]
  lnBeg = at( [,], lcZhiInfo, tnZhiNo ) + 1
  lnEnd = at( [,], lcZhiInfo, tnZhiNo + 1 )
  lcRetu = subs( lcZhiInfo, lnBeg, lnEnd-lnBeg )
 Endif
 Return lcRetu
Endfunc
*-------------------------------------------------
* ����: ��ũ������
* ʾ��: ? GetLunarAniName( 1 )
*-------------------------------------------------
Function GetLunarAniName( tnAniNo )
 Local lcRetu
 lcRetu = []
 tnAniNo = iif( Type([tnAniNo])=[N], tnAniNo+1, 0 )
 If Betw(tnAniNo,1,12)
  Local lcAniInfo, lnBeg, lnEnd
  lcAniInfo = [,��,ţ,��,��,��,��,��,��,��,��,��,��,]
  lnBeg = at( [,], lcAniInfo, tnAniNo ) + 1
  lnEnd = at( [,], lcAniInfo, tnAniNo + 1 )
  lcRetu = subs( lcAniInfo, lnBeg, lnEnd-lnBeg )
 Endif
 Return lcRetu
Endfunc
*-------------------------------------------------
* ����: ��ũ������
* ʾ��: ? GetLunarJieQiName( 0 )
*-------------------------------------------------
Function GetLunarJieQiName( tnJieNo )
 Local lcRetu
 lcRetu = []
 tnJieNo = iif( Type([tnJieNo])=[N], tnJieNo+1, 0 )
 If Betw(tnJieNo,1,24)
  Local lcJieInfo, lnBeg, lnEnd
  lcJieInfo = [,С��,��,����,��ˮ,����,����,����,����,����,С��,â��,����,С��,����,����,����,��¶,���,��¶,˪��,����,Сѩ,��ѩ,����,]
  lnBeg = at( [,], lcJieInfo, tnJieNo ) + 1
  lnEnd = at( [,], lcJieInfo, tnJieNo + 1 )
  lcRetu = subs( lcJieInfo, lnBeg, lnEnd-lnBeg )
 Endif
 Return lcRetu
Endfunc
*-------------------------------------------------
* ����: ĳ��ĵ� N �������Ĺ�������(��0С������)
* ʾ��: ? GetTermDateTime( 2003, 2 ) && ������������ʱ��
*-------------------------------------------------
Function GetTermDateTime( tnYear, tnTerm )
 Return Datetime(1900,1,6,2,5,0) + (31556925974.7*(tnYear-1900)+GetLunarTermInfo(tnTerm)*60000)/1000
Endfunc
*-------------------------------------------------
* ����: ũ����ĵ�N������Ϊ����(��0С������)
* ʾ��: ? GetLunarTermInfo( 2 )
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
* ����: ��ũ����������
* ʾ��: ? GetLunarDayName( 1 )
*-------------------------------------------------
Function GetLunarDayName( tnDay1No )
 Local lcRetu
 lcRetu = []
 tnDay1No = iif( Type([tnDay1No])=[N], tnDay1No, 0 )
 If Betw(tnDay1No,1,30)
  Local lcDay1Info, lnBeg, lnEnd
  lcDay1Info = [,��һ,����,����,����,����,����,����,����,����,��ʮ,ʮһ,ʮ��,ʮ��,ʮ��,ʮ��] ;
   + [,ʮ��,ʮ��,ʮ��,ʮ��,��ʮ,إһ,إ��,إ��,إ��,إ��,إ��,إ��,إ��,إ��,��ʮ,]
  lnBeg = at( [,], lcDay1Info, tnDay1No ) + 1
  lnEnd = at( [,], lcDay1Info, tnDay1No + 1 )
  lcRetu = subs( lcDay1Info, lnBeg, lnEnd-lnBeg )
 Endif
 Return lcRetu
Endfunc
*-------------------------------------------------
* ����: ��ũ�������·�
* ʾ��: ? GetLunarMonthName( 1 )
*-------------------------------------------------
Function GetLunarMonthName( tnMonthNo )
 Local lcRetu
 lcRetu = []
 tnMonthNo = iif( Type([tnMonthNo])=[N], tnMonthNo, 0 )
 If Betw(tnMonthNo,1,12)
  Local lcMonthInfo, lnBeg, lnEnd
  lcMonthInfo = [,Ԫ,��,��,��,��,��,��,��,��,ʮ,��,��,]
  lnBeg = at( [,], lcMonthInfo, tnMonthNo ) + 1
  lnEnd = at( [,], lcMonthInfo, tnMonthNo + 1 )
  lcRetu = subs( lcMonthInfo, lnBeg, lnEnd-lnBeg )
 Endif
 Return lcRetu
Endfunc
*-------------------------------------------------
* ����: ��Ӣ���·�
* ʾ��: ? GetEnglishMonthName( 1 )
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
* ����: �������� ��.��.��.���� ����
* ʾ��: ? GetChineseDateName( 1 )
*-------------------------------------------------
Function GetChineseDateName( tnDay0No )
 Local lcRetu
 lcRetu = []
 tnDay0No = iif( Type([tnDay0No])=[N], tnDay0No, 0 )
 If Betw(tnDay0No,1,11)
  Local lcDay0Info, lnBeg, lnEnd
  lcDay0Info = [,һ,��,��,��,��,��,��,��,��,ʮ,��,]
  lnBeg = at( [,], lcDay0Info, tnDay0No ) + 1
  lnEnd = at( [,], lcDay0Info, tnDay0No + 1 )
  lcRetu = subs( lcDay0Info, lnBeg, lnEnd-lnBeg )
 Endif
 Return lcRetu
Endfunc
*-------------------------------------------------
* ����: ��ũ�� Y ���������
* ʾ��: ? GetLunarYearDays( 2003 )
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
* ����: ��ũ�� Y �����µ�����
* ʾ��: ? GetLunarLeapDays( 2003 )
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
* ����: ��ũ�� Y �� M �µ�������
* ʾ��: ? GetLunarMonthDays( 2003, 10 )
*-------------------------------------------------
Function GetLunarMonthDays( tnYear, tnMonth )
 Local lnRetu, lnTemp, lnInfo
 lnRetu = 0
 lnTemp = 0x8 * 2^(12-tnMonth+1)
 lnInfo = GetlunarInfo(tnYear)
 Return iif( bitor(lnInfo, lnTemp)=lnInfo, 30, 29 )
Endfunc
*-------------------------------------------------
* ����: ��ũ�� Y �����ĸ��� 1-12 , û�򷵻� 0
* ʾ��: ? GetLunarleapMonth( 2003 )
*-------------------------------------------------
Function GetLunarleapMonth( tnYear )
 Local lnInfo
 lnInfo = GetlunarInfo(tnYear)
 Return bitand( lnInfo, 0xF )
Endfunc
*-------------------------------------------------
* ����: ��ũ���������
* ʾ��: ? GetSolarFromLunar( 2003, 06, 05, .F. )
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
   If tnYear > 1900           && ũ����ǰ��ݾ� 1900.01.01 ������
    For liYear = 1900 To tnYear - 1
     lnDiffDays = lnDiffDays + GetLunarYearDays( liYear )
    Endfor
   Endif
   If tnMonth = 1 and tlLeap  && ����Ϊ��Ԫ��
    lnDiffDays = lnDiffDays + GetLunarMonthDays( tnYear, 1 )
   Else
    If tnMonth > 1         && ũ��������ǰ�·ݾ� ����1��1�� ������
     For liMonth = 1 To iif(tlLeap, tnMonth, tnMonth-1 )
      lnDiffDays = lnDiffDays + GetLunarMonthDays( tnYear, liMonth )
     Endfor
    Endif
    If Betw( GetLunarleapMonth(tnYear), 1, tnMonth-1 )
     * ũ��������ǰ�·�������
     lnDiffDays = lnDiffDays + GetLunarLeapDays( tnYear )
    Endif
   Endif
   lnDiffDays = lnDiffDays + tnDay - 1
   * ũ�� 1900.01.01 = ���� 1900.01.31
   ldRetu = Date(1900,01,31) + lnDiffDays
  Endif
 Endif
 Return ldRetu
Endfunc
*-------------------------------------------------
* ����: �ɹ������ũ��
* ʾ��:
* ldDate  = Date(2003,10,01)
* lnYear  = Year (ldDate)
* lnMonth = Month(ldDate)
* lnDay   = Day  (ldDate)
* lIsLeap = .F.
* If GetLunarFromSolar( @lnYear, @lnMonth, @lnDay, @lIsLeap )
*  ? [����:] + DToC(ldDate) + [ -> ũ��:] ;
*   + padl(allt(str(lnYear)),4,[0]) +[.]+ padl(allt(str(lnMonth)),2,[0]) +[.]+ padl(allt(str(lnDay)),2,[0]) ;
*   + iif(lIsLeap,[(��)],[])
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
 lnLeap = GetLunarleapMonth(liYear) && ���ĸ���
 tlLeap = .F.
 liMonth = 1
 Do While liMonth<13 and lnDays > 0
  * ����
  If lnLeap>0 and liMonth=lnLeap+1 and !tlLeap
   liMonth = liMonth - 1
   tlLeap = .T.
   lnTemp = GetLunarLeapDays(liYear)
  Else
   lnTemp = GetLunarMonthDays(liYear, liMonth)
  Endif
  If tlLeap and liMonth=lnLeap+1
   tlLeap = .F. && �������
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
* ����: ����ĳ����������
* ʾ��: ? GetSolarStarName( Date(2003,10,31) )
*-----------------------------------------------------
Function GetSolarStarName( tdDate )
 Local lcRetn, lnMonth, lnDay
 lcRetn = []
 If Type([tdDate])=[D] and !empt(tdDate)
  lnMonth = Month(tdDate)
  lnDay   = Day(  tdDate)
  Do Case
   Case (lnMonth=12 and lnDay>20) or (lnMonth=01 and lnDay<20)
    lcRetn = [ɽ����]
   Case (lnMonth=01 and lnDay>19) or (lnMonth=02 and lnDay<19)
    lcRetn = [ˮƿ��]
   Case (lnMonth=02 and lnDay>18) or (lnMonth=03 and lnDay<21)
    lcRetn = [˫����]
   Case (lnMonth=03 and lnDay>20) or (lnMonth=04 and lnDay<21)
    lcRetn = [������]
   Case (lnMonth=04 and lnDay>20) or (lnMonth=05 and lnDay<21)
    lcRetn = [��ţ��]
   Case (lnMonth=05 and lnDay>20) or (lnMonth=06 and lnDay<21)
    lcRetn = [˫����]
   Case (lnMonth=06 and lnDay>20) or (lnMonth=07 and lnDay<21)
    lcRetn = [��з��]
   Case (lnMonth=07 and lnDay>20) or (lnMonth=08 and lnDay<22)
    lcRetn = [ʨ����]
   Case (lnMonth=08 and lnDay>21) or (lnMonth=09 and lnDay<23)
    lcRetn = [��Ů��]
   Case (lnMonth=09 and lnDay>22) or (lnMonth=10 and lnDay<23)
    lcRetn = [�����]
   Case (lnMonth=10 and lnDay>22) or (lnMonth=11 and lnDay<23)
    lcRetn = [��Ы��]
   Case (lnMonth=11 and lnDay>22) or (lnMonth=12 and lnDay<21)
    lcRetn = [������]
  Endcase
 Endif
 Retu lcRetn
Endfunc
*-------------------------------------------------
* ����: ����ĳ�������µ�����
* ʾ��: ? [���¹� ], GetSolarMonthDays( date() ), [ ��]
*-----------------------------------------------------
Function GetSolarMonthDays( lpDdate )
 lpDdate = iif(Type([lpDdate])$[DT],lpDdate,date())
 Return GoMonth(lpDdate,1)-lpDdate
Endfunc
*-------------------------------------------------
* ����: ����ĳ�������µ����һ��
* ʾ��: ? [�������һ�� ], GetSolarMonthLastDate( date() )
*-----------------------------------------------------
Function GetSolarMonthLastDate( lpDdate )
 Local lnThisY, lnThisM, lnNextY, lnNextM
 lpDdate = iif(Type([lpDdate])$[DT],lpDdate,date())
 lnThisY = Year (lpDdate) && �������
 lnThisM = Month(lpDdate) && �����·�
 lnNextY = IIF( lnThisM=12, lnThisY+1, lnThisY ) && �������
 lnNextM = IIF( lnThisM=12, 01, lnThisM+1 )      && �����·�
 Return Date(lnNextY, lnNextM, 01)-1
Endfunc
*-----------------------------------------------------
* ����: ����ĳ���ϸ��µ����һ��
* ʾ��: ? [�������һ�� ], GetSolarMonthPassDate( date() )
*-----------------------------------------------------
Function GetSolarMonthPassDate( lpDdate )
 lpDdate = iif(Type([lpDdate])$[DT],lpDdate,date())
 Local lnThisY, lnThisM
 lnThisY = Year (lpDdate) && �������
 lnThisM = Month(lpDdate) && �����·�
 Return Date(lnThisY, lnThisM, 01)-1
Endfunc
*-----------------------------------------------------
* ����: ����ĳ��ĳ�µڼ������ڼ�������
* ����: 1��tcYYYYMM  - ��Ԫ����([200310])
*       2��tnNumWeek - ���µڼ�������
*          ����: 1,2,3,4,5 ��ʾ˳���� 1,2,3,4,5 ������
*                6,7,8,9,0 ��ʾ������ 1,2,3,4,5 ������
*       3��tnWeekDay - ���ڼ�(1-7)(����7=������)
* ʾ��: ? [2003��ж���:], GetDateFromYMandWeekNo([200311],4,4)
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
P_USERNAME='³���'
&&xx=ALLTRIM(THISFORM.cmbjsc.DISPLAYVALUE)&&+'.'+ALLTRIM(THISFORM.cmblink.DISPLAYVALUE)+'.'+ALLTRIM(THISFORM.cmbdetail.DISPLAYVALUE)
XX='����ʻ��'
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
*!*				 WAIT WINDOWS '??��ʻ��?'  &&AND  MA8.MA001='2'AND  MA7.MA001='2' AND  MA5.MA001='2'  
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
	CASE XX='����ʻ��'
************��Ӫҵ��������
		SQLEXEC(CON,"SELECT sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND "+;
		"left(LE001,3) like '51[012]' and LE005='2'  ","TMP")
		IF ISNULL(XDS) OR RECCOUNT()<1
			QC=0
		ELSE
			QC=XDS
		ENDIF	
		IF sqlexec(con,"SELECT  SUM( (TB004*TB007))  AS ���� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE  left(TB005,3) like '51[012]'  AND TB001='920' AND TB002<=?xxxx AND LEFT(TB002,4)=?MYEAR","TmpGroupData1")<0
			WAIT WINDOWS 'DFDS��ʻ��' 
			RETURN
		ENDIF&&		
		IF ISNULL(����) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=���� 	
		ENDIF	

		mҵ������=QC+CCD
		SQLEXEC(CON,"SELECT sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND "+;
		"left(LE001,3) like '51[012]' and LE005='2'  ","TMP")
		IF ISNULL(XDS) OR RECCOUNT()<1
			QC=0
		ELSE
			QC=XDS
		ENDIF	
		IF sqlexec(con,"SELECT SUM((TB004*TB007)) AS ���� "+;
		      " FROM ACTTB LEFT JOIN ACTTA ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002 "+;
		      " WHERE left(TB005,3) like '51[012]'  AND TB001='920' AND TB002<=?xxxx1 AND LEFT(TB002,4)=?MYEAR1","TmpGroupData1")<0
			WAIT WINDOWS 'D��ʻ��FDS1' 
			RETURN
		ENDIF&&		
		IF ISNULL(����) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=���� 	
		ENDIF	

		mҵ������1=QC+CCD
************��Ӫҵ��

		SQLEXEC(CON,"SELECT sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND "+;
		"left(LE001,3)='510' and LE005='2'  ","TMP")
		IF ISNULL(XDS) OR RECCOUNT()<1
			QC=0
		ELSE
			QC=XDS
		ENDIF	
		IF sqlexec(con,"SELECT  SUM( (TB004*TB007))  AS ���� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE  left(TB005,3) ='510'  AND TB001='920' AND TB002<=?xxxx AND LEFT(TB002,4)=?MYEAR","TmpGroupData1")<0
			WAIT WINDOWS 'DF��ʻ��DS' 
			RETURN
		ENDIF&&		
		IF ISNULL(����) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=���� 	
		ENDIF	
		m��Ӫҵ��=QC+CCD
		SQLEXEC(CON,"SELECT sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND "+;
		"left(LE001,3)='510' and LE005='2'  ","TMP")
		IF ISNULL(XDS) OR RECCOUNT()<1
			QC=0
		ELSE
			QC=XDS
		ENDIF	
		IF sqlexec(con,"SELECT  SUM( (TB004*TB007))  AS ���� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE  left(TB005,3) ='510'  AND TB001='920' AND TB002<=?xxxx1 AND LEFT(TB002,4)=?MYEAR1","TmpGroupData1")<0
			WAIT WINDOWS 'DFD��ʻ��S' 
			RETURN
		ENDIF&&		
		IF ISNULL(����) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=���� 	
		ENDIF	

		m��Ӫҵ��1=QC+CCD

		lrl=mҵ������/m��Ӫҵ��
		lrl1=mҵ������1/m��Ӫҵ��1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='��Ӫҵ��������' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?lrl,creatdate=getdate(),preval=?lrl1 where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'��Ӫҵ��������',?lrl,getdate(),?P_USERNAME,?pk)")
		ENDIF
	
************������Ȩ��
		SQLEXEC(CON,"SELECT SUM(-1 *(LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND left(LE001,1)= '3' ","TMP")
		QC=XDS
		IF sqlexec(con,"SELECT  SUM((case when left(TB005,1) in (1,4) then 1 else -1 end)*(TB004*TB007))  AS ���� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE  left(TB005 ,1) = '3'  AND TB002<=?xxxx AND LEFT(TB002,4)=?MYEAR","TmpGroupData1")<0
			WAIT WINDOWS 'DFDS  ��ʻ��' 
			RETURN
		ENDIF&&		
		IF ISNULL(����) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=���� 	
		ENDIF	
		m������Ȩ��=QC+CCD/2
		m������Ȩ=QC+CCD
		m����=QC
		SQLEXEC(CON,"SELECT SUM( -1*(LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR1  AND LE003='00' AND left(LE001,1)= '3'")
		QC=XDS
		
		IF sqlexec(con,"SELECT  SUM((case when left(TB005,1) in (1,4) then 1 else -1 end)*(TB004*TB007))  AS ���� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE  left(TB005 ,1) = '3'   AND TB002<=?xxxx1 AND LEFT(TB002,4)=?MYEAR1","TmpGroupData1")<0

			WAIT WINDOWS '��ʻ��   DFDS' 
			RETURN
		ENDIF&&		
		IF ISNULL(����) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=���� 	
		ENDIF	
		m������Ȩ��1=QC+CCD/2
		m������Ȩ1=QC+CCD
		m����1=QC

		SQLEXEC(CON1,"SELECT getval,preval from dashboard  where name=?xx and keydate='������Ȩ��'  AND odbc=?pk","TMP")
		cc=m������Ȩ��
		dd=m������Ȩ��1
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='������Ȩ��'  AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?m������Ȩ,creatdate=getdate(),preval=?m������Ȩ1 where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'������Ȩ��',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF
************�ʱ���ֵ��ֵ��

		SQLEXEC(CON1,"SELECT getval,preval from dashboard  where name=?xx and keydate='�ʱ���ֵ��ֵ��'  AND odbc=?pk ","TMP")
		cc=m������Ȩ/m����
		dd=m������Ȩ1/m����1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�ʱ���ֵ��ֵ��'  AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�ʱ���ֵ��ֵ��',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF
************�ʱ�������

		SQLEXEC(CON1,"SELECT getval,preval from dashboard  where name=?xx and keydate='�ʱ�������'  AND odbc=?pk","TMP")
		cc=(m������Ȩ-m����)/m����
		dd=(m������Ȩ1-m����1)/m����1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�ʱ�������'  AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�ʱ�������',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF

************���ʲ�������

		SQLEXEC(CON1,"SELECT getval,preval from dashboard  where name=?xx and keydate='����ë��'  AND odbc=?pk","TMP")
		cc=getval/m������Ȩ��
		dd=preval/m������Ȩ��1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='���ʲ�������'  AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'���ʲ�������',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF
************�����ܶ�
		SQLEXEC(CON,"SELECT sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND "+;
		"left(LE001,1)='5' AND LE005='2' and left(LE001,4)<>'5241'  ","TMP")
		IF ISNULL(XDS) OR RECCOUNT()<1
			QC=0
		ELSE
			QC=XDS
		ENDIF	
		IF sqlexec(con,"SELECT  SUM( (TB004*TB007))  AS ���� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE  left(TB005,1)='5' and left(TB005,4)<>'5241'  AND TB001='920' AND TB002<=?xxxx AND LEFT(TB002,4)=?MYEAR","TmpGroupData1")<0
			WAIT WINDOWS 'D��ʻ��  FDS' 
			RETURN
		ENDIF&&		
		IF ISNULL(����) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=���� 	
		ENDIF	

		m�����ܶ�=QC+CCD
		SQLEXEC(CON,"SELECT sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND "+;
		"left(LE001,1)='5'  AND LE005='2' and left(LE001,4)<>'5241' ","TMP")
		IF ISNULL(XDS)
			QC=0
		ELSE
			QC=XDS
		ENDIF		
		IF sqlexec(con,"SELECT  SUM( (TB004*TB007))  AS ���� "+;
	      " FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
	      " WHERE   left(TB005,1)='5' and left(TB005,4)<>'5241' AND TB001='920' AND TB002<=?xxxx1 AND LEFT(TB002,4)=?MYEAR1","TmpGroupData1")<0
			WAIT WINDOWS 'DF��ʻ��  DS' 
			RETURN
		ENDIF&&		

		IF ISNULL(����) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=���� 	
		ENDIF	
		m�����ܶ�1=QC+CCD


		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�����ܶ�'  AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?m�����ܶ�,creatdate=getdate(),preval=?m�����ܶ�1  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�����ܶ�',?m�����ܶ�,getdate(),?P_USERNAME,?pk)")
		ENDIF

************���ʲ�
		SQLEXEC(CON,"SELECT sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND left(LE001,1) like '[14]'  ","TMP")
		IF ISNULL(xds) OR RECCOUNT()<1
			qc=0
		else	
			QC=XDS
		ENDIF 	
		nczcc=QC
		IF sqlexec(con,"SELECT  SUM((case when left(TB005,1) in (1,4) then 1 else -1 end)*(TB004*TB007))  AS ���� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE  left(TB005,1) like '[14]'   AND TB002<=?xxxx AND LEFT(TB002,4)=?MYEAR","TmpGroupData1")<0
			WAIT WINDOWS 'DFD��ʻ��  S' 
			RETURN
		ENDIF&&		
		IF ISNULL(����) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=���� 	
		ENDIF	
		bczcc=CCD
		m���ʲ�=QC+CCD
		SQLEXEC(CON,"SELECT sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND left(LE001,1) like '[14]' ","TMP")
		QC=XDS
		nczcc1=QC
		
		IF sqlexec(con,"SELECT  SUM((case when left(TB005,1) in (1,4) then 1 else -1 end)*(TB004*TB007))  AS ���� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE  left(TB005,1) like '[14]' AND TB002<=?xxxx1   AND  LEFT(TB002,4)=?MYEAR1","TmpGroupData1")<0

			WAIT WINDOWS 'DF�Ǽ�ʻ��DS' 
			RETURN
		ENDIF&&		
		IF ISNULL(����) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=���� 	
		ENDIF	
		m���ʲ�1=QC+CCD 
		bczcc1=CCD


		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='���ʲ�' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?m���ʲ�,creatdate=getdate(),preval=?m���ʲ�1  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'���ʲ�',?m���ʲ�,getdate(),?P_USERNAME,?pk)")
		ENDIF
************���ʲ�������

		cc=bczcc/nczcc
		dd=bczcc1/nczcc1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='���ʲ�������' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'���ʲ�������',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF

************���ʲ�������

		cc=m�����ܶ�/m���ʲ�
		dd=m�����ܶ�1/m���ʲ�1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='���ʲ�������' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'���ʲ�������',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF
*************	����	
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
				WAIT windows '???��ʻ��12' 
		endif	
		SUM ch,ch1,cy,cy1 TO cc,cc1,dd,dd1
*!*			cc=ch
*!*			cc1=ch1
*!*			dd=cy
*!*			dd1=cy1
		byxhl=cc
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='��������' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?cc,creatdate=getdate(),preval=?cc1  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,preval,odbc) values (?ffds,?xx,'��������',?cc,getdate(),?P_USERNAME,?cc1,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='��������' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?dd,creatdate=getdate(),preval=?dd1  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,preval,odbc) values (?ffds,?xx,'��������',?dd,getdate(),?P_USERNAME,?dd1,?pk)")
		ENDIF

		
************�ɱ������ܶ�
		IF sqlexec(con,"SELECT SUM(CASE WHEN SUBSTRING(TA003,1,6)= ?mmonth THEN TB019 ELSE 0 END) AS  ���� "+;
		 		" FROM ACRTA INNER JOIN ACRTB ON TA001=TB001 AND TA002=TB002 where SUBSTRING(TA003,1,4)= ?MYEAR ","TmpGroupData1")<0
			WAIT WINDOWS 'D�ͼ�ʻ��FDS' 
			RETURN
		ENDIF&&		
 
		BB=����
 
		RTMD=BB
		IF sqlexec(con,"SELECT Sum(CASE WHEN LEFT(TB002,6)=?MMONTH THEN ACTTB.TB004*ACTTB.TB007 ELSE 0 END) AS '���·���' "+;
		"FROM ACTTB WHERE ACTTB.TB001<>'920' and left(TB005,1) in ('5')"+;
		" and left(TB005,3) in ('511','513','514','515') and ACTTB.TB016='Y' and left(TB002,4)=?MYEAR","TmpGroupData1")<0
			WAIT windows '���������2' 
		ENDIF 		

		BB23=���·���

		*SQLEXEC(CON,"SELECT -1*sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND left(LE001,3) = '510'  ","TMP")
		QC=0&&XDS
		IF sqlexec(con,"SELECT  -1*SUM((case when left(TB005,1) in (1,4) then 1 else -1 end)*(TB004*TB007))  AS ���� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002 inner join CMSMQ ON MQ001=TA001 "+;
		      " WHERE  left(TB005,3) <> '510' and left(TB005,2) = '51' AND LEFT(MQ008,1)<>'4'  AND LEFT(TB002,6)<?MMONTH AND LEFT(TB002,4)=?MYEAR","TmpGroupData1")<0
			WAIT WINDOWS 'D�����ʻ��FDS' 
			RETURN
		ENDIF&&		
		IF ISNULL(����) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=���� 	
		ENDIF	
		m�ɱ������ܶ�=CCD+RTMD*0.7+BB23
		SQLEXEC(CON,"SELECT -1*sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND left(LE001,3) = '510' ","TMP")
		QC=XDS
		
		IF sqlexec(con,"SELECT  -1*SUM((case when left(TB005,1) in (1,4) then 1 else -1 end)*(TB004*TB007))  AS ���� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002 inner join CMSMQ ON MQ001=TA001 "+;
		      " WHERE  left(TB005,3) <> '510' and left(TB005,2) = '51' AND LEFT(MQ008,1)<>'4' AND TB002<=?xxxx1  AND  LEFT(TB002,4)=?MYEAR1","TmpGroupData1")<0

			WAIT WINDOWS 'D�ǷǼ�ʻ��FDS' 
			RETURN
		ENDIF&&		
		IF ISNULL(����) OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=���� 	
		ENDIF	
		m�ɱ������ܶ�1=CCD


		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�ɱ������ܶ�' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?m�ɱ������ܶ�,creatdate=getdate(),preval=?m�ɱ������ܶ�1  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�ɱ������ܶ�',?m�ɱ������ܶ�,getdate(),?P_USERNAME,?pk)")
		ENDIF
		
************�ɱ�����������

		cc=m�����ܶ�/m�ɱ������ܶ�
		dd=m�����ܶ�1/m�ɱ������ܶ�1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�ɱ�����������' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�ɱ�����������',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF
************Ϣ˰ǰ����
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
************��Ϣ
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
************�ѻ���Ϣ����
		cc=jl/ljl
		dd=jl1/ljl1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�ѻ���Ϣ����' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�ѻ���Ϣ����',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF	
************��Ӫ��������ֽ�����
*!*			SQLEXEC(CON1,"SELECT getval,preval from dashboard  where name=?xx and keydate='����ë��' ","TMP")
*!*			jl=getval
*!*			jl1=preval 
		SQLEXEC(CON,"SELECT -1*sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND left(LE001,3) = '161'  ","TMP")
		QC=XDS
		IF sqlexec(con,"SELECT  -1*SUM((case when left(TB005,1) in (1,4) then 1 else -1 end)*(TB004*TB007))  AS ���� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE  left(TB005,3) = '161'   AND TB002<=?xxxx AND LEFT(TB002,4)=?MYEAR","TmpGroupData1")<0
			WAIT WINDOWS 'DF����ʻ��DS' 
			RETURN
		ENDIF&&		
		IF ISNULL(����)  OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=���� 	
		ENDIF	
		gdzc=ccd
		m�����ֽ�����=CCD+jl
		SQLEXEC(CON,"SELECT -1*sum((LE014-LE017)) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND left(LE001,3) = '161' ","TMP")
		QC=XDS
		
		IF sqlexec(con,"SELECT  -1*SUM((case when left(TB005,1) in (1,4) then 1 else -1 end)*(TB004*TB007))  AS ���� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE  left(TB005,3) = '161' AND TB002<=?xxxx1  AND  LEFT(TB002,4)=?MYEAR1","TmpGroupData1")<0

			WAIT WINDOWS 'DFD������ʻ��S' 
			RETURN
		ENDIF&&		
		IF ISNULL(����)  OR RECCOUNT()<1
			CCD=0
		ELSE
			CCD=���� 	
		ENDIF	
		m�����ֽ�����1=CCD+jl1
		gdzc1=ccd


		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�����ֽ�����' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?m�����ֽ�����,creatdate=getdate(),preval=?m�����ֽ�����1  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�����ֽ�����',?m�����ֽ�����,getdate(),?P_USERNAME,?pk)")
		ENDIF

************ӯ���ֽ��ϱ���
		m�ֽ��ϱ���=m�����ֽ�����/jl
		m�ֽ��ϱ���1=m�����ֽ�����1/jl1
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�ֽ��ϱ���' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?m�ֽ��ϱ���,creatdate=getdate(),preval=?m�ֽ��ϱ���1  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�ֽ��ϱ���',?m�ֽ��ϱ���,getdate(),?P_USERNAME,?pk)")
		ENDIF



************������
		SQLEXEC(CON,"SELECT MAX(TB002) AS TB002 FROM ACTTB "+;
		"WHERE ACTTB.TB001='920' and left(TB005,3) in ('510','511','512') and ACTTB.TB016='Y' ","TMP")
		GZR=LEFT(TB002 ,6)
		GZR1=MYEAR1 +SUBSTR(GZR,5,2)
		IF sqlexec(con,"SELECT  SUM(CASE WHEN SUBSTRING(TA003,1,8)= ?XXXX1 THEN (case when ACRTA.TA079='1' then 1 else -1 end)*TB019 ELSE 0 END) AS  ������,"+;
		"SUM(CASE WHEN SUBSTRING(TA003,1,6)= ?mmonth1 AND TA003<= ?XXXX1 THEN (case when ACRTA.TA079='1' then 1 else -1 end)*TB020 ELSE 0 END) AS  y����,"+;
		"SUM(CASE WHEN SUBSTRING(TA003,1,6)= ?mmonth1 AND TA003<= ?XXXX1 THEN (case when ACRTA.TA079='1' then 1 else -1 end)*TB019 ELSE 0 END) AS  ����,"+;
		"SUM(CASE WHEN SUBSTRING(TA003,1,6)> ?GZR1 AND TA003<= ?XXXX1 THEN (case when ACRTA.TA079='1' then 1 else -1 end)*TB019 ELSE 0 END) AS  ë������,"+;
		"SUM(CASE WHEN TA003<=?XXXX1 THEN (case when ACRTA.TA079='1' then 1 else -1 end)*TB019 ELSE 0 END) AS  ������ "+;
		 		" FROM ACRTA INNER JOIN ACRTB ON TA001=TB001 AND TA002=TB002 where SUBSTRING(TA003,1,4)= ?MYEAR1 ","TmpGroupData1")<0
			WAIT WINDOWS 'DF���Ǽ�ʻ��DS' 
			RETURN
		ENDIF&&		
		cc1=������
		BB1=����
		DDDD1=bb1
		DD1=������ 
		YSdd1=dd1
		td1=y����
		MAOLISALE1=ë������

		IF sqlexec(con,"SELECT  SUM(CASE WHEN SUBSTRING(TA003,1,8)= ?XXXX THEN (case when ACRTA.TA079='1' then 1 else -1 end)*TB019 ELSE 0 END) AS  ������,"+;
		"SUM(CASE WHEN SUBSTRING(TA003,1,6)= ?mmonth THEN (case when ACRTA.TA079='1' then 1 else -1 end)*TB020 ELSE 0 END) AS  y����,"+;
		"SUM(CASE WHEN SUBSTRING(TA003,1,6)= ?mmonth THEN (case when ACRTA.TA079='1' then 1 else -1 end)*TB019 ELSE 0 END) AS  ����,"+;
		"SUM(CASE WHEN SUBSTRING(TA003,1,6)> ?GZR THEN (case when ACRTA.TA079='1' then 1 else -1 end)*TB019 ELSE 0 END) AS  ë������,"+;
		"SUM(CASE WHEN TA003<=?XXXX THEN (case when ACRTA.TA079='1' then 1 else -1 end)*TB019 ELSE 0 END) AS  ������ "+;
		 		" FROM ACRTA INNER JOIN ACRTB ON TA001=TB001 AND TA002=TB002 where SUBSTRING(TA003,1,4)= ?MYEAR ","TmpGroupData1")<0
			WAIT WINDOWS '��ʾ��ʻ��DFDS' 
			RETURN
		ENDIF&&		
		cc=������
		BB=����
		DDDD=bb
		DD=������ 
		YSdd=dd
		RTMD=BB
		td=y����
		MAOLISALE=ë������
		tt1=ALLTRIM(STR(INT(cc)))+'/'+ALLTRIM(STR(INT(cc1)))
		tt2=ALLTRIM(STR(INT(bb)))+'/'+ALLTRIM(STR(INT(bb1)))
		tt3=ALLTRIM(STR(INT(dd)))+'/'+ALLTRIM(STR(INT(dd1)))
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='����Ӧ��' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?td,creatdate=getdate(),preval=?td1  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'����Ӧ��',?cc1,getdate(),?P_USERNAME,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='��������' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?cc1  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'��������',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='��������' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?bb,creatdate=getdate(),preval=?bb1  where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'��������',?bb,getdate(),?P_USERNAME,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='��������' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?dd,creatdate=getdate(),preval=?dd1  where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'��������',?dd,getdate(),?P_USERNAME,?pk)")
		ENDIF
************����������
		gdcc=dd/dd1-1
		XXXX2=DTOC(GOMONTH(DATE(),-24),1)
		MYEAR2 =LEFT(XXXX2,4)
		IF sqlexec(con,"SELECT SUM(CASE WHEN TA003<=?XXXX2 THEN TB019 ELSE 0 END) AS  ������ "+;
		 		" FROM ACRTA INNER JOIN ACRTB ON TA001=TB001 AND TA002=TB002 where SUBSTRING(TA003,1,4)= ?MYEAR2 ","TmpGroupData1")<0
			WAIT WINDOWS 'D���ʼ�ʻ��FDS' 
			RETURN
		ENDIF&&		
		DD2=������ 
		gdcc1=dd1/dd2-1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='����������' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?gdcc,creatdate=getdate(),preval=?gdcc1 where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'����������',?gdcc,getdate(),?P_USERNAME,?pk)")
		ENDIF
		
************�ʲ���ת��
		cc=dd/m���ʲ�
		ee=dd1/m���ʲ�1
		ff=mday/ee
		SQLEXEC(CON1,"SELECT interid fro=m dashboard  where name=?xx and keydate='�ʲ���ת��' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?ee  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�ʲ���ת��',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF
		c4=mday/(dd/m���ʲ�)


		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�ʲ���ת����' AND odbc=?pk","TMP")
		SELECT tmp
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?C4,creatdate=getdate(),preval=?ff where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�ʲ���ת����',?C4,getdate(),?P_USERNAME,?pk)")
		ENDIF
*********************�����ʲ�
		SQLEXEC(CON,"SELECT SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND ( LEFT(LE001 ,2) <='15' OR LEFT(LE001,2 )='41' )")
		IF ISNULL(xds)  OR RECCOUNT()<1
			qc=0
		else		
			QC=XDS 
		ENDIF 
		IF sqlexec(con,"SELECT  SUM(TB004*TB007)  AS ������� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND ( LEFT(TB005 ,2)<='15' OR LEFT(TB005,2)='41') and  TB002<=?XXXX and left(TB002,4)=?MYEAR ","TmpGroupData1")<0
			WAIT WINDOWS 'DF�쵼��ʻ��DS' 
			RETURN
		ENDIF	
		Cc=�������+QC
		zcsd=cc
		c1=cc
		SQLEXEC(CON,"SELECT SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND ( LEFT(LE001 ,2) <='15' OR LEFT(LE001,2 )='41' )")
		IF ISNULL(xds)  OR RECCOUNT()<1
			qc=0
		else		
			QC=XDS 
		ENDIF 
		IF sqlexec(con,"SELECT  SUM(TB004*TB007)  AS ������� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND  ( LEFT(TB005 ,2)<='15' OR LEFT(TB005,2)='41') and TB002<=?XXXX1 AND LEFT(TB002,4)=?MYEAR1","TmpGroupData1")<0  &&eft(TB002,6)=?mmonth1 AND 
			WAIT WINDOWS 'DF���Ҽ�ʻ��DS' 
			RETURN
		ENDIF			
		ff=�������+QC
		zcsd1=ff
		c2=ff
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�����ʲ�' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?ff  where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�����ʲ�',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF		
*********************�����ʲ���ת
		gg=YSdd/c1
		ee=YSdd1/c2

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�����ʲ���ת��' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?gg,creatdate=getdate(),preval=?ee where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�����ʲ���ת��',?gg,getdate(),?P_USERNAME,?pk)")
		ENDIF
		r1=mday/(YSdd/c1)
		r2=mday/(YSdd1/c2)

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�����ʲ���ת����' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?r1,creatdate=getdate(),preval=?r2  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�����ʲ���ת����',?r1,getdate(),?P_USERNAME,?pk)")
		ENDIF

*********************�̶��ʲ���ת

		gg=YSdd/gdzc
		ee=YSdd1/gdzc1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�̶��ʲ���ת��' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?gg,creatdate=getdate(),preval=?ee  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�̶��ʲ���ת��',?gg,getdate(),?P_USERNAME,?pk)")
		ENDIF
		r1=mday/(YSdd/gdzc)
		r2=mday/(YSdd1/gdzc1)

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�̶��ʲ���ת����' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?r1,creatdate=getdate(),preval=?r2  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�̶��ʲ���ת����',?r1,getdate(),?P_USERNAME,?pk)")
		ENDIF
*********************���
		SQLEXEC(CON,"SELECT SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND left(LE001,2) in(14,41)")
		IF ISNULL(xds)  OR RECCOUNT()<1
			qc=0
		else		
			QC=XDS 
		ENDIF 
		IF sqlexec(con,"SELECT  SUM(TB004*TB007)  AS ������� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND left(TB005,2) in ('41','14') and  TB002<=?XXXX and left(TB002,4)=?MYEAR ","TmpGroupData1")<0
			WAIT WINDOWS '�˳���ʻ��DFDS' 
			RETURN
		ENDIF	
		WCH=�������+QC
		TCH=(�������/2+QC)*MONTH(DATE())/12
		chsd=WCH
		SQLEXEC(CON,"SELECT SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND left(LE001,2) in(14,41)")
		IF ISNULL(xds)  OR RECCOUNT()<1
			qc=0
		else		
			QC=XDS 
		ENDIF 

		IF sqlexec(con,"SELECT  SUM(TB004*TB007)  AS ������� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND left(TB005,2) in ('41','14') and TB002<=?XXXX1 AND LEFT(TB002,4)=?MYEAR1","TmpGroupData1")<0  &&eft(TB002,6)=?mmonth1 AND 
			WAIT WINDOWS 'D������ʻ��FDS' 
			RETURN
		ENDIF			
		WCH1=�������+QC
		TCH1=(�������/2+QC)*MONTH(DATE())/12
		chsd1=WCH1
		
*********************�����ת
		gg=m��Ӫҵ��/WCH
		ee=m��Ӫҵ��1/WCH1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�����ת��' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?gg,creatdate=getdate(),preval=?ee  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�����ת��',?gg,getdate(),?P_USERNAME,?pk)")
		ENDIF
		r1=mday/gg
		r2=mday/ee

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�����ת����' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?r1,creatdate=getdate(),preval=?r2  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�����ת����',?r1,getdate(),?P_USERNAME,?pk)")
		ENDIF
*********************�ܸ�ծ
		SQLEXEC(CON,"SELECT -1*SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND  left(LE001,1) ='2'")
		IF ISNULL(xds)  OR RECCOUNT()<1
			qc=0
		else		
			QC=XDS 
		ENDIF 
		IF sqlexec(con,"SELECT  -1*SUM(TB004*TB007)  AS ������� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND left(TB005,1)='2'  and  TB002<=?XXXX and left(TB002,4)=?MYEAR ","TmpGroupData1")<0
			WAIT WINDOWS 'DFȡ����ʻ��DS' 
			RETURN
		ENDIF	
		WCH=�������+QC
		TCH=(�������/2+QC)/MONTH(DATE())*12
		SQLEXEC(CON,"SELECT -1*SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND left(LE001,1) ='2'")
		IF ISNULL(xds)  OR RECCOUNT()<1
			qc=0
		else		
			QC=XDS 
		ENDIF 
		IF sqlexec(con,"SELECT  -1*SUM(TB004*TB007)  AS ������� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND left(TB005,1)='2' and TB002<=?XXXX1 AND LEFT(TB002,4)=?MYEAR1","TmpGroupData1")<0  &&eft(TB002,6)=?mmonth1 AND 
			WAIT WINDOWS 'D���ȼ�ʻ��FDS' 
			RETURN
		ENDIF			
		WCH1=�������+QC
		TCH1=(�������/2+QC)/MONTH(DATE())*12
*********************�ʲ���ծ��
		gg=WCH/m���ʲ�
		ee=WCH1/m���ʲ�

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='��ծ��ת��' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?gg,creatdate=getdate(),preval=?ee  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,preval,odbc) values (?ffds,?xx,'��ծ��ת��',?gg,getdate(),?P_USERNAME,?ee,?pk)")
		ENDIF
************�ٶ�����
		tk1=(zcsd-chsd)/WCH
		tk2=(zcsd1-chsd1)/WCH1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�ٶ�����' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?tk1,creatdate=getdate(),preval=?tk2 where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�ٶ�����',?tk1,getdate(),?P_USERNAME,?pk)")
		ENDIF				
************��������
		tk1=(zcsd)/WCH
		tk2=(zcsd1)/WCH1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='��������' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?tk1,creatdate=getdate(),preval=?tk2 where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'��������',?tk1,getdate(),?P_USERNAME,?pk)")
		ENDIF				

************�ʲ�Ϣ˰ǰ������
		gg=jl/dd
		ee=jl1/dd1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='Ϣ˰ǰ������' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?gg,creatdate=getdate(),preval=?ee  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,preval,odbc) values (?ffds,?xx,'Ϣ˰ǰ������',?gg,getdate(),?P_USERNAME,?ee,?pk)")
		ENDIF
		
************�սӵ�
		if SQLEXEC(CON,"select sum( case when TC003=?XXXX then case when  TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 else 0 end) ����,"+;
			"sum(case when LEFT(TC003,6)=?MMONTH then case when TD016='y'  then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 else 0 end) ����,"+;
			"SUM(case when TC003<=?XXXX then case when TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 ELSE 0 END) as ����"+;
			" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,4)=?MYEAR  ","TmpQ2C") <0  &&and TC004<>'90574019'
			WAIT windows '?�ļ�ʻ��??1' 
		endif	
		A2=����
		A1=���� 
		A3=���� 
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
*!*			if SQLEXEC(CONX,"select sum( case when TC003=?XXXX then case when  TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 else 0 end) ����,"+;
*!*				"sum(case when LEFT(TC003,6)=?MMONTH then case when TD016='y'  then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 else 0 end) ����,"+;
*!*				"SUM(case when TC003<=?XXXX then case when TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 ELSE 0 END) as ����"+;
*!*				" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,4)=?MYEAR and TC004<>'90574019' ","TmpQ2C") <0
*!*				WAIT windows '???2' 
*!*			endif	
*!*			SQLDISCONNECT(CONX)
*!*			A21=����
*!*			A11=���� 
*!*			A31=���� 
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

		if SQLEXEC(CON,"select sum( case when TC003=?XXXX1 then case when  TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 else 0 end) ����,"+;
			"sum(case when LEFT(TC003,6)=?MMONTH1 AND TC003<= ?XXXX1 then case when TD016='y'  then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 else 0 end) ����,"+;
			"SUM(case when TC003<=?XXXX1 then case when TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 ELSE 0 END) as ����"+;
			" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,4)=?MYEAR1  ","TmpQ2C") <0  &&and TC004<>'90574019'
			WAIT windows '??���͹���ʻ��?1' 
		endif	
		A2=����
		A1=���� 
		A3=���� 
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
*!*			if SQLEXEC(CONx,"select sum( case when TC003=?XXXX1 then case when  TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 else 0 end) ����,"+;
*!*				"sum(case when LEFT(TC003,6)=?MMONTH1 then case when TD016='y'  then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 else 0 end) ����,"+;
*!*				"SUM(case when TC003<=?XXXX1 then case when TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009 ELSE 0 END) as ����"+;
*!*				" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,4)=?MYEAR1 and TC004<>'90574019' ","TmpQ2C") <0
*!*				WAIT windows '???2' 
*!*			endif
*!*			SQLDISCONNECT(CONX)		
*!*			A21=����
*!*			A11=���� 
*!*			A31=���� 
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

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='���սӵ�' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?cc1  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'���սӵ�',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='���½ӵ�' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?bb,creatdate=getdate(),preval=?bb1  where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'���½ӵ�',?bb,getdate(),?P_USERNAME,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='����ӵ�' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?dd,creatdate=getdate(),preval=?dd1  where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'����ӵ�',?dd,getdate(),?P_USERNAME,?pk)")
		ENDIF
		************�����Ʒ
		IF sqlexec(con,"SELECT  SUM(TB004*TB007)  AS ���  "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND  left(TB005,3)='146' and  LEFT(TB002,6)=?MMONTH1 AND TB002<=?xxxx1","TmpGroupData1")<0
			WAIT WINDOWS 'DF�����ʻ��DS1' 
			RETURN
		ENDIF&&			
		CC=��� 
		IF ISNULL(CC)=.T.
			CC=0
		ENDIF	

		IF SQLEXEC(con,"SELECT SUM((case when left(LE001,1) in(1,4) then 1 else -1 end)*(LE014-LE017)) ��� FROM ACTLE"+;
		"  where LE002=?MYEAR1 and LE003<?XF and  left(LE001,3)='146'","tmp")<0
			WAIT WINDOWS 'DFDS2' 
			RETURN
		ENDIF&&			
		DD=���+CC
		IF sqlexec(con,"SELECT  SUM(TB004*TB007)  AS ���  "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND  left(TB005,3)='146' and  LEFT(TB002,6)=?MMONTH AND TB002<=?xxxx","TmpGroupData1")<0
			WAIT WINDOWS 'DFDS��ʻ��3' 
			RETURN
		ENDIF&&			
		CC=��� 
		IF ISNULL(CC)=.T.
			CC=0
		ENDIF	
		XF=SUBSTR(MMONTH,5,2)
		IF SQLEXEC(con,"SELECT SUM((case when left(LE001,1) in(1,4) then 1 else -1 end)*(LE014-LE017)) ��� FROM ACTLE"+;
		"  where LE002=?MYEAR and LE003<?XF and  left(LE001,3)='146'","tmp")<0
			WAIT WINDOWS 'DFDS��ʻ��4' 
			RETURN
		ENDIF&&			
		CC1=���+CC
				
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�����Ʒ' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?cc1,creatdate=getdate(),preval=?dd  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�����Ʒ',?dd,getdate(),?P_USERNAME,?pk)")
		ENDIF
		************ʵ��
		SQLEXEC(CON,"DROP VIEW LHB")
		IF SQLEXEC(CON,"CREATE VIEW LHB AS SELECT LB005 AS �ͻ�, SUBSTRING(LB020,1,8) AS ����, (CASE WHEN LB001 IN ('0', '1', '2') THEN (LB014 + LB019) ELSE 0.0 END) AS ����Ӧ��, "+;
		"(CASE WHEN LB001 IN ('3', '4', '5') THEN LB014 ELSE 0.0 END) AS ����ʵ�� FROM ACRLB AS ACRLB WHERE (1 = 1 AND LB001 NOT IN ('B', 'C')) UNION ALL "+;
		"SELECT LC006 AS KHID, LC029 AS DAY,  0.0 AS BBYSJE, (CASE WHEN MQ003 IN ('61', '6A', '66', '6B') "+;
		" THEN LC018 ELSE 0.0 END) AS BBSSJE "+;
		" FROM ACRLC  LEFT JOIN CMSMQ AS CMSMQ ON MQ001 = LC003 WHERE (1 = 1 AND (Round(LC018, 3) <> 0.0 OR Round(LC017, 3) <> 0.0)) UNION ALL "+;
		"SELECT LC006 AS KHID,  SUBSTRING(LC029,1,8) AS DAY, 0.0 AS BBYSJE,  LC019 AS BBSSJE  "+;
		" FROM ACRLC WHERE (1 = 1 AND Round(LC019, 3) <> 0.0 ) UNION ALL "+;
		"SELECT LE005 KHID,LD003 DAY,CASE WHEN LE004='3'  THEN 0- LE014 ELSE LE014 END THJE,0 AS SS FROM ACRLD LEFT JOIN ACRLE ON LD001=LE001 AND LD002=LE002")<0
			WAIT windows '��ͼ���������' 
		ENDIF 	

		IF SQLEXEC(CON,"select "+;
			"SUM(CASE WHEN LEFT(����,6)=?MMONTH AND SUBSTRING(����,1,4)=?MYEAR THEN ����Ӧ�� ELSE 0.0 END) as ����Ӧ��,SUM( CASE WHEN LEFT(����,4)=?MYEAR THEN ����Ӧ�� ELSE 0 END) as ����Ӧ��, "+;
			"SUM(CASE WHEN LEFT(����,6)=?MMONTH THEN ����ʵ�� ELSE 0.0 END) as ����ʵ��, SUM( CASE WHEN SUBSTRING(����,1,4)=?MYEAR THEN ����ʵ�� ELSE 0 END) as ����ʵ��, "+;
			"sum(CASE WHEN ����<=?xxxx THEN ����Ӧ��-����ʵ�� ELSE 0 END) AS ��ĩӦ�� ,SUM(CASE WHEN  ����>=?XXXX and LEFT(����,4)=?MYEAR THEN ����ʵ�� ELSE 0.0 END) as ʵ�� FROM LHB","TmpQC")<0
			WAIT windows '���������1' 
		ENDIF 	
		cc1=����Ӧ��
		dd1=����Ӧ��
		ee1=����ʵ��
		ff1=����ʵ��
		GG1=��ĩӦ��
		YSdd=dd1
		TCH=��ĩӦ��
		IF SQLEXEC(CON,"select "+;
			"SUM(CASE WHEN LEFT(����,6)=?MMONTH1 AND ����<=?XXXX1  THEN ����Ӧ�� ELSE 0.0 END) as ����Ӧ��,SUM( CASE WHEN LEFT(����,4)=?MYEAR1 AND ����<=?XXXX1 THEN ����Ӧ�� ELSE 0 END) as ����Ӧ��, "+;
			"SUM(CASE WHEN LEFT(����,6)=?MMONTH1 AND ����<=?XXXX1  THEN ����ʵ�� ELSE 0.0 END) as ����ʵ��,SUM( CASE WHEN LEFT(����,4)=?MYEAR1 AND ����<=?XXXX1 THEN ����ʵ�� ELSE 0 END) as ����ʵ��, "+;
			"sum(CASE WHEN ����<=?xxxx1 THEN ����Ӧ��-����ʵ�� ELSE 0 END) AS ��ĩӦ��  ,SUM(CASE WHEN  ����<=?XXXX1 and LEFT(����,4)=?MYEAR1 THEN ����ʵ�� ELSE 0.0 END) as ʵ�� FROM LHB ","TmpQC")<0
			WAIT windows '���������2' 
		ENDIF 	
		cc2=����Ӧ��
		dd2=����Ӧ��
		ee2=����ʵ��
		ff2=����ʵ��
		GG2=��ĩӦ��
		YSdd1=dd2
		TCH1=��ĩӦ��
*!*	*********************Ӧ���˿�
*!*			SQLEXEC(CON,"SELECT SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR and LE003='00' AND  left(LE001,3) in ('114','113')")
*!*			QC=XDS
*!*			WCH=(TCH+QC)/2
*!*			SQLEXEC(CON,"SELECT SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR1 and LE003='00' AND  left(LE001,3) in ('114','113')")
*!*			QC=XDS
*!*			WCH1=(TCH1+QC)/2
*********************Ӧ���˿���ת
		gg=YSdd/TCH
		ee=YSdd1/TCH1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='Ӧ���˿���ת��' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?gg,creatdate=getdate(),preval=?ee where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'Ӧ���˿���ת��',?gg,getdate(),?P_USERNAME,?pk)")
		ENDIF
		r1=mday*TCH/YSdd
		r2=mday*TCH1/YSdd1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='Ӧ���˿���ת����'  AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?r1,creatdate=getdate(),preval=?r2  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'Ӧ���˿���ת����',?r1,getdate(),?P_USERNAME,?pk)")
		ENDIF

	*************************Ӧ�����
*!*			SQLEXEC(CON,"select SUM((TA041+TA042-TA098+TA059)*(case when TA079=1 then 1 else -1 end)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end)) as 'Ӧ�����' "+;
*!*			"from ACRTA left join CMSMQ on MQ001=TA001 where TA025='Y' and TA029+TA030 <>ACRTA.TA031 and TA020<?xxxx1","tmp")
*!*			cdddd=Ӧ�����
*!*			IF ISNULL(cdddd)
*!*				cdddd=0
*!*			ENDIF	
*!*			DD=cdddd
*!*			SQLEXEC(CON,"select SUM((TA041+TA042-TA098+TA059)*(case when TA079=1 then 1 else -1 end)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end)) as 'Ӧ�����' "+;
*!*			"from ACRTA left join CMSMQ on MQ001=TA001 where TA025='Y' and TA029+TA030 <>ACRTA.TA031","tmp")
*!*			cdddd=Ӧ�����
*!*			IF ISNULL(cdddd)
*!*				cdddd=0
*!*			ENDIF	
*!*			cc=cdddd
*!*			tt1=ALLTRIM(STR(INT(cc)))+'/'+ALLTRIM(STR(INT(cc1)))

		IF SQLEXEC(CON,"select  Sum(CASE WHEN ACRTI.TI019<=?XXXX  AND (ACRTI.TI031 = '1')  THEN TI016+TI032 ELSE 0 END)-Sum(CASE WHEN ACRTI.TI019<=?XXXX  "+;
		 "   AND (ACRTI.TI031 = '2')  THEN TI016+TI032 ELSE 0 END) AS δ���ܶ�, Sum(CASE WHEN ACRTI.TI019<=?XXXX1  AND (ACRTI.TI031 = '1')  THEN TI016+TI032 ELSE 0 END)-Sum(CASE WHEN ACRTI.TI019<=?XXXX1  "+;
		 "   AND (ACRTI.TI031 = '2')  THEN TI016+TI032 ELSE 0 END) AS δ���ܶ�1 "+;
		"FROM ACRTI  WHERE TI013='Y' " ,"TmpCustom1")<0
		 WAIT windows '����Ӧ�տ�'
		 ENDIF 
		GG1=δ���ܶ�
		gg2=δ���ܶ�1
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='Ӧ�����' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc11=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?GG1,creatdate=getdate(),preval=?GG2 where interid=?cc11")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'Ӧ�����',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF

*!*			SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='����Ӧ��' AND odbc=?pk","TMP")
*!*			IF RECCOUNT()=1
*!*				cc12=interid
*!*				SQLEXEC(CON1,"UPDATE dashboard set getval=?cc1,creatdate=getdate(),preval=?cc2  where interid=?cc12")
*!*			ELSE
*!*				SQLDISCONNECT(CON1) 	
*!*				ffds=maxinterid("dashboard")
*!*				CON1=ODBC(6)
*!*				SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'����Ӧ��',?cc1,getdate(),?P_USERNAME,?pk)")
*!*			ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='����Ӧ��' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?dd1,creatdate=getdate(),preval=?dd2  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'����Ӧ��',?dd1,getdate(),?P_USERNAME?pk)")
		ENDIF		
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='����ʵ��' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?ee1,creatdate=getdate(),preval=?ee2  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'����ʵ��',?ee1,getdate(),?P_USERNAME,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='����ʵ��' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?ff1,creatdate=getdate(),preval=?ff2  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'����ʵ��',?ff1,getdate(),?P_USERNAME,?pk)")
		ENDIF		

*!*	 inner join CMSMQ ON MQ001=TA001 "+;
*!*			      " WHERE  left(TB005,3) <> '510' and left(TB005,2) = '51' AND LEFT(MQ008,1)<>'4'
****************����
		IF sqlexec(con,"SELECT SUM(CASE WHEN TB002=?XXXX1 THEN ACTTB.TB004*ACTTB.TB007 ELSE 0 END)  '���շ���',"+;
		"Sum(CASE WHEN LEFT(TB002,6)= ?MMONTH1 AND TB002<=?XXXX1 THEN ACTTB.TB004*ACTTB.TB007 ELSE 0 END) AS '���·���',SUM( ACTTB.TB004*ACTTB.TB007) �������"+;
		",SUM(CASE WHEN TB005 like '514131%02' THEN ACTTB.TB004*ACTTB.TB007 ELSE 0 END)  '�з�����' "+;
		"FROM ACTTB WHERE ACTTB.TB001<>'920' and left(TB005,1) in ('5')"+;
		" and left(TB005,3) in ('511','513','514','515') and ACTTB.TB016='Y' and left(TB002,4)=?MYEAR1 AND TB002<=?XXXX1","TmpGroupData1")<0
			WAIT windows '���������1' 
		ENDIF 	
		cc1=���շ���
		BB123=���·���
		BB1=���·���
		fyfy1=bb1
		DD1=�������
		DD123=�������
		XD1=�з�����
		IF sqlexec(con,"SELECT SUM(CASE WHEN TB002=?XXXX THEN ACTTB.TB004*ACTTB.TB007 ELSE 0 END)  '���շ���' ,"+;
		"Sum(CASE WHEN LEFT(TB002,6)=?MMONTH THEN ACTTB.TB004*ACTTB.TB007 ELSE 0 END) AS '���·���',SUM( ACTTB.TB004*ACTTB.TB007) ������� "+;
		",SUM(CASE WHEN (TB005 like '514131%02') THEN ACTTB.TB004*ACTTB.TB007 ELSE 0 END)  '�з�����' "+;
		"FROM ACTTB WHERE ACTTB.TB001<>'920' and left(TB005,1) in ('5')"+;
		" and left(TB005,3) in ('511','513','514','515') and ACTTB.TB016='Y' and left(TB002,4)=?MYEAR","TmpGroupData1")<0
			WAIT windows '���������2' 
		ENDIF 		
		cc=���շ���
		BB=���·���
		BB23=���·���
		fyfy=bb
		DD=�������
		DD23=�������
		XD=�з�����
		tt1=ALLTRIM(STR(INT(cc)))+'/'+ALLTRIM(STR(INT(cc1)))
		tt2=ALLTRIM(STR(INT(bb)))+'/'+ALLTRIM(STR(INT(bb1)))
		tt3=ALLTRIM(STR(INT(dd)))+'/'+ALLTRIM(STR(INT(dd1)))		
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�з�����' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc11=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?XD,creatdate=getdate(),preval=?XD1 where interid=?cc11")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,preval,creatdate,billname,odbc) values (?ffds,?xx,'�з�����',?XD,?XD1,getdate(),?P_USERNAME,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='���շ���' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc11=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?cc1   where interid=?cc11")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'���շ���',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='���·���' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?bb23,creatdate=getdate(),preval=?bb123 where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'���·���',?bb,getdate(),?P_USERNAME,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�������' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?DD23 ,creatdate=getdate(),preval=?dd123  where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�������',?DD,getdate(),?P_USERNAME,?pk)")
		ENDIF
		ddXY=MAOLISALE*0.35
		dd=DDDD*0.35
		dd1=dddd1*0.35&&-fyfy1
		DD511=dd
		DD1511=DD1
		ddXY1=MAOLISALE1*0.35
		
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='����ë��' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?DD ,creatdate=getdate(),preval=?dd1 where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'����ë��',?DD,getdate(),?P_USERNAME,?pk)")
		ENDIF
		gzr2=myear1+SUBSTR(GZR1,5,2)
		SQLEXEC(CON,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '����ë��' FROM ACTTB inner join CMSMQ ON MQ001=TB001 "+;
		"WHERE LEFT(MQ008,1)='4' and (left(TB005,3) in ('510','511','512')  ) and ACTTB.TB016='Y' and left(TB002,4) =?myear1 AND LEFT(TB002,6)<=?gzr2","TMP")
		bb1=����ë��+ddXY1&&DD1511
		SQLEXEC(CON,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '����ë��' FROM ACTTB inner join CMSMQ ON MQ001=TB001 "+;
		"WHERE LEFT(MQ008,1)='4' and (left(TB005,3) in ('510','511','512')) and ACTTB.TB016='Y' and left(TB002,4) =?myear ","TMP")
		bb=����ë��+ddXY&&���µ�
		tt2=ALLTRIM(STR(INT(bb)))+'/'+ALLTRIM(STR(INT(bb1)))

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='����ë��' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?bb,creatdate=getdate(),preval=?bb1 where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'����ë��',?bb,getdate(),?P_USERNAME,?pk)")
		ENDIF		
		
		SQLEXEC(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '���꾻��' FROM ACTTB WHERE ACTTB.TB001='920' and (left(TB005,1) in('5') OR  TB005 like '514131%02' ) and ACTTB.TB016='Y'"+;
		"  and left(TB002,4) =?myear1  AND TB002<=?XXXX1 ","tmp")
		bb1=���꾻��+DD1511/2&&�ٱ��µ�
		SQLEXEC(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '���꾻��' FROM ACTTB WHERE ACTTB.TB001='920' and (left(TB005,1) in('5') OR  TB005 like '514131%02' ) and ACTTB.TB016='Y'"+;
		"  and left(TB002,4) =?myear AND TB001='920'","tmp")
		bb=���꾻��+ddXY/2
		tt2=ALLTRIM(STR(INT(bb)))+'/'+ALLTRIM(STR(INT(bb1)))

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='���꾻��' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?bb,creatdate=getdate(),preval=?BB1   where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'���꾻��',?bb,getdate(),?P_USERNAME,?pk)")
		ENDIF			


*************************�ʽ�
		IF sqlexec(con,"SELECT  SUM(TB004*TB007)  AS ������� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND (LEFT(TB005 ,4)='1101' OR LEFT(TB005 ,4)='1111') and LEFT(TA014,8)<=?XXXX1 ","TmpGroupData1")<0
			WAIT WINDOWS 'DFDS' 
			RETURN
		ENDIF&&		
		ccCC1=�������+17759846
		IF sqlexec(con,"SELECT  SUM(TB004*TB007)  AS ������� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND (LEFT(TB005 ,4)='1101' OR LEFT(TB005 ,4)='1111')  ","TmpGroupData1")<0
			WAIT WINDOWS 'DFDS' 
			RETURN
		ENDIF&&		
		ccCCCC=�������+17759846
		tt1=ALLTRIM(STR(INT(cc)))+'/'+ALLTRIM(STR(INT(cc1)))

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�ֽ����' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc11=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?ccCCCC,creatdate=getdate(),preval=?ccCC1 where interid=?cc11")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�ֽ����',?ccCCCC,getdate(),?P_USERNAME,?pk)")
		ENDIF

		*************************����Ӧ��
		SQLEXEC(CON,"DROP VIEW LHB")

		SQLEXEC(CON,"CREATE VIEW LHB AS SELECT LB005 AS ��Ӧ��,SUBSTRING(LB020,1,8) AS ����,"+;
			"(Case when LB001 in ('0','1','2') then LB014 when (LB001='C' AND MQ003 IN ('71','7A','7B','7F')) then LB019  else 0.0 end) as ����Ӧ��,"+;
			"(Case when LB001 in ('3','4','5') then LB014 when (LB001='C' AND MQ003='7C') then LB019 else 0.0 end) as ����ʵ�� "+;
		 	"From ACPLB  LEFT JOIN CMSMQ AS CMSMQ ON MQ001=LB009  where LB027='1' union all "+;
			"SELECT LC006,SUBSTRING(LC029,1,6) LC029,(Case when MQ003 IN ('71','7A','7F') then (-1)*LC018 else 0 end) as BBYSJE, "+;
		 	" (Case when LC019 <> 0.0 then LC019 else 0.0 end) as BBSSJE "+;
		 	" FROM ACPLC LEFT JOIN CMSMQ AS CMSMQ ON LC003=MQ001 where LC036='1' and (Round(LC019,3)<>0.0 or Round(LC018,3)<>0.0 or Round(LC017,3)<>0.0) UNION ALL "+;
			"SELECT LE005 KHID,LD010 DAY,LE014 THJE,0 SS FROM ACPLD LEFT JOIN ACPLE ON LD001=LE001 AND LD002=LE002")
		IF SQLEXEC(CON,"select   "+;
			"SUM(CASE WHEN LEFT(����,6)=?MMONTH AND SUBSTRING(����,1,4)=?MYEAR THEN ����Ӧ�� ELSE 0.0 END) as ����Ӧ��, SUM( CASE WHEN SUBSTRING(����,1,4)=?MYEAR THEN ����Ӧ�� ELSE 0 END) as ȫ��Ӧ��,"+;
			"SUM(CASE WHEN LEFT(����,6)=?MMONTH THEN ����ʵ�� ELSE 0.0 END) as ����ʵ��, SUM( CASE WHEN SUBSTRING(����,1,4)=?MYEAR THEN ����ʵ�� ELSE 0 END) as ȫ��ʵ��,"+;
			"sum( ����Ӧ��-����ʵ�� ) AS ��ĩӦ�� ,0 ����δ�� "+;
			" FROM LHB","TmpQC")<0
			WAIT windows 'yf' 
		ENDIF 
		cc1=����Ӧ��
		dd1=ȫ��Ӧ��
		ee1=����ʵ��
		ff1=ȫ��ʵ��
		GG1=��ĩӦ��
		IF SQLEXEC(CON,"select   "+;
			"SUM(CASE WHEN LEFT(����,6)=?MMONTH1 and ����<=?xxxx1 THEN ����Ӧ�� ELSE 0.0 END) as ����Ӧ��, SUM( CASE WHEN SUBSTRING(����,1,4)=?MYEAR1 and ����<=?xxxx1 THEN ����Ӧ�� ELSE 0 END) as ȫ��Ӧ��,"+;
			"SUM(CASE WHEN LEFT(����,6)=?MMONTH1 and ����<=?xxxx1 THEN ����ʵ�� ELSE 0.0 END) as ����ʵ��, SUM( CASE WHEN SUBSTRING(����,1,4)=?MYEAR1 and ����<=?xxxx1 THEN ����ʵ�� ELSE 0 END) as ȫ��ʵ��,"+;
			"sum(CASE WHEN ����<=?xxxx1 THEN ����Ӧ��-����ʵ�� ELSE 0 END) AS ��ĩӦ�� ,0 ����δ�� "+;
			" FROM LHB","TmpQC")<0
			WAIT windows 'yf' 
		ENDIF 
		cc2=����Ӧ��
		dd2=ȫ��Ӧ��
		ee2=����ʵ��
		ff2=ȫ��ʵ��
		GG2=��ĩӦ��
		*************************Ӧ�����
*!*			SQLEXEC(CON,"select sum((TA037+TA038-TA085+TA051)*(case when TA079=1 then 1 else -1 end)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end)) as 'Ӧ�����' "+;
*!*			"from ACPTA left join CMSMQ on MQ001=TA001 where TA024='Y' and TA028+TA029 <>ACPTA.TA030","tmp")

*!*			dddc=Ӧ�����
*!*			IF ISNULL(dddc)
*!*				dddc=0
*!*			ENDIF
*!*			cc=dddc
*!*			SQLEXEC(CON,"select sum((TA037+TA038-TA085+TA051)*(case when TA079=1 then 1 else -1 end)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end)) as 'Ӧ�����' "+;
*!*			"from ACPTA left join CMSMQ on MQ001=TA001 where TA024='Y' and TA028+TA029 <>ACPTA.TA030 and LEFT(TA019,8)<=?XXXX1","tmp")

*!*			dddc=Ӧ�����
*!*			IF ISNULL(dddc)
*!*				dddc=0
*!*			ENDIF
*!*			DD=dddc
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='Ӧ�����' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc11=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?gg1,creatdate=getdate(),preval=?gg1  where interid=?cc11")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'Ӧ�����',?gg1,getdate(),?P_USERNAME,?pk)")
		ENDIF

		****************����δ�����
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='δ�����' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc11=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?GG1,creatdate=getdate(),preval=?GG2  where interid=?cc11")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'δ�����',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF		

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='����Ӧ��' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?cc1,creatdate=getdate(),preval=?cc2  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'����Ӧ��',?cc1,getdate(),?P_USERNAME,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='����Ӧ��' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?dd1,creatdate=getdate(),preval=?dd2  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'����Ӧ��',?dd1,getdate(),?P_USERNAME,?pk)")
		ENDIF		
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='����ʵ��' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?ee1,creatdate=getdate(),preval=?ee2  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'����ʵ��',?ee1,getdate(),?P_USERNAME,?pk)")
		ENDIF
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='����ʵ��' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?ff1,creatdate=getdate(),preval=?ff2  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'����ʵ��',?ff1,getdate(),?P_USERNAME,?pk)")
		ENDIF		
		**********************Ԥ�����
		SQLEXEC(CON,"select SUM( (TK033+TK035+TK036-TK038+TK041)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end) ) as 'Ԥ�����' "+;
		"from ACRTK left join CMSMQ on MQ001=TK001 where TK020='Y' and TK030 <> '3' ","tmp")
		cc=Ԥ�����
		SQLEXEC(CON,"select SUM( (TK033+TK035+TK036+TK041-TK038)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end) ) as 'Ԥ�����' "+;
		"from ACRTK left join CMSMQ on MQ001=TK001 where TK020='Y' and TK030 <> '3' AND TK003<=?XXXX1","tmp")
*!*			dd1=Ԥ�����
*!*			SQLEXEC(CON,"select SUM( (TL020+TL022)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end) ) as 'Ԥ�����' "+;
*!*			"from ACRTL INNER JOIN ACRTK ON TL001=TK001 AND TL002=TK002 Left join CMSMQ on MQ001=TK001 where TL027='Y' AND TL026<=?XXXX1","tmp")
		DD=Ԥ�����
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='Ԥ�����' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'Ԥ�����',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF
		**********************Ԥ�����1

		SQLEXEC(CON,"select SUM((TK031+TK033+TK034-TK036+TK039)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end)) as 'Ԥ�����' "+;
		"from ACPTK left join CMSMQ on MQ001=TK001 where TK020='Y' and ACPTK.TK028 <> '3'","TmpQC")
		cc=Ԥ�����
		SQLEXEC(CON,"select SUM((TK031+TK033+TK034+TK039-TK036)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end)) as 'Ԥ�����' "+;
		"from ACPTK left join CMSMQ on MQ001=TK001 where TK020='Y' and ACPTK.TK028 <> '3' and TK003<=?XXXX1 ","TmpQC")
*!*			DD1s=Ԥ�����
*!*			SQLEXEC(CON,"select SUM((TL020+TL022)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end))   as 'Ԥ�����' "+;
*!*			"from ACPTL INNER JOIN ACPTK ON TL001=TK001 AND TL002=TK002  left join CMSMQ on MQ001=TK001 where TL027='Y' AND  and  TL026<=?XXXX1 ","TmpQC")
*!*			sds=Ԥ�����
		DD=Ԥ�����
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='Ԥ�����' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'Ԥ�����',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF		
		*********************������ծ
		SQLEXEC(CON,"SELECT -1*SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND ( LEFT(LE001 ,2) in ('21','22') )")
		QC=XDS
		IF sqlexec(con,"SELECT  -1*SUM(TB004*TB007) AS �������  FROM ACTTB LEFT JOIN ACTTA ON TA001 = TB001 AND TA002 = TB002"+;
		      " WHERE TA010='Y' AND LEFT(TB005 ,2) in ('21','22') and  TB002<=?XXXX and left(TB002,4)=?MYEAR","TmpGroupData1")<0
			WAIT WINDOWS 'DFDS' 
			RETURN
		ENDIF 
		BQ=�������
		IF ISNULL(BQ)
			BQ=0
		ENDIF	
		CC=	BQ+QC
		WCHfz=CC
		SQLEXEC(CON,"SELECT -1*SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND ( LEFT(LE001 ,2) in ('21','22') )")
		QC=XDS
		IF sqlexec(con,"SELECT  -1*SUM(TB004*TB007)  AS ������� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND ( LEFT(TB005 ,2) in ('21','22') ) and  TB002<=?XXXX1 AND LEFT(TB002,4)=?MYEAR1 ","TmpGroupData1")<0
			WAIT WINDOWS 'DFDS' 
		ENDIF		
		DD=�������+QC
		WCHfz1=DD
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='������ծ' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'������ծ',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF		
		************�ֽ����
		tk1=ccCCCC/WCHfz
		tk2=ccCC1/WCHfz1

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�ֽ����' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?tk1,creatdate=getdate(),preval=?tk2 where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�ֽ����',?tk1,getdate(),?P_USERNAME,?pk)")
		ENDIF				

		************�ֽ�������ծ����
		m�ֽ��ϱ���=(m�����ֽ�����+ccCCCC)/WCHfz
		m�ֽ��ϱ���1=(m�����ֽ�����+ccCC1)/WCHfz1
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�ֽ�������ծ����' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc21=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?m�ֽ��ϱ���,creatdate=getdate(),preval=?m�ֽ��ϱ���1  where interid=?cc21")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�ֽ�������ծ����',?m�ֽ��ϱ���,getdate(),?P_USERNAME,?pk)")
		ENDIF
		*********************�������ʲ�
		SQLEXEC(CON,"SELECT -1*SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR AND LE003='00' AND (left(LE001,2) <>'21' AND left(LE001,2) <>'22') AND left(LE001,2)>'15' "+;
		      "AND left(LE001,2)<>'41' ")
		QC=XDS
		IF sqlexec(con,"SELECT  -1*SUM(TB004*TB007)  AS ������� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND (left(TB005,2) <>'21' AND left(TB005,2) <>'22') AND left(TB005,2)>'15' "+;
		      "AND left(TB005,2)<>'41' and TB002<=?XXXX and left(TB002,4)=?MYEAR AND TB001='920' ","TmpGroupData1")<0
			WAIT WINDOWS 'DFDS1' 
			RETURN
		ENDIF 	
		CC=�������+QC
		SQLEXEC(CON,"SELECT -1*SUM(LE014-LE017) XDS FROM ACTLE WHERE LE002=?MYEAR1 AND LE003='00' AND (left(LE001,2) <>'21' AND left(LE001,2) <>'22') AND left(LE001,2)>'15' "+;
		      "AND left(LE001,2)<>'41' ")		
		QC=XDS
		IF sqlexec(con,"SELECT  -1*SUM(TB004*TB007)  AS ������� "+;
		      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
		      " WHERE TA010='Y' AND (left(TB005,2) <>'21' AND left(TB005,2) <>'22') AND left(TB005,2)>'15' AND left(TB005,2)<>'41'"+;
		      "  and TB002<=?XXXX1 AND LEFT(TB002,4)=?MYEAR1 AND TB001='920'","TmpGroupData1")<0
			WAIT WINDOWS 'DFDS3' 
			RETURN
		ENDIF			
		DD=�������+QC
*!*			IF sqlexec(con,"SELECT sum((case when left(LE001,1) in (1,4) then 1 else -1 end)* (LE014-LE017) ) ���"+;
*!*				"  FROM ACTLE where (left(LE001,2) <>'21' AND left(LE001,2) <>'22') AND left(LE001,2)>'15' AND left(LE001,2)<>'41' and LE002=?MYEAR1 AND LE003<?XF","TMP")<0
*!*				WAIT WINDOWS 'DFDS4' 
*!*				RETURN
*!*			ENDIF
*!*			QC=���
*!*			DD=	BQ+QC
		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='�������ʲ�' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc1=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?CC,creatdate=getdate(),preval=?DD  where interid=?cc1")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'�������ʲ�',?CC,getdate(),?P_USERNAME,?pk)")
		ENDIF	

		************���������
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

		SQLEXEC(CON1,"SELECT interid from dashboard  where name=?xx and keydate='��������' AND odbc=?pk","TMP")
		IF RECCOUNT()=1
			cc12=interid
			SQLEXEC(CON1,"UPDATE dashboard set getval=?dd,creatdate=getdate(),preval=?cc1  where interid=?cc12")
		ELSE
			SQLDISCONNECT(CON1) 	
			ffds=maxinterid("dashboard")
			CON1=ODBC(6)
			SQLEXEC(CON1,"insert dashboard (interid,name,keydate,getval,creatdate,billname,odbc) values (?ffds,?xx,'��������',?dd,getdate(),?P_USERNAME,?pk)")
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
"inner join COPTD on pidetail.interid=COPTD.UDF56 inner join pi on pi.interid=pidetail.maininterid where pi.statusid<>'�᰸' ORDER BY 1 DESC ","tmpPIInfo1")<0  &&
     WAIT windows '?PI״̬����5???' nowait&&left join COPTC ON interid=COPTC.UDF55TC027,left join COPTD ON TC001=TD001 AND TC002=TD002AND TD008<TD009 WHERE TD016='N' AND TD008>TD009
	 SQLDISCONNECT(CON)
     RETURN
ENDIF   
*!*	SQLEXEC(CON,"update pidetail set  mf001=LEFT(TD013,4)+'.'+SUBSTRING(TD013,5,2)+'.'+RIGHT(TD013,2),outerbarcode='����:Ԥ���깤��' "+;
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
	
	IF mchk=1 AND mst='����'
		SQLEXEC(con,"select TOP 1 TC003 FROM COPTC WHERE UDF55=?df AND TC027='Y' ORDER BY 1")
		IF LEFT(TC003,1)='2' AND RECCOUNT()=1
			MT=TC003
			SQLEXEC(con,"update pi set statusid='ERP���' where interid=?df")  &&erpchk=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),
		*ELSE 	
			*SQLEXEC(con,"update pi set statusid='����' where interid=?df") 
			SQLEXEC(con,"update pidetail set outerbarcode='ERP���' where maininterid=?df")
		ENDIF	
	ENDIF 		
	*SQLEXEC(con,"update pipro set TA040 ='',TA010='',UDF56='',TC003=''  where interid=?keyid")
	
	SELECT tmpPIInfo1	
	TT1=''
	tcc=1
	IF LEFT(TD015,1)<'1'
		IF EMPTY(UDF05) OR ISNULL(UDF05)
			SQLEXEC(con,"select TOP 1 UDF56,TA010,UDF03,TA033,TA003,TA012 TA038,TA014 TA039, "+;
			"case when TA011='1' then 'δ����' WHEN TA011='2' THEN '�ѷ���' when TA011='3' THEN '������' when TA011='Y' THEN '���깤' when TA011='y' THEN 'ָ���깤' end ����״̬ "+;
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
						TT1=ALLTRIM(UDF03) +'��'
					ENDIF
					xxc='����:'+ALLTRIM(����״̬)
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
				SQLEXEC(con,"select TC003,TD012,CASE WHEN TD016='Y' THEN '�Զ�����' when TD016='y' then 'ָ������' else 'δ����' end TD,TD015 "+;
				" FROM PURTD INNER JOIN PURTC ON TC001=TD001 AND TC002=TD002 WHERE TD024=?MBILL and TD004=?mcode")
				IF RECCOUNT()>=1
					MT=TD012
					MT1=TC003
					xxc =TD
					xxc='�⹺:'+ALLTRIM(xxc)
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
			"case when TA011='1' then 'δ����' WHEN TA011='2' THEN '�ѷ���' when TA011='3' THEN '������' when TA011='Y' THEN '���깤' when TA011='y' THEN 'ָ���깤' end ����״̬ "+;
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
						TT1=ALLTRIM(UDF03) +'��'
					ENDIF
					xxc='�蹤��:'+ALLTRIM(����״̬)
					SQLEXEC(con,"update pidetail set mf001=?tt,outerbarcode=?xxc where interid=?XCC")
					SQLEXEC(con,"update pipro set UDF56=?tt1,TA038=?XTA031,TA039=?XTA032  where interid=?keyid")
					SQLEXEC(con,"update pidetailpro set UDF56=?tt1,TA038=?XTA031,TA039=?XTA032  where interid=?XCC")
					SQLEXEC(con,"update pi set statusid=?xxc where interid=?keyid")
					tcc=1
			ELSE  	
				SQLEXEC(con,"select TOP 1 TD012 TC003,CASE WHEN TD016='Y' THEN '�Զ�����' when TD016='y' then 'ָ������' else 'δ����' end TD,TD012,TD015 "+;
				" FROM PURTD INNER JOIN PURTC ON TC001=TD001 AND TC002=TD002 WHERE TD024=?MBILL AND TC014='Y' and TD004=?mcode ORDER BY 1 DESC")
				IF RECCOUNT()=1
					MT=TD012
					xxc =TD
					xxc='���⹺:'+ALLTRIM(xxc)
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
		"case when TA011='1' then 'δ����' WHEN TA011='2' THEN '�ѷ���' when TA011='3' THEN '������' when TA011='Y' THEN '���깤' when TA011='y' THEN 'ָ���깤' end ����״̬ "+;
		"FROM MOCTA WHERE TA033=?MBILL AND TA013='Y' AND TA006=?mCode")
		IF RECCOUNT()>=1
			MT=TA010
			XA003=lEFT(MT,4)+'.'+SUBSTR(MT,5,2)+'.'+RIGHT(MT,2)	
			XTA003=lEFT(TA003 ,4)+'.'+SUBSTR(TA003 ,5,2)+'.'+RIGHT(TA003 ,2)	
			XTA031=lEFT(TA038 ,4)+'.'+SUBSTR(TA038 ,5,2)+'.'+RIGHT(TA038 ,2)	
			XTA032=lEFT(TA039 ,4)+'.'+SUBSTR(TA039 ,5,2)+'.'+RIGHT(TA039 ,2)	
			SQLEXEC(con,"update pipro set TA010=?XA003 where interid=?keyid")  &&TA040 =?XTA003,
			xxc='�ع���:'+ALLTRIM(����״̬)

			TT1=ALLTRIM(ZC) +'��'
			XTA015=TA015
			SQLEXEC(con,"update pidetail set mf001=?tt,outerbarcode=?xxc  where interid=?XCC")
			SQLEXEC(con,"update pipro set UDF56=?tt1,TA038=?XTA031,TA039=?XTA032  where interid=?keyid")
			SQLEXEC(con,"update pidetailpro set UDF56=?tt1,TA038=?XTA031,TA039=?XTA032  where interid=?XCC")			
			SQLEXEC(con,"update pi set statusid=?xxc where interid=?keyid")
			tcc=3
		ELSE  	
			SQLEXEC(con,"select TOP 1 CASE WHEN TD016='Y' THEN '�Զ�����' when TD016='y' then 'ָ������' else 'δ����' end TD,TD012,TD015,TC003 "+;
			",LEFT(TD012,4)+'.'+DATENAME( Wk,CAST(TD012 AS DATETIME)) AS ZC ,"+;
			" FROM PURTD INNER JOIN PURTC ON TC001=TD001 AND TC002=TD002 WHERE TD024=?MBILL AND TC014='Y' and TD004=?mcode ORDER BY 2 DESC")
			IF RECCOUNT()=1
				MT1=ALLTRIM(ZC)+'��'
				XTA003=lEFT(TC003  ,4)+'.'+SUBSTR(TC003 ,5,2)+'.'+RIGHT(TC003 ,2)	
				MT=TD012
				xxc='���⹺:'+ALLTRIM(TD)
				SQLEXEC(con,"update pidetail set mf001=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),outerbarcode=?xxc  where interid=?XCC")
				SQLEXEC(con,"update pidetailpro set "+;
					"TA010=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),TA040 =?XTA003,UDF56=?tt1 where interid=?XCC")				
				SQLEXEC(con,"update pipro set "+;
				"TA010=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),TC003=?XTA003,UDF56=?tt1  where interid=?keyid")  &&UDF56=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),
				SQLEXEC(con,"update pi set statusid=?xxc where interid=?keyid")
				tcc=2
			ENDIF
		ENDIF 
	ENDIF 	&&ERP����
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
		WAIT WINDOW '?PI״̬����F6??'  && NOWAIT 
	ENDIF 
	IF RECCOUNT()>=1
		MT=CDATE  
		SQLEXEC(con,"update pipro set TE004=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+SUBSTRING(?MT,7,2)  where interid=?keyid")
		SQLEXEC(con,"update pidetailpro set TE004=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+SUBSTRING(?MT,7,2)  where interid=?XCC")			

	ELSE	
		*SQLEXEC(con,"update pipro set TE004='' where interid=?keyid")
	endif
	IF mclassid<='226' AND mclassid<>'220'
	
		IF SQLEXEC(CON,"SELECT CASE WHEN AA.TA100='1' then '1.δ����' when  AA.TA100='2' then '2.���ֺ���' when AA.TA100='3' then '3.�Ѻ���'   end  AS ����״̬,"+;
			"CASE WHEN EA.TA003 >'1' then CONVERT(VARCHAR(10),CAST(EA.TA003 AS DATETIME),102)  END AS ����֪ͨ����,"+;
			"case when TG003 IS NOT NULL THEN CONVERT(VARCHAR(10),CAST(TG003 AS DATETIME),102)  end ����,"+;
	     	"case when AA.TA003 IS NOT NULL THEN CONVERT(VARCHAR(10),CAST(AA.TA003 AS DATETIME),102)  END  ��Ʊ,TD008-TD009 as  SY FROM COPTD LEFT JOIN COPTH ON "+;
				" TD001=TH014 AND TD002=TH015 AND TD003=TH016 LEFT JOIN COPTG ON TH001=TG001 AND TH002=TG002 LEFT JOIN EPSTB EB ON TD001=EB.TB004 AND TD002=EB.TB005 AND TD003=EB.TB006 "+;
				"LEFT JOIN EPSTA EA ON EA.TA001=EB.TB001 AND EA.TA002=EB.TB002 LEFT JOIN ACRTB AB ON TH001=AB.TB005 and TH002=AB.TB006  and TH003=AB.TB007 "+;
				"LEFT JOIN ACRTA AA ON AA.TA001=AB.TB001 AND AA.TA002=AB.TB002 WHERE COPTD.UDF56=?XCC ORDER BY 1","TMP1")<0 &&�������
		    WAIT windows 'EPSTA ???PI״̬����?11'  && NOWAIT 
	    ENDIF 	
	    SELECT TMP1
	    IF RECCOUNT()>=1
	    	GO TOP  
			XXXX1  =����
			YY2='����֪ͨ'

			IF SY=0
				YY1='����:ȫ��'
			ELSE
				YY1='����:����'
			ENDIF	    	
			XXXX=��Ʊ
			YY=����״̬
			XXXX2  =����֪ͨ����

			IF  !EMPTY(����״̬) AND 1=2

				SQLEXEC(con,"update pi set statusid=?yy  where interid=?keyid")
			ELSE
				IF ����>='1'
					SQLEXEC(con,"update pi set statusid=?YY1 where interid=?keyid")				
				ELSE
					IF ����֪ͨ����>='1'
						SQLEXEC(con,"update pi set statusid=?YY2 where interid=?keyid")
					ELSE
						SQLEXEC(CON,"update pidetail set  mf001=LEFT(TD013,4)+'.'+SUBSTRING(TD013,5,2)+'.'+RIGHT(TD013,2),outerbarcode='����:Ԥ���깤��' "+;
						"FROM pidetail inner join COPTD on pidetail.interid=COPTD.UDF56 where interid=?XCC and (statusid='����' or statusid='')")	
			   		ENDIF &&	��Ʊ   
				ENDIF  &&����
			ENDIF  &&����
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
		WAIT windows '???d???PI״̬����????'
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
		WAIT windows '??????PI״̬����????'
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

SQLEXEC(CON,"update pidetail set outerbarcode=CASE WHEN TD016='Y' THEN '����:�Զ�����' when TD016='y' then '����:ָ������' WHEN TD008<=TD009 THEN '����:�Զ�����' end "+;
"FROM pidetail inner join COPTD on pidetail.interid=COPTD.UDF56 where TD016<>'N' ")	

IF SQLEXEC(CON,"SELECT classid,interid from pi INNER JOIN COPTC ON interid=UDF55 where statusid<>'�᰸' ","tmpPIInfo1")<0
     WAIT windows '??PI״̬����7??' &&left join COPTC ON interid=COPTC.UDF55TC027,left join COPTD ON TC001=TD001 AND TC002=TD002AND TD008<TD009 WHERE TD016='N' AND TD008>TD009
	 SQLDISCONNECT(CON)
     RETURN
ENDIF 
SELECT tmpPIInfo1
DO WHILE .NOT. EOF()
	XX=interid 
	mclassid=classid
	SQLEXEC(CON,"SELECT interid,TD008 from pidetail inner join COPTD ON interid=UDF56 where ((outerbarcode<>'����:�Զ�����' and outerbarcode<>'����:ָ������' and outerbarcode is not null "+;
	" AND outerbarcode <>'3.�Ѻ���') or outerbarcode is null or outerbarcode='') and maininterid=?XX and TD008<>0","TNO")
	IF RECCOUNT()<1
		SQLEXEC(con,"update pi set statusid='�᰸' where interid=?xx and chkid=1")
	ENDIF 
	IF mclassid>='227' OR mclassid='220'
		SQLEXEC(CON,"SELECT interid,TD008 from pidetail inner join COPTD ON interid=UDF56 where ((outerbarcode<>'����:���깤' and outerbarcode<>'����:ָ���깤') "+;
		" or outerbarcode is null or outerbarcode='') and maininterid=?XX and TD008<>0","TNO")
		IF RECCOUNT()<1
			SQLEXEC(con,"update pi set statusid='Ԥ�����깤' where interid=?xx and chkid=1")
		ENDIF 
		SQLEXEC(CON,"SELECT interid,TD008 from pidetail inner join COPTD ON interid=UDF56 where TD008>TD009 and maininterid=?XX and TD008<>0","TNO")
		IF RECCOUNT()<1
			SQLEXEC(con,"update pi set statusid='�᰸' where interid=?xx and chkid=1")
		ENDIF 
	ENDIF 		
	IF SQLEXEC(CON,"SELECT SUM(quan) quan,SUM(price*quan*pi.rate*discount/100) as cash ,SUM(case when price*pi.rate*quan*discount/100-(INVMB.MB057+INVMB.MB058+INVMB.MB059+INVMB.MB060)*quan is null then 0 else "+;
	"price*pi.rate*quan*discount/100-(INVMB.MB057+INVMB.MB058+INVMB.MB059+INVMB.MB060)*quan end) a11,"+;
	"sum(CASE WHEN MF019 IS NULL OR MF019=0 THEN 0 ELSE (MF010/MF019/3600)*quan END) gs FROM pidetail INNER JOIN INVMB ON code = MB001 "+;
	" LEFT JOIN BOMMF ON MB010=MF001 AND MB011=MF002 AND (MF005='1' OR MF005 IS NULL) inner join pi on pi.interid=pidetail.maininterid where maininterid=?xx","tmpdetaifl")<0
		brow
		WAIT windows '???d???PI״̬����????'  &&MF009/3600+
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
		m_Note='����:'+ALLTRIM(hostname)+CHR(13)+CHR(10)+'��¼�˻�:'+ALLTRIM(login)+CHR(13)+CHR(10)+'��¼ʱ��:'+TTOC(login_time)+CHR(13)+CHR(10)+'����״̬:'+ALLTRIM(cmd)+CHR(13)+CHR(10)+'����:'+ALLTRIM(net_address)+CHR(13)+CHR(10)+'NT�û���:'+ALLTRIM(TRANSFORM(username))+CHR(13)+CHR(10)+'���ӷ�ʽ:'+ALLTRIM(net_library)
		m_Note=m_Note+CHR(13)+CHR(10)+'���ֺ�ERP��صĴ������ڸ÷�������,�����Ѿ���ȫ���ƹ�˾ERP���ݿ�,���������޸�ɾ������,�Ѿ�������˾���豾�˹���Ȩ��.'

		mtitle='���˿���ERP������'
		mrev='³���;�µ���;������;�����;�ܺ�;�±�;'
		CON11=ODBC(6)
		SQLEXEC(CON11,"SELECT interid FROM rtxmessage WHERE note=?m_Note")
		SQLDISCONNECT(CON11)
		IF RECCOUNT()<1&&Cmd='AWAITING COMMAND' AND (Hostname='LENOVO-ZHOUHONG' OR Hostname='OA' OR Hostname='ERP')
			tmpkeyid=maxinterid("rtxmessage")
			TS12=odbc(6)
			SQLEXEC(TS12,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_Note,?mtitle,102)")
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
	xx3='%'+xx1+',�ؼ���:'+xx2+'%'
	TS1=odbc(5)
	IF SQLEXEC(TS1,"SELECT login_time,CAST(hostname as char(20)) as hostname,CAST(program_name as char(20)) as program_name,"+;
		"cmd,CAST(nt_username as char(20)) as username,CAST(loginame as char(15)) as login,net_library,net_address FROM master..sysprocesses "+;
		"where program_name<>'�׷�ERPϵͳ' and program_name<>'' and program_name not like 'SQLAgent%' and program_name<>'OA����'"+;
		" and hostname <>'LHB-PC' and program_name<>'�׷�ERP����' and program_name<>'Microsoft Visual Fox' and "+;
		"program_name<>'Symantec Backup Exec' and program_name<>'YiFei' and  program_name not like 'Lumigent%'  ORDER BY 1 desc ","TEffffMP")<0
		SQLDISCONNECT(TS1) && and hostname <>'TS2'
	ELSE 
		SELECT TEffffMP
		tata=RECCOUNT()
		IF tata>=1 &&and hostname <>'IBM-F830B3770FA' 
			m_Note=TTOC(DATETIME())+'����,Ԥ�ⶩ��:'+xx1+',�ؼ���:'+xx2+',�ظ�����'+CHR(13)+CHR(10)+'Ŀǰ:'+ALLTRIM(STR(tata,3))+'�����ӵ�ERP���ݿ⣬'+'��������:'+CHR(13)+CHR(10)
			GO TOP
			DO WHIL .NOT. EOF()
				m_Note=m_Note+ALLTRIM(hostname)+CHR(13)+CHR(10)+'��¼�˻�:'+ALLTRIM(login)+CHR(13)+CHR(10)+'������:'+ALLTRIM(program_name)+CHR(13)+CHR(10)+'����״̬:'+ALLTRIM(cmd)+CHR(13)+CHR(10)+'����:'+ALLTRIM(net_address)+CHR(13)+CHR(10)+'NT�û���:'+ALLTRIM(username)+CHR(13)+CHR(10)+'���ӷ�ʽ:'+ALLTRIM(net_library)
				SKIP
			ENDDO	
		ELSE 
			m_Note=TTOC(DATETIME())+'����,Ԥ�ⶩ��:'+xx1+',�ؼ���:'+xx2+',�ظ�����'+CHR(13)+CHR(10)+'û�нػ񵽶������������Ϣ���ڿ��Ѿ��ж�����!'
		ENDIF 	

		TS1=odbc(6)
		SQLEXEC(TS1,"SELECT interid FROM rtxmessage WHERE  mtitle='Ԥ�ⶩ�����ݱ��޸ĵ���������' and note like ?xx3","TEffffMP")
		SQLDISCONNECT(TS1)			
		IF RECCOUNT()<1
			mtitle='Ԥ�ⶩ�����ݱ��޸ĵ���������'
			mrev='³���;�µ���;�ܺ�;�����;�±�;������;'

			tmpkeyid=maxinterid("rtxmessage")
*!*				TS1=odbc(6)
*!*				SQLEXEC(TS1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_Note,?mtitle,0)")
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
	SQLEXEC(CON,"SELECT item from defaultval where name='COPTC��ȡʱ��'","TMP")
	SELECT tmp
	FEND=CTOT(LEFT(item,19))-36000*3
	FEND1=TTOC(CTOT(LEFT(item,19))-36000*3,1)
	SQLDISCONNECT(CON)
	CON=ODBC(5)
	
	IF sQLEXEC(con,"SELECT CAST(TB007 AS CHAR(35)) TB007,"+;
		"CASE WHEN  TB002='0' THEN '�޸�' WHEN TB002='1' THEN '����' WHEN  TB002='2' THEN 'ɾ��' WHEN TB002='A' THEN '���' WHEN TB002='B' THEN 'ȡ�����' "+;
		"WHEN TB002='3' THEN 'ִ��SQL' ELSE '��' END AS TB002,V1.MV002,TB006,V2.MV002 as MV001,TC015,MA002,TC200,MA028,TB001,TC012,COPTC.UDF55,COPTC.TC003,"+;
		"CAST(COPMA.UDF06 as char(50)) AS GDY,SUBSTRING(MB004,1,3)+LTRIM(substring(TB005,5,3)) AS TABLENAME,TB005,COPTC.UDF55  "+;
		"FROM ADMTB LEFT JOIN DSCSYS..ADMMB as ADMMB ON TB003=ADMMB.MB001 LEFT JOIN CMSMV V1 ON TB004=V1.MV001 INNER JOIN COPTC ON TB007 like RTRIM(TC001)+'-'+RTRIM(TC002)+'%'  "+;
		"LEFT JOIN COPMA ON TC004=MA001 LEFT JOIN CMSMV V2 ON TC006=V2.MV001 WHERE (LEFT(MB001,3)='COP' OR MB002='¼��ͻ�����(ҫ��70)') "+;
		"AND ((TB001='1' and TB002='1') OR TB001='2') AND TB006>?fend  and TB005 not like '%����  0��%' ORDER BY 1","TMP")<0 && AND TB002='1'  &&(MB001='COPMI06' OR MB001='COPI06') and TC005<>'512'
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
*!*				IF SH='ȡ�����'
*!*					MT=''
*!*				ENDIF	
			IF UDF55>0
				con=odbc(5)
				IF SH='ȡ�����'
					SQLEXEC(con,"update pi set statusid=?sh where interid=?XUDF55")
				ELSE
					SQLEXEC(con,"update pi set statusid='ERP���' where interid=?XUDF55")
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
				xxx1x='%'+aLLTRIM(TB007)+ALLTRIM(MV002)+'��'+TTOC(TB006)+ALLTRIM(TB002)+'%'
				CON3=ODBC(6)
				SQLEXEC(CON3,"SELECT 'X' FROM rtxmessage where note like ?xxx1x and title like '%���������%'")
				SQLDISCONNECT(CON3)
				IF RECCOUNT()<1
					SELECT TMP1

						CON=ODBC(5)
						SQLEXEC(con,"select top 1 pi.classid from pidetail inner join pi on pi.interid=pidetail.maininterid where maininterid=?MUDF55 and mf002='N' and code>='A' AND LEFT(code,1)<>'X'")
						IF RECCOUNT()=1 AND classid='223'
							IF '����'$mrev=.F.
								mrev=mrev+'����;'
							ENDIF				
						ENDIF
					SELECT TMP1
					XD=XD+ALLTRIM(STR(lu))+'.'+ALLT(MA002)+JIAOQ+','+ALLTRIM(TB007)+ALLTRIM(MV002)+'��'+TTOC(TB006)+ALLTRIM(TB002)+CHR(13)+CHR(10)
					lu=lu+1
				ENDIF 
			*ELSE	
			*	XD=XD+ALLTRIM(STR(RECNO()))+'.'+ALLT(MA002)+JIAOQ+','+ALLTRIM(TB007)+ALLTRIM(MV002)+'��'+TTOC(TB006)+ALLTRIM(TB002)+CHR(13)+CHR(10)
			*XD=XD+ALLTRIM(STR(RECNO()))+'.'+ALLT(MA002)+JIAOQ+','+ALLTRIM(TB007)+'(ע:'+ALLTRIM(TC015)+')'+ALLTRIM(MV002)+'��'+TTOC(TB006)+ALLTRIM(TB002)+CHR(13)+CHR(10)
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
*!*			IF '������'$mrev=.F.
*!*				mrev=mrev+'������;'
*!*			ENDIF
		IF ISNULL(mver)
			mver=''
		ENDIF 
*!*			IF '�Ź���'$mrev=.F.
*!*				mrev=mrev+'�Ź���;����;'
*!*			ENDIF
			*mrev=mrev+'����;�³���;'

&&		mrev=mrev&&'������Ƽ;���Ҿ�;�����;�³���;����÷;������;����Ƽ;����;��Զ��;������;����;'
		mtitle=TTOC(DATETIME())+':ERP������['+ALLTRIM(STR(lu-1))+']�ŵ��������'

		m_note=XD
		IF LEN(m_note)>10
			IF LEN(ALLTRIM(m_note))<1500
*				m_note=LEFT(m_note,2000)
				tmpkeyid=maxinterid("rtxmessage")
				keyidid1=ODBC(6)
				IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,4)")<0
					WAIT windows '?PI״̬����3???' nowait
				ENDIF 

			ELSE
				m_note1=LEFT(m_note,1500)
				m_note2=ALLTRIM(SUBSTR(m_note,1501,2000))
				tmpkeyid=maxinterid("rtxmessage")
				keyidid1=ODBC(6)
				IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note1,?mtitle,4)")<0
					WAIT windows '?PI״̬����3???' nowait
				ENDIF 
				SQLDISCONNECT(keyidid1)
				tmpkeyid=maxinterid("rtxmessage")
				keyidid1=ODBC(6)
				IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note2,'�������֪ͨ',4)")<0
					WAIT windows '?PI״̬����3???' nowait
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
	SQLEXEC(CON,"SELECT item from defaultval where name='COPTC��ȡʱ��'","TMP")
	SELECT tmp
	FEND=CTOT(LEFT(item,19))-1800
	FEND1=TTOC(CTOT(LEFT(item,19))-1800,1)
	SQLDISCONNECT(CON)
	TRY
	CON=ODBC(5)
	
	IF sQLEXEC(con,"SELECT CAST(TB007 AS CHAR(35)) TB007,"+;
		"CASE WHEN  TB002='0' THEN '�޸�' WHEN TB002='1' THEN '����' WHEN  TB002='2' THEN 'ɾ��' WHEN TB002='A' THEN '���' WHEN TB002='B' THEN 'ȡ�����' "+;
		"WHEN TB002='3' THEN 'ִ��SQL' ELSE '��' END AS TB002,V1.MV002,TB006,V2.MV002 as MV001,TC015,MA002,TC200,MA028,TB001,TC012,COPTC.UDF55,COPTC.TC003,"+;
		"CAST(COPMA.UDF06 as char(50)) AS GDY,SUBSTRING(MB004,1,3)+LTRIM(substring(TB005,5,3)) AS TABLENAME,TB005,COPTC.UDF55  "+;
		"FROM ADMTB LEFT JOIN DSCSYS..ADMMB as ADMMB ON TB003=ADMMB.MB001 LEFT JOIN CMSMV V1 ON TB004=V1.MV001 INNER JOIN COPTC ON TB007 like RTRIM(TC001)+'-'+RTRIM(TC002)+'%'  "+;
		"LEFT JOIN COPMA ON TC004=MA001 LEFT JOIN CMSMV V2 ON TC006=V2.MV001 WHERE (LEFT(MB001,3)='COP' OR MB002='¼��ͻ�����(ҫ��70)') "+;
		"AND ((TB001='1' and TB002='1') OR TB001='2') AND TB006>?fend  and TB005 not like '%����  0��%' ORDER BY TB006","TMP")<0 && AND TB002='1'  &&(MB001='COPMI06' OR MB001='COPI06') and TC005<>'512'
		SQLDISCONNECT(con)
		RETURN 
	ENDIF 

	SQLDISCONNECT(con)
	SELECT TMP
	IF RECCOUNT()>0
*!*			CON=ODBC(5)
*!*			sQLEXEC(con,"SELECT DISTINCT TO001,TO002,TO005,V3.MV002 CHKNAME,V2.MV002 SALES,TC200,TO013,TO113,MA002,COPTC.UDF55,TC001,TC002,TC012,TA006,TA034,TA015,"+;
*!*			" case when TA011='1' then 'δ����' WHEN TA011='2' THEN '�ѷ���' when TA011='3' THEN '������' when TA011='Y' THEN '���깤' when TA011='y' THEN 'ָ���깤' end STATUS "+;
*!*			"FROM  MOCTO LEFT JOIN COPTC ON TO134=RTRIM(TC001)+TC002 INNER JOIN MOCTA ON TA001=TO001 AND TA002=TO002 INNER JOIN "+;
*!*			" COPMA ON TC004=MA001 LEFT JOIN CMSMV V2 ON TC006=V2.MV001 LEFT JOIN CMSMV V3 ON TO044=V3.MV001 "+;
*!*			"WHERE MOCTO.CREATE_DATE>?FEND1 AND COPTC.UDF55>0 and TO041='Y' AND TO013>TC200 AND TO013>TO113 AND (TO123='07' OR TO123='05' OR TO123='11' OR TO123='12'  OR TO123='02') ORDER BY 1 DESC","TMPTO")
*!*			SQLDISCONNECT(CON)
		SELECT TMP
		GO BOTT
		cFEND=tTOC(TB006)
		CON=ODBC(6)
		SQLEXEC(CON,"update defaultval set item=?cFEND where name='COPTC��ȡʱ��'")
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
*!*			IF SH='ȡ�����'
*!*				MT=''
*!*			ENDIF	
		IF UDF55>0
			con=odbc(5)
			IF SH='ȡ�����'
				SQLEXEC(con,"update pi set statusid=?sh where interid=?XUDF55")
			ELSE
				SQLEXEC(con,"update pi set statusid='ERP���' where interid=?XUDF55")
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
		xxx1x='%'+ALLTRIM(TB007)+ALLTRIM(MV002)+'��'+TTOC(TB006)+ALLTRIM(TB002)+'%'
		CON3=ODBC(6)
		SQLEXEC(CON3,"SELECT interid FROM rtxmessage where note like ?xxx1x and title like '%���������%' and creatdate>?FEND")
		SQLDISCONNECT(CON3)
		IF RECCOUNT()<1
			SELECT TMP1
			IF LEFT(TB007,3)='223'
				CON=ODBC(5)
				SQLEXEC(con,"select top 1 pi.classid from pidetail inner join pi on pi.interid=pidetail.maininterid where maininterid=?MUDF55 and mf002='N' and code>='A' AND LEFT(code,1)<>'X'")
				SQLDISCONNECT(con)
				IF RECCOUNT()=1 AND classid='223'
					IF '����'$mrev=.F.
						mrev=mrev+'����;'
					ENDIF				
				ENDIF
			ENDIF 	
			SELECT TMP1
			XD=XD+ALLTRIM(STR(lu))+'.'+ALLT(MA002)+','+ALLTRIM(TB007)+ALLTRIM(MV002)+'��'+TTOC(TB006)+ALLTRIM(TB002)+CHR(13)+CHR(10)
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
*!*			IF '������'$mrev=.F.
*!*				mrev=mrev+'������;'
*!*			ENDIF
		IF ISNULL(mver)
			mver=''
		ENDIF 
*!*			IF '�Ź���'$mrev=.F.
*!*				mrev=mrev+'�Ź���;����;'
*!*			ENDIF
		*	mrev=mrev+'����;�³���;'

&&		mrev=mrev&&'������Ƽ;���Ҿ�;�����;�³���;����÷;������;����Ƽ;����;��Զ��;������;����;'
		mtitle=TTOC(DATETIME())+':ERP������['+ALLTRIM(STR(lu-1))+']�ŵ��������'

		m_note=XD
		IF LEN(m_note)>10
			IF LEN(ALLTRIM(m_note))<1500
*				m_note=LEFT(m_note,2000)
				tmpkeyid=maxinterid("rtxmessage")
				keyidid1=ODBC(6)
				IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,4)")<0
					WAIT windows '?PI״̬����3???' nowait
				ENDIF 

			ELSE
				m_note1=LEFT(m_note,1500)
				m_note2=ALLTRIM(SUBSTR(m_note,1501,2000))
				tmpkeyid=maxinterid("rtxmessage")
				keyidid1=ODBC(6)
				IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note1,?mtitle,4)")<0
					WAIT windows '?PI״̬����3???' nowait
				ENDIF 
				SQLDISCONNECT(keyidid1)
				tmpkeyid=maxinterid("rtxmessage")
				keyidid1=ODBC(6)
				IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note2,'�������֪ͨ',4)")<0
					WAIT windows '?PI״̬����3???' nowait
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
			mtitle='['+ALLTRIM(CHKNAME)+']��'+RTRIM(TO001)+ALLTRIM(TO002)+'���б��,��ȷ�ϺϷ���!'
			con3=odbc(6)
			SQLEXEC(con3,"select interid from rtxmessage where title=?mtitle")
			SQLDISCONNECT(con3)
			IF RECCOUNT()<1
				mrev=ALLTRIM(CHKNAME)+';������;������Ƽ;������;���ػ�;'+ALLTRIM(SALES)
				JIAOQ='PI:'+ALLTRIM(STR(INT(UDF55)))+'('+RTRIM(TC001)+ALLTRIM(TC002)+'),��ͬ����:'+SUBSTR(TC200,1,4)+'.'+SUBSTR(TC200,5,2)+'.'+SUBSTR(TC200,7,2)
				IF ISNULL(TC012) OR EMPTY(TC012)
					JIAOQ=JIAOQ+','
				ELSE
					JIAOQ=JIAOQ+'(Po:'+ALLTRIM(TC012)+'),'
				ENDIF 
				IF ISNULL(TO005) OR EMPTY(TO005)
					XD=JIAOQ+ALLT(MA002)+'.'+ALLTRIM(TA006)+'['+ALLT(TA034)+','+ALLTRIM(STR(INT(TA015)))+']'+ALLTRIM(STATUS)+CHR(13)+CHR(10)+'�������Ҫ���깤��[��'+SUBSTR(TO113,1,4)+'.'+SUBSTR(TO113,5,2)+'.'+SUBSTR(TO113,7,2)+'��'+SUBSTR(TO013,1,4)+'.'+SUBSTR(TO013,5,2)+'.'+SUBSTR(TO013,7,2)+']'+CHR(13)+CHR(10)
				ELSE	
					XD=JIAOQ+ALLT(MA002)+').'+ALLTRIM(TA006)+'['+ALLT(TA034)+','+ALLTRIM(STR(INT(TA015)))+']'+ALLTRIM(STATUS)+CHR(13)+CHR(10)+'�������Ҫ���깤��[��'+SUBSTR(TO113,1,4)+'.'+SUBSTR(TO113,5,2)+'.'+SUBSTR(TO113,7,2)+'��'+SUBSTR(TO013,1,4)+'.'+SUBSTR(TO013,5,2)+'.'+SUBSTR(TO013,7,2)+']'+',ע:'+ALLTRIM(TO005)+CHR(13)+CHR(10)
				ENDIF

				m_note=XD&&+'����Ҫ��������ڴ��ں�ͬ����ʱ,Ӧ��֪ͨҵ��Ա���ȱ����ͬ���ںͶ���Ҫ�������������,����ȷ�ϲ���,ȷ���������ܴβ��ᳬ���������ĵ���������.'
				IF LEN(m_note)>19
					tmpkeyid=maxinterid("rtxmessage")
					m_note=LEFT(m_note,2000)
					keyidid1=ODBC(6)
					IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,0)")<0
						WAIT windows '?PI״̬����4???' nowait
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
				mtitle='ERP����'+ALLTRIM(TB007)+TB002
			ELSE
				mtitle='ERP����'+ALLTRIM(TB007)+'(Po:'+ALLTRIM(TC012)+')'+TB002
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
					JIAOQ=',����:'+SUBSTR(TC200,1,4)+'.'+SUBSTR(TC200,5,2)+'.'+SUBSTR(TC200,7,2)
				ELSE	
					JIAOQ='('+ALLTRIM(MA028)+')'+',����:'+SUBSTR(TC200,1,4)+'.'+SUBSTR(TC200,5,2)+'.'+SUBSTR(TC200,7,2)
				ENDIF	
			ENDIF	
			IF ISNULL(TC015) OR EMPTY(TC015)
				XD=ALLT(MA002)+JIAOQ+','+ALLTRIM(TB007)+ALLTRIM(MV002)+'��'+TTOC(TB006)+ALLTRIM(TB002)+CHR(13)+CHR(10)
			ELSE	
				XD=ALLT(MA002)+JIAOQ+','+ALLTRIM(TB007)+'(ע:'+ALLTRIM(TC015)+')'+ALLTRIM(MV002)+'��'+TTOC(TB006)+ALLTRIM(TB002)+CHR(13)+CHR(10)
			ENDIF
			IF TB002='����1'
				dfd=TB007
				con=odbc(5)
				SQLEXEC(CON,"SELECT TD003,TD004,TD005,TD008,TD015,TD202,TD203,UDF05 FROM COPTD WHERE RTRIM(TD001)+'-'+TD002=?DFD ORDER BY 1","DDS")
				SQLDISCONNECT(CON)
				SELECT DDS
				IF RECCOUNT()>10
					FDD='....����:'+ALLTRIM(STR(RECCOUNT()))+'�ֲ�Ʒ.'
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
						XD=XD+SUBS(TD003,3,2)+'.'+ALLTRIM(TD004)+'('+ALLTRIM(TD005)+'):'+ALLTRIM(STR(INT(TD008)))+'ֻ,���:'+ALLTRIM(STR(INT(TD202)))+'-'+ALLTRIM(STR(INT(TD203)))
					ELSE 	
						XD=XD+SUBS(TD003,3,2)+'.'+ALLTRIM(TD004)+'('+ALLTRIM(TD005)+'):'+ALLTRIM(STR(INT(TD008)))+'ֻ'
					ENDIF 
					IF !EMPTY(TD015) AND !isnull(TD015)
						xd=xd+',��Ԥ��:'+ALLTRIM(TD015)
					ENDIF	
					IF !EMPTY(UDF05) AND !ISNULL(UDF05)
						xd=xd+',����:'+ALLTRIM(UDF05)
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
*!*					IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,0)")<0
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

		SQLEXEC(CON,"update fordashboad3 set LEIBIE='',GYS='',MAKE='',MQNAME=(CASE WHEN MQ.MQ002 IS NULL THEN '����Դ' ELSE MQ.MQ002 END) ,"+;
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
					SQLEXEC(CON,"update fordashboad3 set GYS=?TT,LEIBIE='�⹺',MAKE=?TT1 where rtrim(COH)+TB002=?mcoh")
				ELSE	
					SQLEXEC(CON,"SELECT MD001,MD002 FROM MOCTA INNER JOIN CMSMD ON TA021=MD001 WHERE TA033=?T4 AND TA006=?T5","TMPX")
					IF RECCOUNT()>0 AND !ISNULL(MD002)
						TT=MD002
						TT1=MD001
						SQLEXEC(CON,"update fordashboad3 set GYS=?TT,LEIBIE='�Բ�',MAKE=?TT1 where rtrim(COH)+TB002=?mcoh")
					ELSE	
						SQLEXEC(CON,"update fordashboad3 set GYS='',MAKE='',LEIBIE='�����' where rtrim(COH)+TB002=?mcoh")
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
						SQLEXEC(CON,"update fordashboad3 set GYS=?TT,LEIBIE='�⹺Ԥ��',MAKE=?TT1 where rtrim(COH)+TB002=?mcoh")
					ELSE	
						SQLEXEC(CON,"SELECT MD001,MD002 FROM MOCTA INNER JOIN CMSMD ON TA021=MD001 WHERE TA033=?T1 AND TA006=?T3","TMPX")
						IF RECCOUNT()>0 AND !ISNULL(MD002)
							TT=MD002
							TT1=MD001
							SQLEXEC(CON,"update fordashboad3 set GYS=?TT,LEIBIE='�Բ�Ԥ��',MAKE=?TT1 where rtrim(COH)+TB002=?mcoh")
						ELSE	
							SQLEXEC(CON,"update fordashboad3 set LEIBIE='�����Բ�Ԥ��' where rtrim(COH)+TB002=?mcoh")
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
						SQLEXEC(CON,"update fordashboad3 set GYS=?TT,LEIBIE='�⹺����',MAKE=?TT1 where rtrim(COH)+TB002=?mcoh")
					ELSE	
						SELECT TMPY
						
						T1=SUBSTR(UDF05,1,3)+STREXTRACT(UDF05,',',',')
						SQLEXEC(CON,"SELECT MD001,MD002 FROM MOCTA INNER JOIN CMSMD ON TA021=MD001 WHERE TA033=?T1 AND TA006=?T3","TMPX")
						IF RECCOUNT()>0 AND !ISNULL(MD002)
							TT=MD002
							TT1=MD001
							SQLEXEC(CON,"update fordashboad3 set GYS=?TT,LEIBIE='�Բ�����',MAKE=?TT1 where rtrim(COH)+TB002=?mcoh")
						ELSE	
							SQLEXEC(CON,"update fordashboad3 set LEIBIE='�����Բ�����' where rtrim(COH)+TB002=?mcoh")
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
		IF sqlexec(con,"SELECT Sum(CASE WHEN SUBSTRING(TB002,1,6)= ?mmonth THEN 0-ACTTB.TB004*ACTTB.TB007 ELSE 0 END) ����,"+;
			"Sum(CASE WHEN SUBSTRING(TB002,1,4)= ?mYEAR THEN 0-ACTTB.TB004*ACTTB.TB007 ELSE 0 END) ����,"+;
			"Sum(CASE WHEN SUBSTRING(TB002,1,6)= ?mmonth1 THEN 0-ACTTB.TB004*ACTTB.TB007 ELSE 0 END) ȥ��,"+;
			"Sum(CASE WHEN SUBSTRING(TB002,1,4)= ?mYEAR1 and SUBSTRING(TB002,1,6)<= ?mmonth1 THEN 0-ACTTB.TB004*ACTTB.TB007 ELSE 0 END) ȥ�� "+;
			"FROM ACTMA a LEFT OUTER JOIN ACTTB ON ACTTB.TB005 = a.MA001 left join ACTMA b on left(TB005,1) =b.MA001 "+;
			"WHERE (ACTTB.TB001='920') and (a.MA022<5) and TB005 like '5111%'","TmpGroupData1")<0	
			WAIT WINDOWS 'KS' 
		ENDIF	 
		t1=����
		t2=����
		t3=ȥ��
		t4=ȥ�� 
		T1=0
		T2=0
		T3=0
		T4=0
	SQLEXEC(CON,"SELECT MAX(TB002) AS TB002 FROM ACTTB "+;
	"WHERE ACTTB.TB001='920' and left(TB005,3) in ('510','511','512') and ACTTB.TB016='Y' ","TMP")
	GZR=LEFT(TB002 ,6)
	IF sqlexec(con,"SELECT  SUM(CASE WHEN SUBSTRING(TA003,1,6)= ?mmonth THEN TB019 ELSE 0 END) AS  ����,SUM(  TB019 ) AS  ������,"+;
			"SUM(CASE WHEN TA001='661' AND SUBSTRING(TA003,1,6)= ?mmonth THEN  TB019*0.04 else 0 END)  AS �µֿ�,"+;
			"SUM(CASE WHEN TA001<>'661' THEN 0 ELSE TB019*0.04 END)  AS ��ֿ�,"+;
	       "SUM(CASE WHEN  SUBSTRING(TA003,1,6)= ?mmonth THEN BZCB ELSE 0 END) AS ʵ�ʳɱ�,"+;
	       "SUM( XHCB) AS ��ɱ� "+;
	 		" FROM LHB where SUBSTRING(TA003,1,4)= ?mYEAR","TmpGroupData1")<0
		WAIT WINDOWS 'DFDS' nowait
		RETURN
	ENDIF&&
	FFFF1=ALLTRIM(STR(INT(����/10000)))
	IF ISNULL(ffff1)
		ffff1=0
	ENDIF
	FFFF2=ALLTRIM(STR(INT(������/10000)))
	xxx=������
	dddd=����
	IF ISNULL(DDDD)
		DDDD=0
	ENDIF
	*FFFF3=ALLTRIM(STR(INT((����-�µֿ�-ʵ�ʳɱ�)/10000)))+'('+allt(STR(INT((����-�µֿ�-ʵ�ʳɱ�)/����*100)))+'%)'
	FFFF3=ALLTRIM(STR(INT((����*0.35)/10000)))
	sqlexec(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '���·���' FROM ACTTB WHERE ACTTB.TB001<>'920' and left(TB005,1) in('5')"+;
	" and left(TB005,3) in('513','514','515') and ACTTB.TB016='Y' and left(TB002,6) =?mmonth","tm")	
	IF RECCOUNT()=1 AND !ISNULL(���·���)
		fyfy=���·���
	ELSE
		fyfy=0
	ENDIF	
	sqlexec(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '���·���' FROM ACTTB WHERE ACTTB.TB001<>'920' and left(TB005,1) in('5')"+;
	" and left(TB005,3) in('513','514','515') and ACTTB.TB016='Y' and left(TB002,4) =?myear","tm")	
	IF RECCOUNT()=1 AND !ISNULL(���·���)
		fyfyy=���·���
	ELSE
		fyfyy=0
	ENDIF	
	m��������=INT((dddd*0.35-fyfy)/10000)
*!*		IF sqlexec(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '���'	FROM ACTMA a LEFT JOIN ACTTB ON ACTTB.TB005 = a.MA001 left join ACTMA b on left(TB005,1) =b.MA001 "+;
*!*		"WHERE (ACTTB.TB001<>'920') and (a.MA022<5) and (TB005 like '513%' or TB005 like '514%' or TB005 like '515%' ) and  left(ACTTB.TB002,4)  =?myear","TmpGroupData1")<0
*!*			WAIT WINDOWS 'DFfweewrwerDS' 
*!*			RETURN
*!*		ENDIF&&
*!*		XXX2=���
*!*		IF sqlexec(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '���' FROM ACTMA a LEFT JOIN ACTTB ON ACTTB.TB005 = a.MA001 left join ACTMA b on left(TB005,1) =b.MA001 "+;
*!*		"WHERE ACTTB.TB001='920' and a.MA022<5 and (TB005 like '510%' or TB005 like '511%' or TB005 like '512%') and left(TB002,4) =?myear","TMP")<0
*!*			WAIT WINDOWS '���' 
*!*			RETURN
*!*		ENDIF&&

	
	SQLEXEC(CON,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '����ë��' FROM ACTTB "+;
	"WHERE ACTTB.TB001='920' and left(TB005,3) in ('510','511','512') and ACTTB.TB016='Y' and left(TB002,4) =?myear ","TMP")
*!*		xxx1=���+dddd
*!*		m��������=INT((XXX2-XXX1)/10000)
	ffff4=ALLTRIM(STR(INT(((����ë��)/10000))))+'('+allt(STR(INT((����ë��)/(XXX-dddd+t2)*100)))+'%)'

	IF sqlexec(con,"SELECT  SUM(CASE WHEN SUBSTRING(TA003,1,6)= ?mmonth1  THEN TB019 ELSE 0 END) AS  ����,SUM(  TB019 ) AS  ������,"+;
			"SUM(CASE WHEN TA001='661' AND SUBSTRING(TA003,1,6)= ?mmonth1   THEN  TB019*0.04 else 0 END)  AS �µֿ�,"+;
			"SUM(CASE WHEN TA001<>'661' THEN 0 ELSE TB019*0.04 END)  AS ��ֿ�,"+;
	       "SUM(CASE WHEN  SUBSTRING(TA003,1,6)= ?mmonth1  THEN BZCB ELSE 0 END) AS ʵ�ʳɱ�,"+;
	       "SUM( XHCB) AS ��ɱ� "+;
	 		" FROM LHB where  left(TA003,4) =?myear1","TmpGroupData1")<0  &&and SUBSTRING(TA003,1,8)<= ?xxxx1
		WAIT WINDOWS 'DFDS' nowait
		RETURN
	ENDIF&&
	FFFF11=ALLTRIM(STR(INT(����/10000)))
	IF ISNULL(ffff11)
		ffff11=0
	ENDIF
	FFFF21=ALLTRIM(STR(INT(������/10000)))
	xxx1=������
	dddd1=����
	IF ISNULL(dddd1)
		dddd1=0
	ENDIF
	*FFFF3=ALLTRIM(STR(INT((����-�µֿ�-ʵ�ʳɱ�)/10000)))+'('+allt(STR(INT((����-�µֿ�-ʵ�ʳɱ�)/����*100)))+'%)'
	FFFF3=FFFF3+'/'+ALLTRIM(STR(INT((����*0.35)/10000)))
	sqlexec(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '���·���' FROM ACTTB WHERE ACTTB.TB001<>'920' and left(TB005,1) in('5')"+;
	" and left(TB005,3) in('513','514','515') and ACTTB.TB016='Y' and left(TB002,8) <=?XXXX1 and left(TB002,6) =?mmonth1 and left(TB002,8) <=?xxxx1","tm")	
	IF RECCOUNT()=1 AND !ISNULL(���·���)
		fyfy1=���·���
	ELSE
		fyfy1=0
	ENDIF	
	sqlexec(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '���·���' FROM ACTTB WHERE ACTTB.TB001<>'920' and left(TB005,1) in('5')"+;
	" and left(TB005,3) in('513','514','515') and ACTTB.TB016='Y' and left(TB002,4) =?myear1  ","tm")	
	IF RECCOUNT()=1 AND !ISNULL(���·���)
		fyfyy1=���·���
	ELSE
		fyfyy1=0
	ENDIF	
	m��������1=INT((dddd1*0.35-fyfy1-t3)/10000)
*!*		IF sqlexec(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '���'	FROM ACTMA a LEFT JOIN ACTTB ON ACTTB.TB005 = a.MA001 left join ACTMA b on left(TB005,1) =b.MA001 "+;
*!*		"WHERE (ACTTB.TB001<>'920') and (a.MA022<5) and (TB005 like '513%' or TB005 like '514%' or TB005 like '515%' ) and  left(ACTTB.TB002,4)  =?myear","TmpGroupData1")<0
*!*			WAIT WINDOWS 'DFfweewrwerDS' 
*!*			RETURN
*!*		ENDIF&&
*!*		XXX2=���
*!*		IF sqlexec(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '���' FROM ACTMA a LEFT JOIN ACTTB ON ACTTB.TB005 = a.MA001 left join ACTMA b on left(TB005,1) =b.MA001 "+;
*!*		"WHERE ACTTB.TB001='920' and a.MA022<5 and (TB005 like '510%' or TB005 like '511%' or TB005 like '512%') and left(TB002,4) =?myear","TMP")<0
*!*			WAIT WINDOWS '���' 
*!*			RETURN
*!*		ENDIF&&
	SQLEXEC(CON,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '����ë��' FROM ACTTB "+;
	"WHERE ACTTB.TB001='920' and left(TB005,3) in ('510','511','512') and ACTTB.TB016='Y' and left(TB002,4) =?myear1 and left(TB002,6) <=?mmonth1","TMP")
*!*		xxx1=���+dddd
*!*		m��������=INT((XXX2-XXX1)/10000)
	ffff4=ffff4+'/'+ALLTRIM(STR(INT(((����ë��-T2)/10000))))+'('+allt(STR(INT((����ë��-t4)/(XXX1)*100)))+'%)'	
	*FFFF4=ALLTRIM(STR(INT((������-��ֿ�-��ɱ�)/10000)))+'('+allt(STR(INT((������-��ֿ�-��ɱ�)/������*100)))+'%)'
SQLEXEC(CON,"DROP VIEW LHB")
SQLEXEC(CON,"select SUM( (TK033+TK035+TK036-TK038+TK041)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end) ) as 'Ԥ�����' "+;
"from ACRTK left join CMSMQ on MQ001=TK001 where TK020='Y' and ACRTK.TK030 <> '3' ","tmp")
xxx=Ԥ�����
IF ISNULL(xxx)
xxx=0
ENDIF
SQLEXEC(CON,"CREATE VIEW LHB AS SELECT LB005 AS �ͻ�, SUBSTRING(LB020,1,6) AS ����, (CASE WHEN LB001 IN ('0', '1', '2') THEN (LB014 + LB019) ELSE 0.0 END) AS ����Ӧ��, "+;
"(CASE WHEN LB001 IN ('3', '4', '5') THEN LB014 ELSE 0.0 END) AS ����ʵ�� FROM ACRLB AS ACRLB WHERE (1 = 1 AND LB001 NOT IN ('B', 'C')) UNION ALL "+;
"SELECT LC006 AS KHID, LC029 AS DAY,  0.0 AS BBYSJE, (CASE WHEN MQ003 IN ('61', '6A', '66', '6B') "+;
" THEN LC018 ELSE 0.0 END) AS BBSSJE "+;
" FROM ACRLC  LEFT JOIN CMSMQ AS CMSMQ ON MQ001 = LC003 WHERE (1 = 1 AND (Round(LC018, 3) <> 0.0 OR Round(LC017, 3) <> 0.0)) UNION ALL "+;
"SELECT LC006 AS KHID,  SUBSTRING(LC029,1,6) AS DAY, 0.0 AS BBYSJE,  LC019 AS BBSSJE  "+;
" FROM ACRLC WHERE (1 = 1 AND Round(LC019, 3) <> 0.0 ) UNION ALL "+;
"SELECT LE005 KHID,LD003 DAY,CASE WHEN LE004='3'  THEN 0- LE014 ELSE LE014 END THJE,0 AS SS FROM ACRLD LEFT JOIN ACRLE ON LD001=LE001 AND LD002=LE002")

IF SQLEXEC(CON,"SELECT SUM(TB004*TB007)  AS ������� "+;
      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
      " WHERE TA010='Y' AND (LEFT(TB005 ,4)='1101' OR LEFT(TB005 ,4)='1111') ORDER BY 1 ","TmpBank1")<0
		WAIT WINDOWS '������� ' nowait
		RETURN
ENDIF&&
xx2=������� 
m���=INT((17759846+xx2)/10000)
IF ISNULL(xx2)
xx2=0
ENDIF
IF ISNULL(m���)
m���=0
ENDIF

IF SQLEXEC(CON,"SELECT SUM(TB004*TB007)  AS ������� "+;
      "  FROM ACTTB LEFT JOIN ACTTA  ON ACTTA.TA001 = ACTTB.TB001 AND ACTTA.TA002 = ACTTB.TB002  "+;
      " WHERE TA010='Y' AND (LEFT(TB005 ,4)='1101' OR LEFT(TB005 ,4)='1111') and LEFT(TA014,8)<=?XXXX1  ORDER BY 1 ","TmpBank1")<0
		WAIT WINDOWS '������� ' nowait
		RETURN
ENDIF&&
xx21=������� 
m���1=INT((17759846+xx21)/10000)
IF ISNULL(xx21)
xx21=0
ENDIF
IF ISNULL(m���1)
m���1=0
ENDIF
*!*	SQLEXEC(con,"SELECT SUM(CASE WHEN SUBSTRING(TB002,1,6)=?MMONTH THEN TB004 * TB007 ELSE 0 END) AS '�½��',SUM(TB004 * TB007) �ܽ�� "+;
*!*	"FROM  ACTMA AS a LEFT JOIN  ACTTB ON ACTTB.TB005 = a.MA001  "+;
*!*	" WHERE (ACTTB.TB001 <> '920') AND (a.MA022 < 5) AND (ACTTB.TB005 LIKE '5%') AND SUBSTRING(TB002,1,4)=?MYEAR","TMP")&&����

SQLEXEC(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '���꾻��' FROM ACTTB WHERE ACTTB.TB001='920' and left(TB005,1) in('5') and ACTTB.TB016='Y'  and left(TB002,4) =?myear","tmp")

*!*	*m��������= INT(�½��/10000)
M��������= INT(���꾻��/10000)
SQLEXEC(con,"SELECT Sum(ACTTB.TB004*ACTTB.TB007) AS '���꾻��' FROM ACTTB WHERE ACTTB.TB001='920' and left(TB005,1) in('5') "+;
"and ACTTB.TB016='Y'  and left(TB002,4) =?myear1  and left(TB002,8) <=?XXXX1 ","tmp")

*!*	*m��������= INT(�½��/10000)
M��������1= INT(���꾻��/10000)

SQLEXEC(CON,"select SUM((TA041+TA042-TA098+TA059)*(case when TA079=1 then 1 else -1 end)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end)) as 'Ӧ�����' "+;
"from ACRTA left join CMSMQ on MQ001=TA001 where TA025='Y' and TA029+TA030 <>ACRTA.TA031","tmp")
cdddd=Ӧ�����
IF ISNULL(cdddd)
	cdddd=0
ENDIF	
DATEID=DATE()
SQLEXEC(CON,"select SUM(TA041+TA042+TA059-TA098) AS RMB,SUM( (TA041+TA042+TA059-TA098)*DATEDIFF( DAY,CAST(TA020 AS DATETIME), ?DATEID)) AS TRMB "+;
"FROM ACRTA AS ACRTA  LEFT JOIN CMSMQ AS CMSMQ ON MQ001=TA001  "+;
"WHERE  ( MQ003 IN ('61','6A','66')  AND TA025='Y' AND TA100<>'3'"+;
"  AND (TA020<?CDATE OR TA020 = '')) ","TMPYD")
IF SQLEXEC(CON,"select "+;
	"SUM(CASE WHEN ����=?MMONTH THEN ����Ӧ�� ELSE 0.0 END) as ����Ӧ��,SUM( CASE WHEN SUBSTRING(����,1,4)=?MYEAR THEN ����Ӧ�� ELSE 0 END) as ����Ӧ��, "+;
	"SUM(CASE WHEN ����=?MMONTH  THEN ����ʵ�� ELSE 0.0 END) as ����ʵ��, SUM( CASE WHEN SUBSTRING(����,1,4)=?MYEAR THEN ����ʵ�� ELSE 0 END) as ����ʵ��, "+;
	"sum(CASE WHEN ����<='999999'  THEN ����Ӧ��-����ʵ�� ELSE 0 END) AS ��ĩӦ�� ,0 ����δ��   "+;
	" FROM LHB LHB  "+;
	"","TmpQC")<0
	WAIT windows '���������' nowait
ENDIF 	
YSK1='3.����Ӧ�գ�'+ALLTRIM(STR(INT(����Ӧ��/10000)))+'�����꣺'+ALLTRIM(STR(INT(����Ӧ��/10000)))+'��δ�գ�'+ALLTRIM(STR(INT((cdddd)/10000)))+'��Ԥ����'+ALLTRIM(STR(INT((xxx)/10000)))
YSK2='������ʵ�գ�'+ALLTRIM(STR(INT(����ʵ��/10000)))+'�����꣺'+ALLTRIM(STR(INT(����ʵ��/10000)))
*!*	SELECT TMPYD
*!*	IF RECCOUNT()=1 AND !ISNULL(RMB)
*!*		YSK2=''
*!*		*YSK2+'�������˿'+ALLTRIM(STR(INT(RMB/10000)))+'��*������'+ALLTRIM(STR(INT(TRMB/10000)))
*!*	ENDIF
*!*	IF SQLEXEC(CON,"select SUM(CASE WHEN TK003=?mmonth  AND CMSMQ.MQ003='6D' THEN TK033+TK036+TK035+TK041  ELSE 0 END) AS �����˿�, "+;
*!*	"SUM(CASE WHEN substring(TK003,1,4)=?myear  AND CMSMQ.MQ003='6D' THEN TK033+TK036+TK035+TK041  ELSE 0 END) AS �˿��ܶ�   "+;
*!*	" FROM ACRTK ACRTK  LEFT JOIN CMSMQ AS CMSMQ ON MQ001=TK001   "+;
*!*	  "WHERE ( TK020='Y' )  " ,"TmpCustom1")<0
*!*	  WAIT windows '�տ'
*!*	ENDIF   
*!*	IF RECCOUNT()=1 AND !ISNULL(�����˿�)
*!*	YSK2=YSK2+'�������˿'+ALLTRIM(STR(INT(�����˿�/10000)))+'�����꣺'+ALLTRIM(STR(INT(�˿��ܶ� /10000)))
*!*	ENDIF 
SQLEXEC(CON,"DROP VIEW LHB")

SQLEXEC(CON,"CREATE VIEW LHB AS SELECT LB005 AS ��Ӧ��,SUBSTRING(LB020,1,6) AS ����,"+;
	"(Case when LB001 in ('0','1','2') then LB014 when (LB001='C' AND MQ003 IN ('71','7A','7B','7F')) then LB019  else 0.0 end) as ����Ӧ��,"+;
	"(Case when LB001 in ('3','4','5') then LB014 when (LB001='C' AND MQ003='7C') then LB019 else 0.0 end) as ����ʵ�� "+;
 	"From ACPLB  LEFT JOIN CMSMQ AS CMSMQ ON MQ001=LB009  where LB027='1' union all "+;
	"SELECT LC006,SUBSTRING(LC029,1,6) LC029,(Case when MQ003 IN ('71','7A','7F') then (-1)*LC018 else 0 end) as BBYSJE, "+;
 	" (Case when LC019 <> 0.0 then LC019 else 0.0 end) as BBSSJE "+;
 	" FROM ACPLC LEFT JOIN CMSMQ AS CMSMQ ON LC003=MQ001 where LC036='1' and (Round(LC019,3)<>0.0 or Round(LC018,3)<>0.0 or Round(LC017,3)<>0.0) UNION ALL "+;
	"SELECT LE005 KHID,LD010 DAY,LE014 THJE,0 SS FROM ACPLD LEFT JOIN ACPLE ON LD001=LE001 AND LD002=LE002")
SQLEXEC(CON,"select sum((TA037+TA038-TA085+TA051)*(case when TA079=1 then 1 else -1 end)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end)) as 'Ӧ�����' "+;
"from ACPTA left join CMSMQ on MQ001=TA001 where TA024='Y' and TA028+TA029 <>ACPTA.TA030","tmp")

dddc=Ӧ�����
IF ISNULL(dddc)
	dddc=0
ENDIF
SQLEXEC(CON,"select SUM((TK031+TK033+TK034-TK036+TK039)*(case when CMSMQ.MQ003 like '_D' then -1 else 1 end)) as 'Ԥ�����' "+;
"from ACPTK left join CMSMQ on MQ001=TK001 where TK020='Y' and ACPTK.TK028 <> '3'","TmpQC")
yyy=Ԥ�����
IF SQLEXEC(CON,"select   "+;
	"SUM(CASE WHEN ����=?MMONTH THEN ����Ӧ�� ELSE 0.0 END) as ����Ӧ��, SUM( CASE WHEN SUBSTRING(����,1,4)=?MYEAR THEN ����Ӧ�� ELSE 0 END) as ȫ��Ӧ��,"+;
	"SUM(CASE WHEN ����=?MMONTH THEN ����ʵ�� ELSE 0.0 END) as ����ʵ��, SUM( CASE WHEN SUBSTRING(����,1,4)=?MYEAR THEN ����ʵ�� ELSE 0 END) as ȫ��ʵ��,"+;
	"sum(CASE WHEN ����<=?MMONTH THEN ����Ӧ��-����ʵ�� ELSE 0 END) AS ��ĩӦ�� ,0 ����δ�� "+;
	" FROM LHB","TmpQC")<0
	WAIT windows 'yf' nowait
ENDIF 	
SQLEXEC(CON,"select SUM(TA037 + TA038 + TA051 - TA085) ����δ����� "+;
"FROM ACPTA ACPTA LEFT JOIN  CMSMQ CMSMQ ON MQ001 = TA001  "+;
" WHERE TA024 = 'Y' AND TA087 <> '3' AND TA008 = 'RMB' AND (TA019 < ?CDATE)   UNION ALL "+;
"select   SUM( TI016 + TI032 - TI018) ����δ����� "+;
"FROM ACPTI ACPTI LEFT JOIN  CMSMQ CMSMQ ON MQ001 = TI001   "+;
"WHERE (TI013 = 'Y' AND TI029 <> '3' AND TI007 = 'RMB' AND (TI010 <?CDATE))","Tmpwf")
IF RECCOUNT()>0 AND !ISNULL(����δ�����)
	XXX=����δ�����
	SELECT TMPQC
	REPLACE ����δ�� WITH XXX
ENDIF

SELECT TMPQC
YFK1='4.����Ӧ����'+ALLTRIM(STR(INT(����Ӧ��/10000)))+'�����꣺'+ALLTRIM(STR(INT(ȫ��Ӧ��/10000)))+'��δ����'+ALLTRIM(STR(INT((dddc)/10000)))+'��Ԥ����'+ALLTRIM(STR(INT((yyy)/10000)))
YFK2='������ʵ����'+ALLTRIM(STR(INT(����ʵ��/10000)))+'�����꣺'+ALLTRIM(STR(INT(ȫ��ʵ��/10000)))+'������δ����'+ALLTRIM(STR(INT(����δ��/10000)))

if SQLEXEC(CON,"select sum(case when   TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009) ����,"+;
	"SUM(CASE WHEN    TD015<>'' THEN TD012*TC009 ELSE 0 END) as ����"+;
	" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,6)=?MMONTH  and not (TC004='90574019' and TC003>'20120901')","TmpQ2C") <0
	WAIT windows '???' nowait
endif	
A1=���� 
A3=���� 
IF ISNULL(A1)
A1=0
ENDIF
IF ISNULL(A3)
A3=0
ENDIF
if SQLEXEC(CON,"select sum(case when   TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009) ����,"+;
	"SUM(CASE WHEN    TD015<>'' THEN TD012*TC009 ELSE 0 END) as ����"+;
	" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,6)=?MMONTH1 and LEFT(TC003,8)<=?XXXX1 and not (TC004='90574019' and TC003>'20120901')","TmpQ2C") <0
	WAIT windows '???' nowait
endif	
A11=���� 
A31=���� 
IF ISNULL(A11)
A11=0
ENDIF
IF ISNULL(A31)
A31=0
ENDIF
 SQLEXEC(CON,"select sum(case when   TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009) ȫ�� ,"+;
	"SUM(CASE WHEN    TD015<>'' THEN TD012*TC009 ELSE 0 END) as ���� "+;
	" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,4)=?Myear  and not (TC004='90574019' and TC003>'20120901')","TmpQ2C") 
A2=ȫ�� 
A4=���� 
IF ISNULL(A2)
A2=0
ENDIF
IF ISNULL(A4)
A4=0
ENDIF
 SQLEXEC(CON,"select sum(case when   TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009) ȫ�� ,"+;
	"SUM(CASE WHEN    TD015<>'' THEN TD012*TC009 ELSE 0 END) as ���� "+;
	" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,4)=?Myear1 "+;
	" and LEFT(TC003,8)<=?XXXX1 and not (TC004='90574019' and TC003>'20120901')","TmpQ2C") 
A21=ȫ�� 
A41=���� 
IF ISNULL(A21)
A21=0
ENDIF
IF ISNULL(A41)
A41=0
ENDIF
CON1=odbc(15)
 SQLEXEC(CON1,"select sum(case when   TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009) ����,"+;
	"SUM(CASE WHEN    TD015<>'' THEN TD012*TC009 ELSE 0 END) as ����"+;
	" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,6)=?MMONTH  and not (TC004='90574019' and TC003>'20120901')","TmpQ2C") 
IF RECCOUNT()=1 AND !ISNULL(����)
A1=����+A1
A3=����+A3
ENDIF
 SQLEXEC(CON1,"select sum(case when   TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009) ȫ�� ,"+;
	"SUM(CASE WHEN    TD015<>'' THEN TD012*TC009 ELSE 0 END) as ���� "+;
	" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,4)=?Myear  and not (TC004='90574019' and TC003>'20120901')","TmpQ2C") 
A2=ȫ��+A2
A4=����+A4
 SQLEXEC(CON1,"select sum(case when   TD016='y' then COPTD.TD009*COPTD.TD011*COPTD.TD026 else TD012 end*TC009) ȫ�� ,"+;
	"SUM(CASE WHEN    TD015<>'' THEN TD012*TC009 ELSE 0 END) as ���� "+;
	" FROM COPTD INNER JOIN COPTC ON TD001=TC001 AND TD002=TC002 WHERE TD021='Y' and LEFT(TC003,4)=?Myear  and not (TC004='90574019' and TC003>'20120901')","TmpQ2C") 
A21=ȫ��+A21
A41=����+A41

IF RECCOUNT()=1 AND !ISNULL(A1)  &&'�����б��µ���Ԥ���棺'+ALLTRIM(STR(A3/10000))+'���������Ԥ���棺'+ALLTRIM(STR(A4/10000))+
	DD1='5.���½ӵ���'+ALLTRIM(str(A1/10000))+'/'+ALLTRIM(str(A11/10000))+'�����꣺'+ALLTRIM(str(A2/10000))+'/'+ALLTRIM(str(A21/10000))+'���������۶'+ffff1+'/'+ffff11+'�����꣺'+ffff2+'/'+ffff21
ELSE
	DD1=''
ENDIF
con2=odbc(11)
SQLEXEC(con2,"select SUM(plancash) cash from budget b inner join budgetdetail d on b.interid=d.maininterid where b.dateid=?myear and b.classid='���'","tt")
ysn=cash
SQLEXEC(con2,"select SUM(plancash) cash from budget b inner join budgetdetail d on b.interid=d.maininterid where b.dateid=?MMONTH and b.classid='�¶�'","tt")
ysm=cash

SQLDISCONNECT(CON2)
SQLDISCONNECT(CON1)
SQLDISCONNECT(con)
*+'(����Ԥ�㣺'+ALLTRIM(STR(INT(ysn/10000)))+')'*+'(����Ԥ�㣺'+ALLTRIM(STR(INT(ysm/10000)))+')'
mtitle=DTOC(DATE())+'�ղ������(��Ԫ)'
m_note='1.��������Ԥ��ë����'+FFFF3+'������ʵ��ë����'+FFFF4+'������Ԥ�ƾ�����'+ALLTRIM(str(m��������))+'/'+ALLTRIM(str(m��������1))+'�����꣺'+ALLTRIM(str(m��������))+'/'+ALLTRIM(str(m��������1))+CHR(13)+CHR(10)
m_note=m_note+'2.���·������ã�'+ALLTRIM(STR(INT(fyfy/10000)))+'/'+ALLTRIM(STR(INT(fyfy1/10000)))+'�����꣺'+ALLTRIM(STR(INT(fyfyy/10000)))+'/'+ALLTRIM(STR(INT(fyfyy1/10000)))+'���ֽ��'+ALLTRIM(STR(m���))+'/'+ALLTRIM(STR(m���1))+CHR(13)+CHR(10)
m_note=m_note+YSK1+YSK2+CHR(13)+CHR(10)+YFK1+YFK2+CHR(13)+CHR(10)+DD1
mrev='ceo'
keyidid1=ODBC(6)
tmpkeyid=maxinterid("rtxmessage")
IF SQLEXEC(keyidid1,"insert rtxmessage (interid,toman,billname,creatdate,note,title,sysid) values (?tmpkeyid,?mrev,'³���',getdate(),?m_note,?mtitle,2)")<0
	WAIT windows '????' nowait
ENDIF 
SQLDISCONNECT(keyidid1)
ENDPROC 

PROCEDURE quotation
HR_DEPT='��Ϣ��'
P_UserName='���ֻ�����'
CON=ODBC(5)
IF SQLEXEC(CON,"SELECT  interid,name ��Ʒ����,spec as ���,"+;
	"pricenote,currency ����, exchangerate ����,price �۸�,cost �ɱ�,case when price=0 then 0 else (price*exchangerate*discount/100-cost)/(price*exchangerate*discount/100)*100 end ë����,note ��ע,tosupplyid,supplyid,supplyname,"+;
	" NA003,taxrate ˰��,convert(char(10),CAST(begindate as datetime),102) MA021 ,convert(char(10),CAST(enddate as datetime),102) MA022 ,M.MV002 billname,creatdate,"+;
	"chkman,chkdate,customid,MA002,C.MV002,bomman, bomdate,code as ERPƷ��,itemno ��˾����,customcode �ͻ�Ʒ��,color,classid,"+;
	"mb057,mb058,mb059,mb060,customspec �ͻ���� ,bomchkid,chkid,moq,MB025 "+;
	" FROM quotation left join CMSNA  on NA001='2' and payment=NA002 "+;
	"LEFT JOIN COPMA ON MA001=customid LEFT JOIN CMSMV C ON C.MV001=MA016 LEFT JOIN CMSMV M ON M.MV001= billname left join INVMB ON MB001=code"+;
	 " WHERE chkid=1","tmp")<0
		SQLDISCONNECT(CON)

	 WAIT windows '������'
	 RETURN
ENDIF   
SELECT tmp
DO whil .not. EOF()
	xd=interid
	cdate=DTOC(DATE(),1)
	xd=interid
	MTD004 =ALLTRIM(ERPƷ��)
	MTC008 =����
	MTC004 =customid 
	MTD014 =ALLTRIM(�ͻ�Ʒ��)
	MTD205 =ALLTRIM(color)
	mpricenote=pricenote
	mf=tosupplyid
	MCLASSID=CLASSID
	M0=MB025
	MTC004 =customid
	MMB002=ALLTRIM(��Ʒ����)
	MMB003=ALLTRIM(���)
	sn=MMB002+':'+MMB003
	yss=ALLTRIM(color)
	sxrq=MA022 
	IF ISNULL(yss)
		yss=''
	ENDIF 
	MCB=�ɱ�
	SQLEXEC(CON,"select TOP 1 MG004,MG002  FROM CMSMG WHERE MG001=?MTC008 AND MG002<=?CDATE ORDER BY MG002 DESC")
	IF RECCOUNT()<1
		*MESSAGEBOX('���ֲ�����',0+47+1,'�����Ǳ����')
		*RETURN 
	ENDIF	
	WW13=MG004	
	SQLEXEC(con,"UPDATE quotation SET exchangerate=?WW13 WHERE [currency]=?MTC008")
	SQLEXEC(con,"UPDATE quotation SET profit=(price*exchangerate*discount/100-cost)/(price*exchangerate*discount/100)*100 WHERE interid=?XD AND price>0")		

	IF sxrq<DTOC(DATE())
		SQLEXEC(con,"UPDATE quotation SET chkid=0 WHERE interid=?XD")
		sn='ʧЧ����['+sxrq+'],���������'
		ccodeid=maxinterid("piapprove")
		CON1=ODBC(6)
		SQLEXEC(CON1,"INSERT INTO piapprove (interid,note,chkname,chkdate,keyinterid,dept,action,keyorder) values (?ccodeid,?sn, ?P_UserName,GETDATE(), ?XD,?HR_DEPT,'�˼۵�ʧЧ',1)")
		SQLDISCONNECT(CON1)
	ENDIF 
	SQLEXEC(CON,"select enddate FROM quotationprice WHERE interid=?XD")
	IF RECCOUNT()=1
		IF enddate <=DTOC(DATE())
			SQLEXEC(con,"UPDATE quotation SET chkid=0 WHERE interid=?XD")
			SQLEXEC(con,"UPDATE quotationprice SET chkid=0 WHERE interid=?XD")
			sn='�⹺��Ʒ�˼�ʧЧ����['+sxrq+'],���������'
			ccodeid=maxinterid("piapprove")
			CON1=ODBC(6)
			SQLEXEC(CON1,"INSERT INTO piapprove (interid,note,chkname,chkdate,keyinterid,dept,action,keyorder) values (?ccodeid,?sn, ?P_UserName,GETDATE(), ?XD,?HR_DEPT,'�⹺ʧЧ',1)")
			SQLDISCONNECT(CON1)
		ENDIF 
	ENDIF 
	SELECT TMP
	IF mf='N' &&AND bomchkid<>1 &&AND MTD004 >='A'
*!*			IF (bomchkid<>1 OR ISNULL(bomchkid)) AND MTD004 >='A' AND LEFT(MTD004,1)<>'X'
*!*				IF MESSAGEBOX('['+MMB002+':'+MMB003+ ']û�����BOM�������Բ�����Ʒ���뽨�����BOM֮�󣬲�����˺˼۵���'+CHR(13)+CHR(10)+CHR(13)+CHR(10)+'�����ǿ����ˣ���ȡ����['+ALLTRIM(MTD004 )+']��׼�ɱ�,�Ƿ������',36,'BOMû�����')<>6
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
*!*						SQLEXEC(CON1,"INSERT INTO piapprove (interid,note,chkname,chkdate,keyinterid,dept,action,keyorder) values (?ccodeid,?sn, ?P_UserName,GETDATE(), ?XD,?HR_DEPT,'�ɱ�����',1)")
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
					sn='ԭ='+ALLTRIM(STR(mcb,10,2))+',��='+ALLTRIM(STR(mcost,10,2))
					ccodeid=maxinterid("piapprove")

					CON1=ODBC(6)
					SQLEXEC(CON1,"INSERT INTO piapprove (interid,note,chkname,chkdate,keyinterid,dept,action,keyorder) values (?ccodeid,?sn, ?mname,?mname, ?XD,?HR_DEPT,'�ɱ�����',1)")
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
				sn='ԭ='+ALLTRIM(STR(mcb,10,2))+',��='+ALLTRIM(STR(mcost,10,2))
				SQLEXEC(con,"UPDATE quotation SET cost=?MCOST,mb059=?m59,mb058=?m58,mb060=?m60,mb057=?m57 WHERE interid=?XD  and tosupplyid='N'")
				ccodeid=maxinterid("piapprove")

				CON1=ODBC(6)
				SQLEXEC(CON1,"INSERT INTO piapprove (interid,note,chkname,chkdate,keyinterid,dept,action,keyorder) values (?ccodeid,?sn, ?mname,?mdate, ?XD,?HR_DEPT,'�ɱ�����',1)")
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
			sn='ԭ='+ALLTRIM(STR(mcb,10,2))+',��='+ALLTRIM(STR(mcost,10,2))
			SQLEXEC(con,"UPDATE quotation SET cost=?MCOST,mb059=?m59,mb058=?m58,mb060=?m60,mb057=?m57 WHERE interid=?XD  and tosupplyid='N'")
			ccodeid=maxinterid("piapprove")
			CON1=ODBC(6)
			SQLEXEC(CON1,"INSERT INTO piapprove (interid,note,chkname,chkdate,keyinterid,dept,action,keyorder) values (?ccodeid,?sn, ?mname,?mdate, ?XD,?HR_DEPT,'�ɱ�����',1)")
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
			   IF lcChar=" " AND !llNoPlus && AND 1=2 && AND  F1<>'����'&&
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