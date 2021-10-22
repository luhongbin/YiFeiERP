publ	MTC004,MTD004,MMB002,MMB003,MTD014,MTD205,MTC042,MCOST,MTD011,mprofit,MBILL,MTC003,MTC008,MTD037,MTC009,mmf002,msupplyid,msupply,cxcodeid,MTD004,MTD037,MTC008,MTC004,MTC042,MMB080,ys,mchkname,MTC006
CON=ODBC(5)
*!*	SQLEXEC(con,"delete from quotation")
*!*	SQLEXEC(con,"delete from salebom")
?SQLEXEC(CON,"SELECT DISTINCT TD004,TD037,TC008,TC004,TC042,MA002,MB109,MB410,bincode.obm "+;
"FROM COPTC INNER JOIN COPTD ON TC001=TD001 AND TC002=TD002 INNER JOIN pidetail ON COPTD.UDF56=interid INNER JOIN INVMB ON TD004=MB001 LEFT JOIN COPMA ON MA001=TC004 left join bincode on TD004=bincode.code "+;
"where LEFT(TC003,4)>='2004' AND TC027='V'  AND TC004='90574117' and TC001<>'227'   ORDER BY TC004,TD004","TMP")  &&AND TD011>0
SQLDISCONNECT(con)
GO TOP
DO WHILE .NOT. EOF()
	MTD004=ALLTRIM(TD004)
	MTD037=TD037
	MTC008=ALLTRIM(TC008)
	MTC004=ALLTRIM(TC004)
	MTC042=ALLTRIM(TC042)
	MMA002=ALLTRIM(MA002)
	TY=MB109
	TQ=MB410 
	ddds=obm
	cxcodeid=maxinterid("quotation")
	con=odbc(5)
	SQLEXEC(CON,"SELECT TOP 1 TD004,MB002,MB003,ISNULL(MB080,'') MB080,ISNULL(TD014,'') TD014,TD205,TD011,TD037,TC008,TC009,TC004,TC042,TC003,case when MB025='P' THEN MB057 ELSE MB061+MB062+MB063 END AS COST,"+;
	"TD001+TD002+TD003 BILL,TC006,chkdate,chkname,mf002,supplyid,supply "+;
	",MB025,ISNULL(MA003,'') MA003,MB057+MB058+MB059+MB060 CB,RTRIM(TD001)+TD002 mct,MB061,MB062,MB063 "+;
	" from COPTC INNER JOIN COPTD ON TC001=TD001 AND TC002=TD002 INNER JOIN pidetail ON COPTD.UDF56=pidetail.interid INNER JOIN INVMB ON TD004=MB001 INNER JOIN pi on pi.interid=pidetail.maininterid "+;
	"left join INVMA ON  MA001='4' AND MB008=MA002 WHERE TD004=?MTD004 ORDER BY TC003 DESC","TTT")  && AND TC027='Y' AND TD011>0 AND TC042=?MTC042  4 AND TD037=?MTD037 AND TC008=?MTC008
	cdate=DTOC(DATE(),1)

