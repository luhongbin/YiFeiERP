RELEASE    mindex,datefrom,dateto,mcount,i,j,mInxdex,MyData,x,data1,mcountrelate,y,mid,MyDatax,conu

PUBLIC   mindex,datefrom,dateto,mcount,i,j,mInxdex,MyData,x,data1,mcountrelate,y,mid,MyDatax,conu
Declare Integer InternetGetConnectedState In wininet.Dll Integer @lpdwFlags, Integer dwReservednReserved
If internetgetconnectedstate(7, 0) = 0
	 RETURN 
ENDIF
LOCAL   loXMLHTTP AS "MSXML2.XMLHTTP"
loXMLHTTP = CREATEOBJECT("MSXML2.XMLHTTP")
LOCAL   oIE  as internetexplorer.application

header1="'User-Agent':'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0; Trident/5.0)'"
url='http://wenshu.court.gov.cn/List/ListContent'

conu=odbc(6)
SQLEXEC(conu,"select min(dateid) dfrom,max(dateid) dto ,CONVERT(varchar(10), getdate(), 112) DATEID from sixplusone..wenshu")
SQLDISCONNECT(conu)
IF RECCOUNT()<1 OR ISNULL(dfrom)
	datefrom='2017-02-01'
	x1=DTOC(DATE(),1)
	dateto=LEFT(x1,4)+'-'+SUBSTR(x1,5,2)+'-'+RIGHT(x1,2)
	dateto='2017-02-20'
ELSE
	IF dto=DATEID OR 1=1
		x=dfrom 
		x1=DTOC(CTOD(LEFT(x,4)+'.'+SUBSTR(x,5,2)+'.'+RIGHT(x,2))-30,1)
		datefrom=LEFT(x1,4)+'-'+SUBSTR(x1,5,2)+'-'+RIGHT(x1,2)
		dateto=LEFT(x,4)+'-'+SUBSTR(x,5,2)+'-'+RIGHT(x,2)
			dateto='2017-01-22'
		datefrom='2017-01-22'

*!*			oIE.quit
*!*			oIE= NULL
*!*			loXMLHTTP = NULL
*!*			RETURN
	ELSE
		x=DTOC(CTOD(LEFT(dto,4)+'.'+SUBSTR(dto,5,2)+'.'+RIGHT(dto,2))-1,1)
		datefrom=LEFT(x,4)+'-'+SUBSTR(x,5,2)+'-'+RIGHT(x,2)
		y=ALLTRIM(DATEID)
		dateto=LEFT(y,4)+'-'+SUBSTR(y,5,2)+'-'+RIGHT(y,2)
	ENDIF 	
ENDIF 	
mindex=40

P_FileName='�й�����������'
P_EditMode='����'
WITH loXMLHTTP AS MSXML2.XMLHTTP
FOR mInxdex=31 TO mindex
	data1="Param=������:����,����:��ͬ����,��������:"+datefrom+" TO "+dateto+"&Index= "+ALLTRIM(STR(mInxdex))+"&Page=20&Order=��������&Direction=desc"
*!*			TRY 
			.OPEN("POST", url,.f.)
			.setRequestHeader("Content-Length",Len(data1))	
			.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded")
			.send(data1)	
			DO WHILE .ReadyState<> 4
				=Inkey(1)
			Enddo
			MyData=.responseText
