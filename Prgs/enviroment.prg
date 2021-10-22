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
	ON ERROR DO errHandler WITH  ERROR( ), MESSAGE( ), MESSAGE(1), PROGRAM( ), LINENO( )
*ON ERROR 
set defa to d:\trade
*!*	SET DEFAULT TO alert
*!*	DO main.prg
			
*!*	SET DEFAULT TO ..
CLOSE DATABASES ALL 
CLEAR ALL
*!*	CLOSE ALL
*!*	OPEN DATABASE dats\mymis
SET SYSMENU TO DEFAULT 
SET NULL OFF
PUBLIC P_TollBar
P_TollBar=.F.
PUBLIC P_Prgs,P_Frms,P_Dats,P_Rpts,P_Tmps,P_RptSource,P_Others,P_Imgs,P_Rights,P_ChkBill,P_Service,con,MVer,P_DockDate,P_UserCode,P_Long,P_Cycle,P_Use,TM,P_Title,P_Email,P_CASH,tqyb,CDATE,oldpath
P_CASH=0
P_Title=''
P_Email=''
PUBLIC CodeID,KeyID,mKeyId,DATEID,FEND,EEND,mWhere,KeyTxt,TXTKEY,mLevel,oldpath,P_Driver,P_Vice,P_Ass,cdate,tableid,CON1,f1,f2,reptid,P_PutClass,P_Cash,P_Day,P_DayCash,P_SuperRights,F11,F3,p_chkman,emailsign
PUBLIC goPic AS Image
m.goPic = NEWOBJECT( 'Image' ) 

emailsign='鲁红斌'
P_Long=0
P_Cycle='两周'
codeid=0
P_DockDate=0
p_chkman=0
P_Driver=''
P_Vice=''
P_Ass=''
mWhere=''
CDATE=''
tableid=1
P_UserCode='Y00095'
P_SuperRights='1'
OldPath='D:\TRADE'
*!*	SET EXCL ON
DIME Ver[1]
P_ChkBill=0
mLevel=0
mKeyId=0
TXTKEY=''
KEYTXT=''
FEND=DATE()
EEND=DATE()
*!*	AGETFILEVERSION(Ver,"lu3.EXE")
*!*	SET NULL off
*!*	mVer='版本号：'+ALLT(Ver[4])
DATEID=DATE()
KeyID=0
SET NULLDISPLAY TO ''
P_Prgs="Prgs\"
P_Frms="Frms\"
P_Dats="Dats\"
P_Others="Others\"
P_Tmps="Tmps\"
P_Rpts="Rpts\"
P_RptSource='RptSource\'
P_Imgs='Imgs\'
P_Title='SUPERUSER'
PUBLIC P_EditMode,P_FileName,P_Id,P_Rights,EditMode,HRMACHID,oldAlias
HRMACHID='6028'
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
PUBLIC P_Icon,P_Caption
P_Caption=""
P_Icon="&P_Others.Shipping.ICO"

***** Set Report File's Information
PUBLIC P_ReportName,P_RecordCount,P_ReportFile,P_BeginPage,P_EndPage,mwhere1,P_ZX,P_USE,xfend
P_ReportName=''
P_RecordCount=''
P_ReportFile=''
P_BeginPage=1
P_EndPage=9999
SET REPORTBEHAVIOR 90
***** Set Passward
PUBLIC P_UserName,P_SuperRights,P_Dept,P_Appo,HR_DEPT,P_Print
HR_DEPT='信息部' 
P_UserName='鲁红斌'
P_Rights='1111111311111111111111111'
P_SuperRights='1'
P_Dept='耀华灯具压铸车间'
P_Appo='经理'
DO (LOCFILE("System.app"))
DO LOCFILE("FoxyPreviewer.App")
WITH _Screen.oFoxyPreviewer 
*!*	    .lQuietMode 
*!*	    .lPDFEmbedFonts 
*!*	    .lPDFCanPrint 
    .lPDFCanEdit =.f.
    .lPDFCanCopy =.f.
*!*	    .lPDFCanAddNotes 
*!*	    .lPDFEncryptDocument 
*!*	    .cPDFMasterPassword 
*!*	    .cPDFUserPassword 
*!*	    .lPDFShowErrors 
*!*	    .cPDFSymbolFontsList 
*!*	    .cPdfAuthor 
*!*	    .cPdfTitle 
*!*	    .cPdfSubject 
*!*	    .cPdfKeyWords 
*!*	    .cPdfCreator 
*!*	    .cPDFDefaultFont 
*!*	    .lOpenViewer 
*!*	    .nPDFPageMode 
	.cPdfTitle ='Ningbo UTEC Electric Co., LTD'
    .cPdfAuthor =P_USERCODE
    .cPdfCreator ='Lu3 Software'
ENDWITH 
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
IF !DIREC('&P_IMGS')
	MD IMGS
ENDI
IF !DIREC('&P_TMPS')
	MD TMPS
ENDI
IF !DIREC('&P_RPTS')
	MD RPTS
ENDIF
mwhere1='xx'
P_Print=0
*****
SET PROCEDURE TO &P_Prgs.SysProce,&P_Others.OrderInfoMenu.Mpr,&P_Prgs.qdfoxjson.prg,&P_Prgs.foxbarcodeqr,&P_Prgs.costformocta&&,&Prgs.autoproce.prg
*DO &P_Prgs.gethrtree
SET PATH to class addi
DO ReduceMemory
ON ERROR DO errHandler WITH  ERROR( ), MESSAGE( ), MESSAGE(1), PROGRAM( ), LINENO( )
*!*	CON=ODBC(5)
*!*	SQLEXEC(CON,"DROP VIEW LHBCOPTD")
*!*	SQLEXEC(CON,"CREATE VIEW LHBCOPTD AS SELECT TD001,TD002,UDF03"+;
*!*	"FROM COPTD GROUP BY TD001,TD002,TD004")
*!*	 ENDCASE 	
*!*	SQLDISCONNECT(con)

RETURN
*****	Begin Next file
*****	End of File
