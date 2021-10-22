*	***************************************************************
*	*
*	*			1995-10-25		Begin.PRG			21:00:00
*	*
*	***************************************************************
*	*	Programmer:	Lu_HongBin
*	*
*	*	CopyRight(R)	Trade Main   V1.0
*	*
*	*	Description:	This is first file of YAOHUALUX   
*	*
*	***************************************************************
*	Call By :	No file


*****	Set Envoriment of System
*****	Set File's Root
ON ERROR return
	ON ERROR DO errHandler WITH  ERROR( ), MESSAGE( ), MESSAGE(1), PROGRAM( ), LINENO( )

_SCREEN.VISIBLE=.F.
SET EXCL ON
PUBLIC P_Backup,P_Prgs,P_Frms,P_Dats,P_Rpts,P_Tmps,P_RptSource,P_Others,P_Imgs,mVer,P_Rights,P_SuperRights,P_Service,P_DockDate,P_WareHouse,P_PutClass,P_Cash,P_Day,P_DayCash,P_Title,P_Email,xfend
P_DockDate=0
KEYTXT=''

P_Prgs="Prgs\"
P_Frms="Frms\"
P_Dats="dats\"
P_Others="Others\"
P_Tmps="Tmps\"
P_Rpts="Rpts\"
P_RptSource='RptSource\'
P_Imgs='Imgs\'
P_Backup='backup\'
P_Rights='00000000000000000'
SET PROCEDURE TO &P_Prgs.SysProce,&P_Others.OrderInfoMenu.Mpr,&P_Prgs.qdfoxjson.prg,&P_Prgs.foxbarcodeqr,&P_Prgs.costformocta
*run "taskkill /f /im/n erp.exe"
DECLARE INTEGER FindWindow IN USER32.DLL AS Find_Window STRING,STRING
LOCAL cTitle
cTitle="ERP助手"
IF Find_Window(0,cTitle)!=0
	=MESSAGEBOX('本程序已经运行!',48,'提示信息')
	quit
ENDIF
*--------------------------------------------------------
SET REPORTBEHAVIOR 90

SET  EXCL OFF

PUBLIC KeyID,mKeyId,DATEID,FEND,EEND,mWhere,TXTKEY,OldPath,P_ChkBill,P_Driver,P_Vice,P_Ass,P_ZX,CDate,P_UserCode,tableid,P_Long,P_Cycle,P_Use,TM,P_ChkMan

P_ChkBill=0
P_Driver=''
P_Vice=''
P_Ass=''

PUBLIC P_FileName,P_EditMode,P_Id,CON1,EditMode,F11,reptid,mwhere1,HR_DEPT,HRMACHID,tqyb

DATEID=DATE()
txtkey=''
KeyID=0
P_EditMode=''
P_FileName=''
P_Id=''
KEYTXT=''
mwhere1=''
***** Set Date and Time

mKeyId=0
***** Set File Name
PUBLIC P_Icon,P_Caption
P_Caption="ERP助手"
P_Icon="&P_Others.misc29.ICO"
***** Set Report File's Information
PUBLIC P_ReportName,P_RecordCount,P_ReportFile,P_BeginPage,P_EndPage,P_Print,codeid,F1,F2,con,F3,P_CASH,P_LOGINID
P_LOGINID=0
P_CASH=0

P_ReportName=''
P_RecordCount=''
P_ReportFile=''
P_BeginPage=1
P_EndPage=9999
P_Print=1
codeid=0
PUBLIC goPic AS Image
m.goPic = NEWOBJECT( 'Image' ) 
***** Set Passward
PUBLIC P_UserName,P_SuperRight,P_Dept,P_Appo
P_UserName='GAME OVER'
P_SuperRight=.T.
EditMode=''
**** SET PowerTotal

IF WVISIBLE("常用")
	HIDE WINDOW ("常用")
ENDIF
***** 	Set  BackGround
*****
IF !DIREC('&P_BACKUP')
      MD BACKUP
ENDIF