*!*		    CATCH 
*!*		    FINALLY 
*!*		    ENDTRY 			
			
	mcount=OCCURS('����Ҫּ��ԭ��\"',MyData)

	x=VAL(STREXTRACT(MyData,'Count\":\"','\"'))
	
	IF x=0
		mindex=1
		EXIT
		LOOP 
	ELSE 
		*mindex=IIF(INT(x/20)=x/20,mindex=x/20,mindex=x/20+1)
		FOR x=1 TO mcount
	    	mid=STREXTRACT(MyData,'����ID\":\"','\"',x)
	    	mcaseno=ALLTRIM(STREXTRACT(MyData,'����\":\"','\",',x))

	    	conu=odbc(6)
	    	IF SQLEXEC(conu,"insert into sixplusone..wenshu (id,caseno) values (?mid,?mcaseno)")>0
	    	?mid
		    	mgist=STREXTRACT(MyData,'����Ҫּ��ԭ��\":\"','\",',x)
		    	mcasetype=allt(STREXTRACT(MyData,'��������\":\"','\",',x))
		    	mdateid=DTOC(CTOD(STREXTRACT(MyData,'��������\":\"','\",',x)),1)
		    	mcasename=STREXTRACT(MyData,'��������\":\"','\",',x)
		    	mprogram=STREXTRACT(MyData,'���г���\":\"','\",',x)
		    	mcourtname=ALLTRIM(STREXTRACT(MyData,'��Ժ����\":\"','\"',x))
				IF SQLEXEC(conu,"update sixplusone..wenshu set gist=?mgist,casetype=?mcasetype,dateid=?mdateid,casename=?mcasename,"+;
				"program=?mprogram,caseno=?mcaseno,courtname=?mcourtname,billname=?P_USERNAME,creatdate=getdate() where caseno=?mcaseno and id=?mid ")<0
				ENDIF 
				urltext='http://wenshu.court.gov.cn/content/content?DocID='+mid+'&KeyWord= '+mcaseno&&&&***************��ȡ����
				.OPEN("POST", urltext,.f.)
				.setRequestHeader("Content-Length",Len(urltext))	
				.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded")
				.send()	
				DO WHILE .ReadyState<> 4
					=Inkey(1)
				ENDDO
				=Inkey(1)
				MyDatay=.responseText
			IF mydata='"remind"'
				MESSAGEBOX("��������֤��,���ݴ�����Ҫ,�����޷���������")
				oIE = createobject( "internetexplorer.application" ) 
				oIE.Visible = .t. 
				oIE.Navigate( "http://wenshu.court.gov.cn/Html_Pages/VisitRemind.html" ) 
				
			ENDIF 
		    	mprov=STREXTRACT(MyDatay,'"��Ժʡ��":"','"')
		    	mcity=ALLTRIM(STREXTRACT(MyDatay,'��Ժ����":"','"'))
		    	mdistrict=ALLTRIM(STREXTRACT(MyDatay,'��Ժ����":"','"'))
		    	mtime=ALLTRIM(STREXTRACT(MyDatay,'�ϴ�����":"\/Date(',')'))
		    	SQLEXEC(conu,"update sixplusone..wenshu set prov=?mprov,city=?mcity,district=?mdistrict,uptimestamp=?mtime where caseno=?mcaseno and id=?mid ") &&&&***************��ȡ����
		    ELSE 
			ENDIF 	
*!*					urltext='http://wenshu.court.gov.cn/CreateContentJS/CreateContentJS.aspx?DocID='+mid&&&&***************�о�����
*!*					.OPEN("POST", urltext,.f.)
*!*					.setRequestHeader("Content-Length",Len(urltext))	
*!*					.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded")
*!*					.send()	
*!*					DO WHILE .ReadyState<> 4
*!*						=Inkey(1)
*!*					ENDDO
*!*					=Inkey(1)
*!*					xm=STREXTRACT(.responseText,'\"PubDate\":\"','\",\"Html')
*!*					SQLEXEC(conu,"update sixplusone..wenshu set pubdate=?xm  where caseno=?mcaseno and id=?mid") &&&&***************�о����ķ�������
*!*					STRTOFILE(STREXTRACT(.responseText,'"Html\":\"','\"}"'),"D:\liuplusone.HTML")
*!*					TRY 
*!*						oIE = createobject( "internetexplorer.application" ) 
*!*						oIE.Visible = .f. 
*!*						oIE.Navigate( "D:\liuplusone.HTML" ) 
*!*						DO WHILE oie.Busy() 
*!*						ENDDO 
*!*						oDoc = oIE.Document 
*!*						lcText = oDoc.documentElement.innerText 
*!*						oIE.quit
*!*				    	maddr=STREXTRACT(lcText ,'','����Ժ')

