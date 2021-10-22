
PROCEDURE errHandler

   PARAMETER merror, mess, mess1, mprog, mlineno
   ? 'Error number: ' + LTRIM(STR(merror))
   WAIT WINDOWS 'Error message: ' + mess
   ? 'Line of code with error: ' + mess1
   ? 'Line number of error: ' + LTRIM(STR(mlineno))
   ? 'Program with error: ' + mprog
	WAIT WINDOWS 'Line of code with error: ' + mess1
ENDPROC

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
ENDFUNC
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
FUNCTION GetServerDate
	CON5=ODBC(5)
	llReturn=SQLEXEC(CON5,"SELECT Getdate() AS GetSeverDate")
	SQLDISCONNECT(CON5)
	RETURN GetSeverDate
ENDFUNC 
***** Begin of ODBC
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

PROCEDURE maxinteridt
	PARAMETERS TABLENAME

	CON5=ODBC(6)
	SQLEXEC(CON5,"SELECT id  FROM sixplusone..tablemaxid WHERE UPPER(tablename)=UPPER('&TABLENAME')" ,'tempinsert')
	SELECT tempinsert
	T=tempinsert.ID
	IF YEAR(DATE())*1000000+MONTH(DATE())*10000>T
		P_ChkBill=YEAR(DATE())*1000000+MONTH(DATE())*10000
		CKEYID=STR(P_ChkBill)
		SQLEXEC(con5,"UPDATE sixplusone..tablemaxid SET id='&CKEYID' WHERE UPPER(tablename)=UPPER('&TABLENAME') ")
	ELSE
		P_ChkBill=T
		CKEYID=STR(P_ChkBill+1)
		SQLEXEC(con5,"UPDATE sixplusone..tablemaxid SET id='&CKEYID' WHERE UPPER(tablename)=UPPER('&TABLENAME') ")
	ENDIF
	IF USED("tempinsert")
		SELECT tempinsert
		USE
	ENDIF	
	SQLDISCONNECT(con5)
	RETURN P_ChkBill
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


*!*	?'CPU序号：',lcCPUID  
*!*	?'硬盘序号：',lcHDID  
*!*	?'网卡MAC地址：',LcMAC
PROCEDURE PROCerrOR
	PARAMETER errnum,MESSAGE
	IF  (ALLTRIM(STR(errnum)))="125"
		RELE WINDOW
		RETU
	ENDIF
ENDPROC


Function VerifyEmail(tcAddress)
     Local oReg as vbscript.regexp
     oReg = NewObject('vbscript.regexp')
     oReg.Pattern = '^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$'
     Return oReg.Test(tcAddress)
EndFunc


FUNCTION   GetAllProcessID   (   lpProcTable   )   
	lpProcTable   =   IIF(PARAMETERS()=1   AND   TYPE([lpProcTable])=[C],   lpProcTable,   [AllProclists]   )   
	DECLARE   INTEGER   CreateToolhelp32Snapshot   IN   kernel32   INTEGER   lFlags,   INTEGER   lProcessID   
	DECLARE   INTEGER   Process32First   IN   kernel32   INTEGER   hSnapShot,   STRING   @PROCESSENTRY32_uProcess   
	DECLARE   INTEGER   Process32Next   IN   kernel32   INTEGER   hSnapShot,   STRING   @PROCESSENTRY32_uProcess   
	DECLARE   INTEGER   CloseHandle   IN   kernel32   INTEGER   hObject   
	DECLARE   INTEGER   GetLastError   IN   kernel32   
	    
	CREA   CURSOR   (lpProcTable)   (PdwSize   N(3),   PcntUsage   N(12),   ;   
	Pth32ProcessID   N(12),   Pth32DefaultHeapID   N(12),   ;   
	Pth32ModuleID   N(12),   PcntThreads   N(12),   ;   
	Pth32ParentProcessID   N(12),   PpcPriClassBase   N(3),   ;   
	PdwFlags   N(3),   PszExeFile   C(254)   )   
	lnHand   =   0   
	lnHand   =   CreateToolhelp32Snapshot(3,0)   
	IF   lnHand>0   
	dwSize   =   Num2Dword(296)   
	cntUsage   =   Num2Dword(0)   
	th32ProcessID   =   Num2Dword(0)   
	th32DefaultHeapID   =   Num2Dword(0)   
	th32ModuleID   =   Num2Dword(0)   
	cntThreads   =   Num2Dword(0)   
	th32ParentProcessID   =   Num2Dword(0)   
	pcPriClassBase   =   Num2Dword(0)   
	dwFlags   =   Num2Dword(0)   
	szExeFile   =   REPLI(CHR(0),   260)   
	lcTitle   =   dwSize   +   cntUsage   +   th32ProcessID   +   th32DefaultHeapID   ;   
	+   th32ModuleID   +   cntThreads   +   th32ParentProcessID   ;   
	+   pcPriClassBase   +   dwFlags   +   szExeFile   
	IF   Process32First(lnHand,@lcTitle)   >   0     &&   第一个进程是   kernel32.dll，没必要列出   
	DO   WHILE   Process32Next(lnHand,@lcTitle)>   0   
	INSERT   INTO   (lpProcTable)   (PdwSize,   PcntUsage,   Pth32ProcessID,   Pth32DefaultHeapID,   ;   
	Pth32ModuleID,   PcntThreads,   Pth32ParentProcessID,   ;   
	PpcPriClassBase,   PdwFlags,   PszExeFile)   ;   
	VALUES   (   ;   
	Dword2Num(SUBSTR(lcTitle,   1,4)),   ;   
	Dword2Num(SUBSTR(lcTitle,   5,4)),   ;   
	Dword2Num(SUBSTR(lcTitle,   9,4)),   ;   
	Dword2Num(SUBSTR(lcTitle,13,4)),   ;   
	Dword2Num(SUBSTR(lcTitle,17,4)),   ;   
	Dword2Num(SUBSTR(lcTitle,21,4)),   ;   
	Dword2Num(SUBSTR(lcTitle,25,4)),   ;   
	Dword2Num(SUBSTR(lcTitle,29,4)),   ;   
	Dword2Num(SUBSTR(lcTitle,33,4)),   ;   
	SUBSTR(SUBSTR(lcTitle,   37),   1,   AT(CHR(0),SUBSTR(lcTitle,   37))-1)   )   
	ENDDO   
	ENDIF   
	=   CloseHandle(lnHand)   
	RETURN   .T.   
	ELSE   
	RETURN   .F.   
	ENDIF   
