*!*	XT=getserverdate()
*!*	servetime=HOUR(XT)
*!*	mt =TTOD(XT)
*!*	IF servetime=16
*!*		CON=ODBC(6)
*!*		SQLEXEC(con,"select interid from getsmm where (getid=0 or getid=2) and  CONVERT(char(19), creatdate, 102)=?mt ")
*!*		SQLDISCONNECT(con)
*!*		IF RECCOUNT()<1
*!*			DECLARE INTEGER InternetOpen IN wininet.DLL STRING, INTEGER, STRING, STRING, INTEGER
*!*			DECLARE INTEGER InternetOpenUrl IN wininet.DLL INTEGER, STRING, STRING, INTEGER, INTEGER, INTEGER
*!*			Declare Integer DeleteUrlCacheEntry In Wininet.Dll String szUrl
*!*			DECLARE short InternetCloseHandle IN wininet.DLL INTEGER
*!*			=DeleteUrlCacheEntry("http://www.smm.cn/") &&清理缓存
*!*			HINTERNETSESSION = INTERNETOPEN("www.baidu.com",0,"","",0)
*!*			IF HINTERNETSESSION = 0
*!*			   RETURN -1
*!*			ENDIF
*!*			HURLFILE = INTERNETOPENURL(HINTERNETSESSION,"http://www.smm.cn/","",0,2147483648,0)
*!*			IF HURLFILE = 0
*!*			   RETURN -1
*!*			ENDIF

*!*			 = InternetCloseHandle(HINTERNETSESSION)
*!*			= INTERNETCLOSEHANDLE(HURLFILE) 
*!*			lcRemoteUrl="http://www.smm.cn/" 
*!*			lcRemoteFile=lcRemoteUrl
*!*			lcLocalFile = "c:\UTF8格式4.txt"
*!*			Declare Integer DeleteUrlCacheEntry In Wininet.Dll String szUrl
*!*			Declare Integer URLDownloadToFile In urlmon.Dll Integer pCaller,String szURL,;
*!*			    String szFileName,Integer dwReserved,Integer lpfnCB
*!*			=DeleteUrlCacheEntry(lcRemoteUrl) &&清理缓存
*!*			If URLDownloadToFile(0,lcRemoteFile,lcLocalFile,0,0)<>0
*!*				IF URLDownloadToFile(0,lcRemoteFile,lcLocalFile,0,0)<>0
*!*				    RETURN
*!*				 ENDIF 
*!*			Endif
*!*			COPY file c:\UTF8格式4.txt to DTOC(DATE(),1)+'.txt'
*!*		*P_HRDEPT=STREXTRACT(FILETOSTR("c:\UTF8格式4.txt"),'<th>市场</th>','<div class="tl-price" id="tabs-2" style="display:none">',1)
*!*		*P_HRDEPT=STREXTRACT(STRCONV(FILETOSTR("c:\UTF8格式4.txt"),11),'fifth">日期</td>','<div class="content-left-first-footer">',1) &&2016.10.19变更,因为从10.17日开始,SMM变更了网站格式,因此重新截取数据
*!*		P_HRDEPT=STREXTRACT(STRCONV(FILETOSTR("c:\UTF8格式4.txt"),11),'fifth">日期</td>','</tbody>',1) &&2017.5.1变更,因为从4.1日开始,SMM变更了网站格式,因此重新截取数据
*!*		P_HRDEPT=STRt(P_HRDEPT,' "','"')
*!*		P_HRDEPT=STRt(P_HRDEPT,'" ','"') 
*!*	*!*		P_HRDEPT=STRt(P_HRDEPT,STREXTRACT(P_HRDEPT,'<!--','-->',1),'')&&2017.5.1变更,因为从4.1日开始,SMM变更了网站格式,因此重新截取数据
*!*	*!*		P_HRDEPT=STRt(P_HRDEPT,STREXTRACT(P_HRDEPT,'<!--','-->',1),'')
*!*		*apiStartTags ='<td class="name"'
*!*		apiStartTags ='https://hq.smm.cn'&&'href="http://hq.smm.cn'&&2017.5.1变更,因为从4.1日开始,SMM变更了网站格式,因此重新截取数据
*!*		i2=occurs(apiStartTags ,P_HRDEPT)
*!*		dateid=getserverdate()
*!*		yy=''
*!*		ttd=1
*!*		i3=0
*!*		FOR i1=1 TO i2
*!*			wdd=i1
*!*			xx=yy
*!*			tkeyid=MAXINTERID("getsmm")
*!*			mName = STREXTRACT(STREXTRACT(P_HRDEPT,'<td class="content-left-first-pirce-table-first"','</td>',i1),'">','</a>',2)
*!*			mName =ALLTRIM(STRt(mName ,'SMM','') )
*!*			yy=ALLTRIM(mname)
*!*			IF yy='升贴水'
*!*				mName =ALLTRIM(xx)+'('+ALLTRIM(yy)+')'
*!*			ENDIF 	
*!*			mprice = STREXTRACT(STREXTRACT(P_HRDEPT,'content-left-first-pirce-table-second','/td>',i1),'>','<',1)
*!*			mprice=ALLTRIM(STRt(mprice ,'>',' ') )
*!*			mprice=ALLTRIM(STRt(mprice ,'$',' ') )
*!*			mprice=ALLTRIM(STRt(mprice ,"style='border-bottom:0px;'",' ') )

