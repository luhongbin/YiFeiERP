*
* VFP写的抓取网络数据包（应用层）。
* 可以获取收发数据的IP、端口和大小。
* 显示IP端口关联的进程。
* 显示收发数据包内容，直观请求和应答情况。
*
#DEFINE WM_SOCKET    0x400 + 100

DECLARE LONG WSAGetLastError IN "Ws2_32"
DECLARE LONG WSAStartup IN "Ws2_32" LONG, STRING@
DECLARE LONG WSACleanup IN "Ws2_32"
DECLARE LONG socket IN "Ws2_32" LONG, LONG, LONG 
DECLARE LONG closesocket IN "Ws2_32" LONG
DECLARE LONG WSAAsyncSelect IN "Ws2_32" LONG, LONG, LONG, LONG
DECLARE LONG bind IN "Ws2_32" AS _bind LONG, STRING@, LONG
DECLARE LONG recv IN "Ws2_32" LONG, STRING@, LONG, LONG 
DECLARE LONG inet_addr IN "Ws2_32" STRING@
DECLARE LONG inet_ntoa IN "Ws2_32" LONG
DECLARE LONG htons IN "Ws2_32" LONG
DECLARE LONG ntohs IN "Ws2_32" LONG
DECLARE LONG setsockopt IN "Ws2_32" LONG, LONG, LONG, LONG@, LONG
DECLARE LONG ioctlsocket IN "Ws2_32" LONG, LONG, LONG@

DECLARE LONG CreateToolhelp32Snapshot IN Kernel32 LONG, LONG
DECLARE LONG Process32First IN Kernel32 LONG, STRING@
DECLARE LONG Process32Next IN Kernel32 LONG, STRING@
DECLARE LONG CloseHandle IN Kernel32 LONG
DECLARE LONG GetExtendedTcpTable IN "Iphlpapi.dll" STRING@, LONG@, LONG, LONG, LONG, LONG
DECLARE LONG GetExtendedUdpTable IN "Iphlpapi.dll" STRING@, LONG@, LONG, LONG, LONG, LONG

ON ERROR _OnError(ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO())
_SCREEN.Visible = .F.
SET TALK OFF
SET SAFETY OFF
CLEAR

CREATE CURSOR PCAP (发送IP C(16), 发送端口 I, 接收IP C(16), 接收端口 I, 协议 C(4), 大小 I,;
                    进程ID I, 进程文件名 C(50), 数据包 M) 

PUBLIC oForm
oForm = NEWOBJECT("WSockPCap")
oForm.Show
READ EVENTS
CLOSE DATABASES
CLEAR DLLS
_SCREEN.Visible = .T.
ON ERROR
RETURN