ENDFUNC   
FUNCTION   Num2Dword   (   lpnNum   )   
DECLARE   INTEGER   RtlMoveMemory   IN   kernel32   AS   RtlCopyDword   STRING   @pDeststring,   INTEGER   @pVoidSource,   INTEGER   nLength   
lcDword   =   SPACE(4)   
=   RtlCopyDword(@lcDword,   BITOR(lpnNum,0),   4)   
RETURN   lcDword   
ENDFUNC   
    
FUNCTION   Dword2Num   (   tcDword   )   
DECLARE   INTEGER   RtlMoveMemory   IN   kernel32   AS   RtlCopyNum   INTEGER   @DestNumeric,   STRING   @pVoidSource,   INTEGER   nLength   
lnNum   =   0   
=RtlCopyNum(@lnNum,   tcDword,   8)   
RETURN   lnNum   
ENDFUNC   

PROCEDURE stopit
	MEXIT=2
	WAIT WINDOWS '正在退出，稍后....'
	Declare keybd_event In Win32API Short bVk,Short bScan,Integer dwFlags, Integer deExtraInfo
	keybd_event(17, 0, 0, 0)
	keybd_event(18, 0, 0, 0)
	keybd_event(Asc('D'), 0, 0, 0)
	keybd_event(Asc('D'), 0, 2, 0)
	keybd_event(17, 0, 2, 0)
	keybd_event(18, 0, 2, 0)
	RUN /N reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f
	RUN /N7 ipconfig /flushdns
ENDPROC 
Function URLdecode
PARAMETER pcInStr
*  ' unencode EVERY %XX
*  ' (keep track of current position so you don't unencode
*  '  a percent that just came out of an URLencoded char
LOCAL I, tStr, tChr, tOut
  tStr = pcInStr
  tOut = ""
  tStr = StrTran(tStr, "+", " ")
  I = 1
  do While I <= Len(tStr)
    If (SubStr(tStr, I, 1) = "%") ;
       And SubStr(tStr, I + 1, 1) $ "0123456789ABCDEF" ;
       And SubStr(tStr, I + 2, 1) $ "0123456789ABCDEF" 
      tChr = (( At( SubStr(tStr, I + 1, 1), "0123456789ABCDEF" )-1) * 16 ) ;
           + (( At( SubStr(tStr, I + 2, 1), "0123456789ABCDEF" )-1)      ) 
      I = I + 2
*03/18/03 Zero's are now allowed.      
      if between(tChr,0,255) && 03/18/03
*      if tChr > 0 and tChr < 255
        tOut = tOut + chr( tChr )
      endif
    else
      tOut = tOut + SubStr(tStr, I, 1)
    EndIf
    I = I + 1
  EndDo
RETURN tOut