*!*			maver = STREXTRACT(STREXTRACT(P_HRDEPT,'content-left-first-pirce-table-third','/td>',i1),'>','<',1)
*!*			maver =ALLTRIM(STRt(maver ,'>',' ') )
*!*			maver =ALLTRIM(STRt(maver ,'$',' ') )
*!*			maver =ALLTRIM(STRt(maver ,"style='border-bottom:0px;'",' ') )
*!*			mchange = STREXTRACT(STREXTRACT(P_HRDEPT,'content-left-first-pirce-table-fourth','/td>',i1),'>','<',1)
*!*			mchange =ALLTRIM(STRt(mchange ,'>',' ') )		
*!*			mchange =ALLTRIM(STRt(mchange ,'$',' ') )		
*!*			mchange =ALLTRIM(STRt(mchange ,"style='border-bottom:0px;'",' ') )
*!*			mtoday= STREXTRACT(STREXTRACT(P_HRDEPT,'content-left-first-pirce-table-fifth','/td>',i1),'>','<',1)
*!*			mtoday=ALLTRIM(STRt(mtoday,'>',' ') )		
*!*			mtoday=ALLTRIM(STRt(mtoday,'$',' ') )

*!*				IF hour(dateid)>=16 AND ty=1
*!*					mgetid=0
*!*					IF left(mtoday,2)+SUBSTR(mtoday,4,2)<>SUBSTR(DTOC(TTOD(dateid),1),5,4)
*!*						IF ':'$mtoday=.t. 
*!*							IF  ttd=0
*!*								mgetid=0
*!*							ELSE 	
*!*								mgetid=2
*!*								ttd=1
*!*							ENDIF 	
*!*						ELSE 	
*!*							mgetid=2
*!*							ttd=1
*!*						ENDIF 	
*!*					ELSE 
*!*						ttd=0	
*!*						mgetid=0
*!*					ENDIF 
*!*				ELSE
*!*					mgetid=1
*!*				ENDIF 

