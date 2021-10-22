*!*	*https://social.msdn.microsoft.com/Forums/en-US/d493e88f-2362-4af7-9d5e-9a645fe43344/reading-emails-into-vfp-table?forum=visualfoxprogeneral
*!*	RELEASE mreceivedate
*!*	PUBLIC mreceivedate
*!*	cmac=getmac()
*!*	con=odbc(5)
*!*	sqlexec(con,"select top 1 emaildate from [declaration_email] where mac=?cmac order by 1 desc ")
*!*	SQLDISCONNECT(con)
*!*	IF RECCOUNT()<1
*!*		mreceivedate='2015.10.01'
*!*	ELSE 
*!*		mreceivedate=TTOC(emaildate)
*!*	ENDIF 	
*!*	loApp = CREATEOBJECT("Outlook.application")
*!*	xloFolders = loApp.GetNameSpace("MAPI")
*!*	lcName =''
*!*	?xloFolders.Folders(1)
*!*	? TRANSFORM(xloFolders.class)		+'xxxx'
*!*	*!*	?xloFolders.Folders.COUNT 
*!*	IF xloFolders.Folders.COUNT > 0

*!*	*!*			loMessages =xloFolders.Items.Restrict("[ReceivedTime] > '&mreceivedate'")
*!*	*!*			?loMessages.Count
*!*	*!*				FOR lnMsg = 1 TO loMessages.Count
*!*	*!*						   	? loMessages.Item[ lnMsg ].ReceivedTime
*!*	*!*							? loMessages.Item[ lnMsg ].subject 
*!*	*!*				ENDFOR	
*!*	*		?lcname=xloFolders.Folders.name
*!*		   	FOR lnSub1 = 1 TO xloFolders.Folders.COUNT
*!*		    	lcname=lcname+'.'+xloFolders.Folders.ITEM(lnSub1 ).NAME
*!*		      	?lcname+'='+TRANSFORM( xloFolders.Folders.ITEM(lnSub1 ).items.Class)+'yyy'
*!*		      	? xloFolders.Folders.ITEM(lnSub1).Items.COUNT
*!*				FOR lnSub2 = 1 TO xloFolders.Folders.ITEM(lnSub1).Items.COUNT
*!*					TRY 
*!*					   	? xloFolders.Folders.Item[ lnSub1 ].Items.Item[ lnSub2 ].ReceivedTime
*!*						? xloFolders.Folders.Item[ lnSub1].Items.Item[ lnSub2 ].subject 
*!*					FINALLY
*!*					   MKEYID=0
*!*					ENDTRY
*!*				ENDFOR   
*!*	*!*				? xloFolders.Folders.ITEM(lnSub1).Folders.COUNT   
*!*				IF  xloFolders.Folders.ITEM(lnSub1).Folders.COUNT > 0 
*!*				   	FOR lnSub3 = 1 TO xloFolders.Folders.ITEM(lnSub1).Folders.COUNT
*!*				    	lcname=lcname+'.'+xloFolders.Folders.ITEM(lnSub1).Folders.ITEM(lnSub3).NAME
*!*				      	?lcname
*!*						FOR lnSub4 = 1 TO xloFolders.Folders.ITEM(lnSub1).Folders.ITEM(lnSub3).Items.COUNT
*!*							TRY 
*!*							   	? xloFolders.Folders.Item[ lnSub1 ].Folders.ITEM(lnSub3).Items.Item[ lnSub4 ].ReceivedTime
*!*								? xloFolders.Folders.Item[ lnSub1].Folders.ITEM(lnSub3).Items.Item[ lnSub4 ].subject 
*!*							FINALLY
*!*							   MKEYID=0
*!*							ENDTRY
*!*						ENDFOR  
*!*					ENDFOR 	
*!*				endif					
*!*		   ENDFOR
*!*	   ENDIF 
*!*	RETURN 

