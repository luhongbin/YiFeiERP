VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "IMWatch"
   ClientHeight    =   7800
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   9165
   LinkTopic       =   "Form1"
   ScaleHeight     =   7800
   ScaleWidth      =   9165
   StartUpPosition =   3  '窗口缺省
   Visible         =   0   'False
   Begin VB.CommandButton btnRegApp 
      Caption         =   "注册应用"
      Height          =   375
      Left            =   240
      TabIndex        =   17
      Top             =   3960
      Width           =   1575
   End
   Begin VB.CommandButton btnUnRegApp 
      Caption         =   "注销应用"
      Height          =   375
      Left            =   2475
      TabIndex        =   16
      Top             =   3960
      Width           =   1575
   End
   Begin VB.CommandButton btnStartApp 
      Caption         =   "启动应用"
      Height          =   375
      Left            =   4725
      TabIndex        =   15
      Top             =   3960
      Width           =   1575
   End
   Begin VB.CommandButton btnStopApp 
      Caption         =   "停止应用"
      Height          =   375
      Left            =   6960
      TabIndex        =   14
      Top             =   3960
      Width           =   1575
   End
   Begin VB.TextBox txtResult 
      Height          =   975
      Left            =   240
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   13
      Top             =   5040
      Width           =   8295
   End
   Begin VB.TextBox txtRecvMsg 
      Height          =   1095
      Left            =   240
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   12
      Top             =   6600
      Width           =   8295
   End
   Begin VB.TextBox txtSvrIP 
      Height          =   285
      Left            =   1920
      TabIndex        =   11
      Text            =   "127.0.0.1"
      Top             =   120
      Width           =   2535
   End
   Begin VB.TextBox txtSvrPort 
      Height          =   285
      Left            =   6480
      TabIndex        =   10
      Text            =   "8006"
      Top             =   120
      Width           =   2535
   End
   Begin VB.TextBox txtAppGuid 
      Height          =   285
      Left            =   1920
      TabIndex        =   9
      Top             =   720
      Width           =   2535
   End
   Begin VB.TextBox txtAppName 
      Height          =   285
      Left            =   6480
      TabIndex        =   8
      Text            =   "AppTest1"
      Top             =   720
      Width           =   2535
   End
   Begin VB.TextBox txtAppAction 
      Height          =   285
      Left            =   1920
      TabIndex        =   7
      Text            =   "copy"
      Top             =   1290
      Width           =   2535
   End
   Begin VB.TextBox txtFilterAppName 
      Height          =   285
      Left            =   6480
      TabIndex        =   6
      Text            =   "all"
      Top             =   1290
      Width           =   2535
   End
   Begin VB.TextBox txtFilterRequestType 
      Height          =   285
      Left            =   1920
      TabIndex        =   5
      Text            =   "Tencent.RTX.IM"
      Top             =   1890
      Width           =   2535
   End
   Begin VB.TextBox txtFilterResponseType 
      Height          =   285
      Left            =   6480
      TabIndex        =   4
      Text            =   "none"
      Top             =   1890
      Width           =   2535
   End
   Begin VB.TextBox txtFilterSender 
      Height          =   285
      Left            =   1920
      TabIndex        =   3
      Text            =   "anyone"
      Top             =   2490
      Width           =   2535
   End
   Begin VB.TextBox txtFilterReceiver 
      Height          =   285
      Left            =   6480
      TabIndex        =   2
      Text            =   "anyone"
      Top             =   2490
      Width           =   2535
   End
   Begin VB.TextBox txtFilterReceiverState 
      Height          =   285
      Left            =   1920
      TabIndex        =   1
      Text            =   "anystate"
      Top             =   3090
      Width           =   2535
   End
   Begin VB.TextBox txtFilterKey 
      Height          =   285
      Left            =   6480
      TabIndex        =   0
      Text            =   " "
      Top             =   3090
      Width           =   2535
   End
   Begin VB.Label Label1 
      Caption         =   "RTXApp Server IP："
      Height          =   255
      Left            =   240
      TabIndex        =   31
      Top             =   120
      Width           =   1695
   End
   Begin VB.Label Label2 
      Caption         =   "RTXApp Server Port："
      Height          =   255
      Left            =   4680
      TabIndex        =   30
      Top             =   120
      Width           =   1695
   End
   Begin VB.Label Label3 
      Caption         =   "应用标示："
      Height          =   255
      Left            =   240
      TabIndex        =   29
      Top             =   720
      Width           =   1695
   End
   Begin VB.Label Label4 
      Caption         =   "应用名："
      Height          =   255
      Left            =   4680
      TabIndex        =   28
      Top             =   720
      Width           =   1095
   End
   Begin VB.Label Label5 
      Caption         =   "过滤动作："
      Height          =   255
      Left            =   240
      TabIndex        =   27
      Top             =   1320
      Width           =   1695
   End
   Begin VB.Label Label6 
      Caption         =   "过滤应用名："
      Height          =   255
      Left            =   4680
      TabIndex        =   26
      Top             =   1320
      Width           =   1695
   End
   Begin VB.Label Label7 
      Caption         =   "过滤请求类型："
      Height          =   255
      Left            =   240
      TabIndex        =   25
      Top             =   1920
      Width           =   1695
   End
   Begin VB.Label Label8 
      Caption         =   "过滤回复类型："
      Height          =   255
      Left            =   4680
      TabIndex        =   24
      Top             =   1920
      Width           =   1695
   End
   Begin VB.Label Label9 
      Caption         =   "过滤发送者："
      Height          =   255
      Left            =   240
      TabIndex        =   23
      Top             =   2520
      Width           =   1695
   End
   Begin VB.Label Label10 
      Caption         =   "过滤接收者："
      Height          =   255
      Left            =   4680
      TabIndex        =   22
      Top             =   2520
      Width           =   1695
   End
   Begin VB.Label Label11 
      Caption         =   "过滤接收者状态："
      Height          =   255
      Left            =   240
      TabIndex        =   21
      Top             =   3120
      Width           =   1695
   End
   Begin VB.Label Label12 
      Caption         =   "过滤消息关键字："
      Height          =   255
      Left            =   4680
      TabIndex        =   20
      Top             =   3120
      Width           =   1695
   End
   Begin VB.Label Label13 
      Caption         =   "操作结果："
      Height          =   375
      Left            =   240
      TabIndex        =   19
      Top             =   4680
      Width           =   1335
   End
   Begin VB.Label Label14 
      Caption         =   "收到的消息："
      Height          =   375
      Left            =   240
      TabIndex        =   18
      Top             =   6240
      Width           =   1215
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim WithEvents AppObj As RTXSAPIObj '声明一个Root对象
Attribute AppObj.VB_VarHelpID = -1
Dim RootObj As RTXSAPIRootObj