*!*						SQLEXEC(conu,"update sixplusone..wenshu set mainbody=?lcText,address=?maddr,getid=1 where caseno=?mcaseno and id=?mid ")
*!*					CATCH 
*!*						keyidc=maxinterid("Remotion")
*!*						xm1=STREXTRACT(.responseText,'"Html\":\"','\"}"')
*!*						SQLEXEC(conu,"update sixplusone..wenshu set mainbody=?xm1,getid=0 where caseno=?mcaseno and id=?mid ")

*!*	*!*						conux=odbc(6)

*!*	*!*						IF SQLEXEC(conu,"INSERT INTO remotion (interid,dateid,truckno,note,statusid,keyvalue,billname,creatdate,remotion) values "+;
*!*	*!*							"(?keyidc,getdate(),'�ɼ��о����ı�ʧ��',?mcaseno,'�ɼ�ʧ��','','����',getdate(),?mid)")<0
*!*	*!*							WAIT windows ',,,,,' nowait  &&,keyvalue,dept,billname,creatdate,?mkeyvalue,?P_DEPT,?p_username,getdate()
*!*	*!*						ENDIF 
*!*	*!*						SQLDISconuNECT(conux)
*!*					FINALLY 
*!*					ENDTRY 				


*!*					url2='http://wenshu.court.gov.cn/List/GetAllRelateFiles?'&&&***************�����ļ�
*!*					data1="caseInfoAll"+mid+"|"+mcourtname+"|"+mcaseno+"|"+mcasetype
*!*					.OPEN("POST", url,.f.)
*!*					.setRequestHeader("Content-Length",Len(data1))	
*!*					.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded")
*!*					.send(data1)	
*!*					DO WHILE .ReadyState<> 4
*!*						=Inkey(1)
*!*					ENDDO
*!*					=Inkey(1)
*!*					MyDatax=.responseText
*!*					mcountrelate=OCCURS('����ID\":\"',MyDatax)	
*!*					FOR y=1 TO mcountrelate
*!*				    	mid=STREXTRACT(MyDatax,'����ID\":\"','\"',y)
*!*				    	IF LEN(mid)<10
*!*				    		EXIT
*!*				    		LOOP
*!*				    	ENDIF 
*!*				    	SQLEXEC(conu,"select interid from [sixplusone..relatecase] where caseno=?mcaseno and id=?mid ")
*!*				    	IF RECCOUNT()=1
*!*				    		minter=interid 
*!*				    	ELSE
*!*	*!*				    		minter=maxinteridx("relatecase")

*!*				    		SQLEXEC(conu,"insert into sixplusone..relatecase (id,caseno) values (?mid,?mcaseno )")
*!*				    		SQLEXEC(conu,"select interid from [sixplusone..relatecase] where caseno=?mcaseno and id=?mid ")
*!*				    		minter=interid 
*!*				    	ENDIF 	
*!*				    	mdateid=DTOC(CTOD(STREXTRACT(MyDatax,'��������\":\"','\",',x)),1)
*!*				    	mcloseway=STREXTRACT(MyDatax,'�᰸��ʽ\":\"','\",',x)
*!*				    	mprogram=STREXTRACT(MyDatax,'���г���\":\"','\",',x)
*!*				    	mcaseno=ALLTRIM(STREXTRACT(MyDatax,'����\":\"','\",',x))
*!*				    	mcourtname=ALLTRIM(STREXTRACT(MyDatax,'����Ժ\":\"','\"',x))		
*!*						IF SQLEXEC(conu,"update [sixplusone..relatecase] set interid=?minter,dateid=?mdateid,program=?mprogram,courtname=?mcourtname where caseno=?mcaseno and id=?mid")<0
*!*						ENDIF 			    		    	
*!*				    ENDFOR 		
*!*					    	
*!*										
*!*					SQLDISCONNECT(conu)
*!*	*!*					P_ID='����ID:'+mcaseno
*!*	*!*					DO &P_Prgs.EveryDay WITH P_FileName,P_ID,P_EditMode
	    ENDFOR 
	ENDIF    
ENDFOR 
ENDWITH

loXMLHTTP = NULL