DEFINE CLASS WSockPCap As Form
    Width = 800
    Height = 600
    Desktop = .T.
    ShowWindow = 2
    WindowType = 1
    AutoCenter = .T.
    AlwaysOnTop = .T.
    BorderStyle = 0
    
    szFilterSourIP = ""
    szFilterDestIP = ""
    nSelStart = 0
    
    Add Object Command1 As CommandButton WITH Top=5, Left=10,  Width=50, Height=25, Caption="启动"
    Add Object Command2 As CommandButton WITH Top=5, Left=65,  Width=50, Height=25, Caption="清屏"
    Add Object Command3 As CommandButton WITH Top=5, Left=120, Width=50, Height=25, Caption="关闭"
    Add Object Label1 As Label WITH Top=12, Left=180, AutoSize=.T.,;
        Caption="本端：IP                    端口"
    Add Object Text1 As TextBox WITH Top=8, Left=230, Width=110, Height=20
    Add Object Text2 As TextBox WITH Top=8, Left=372, Width=50,  Height=20, value=1314
    Add Object Checkbox1 As Checkbox WITH Top=11, Left=432, Height=20, AutoSize=.T.,;
        Caption="OnTop", Value=1
    Add Object Label2 As Label WITH Top=12, Left=500, AutoSize=.T., Caption=""
    Add Object Grid1 As Grid WITH Top=35, Left=10, Width=780, Height=292,;
        AllowCellSelection=.F., DeleteMark=.F., RecordMark=.F., ScrollBars=2,;
        RecordSourceType=1, RecordSource="PCAP"
    Add Object Edit1 As EditBox WITH Top=334, Left=10,  Width=385, Height=260
    Add Object Edit2 As EditBox WITH Top=334, Left=405, Width=385, Height=260
    
    Add Object SocketCap1 As SocketCap
        
    PROCEDURE Init
        LOCAL oIPs
        BINDEVENT(this.hWnd, WM_SOCKET, this.SocketCap1, "_SocketMsg")

        oIPs = GETOBJECT('winmgmts:')
        oIPs = oIPs.InstancesOf('Win32_NetworkAdapterConfiguration')
        FOR EACH oIP IN oIPs
            IF oIP.IPEnabled
                this.Text1.Value = oIP.IPAddress[0]
                EXIT
            ENDIF
        ENDFOR
        
        this._WriteMsg("双击表格切换监听选择")
        thisform.Grid1.SetFocus
    ENDPROC
    
    PROCEDURE Unload
        CLEAR EVENTS
    ENDPROC
    
    PROCEDURE Checkbox1.InteractiveChange
        thisform.AlwaysOnTop = (this.Value == 1)
    ENDPROC
    
    PROCEDURE Command1.Click
        IF this.Caption == "启动"
            LOCAL szRet
            szRet = thisform.SocketCap1._Start(thisform.hWnd,;
                                               ALLTRIM(thisform.Text1.Value),;
                                               thisform.Text2.Value)
            thisform._WriteMsg(szRet)
        
            IF szRet == "启动成功"
                this.Caption = "停止"
            ENDIF
        ELSE
            thisform.SocketCap1._CloseSocket()
            this.Caption = "启动"
        ENDIF
    ENDPROC

    PROCEDURE Command2.Click
        ZAP IN "PCAP"
        thisform.Grid1.Refresh
        thisform.Edit1.Value = ""
        thisform.Edit2.Value = ""
    ENDPROC

    PROCEDURE Command3.Click
        thisform.Release
    ENDPROC
    
    PROCEDURE Grid1.Click
        LOCAL szPack, szChr, szTxt, szHex
        szPack = PCAP.数据包
        szTxt  = ""
        szHex  = ""
        
        FOR i = 1 TO LEN(szPack)
            szChr = SUBSTR(szPack, i, 1)
            szHex = szHex + STRCONV(szChr, 15) + " "
            szTxt = szTxt + IIF((ASC(szChr) < 0x20) AND !INLIST(szChr, 0h09, 0h0D, 0h0A),;
                                ".", szChr)  && “.”表示非打印字符
        ENDFOR
        
        thisform.Edit1.Value = szHex
        thisform.Edit2.Value = szTxt
        thisform.Edit1.Refresh
        thisform.Edit2.Refresh
        thisform.Edit2.Tag = ""
        this.SetFocus
    ENDPROC

    PROCEDURE Grid1.KeyPress
        LPARAMETERS nKeyCode, nShiftAltCtrl
        DoDefault(nKeyCode, nShiftAltCtrl)    && 先执行键盘动作
        NoDefault        
        IF BETWEEN(nKeyCode, 5, 24)
            this.Click
        ENDIF
    ENDPROC
    
    PROCEDURE Grid1.DblClick
        IF EMPTY(thisform.szFilterSourIP)
            thisform.szFilterSourIP = RTRIM(PCAP.发送IP)
            thisform.szFilterDestIP = RTRIM(PCAP.接收IP)
            thisform.Label2.Caption = "监听：发送 " + thisform.szFilterSourIP;
                                        + "，接收 " + thisform.szFilterDestIP
        ELSE
            thisform.szFilterSourIP = ""
            thisform.szFilterDestIP = ""
            thisform.Label2.Caption = ""
        ENDIF
    ENDPROC
    
    PROCEDURE Edit2.Click
        thisform.nSelStart = this.SelStart    && 暂存Edit2点击位置
    ENDPROC
        
    PROCEDURE Edit2.DblClick
        this.SelStart  = thisform.nSelStart           && 恢复Edit2起点位置
        this.SelLength = 0                            && 取消Edit2选块
        thisform.Edit1.SelStart  = this.SelStart * 3  && 相对定位Edit1位置
        thisform.Edit1.SelLength = 2                  && 选块一个字符
        thisform.Edit1.SetFocus
    ENDPROC
    
    PROCEDURE Edit2.RightClick
        this.Tag = IIF(this.Tag == "1", "", "1")
        IF this.Tag == "1"
            this.Value = STRCONV(this.Value, 11)
        ELSE
            thisform.Grid1.Click
        ENDIF
    ENDPROC

    PROCEDURE _WriteMsg
        LPARAMETERS szMsg
        this.Edit1.Value = this.Edit1.Value + 0h0D0A + szMsg
        this.Edit1.SelStart = LEN(this.Edit1.Text)
        this.Edit1.SelLength = 0
    ENDPROC
        
    PROCEDURE SocketCap1._OnRead
        LPARAMETERS szReadBuf, nDataLen
        LOCAL bProtocol, nHeadLen
        
        bProtocol  = CTOBIN(SUBSTR(szReadBuf, 10, 1), "1RS")
        
        IF !INLIST(bProtocol, 6, 17)
            RETURN    && 在此只考虑TCP和UDP
        ENDIF

        nHeadLen = IIF(bProtocol == 6, 40, 28)    && IP协议头大小
        nDataLen = nDataLen - nHeadLen            && 数据包大小

        IF nDataLen < 1
            RETURN    && 空包
        ENDIF
        
            * 取收发IP端口数据
        LOCAL szProtocol, nIP, szSourIP, szDestIP, nSourPort, nDestPort,;
              nRecno, szLocalAddr, nPID, szExeFile
        
        szProtocol = IIF(bProtocol == 6, "TCP", "UDP")
        
        nIP       = CTOBIN(SUBSTR(szReadBuf, 13, 4), "4RS")
        szSourIP  = SYS(2600, inet_ntoa(nIP), 16)
        szSourIP  = LEFT(szSourIP, AT(0h00, szSourIP)-1)
        
        nIP       = CTOBIN(SUBSTR(szReadBuf, 17, 4), "4RS")
        szDestIP  = SYS(2600, inet_ntoa(nIP), 16)
        szDestIP  = LEFT(szDestIP, AT(0h00, szDestIP)-1)
        
        IF (!EMPTY(thisform.szFilterSourIP) AND !(szSourIP == thisform.szFilterSourIP)) OR ;
           (!EMPTY(thisform.szFilterDestIP) AND !(szDestIP == thisform.szFilterDestIP))
            RETURN    && 不是要监听的IP
        ENDIF
        
        nSourPort = ntohs(CTOBIN(SUBSTR(szReadBuf, 21, 2), "2RS"))
        nDestPort = ntohs(CTOBIN(SUBSTR(szReadBuf, 23, 2), "2RS"))
        
            * 取本地IP端口关系的进程ID和文件名
        nPID        = 0
        szExeFile   = ""
        szLocalAddr = ALLTRIM(thisform.Text1.Value)
        
        IF (szSourIP == szLocalAddr)
            nPID = PortToPid(szSourIP, nSourPort, szProtocol)
        ELSE
            IF (szDestIP == szLocalAddr)
                nPID = PortToPid(szDestIP, nDestPort, szProtocol)
            ENDIF
        ENDIF
        
        IF nPID > 0
            szExeFile = PidToFileName(nPID)
        ENDIF
        
            * 写入数据表
        szReadBuf = RIGHT(szReadBuf, nDataLen)
        nRecno    = RECNO("PCAP")
        INSERT INTO PCAP VALUES (szSourIP, nSourPort, szDestIP, nDestPort, szProtocol,;
                                 nDataLen, nPID, szExeFile, szReadBuf)
        GO nRecno IN "PCAP"
        thisform.Grid1.SetFocus    &&Refresh
    ENDPROC
