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
*	Call By :Main.SCX
IF P_SuperRight='1'
	DO FORM &P_Frms.SystemInfo.SCX
ELSE
	MESSAGEBOX('��û�в�������ܵ�Ȩ��!',0+47+1,'��ʾ��Ϣ')
	RETURN
ENDI	
