*	***************************************************************
*	*
*	*			2004-03-25		Begin.PRG			21:00:00
*	*
*	***************************************************************
*	*	Programmer:	Lu_HongBin
*	*
*	*	CopyRight(R)	LU3   V1.0
*	*
*	*	Description:	This is first file of LU3   
*	*
*	***************************************************************
*	Call By :	No file


*****	Set Envoriment of System
*****	Set File's Root
_SCREEN.VISIBLE=.F.
*!*	SET SYSMENU TO DEFAULT 
SET NULL OFF

*!*	PUBLIC P_TollBar
*!*	P_TollBar=.F.
*!*	PUBLIC P_Prgs,P_Frms,P_Dats,P_Rpts,P_Tmps,P_RptSource,P_Others,P_Imgs,P_Rights,P_ChkBill,P_Service,con,MVer,P_DockDate,P_UserCode,P_Long,P_Cycle,P_Use,TM,P_Title,P_Email,P_CASH,tqyb,CDATE,oldpath,odbc
*!*	P_CASH=0
*!*	P_Title=''
*!*	P_Email=''
*!*	PUBLIC CodeID,KeyID,mKeyId,DATEID,FEND,EEND,mWhere,KeyTxt,TXTKEY,mLevel,oldpath,P_Driver,P_Vice,P_Ass,cdate,tableid,CON1,f1,f2,reptid,P_PutClass,P_Cash,P_Day,P_DayCash,P_SuperRights,F11,F3,p_chkman,emailsign,odbc
*ON ERROR RETURN

*!*	P_Long=0
*!*	P_Cycle='����'
*!*	codeid=0
*!*	P_DockDate=0
*!*	p_chkman=0
*!*	P_Driver=''
*!*	P_Vice=''
*!*	P_Ass=''
*!*	mWhere=''
*!*	CDATE=''
*!*	tableid=1
*!*	P_SuperRights='1'
*!*	*!*	SET EXCL ON
*!*	DIME Ver[1]
*!*	P_ChkBill=0
*!*	mLevel=0
*!*	mKeyId=0
*!*	TXTKEY=''
*!*	KEYTXT=''
*!*	FEND=DATE()
*!*	EEND=DATE()

DATEID=DATE()
KeyID=0
SET NULLDISPLAY TO ''
P_Prgs="Prgs\"
P_Frms="Frms\"
P_Others="Others\"
SET PROCEDURE TO Prgs\autoproce.prg
*ON ERROR DO errHandler WITH  ERROR( ), MESSAGE( ), MESSAGE(1), PROGRAM( ), LINENO( )
ON ERROR INKEY(1)
P_Icon="&P_Others.misc29.ICO"

PUBLIC P_EditMode,P_FileName,P_Id,P_Rights,EditMode,HRMACHID,oldAlias
P_rights=''
P_EditMode='New'
P_FileName=''
P_Id=''
FdateID=DATE()
EdateID=DATE()
EditMode=''
***** Set Date and Time
PUBLIC P_Date,P_Time
P_Date=DATE()
P_Time=TIME()
CURSORSETPROP("MapBinary",.T.,0)
***** Set File Name

SET REPORTBEHAVIOR 90
***** Set Passward
PUBLIC P_UserName,P_SuperRights,P_Dept,P_Appo,HR_DEPT,P_Print

***** Set Condition of System
SET FIXED OFF
SET TALK OFF
SET ECHO OFF
SET SAFETY OFF
SET EXCL ON
SET DELE ON
SET DATE TO ANSI LONG
SET CENTURY ON
SET EXACT OFF
SET CENTURY TO
SET STATUS BAR OFF
SET MULTILOCKS ON
SET NOTIFY CURSOR OFF
SET DECIMALS TO 2
SET HOURS TO 24
SET CONSOLE OFF 
SET COMPATIBLE ON
SET COMPATIBLE Off
***** 	Set  BackGround
*****