ENDDEFINE


DEFINE CLASS SocketCap AS Session
    hWnd    = 0
    hSocket = 0

    PROCEDURE Destroy
         this._CloseSocket()
    ENDPROC

    PROCEDURE _CloseSocket
        closesocket(this.hSocket)
        WSACleanup()
    ENDPROC

    PROCEDURE _Start
        LPARAMETERS hWnd, szIP, nPort
        LOCAL stWsaData, stSockAddr, bflag, dwValue, nError
        this.hWnd = hWnd
        this._CloseSocket()
        
        stWsaData  = REPLICATE(0h00, 398)
        WSAStartup(0x101, @stWsaData)
            * socket的SOCK_RAW套接字类型在Win8要受权，估计Win7也有要受权。
        this.hSocket = socket(2, 3, 0)    && AF_INET, SOCK_RAW, IPPROTO_IP

        IF this.hSocket == BITNOT(0)      && INVALID_SOCKET, (NOT 0)  
            nError = WSAGetLastError()
            IF  nError == 10013
                RETURN "因权限被拒，可尝试以管理员身份运行。"
            ELSE
                RETURN "socket error: " + TRANSFORM(nError)
            ENDIF
        ENDIF

        * 设置套接口的选项，其中flag为ture，对IP头进行处理  
        bflag = 1    && .T.
        IF setsockopt(this.hSocket,;
                      0,;         && IPPROTO_IP
                      2,;         && IP_HDRINCL
                      @bflag,;    && true 
                      4;          && DWORD类型长度
                      ) == -1
                      
            RETURN "setsockopt error: " + TRANSFORM(WSAGetLastError())
        ENDIF

        IF WSAAsyncSelect(this.hSocket, this.hWnd, WM_SOCKET, 63) == -1    && FD_ALL 63
            RETURN "WSAAsyncSelect error: " + TRANSFORM(WSAGetLastError())
        ENDIF
        
        stSockAddr = BINTOC(2, '2RS');                   && sin_family
                   + BINTOC(htons(nPort), '2RS');        && sin_port
                   + BINTOC(inet_addr(@szIP), '4RS');    && sin_addr
                   + REPLICATE(0h00, 8)
    
        IF _bind(this.hSocket, @stSockAddr, LEN(stSockAddr)) == -1    && SOCKET_ERROR
            RETURN "bind error: " + TRANSFORM(WSAGetLastError())
        ENDIF

        dwValue = 1
            * Socket2的WSAIoctl()在Win8调用出现异常（997）?
            * 只好继续用Socket1的ioctlsocket()
        IF ioctlsocket(this.hSocket,;
                       0x98000001,;        && SIO_RCVALL，接收所有的IP包
                       @dwValue;           && 1-执行，0-取消
                       ) == -1
            RETURN "ioctlsocket error: " + TRANSFORM(WSAGetLastError())
        ENDIF
        
        RETURN "启动成功"
    ENDPROC

    PROCEDURE _OnRead
        LPARAMETERS szReadBuf, nDataLen
    ENDPROC

    * 网络消息处理
    PROCEDURE _SocketMsg
        LPARAMETERS hWnd, Msg, wParam, lParam
        LOCAL szReadBuf, nDataLen
        szReadBuf = SPACE(32768)                    && 32 * 1024
        nDataLen  = recv(this.hSocket, @szReadBuf, LEN(szReadBuf), 0)
        IF nDataLen > 0
            szReadBuf = LEFT(szReadBuf, nDataLen)
            this._OnRead(szReadBuf, nDataLen)       && 触发_OnRead事件 
        ENDIF
    ENDPROC
