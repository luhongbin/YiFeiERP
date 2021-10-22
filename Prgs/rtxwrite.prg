DEFINE CLASS myclass AS Session 
   PROCEDURE RtxWrite1
	   mSender=ALLTRIM(MsgObj.Sender)
	   mReceive=ALLTRIM(MsgObj.Receivers)+'('+ALLTRIM(MsgObj.OfflineReceivers)+')'
	   mTime=ALLTRIM(MsgObj.TimeSent)
	   mContent=ALLTRIM(SUBSTR(MsgObj.Content,1,2000))
	   CON=ODBC(6)
	   IF SQLEXEC(CON,"INSERT INTO mathistory1 (sender,receiver,dtime,talkcontent) values (?msender,?mreceiver,?mtime,?mcontent)")<0
	   	WAIT WINDOWS 'ERROR' NOWAIT
	   ENDIF
	   SQLDISCONNECT(con)
	   RETURN
   ENDPROC 
ENDDEFINE