*!*	cmac=getmac()
*!*	con=odbc(5)
*!*	sqlexec(con,"select top 1 emaildate from [declaration_email] where mac=?cmac order by 1 desc ")
*!*	IF RECCOUNT()<1
*!*		mreceivedate=CTOT('2016.10.01')
*!*	ELSE 
*!*		mreceivedate=emaildate 
*!*	ENDIF 	
*!*	cfilter='ReceivedTime > mreceivedate-1'
*!*	loApp = CREATEOBJECT("Outlook.application")
*!*	loSpace = loApp.GetNameSpace("MAPI")
*!*	xloFolders = loSpace.GetDefaultFolder(6)
*!*	loFolders  = loSpace.Folders
*!*	*loItems = loSpace.Folders.Items
*!*	lcName =''
*!*	FOR lni = 1 TO loSpace.Folders.Count
*!*	   lcName = loSpace.Folders(lni).Name
*!*	ENDFOR
*!*	FOR lnSub = 1 TO xloFolders.Items.COUNT
*!*		lcName = xloFolders.NAME
*!*		TRY 
*!*		   	? xloFolders.Items.Item[ lnSub ].ReceivedTime
*!*			? xloFolders.Items.Item[ lnSub ].subject 
*!*		FINALLY
*!*		   MKEYID=0
*!*		ENDTRY
*!*	ENDFOR
*!*	?xloFolders.Folders.COUNT 
*!*	IF xloFolders.Folders.COUNT > 0
*!*	   	FOR lnSub1 = 1 TO xloFolders.Folders.COUNT
*!*	    	lcname=lcname+'.'+xloFolders.Folders.ITEM(lnSub1 ).NAME
*!*	      	?lcname
*!*			FOR lnSub2 = 1 TO xloFolders.Folders.ITEM(lnSub1).Items.COUNT
*!*				TRY 
*!*				   	? xloFolders.Folders.Item[ lnSub1 ].Items.Item[ lnSub2 ].ReceivedTime
*!*					? xloFolders.Folders.Item[ lnSub1].Items.Item[ lnSub2 ].subject 
*!*				FINALLY
*!*				   MKEYID=0
*!*				ENDTRY
*!*			ENDFOR     
*!*			IF  xloFolders.Folders.ITEM(lnSub1).Folders.COUNT > 0 
*!*			   	FOR lnSub3 = 1 TO xloFolders.Folders.ITEM(lnSub1).Folders.COUNT
*!*			    	lcname=lcname+'.'+xloFolders.Folders.ITEM(lnSub1).Folders.ITEM(lnSub3).NAME
*!*			      	?lcname
*!*					FOR lnSub4 = 1 TO xloFolders.Folders.ITEM(lnSub1).Folders.ITEM(lnSub3).Items.COUNT
*!*						TRY 
*!*						   	? xloFolders.Folders.Item[ lnSub1 ].Folders.ITEM(lnSub3).Items.Item[ lnSub4 ].ReceivedTime
*!*							? xloFolders.Folders.Item[ lnSub1].Folders.ITEM(lnSub3).Items.Item[ lnSub4 ].subject 
*!*						FINALLY
*!*						   MKEYID=0
*!*						ENDTRY
*!*					ENDFOR  
*!*				ENDFOR 	
*!*			endif					
*!*	   ENDFOR
*!*	ENDIF 
*!*	RETURN 
*!*	loApp = CREATEOBJECT("Outlook.application")
*!*	loSpace = loApp.GetNameSpace("MAPI")
*!*	xloFolders = loSpace.GetDefaultFolder(6)
*!*	loFolders  = loSpace.Folders
*!*	*loItems = loSpace.Folders.Items
*!*	FOR lni = 1 TO loSpace.Folders.Count
*!*	   lcName = loSpace.Folders(lni).Name
*!*	ENDFOR
*!*	lcName =''
*!*	FOR lni = 1 TO loFolders.Count
*!*	   FOR lnSub = 1 TO loFolders.ITEM(lni).folders.COUNT
*!*	      lcName = loFolders.ITEM(lni ).folders.ITEM(lnSub ).NAME
*!*	      ?lcName
*!*			MKEYID=1
*!*	      	FIRST=loFolders.ITEM(lni ).folders.ITEM(lnSub ).Items
*!*			FOR lnCounter = 1 TO  FIRST.COUNT
*!*	      		TRY 
*!*			    	? FIRST.Item[ lnCounter ].ReceivedTime
*!*			 		? FIRST.Item[ lnCounter ].subject 
*!*	*!*				 	ELSE
*!*	*!*				 		MKEYID=0	
*!*	*!*			 		ENDIF
*!*				FINALLY
*!*				*	?'X'
*!*				   MKEYID=0
*!*				ENDTRY
*!*	*!*				IF MKEYID=0
*!*	*!*					EXIT
*!*	*!*				endif
*!*	      ENDFOR
*!*	      IF loFolders.ITEM(lni ).folders.ITEM(lnSub ).Folders.COUNT > 0
*!*	      		FOR lnSub1 = 1 TO loFolders.ITEM(lni ).folders.ITEM(lnSub ).Folders.COUNT
*!*	      			lcname=lcname+'.'+loFolders.ITEM(lni ).folders.ITEM(lnSub ).Folders.ITEM(lnSub1 ).NAME
*!*	      			?lcname
*!*		   			IF loFolders.ITEM(lni ).folders.ITEM(lnSub ).Folders.ITEM(lnSub1 ).Folders.COUNT>0
*!*			      		FOR lnSub2 = 1 TO loFolders.ITEM(lni ).folders.ITEM(lnSub ).Folders.ITEM(lnSub1 ).Folders.COUNT
*!*			      			lcname=lcname+'.'+loFolders.ITEM(lni ).folders.ITEM(lnSub ).Folders.ITEM(lnSub1 ).Folders.ITEM(lnSub2 ).NAME
*!*			      			?lcname
*!*			      			IF loFolders.ITEM(lni ).folders.ITEM(lnSub ).Folders.ITEM(lnSub1 ).Folders.ITEM(lnSub2).Folders.COUNT>0
*!*					      		FOR lnSub3 = 1 TO loFolders.ITEM(lni ).folders.ITEM(lnSub ).Folders.ITEM(lnSub1 ).Folders.ITEM(lnSub2).Folders.COUNT
*!*					      			lcname=lcname+'.'+loFolders.ITEM(lni ).folders.ITEM(lnSub ).Folders.ITEM(lnSub1 ).Folders.ITEM(lnSub2 ).Folders.ITEM(lnSub3).NAME
*!*					      			?lcname
*!*					    		ENDFOR 	
*!*							ENDIF 
*!*			    		ENDFOR 	
*!*					ENDIF 
*!*	    		ENDFOR 	
*!*	      ENDIF 
*!*	   ENDFOR
*!*	ENDFOR 

