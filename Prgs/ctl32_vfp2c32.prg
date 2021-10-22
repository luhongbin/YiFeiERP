LOCAL loOutlook AS Outlook.Application 
LOCAL loInBox   AS Outlook.MAPIFolder 
LOCAL loItems   AS Outlook.Items
LOCAL loObj     AS Outlook.MailItem 
LOCAL lnI       AS Integer, liCount AS Integer 

#DEFINE olFolderInbox     5
#DEFINE olHeaderOnly       0 
#DEFINE olMarkedForDownload 2

loOutlook = CREATEOBJECT('Outlook.Application')
loInBox   = loOutlook.GetNamespace("MAPI").GetDefaultFolder(olFolderInbox)
loItems   = loInbox.Items 
liCount   = loItems.Count 
	 WAIT windows TRANSFORM(liCount )
FOR lnI = 1 TO liCount 

    loObj = loItems.Item[lnI]
    *-- Verify if the state of the item is olHeaderOnly
MESSAGEBOX(loObj.Subject)
*!*	    IF loObj.DownloadState = olHeaderOnly 
*!*	       MESSAGEBOX("This item has not been fully downloaded.")
*!*	       *-- Mark the item to be downloaded.
*!*	       loObj.MarkForDownload = olMarkedForDownload 
*!*	       loObj.Save 
*!*	    ENDIF
ENDFOR

