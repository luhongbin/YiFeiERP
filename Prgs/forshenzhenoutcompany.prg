CON=ODBC(1)
?SQLEXEC(con,"select A.NAME FROM FROMWEB A  WHERE NOT EXISTS (SELECT 'X' FROM HEADINFODETAIL B WHERE B.NAME=A.NAME ) AND "+;
"NOT EXISTS (SELECT 'X' FROM SENDOVER C WHERE A.NAME=C.NAME OR A.NAME=RTRIM(C.NAME)+CHAR(13) ) AND A.RESULT<>'无结果' AND  BODY NOT LIKE '%企业服务%'","TMP")
SELECT TMP
DO WHIL .NOT. EOF()
	X=STRTRAN(ALLTRIM(NAME),CHR(13),'')
 	SQLEXEC(con,"SELECT 'X' FROM HEADINFODETAIL WHERE NAME=?X AND BODY LIKE '%企业服务%'" ) 
 	IF RECCOUNT()=1
 		SELECT TMP
 		DELETE
 	ENDIF	
*!*	 	SQLEXEC(con,"SELECT 'X' FROM HEADINFODETAIL B WHERE B.NAME=?X" ) 
*!*	 	IF RECCOUNT()=1
*!*	 		SELECT TMP
*!*	 		DELETE
*!*	 	ENDIF	
	SELECT TMP
 	WAIT windows TRANSFORM(RECNO()) NOWAIT 
	SKIP
ENDDO	

*!*	SQLEXEC(con,"select DISTINCT [investor] FROM [investInfo] A  WHERE (investor like '%公司' or investor like '%厂') "+;
*!*	"AND NOT EXISTS (SELECT 'X' FROM HEADINFODETAIL B WHERE B.NAME=A.[investor]) AND NOT EXISTS (SELECT 'X' FROM SENDOVER C WHERE C.NAME=A.[investor])  ","TMP")
SELECT TMP
DO WHIL .NOT. EOF()
	X=investor
	X1=ALLTRIM(investor)+CHR(13)
 	SQLEXEC(con,"SELECT 'X' FROM FROMWEB  WHERE NAME=?X OR NAME=?X1" ) 
 	IF RECCOUNT()=1
 		SELECT TMP
 		DELETE
 	ENDIF	
*!*	 	SQLEXEC(con,"SELECT 'X' FROM HEADINFODETAIL B WHERE B.NAME=?X" ) 
*!*	 	IF RECCOUNT()=1
*!*	 		SELECT TMP
*!*	 		DELETE
*!*	 	ENDIF	
	SELECT TMP
 	WAIT windows TRANSFORM(RECNO()) NOWAIT 
	SKIP
ENDDO	
*!*	PACK

*!*	SQLEXEC(con,"select DISTINCT OUTCOMPANY FROM [outinvestinfo] A  WHERE  NOT EXISTS (SELECT 'X' FROM SENDOVER C WHERE C.NAME=A.OUTCOMPANY )  ","TMP")
*!*	SELECT TMP
*!*	DO WHIL .NOT. EOF()
*!*		X=OUTCOMPANY 
*!*	 	SQLEXEC(con,"SELECT 'X' FROM FROMWEB  WHERE GETNAME=?X" ) 
*!*	 	IF RECCOUNT()=1
*!*	 		SELECT TMP
*!*	 		DELETE
*!*	 	ENDIF	
*!*	 	SQLEXEC(con,"SELECT 'X' FROM HEADINFODETAIL B WHERE B.NAME=?X" ) 
*!*	 	IF RECCOUNT()=1
*!*	 		SELECT TMP
*!*	 		DELETE
*!*	 	ENDIF	
*!*		SELECT TMP
*!*	 	WAIT windows TRANSFORM(RECNO()) NOWAIT 
*!*		SKIP
*!*	ENDDO	
*!*	PACK