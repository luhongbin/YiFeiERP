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
   StartUpPosition =   3  '����ȱʡ
   Visible         =   0   'False
   Begin VB.CommandButton btnRegApp 
      Caption         =   "ע��Ӧ��"
      Height          =   375
      Left            =   240
      TabIndex        =   17
      Top             =   3960
      Width           =   1575
   End
   Begin VB.CommandButton btnUnRegApp 
      Caption         =   "ע��Ӧ��"
      Height          =   375
      Left            =   2475
      TabIndex        =   16
      Top             =   3960
      Width           =   1575
   End
   Begin VB.CommandButton btnStartApp 
      Caption         =   "����Ӧ��"
      Height          =   375
      Left            =   4725
      TabIndex        =   15
      Top             =   3960
      Width           =   1575
   End
   Begin VB.CommandButton btnStopApp 
      Caption         =   "ֹͣӦ��"
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
      Caption         =   "RTXApp Server IP��"
      Height          =   255
      Left            =   240
      TabIndex        =   31
      Top             =   120
      Width           =   1695
   End
   Begin VB.Label Label2 
      Caption         =   "RTXApp Server Port��"
      Height          =   255
      Left            =   4680
      TabIndex        =   30
      Top             =   120
      Width           =   1695
   End
   Begin VB.Label Label3 
      Caption         =   "Ӧ�ñ�ʾ��"
      Height          =   255
      Left            =   240
      TabIndex        =   29
      Top             =   720
      Width           =   1695
   End
   Begin VB.Label Label4 
      Caption         =   "Ӧ������"
      Height          =   255
      Left            =   4680
      TabIndex        =   28
      Top             =   720
      Width           =   1095
   End
   Begin VB.Label Label5 
      Caption         =   "���˶�����"
      Height          =   255
      Left            =   240
      TabIndex        =   27
      Top             =   1320
      Width           =   1695
   End
   Begin VB.Label Label6 
      Caption         =   "����Ӧ������"
      Height          =   255
      Left            =   4680
      TabIndex        =   26
      Top             =   1320
      Width           =   1695
   End
   Begin VB.Label Label7 
      Caption         =   "�����������ͣ�"
      Height          =   255
      Left            =   240
      TabIndex        =   25
      Top             =   1920
      Width           =   1695
   End
   Begin VB.Label Label8 
      Caption         =   "���˻ظ����ͣ�"
      Height          =   255
      Left            =   4680
      TabIndex        =   24
      Top             =   1920
      Width           =   1695
   End
   Begin VB.Label Label9 
      Caption         =   "���˷����ߣ�"
      Height          =   255
      Left            =   240
      TabIndex        =   23
      Top             =   2520
      Width           =   1695
   End
   Begin VB.Label Label10 
      Caption         =   "���˽����ߣ�"
      Height          =   255
      Left            =   4680
      TabIndex        =   22
      Top             =   2520
      Width           =   1695
   End
   Begin VB.Label Label11 
      Caption         =   "���˽�����״̬��"
      Height          =   255
      Left            =   240
      TabIndex        =   21
      Top             =   3120
      Width           =   1695
   End
   Begin VB.Label Label12 
      Caption         =   "������Ϣ�ؼ��֣�"
      Height          =   255
      Left            =   4680
      TabIndex        =   20
      Top             =   3120
      Width           =   1695
   End
   Begin VB.Label Label13 
      Caption         =   "���������"
      Height          =   375
      Left            =   240
      TabIndex        =   19
      Top             =   4680
      Width           =   1335
   End
   Begin VB.Label Label14 
      Caption         =   "�յ�����Ϣ��"
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
Dim WithEvents AppObj As RTXSAPIObj '����һ��Root����
Attribute AppObj.VB_VarHelpID = -1
Dim RootObj As RTXSAPIRootObj

Private Sub appobj_OnAppStop(ByVal iCode As Long)  '��Ӧ��ֹͣʱ�������¼�

txtResult.Text = "Ӧ��ֹͣ����"

End Sub

Private Sub AppObj_OnRecvMessage(ByVal Message As RTXSAPILib.IRTXSAPIMessage) '���յ���Ϣʱ�������¼�

txtRecvMsg.Text = Message.Sender + "����" + Message.Content + "��" + Message.Receivers

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

