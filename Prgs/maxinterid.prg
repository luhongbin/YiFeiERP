PARAMETERS TABLENAME

CON=ODBC(6)
SQLEXEC(CON,"SELECT ID FROM TABLEMAXID WHERE UPPER(TABLENAME)=UPPER('&TABLENAME')" ,'tempinsert')
SELECT tempinsert
T=tempinsert.ID
IF YEAR(DATE())*1000000+MONTH(DATE())*10000>T
	P_ChkBill=YEAR(DATE())*10000+MONTH(DATE())*100
	CKEYID=STR(P_ChkBill)
	SQLEXEC(CON,"UPDATE TABLEMAXID SET ID='&CKEYID' WHERE UPPER(TABLENAME)=UPPER('&TABLENAME') ")
ELSE
	P_ChkBill=T
	CKEYID=STR(P_ChkBill+1)
	SQLEXEC(CON,"UPDATE TABLEMAXID SET ID='&CKEYID' WHERE UPPER(TABLENAME)=UPPER('&TABLENAME') ")
ENDIF
IF USED("tempinsert")
	SELECT tempinsert
	USE
ENDIF	
SQLDISCONNECT(con)
RETURN KeyID