*!*	FUNCTION getmail
*!*		PARAMETERS mcount
*!*		
*!*	ENDFUNC 

*!*	return
*!*	LOCAL loOutlook   AS Outlook.Application
*!*	LOCAL loNameSpace AS Outlook.NameSpace 
*!*	LOCAL loInBox     AS Object 

*!*	#DEFINE olFolderInBox      6

*!*	*!*	loOutlook   = CREATEOBJECT('Outlook.Application')
*!*	*!*	loNameSpace = loOutlook.GetNamespace("MAPI")
*!*	*!*	loInBox     = loNameSpace.GetDefaultFolder(olFolderInBox)

*!*	*!*	*-- At this point we have the InBox Object.
*!*	*!*	*-- Let¡¯s display how many messages we have in the Inbox.

*!*	*!*	? "We have "+TRANSFORM(loInBox.Items.Count)+" Messages"

*!*	*!*	*-- What about subfolders in the inbox.
*!*	*!*	? "The inbox contains " + TRANSFORM(loInBox.Folders.Count) + " SubFolders"


*!*	LOCAL loOutlook, loNameSpace, loFolders, lcKey, loNode, lnCounter,lnCounter1,lnCounter2
*!*	LOCAL loInbox AS Outlook.MAPIFolder, loMessages AS Outlook.Items
*!*	LOCAL lcFilter, lnMsgCount, lcSubject, lcBDPE

*!*	loOutlook = CreateObject('Outlook.Application')
*!*	loNameSpace = loOutlook.GetNameSpace('MAPI')
*!*	*loFolders = loNameSpace.Folders
*!*	loFolders = loNameSpace.GetDefaultFolder(olFolderInBox)
*!*	FOR lnCounter = 1 TO loFolders.Items.COUNT
*!*	*!*	    IF TYPE("loFolders.ITEM(lnCounter).Folders.count") = "N"
*!*	*!*		    IF loFolders.ITEM(lnCounter).Folders.COUNT > 0
*!*	*!*		        FOR lnCounter1 = 1 TO  loFolders.ITEM(lnCounter).folders.COUNT
*!*	*!*	       	    	?loFolders.ITEM(lnCounter).folders.ITEM(lnCounter1).NAME
*!*	*!*					loInbox = loNameSpace.GetDefaultFolder(6)
*!*	*!*	       	    	loMessages = loInbox.Items
*!*	*!*	       	    	FOR lnMsg = 1 TO loMessages.Count
*!*	*!*		       	    	?loMessages.Item[ lnMsg ].subject 
*!*	*!*					ENDFOR

*!*	*!*			        FOR lnCounter2 = 1 TO loFolders.ITEM(lnCounter).folders.ITEM(lnCounter1).folders.COUNT
*!*	*!*			        	?loFolders.ITEM(lnCounter).folders.ITEM(lnCounter1).folders.ITEM(lnCounter2).folders.NAME
*!*	*!*			       	ENDFOR
*!*	       	    	 ?loFolders.Items.Item[ lnCounter ].subject 
*!*	        	ENDFOR
*!*	*!*	        ENDIF	
*!*	*!*	    ENDIF
*!*	ENDFOR
*!*	loMessages = loFolders.Folders
*!*	IF loMessages.COUNT>0
*!*		FOR lnCounter = 1 TO loMessages.COUNT
*!*			*?loFolders.Folders.ITEM(lnCounter1)
*!*			?loMessages.Item[ lnCounter ].subject 
*!*	    	*FOR lnMsg = 1 TO loMessages.Items.Count
*!*	   	    	*?loMessages.Item[ lnMsg ].subject 
*!*			*ENDFOR
*!*		ENDFOR
*!*	ENDIF	
*!*	loNameSpace = NULL
*!*	loOutlook = NULL
*!*	RELEASE loNameSpace
*!*	RELEASE loOutlook