AppObj.ServerIP = txtSvrIP.Text  '���÷�������ַ
AppObj.ServerPort = txtSvrPort.Text ' ���÷������˿�
AppObj.AppGUID = Trim(txtAppGuid.Text) ' ����Ӧ��GUID
AppObj.AppName = txtAppName.Text '����Ӧ����

If txtAppAction.Text = "copy" Then '���ù��˶���

    AppObj.AppAction = AA_COPY
    
ElseIf txtAppAction.Text = "distill" Then

    AppObj.AppAction = AA_DISTILL
    
Else
    MsgBox "��Ч���˶���"
    
    Exit Sub
    
End If

AppObj.FilterAppName = txtFilterAppName.Text  '���ù���Ӧ����
AppObj.FilterRequestType = txtFilterRequestType.Text '���ù�����Ϣ����
AppObj.FilterResponseType = txtFilterResponseType.Text '������Ϣ�ظ�����
AppObj.FilterSender = txtFilterSender.Text '������Ϣ������
AppObj.FilterReceiver = txtFilterReceiver.Text ' ������Ϣ������
AppObj.FilterReceiverState = txtFilterReceiverState.Text ' ������Ϣ������״̬
AppObj.FilterKey = txtFilterKey.Text '���ùؼ��֣���Ϊ��ʱ��ʾ����������Ϣ

AppObj.RegisterApp

txtResult.Text = "ע��ɹ�"

Exit Sub


errorhandler:

txtResult.Text = "Error # " & Str(Err.Number) & Chr(13) & Err.Description

End Sub

Private Sub btnStartApp_Click()

On Error GoTo errorhandler


AppObj.StartApp "", 4

txtResult.Text = "�����ɹ�"

Exit Sub


errorhandler:

txtResult.Text = "Error # " & Str(Err.Number) & Chr(13) & Err.Description

End Sub

Private Sub btnStopApp_Click()

On Error GoTo errorhandler

AppObj.StopApp

txtResult.Text = "ֹͣ�ɹ�"

Exit Sub


errorhandler:

txtResult.Text = "Error # " & Str(Err.Number) & Chr(13) & Err.Description

End Sub

Private Sub btnUnRegApp_Click()

On Error GoTo errorhandler


AppObj.UnRegisterApp

txtResult.Text = "ע���ɹ�"

Exit Sub


errorhandler:

txtResult.Text = "Error # " & Str(Err.Number) & Chr(13) & Err.Description


End Sub

Private Sub Form_Load()

If App.PrevInstance Then
End
End If

Set RootObj = CreateObject("RTXSAPIRootObj.RTXSAPIRootObj") '����������
Set AppObj = RootObj.CreateAPIObj   '����Ӧ�ö���

txtAppGuid.Text = "{9FEF6E5D-136C-4b2c-83A5-25B05FDBAC02}" '����Ӧ��GUID


AppObj.ServerIP = txtSvrIP.Text  '���÷�������ַ
AppObj.ServerPort = txtSvrPort.Text ' ���÷������˿�
AppObj.AppGUID = Trim(txtAppGuid.Text) ' ����Ӧ��GUID
AppObj.AppName = txtAppName.Text '����Ӧ����

If txtAppAction.Text = "copy" Then '���ù��˶���

    AppObj.AppAction = AA_COPY
    
ElseIf txtAppAction.Text = "distill" Then

    AppObj.AppAction = AA_DISTILL
    
Else
    MsgBox "��Ч���˶���"
    
    Exit Sub
    
End If

AppObj.FilterAppName = txtFilterAppName.Text  '���ù���Ӧ����
AppObj.FilterRequestType = txtFilterRequestType.Text '���ù�����Ϣ����
AppObj.FilterResponseType = txtFilterResponseType.Text '������Ϣ�ظ�����
AppObj.FilterSender = txtFilterSender.Text '������Ϣ������
AppObj.FilterReceiver = txtFilterReceiver.Text ' ������Ϣ������
AppObj.FilterReceiverState = txtFilterReceiverState.Text ' ������Ϣ������״̬
AppObj.FilterKey = txtFilterKey.Text '���ùؼ��֣���Ϊ��ʱ��ʾ����������Ϣ

AppObj.RegisterApp

txtResult.Text = "ע��ɹ�"

AppObj.StartApp "", 4


End Sub


