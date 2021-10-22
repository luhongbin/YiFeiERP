#DEFINE olFolderCalendar 9
#DEFINE olFolderContacts 10
#DEFINE olFolderDeletedItems 3
#DEFINE olFolderInBox 6
#DEFINE olFolderJournal 11
#DEFINE olFolderNotes 12
#DEFINE olFolderOutBox 4
#DEFINE olFolderSentMail 5
#DEFINE olFolderTask 13
#DEFINE olBusy 2
#DEFINE True .T.
#DEFINE False .F.
#DEFINE olPrivate 2
#DEFINE MAILITEM 0
#DEFINE IMPORTANCELOW 0
#DEFINE IMPORTANCENORMAL 1
#DEFINE IMPORTANCEHIGH 2
LOCAL oOutlook,oNameSpace,oDefaultFolder
oOutlook = CREATEOBJECT('outlook.application') 
oNameSpace = oOutlook.Session.Accounts
?oNameSpace.COUNT
?oNameSpace.ITEM(1).SmtpAddress 

RETURN

FOR i=1 TO oNameSpace.COUNT
?oNameSpace.ACCOUNT(I).DisplayName
ENDFOR 

oNameSpace = oOutlook.getnamespace('MAPI')
oDefaultFolder=oNameSpace.GetDefaultFolder(olFolderContacts) &&Contact
oDefaultFolder.display()
RETURN 

CON=ODBC(6)
SQLEXEC(CON,"SELECT  interid,worker FROM  Workdaily order by interid","TmpWorkDaily")
SQLDISCONNECT(CON)

SELECT TmpWorkDaily
DO whil .not. EOF()
	KEYID=INTERID
	TXTKEY=worker 
	CON=ODBC(11)
	SQLEXEC(CON,"SELECT CAST(a.cnname as char(10))  as NAME,a.code from Employee as a left join Department as e on a.DepartmentId=e.DepartmentId left join Job as F on A.JobId=F.JobId  left join  " +;
		"EmployeeState q on a.EmployeeStateId=q.EmployeeStateId  where  e.name='Ñ¹Öý³µ¼ä' and a.cnname =?TXTKEY","TEMP9")
	SQLDISCONNECT(CON)
	IF RECCOUNT()=1
		A61 =ALLTRIM(CODE)
		CON=ODBC(6)
		SQLEXEC(CON,"UPDATE WORKDAILY SET hrcode=?A61 WHERE INTERID=?KEYID")
		SQLDISCONNECT(CON)
	ENDIF
	SELECT TmpWorkDaily 
	SKIP
ENDDO	