ENDDEFINE


* 返回IP端口关联的进程ID
FUNCTION PortToPid(szIP, nPort, szProtocol)
    LOCAL dwSize, stTable, nTableCount, dwLocalAddr, dwLocalPort, dwOwningPid,;
          szLocalAddr
          
    dwOwningPid = 0
    dwSize      = 0
    
        * 第一次调用GetExtendedTcpTable获取数据空间（dwSize）的大小
    IF szProtocol == "TCP"
        GetExtendedTcpTable(NULL, @dwSize, 1, 2, 5, 0)    && TCP_TABLE_OWNER_PID_ALL
    ELSE
        GetExtendedUdpTable(NULL, @dwSize, 1, 2, 1, 0)    && UDP_TABLE_OWNER_PID
    ENDIF
                            
    IF dwSize > 0
        stTable = REPLICATE(0h0, dwSize)    && 分配数据空间
        
            * 第二次调用GetExtendedTcpTable获取数据
        IF szProtocol == "TCP"
            GetExtendedTcpTable(@stTable, @dwSize, 1, 2, 5, 0)
        ELSE
            GetExtendedUdpTable(@stTable, @dwSize, 1, 2, 1, 0)
        ENDIF
            
        nTableCount = CTOBIN(SUBSTR(stTable, 1, 4), "4RS")    && 数据结构体的数目
    
        IF nTableCount > 0
            stTable = STUFF(stTable, 1, 4, "")                && 到第一个数据表首
        
            FOR i = 1 TO nTableCount
                IF szProtocol == "TCP"
                    dwLocalAddr = CTOBIN(SUBSTR(stTable,  5, 4), "4RS")        && 本地IP
                    dwLocalPort = ntohs(CTOBIN(SUBSTR(stTable,  9, 4), "4RS")) && 本地端口
                    dwOwningPid = CTOBIN(SUBSTR(stTable, 21, 4), "4RS")        && 进程ID
                    stTable = STUFF(stTable, 1, 24, "")       && 到下一个TCP数据表首 
                ELSE
                    dwLocalAddr = CTOBIN(SUBSTR(stTable,  1, 4), "4RS")
                    dwLocalPort = ntohs(CTOBIN(SUBSTR(stTable,  5, 4), "4RS"))
                    dwOwningPid = CTOBIN(SUBSTR(stTable, 9, 4), "4RS")
                    stTable = STUFF(stTable, 1, 12, "")       && 到下一个UDP数据表首 
                ENDIF
                                    
                szLocalAddr = SYS(2600, inet_ntoa(dwLocalAddr), 16)
                szLocalAddr = LEFT(szLocalAddr, AT(0h00, szLocalAddr)-1)
                
                IF (szLocalAddr == szIP) AND (dwLocalPort == nPort)
                    EXIT
                ENDIF
            ENDFOR
        ENDIF
    ENDIF
    
    RETURN dwOwningPid
