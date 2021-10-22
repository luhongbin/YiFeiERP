******************************************************************************
*** Program: Inbox2Dbf
*** Time Stamp:   07/31/02 08:26:02 PM
*** Instantiates the custom class defined in this program for automating outlook 2000.
*** Includes functionality to read
*** messages from the Outlook Inbox and store them in OlMail.dbf
******************************************************************************
Local loMail, loRootFolder
loMail = Createobject( 'sesOutlook' )
If Vartype( loMail ) = 'O'
  With loMail
    loRootFolder = .oNameSpace.Folders(1)
    If .ReadMail( loRootFolder )
      Set DataSession To loMail.DataSessionId
      Select SaveMail
      Browse Last
    Endif
  Endwith
Endif
Return
 
Define Class sesOutlook As Session
 
  *** Object reference to the outlook application object
  oOutlook = .Null.
  *** Object reference to the MAPI namespace object in Outlook from which you reference all the other objects (like the inbox)
  oNameSpace = .Null.
 
  *** array for holding contacts
  Dimension aContacts[1,1]
  *** name of attachment subdirectory
  cDirAttach = "ATTACH\"
  *** add a counter property
  iCounter = 1
 
  *******************************************************************************************************
  Function CreateSession()
    *******************************************************************************************************
    *** Instantiate outlook and logon
    Local llRetVal
 
    *** See we we already have an instance of Outlook Running
    If Type( 'This.oOutlook' ) = 'O' And Not Isnull( This.oOutlook )
      *** No need to create a new instance
    Else
      With This
        .oOutlook = Createobject( 'Outlook.Application' )
        If Type( 'This.oOutLook' ) = 'O' And Not Isnull( .oOutlook )
          .oNameSpace = .oOutlook.GetNameSpace( 'MAPI' )
          If Type( 'This.oNameSpace' ) = 'O' And Not Isnull( .oNameSpace )
            llRetVal = .T.
          Endif
        Endif
      Endwith
    Endif
 
    Return llRetVal
  Endfunc
 
  *******************************************************************************************************
  Function OpenMsgTables()
    *******************************************************************************************************
    With This
      If Not Used( 'SaveMail' )
        Use SaveMail Again In 0
      Endif
      If Not Used( 'OlAttach' )
        Use SaveAttach Again In 0
      Endif
    Endwith
 
    Create Dbf SaveCont (cnal c(50), cnaf c(50), cnafl c(80), cemail1 c(80), cemail2 c(80), cemail3 c(80))
 
  Endfunc
 
  *******************************************************************************************************
  Function ReadMail( toFolder )
    *******************************************************************************************************
    *** The ReadMail Method goes through all the Outlook folders recursively and save all
    *** of the mailItems to the table OlMail.dbf. If the message has any attachments,
    *** it then calls the SaveAttachments method to save the attachment as a file on disk and
    *** insert a record with the name of the file into OlAttach.dbf along with a foreign key
    *** to the message in OlMail.dbf
    Local loItems, loItem, loFolders, loFolder
 
    *** Get a local referenece to the collection of of items in the current folder
    loItems = toFolder.Items
 
    *** Process all the items in the current folder
    *** If it is a mail item, save it and process the attachments
    If Vartype( loItems ) = 'O'
      For Each loItem In loItems
        Wait Window Nowait Transform(This.iCounter)
        If   loItem.Class =   43    && olMail
 
          *** Add a record to the messages tabel
          *** store list of recipients as well
          lnCount = loItem.Recipients.Count
          m.lcRecip = ''
          For lnRecip = 1 To lnCount
            loRecipient = loItem.Recipients[ lnRecip ]
            m.lcRecip = m.lcRecip + loRecipient.Name + ': ' + loRecipient.Address + Chr( 13 ) + Chr( 10 )
          Endfor
 
          *** 2002-09-12 Marcia G. Akins: let's try a different strategy for matching up the e-mail address
          *** First see if the sender name actually IS an e-mail address
          If '@' $ loItem.SenderName
            m.lcSenderEm = loItem.SenderName
          Else
            lnRow = Ascan( This.aContacts, loItem.SenderName, -1, -1, 3, 15 )
            If lnRow > 0
              m.lcSenderEm = This.aContacts[ lnRow, 6 ]
            Else
              lnRow = Ascan( This.aContacts, loItem.SenderName, -1, -1, 4, 15 )
              If lnRow > 0
                m.lcSenderEm = This.aContacts[ lnRow, 7 ]
              Else
                lnRow = Ascan( This.aContacts, loItem.SenderName, -1, -1, 5, 15 )
                If lnRow > 0
                  m.lcSenderEm = This.aContacts[ lnRow, 8 ]
                Else
                  m.lcSenderEm = ''
                Endif
              Endif
            Endif
          Endif
 
          If '@' $ loItem.SenderName
            m.lcSenderEm2 = loItem.SenderName
          Else
            If Empty(loItem.To)
              * don't reply - this is just a draft
              m.lcSenderEm2 = "Draft"
            Else
              loReply = loItem.Reply()
              loRecip = loReply.Recipients[ 1 ]
              m.lcSenderEm2 = Iif( Not Empty( loRecip.Address ), loRecip.Address, loRecip.Name )
            Endif
          Endif
 
          Insert Into SaveMail ( omInDate, omSender, omSubject, omBody, omFolder, omRecip, omSenderEm, omSenderEm2 ) ;
            VALUES ( loItem.ReceivedTime, loItem.SenderName, loItem.Subject, loItem.Body, toFolder.Name, m.lcRecip, m.lcSenderEm, m.lcSenderEm2 )
          *** Now see if we have attachments
          If loItem.Attachments.Count > 0
            This.SaveAttachments( loItem )
          Endif
        Endif
 
        This.iCounter = This.iCounter + 1
 
      Endfor
    Endif
 
    *** Now see if this folder has folders to process
    If toFolder.Class = 2  &&  olFolder
      loFolders = toFolder.Folders
      For Each loFolder In loFolders
        This.ReadMail( loFolder )
      Endfor
    Endif
 
    Return
  Endfunc
 
  *******************************************************************************************************
  Function SaveAttachments( toMsg )
    *******************************************************************************************************
    Local  loAttachment,  lcFileName
 
    *** Saves the attachmens associated with the current message to the specified file name
    For Each loAttachment In toMsg.Attachments
 
      **** send attachment files into a subdir
      lcFileName = Fullpath( Curdir() + This.cDirAttach ) + loAttachment.FileName
      If !Empty( m.lcFileName )
        loAttachment.SaveAsFile( lcFileName )
        *** Make sure it was saved
        *** The SaveAsFile method returns null...it doesn't tell us about success or failure
        If File( lcFileName )
          *** ok...now add it to the table
          Insert Into SaveAttach ( omMailFK, attFname ) Values ( SaveMail.omMailPK, lcFileName )
        Endif
      Endif
    Endfor
  Endfunc
 
 
  *******************************************************************************************************
  Function Destroy()
    *******************************************************************************************************
    With This
      .oNameSpace = .Null.
      .oOutlook = .Null.
    Endwith
  Endfunc
 
 
  *******************************************************************************************************
  Function Init()
    *******************************************************************************************************
    Local llRetVal
    llRetVal = DoDefault()
 
    If llRetVal
      llRetVal = This.CreateSession( )
    Endif
 
    If llRetVal
      This.OpenMsgTables()
    Endif
 
    *** create the contacts list as well
    If llRetVal
      This.GetContacts()
    Endif
 
    Return llRetVal
 
  Endfunc
 
  *******************************************************************************************************
  Function GetContacts()
    *******************************************************************************************************
 
    Local loAddressBook As Outlook.MAPIFolder, loContact As Object, lnContactCount
 
    *** Get a reference to the contacts folder
    *** olFolderContacts is 10
    loAddressBook = This.oNameSpace.GetDefaultFolder( 10 )
    If Vartype( loAddressBook ) = 'O'
      lnContactCount = 0
      *** Get info about each contact into the array
      For Each loContact In loAddressBook.Items
        With loContact
          *** Make sure we only get individual contacts
          *** and skip any distribution lists
          Wait Window Nowait "Parsing Contacts: " + Transform(m.lnContactCount) + " processed"
          *** olContact is 40
          If .Class = 40
            lnContactCount = lnContactCount + 1
            Dimension This.aContacts[ lnContactCount, 9 ]
            This.aContacts[ lnContactCount, 1 ] = .LastName
            This.aContacts[ lnContactCount, 2 ] = .FirstName
            This.aContacts[ lnContactCount, 3 ] = Strtran( .Email1DisplayName, '(E-mail)', '', -1, 1, 1  )
            This.aContacts[ lnContactCount, 4 ] = Strtran( .Email2DisplayName, '(E-mail 2)', '', -1, 1, 1 )
            This.aContacts[ lnContactCount, 5 ] = Strtran( .Email3DisplayName, '(E-mail 3)', '', -1, 1, 1 )
            This.aContacts[ lnContactCount, 6 ] = .Email1Address
            This.aContacts[ lnContactCount, 7 ] = .Email2Address
            This.aContacts[ lnContactCount, 8 ] = .Email3Address
            This.aContacts[ lnContactCount, 9 ] = Upper(.FullName)
            m.lcNaf = .LastName
            m.lcNal = .FirstName
            m.lcNafl = .FullName
            m.lcemail1 = .Email1Address
            m.lcemail2 = .Email2Address
            m.lcemail3 = .Email3Address
 
            Insert Into SaveCont ;
              (cnaf, cnal, cnafl, cemail1, cemail2, cemail3) ;
              values ;
              (m.lcNaf, m.lcNal, m.lcNafl, m.lcemail1, m.lcemail2, m.lcemail3)
 
          Endif
        Endwith
      Endfor
      Asort( This.aContacts )
    Endif
 
Enddefine
*** EndDefine: sesOutlook
 