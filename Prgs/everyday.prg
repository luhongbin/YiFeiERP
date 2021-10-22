*	***************************************************************
*	*
*	*			2008-03-25		Begin.PRG			21:00:00
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

PROCEDURE everyday
PARA mFile,mId,mEditMode
cmac=getmac()
CPUSER=P_UserName+'/'+ALLTRIM(SYS(0))
CON=ODBC(6)
SQLEXEC(CON,"execute everylog '&CPUSER','&mFile','&mId','&mEditMode','&cmac'")
SQLDISCONNECT(con)
RETURN 