mwhere1='xx'
*****
restore from Buys additive
*!*	IF p_username='Ӧ����'
*!*		canc
*!*		quit
*!*	ENDIF	
*!*	IF P_USERNAME>'��'
*!*		CON=ODBC(1)
*!*		SQLEXEC(CON,"SELECT TOP 1 NAME,website,namesource,creatdate  FROM fromweb WHERE  BODY IS NULL AND website like 'firm%' ORDER BY 4","wods")
*!*		SQLDISCONNECT(cON)
*!*		IF RECCOUNT()=1
*!*			DO FORM &P_Frms.txtcollectqichachadetail.scx
*!*		ELSE	
*!*			DO FORM &P_Frms.txtcollectshuidi.SCX
*!*		ENDIF
*!*		SQLDISCONNECT(CON)	
*!*	ELSE	
	DO FORM &P_Frms.txtcollectshuidi.SCX
*!*	ENDIF
READ EVENTS

*DO &P_Prgs.gethrtree
RETURN
SET PATH to class addi
RELEASE X,mweb,minteridx,MID,XMAINBODY,MAINBODYB,Mcaseno,mPROGRAM,minteridx,CONX
PUBLIC X,mweb,minteridx,MID,XMAINBODY,MAINBODYB,Mcaseno,mPROGRAM,minteridx,CONX
Declare Integer InternetGetConnectedState In wininet.Dll Integer @lpdwFlags, Integer dwReservednReserved,MBEGIN
internetgetconnectedstate(7, 0)
If internetgetconnectedstate(7, 0) = 0
	 CANCEL
	 QUIT
ENDIF
DO WHILE 1=1
LOCAL loXMLHTTP AS "MSXML2.XMLHTTP"
loXMLHTTP = CREATEOBJECT("MSXML2.XMLHTTP")
header1="'User-Agent':'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0; Trident/5.0)'"
WITH loXMLHTTP AS MSXML2.XMLHTTP

CONX=ODBC(6)
SQLEXEC(CONX,"SELECT top 50 id , [caseno],dateid,docid from sixplusone..[wenshu] a left join sixplusone..courtcode b on a.courtno =b.courtno  "+;
"where b.prov='�㽭' AND PAGE<>200  and (mainbody is null or  mainbody not like '%��Ժ%') order by 3 desc","Tmpwenshu")
IF RECCOUNT()>0
	GO top
	DO WHILE .NOT. EOF()
		x=caseno
		SQLEXEC(CONX,"update sixplusone..wenshu set page=200 where caseno=?x","Tmpwenshu")
		SELECT Tmpwenshu
		skip
	ENDDO
ELSE
	quit
ENDIF 
SELECT Tmpwenshu
TT=ALLTRIM(STR(RECCOUNT()))
GO TOP
DO WHIL .NOT. EOF()
*	WAIT WINDOWS TRANS(RECNO())+'/'+TT NOWAIT 
	MID=id
	Mcaseno=ALLTRIM(caseno)
	tdate=DTOC(DATE(),1)
	mdocid=ALLTRIM(str(docid))
	*SQLEXEC(CONX,"SELECT MAINBODY FROM sixplusone..wenshu  WHERE ID=?MID AND CASENO=?Mcaseno")
	IF docid<10 OR ISNULL(docid)
	url='http://www.zjsfgkw.cn/document/JudgmentSearch'
	data1="ah="+Mcaseno+"&cbfy&jarq1&jarq2&pageno=1&pagesize=10"
	.OPEN("POST", url,.f.)
	.setRequestHeader("Content-Length",Len(data1))	
	.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded")
	.setRequestHeader('User-Agent', 'User-Agent:Mozilla/5.0(Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.95Safari/537.36 Core/1.50.1280.400')	
	.send(data1)	
	DO WHILE .ReadyState<> 4
		=Inkey(1)
	Enddo
	MyData=.responseText

	mdocid=STREXTRACT(MyData,'DocumentId":',',')
	ENDIF
	urltext='http://www.zjsfgkw.cn/document/JudgmentDetail/'+mdocid&&&&***************�о�����
	.OPEN("GET", urltext,.f.)
	.setRequestHeader("Content-Length",Len(urltext))	
	.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded")
	.setRequestHeader('User-Agent', 'User-Agent:Mozilla/5.0(Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.95Safari/537.36 Core/1.50.1280.400')	
	.send()	
	DO WHILE .ReadyState<> 4
	ENDDO
	xm2=ALLTRIM(STREXTRACT(.responseText,'�������ڣ�','</h6>'))
	xm='/attachment/'+ALLTRIM(STREXTRACT(.responseText,'src="/attachment/','"'))

	urltext='http://www.zjsfgkw.cn'+xm&&&&***************�о�����
	.OPEN("GET", urltext,.f.)
	.setRequestHeader("Content-Length",Len(urltext))	
	.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded")
	.setRequestHeader('User-Agent', 'User-Agent:Mozilla/5.0(Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.95Safari/537.36 Core/1.50.1280.400')	
	.send()	
	DO WHILE .ReadyState<> 4
	ENDDO
	xm=.responseText
	STRTOFILE(STRCONV(ALLTRIM(STREXTRACT(.responseText,'><html ','</html>')),9),"D:\ssliuplusone.HTML")
	oIE = createobject( "internetexplorer.application" ) 
	oIE.Visible = .f. 
	oIE.Navigate( "D:\ssliuplusone.HTML" ) 
	DO WHILE oie.Busy() 
	ENDDO 
	oDoc = oIE.Document 
	lcText =ALLTRIM( oDoc.documentElement.innerText )
	lcText =CHRTRAN(lcText ,'?','')
	lcText =strTRAN(lcText ,'xmlns="http://www.w3.org/1999/xhtml">','')
	lcText =CHRTRAN(lcText ,' ','')
	oIE.quit


	IF '��Ժ'$ALLTRIM(lcText)
		SQLEXEC(CONX,"update sixplusone..wenshu set mainbody=?lcText,pubdate=?xm2,docid=?mdocid, getid=1,billname=?P_USERNAME,creatdate=getdate() where caseno=?mcaseno and id=?mid ")
