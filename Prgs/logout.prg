*	***************************************************************
*	*
*	*			2004-03-25		Begin.PRG			21:00:00
*	*
*	***************************************************************
*	*	Programmer:	Lu_HongBin
*	*
*	*	CopyRight(R)	ShenTaMyMis   V1.0
*	*
*	*	Description:	This is first file of ShenTaMyMis   
*	*
*	***************************************************************
*	Call By :	No file

*!*	Answer=MESSAGEBOX('ȷ��Ҫ�˳�ϵͳ��?     ',4+32+256,'�˳�ϵͳ')
*!*	DO CASE
*!*	CASE Answer=6
*!*	ERASE C:\LATLON.htm
TRY 
	con=odbc(5)
	SQLEXEC(con,"drop table &P_UserName")
	SQLDISCONNECT(CON)
	P_EditMode='�˳�'
	P_FileName='�˳�ϵͳ'
	P_ID=P_UserName
	DO &P_Prgs.EveryDay WITH P_FileName,P_ID,P_EditMode
	SAVE TO BUYS
CATCH 
ENDTRY 
*!*	CLEAR ALL
RUN /N reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f
RUN /N7 taskkill /im autolutec.exe /f
ON SHUTDOWN
QUIT
*!*	CASE Answer=7
*!*		RETURN
*!*	ENDCASE