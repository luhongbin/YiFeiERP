Public _Form1
_Form1=CreateObject("Form1")
_Form1.show
RETURN
DEFINE CLASS Form1 AS form
ICON=P_Icon
Height = 32
Width = 297
ShowWindow = 2
ShowInTaskBar = .T.
DoCreate = .T.
Caption = "ϵͳ����"
MaxButton = .F.
MinButton = .F.
TitleBar = 1
WindowState = 0
BackColor =RGB( 221,177,226)
PROCEDURE Init
this.AddObject("Label1","Classname")
DECLARE INTEGER FindWindow IN user32;
    STRING lpClassName,;
    STRING lpWindowName
DECLARE INTEGER GetWindow IN user32;
    INTEGER hwnd,;
    INTEGER wFlag
DECLARE INTEGER SetWindowPos IN user32;
    INTEGER hwnd,;
    INTEGER hWndInsertAfter,;
    INTEGER x,;
    INTEGER y,;
    INTEGER cx,;
    INTEGER cy,;
    INTEGER wFlags
Declare integer SetParent in user32 integer hWndChild , integer hWndNewParent
*-----------------------------------------------------------------*
*-VFPӦ�ó�ʽ�㷨Ⱥ:12787940 ������:310727570-*
*-----------------------------------------------------------------*
uHwnd = FindWindow('ProgMan',NULL)
fHwnd = getWindow(_screen.hwnd,5)
SetParent(fHwnd,uHwnd)
SetWindowPos(this.hwnd, -1, 0, 0, 0,0, 1)
ENDPROC
PROCEDURE Unload
canc
ENDPROC
ENDDEFINE
DEFINE CLASS Classname AS label
Visible=.T.

AutoSize = .T.
FontSize = 14
BackStyle = 0
Caption = "�Ҿ�ͣ�������ˣ���ô�Ű��㣿��"
Height = 24
Left = 16
Top = 6
Width = 287
ForeColor =RGB( 255,0,0)
ENDDEFINE

*!*	oWMI=Getobject('winmgmts:')      && vfp9.0
*!*	m.cWin32Class='Win32_Processor'  && CPU��Ϣ ( ProcessorId ��Ϊ���к�)
*!*	oItems=oWMI.ExecQuery('Select * From '+m.cWin32Class)
*!*	Create Cursor GetInfo (_Property C(50),_Value C(200))
*!*	For Each oItem In oItems         && ���ж����ͬ�����豸��Ҳһ��ȡ��������ȡӲ����Ϣʱ���ж��Ӳ��ʱҲ��ȫ��ȡ����
*!*	    For Each oProperty In oItem.Properties_
*!*	        lcName=oProperty.Name
*!*	        lcVal=Transform(oProperty.Value)
*!*	        Try
*!*	            Insert Into GetInfo Values (lcName,lcVal)
*!*	        Catch
*!*	        Endtry
*!*	    Endfor
*!*	Endfor
*!*	Locate
*!*	Browse
*!*	Return