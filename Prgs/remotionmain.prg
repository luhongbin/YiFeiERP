SET SAFETY OFF
SET EXCLUSIVE OFF
SET TALK OFF 
SET HOURS TO 24
*!*	DECLARE INTEGER FindWindow IN USER32.DLL AS Find_Window STRING,STRING
*!*	LOCAL cTitle
*!*	IF Find_Window(0,'OA����')!=0
*!*		=MESSAGEBOX('OA�����Ѿ����У�����ʧ��!',48,'��ʾ��Ϣ')
*!*		quit
*!*	ENDIF
*!*	IF !FILE("buys.dbf",1) OR !FILE("face02.ico",1) OR !FILE("oavice.exe",1)
*!*		QUIT
*!*	ENDIF 	
ON ERROR DO errHandler WITH  ERROR( ), MESSAGE( ), MESSAGE(1), PROGRAM( ), LINENO( )
PUBLIC KEYID,tcAliasName,pk
KEYID=1
SET PROCEDURE TO Prgs\remotion.prg
*DO  Prgs\getmessage.prg
PUBLIC P_USERNAME
P_USERNAME='³���'
DO FORM frms\oaremotion.scx

READ EVENTS
 