***** 	Set  BackGround
WITH _SCREEN
	.BACKCOLOR=RGB(255,255,255)           && Change background to white
	.BORDERSTYLE=0                      && Change border to sizeable
	.CLOSABLE=.F.
	.AUTOCENTER=.T.                       && Reset window control buttons
	.CONTROLBOX=.T.
	.MAXBUTTON=.T.
	.MINBUTTON=.T.
	.MOVABLE=.t. 
	.WINDOWSTATE=2
	.ICON=P_Icon
	.CAPTION=P_Caption
*!*		.PICTURE='&P_OtherS\CIRCLES.BMP'
	
ENDWITH
SET SAFETY OFF

*!*	RUN /N Regsvr32 "mscal.OCX" /s
XXXXX=SYS(5)+SYS(2003)+"\"

Declare Integer IsWow64Process In WIN32API ; 
Integer hProcess, Integer @ Wow64Process 
Declare Integer GetCurrentProcess In WIN32API 
* 
Local lnWin64, IsWin64 
lnWin64 = 0 
Try 
IsWow64Process( GetCurrentProcess(), @lnWin64) 
ENDTRY 
* 
IsWin64 = ( m.lnWin64 != 0 ) 
IF m.lnWin64 <>0
*!*		COPY FILE "comctl32.OCX" TO "C:\WINDOWS\syswow64\comctl32.OCX"
*!*		COPY FILE "mscomctl.OCX" TO "C:\WINDOWS\syswow64\mscomctl.OCX"
*!*		CD C:\WINDOWS\syswow64\comctl32.OCX
*!*		RUN /N Regsvr32 "comctl32.OCX" /s
*!*		RUN /N Regsvr32 "mscomctl.OCX" /s

*!*		CD "&XXXXX"
ENDIF
con1=odbc(5)

IF con1<=0
	SQLDISCONNECT(con1)
	con=odbc(4)
	IF con<=0
		MESSAGEBOX('请确认[SQLSERVER]已经正确安装!...',0+47+1,P_Caption)
		QUIT
	ENDIF
*!*		KEYTXT=Sys(5)+Sys(2003)+'\rongjie_Log.LDF'
*!*		TXTKEY=Sys(5)+Sys(2003)+'\rongjie_Data.MDF'
*!*		IF 	SQLExec(CON,"Exec Sp_Attach_DB @DbName = 'RongJie',@FileName1=?TXTKEY,@FileName2=?KEYTXT")<0
*!*			MESSAGEBOX('附加数据库失败，请确认rongjie_Data.MDF和rongjie_Log.LDF是否存在',0+47+1,P_Caption)
*!*			QUIT
*!*		ELSE	
*!*			SQLDISCONNECT(CON)
*!*		ENDIF	
ELSE 
	SQLDISCONNECT(CON1)
ENDIF 
*!*	DO &P_Others.Main.MPR
IF !FILE("Dalert.EXE")
	CON=ODBC(6)

	CURSORSETPROP("MapBinary",.T.,0)

	SQLEXEC(CON,"SELECT filename,filedata FROM [update] WHERE filename='Dalert.EXE' ","TMP")&&where newid=1
	STRTOFILE(filedata,"Dalert.EXE")
	SQLDISCONNECT(CON)
ENDIF	
RUN /N Dalert.EXE /unregserver
RUN /N Dalert.EXE /regserver

IF !FILE("u1701a.exe")
	CON=ODBC(6)

	CURSORSETPROP("MapBinary",.T.,0)

	SQLEXEC(CON,"SELECT filename,filedata FROM [update] WHERE filename='u1701a.exe' ","TMP")&&where newid=1
	STRTOFILE(filedata,"u1701a.exe")
	SQLDISCONNECT(CON)

ENDIF
*RUN /N u1701a.EXE
_SCREEN.VISIBLE=.T.


LOCAL lcPath
lcPath = ADDBS(JUSTPATH(SYS(16)))

