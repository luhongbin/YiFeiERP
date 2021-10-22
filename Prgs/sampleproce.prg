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

FUNCTION CloseDB
LPARAMETERS tcAliasName
IF USED("&tcAliasName")
   SELECT "&tcAliasName"
   USE 
ENDIF
RETURN
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

PROCEDURE everyday
PARA mFile,mId,mEditMode
cmac=getmac()
CPUSER=P_UserName+'/'+ALLTRIM(SYS(0))
CON=ODBC(6)
SQLEXEC(CON,"execute everylog '&CPUSER','&mFile','&mId','&mEditMode'",'&cmac')
SQLDISCONNECT(con)
RETURN 

ENDPROC 