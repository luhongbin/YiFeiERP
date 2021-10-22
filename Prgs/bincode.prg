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
oNameSpace = oOutlook.getnamespace('MAPI')
oDefaultFolder=oNameSpace.GetDefaultFolder(olFolderCalendar) &&Calendar
oDefaultFolder.display()

return
con=odbc(5)
sQLEXEC(con,"select interid from quotation","tmp")

SELECT tmp
DO whil .not. EOF()
	SELECT tmp
	z=interid
	SQLEXEC(con,"select priceinterid from pidetail inner join pi on pi.interid=pidetail.maininterid  where priceinterid=?z and pi.chkid=1","tmp1")
	y=RECCOUNT()

	SQLEXEC(con,"update quotation set countpi=?y where interid=?z")
	SELECT tmp
	SKIP
ENDDO 	
SQLDISCONNECT(con)