*!*				con=odbc(6)
*!*				SQLEXEC(con,"insert into getsmm (interid,creatdate,today,change,aver,price,name,getid) values (?tkeyid,?dateid,?mtoday ,?mchange ,?maver ,?mprice ,?mName,?mgetid )")
*!*				SQLDISCONNECT(con)
*!*			ENDFOR 	
*!*		ENDIF 	
*!*	ENDIF 
*!*	return
*!*	ON ERROR WAIT WINDOWS '' NOWAIT
*!*					lcRemoteUrl='D:\ddd.HTM'
*!*					oo = Newobject('Form') 
*!*					oo.AddObject('oo','olecontrol','Shell.Explorer.2') 
*!*					oo.oo.Visible = .T. 
*!*					oo.oo.Navigate2(lcRemoteUrl) 
*!*					Do While oo.oo.readyState <> 4 
*!*					    Inkey(0.1) 
*!*					Enddo 
*!*					*Strtofile(oo.oo.Document.body.innerText,'D:\a.txt') 
*!*					*_cliptext = oo.oo.Document.body.innerText 
*!*					*MessageBox('网页内容已复制到剪贴板。') 
*!*					lcText  = oo.oo.Document.body.innerText 
*!*					?lcText  
*!*					oo=null
*!*	canc
*!*	P_VICE=getmac()
*!*	mtoday=TTOD(getserverdate() )+1
*!*	CON=ODBC(5)
*!*	SQLEXEC(CON,"DELETE FROM [declaration_email]")
*!*	SQLEXEC(CON,"DELETE FROM [contacts]")
*!*	SQLDISCONNECT(CON)
*!*	CON=ODBC(6)
*!*	SQLEXEC(CON,"DELETE FROM [Attachments]")
*!*	SQLDISCONNECT(CON)
*!*	con=odbc(5)
*!*	sqlexec(con,"select top 1 receivedtime from [declaration_email] where mac=?P_VICE order by 1 desc ")
*!*	IF RECCOUNT()<1
*!*		mreceivedateend=DTOC(CTOD('2014.10.01')-1)
*!*	ELSE 
*!*		mreceivedateend=TTOC(tTOd(receivedtime )-1)
*!*	ENDIF 	
*!*	mreceivedatebegin=DTOC(mtoday)
*!*	mwhere ="[ReceivedTime]> '"+ mreceivedateend +"' AND [ReceivedTime]<'"+mreceivedatebegin + "'"

*!*	loApp = CREATEOBJECT("Outlook.application")
*!*	IF vartype( loApp ) = 'O' &&OR NOT ISNULL(loApp)
*!*		xloFolders = loApp.GetNameSpace("MAPI")
*!*		oAccount = loApp.Session.Accounts
*!*		FOR lnSubRoot = 1 TO xloFolders.Folders.COUNT
*!*			TRY 

*!*			mwhere1=ALLT(oAccount.ITEM(lnSubRoot ).SmtpAddress )
*!*			loRootFolder =xloFolders.Folders(lnSubRoot )
*!*			KEYTXT=ALLTRIM(xloFolders.Folders(lnSubRoot).NAME)
*!*			TXTKEY=KEYTXT
*!*			codeid=0
*!*			ReadMail(loRootFolder )
*!*						CATCH 
*!*							MESSAGEBOX( '系统将读取你邮件内容,OutLook警告必需选择允许,或者WINDOWS操作安全级别设置最低',0,'无法继续')
*!*							EXIT 
*!*						FINALLY
*!*						ENDTRY
*!*		ENDFOR 	
*!*	ENDIF 
*!*	Function ReadMail&&( toFolder )
*!*		PARAMETERS toFolder
*!*	    Local loItems, loItem, loFolders, loFolder,ds
*!*	    codeid=0
*!*	   	P_ASS=''

*!*	   	IF toFolder.Items.COUNT>0
*!*		    IF toFolder.Items.Item[ 1 ].CLASS=43
*!*				TRY 

