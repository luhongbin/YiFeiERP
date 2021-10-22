con=odbc(5)
IF SQLEXEC(con,"declare @rc int;declare @TraceID int;declare @maxfilesize bigint;set @maxfilesize = 5 ")<0
	WAIT windows '???1'
ENDIF 

IF SQLEXEC(con,"exec @rc = sp_trace_create @TraceID output, 0, N'D:\LHB', @maxfilesize, NULL")<0
	WAIT windows '???2'
ENDIF 
*!*	IF SQLEXEC(con,"")<0
*!*		WAIT windows '???3'
*!*	ENDIF 
IF SQLEXEC(con,"exec sp_trace_setevent @TraceIdOut, 13, 1, @On")<0
	WAIT windows '???4'
ENDIF 
IF SQLEXEC(con,"exec @rc = sp_trace_setstatus @TraceIdOut, @status = 1 ")<0
	WAIT windows '???5'
ENDIF 
SQLDISCONNECT(con)