*!*		SQLEXEC(CON,"select TOP 1 MG004,MG002  FROM CMSMG WHERE MG001=?MTC008 AND MG002<=?CDATE ORDER BY MG002 DESC")
*!*		
*!*		IF RECCOUNT()<1
*!*			MESSAGEBOX('币种不存在',0+47+1,'币种是必须的')
*!*			SELECT TmpBOMMF
*!*			BROWSE 
*!*			RETURN 
*!*		ENDIF	
	MTC008 ='RMB'
	WW13=1&&MG004	
	SQLDISCONNECT(con)
	SELECT TTT
	MTD205=ALLTRIM(LEFT(MB002,40))
	MMB080=ALLTRIM(MB080)
	IF MTD004<'A'
		MMB002=ALLTRIM(MB002)
		MMB003=ALLTRIM(MB003)
		mcolor=MMB003
		IF !EMPTY(ALLTRIM(TD014)) AND TD014<>MMB080
			IF TD014<>TD004
				MMB003=MMB003+'['+ALLTRIM(TD014)+']'
			ENDIF	
		ENDIF
	ELSE
		MMB002='['+ALLTRIM(MMB080)+']'+ALLTRIM(MB002)
		MMB003=''
		IF !EMPTY(ALLTRIM(MA003))
			MMB003=ALLTRIM(MA003)
		ENDIF
		mcolor=MMB003

		MMB003=MMB003+'['
		IF !EMPTY(ALLTRIM(TD014)) AND TD014<>MMB080
			IF TD014<>TD004
				MMB003=MMB003+ALLTRIM(TD014)+':'
			ENDIF	
		ENDIF
		MMB003=MMB003+ALLTRIM(MMA002)+']'
	ENDIF	
	MTD014=ALLTRIM(TD014)
	MTD011=TD011
	MTC009=WW13
	MTC003=TC003
	MCOST=COST
	JG=CB
	MTC006=ALLTRIM(TC006)
	MBILL='订单:'+BILL
	mta=MCT
	mchkdate=chkdate
	mchkname =ALLTRIM(chkname)
	IF MTD011*MTC009=0
		mprofit=0
	ELSE
		mprofit=(MTD011*MTC009-MCOST)/(MTD011*MTC009)*100
	ENDIF	
	mmf002=mf002
	msupplyid=ALLTRIM(supplyid)
	msupply=ALLTRIM(supply)
	M0=MB025
	YS=ALLTRIM(MA003)
	m58=mb061
	m59=mb062
	m60=mb063
	MMB002=ALLTRIM(LEFT(MMB002,60))
	MMB003=ALLTRIM(LEFT(MMB003,60))
	RED=RECNO()
	con=odbc(5)
	IF SQLEXEC(con,"insert into quotation (customid,code,name,spec,customcode,customspec,[payment],[cost]"+;
    " ,[price]      ,[profit]      ,[note]      ,[pricenote]      ,[begindate]      ,[enddate]"+;
    " ,[currency],[taxrate],[exchangerate]   ,[tosupplyid] ,[supplyid] ,[supplyname],interid,mb057,mb058,mb059,mb060) values "+;
		"( ?MTC004,?MTD004,?MMB002,?MMB003,?MTD014,?MTD205,?MTC042,?MCOST,?MTD011,0,?MBILL,'1.客户计价',?MTC003,'20161231',?MTC008"+;
	",?MTD037,?MTC009,?mmf002,?msupplyid,?msupply,?cxcodeid,?MCOST,?m58,?m59,?m60)")<0
		SELECT TTT
		WAIT WINDOWS '1X' nowait
		*BROWSE
		*RETURN 
	ENDIF
	IF SQLEXEC(con,"UPDATE quotation SET bomchkid=1,bomman=?p_userCODE,bomdate=getdate(),itemno=?MMB080,color=?mcolor,chkdate=GETDATE(),chkman=?mchkname, "+;
	"chkid=1,billname=?MTC006,moq=0,creatdate=getdate(),stopid=0 WHERE interid=?cxcodeid")<0
	SQLDISCONNECT(con)
	con=odbc(5)
	SQLEXEC(con,"UPDATE quotation SET bomchkid=1,bomman=?p_userCODE,bomdate=getdate(),itemno=?MMB080,stopid=0  WHERE interid=?cxcodeid")	
	SQLEXEC(con,"UPDATE quotation SET chkid=0,chkdate=getdate(),chkman=?mchkname WHERE interid=?cxcodeid")	
	SQLEXEC(con,"UPDATE quotation SET color=?YS,billname=?MTC006,moq=?TQ,creatdate=getdate() WHERE interid=?cxcodeid")	
	ENDIF
	IF TY='Y' and ddds=0
		SQLEXEC(con,"UPDATE quotation SET stopid=0 WHERE interid=?cxcodeid")	
	else	
		SQLEXEC(con,"UPDATE quotation SET stopid=1 WHERE interid=?cxcodeid")	
	ENDIF
	IF Mmf002='Y' OR (M0='P' AND MTD004<'A') 
		SQLEXEC(con,"select TOP 1 D.TD002,D.TD010*D1.TC006 PRICE FROM PURTD D INNER JOIN PURTC D1 ON D.TD001=D1.TC002 AND D.TD002=D1.TC002 INNER JOIN COPTC X ON D.TD024=RTRIM(X.TC001)+X.TC002 "+;
		" WHERE TD004=?MTD004 AND TD018='Y' AND X.TC004=?MTC004 AND D.TD010>0  ORDER BY 1 DESC")  &&*(1+D.TD033)
		IF RECCOUNT()=1
			JG=PRICE
			SQLEXEC(con,"UPDATE quotation SET chkid=1,cost=?JG WHERE interid=?cxcodeid")&&,profit=(price*exchangerate-?jg)/(price*exchangerate)*100 
		ELSE 	
			IF MTD004<'A' 
				SQLEXEC(con,"UPDATE quotation SET chkid=1,cost=?JG WHERE interid=?cxcodeid")&&,profit=(price*exchangerate-?jg)/(price*exchangerate)*100 
			ELSE
				SQLEXEC(con,"UPDATE quotation SET chkid=0,cost=?JG WHERE interid=?cxcodeid")&&,profit=(price*exchangerate-?jg)/(price*exchangerate)*100 
			ENDIF	
		ENDIF	

	ELSE

		IF SQLEXEC(CON,"SELECT TOP 1 TA001,TA002,TA003 "+;
		"from MOCTA INNER JOIN COPTC ON RTRIM(TC001)+TC002=TA033 INNER JOIN COPTD ON TD001=TC001 AND TD002=TC002 where TA033=?mta and TA006=?MTD004 "+;
			"and (TA001='512' OR TA001='511') AND TC004=?MTC004 AND TD014=?MTD014 AND TA013='Y'  ORDER BY TA003 DESC","T231")<0
		WAIT WINDOWS '2' 
		ENDIF
		IF RECCOUNT()=1
			T1=TA001
			T2=TA002	
			IF SQLEXEC(CON,"SELECT DISTINCT TA003,TB003,CASE WHEN MD001 IS NULL THEN TB004/TA015 ELSE MD006 END ZC,CASE WHEN MD001 IS NULL THEN 1 ELSE MD007 END DS,CASE WHEN MD001 IS NULL THEN '1' ELSE MD010 END TD "+;
			",ISNULL(MD001,'无BOM') BOM,(C.MB057+C.MB058+C.MB059+C.MB060)*TB004/TA015 AS COST,C.MB057*TB004/TA015 mb057,C.MB058*TB004/TA015 mb058,C.MB059*TB004/TA015 mb059 ,C.MB060*TB004/TA015 mb060,b.MB025  "+;
			"from MOCTA INNER JOIN MOCTB ON TA001=TB001 AND TA002=TB002 LEFT JOIN COPTD ON RTRIM(TD001)+TD002=TA033   "+;
				"INNER JOIN pidetail on interid=COPTD.UDF56 left JOIN INVMB b ON TD004=b.MB001 LEFT JOIN  INVMA ON b.MB008=MA002 AND MA001='4' inner join INVMB C ON TB003=C.MB001"+;
				" LEFT JOIN BOMMD ON TA006=MD001 AND TB003=MD003 "+;
				" where TA001=?T1 AND TA002=?T2 ORDER BY TA003 DESC","T231")<0
				WAIT WINDOWS '3' 
			ENDIF
			IF RECCOUNT()>=1
				XX=MB025
				SUM cost,mb057,mb058,mb059,mb060 TO JG,m57,m58,m59,m60
				GO TOP
				DO WHILE .NOT. EOF()
					T1=ALLTRIM(TB003)
					T2=ZC
					T3=DS
					T4=TD
					T5=BOM

					SQLEXEC(CON,"Insert into salebom (interid,code,quan,rate,replacements,note) values (?cxcodeid,?T1,?t2,?t3,?t4,?t5)")
					SELECT T231
					SKIP
				ENDDO	
				SQLEXEC(con,"UPDATE quotation SET chkid=1,cost=cost+?jg,mb059=mb059+?m59,mb058=mb058+?m58,mb060=mb060+?m60,mb057=?m57 WHERE interid=?cxcodeid")
			ELSE 	
				SQLEXEC(con,"UPDATE quotation SET cost=?JG,mb059=0,mb058=0,mb060=0,mb057=0,chkid=0,bomchkid=0 WHERE interid=?cxcodeid")
				*SQLEXEC(con,"UPDATE quotation SET profit=(price*exchangerate-cost)/(price*exchangerate)*100 WHERE interid=?cxcodeid")

			ENDIF
		ELSE
			SQLEXEC(con,"UPDATE quotation SET cost=0,mb059=0,mb058=0,mb060=0,mb057=0,chkid=0,bomchkid=0 WHERE interid=?cxcodeid")
			*SQLEXEC(con,"UPDATE quotation SET profit=(price*exchangerate-cost)/(price*exchangerate)*100 WHERE interid=?cxcodeid")

		ENDIF	
	ENDIF	

	SQLDISCONNECT(con)
		*SQLEXEC(con,"insert into quotation ([customid],[code],[name],[spec],[customcode],[customspec] ,[payment],[cost]"+;
    " ,[price]      ,[profit]      ,[note]      ,[pricenote]      ,[creatdate]      ,[begindate]      ,[enddate]"+;
    " ,[currency],[taxrate],[exchangerate]      ,[moq]      ,[billname]      ,[chkid]      ,[chkdate]"+;
    " ,[chkman],[tosupplyid] ,[supplyid] ,[supplyname]) values "+;
	"( ?MTC004,?MTD004,?MMB002,?MMB003,?MTD014,?MTD205,?MTC042,?MCOST,?MTD011,?mprofit,?MBILL,'客户计价',getdate(),?MTC003,'20161231',?MTC008"+;
	",?MTD037,?MTC008,0,?MTC006,1,?mchkdate,?mchkname ,?mmf002,?msupplyid,?msupply)")
	SELECT TMP
	SKIP
ENDDO	


*SQLEXEC(CON,"SELECT TD004,TD005,TD006,MB080,TD014,TD205,TD011,TD037,TC008,TC009,TC004,TC042,TC003")