*!*	    		toFolder1=toFolder.Items.Restrict(mwhere)
*!*				FOR mkeyid  = 1 TO toFolder1.COUNT
*!*					IF  toFolder1.Item[ mkeyid  ].CLASS=43 AND !EMPTY(toFolder1.Item[ mkeyid  ].SenderName)
*!*						
*!*					   	a1=toFolder1.Item[ mkeyid  ].ReceivedTime
*!*						a2=toFolder1.Item[ mkeyid  ].subject 
*!*						a3=toFolder1.Item[ mkeyid  ].SenderName
*!*						a4=ALLT(toFolder1.Item[ mkeyid  ].SenderEmailAddress)
*!*						p_cash=toFolder1.Item[ mkeyid  ].EntryID
*!*						a6=LEFT(toFolder1.Item[ mkeyid  ].to,100)
*!*						a7=toFolder1.Item[ mkeyid  ].CC
*!*						a8=toFolder1.Item[ mkeyid  ].BCC
*!*						a9=toFolder1.Item[ mkeyid  ].BodyFormat
*!*						a10=toFolder1.Item[ mkeyid  ].ReceivedByName
*!*						a11=toFolder1.Item[ mkeyid  ].SentOn
*!*						IF EMPTY(A11)
*!*							A11=NULL
*!*						ENDIF	
*!*						a113=LEFT(toFolder1.Item[ mkeyid  ].ReplyRecipientNames,100)
*!*						a12=LEFT(toFolder1.Item[ mkeyid  ].Body,1500)
*!*						*a112=INT(IIF(LEN(ALLTRIM(toFolder1.Item[ mkeyid  ].Body))/1024<1,1,LEN(ALLTRIM(toFolder1.Item[ mkeyid  ].Body))/1024+1))
*!*						a112=INT(toFolder1.Item[ mkeyid  ].Size/1024)+1
*!*						xx=ALLTRIM(toFolder.NAME)
*!*						CURSORSETPROP("MapBinary",.T.,0)

