SET SAFETY OFF
SET EXCLUSIVE OFF
DECLARE INTEGER FindWindow IN USER32.DLL AS Find_Window STRING,STRING
LOCAL cTitle
IF Find_Window(0,'OA����')!=0
	=MESSAGEBOX('OA�����Ѿ����У�����ʧ��!',48,'��ʾ��Ϣ')
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

mVer='�汾�ţ�'+ALLT(Ver[4])
*****
SET MESSAGE TO " ���û�ѡ���û����������û�����!"
DO FORM &P_Frms.Login.SCX

RUN /N OAVICE.EXE 
DO FORM frms\oaasstant.scx

READ EVENTS
 