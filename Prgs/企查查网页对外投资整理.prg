CON=ODBC(1)
SQLEXEC(CON,"SELECT TOP 1  a.NAME ,A.URL,a.id,a.DWTZ,tznr FROM [SHANGSHIMINGDAN] b left join [shangshi] a on a.name=b.name WHERE dwtz >0  ORDER BY 1","TMP")
SELECT TMP
DO WHIL NOT. EOF()
	gdxx=tznr
	i=OCCURS('class="text-lg c_a"',gdxx)
	FOR I1=1 TO I
				X1=STREXTRACT(STREXTRACT(gdxx,'class="m-t-xs">','</a>',I1),'>','')
*!*					SQLEXEC(CON,"INSERT INTO [outinvestinfo] ([company],[outcompany]) values (?qude,?X1)")
				X2=STREXTRACT(STREXTRACT(gdxx,X1,'对外投资与任职'),'target="_blank">','</a>') &&法人
				x4=ALLTRIM(STREXTRACT(STREXTRACT(gdxx,'对外投资与任职','<span',I1),CHR(10),CHR(10))) &&注册资金
				x4=STRTRAN(x4,' ','')
				x7=ALLTRIM(STREXTRACT(STREXTRACT(gdxx,'对外投资与任职','<span',I1),'class="text-center">'+CHR(10),CHR(10),2)) &&投资比例w
				x3=left(STREXTRACT(STREXTRACT(gdxx,'对外投资与任职','<span',I1),'class="text-center">'+CHR(10),'</td>',3),10) &&成立日期
				x5=STREXTRACT(STREXTRACT(gdxx,'<span','</span>',I1),'">','') &&状态
				x6='firm_'+STREXTRACT(gdxx, 'href="/firm_','"',i1)  &&链接
*!*					IF SQLEXEC(CON,"update [outinvestinfo] set [href]=?x6,[dateid]=?x3 , [boss]=?x2,[cash]=?x4,[radio]=?x7,[statusid]=?x5 where [company]=?qude and [outcompany]=?X1")<0
*!*						*WAIT WINDOWS '23'+x2+x1+x5+X7+X4+X3
*!*						*WAIT WINDOWS X6
*!*					ENDIF	
				?X1
				?X2
				?X4
				?X5
				?X6
				?X4
				?X7
*!*					IF LEN(x1)>10
*!*						IF SQLEXEC(CON,"SELECT  website FROM fromweb WHERE NAME =?X1")<0
*!*							*WAIT WINDOWS '24'
*!*						ENDIF	
*!*						IF RECCOUNT()<1 
*!*							IF SQLEXEC(CON,"SELECT [nameid]  FROM [headinfodetail] WHERE NAME =?X1")<0
*!*								*WAIT WINDOWS '25'
*!*							ENDIF	
*!*							IF RECCOUNT()<1 OR ISNULL(nameid)
*!*								IF SQLEXEC(con,"INSERT INTO fromweb (name,BILLNAME,namesource,website) values (?X1,?p_username,'对外投资',?x6)")<0
*!*									*WAIT WINDOWS '27'
*!*								ENDIF	
*!*							ENDIF 
*!*						ENDIF 	
*!*					ENDIF 
	ENDFOR
	SELECT TMP
	SKIP
ENDDO		