*!*						DO case
*!*							CASE a9=0 OR a9=1
*!*								a13=CAST(toFolder1.Item[ mkeyid  ].Body as w)
*!*							CASE a9=2
*!*								a13=CAST(toFolder1.Item[ mkeyid  ].HTMLBody as w)
*!*							CASE a9=3
*!*								a13=CAST(toFolder1.Item[ mkeyid  ].RTFBody as w)
*!*						ENDCASE 	 
*!*						IF SUBSTR(txtkey,len(txtkey)-LEN(xx)+1,LEN(xx))<>xx
*!*			      			TXTKEY=txtkey+'.'+xx
*!*		      			ENDIF 
*!*						IF mwhere1=a4&&LEFT(a4,AT(A4,'@')-1)=KEYTXT
*!*							MID=1
*!*						ELSE
*!*							MID=0
*!*						ENDIF	
*!*						CON=ODBC(5)
*!*						SQLEXEC(con,"select foritem from contacts where email=?a4")
*!*						IF RECCOUNT()=1
*!*							a21=foritem 
*!*						ELSE 
*!*							IF SQLEXEC(con,"INSERT INTO [contacts] ([email]) values (?a4)")>0
*!*								a21='业务员往来'
*!*								A22='PURMA'
*!*								DO CASE
*!*									CASE HR_DEPT='销售部'
*!*										a21='业务员往来'
*!*										A22='COPMA'
*!*									CASE HR_DEPT='市场部'
*!*										a21='业务员往来'
*!*										A22='marketcustom'
*!*									CASE HR_DEPT='单证'	OR HR_DEPT='计划部' OR HR_DEPT='财务部'
*!*										a21='业务员往来'
*!*										A22='PURMA'
*!*								ENDCASE 
*!*								SQLEXEC(CON,"UPDATE [contacts] SET  [hrdept]=?HR_DEPT,[fordept]=?HR_DEPT,[creatdate]=GETDATE() ,[billname]=?P_USERNAME,[source]=?KEYTXT,[senddate]=?a1,foritem =?a21,fromtable=?A22 WHERE [email]=?a4")
*!*								a=LEFT(HR_DEPT,10)
*!*								keyidc=maxinterid("Remotion")
*!*								CON1=ODBC(6)
*!*								IF SQLEXEC(CON1,"INSERT INTO remotion (interid,dateid,dept,truckno,note,statusid,keyvalue,billname,creatdate,remotion) values "+;
*!*									"(?keyidc,getdate(),?a,?A4,'','新建','邮箱登记',?p_username,getdate(),'ALL')")<0
*!*									WAIT windows ',DDD,,,,' &&,keyvalue,dept,billname,creatdate,?mkeyvalue,?P_DEPT,?p_username,getdate()
*!*								ENDIF 
*!*								SQLDISCONNECT(con1)				      		
*!*					      	ENDIF 	
*!*						ENDIF 
*!*						IF SQLEXEC(CON,"INSERT INTO [declaration_email] ([entryid]) VALUES (?p_cash)")>0
*!*							IF SQLEXEC(CON,"UPDATE [declaration_email] SET  [bodyformat]=?a9,[sendername]=?a3,[senderemaiaAddress]=?a4,[sendon]=?a11 "+;
*!*					      		",[receivedbyname]=?a10,[toreceive]=?a6 ,[cc]=?a7, [bcc]=?a8 ,[outin]=?MID,[receivedtime]=?a1,[subject]=?a2,[mac]=?P_VICE "+;
*!*					      		",[creatdate]=GETDATE() ,[dept]=?HR_DEPT,[billname]=?P_USERNAME,[sourcedir]=?TXTKEY,[body]=?a12,bodysize=?a112,replyrecipientnames=?a113,"+;
*!*					      		"classto=?HR_DEPT,classitem=?a21 WHERE [entryid]=?p_cash")>0
*!*								SQLDISCONNECT(CON)
*!*								a=LEFT(HR_DEPT,10)
*!*								keyidc=maxinterid("Remotion")
*!*								CON1=ODBC(6)
*!*								IF SQLEXEC(CON1,"INSERT INTO remotion (interid,dateid,dept,truckno,note,statusid,keyvalue,billname,creatdate,remotion) values "+;
*!*									"(?keyidc,getdate(),?a,?A4,'','读取','邮件收发',?p_username,getdate(),'ALL')")<0
*!*									WAIT windows ',,,,,' &&,keyvalue,dept,billname,creatdate,?mkeyvalue,?P_DEPT,?p_username,getdate()
*!*								ENDIF 
*!*								SQLDISCONNECT(con1)		
*!*				            	con=odbc(6)
*!*					            SQLEXEC(CON,"insert into Attachments (interid,filename,Attachments,[filesize]  ) values (?p_cash,'MainBody.Lutec',?A13,?A112)")
*!*								SQLDISCONNECT(Con)
*!*								attfolder=toFolder1.Item[ mkeyid  ].Attachments
*!*								x1=attfolder.COUNT
*!*								IF attfolder.COUNT>0
*!*									FOR lnSub1 = 1 TO attfolder.COUNT
*!*							            cFilename= attfolder.item(lnSub1 ).filename &&filename
*!*							            IF !EMPTY(cFilename) AND !ISNULL(cFilename)
*!*								            lcFileName = Fullpath( Curdir() ) + cFilename
*!*								            attfolder.item(lnSub1).SaveAsFile(lcFilename )	
*!*								            
*!*								            x=INT(FSIZE(lcFilename )/1024)
*!*								            mFileName=CAST(filetostr(lcFilename) as w)
*!*								            ERASE lcFilename 
*!*								            con=odbc(6)
*!*								            SQLEXEC(CON,"insert into Attachments (interid,filename,Attachments,[filesize] ) values (?p_cash,?cFilename,?mFileName,?x)")
*!*											SQLDISCONNECT(Con)
*!*										ENDIF 	
*!*									ENDFOR
*!*									con=odbc(5)
*!*									SQLEXEC(CON,"UPDATE [declaration_email] SET  [attacount]=?x1 WHERE [entryid]=?p_cash")
*!*									SQLDISCONNECT(con)
*!*								ENDIF 
*!*							ENDIF 
*!*						ENDIF