CURSORSETPROP("MapBinary",.T.,0)&&非常关键
IF !FILE("cubemaster.exe")
	CON=ODBC(6)

	CURSORSETPROP("MapBinary",.T.,0)

	SQLEXEC(CON,"SELECT filename,filedata FROM [update] WHERE filename='cubemaster.exe' ","TMP")&&where newid=1
	STRTOFILE(filedata,"cubemaster.exe")
	SQLDISCONNECT(CON)
ENDIF
*!*	IF !FILE("autolutec.exe")
	CON=ODBC(6)

	CURSORSETPROP("MapBinary",.T.,0)

	SQLEXEC(CON,"SELECT filename,filedata FROM [update] WHERE filename='autolutec.exe' ","TMP")&&where newid=1
	STRTOFILE(filedata,"autolutec.exe")
	SQLDISCONNECT(CON)

*!*	ENDIF

IF !FILE("libhpdf.dll")
	CON=ODBC(6)

	CURSORSETPROP("MapBinary",.T.,0)

	SQLEXEC(CON,"SELECT filename,filedata FROM [update] WHERE filename='libhpdf.dll' ","TMP")&&where newid=1
	STRTOFILE(filedata,"libhpdf.dll")
	SQLDISCONNECT(CON)
ENDIF
IF !FILE("FoxyPreviewer.app")
	CON=ODBC(6)

	CURSORSETPROP("MapBinary",.T.,0)

	SQLEXEC(CON,"SELECT filename,filedata FROM [update] WHERE filename='FoxyPreviewer.app' ","TMP")&&where newid=1
	STRTOFILE(filedata,"FoxyPreviewer.app")
	SQLDISCONNECT(CON)
ENDIF
con=odbc(6)
x=ALLTRIM(SYS(0))+'%'
SQLEXEC(con,"select top 1 username,filename,interid from everyday where id LIKE ?x and editmode='登录' order by 3 desc","tmp")
SQLDISCONNECT(CON)
IF RECCOUNT()<1
	IF FILE("Buys.Mem")
		restore from Buys additive
	ENDIF	
ELSE 
	P_UserCode	=ALLTRIM(filename)
	p_username=LEFT(username,AT('/',username)-1)
ENDIF 
=GetAllProcessID()
LOCATE FOR ALLTRIM(LOWER(pszexefile))='autolutec.exe'
*!*	IF !FOUND() AND p_username<>'应燕蓉'
*!*		Declare Long WinExec In kernel32 String,Long
*!*		=WinExec('autolutec.exe',1) && 启动程序启动真正的程序
*!*	ENDIF 
***** Set Condition of System
SET TALK OFF
SET NULLDISPLAY TO ''
SET EXCL OFF
SET DELE ON
SET HOURS TO 24
SET DATE TO ANSI LONG
SET CENTURY ON
SET EXACT OFF
SET CENTURY TO
SET MULT ON
SET STATUS BAR OFF
SET CLOCK STATUS
SET MESSAGE TO "易飞ERP助手"
SET MULTILOCKS ON
SET NOTIFY CURSOR OFF
SET DECIMALS TO 
SET CONSOLE OFF 
SET COMPATIBLE Off
Cdate=MDY(DATE())
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
SET PATH to class addi
OldPath=SUBSTR(FULLPATH("ERP.EXE"),1,LEN(FULLPATH("ERP.EXE")) - 8)

DIME Ver[1]

AGETFILEVERSION(Ver,"ERP.EXE")

mVer='版本号：'+ALLT(Ver[4])
*****
SET MESSAGE TO " 请用户选择用户名并输入用户密码!"
DO FORM &P_Frms.Login.SCX

DO &P_Others.Main.MPR
DO System.app
*!*	IF mRec=0
*!*		DO FORM &P_Frms.SystemInfo.SCX
*!*	ENDI
SET MESSAGE TO " 当前系统操作员: "+P_USERNAME
DO FORM &P_Frms.MainMenu.SCX
_Screen.WindowState= 0
_Screen.WindowState= 2
*!*	DO FORM &P_Frms.updatehint.SCX

WAIT CLEAR 
READ EVENT
*****	Begin Next file
*****	End of File