*!*		ELSE
*!*			urltext='http://wenshu.court.gov.cn/CreateContentJS/CreateContentJS.aspx?DocID='+mid&&&&***************�о�����
*!*			.OPEN("POST", urltext,.f.)
*!*			.setRequestHeader("Content-Length",Len(urltext))	
*!*			.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded")
*!*			.send()	
*!*			DO WHILE .ReadyState<> 4
*!*			ENDDO
*!*			lcText=.responseText
*!*			xm=STREXTRACT(.responseText,'\"PubDate\":\"','\",\"Html')
*!*			STRTOFILE(STREXTRACT(.responseText,'"Html\":\"','\"}"'),"D:\ssliuplusone.HTML")
*!*			oIE = createobject( "internetexplorer.application" ) 
*!*			oIE.Visible = .f. 
*!*			oIE.Navigate( "D:\ssliuplusone.HTML" ) 
*!*			DO WHILE oie.Busy() 
*!*			ENDDO 
*!*			oDoc = oIE.Document 
*!*			lcText =ALLTRIM( oDoc.documentElement.innerText )
*!*			IF '��Ժ'$lcText
*!*				SQLEXEC(conx,"update sixplusone..wenshu set pubdate=?xm  ,mainbody=?lcText,getid=1,billname=?P_USERNAME,creatdate=getdate() where caseno=?mcaseno and id=?mid ")
*!*			ENDIF 			
*!*			oIE.quit

*!*			MAINBODYB=	ALLTRIM(lcText)
*!*		ENDIF 
	MAINBODYB=lcText 
	mPROGRAM=''
	IF '��'$STREXTRACT(MAINBODYB,'��Ժ','��')
		mPROGRAM='һ��'
	ENDIF
	IF '��'$STREXTRACT(MAINBODYB,'��Ժ','��')
		mPROGRAM='����'
	ENDIF
	IF '��'$STREXTRACT(MAINBODYB,'��Ժ','��')
		mPROGRAM='����'
	ENDIF
	MAINBODYB=STRTRAN(MAINBODYB,'���ͣ�ԭ������','')
	MAINBODYB=STRTRAN(MAINBODYB,'�������ˣ�ԭ�󱻸棩','����')	
	MAINBODYB=STRTRAN(MAINBODYB,'�����ˣ�ԭ�󱻸棩','ԭ��')
	MAINBODYB=STRTRAN(MAINBODYB,'�������ˣ�ԭ��ԭ�棩','����')
	MAINBODYB=STRTRAN(MAINBODYB,'�����߱��棩','')
	MAINBODYB=STRTRAN(MAINBODYB,'������ԭ�棩','')
	MAINBODYB=STRTRAN(MAINBODYB,'��ԭ�󱻸棩','')
	MAINBODYB=STRTRAN(MAINBODYB,'��ԭ��ԭ�棩','')
	MAINBODYB=STRTRAN(MAINBODYB,'ԭ�󱻸�','����')
	MAINBODYB=STRTRAN(MAINBODYB,'ԭ��ԭ��','����')
	*MAINBODYB=STRTRAN(MAINBODYB,'������','')
	*MAINBODYB=STRTRAN(MAINBODYB,'��������','')