Private Sub appobj_OnAppStop(ByVal iCode As Long)  '当应用停止时触发该事件

txtResult.Text = "应用停止运行"

End Sub

Private Sub AppObj_OnRecvMessage(ByVal Message As RTXSAPILib.IRTXSAPIMessage) '接收到消息时触发该事件

txtRecvMsg.Text = Message.Sender + "发送" + Message.Content + "到" + Message.Receivers

Set cn = CreateObject("ADODB.Connection")
Connstr = "Driver={SQL Server};PWD=yh***microsoft***;UID=sa;DataBase=trade;Server=192.168.0.2"
cn.Open Connstr

X1 = Trim(Message.Content)
'X5 = Trim(Mid(X1, InStr(1, X1, "&lt;Txt&gt;") + 11, InStr(1, X1, "&lt;/Txt&gt;") - InStr(1, X1, "&lt;Txt&gt;") - 11))
X2 = Trim(Message.Sender)
x3 = Trim(Message.Receivers)
'X4 = Trim(Mid(X1, InStr(1, X1, "Key=""Title"" Type=""String"">") + 26, 100))

If X2 <> "ceo" Then
Set rs = CreateObject("adodb.recordset")
On Error GoTo errorhandler
Set rs = cn.Execute("INSERT INTO mathistory1 (sender,receiver,dtime,talkcontent) values ('" & X2 & "','" & x3 & "',getdate(),'" & X1 & "')")

'rs.Close
'cn.Close
Set rs = Nothing
Set cn = Nothing
errorhandler:
End If
End Sub

