FOR COUNTMCOUT=1 TO 3
	MFILE='D:\Data\2020010'+ALLTRIM(STR(COUNTMCOUT))+'.txt'
	IF !FILE(MFILE)
		?'no'
		LOOP
	ENDIF	
	XT=FDATE(MFILE,1)
	servetime=HOUR(XT)
	mt =TTOD(XT)
	con=odbc(6)
	SQLEXEC(con,"select interid from getsmm where (getid=0 or getid=2) and  CONVERT(char(19), creatdate, 102)=?mt ")
	SQLDISCONNECT(con)
	IF RECCOUNT()>=1
		?'yy'
		LOOP 
	ENDIF
	P_HRDEPT=STREXTRACT(STRCONV(FILETOSTR(MFILE),11),'<td class="c6">日期</td>','<div class="main-top-ads-warp">',1) &&2019.12.11变更,因为从4.1日开始,SMM变更了网站格式,因此重新截取数据
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
	dateid=XT
	yy=''
	ttd=1
	i3=0
	FOR i1=1 TO i2
		wdd=i1
		xx=yy
		tkeyid=MAXINTERID("getsmm")
		mNote1 =''
		mName = STREXTRACT(STREXTRACT(P_HRDEPT,'class="c1">','</td>',i1),'"rel="nofollow">','</a>',1)
		mName =ALLTRIM(STRt(mName ,'SMM','') )
		yy=ALLTRIM(mname)
		IF yy='升贴水'
			mName =ALLTRIM(xx)+'('+ALLTRIM(yy)+')'
		ENDIF 	
		mNote1 = STREXTRACT(STREXTRACT(P_HRDEPT,'class="c1">','</td>',i1),'declaration">','</div>',1)

		mprice = STREXTRACT(STREXTRACT(P_HRDEPT,'class="c2','/td>',i1),'>','<',1)
		mprice=ALLTRIM(STRt(mprice ,'>',' ') )
		mprice=ALLTRIM(STRt(mprice ,CHR(9),''))
		mprice=ALLTRIM(STRt(mprice ,'$',' ') )
		mprice=ALLTRIM(STRt(mprice ,"style='border-bottom:0px;'",' ') )

		
		maver = STREXTRACT(STREXTRACT(P_HRDEPT,'class="c3','/td>',i1),'>','<',1)
		maver =ALLTRIM(STRt(maver ,'>',' ') )
		maver =ALLTRIM(STRt(maver ,'$',' ') )
		maver =ALLTRIM(STRt(maver ,"style='border-bottom:0px;'",' ') )
		maver =ALLTRIM(STRt(maver ,CHR(9),''))

		
		mchange = STREXTRACT(STREXTRACT(P_HRDEPT,'class="c4','/td>',i1),'>','<',1)
		mchange =ALLTRIM(STRt(mchange ,'>',' ') )		
		mchange =ALLTRIM(STRt(mchange ,'$',' ') )		
		mchange =ALLTRIM(STRt(mchange ,"style='border-bottom:0px;'",' ') )

		mNote1 = mNote1 +'-'+ STREXTRACT(STREXTRACT(P_HRDEPT,'class="c5','/td>',i1),'>','<',1)
		mNote1 =ALLTRIM(STRt(mNote1 ,'>',' ') )		
		mNote1 =ALLTRIM(STRt(mNote1 ,'<div class="price-declaration price_declaration"',' ') )
		mNote1 =ALLTRIM(STRt(mNote1 ,'</i',' ') )		
				
		mtoday= STREXTRACT(STREXTRACT(P_HRDEPT,'class="c6','/td>',i1),'>','<',1)
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

		con=odbc(6)
		?tkeyid
		?dateid
		?mtoday 
		?mchange 
		?maver 
		?mprice 
		?mName
		?mgetid
		?mNote1 
		?SQLEXEC(con,"insert into getsmm (interid,creatdate,today,change,aver,price,name,getid,note) values (?tkeyid,?dateid,?mtoday ,?mchange ,?maver ,?mprice ,?mName,?mgetid,?mnote1 )")
		SQLDISCONNECT(con)
	ENDFOR 	
ENDFOR