************************************************************************	
	XMAINBODY1=ALLTRIM('ԭ��'+STREXTRACT(MAINBODYB,'ԭ��',CHR(13)))
	c=LEN(XMAINBODY1)
	IF '��'$XMAINBODY1 
		XMAINBODY=subs(XMAINBODY1,1,AT('��',XMAINBODY1)-1)
		IF '('$XMAINBODY1
			XMAINBODY=subs(XMAINBODY1,1,AT('(',XMAINBODY1)-1)
		ENDIF 	
	ELSE 
		XMAINBODY=XMAINBODY1
	ENDIF 	
	X=STREXTRACT(XMAINBODY,'ԭ��','��')
	IF EMPTY(X)
		X=STREXTRACT(XMAINBODY,'ԭ��',',')
		IF EMPTY(X)	
			X=STREXTRACT(XMAINBODY,'ԭ��','��')
			IF EMPTY(X)	
				X=STREXTRACT(XMAINBODY,'ԭ��','')
			ENDIF 
		ENDIF		
	ENDIF 			
	X=STRTRAN(x,':','')
	X=STRTRAN(x,'��','')
	IF '����'$STREXTRACT(MAINBODYB,'ԭ��','����')=.T. OR  '������'$STREXTRACT(MAINBODYB,'ԭ��','����')=.T.
		mattr=1
		IF '����������'$STREXTRACT(MAINBODYB,'ԭ��','����')=.T.
			mweb=STREXTRACT(MAINBODYB,'����������','')
		ELSE 
			IF '������'$STREXTRACT(MAINBODYB,'ԭ��','����')=.T.
				mweb=STREXTRACT(MAINBODYB,'������','')
			ENDIF	
		ENDIF	
		IF '������'$STREXTRACT(MAINBODYB,'ԭ��','����')=.T.
			mweb=STREXTRACT(MAINBODYB,'������','')
		ENDIF	
		mweb=STRTRAN(mweb,':','')
		mweb=STRTRAN(mweb,'��','')
	ELSE
		mattr=0
	ENDIF 	
	SQLEXEC(CONX,"SELECT interid FROM sixplusone..headinfo WHERE ID=?MID and classid='ԭ��' AND CASENO=?Mcaseno")
	IF RECCOUNT()=1
		IF ISNULL(interid )
			minterid=maxinteridt("headinfo")
			SQLEXEC(CONX,"update sixplusone..headinfo set interid=?minterid WHERE ID=?MID AND CASENO=?Mcaseno and classid='ԭ��'")
		ELSE
			minterid=interid
		ENDIF 	
		SQLEXEC(CONX," UPDATE sixplusone..headinfo SET name=?X,interid=?minterid,attr=?mattr WHERE interid=?minterid")
	ELSE
		minterid=maxinteridt("headinfo")
		SQLEXEC(CONX," INSERT INTO  sixplusone..headinfo (id,name,classid,attr,caseno) values (?mid,?X,'ԭ��',?mattr,?mcaseno)")
	ENDIF 

	
*********************************
	IF mPROGRAM='����'
		XMAINBODYT=CHR(10)+'����'+STREXTRACT(MAINBODYB,'����','������')
	ELSE
		XMAINBODYT=CHR(10)+'����'+STREXTRACT(MAINBODYB,'����','ԭ��')
	ENDIF	
	moccurs=OCCURS(CHR(10)+'����', XMAINBODYT)
	FOR m1=1 TO moccurs