Private Sub btnRegApp_Click()

On Error GoTo errorhandler

AppObj.ServerIP = txtSvrIP.Text  '设置服务器地址
AppObj.ServerPort = txtSvrPort.Text ' 设置服务器端口
AppObj.AppGUID = Trim(txtAppGuid.Text) ' 设置应用GUID
AppObj.AppName = txtAppName.Text '设置应用名

If txtAppAction.Text = "copy" Then '设置过滤动作

    AppObj.AppAction = AA_COPY
    
ElseIf txtAppAction.Text = "distill" Then

    AppObj.AppAction = AA_DISTILL
    
Else
    MsgBox "无效过滤动作"
    
    Exit Sub
    
End If

AppObj.FilterAppName = txtFilterAppName.Text  '设置过滤应用名
AppObj.FilterRequestType = txtFilterRequestType.Text '设置过滤消息类型
AppObj.FilterResponseType = txtFilterResponseType.Text '设置消息回复类型
AppObj.FilterSender = txtFilterSender.Text '设置消息发送者
AppObj.FilterReceiver = txtFilterReceiver.Text ' 设置消息接收者
AppObj.FilterReceiverState = txtFilterReceiverState.Text ' 设置消息接收者状态
AppObj.FilterKey = txtFilterKey.Text '设置关键字，当为空时表示过滤所有消息

AppObj.RegisterApp

txtResult.Text = "注册成功"

Exit Sub


errorhandler:

txtResult.Text = "Error # " & Str(Err.Number) & Chr(13) & Err.Description

End Sub

Private Sub btnStartApp_Click()

On Error GoTo errorhandler


AppObj.StartApp "", 4

txtResult.Text = "启动成功"

Exit Sub


errorhandler:

txtResult.Text = "Error # " & Str(Err.Number) & Chr(13) & Err.Description

End Sub

Private Sub btnStopApp_Click()

On Error GoTo errorhandler

AppObj.StopApp

txtResult.Text = "停止成功"

Exit Sub


errorhandler:

txtResult.Text = "Error # " & Str(Err.Number) & Chr(13) & Err.Description

End Sub

Private Sub btnUnRegApp_Click()

On Error GoTo errorhandler


AppObj.UnRegisterApp

txtResult.Text = "注销成功"

Exit Sub


errorhandler:

txtResult.Text = "Error # " & Str(Err.Number) & Chr(13) & Err.Description


End Sub

Private Sub Form_Load()

If App.PrevInstance Then
End
End If

Set RootObj = CreateObject("RTXSAPIRootObj.RTXSAPIRootObj") '创建根对象
Set AppObj = RootObj.CreateAPIObj   '创建应用对象

txtAppGuid.Text = "{9FEF6E5D-136C-4b2c-83A5-25B05FDBAC02}" '设置应用GUID


AppObj.ServerIP = txtSvrIP.Text  '设置服务器地址
AppObj.ServerPort = txtSvrPort.Text ' 设置服务器端口
AppObj.AppGUID = Trim(txtAppGuid.Text) ' 设置应用GUID
AppObj.AppName = txtAppName.Text '设置应用名

If txtAppAction.Text = "copy" Then '设置过滤动作

    AppObj.AppAction = AA_COPY
    
ElseIf txtAppAction.Text = "distill" Then

    AppObj.AppAction = AA_DISTILL
    
Else
    MsgBox "无效过滤动作"
    
    Exit Sub
    
End If

AppObj.FilterAppName = txtFilterAppName.Text  '设置过滤应用名
AppObj.FilterRequestType = txtFilterRequestType.Text '设置过滤消息类型
AppObj.FilterResponseType = txtFilterResponseType.Text '设置消息回复类型
AppObj.FilterSender = txtFilterSender.Text '设置消息发送者
AppObj.FilterReceiver = txtFilterReceiver.Text ' 设置消息接收者
AppObj.FilterReceiverState = txtFilterReceiverState.Text ' 设置消息接收者状态
AppObj.FilterKey = txtFilterKey.Text '设置关键字，当为空时表示过滤所有消息

AppObj.RegisterApp

txtResult.Text = "注册成功"

AppObj.StartApp "", 4


End Sub