ENDFUNC


* 返回进程ID关联的进程文件名
FUNCTION PidToFileName(nPID)
    LOCAL stPROCESSENTRY32, hSnapshot, nRet, szExeFile
    
    szExeFile = ""
    stPROCESSENTRY32 = BINTOC(296, "4RS") + REPLICATE(0h0, 292)
    hSnapshot = CreateToolhelp32Snapshot(2, 0)             && TH32CS_SNAPPROCESS
    nRet = Process32First(hSnapshot, @stPROCESSENTRY32)    && 第一个进程 

    DO WHILE nRet > 0
        IF CTOBIN(SUBSTR(stPROCESSENTRY32, 9, 4), "4RS") == nPID
            szExeFile = SUBSTR(stPROCESSENTRY32, 37, 260)
            szExeFile = LEFT(szExeFile, AT(0h00, szExeFile)-1)
            EXIT
        ENDIF
        nRet = Process32Next(hSnapshot, @stPROCESSENTRY32) && 下一个进程 
    ENDDO

    CloseHandle(hSnapshot)
    RETURN szExeFile
ENDFUNC


FUNCTION _OnError(nErrNum, szErrMsg, szErrCode, szErrProgram, nErrLineNo)
    LOCAL szMsg, nRet
    
    szMsg = '错误信息: ' + szErrMsg           + 0h0D0D;
          + '错误编号: ' + TRANSFORM(nErrNum) + 0h0D0D;
          + '错误代码: ' + szErrCode          + 0h0D0D;
          + '出错程序: ' + szErrProgram       + 0h0D0D;
          + '出错行号: ' + TRANSFORM(nErrLineNo)

    nRet = MESSAGEBOX(szMsg, 2+48+512, "Error")

    DO CASE
    CASE nRet == 3            && 终止
        CANCEL
    CASE nRet == 4            && 重试
        RETRY
    ENDCASE
ENDFUNC