*!*			XMAINBODY=ALLTRIM('����'+STREXTRACT(XMAINBODY,'����','ԭ��',m1))
		XMAINBODY1=ALLTRIM(CHR(10)+'����'+STREXTRACT(XMAINBODYT,CHR(10)+'����',CHR(10),m1))
		c=LEN(XMAINBODY1)
		IF '��'$XMAINBODY1 AND '֮'$XMAINBODY1
			XMAINBODY=subs(XMAINBODY1,1,AT('��',XMAINBODY1)-1)
			IF '('$XMAINBODY1
				XMAINBODY=subs(XMAINBODY1,1,AT('(',XMAINBODY1)-1)
			ENDIF 	
		ELSE 
			XMAINBODY=XMAINBODY1
		ENDIF 	
		X=STREXTRACT(XMAINBODY,'����',',')
		IF EMPTY(X)
			X=STREXTRACT(XMAINBODY,'����','��')
			IF EMPTY(X)	
				X=STREXTRACT(XMAINBODY,'����','��')
				IF EMPTY(X)	
					X=STREXTRACT(XMAINBODY,'����','')
				ENDIF 
			ENDIF		
		ENDIF 			
		X=STRTRAN(x,':','')
		X=STRTRAN(x,'��','')
		XMAINBODY2=CHR(10)+'����'+STREXTRACT(XMAINBODYT+'ԭ��',CHR(10)+'����','ԭ��',m1)+'����'

		IF ('����'$STREXTRACT(XMAINBODY2,'����','����')=.T. OR  '����'$STREXTRACT(XMAINBODY2,'����','����')=.T. OR  '������'$STREXTRACT(XMAINBODY2,'����','����')=.T. OR '��Ӫ��'$STREXTRACT(XMAINBODY2,'����','����')=.T.) AND LEN(X)>10
			mattr=1
			IF '����������'$STREXTRACT(XMAINBODY2,'����','����')=.T.
				mweb=STREXTRACT(XMAINBODY2,'����������','')
			ELSE
				IF '������'$STREXTRACT(XMAINBODY2,'����','����')=.T.
					mweb=STREXTRACT(XMAINBODY2,'������','')
				ELSE
					IF '������'$STREXTRACT(XMAINBODY2,'����','����')=.T.
						mweb=STREXTRACT(XMAINBODY2,'������','')
					ENDIF
				ENDIF	
			ENDIF	
			IF '������'$STREXTRACT(XMAINBODY2,'����','����')=.T.
				mweb=STREXTRACT(XMAINBODY2,'������','')
			ENDIF	
			IF '��Ӫ��'$STREXTRACT(XMAINBODY2,'����','����')=.T.
				mweb=STREXTRACT(XMAINBODY2,'��Ӫ��','')
			ENDIF
			mweb=STRTRAN(mweb,':','')
			mweb=STRTRAN(mweb,'��','')
		ELSE
			mattr=0
		ENDIF 	
		SQLEXEC(CONX,"SELECT interid FROM sixplusone..headinfo WHERE ID=?MID and classid='����'  AND CASENO=?Mcaseno and name=?x")
		IF RECCOUNT()=1
			IF ISNULL(interid )
				minterid=maxinteridt("headinfo")
				SQLEXEC(CONX,"update sixplusone..headinfo set interid=?minterid WHERE ID=?MID  AND CASENO=?Mcaseno and classid='����' and name=?x")
			ELSE
				minterid=interid
			ENDIF 	
			SQLEXEC(CONX," UPDATE sixplusone..headinfo SET name=?X,interid=?minterid,attr=?mattr WHERE interid=?minterid")
		ELSE
			minterid=maxinteridt("headinfo")
			SQLEXEC(CONX," INSERT INTO  sixplusone..headinfo (id,name,classid,attr,caseno) values (?mid,?X,'����',?mattr,?mcaseno)")
		ENDIF 
	ENDFOR 
