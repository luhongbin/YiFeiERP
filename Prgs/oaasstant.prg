SET SAFETY OFF
SET EXCLUSIVE OFF
DECLARE INTEGER FindWindow IN USER32.DLL AS Find_Window STRING,STRING
LOCAL cTitle
IF Find_Window(0,'OA����')!=0
	=MESSAGEBOX('OA�����Ѿ����У�����ʧ��!',48,'��ʾ��Ϣ')
	quit
ENDIF
IF !FILE("buys.dbf",1) OR !FILE("face02.ico",1) &&OR !FILE("oavice.exe",1)
	QUIT
ENDIF 	
*!*	ON ERROR DO errHandler WITH  ERROR( ), MESSAGE( ), MESSAGE(1), PROGRAM( ), LINENO( )
PUBLIC KEYID
KEYID=1
SET PROCEDURE TO Prgs\sampleproce
*DO  Prgs\getmessage.prg

&&RUN /N OAVICE.EXE 
DO FORM frms\oaasstant.scx

READ EVENTS
 