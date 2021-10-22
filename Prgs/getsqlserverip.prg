CON=ODBC(5)
*SQLEXEC(CON,"SELECT login_time,CAST(hostname as char(20)) as hostname,CAST(program_name as char(20)) as program_name,"+;
"cmd,CAST(nt_username as char(20)) as username,CAST(loginame as char(10)) as login,net_library,net_address FROM master..sysprocesses "+;
"where program_name<>'易飞ERP系统' and program_name<>'' and hostname <>'IBM-F830B3770FA' and program_name not like 'SQLAgent%'"+;
" and hostname <>'LHB-PC' and hostname <>'TS2' and program_name<>'易飞ERP助手'  and  program_name not like 'Lumigent%'  ORDER BY hostname ","TEMP")
*SQLEXEC(CON,"SELECT *,CAST(sql as CHAR(100)) AS DATA from sys.syscacheobjects where sql not like'%cach%' and sql not like '%sys.%'","TEMP")
*SQLEXEC(CON,"select * from test..sysobjects ","TEMP")&&where type = 'u' or type = 's
SQLEXEC(CON,"select * from master..sysprocesses ","TEMP")
SQLDISCONNECT(CON)
BROW