*********************************	����
	Mcasecategory=''
	D=STREXTRACT(MAINBODYB,'ԭ��','һ��')
	SQLEXEC(CONX,"SELECT top 1 NAME FROM sixplusone..TREECODE WHERE ?D LIKE '%'+RTRIM(NAME)+'%' order by LEN(RTRIM(name)) desc")
	IF RECCOUNT()=1
		Mcasecategory=ALLTRIM(NAME)
	ENDIF

	D1=RIGH(STREXTRACT(MAINBODYB,'�����ս�','��'),12)+'��'
	mIncidentdate=SUBSTR(D1,AT('��',D1)-4,4)+IIF(LEN(STREXTRACT(D1,'��','��'))=1,'0'+STREXTRACT(D1,'��','��'),STREXTRACT(D1,'��','��'))+IIF(LEN(STREXTRACT(D1,'��','��'))=1,'0'+STREXTRACT(D1,'��','��'),STREXTRACT(D1,'��','��'))
	IF LEN(mIncidentdate)<8
		mIncidentdate=''
	ENDIF
	D1=STREXTRACT(MAINBODYB,'һ��','����')
	IF LEN(d1)=0
		D1=STREXTRACT(MAINBODYB,'һ��','����')
	ENDIF 
	*D1=SUBSTR(D1,AT('2',D1)-1,22)
	mregisterdate=SUBSTR(D1,AT('��',D1)-4,4)+IIF(LEN(STREXTRACT(D1,'��','��'))=1,'0'+STREXTRACT(D1,'��','��'),STREXTRACT(D1,'��','��'))+IIF(LEN(STREXTRACT(D1,'��','��'))=1,'0'+STREXTRACT(D1,'��','��'),STREXTRACT(D1,'��','��'))
	IF LEN(mregisterdate)<8  OR LEFT(mregisterdate,1)<>'2'
		mregisterdate=''
	ENDIF
	D1=STREXTRACT(MAINBODYB,'����','������ͥ')
	IF LEN(d1)=0
		D1=STREXTRACT(MAINBODYB,'����','������ͥ')
	ENDIF 	
	*D1=SUBSTR(D1,AT('2',D1)-1,22)
	mprosecutedate=SUBSTR(D1,AT('��',D1)-4,4)+IIF(LEN(STREXTRACT(D1,'��','��'))=1,'0'+STREXTRACT(D1,'��','��'),STREXTRACT(D1,'��','��'))+IIF(LEN(STREXTRACT(D1,'��','��'))=1,'0'+STREXTRACT(D1,'��','��'),STREXTRACT(D1,'��','��'))
	IF LEN(mprosecutedate)<8 OR LEFT(mprosecutedate,1)<>'2'
		mprosecutedate=''
	ENDIF
	SQLEXEC(CONX,"UPDATE sixplusone..WENSHU SET casecategory=?Mcasecategory,program=?mprogram WHERE ID=?MID AND CASENO=?Mcaseno")
	SQLEXEC(CONX,"UPDATE sixplusone..WENSHU SET Incidentdate=?mIncidentdate,[prosecutiondate]=?mregisterdate,[filingdate]=?mprosecutedate"+;
	" WHERE ID=?MID AND CASENO=?Mcaseno")&&trialdate]=?,
	s1=STREXTRACT(MAINBODYB,'�о�����','��')
	s2=[]
	P=0
	for i=1 to len(s1)
		if at(subst(s1,i,1),[.1234567890])>0
			s2=s2+subst(s1,i,1)
			P=1
		ELSE
			IF (SUBSTR(S1,I,2)='Ԫ' OR SUBSTR(S1,I,2)='��') AND P=1
				EXIT
			ELSE
				IF subst(s1,i,1)<>','
					S2=''	
					P=0
				ENDIF	
			ENDIF
		ENDIF
	NEXT
	S3=VAL(S2)
	IF SUBSTR(S1,I,2)='��'
		S3=S3*10000
	ENDIF
	IF '�����'$S1 OR S3=0
		S3=0
		s1=RIGHT(STREXTRACT(MAINBODYB,'Ժ��','Ԫ'),15)
		s2=[]
		for i=1 to len(s1)
			if at(subst(s1,i,1),[.1234567890])>0
				s2=s2+subst(s1,i,1)
			ENDIF
		NEXT
		S3=VAL(S2)
		IF RIGHT(s1,2)='��'
			S3=S3*10000
		ENDIF
	ENDIF
	IF '�����'$S1
		S3=VAL(STREXTRACT(MAINBODYB,'�ϼ������','Ԫ'))
	ENDIF
	SQLEXEC(CONX,"UPDATE sixplusone..WENSHU SET [capital]=?S3 WHERE ID=?MID AND CASENO=?Mcaseno")
*!*		IF HR_dept='���۲�'
*!*			WAIT WINDOWS '' TIMEOUT 1
*!*		ELSE
*!*			WAIT WINDOWS '' TIMEOUT 1
*!*		ENDIF	
	ENDIF 
*********************************
	SELECT 	Tmpwenshu
	SKIP
ENDDO
ENDWITH
SQLDISCONNECT(CONX)
loXMLHTTP = NULL
WAIT WINDOWS '' TIMEOUT 300
ENDDO 
READ EVENTS

