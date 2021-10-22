FOR COUNTMCOUT=11 TO 31
	MFILE='D:\Data\201912'+ALLTRIM(STR(COUNTMCOUT))+'.txt'
	IF !FILE(MFILE)
		LOOP
	ENDIF	
	XT=FDATE(MFILE,1)
	servetime=HOUR(XT)
	mt =TTOD(XT)
	con=odbc(6)
	SQLEXEC(con,"select interid from getsmm where (getid=0 or getid=2) and  CONVERT(char(19), creatdate, 102)=?mt ")
	SQLDISCONNECT(con)
	IF RECCOUNT()>=1
		?'YY'
		LOOP 
	ENDIF
	P_HRDEPT=STREXTRACT(STRCONV(FILETOSTR(MFILE),11),'div class="box-body"','</tbody>',1) &&2017.5.1变更,因为从4.1日开始,SMM变更了网站格式,因此重新截取数据
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
		TD1=LEN(mprice)
		CSS=''
		FOR TD=1 TO TD1
			CDDS=SUBSTR(mprice,TD,1)
			DO CASE
				CASE CDDS='2'
					CSS=CSS+'0'
				CASE CDDS='4'
					CSS=CSS+'1'
				CASE CDDS='1'
					CSS=CSS+'2'
				CASE CDDS='5'
					CSS=CSS+'3'
				CASE CDDS='9'
					CSS=CSS+'4'
				CASE CDDS='8'
					CSS=CSS+'5'
				CASE CDDS='7'
					CSS=CSS+'6'
				CASE CDDS='3'
					CSS=CSS+'7'
				CASE CDDS='6'
					CSS=CSS+'8'
				CASE CDDS='0'
					CSS=CSS+'9'
				OTHERWISE 
					CSS=CSS+CDDS	
			ENDCASE
		ENDFOR	
		mprice= CSS
		
		maver = STREXTRACT(STREXTRACT(P_HRDEPT,'content-left-first-pirce-table-third','/td>',i1),'>','<',1)
		maver =ALLTRIM(STRt(maver ,'>',' ') )
		maver =ALLTRIM(STRt(maver ,'$',' ') )
		maver =ALLTRIM(STRt(maver ,"style='border-bottom:0px;'",' ') )
		maver =ALLTRIM(STRt(maver ,CHR(9),''))
		TD1=LEN(maver )
		CSS=''
		FOR TD=1 TO TD1
			CDDS=SUBSTR(maver ,TD,1)
			DO CASE
				CASE CDDS='2'
					CSS=CSS+'0'
				CASE CDDS='4'
					CSS=CSS+'1'
				CASE CDDS='1'
					CSS=CSS+'2'
				CASE CDDS='5'
					CSS=CSS+'3'
				CASE CDDS='9'
					CSS=CSS+'4'
				CASE CDDS='8'
					CSS=CSS+'5'
				CASE CDDS='7'
					CSS=CSS+'6'
				CASE CDDS='3'
					CSS=CSS+'7'
				CASE CDDS='6'
					CSS=CSS+'8'
				CASE CDDS='0'
					CSS=CSS+'9'
				OTHERWISE 
					CSS=CSS+CDDS	
			ENDCASE
		ENDFOR	
		maver = CSS
		
		mchange = STREXTRACT(STREXTRACT(P_HRDEPT,'content-left-first-pirce-table-fourth','/td>',i1),'>','<',1)
		mchange =ALLTRIM(STRt(mchange ,'>',' ') )		
		mchange =ALLTRIM(STRt(mchange ,'$',' ') )		
		mchange =ALLTRIM(STRt(mchange ,"style='border-bottom:0px;'",' ') )
		TD1=LEN(mchange )
		CSS=''
		FOR TD=1 TO TD1
			CDDS=SUBSTR(mchange ,TD,1)
			DO CASE
				CASE CDDS='2'
					CSS=CSS+'0'
				CASE CDDS='4'
					CSS=CSS+'1'
				CASE CDDS='1'
					CSS=CSS+'2'
				CASE CDDS='5'
					CSS=CSS+'3'
				CASE CDDS='9'
					CSS=CSS+'4'
				CASE CDDS='8'
					CSS=CSS+'5'
				CASE CDDS='7'
					CSS=CSS+'6'
				CASE CDDS='3'
					CSS=CSS+'7'
				CASE CDDS='6'
					CSS=CSS+'8'
				CASE CDDS='0'
					CSS=CSS+'9'
				OTHERWISE 
					CSS=CSS+CDDS	
			ENDCASE
		ENDFOR	
		mchange = VAL(CSS)
				
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

		con=odbc(6)
		?tkeyid
		?dateid
		?mtoday 
		?mchange 
		?maver 
		?mprice 
		?mName
		?mgetid
		?SQLEXEC(con,"insert into getsmm (interid,creatdate,today,change,aver,price,name,getid) values (?tkeyid,?dateid,?mtoday ,?mchange ,?maver ,?mprice ,?mName,?mgetid )")
		SQLDISCONNECT(con)
	ENDFOR 	
ENDFOR
