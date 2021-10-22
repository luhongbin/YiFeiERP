*!*	FOR I1=20170621 TO 20170630
*!*		y= 'D:\'+STR(I1,8,0)+'.txt'
*!*		?Y
	COPY file 'D:\20170703.TXT' to 'c:\UTF8格式4.txt'
	=GETSMM()
*!*	ENDFOR
FUNCTION getsmm
*!*		XT=getserverdate()
*!*		servetime=HOUR(XT)
*!*		mt =TTOD(XT)
*!*		CON=ODBC(6)
*!*		SQLEXEC(con,"select interid from getsmm where (getid=0 or getid=2) and  CONVERT(char(19), creatdate, 102)=?mt ")
*!*		SQLDISCONNECT(con)
*!*		IF RECCOUNT()>=1
*!*			RETURN 
*!*		ENDIF 	

	*P_HRDEPT=STREXTRACT(FILETOSTR("c:\UTF8格式4.txt"),'<th>市场</th>','<div class="tl-price" id="tabs-2" style="display:none">',1)
	*P_HRDEPT=STREXTRACT(STRCONV(FILETOSTR("c:\UTF8格式4.txt"),11),'fifth">日期</td>','<div class="content-left-first-footer">',1) &&2016.10.19变更,因为从10.17日开始,SMM变更了网站格式,因此重新截取数据
	P_HRDEPT=STREXTRACT(STRCONV(FILETOSTR("c:\UTF8格式4.txt"),11),'fifth">日期</td>','</tbody>',1) &&2017.5.1变更,因为从4.1日开始,SMM变更了网站格式,因此重新截取数据
	P_HRDEPT=STRt(P_HRDEPT,' "','"')
	P_HRDEPT=STRt(P_HRDEPT,'" ','"') 
	P_HRDEPT=STRt(P_HRDEPT,CHR(9),'')
	P_HRDEPT=STRt(P_HRDEPT,CHR(13),'')
	P_HRDEPT=STRt(P_HRDEPT,CHR(10),'')

*!*		P_HRDEPT=STRt(P_HRDEPT,STREXTRACT(P_HRDEPT,'<!--','-->',1),'')&&2017.5.1变更,因为从4.1日开始,SMM变更了网站格式,因此重新截取数据
*!*		P_HRDEPT=STRt(P_HRDEPT,STREXTRACT(P_HRDEPT,'<!--','-->',1),'')
	*apiStartTags ='<td class="name"'
	apiStartTags ='https://hq.smm.cn'&&'href="http://hq.smm.cn'&&2017.5.1变更,因为从4.1日开始,SMM变更了网站格式,因此重新截取数据
	i2=occurs(apiStartTags ,P_HRDEPT)
	dateid=getserverdate()
	yy=''
	ttd=1
	i3=0
	FOR i1=1 TO i2
		wdd=i1
		xx=yy
		tkeyid=MAXINTERID("getsmm")
		mName = STREXTRACT(STREXTRACT(P_HRDEPT,'<td class="content-left-first-pirce-table-first"','</td>',i1),'">','</a>',2)
		mName =ALLTRIM(STRt(mName ,'SMM','') )
		yy=ALLTRIM(mname)
		IF yy='升贴水'
			mName =ALLTRIM(xx)+'('+ALLTRIM(yy)+')'
		ENDIF 	
		mprice = STREXTRACT(STREXTRACT(P_HRDEPT,'content-left-first-pirce-table-second','/td>',i1),'>','<',1)
		mprice=ALLTRIM(STRt(mprice ,'>',' ') )
		mprice=ALLTRIM(STRt(mprice ,CHR(9),''))
		mprice=ALLTRIM(STRt(mprice ,'$',' ') )
		mprice=ALLTRIM(STRt(mprice ,"style='border-bottom:0px;'",' ') )

		maver = STREXTRACT(STREXTRACT(P_HRDEPT,'content-left-first-pirce-table-third','/td>',i1),'>','<',1)
		maver =ALLTRIM(STRt(maver ,'>',' ') )
		maver =ALLTRIM(STRt(maver ,'$',' ') )
		maver =ALLTRIM(STRt(maver ,"style='border-bottom:0px;'",' ') )
		maver =ALLTRIM(STRt(maver ,CHR(9),''))

		mchange = STREXTRACT(STREXTRACT(P_HRDEPT,'content-left-first-pirce-table-fourth','/td>',i1),'>','<',1)
		mchange =ALLTRIM(STRt(mchange ,'>',' ') )		
		mchange =ALLTRIM(STRt(mchange ,'$',' ') )		
		mchange =ALLTRIM(STRt(mchange ,"style='border-bottom:0px;'",' ') )
		mtoday= STREXTRACT(STREXTRACT(P_HRDEPT,'content-left-first-pirce-table-fifth','/td>',i1),'>','<',1)
		mtoday=ALLTRIM(STRt(mtoday,'>',' ') )		
		mtoday=ALLTRIM(STRt(mtoday,'$',' ') )

		IF hour(dateid)>16
			mgetid=0
			IF left(mtoday,2)+SUBSTR(mtoday,4,2)<>SUBSTR(DTOC(TTOD(dateid),1),5,4)
				IF ':'$mtoday=.t. 
					IF  ttd=0
						mgetid=0
					ELSE 	
						mgetid=2
						ttd=1
					ENDIF 	
				ELSE 	
					mgetid=2
					ttd=1
				ENDIF 	
			ELSE 
				ttd=0	
				mgetid=0
			ENDIF 
		ELSE
			mgetid=1
		ENDIF 
mgetid =0
dateid=CTOT('2017.07.03 16:00:00')
		con=odbc(6)
		SQLEXEC(con,"insert into getsmm (interid,creatdate,today,change,aver,price,name,getid) values (?tkeyid,?dateid,?mtoday ,?mchange ,?maver ,?mprice ,?mName,?mgetid )")
		SQLDISCONNECT(con)
	ENDFOR 	
ENDFUNC
