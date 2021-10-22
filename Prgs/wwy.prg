*/ Importance Constants
#DEFINE olImportanceLow 0
#DEFINE olImportanceNormal 1
#DEFINE olImportanceHigh 2


*// Item Constants
#DEFINE olMailItem 0
#DEFINE olAppointmentItem 1
#DEFINE olContactItem 2
#DEFINE olTaskItem 3
#DEFINE olJournalItem 4
#DEFINE olNoteItem 5
#DEFINE olPostItem 6

*// Added a Folder Constant

#DEFINE olFolderTasks 13

*// Create the Outlook Object
Public oOutLookObject
oOutLookObject = CreateObject("Outlook.Application")

*// Added code for alternate creating of Task

oNameSpace=oOutlookObject.GetNameSpace("MAPI")
oTaskFolder=oNameSpace.GetDefaultFolder(olFolderTasks)
oTaskItem=oTaskFolder.Items.Add

WITH oTaskItem
 .Subject = "My Subject"
 .Body = "My Body"
 .StartDate = date()
 .DueDate = date() + 10
 .ReminderSet = .t.&&True
 .ReminderTime = datetime() + 3600
 .Categories = "Personal"
 .Save
EndWith
***************The Delete method deletes an item. Deleted items are placed in the Deleted Items folder. To permanently delete items, delete items that are in the Deleted Items folder.
*!*	TrashFolder = loSpace.GetDefaultFolder(3)

*!*	lnItems = trashfolder.items.count

*!*	For lni = l TO lnItems

*!*	   Trashfolder.items(0).delete()

*!*	Endfor 
*******************************************
FOR EACH loTask IN oTasks.Items

   IF loTask.DelegationState = 1

      ? loTask.Subject

   ENDIF

ENDFOR

release oTaskItem
release oOutLookObject