*!*					ELSE
*!*						TXTKEY=keytxt
*!*					ENDIF
*!*				ENDFOR 
*!*			ELSE 
*!*				TXTKEY=keytxt
*!*						CATCH 
*!*							MESSAGEBOX( '系统将读取你邮件内容,OutLook警告必需选择允许,或者WINDOWS操作安全级别设置最低',0,'无法继续')
*!*							EXIT 
*!*						FINALLY
*!*						ENDTRY
*!*			ENDIF
*!*		ELSE 
*!*			TXTKEY=keytxt
*!*		ENDIF
*!*		IF  toFolder.Folders.COUNT>0
*!*	    	FOR DS = 1 TO toFolder.Folders.COUNT
*!*		    	loFolders = toFolder.Folders(DS)
*!*	        	ReadMail( loFolders)
*!*	      	ENDFOR
*!*		ENDIF	
*!*	    Return
*!*	Endfunc    
*!*	*!*	    
*!*	*!*		FOR lnSub = 1 TO toFolder.Items.COUNT
*!*	*!*			IF  toFolder.Items.Item[ lnSub ].CLASS=43
*!*	*!*				TRY 
*!*	*!*			   	?toFolder.Items.Item[ lnSub ].ReceivedTime
*!*	*!*				?toFolder.Items.Item[ lnSub ].subject 
*!*	*!*				?toFolder.Items.Item[ lnSub ].SenderName
*!*	*!*				?toFolder.Items.Item[ lnSub ].SenderEmailAddress
*!*	*!*				?toFolder.Items.Item[ lnSub ].EntryID
*!*	*!*				?toFolder.Items.Item[ lnSub ].to
*!*	*!*				?toFolder.Items.Item[ lnSub ].CC
*!*	*!*				?toFolder.Items.Item[ lnSub ].BCC
*!*	*!*				?toFolder.Items.Item[ lnSub ].BodyFormat
*!*	*!*				?toFolder.Items.Item[ lnSub ].ReceivedByName
*!*	*!*				?toFolder.Items.Item[ lnSub ].SentOn
*!*	*!*				CATCH 
*!*	*!*					MESSAGEBOX( '系统将读取你邮件内容,OutLook警告必需选择允许,或者WINDOWS操作安全级别设置最低',0,'无法继续')
*!*	*!*					EXIT 
*!*	*!*				FINALLY
*!*	*!*				ENDTRY
*!*	*!*			ELSE
*!*	*!*				EXIT	
*!*	*!*			ENDIF
*!*	*!*		ENDFOR	
*!*	    *** Now see if this folder has folders to process
*!*	*!*	    IF toFolder.Items.Item[ 1 ].CLASS=2
*!*	*!*	*    If toFolder.CLASS=2  &&  olFolder
*!*	*!*	*!*	    	loFolders = toFolder.Folders
*!*	*!*	*!*			For Each loFolder In loFolders
*!*	*!*	*!*				P_ASS=ALLTRIM(loFolder.NAME)
*!*	*!*	*!*		          ReadMail( loFolder )
*!*	*!*	*!*		          TXTKEY=TXTKEY+'.'+P_ASS
*!*	*!*	*!*			Endfor
*!*	*!*	    	FOR lnSub = 1 TO toFolder.Folders.COUNT
*!*	*!*		    	loFolders = toFolder.Folders(lnSub)
*!*	*!*		    	P_ASS=ALLTRIM(toFolder.Folders(lnSub).NAME)
*!*	*!*	        	ReadMail( loFolders)
*!*	*!*		    	TXTKEY=TXTKEY+'.'+P_ASS
*!*	*!*		    	?TXTKEY
*!*	*!*	      	ENDFOR
*!*	*!*			TXTKEY=KEYTXT
*!*	*!*	    ELSE
*!*	*!*	      	TXTKEY=KEYTXT
*!*	*!*	    Endif
*!*		