SET SAFETY OFF
SET EXCLUSIVE OFF
DECLARE INTEGER FindWindow IN USER32.DLL AS Find_Window STRING,STRING
LOCAL cTitle
IF Find_Window(0,'OA助手')!=0
	=MESSAGEBOX('OA助手已经运行，启动失败!',48,'提示信息')
	quit
ENDIF
IF !FILE("buys.dbf",1) OR !FILE("face02.ico",1) OR !FILE("oavice.exe",1)
	QUIT
ENDIF 	
*!*	ON ERROR DO errHandler WITH  ERROR( ), MESSAGE( ), MESSAGE(1), PROGRAM( ), LINENO( )
PUBLIC KEYID
KEYID=1
SET PROCEDURE TO Prgs\sampleproce
*DO  Prgs\getmessage.prg
DIME Ver[1]
AGETFILEVERSION(Ver,"lu3.EXE")

mVer='版本号：'+ALLT(Ver[4])
*****
SET MESSAGE TO " 请用户选择用户名并输入用户密码!"
DO FORM &P_Frms.Login.SCX

RUN /N OAVICE.EXE 
DO FORM frms\oaasstant.scx

READ EVENTS
 