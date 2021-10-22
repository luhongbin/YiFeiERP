PROCEDURE pimocta
PARAMETERS W11
	CON=ODBC(5)
	SQLEXEC(CON,"SELECT pidetail.interid,customid from pidetail inner join pi on pidetail.maininterid=pi.interid where maininterid=?w11","tmppi2mocta")
	SQLDISCONNECT(con)
	SELECT tmppi2mocta
	DO whil .not. EOF()
		mkeyid=interid 
		premocta(mkeyid)
*!*			con=odbc(5)
*!*			SQLEXEC(con,"SELECT interid,code,p57,p58,p59,p60,p57/ta015+p58+p59+p60 price from pmocta  where detailinterid=?mkeyid","tmp")
*!*			DO WHILE .NOT. EOF()
*!*				xx=price
*!*				x1=interid
*!*				x2=code
*!*				SQLEXEC(con,"update pmoctb set price=?xx where maininterid=?x1 and code=?x2")
*!*				SELECT tmp
*!*				skip
*!*			ENDDO 
		SELECT tmppi2mocta
		skip
	ENDDO 
	CON1=ODBC(6)
	SQLEXEC(con1,"delete from piapprove where keyinterid=?w11 and keyvalue <> 1")
	SQLDISCONNECT(CON1)
	ccodeid=maxinterid("piapprove")
	CON1=ODBC(6)

	SQLEXEC(CON1,"INSERT INTO piapprove (interid,note,chkname,chkdate,keyinterid,dept,action) values (?ccodeid,'生成PI工艺成本', ?P_UserName,GETDATE(), ?W11,?HR_DEPT,'导入')")
	SQLDISCONNECT(CON1)

ENDPROC 

PROCEDURE packmoctb
PARAMETERS w11
	CON=ODBC(5)
 	SQLEXEC(CON,"SELECT b.interid,b.maininterid,MB001,MC012,MA003,b.quan,b.addi FROM pmocta a inner join pmoctb b on a.interid=b.maininterid "+;
 	"inner join pidetail on pidetail.interid=a.detailinterid inner join pi on pi.interid=pidetail.maininterid inner join INVMB ON b.tb003=MB001 "+;
 	"LEFT JOIN INVMA ON MB006=MA002 AND MA001='2' LEFT JOIN INVMC ON MB017 = MC002 AND MB001 = MC001 "+;
 	"WHERE (MA003='彩包' OR MA003='彩贴') and pi.interid=?w11","tmppk",xt)
 	IF xt[2]>1
 		DO whil .not. EOF()
 			x1=MB001
 			X2=QUAN
 			X3=ADDI
 			X4=ALLTRIM(MC012)
 			X5=MA003
			SQLEXEC(CON,"SELECT SUM(TD008-TD015) as 在途量 FROM PURTD WHERE TD016='N' AND TD018='Y' AND TD004=?x1")
			zt=在途量
			IF MA003='彩包'
	 			IF x4='' AND zt=0
	 				xx='彩包新制版'
	 			ELSE
	 				XX='老版'
	 			ENDIF	
	 		ENDIF	
			SQLEXEC(CON,"SELECT b.interid,b.maininterid,MB001,MC012,MA003,b.quan,b.addi FROM pmocta a inner join pmoctb b on a.interid=b.maininterid "+;
		 	"inner join pidetail on pidetail.interid=a.detailinterid inner join pi on pi.interid=pidetail.maininterid  "+;
		 	"WHERE b.tb003=?x1 and (pi.chkid=0 or pi.statusid='终审' OR pi.statusid='ERP审核')")
 			
 			SELECT tmppk
 			skip
 		ENDDO 
 	ENDIF 
	SQLDISCONNECT(con)
ENDPROC 	
PROCEDURE premocta
PARAMETERS 	w10
	RELEASE  mclassid1,C6,HH
	PUBLIC mclassid1,C6
	knote=''
	mclassid1=''
	CON=ODBC(5)
	SQLEXEC(con,"select top 1 a.quan,a.code,a.name,a.spec,a.mf002,case when T.MB025='M' then a.supplyid else T.MB067 END supplyid ,"+;
	"a.supply,a.edate,x.piinterid,T.MB080 ,T.MB003,a.mcw mb057,a.mcd mb058,a.mch mb059,a.mccmb mb060,T.MB025,T.MB046,T.MB067,T.MB068,T.MB032,a.maininterid,T.MB006,V.MA003,a.priceinterid "+;
	"from pidetail a  inner join INVMB T ON T.MB001=a.code left join pidetailcallforecast x on a.interid=x.piinterid "+;
	" LEFT JOIN INVMA V ON V.MA001='4' AND V.MA002=T.MB006 where a.interid=?w10 and LEFT(a.code,1)<>'X' union all "+;
	"select a.totalpcs quan,a.code,T.MB002 name,T.MB003 spec,case when T.MB025='M' THEN 'N' ELSE 'Y' END mf002,"+;
	"case when MB025='M' THEN T.MB068 ELSE T.MB067 END supplyid,case when T.MB025='M' THEN T.MB068 ELSE T.MB032 END supply,x.edate,2 piinterid,"+;
	"T.MB080 ,T.MB003,T.MB057,T.MB058,T.MB059,T.MB060,T.MB025,T.MB046,T.MB067,T.MB068,T.MB032,x.maininterid,T.MB006,V.MA003,x.priceinterid "+;
	"from exportcode a inner join INVMB T ON T.MB001=a.code LEFT JOIN INVMA V ON V.MA001='4' AND V.MA002=T.MB006 inner join pidetail x on a.pidetailinterid=x.interid "+;
	"where a.pidetailinterid=?w10 ","tmpsql",xt)
	IF xt[2]<1
		SQLDISCONNECT(con)
		RETURN 
	ENDIF 
	SQLEXEC(con,"delete from pmocta  where pmocta.detailinterid=?w10")
	SQLEXEC(con,"SELECT interid from pmocta  where pmocta.detailinterid=?w10")
	DO whil .not. EOF()
		x=interid
		SQLEXEC(con,"delete from pmoctb where maininterid=?x")
		SKIP
	ENDDO 	

	SELECT tmpsql
	DO WHILE .NOT. EOF()
		Mmf002=mf002
		Msupplyid=supplyid
		m1code=code
		xname=name
		xspec=spec
		msupply=supply
		mquan=quan
		C6=MA003	
		HH=MB080
		mname=name
		mspec=spec
		fdsdate=edate
		M1=MB057*mquan
		M2=MB058*mquan
		M3=MB059*mquan
		M4=MB060*mquan
		m5=M1+m2+m3+m4
		N1=0
		N2=0
		M0=MB025
		T68=MB032
		M67=MB067
		M68=MB068		
		IF ISNULL(piinterid) OR piinterid=2
			IF Mmf002='Y' 
				IF  m1code<'A' &&OR LEFT(m1code,1)='Z'
					IF MB025='S'
						mclassid='512'
						knote='委外'	
					ELSE	
						mclassid='311'
					ENDIF	
				ELSE
					IF MB025='P' 
						mclassid='335'
					ENDIF
				ENDIF	
			ELSE 
				IF  m1code<'A' &&OR LEFT(m1code,1)='Z'
					IF MB025='S'
						mclassid='512'
						knote='委外'	
					ENDIF	
					IF MB025='P'
						mclassid='311'
					ENDIF	
					IF MB025='M'
						mclassid='511'
						knote='自产'	
					ENDIF
				ELSE
					IF MB025='M'
						mclassid='511'
					ENDIF	
				ENDIF 	
			ENDIF 						
			IF MB025='P'
				knote='采购'	
			ENDIF
		ELSE
			IF MB025<>'P' 
				mclassid='525'
			ELSE
				mclassid='335'
			ENDIF 
			knote='调预测'	
		ENDIF
		M0=MB025
		

		IF piinterid=2
			knote='调拨['+ALLTRIM(m1code)+']'
			medate=DTOC(CTOD(LEFT(edate,4)+'.'+SUBSTR(edate,5,2)+'.'+SUBSTR(edate,7,2))-7,1)
		ELSE	
			knote=knote+',主件['+ALLTRIM(m1code)+']'
			medate=edate
		ENDIF	
		n3=''&&标准单价'

		IF LEFT(T68,1)='Y'
			tsupplyid=MB032
		ENDIF

		IF Mmf002='Y' OR (M0='P' AND m1code<'A') &&OR LEFT(m1code,1)='Z' &&外购
			T68=MB032
			M67=MB067
			M68=MB068		
			Msupplyid=MB032

*!*				IF tnbcmb=0
				N3=''&&新产品,请有关人员暂估单价,然后再提交审批!'	
*!*				ENDI	
			if m1code<'A'
				mclassid='311'
			ELSE 
				mclassid='335'
			ENDIF 
			minterid=maxinterid("pmocta")
			IF SQLEXEC(CON,"INSERT INTO pmocta (interid,detailinterid,code,ta015,ta030,ta021,ta010,classid,name,spec,lowlevel,note,source,buyer) "+;
				"values (?minterid,?w10,?m1code,?mquan,?M0,?Msupplyid,?medate,?mclassid,?mname,?mspec,0,?knote,?n3,?M67)")<0
				WAIT windows '第一.?5FF323F??' 
			ENDIF 		
			m5 =m1+m2+m3+m4
			Sqlexec(con,"update pmocta set  mb057=?m1,mb058=?m2,mb059=?m3,mb060=?m4,mbuyprice=?m5 WHERE interid=?minterid")
			IF mclassid='511' OR mclassid='512'
				SELECT tmpsql
				x1mwcode=priceinterid
				getbom1(x1mwcode,mquan,fdsdate,mclassid,minterid)
				CLOSEDB("T231")
			ELSE
				cinterid=maxinterid("pmoctb")
				IF SQLEXEC(CON,"INSERT INTO pmoctb (interid,maininterid,tb003,quan,price,addi,stprice,name,spec,ta021,buyer,source) "+;
					"values (?cinterid,?minterid,?m1code,?mquan,?0,0,?m5,?mname,?mspec,?Msupplyid,?M67,?n3)")<0
					WAIT windows '第一.?5FFF??' 
				ENDIF 
			ENDIF 	
		ELSE &&自产

			T68=MB032
			M67=MB067
			M68=MB068		
			Msupplyid=M68

			minterid=maxinterid("pmocta")
			codeid=minterid
			IF SQLEXEC(CON,"INSERT INTO pmocta (interid,detailinterid,code,ta015,ta030,ta021,ta010,classid,name,spec,lowlevel,note,source) "+;
						"values (?minterid,?w10,?m1code,?mquan,?M0,?Msupplyid,?medate,?mclassid,?mname,?mspec,0,?knote,?n3)")<0
				WAIT windows '第一.???'  
			ENDIF 
			M5=M1+M4+m2+m3
			
			IF Sqlexec(con,"update pmocta set  mb057=?m1,mb058=?m2,mb059=?m3,mb060=?m4,mbuyprice=?m5,"+;
			"p57=?n1,p60=?n2,buyer=?M67 WHERE interid=?minterid")<0  &&,pbuyprice=?n1+?n2*ta015
				WAIT windows '?F4FF??' 
			ENDIF 	

			IF mclassid='511' OR mclassid='512'
				SELECT tmpsql
				x1mwcode=priceinterid
				getbom1(x1mwcode,mquan,fdsdate,mclassid,minterid)
				knote=ALLTRIM(knote)+',源自'+ALLTRIM(STR(x1mwcode))
				CLOSEDB("T231")			
		 		IF SQLEXEC(con,"update pmocta set pbuyprice=(select SUM(addi) price from pmoctb where maininterid=?minterid),"+;
				"p57=(select SUM(price*quan) price from pmoctb where maininterid=?minterid),note=?knote  where interid=?minterid")<0
					WAIT windows '?1FFFP31237??' NOWAIT 
				ENDIF 		
			ELSE
				cinterid=maxinterid("pmoctb")
				IF SQLEXEC(CON,"INSERT INTO pmoctb (interid,maininterid,tb003,quan,price,addi,stprice,name,spec,ta021,buyer,source) "+;
					"values (?cinterid,?minterid,?m1code,?mquan,?m5,0,?m5,?mname,?mspec,?Msupplyid,?M67,?n3)")<0
					WAIT windows '?5FFF??' NOWAIT 
				ENDIF 	
			ENDIF 
		ENDIF 

		SELECT tmpsql
		SKIP
	ENDDO
*!*		IF Sqlexec(con,"update pidetail set lastprice=(select SUM(p57+p58*ta015+p59*ta015+p60*ta015) price from pmocta where detailinterid=?w10 and pidetail.code=pmocta.code),"+;
*!*			"lastquan=(select SUM(pbuyprice) price from pmocta where detailinterid=?w10  and pidetail.code=pmocta.code),"+;
*!*			"stprice=(select SUM(mb057+mb058+mb059+mb060) price from pmocta where detailinterid=?w10  and pidetail.code=pmocta.code) WHERE  interid=?W10")<0
*!*			WAIT windows '?1FFF??' NOWAIT 
*!*		ENDIF
	SQLDISCONNECT(CON)

	CON1=ODBC(6)
	ccodeid=maxinterid("piapprove")
	SQLEXEC(CON1,"INSERT INTO piapprove (interid,note,chkname,chkdate,keyinterid,dept,action,detailinterid) values (?ccodeid,'生成PI工艺成本细节', ?P_UserName,GETDATE(), ?keyid,?HR_DEPT,'自动',?w10)")
	SQLDISCONNECT(CON1)
ENDPROC 

FUNCTION getbom1
PARAMETERS xmwcode,mquan,medate,mclassid,minterid
	m1wcode=xmwcode
	mquan1=mquan
	t2interid=minterid
	ec1=medate
*!*		IF SQLEXEC(CON,"SELECT '' MD001,s.code MD003,s.quan/s.rate 组成用量,MB002,MB003, MB046 单价,'标准进价' AS 来源,MB057,MB058,MB059,MB060,MB067,MB068,MB025,MC012,MA003,MB032,"+;
*!*			"case when b.nbcmb is null then 0 else b.nbcmb end nbcmb,b.nbkgs,b.nbw,b.nbd, "+;				
*!*			"case when b.nbh is null then 0 else b.nbh end nbh,b.innerbarcode,MB006 "+;				
*!*			" FROM salebom s INNER JOIN INVMB ON MB001=s.code LEFT JOIN INVMA ON MB006=MA002 AND MA001='2' LEFT JOIN INVMC ON MB017 = MC002 AND MB001 = MC001 left join bincode b on MB001=b.code "+;
*!*			"WHERE s.interid=?m1wcode","TMP1",XT)<0
*!*			WAIT WINDOW 'BOM1'  &&salebom 
*!*		ENDIF	
	IF SQLEXEC(CON,"SELECT MD001,MD003,MD006/MD007 组成用量,MB002,MB003, MB046 单价,'标准进价' AS 来源,MB057,MB058,MB059,MB060,MB067,MB068,MB025,MC012,MA003,MB032,"+;
	"case when b.nbcmb is null then 0 else b.nbcmb end nbcmb,b.nbkgs,b.nbw,b.nbd, "+;				
	"case when b.nbh is null then 0 else b.nbh end nbh,b.innerbarcode "+;				
	" FROM BOMMD INNER JOIN INVMB ON MB001=MD003 LEFT JOIN INVMA ON MB006=MA002 AND MA001='2' LEFT JOIN INVMC ON MB017 = MC002 AND MB001 = MC001 left join bincode b on MB001=b.code "+;
	"WHERE MD014='Y' AND MD001=?m1code AND MD012=''","TMP1",XT)<0
	WAIT WINDOW 'BOM1'
	ENDIF
	IF xt[2]>0
		SELECT TMP1
		GO TOP
		DO WHIL .NOT. EOF()
			TCODE=MD003
			t1code=MD003
			tname=MB002
			tspec=MB003

			tquan=组成用量*mquan1
			M1=MB057*tquan
			M2=MB058*tquan
			M3=MB059*tquan
			M4=MB060*tquan
			M5=M1+M4+M2+M3
			t68=MB067
			t25=mb025
			tn5=nbcmb+nbh&&单价
			tsupplyid=MB032
			CBCT=MA003
			RKSJ=ALLTRIM(MC012)
			n1=nbcmb
			n2=nbh 			
			n3=innerbarcode
			DFD=MD001
			IF t25='M'
				mclassid1='511'
				tsupplyid=MB068
			ENDIF	
			IF t25='S'
				mclassid1='512'
				tsupplyid=MB032
			ENDIF			
			e1=DTOC(CTOD(LEFT(ec1,4)+'.'+SUBSTR(ec1,5,2)+'.'+SUBSTR(ec1,7,2))-7,1)
			knote=''&&'主件['+ALLTRIM(DFD)+']'&&,源自'+m1wcode


*!*				IF TN5=0
*!*					SQLEXEC(CON,"UPDATE pmocta set nocashid=1 where detailinterid=?w10")
*!*				ENDIF
			cinterid1=maxinterid("pmoctb")
			SQLEXEC(CON,"INSERT INTO pmoctb (interid,maininterid,tb003,quan,price,addi,stprice,name,spec,ta021,buyer,attr,source) "+;
			"values (?cinterid1,?t2interid,?t1code,?tquan,?tn5,0,?m5,?tname,?tspec,?tsupplyid,?t68,?t25,?n3)")

			SELECT tmp1
			t25=mb025
			IF T25<>'P'
				m1interid=maxinterid("pmocta")
				SQLEXEC(CON,"INSERT INTO pmocta (interid,detailinterid,code,ta015,ta030,ta021,ta010,classid,name,spec,lowlevel,source,note) "+;
				"values (?m1interid,?w10,?t1code,?tquan,?t25,?tsupplyid,?e1,?mclassid1,?tname,?tspec,1,?n3,?knote)")
				M5=M1+M4
				n5=n1+n2
				IF Sqlexec(con,"update pmocta set mb057=?m1,mb058=?m2,mb059=?m3,mb060=?m4,mbuyprice=?m5,p57=?n1,p60=?n2,buyer=?T68 WHERE interid=?m1interid")<0  &&pbuyprice=?n5,
					WAIT windows '?F4FF??' NOWAIT 
				ENDIF 	
				m1wcode=TCODE
				getbom2(m1wcode,tquan,e1,mclassid1,m1interid)

				IF SQLEXEC(con,"update pmocta set pbuyprice=(select SUM(addi) price from pmoctb where maininterid=?m1interid),"+;
					"p57=(select SUM(price*quan) price from pmoctb where maininterid=?m1interid)  where interid=?m1interid")<0
					WAIT windows '?1FFFP542347??' NOWAIT 
				ENDIF 
				IF SQLEXEC(con,"update pmoctb set price=(select (p57/ta015 +p58+p59+p60)   price from pmocta where interid=?m1interid) where interid=?cinterid1")<0
					WAIT windows '?1FFFP234571??' NOWAIT 
				ENDIF 
			ELSE
				IF CBCT='彩包' OR  CBCT='彩贴'
					SQLEXEC(CON,"SELECT SUM(TD008-TD015) as 在途量 FROM PURTD WHERE TD016='N' AND TD018='Y' AND TD004=?TCODE")
					zt=在途量
					DO CASE
						CASE CBCT='彩包'
							IF RKSJ=='' AND zt=0
								DO CASE
									CASE tquan<600
						 				xx='新制版费:400,起步费:400元;'
						 				YY=800
						 			CASE tquan<1000 AND tquan>=600
						 				xx='新制版费:400,起步费:免;'
						 				YY=400
						 			OTHERWISE
						 				XX='新制版够数,免附加费'	
						 				YY=0
						 		ENDCASE		
					 		ELSE
								DO CASE
									CASE tquan<600
						 				xx='老版起步费:400元;'
						 				YY=400
						 			OTHERWISE
						 				XX='老版够数,免起步费'	
						 				YY=0
						 		ENDCASE		
					 		ENDIF	
						CASE CBCT='彩贴'
							IF RKSJ=='' AND zt=0
								DO CASE
						 			CASE tquan<1000 
						 				xx='新版起步费:200;'
						 				YY=200
						 			OTHERWISE
						 				XX='新版够数,免附加费'	
						 				YY=0
						 		ENDCASE		
					 		ELSE
				 				XX='老版,免起步费'	
						 		YY=0
					 		ENDIF	
					ENDCASE	
					SQLEXEC(CON,"UPDATE pmoctb set addi=?yy,note=?xx where interid=?cinterid1")
				ENDIF	
			ENDIF 


			SELECT TMP1
			SKIP
		ENDDO	
	ELSE 
*!*			ccodeid=maxinterid("piapprove")
*!*			m1codec2='['+ALLTRIM(m1code)+']该品号没有BOM,请技术部立即制作BOM,否则无法核算成本,做好BOM之后,在PI审批中执行[重新生成审批单据]重新计算成本!'
*!*			CON1=ODBC(6)
*!*			*SQLEXEC(CON1,"INSERT INTO piapprove (interid,note,chkname,chkdate,keyinterid,dept,action) values (?ccodeid,?m1codec2, ?P_UserName,GETDATE(), ?keyid,?HR_DEPT,'缺BOM')")
*!*			SQLDISCONNECT(CON1)
*!*			tmpkeyid=maxinterid("rtxmessage")
*!*			CON1=ODBC(6)
*!*			mrev=ALLTRIM(P_UserName)+';王文雅;彭秀娟;陈冲俞;桑丹丹;'
*!*			*SQLEXEC(con1,"insert rtxmessage (interid,toman,billname,creatdate,note,title) values (?tmpkeyid,?mrev,?P_UserName,getdate(),?m1codec2,'缺BOM')")
*!*			SQLDISCONNECT(CON1)
	ENDIF	
ENDFUNC 

FUNCTION getbom2
PARAMETERS mwcode,mquan,medate,mclassid,minterid
	m11wcode=mwcode

	mquan2=mquan
	t1interid=minterid
	ec2=medate

	IF SQLEXEC(CON,"SELECT MD001,MD003,MD006/MD007 组成用量,MB002,MB003, MB046 单价,'标准进价' AS 来源,MB057,MB058,MB059,MB060,MB067,MB068,MB025,MC012,MA003,MB032,"+;
		"case when b.nbcmb is null then 0 else b.nbcmb end nbcmb,b.nbkgs,b.nbw,b.nbd, "+;				
		"case when b.nbh is null then 0 else b.nbh end nbh,b.innerbarcode,MB006 "+;				
		" FROM BOMMD INNER JOIN INVMB ON MB001=MD003 LEFT JOIN INVMA ON MB006=MA002 AND MA001='2' LEFT JOIN INVMC ON MB017 = MC002 AND MB001 = MC001 left join bincode b on MB001=b.code "+;
		"WHERE MD014='Y' AND MD001=?m11wcode AND MD012=''","TMP2",XT)<0
		WAIT WINDOW 'BOM1'
	ENDIF

	knote='主件['+ALLTRIM(m11wcode)+']'&&源自'+m1wcode
	

	IF xt[2]>0
		SELECT TMP2
		GO TOP
		DO WHIL .NOT. EOF()
			TCODE2=MD003
			t1code=MD003
			tname=MB002
			tspec=MB003
			IF MB006='PT'
				tspec=mcolor
			ENDIF
			tquan=组成用量*mquan2
			M1=MB057*tquan
			M2=MB058*tquan
			M3=MB059*tquan
			M4=MB060*tquan

			M5=M1+M4+M2+M3
			tsupplyid=MB032
			t68=MB067
			t25=mb025
			tn5=nbcmb+nbh
			IF t25='M'
				mclassid1='511'
				tsupplyid=MB068
			ENDIF	
			IF t25='S'
				mclassid1='512'
				tsupplyid=MB032
			ENDIF			
			n1=nbcmb
			n2=nbh 			
			n3=innerbarcode
			e2=DTOC(CTOD(LEFT(ec2,4)+'.'+SUBSTR(ec2,5,2)+'.'+SUBSTR(ec2,7,2))-7,1)


			IF TN5=0
				SQLEXEC(CON,"UPDATE pmocta set nocashid=1 where detailinterid=?w10")
			ENDIF
			cinterid2=maxinterid("pmoctb")
			SQLEXEC(CON,"INSERT INTO pmoctb (interid,maininterid,tb003,quan,price,addi,stprice,name,spec,ta021,buyer,attr,source) "+;
			"values (?cinterid2,?t1interid,?t1code,?tquan,?tn5,0,?m5,?tname,?tspec,?tsupplyid,?t68,?t25,?n3)")

			SELECT tmp2
			t25=mb025
			IF T25<>'P'
				minterid2=maxinterid("pmocta")
				SQLEXEC(CON,"INSERT INTO pmocta (interid,detailinterid,code,ta015,ta030,ta021,ta010,classid,name,spec,lowlevel,source) "+;
				"values (?minterid2,?w10,?t1code,?tquan,?t25,?tsupplyid,?e2,?mclassid1,?tname,?tspec,2,?n3)")
				M5=M1+M4
				n5=n1+n2
				IF Sqlexec(con,"update pmocta set mb057=?m1,mb058=?m2,mb059=?m3,mb060=?m4,mbuyprice=?m5,p57=?n1,p60=?n2,buyer=?T68,note=?knote WHERE interid=?minterid2")<0  &&pbuyprice=?n5,
					WAIT windows '?F4FF??' NOWAIT 
				ENDIF 	

				getbom3(TCODE2,tquan,e2,mclassid,minterid2)
				IF SQLEXEC(con,"update pmocta set pbuyprice=(select SUM(addi) price from pmoctb where maininterid=?minterid2),"+;
					"p57=(select SUM(price*quan) price from pmoctb where maininterid=?minterid2)  where interid=?minterid2")<0
					WAIT windows '?1FFFP5123455667??' NOWAIT 
				ENDIF 				
				IF SQLEXEC(con,"update pmoctb set price=(select (p57/ta015 +p58+p59+p60)  price from pmocta where interid=?minterid2) where interid=?cinterid2")<0
					WAIT windows '工艺线路中成本更新失败,不过不影响导入,是个问题,无需理睬...' NOWAIT 
				ENDIF 

			ENDIF 	
			SELECT TMP2
			SKIP
		ENDDO	
	ENDIF	
ENDFUNC 

FUNCTION getbom3
PARAMETERS m1code,mquan,medate,mclassid,minterid
	m1code =m1code
	mquan3=mquan
	t3interid=minterid
	ec3=medate
	IF SQLEXEC(CON,"SELECT MD001,MD003,MD006/MD007 组成用量,MB002,MB003, MB046 单价,'标准进价' AS 来源,MB057,MB058,MB059,MB060,MB067,MB068,MB025,MC012,MA003,MB032,"+;
		"case when b.nbcmb is null then 0 else b.nbcmb end nbcmb,b.nbkgs,b.nbw,b.nbd, "+;				
		"case when b.nbh is null then 0 else b.nbh end nbh,b.innerbarcode "+;				
		" FROM BOMMD INNER JOIN INVMB ON MB001=MD003 LEFT JOIN INVMA ON MB006=MA002 AND MA001='2' LEFT JOIN INVMC ON MB017 = MC002 AND MB001 = MC001 left join bincode b on MB001=b.code "+;
		"WHERE MD014='Y' AND MD001=?m1code AND MD012=''","TMP3",XT)<0
		WAIT WINDOW 'BOM1'
	ENDIF	

	knote='主件['+ALLTRIM(m1code)+']'&&源自'+m1wcode

	IF xt[2]>0
		SELECT TMP3
		GO TOP
		DO WHIL .NOT. EOF()
			TCODE=MD003
			t1code=MD003
			tname=MB002
			tspec=MB003
			tquan=组成用量*mquan3
			M1=MB057*tquan
			M2=MB058*tquan
			M3=MB059*tquan
			M4=MB060*tquan
			mby=MB032

			M5=M1+M4+M2+M3
			tsupplyid=MB032
			n1=nbcmb
			n2=nbh 			
			n3=innerbarcode
			t68=MB067
			t25=mb025
			tn5=n1+n2
			e3=DTOC(CTOD(LEFT(ec3,4)+'.'+SUBSTR(ec3,5,2)+'.'+SUBSTR(ec3,7,2))-7,1)

			IF t25='M'
				mclassid1='511'
				tsupplyid=MB068
			ENDIF	
			IF t25='S'
				mclassid1='512'
				tsupplyid=MB032
			ENDIF			


			IF TN5=0
				SQLEXEC(CON,"UPDATE pmocta set nocashid=1 where detailinterid=?w10")
			ENDIF
			cinterid3=maxinterid("pmoctb")
			SQLEXEC(CON,"INSERT INTO pmoctb (interid,maininterid,tb003,quan,price,addi,stprice,name,spec,ta021,buyer,attr,source) "+;
			"values (?cinterid3,?t3interid,?t1code,?tquan,?tn5,0,?m5,?tname,?tspec,?tsupplyid,?t68,?t25,?n3)")

			SELECT tmp3
			t25=mb025
			IF T25<>'P'
				minterid3=maxinterid("pmocta")
				SQLEXEC(CON,"INSERT INTO pmocta (interid,detailinterid,code,ta015,ta030,ta021,ta010,classid,name,spec,lowlevel,source) "+;
				"values (?minterid3,?w10,?t1code,?tquan,?t25,?tsupplyid,?e3,?mclassid1,?tname,?tspec,3,?n3)")
				M5=M1+M4
				n5=n1+n2
				IF Sqlexec(con,"update pmocta set mb057=?m1,mb058=?m2,mb059=?m3,mb060=?m4,mbuyprice=?m5,p57=?n1,p60=?n2,buyer=?T68,note=?knote WHERE interid=?minterid3")<0  &&pbuyprice=?n5,
					WAIT windows '?F4FF??' NOWAIT 
				ENDIF 	

				getbom4(t1code,tquan,e3,mclassid,minterid3)
				IF SQLEXEC(con,"update pmocta set pbuyprice=(select SUM(addi) price from pmoctb where maininterid=?minterid3),"+;
					"p57=(select SUM(price*quan) price from pmoctb where maininterid=?minterid3)  where interid=?minterid3")<0
					WAIT windows '?1FFFP59??' NOWAIT 
				ENDIF 
				IF SQLEXEC(con,"update pmoctb set price=(select (p57/ta015 +p58+p59+p60)   price from pmocta where interid=?minterid3) where interid=?cinterid3")<0
					WAIT windows '?1FFFP60??' NOWAIT 
				ENDIF 
			ENDIF 	
			SELECT TMP3
			SKIP
		ENDDO	
	ENDIF
ENDFUNC 
FUNCTION getbom4
PARAMETERS m1code,mquan,medate,mclassid,minterid
	m14code =m1code
	mquan4=mquan
	t34interid=minterid
	ec341=medate
	IF SQLEXEC(CON,"SELECT MD001,MD003,MD006/MD007 组成用量,MB002,MB003, MB046 单价,'标准进价' AS 来源,MB057,MB058,MB059,MB060,MB067,MB068,MB025,MC012,MA003,MB032,"+;
		"case when b.nbcmb is null then 0 else b.nbcmb end nbcmb,b.nbkgs,b.nbw,b.nbd, "+;				
		"case when b.nbh is null then 0 else b.nbh end nbh,b.innerbarcode "+;				
		" FROM BOMMD INNER JOIN INVMB ON MB001=MD003 LEFT JOIN INVMA ON MB006=MA002 AND MA001='2' LEFT JOIN INVMC ON MB017 = MC002 AND MB001 = MC001 left join bincode b on MB001=b.code "+;
		"WHERE MD014='Y' AND MD001=?m14code AND MD012=''","TMP4",XT)<0
		WAIT WINDOW 'BOM1'
	ENDIF	

	knote='主件['+ALLTRIM(m14code )+']'&&源自'+m1wcode

	IF xt[2]>0
		SELECT TMP4
		GO TOP
		DO WHIL .NOT. EOF()
			TCODE=MD003
			t1code=MD003
			tname=MB002
			tspec=MB003
			tquan=组成用量*mquan4
			M1=MB057*tquan
			M2=MB058*tquan
			M3=MB059*tquan
			M4=MB060*tquan
			mby=MB032

			M5=M1+M4+M2+M3
			tsupplyid=MB032
			n1=nbcmb
			n2=nbh 			
			n3=innerbarcode
			t68=MB067
			t25=mb025
			tn5=n1+n2
			e341=ec341&&DTOC(CTOD(LEFT(ec341,4)+'.'+SUBSTR(ec341,5,2)+'.'+SUBSTR(ec341,7,2))-7,1)
			IF t25='M'
				mclassid1='511'
				tsupplyid=MB068
			ENDIF	
			IF t25='S'
				mclassid1='512'
				tsupplyid=MB032
			ENDIF			

			IF TN5=0
				SQLEXEC(CON,"UPDATE pmocta set nocashid=1 where detailinterid=?w10")
			ENDIF
			cinterid4=maxinterid("pmoctb")
			SQLEXEC(CON,"INSERT INTO pmoctb (interid,maininterid,tb003,quan,price,addi,stprice,name,spec,ta021,buyer,attr,source) "+;
			"values (?cinterid4,?t34interid,?t1code,?tquan,?tn5,0,?m5,?tname,?tspec,?tsupplyid,?t68,?t25,?n3)")

			SELECT TMP4
			t25=mb025
			IF T25<>'P'
				minterid4=maxinterid("pmocta")
				SQLEXEC(CON,"INSERT INTO pmocta (interid,detailinterid,code,ta015,ta030,ta021,ta010,classid,name,spec,lowlevel,source) "+;
				"values (?minterid4,?w10,?t1code,?tquan,?t25,?tsupplyid,?e341,?mclassid1,?tname,?tspec,4,?n3)")
				M5=M1+M4+M2+M3
				n5=n1+n2
				IF Sqlexec(con,"update pmocta set mb057=?m1,mb058=?m2,mb059=?m3,mb060=?m4,mbuyprice=?m5,p57=?n1,p60=?n2,buyer=?T68,note=?knote WHERE interid=?minterid4")<0  &&pbuyprice=?n5,
					WAIT windows '?F4FF??' NOWAIT 
				ENDIF 	

				getbom5(m1wcode,tquan,e341,mclassid,minterid4)
				IF SQLEXEC(con,"update pmocta set pbuyprice=(select SUM(addi) price from pmoctb where maininterid=?minterid4),"+;
					"p57=(select SUM(price*quan) price from pmoctb where maininterid=?minterid4)   where interid=?minterid4")<0
					WAIT windows '?1FFFP471??' NOWAIT 
				ENDIF 
				IF SQLEXEC(con,"update pmoctb set price=(select (p57/ta015 +p58+p59+p60) price  from pmocta where interid=?minterid4) where interid=?cinterid4")<0
					WAIT windows '?1FFFP271??' NOWAIT 
				ENDIF 
			ENDIF 	
			SELECT TMP4
			SKIP
		ENDDO	
	ENDIF
ENDFUNC 
FUNCTION getbom5
PARAMETERS m1code,mquan,medate,mclassid,minterid
	m14code =m1code
	mquan4=mquan
	t35interid=minterid
	e34=medate
	IF SQLEXEC(CON,"SELECT MD001,MD003,MD006/MD007 组成用量,MB002,MB003, MB046 单价,'标准进价' AS 来源,MB057,MB058,MB059,MB060,MB067,MB068,MB025,MC012,MA003,MB032,"+;
		"case when b.nbcmb is null then 0 else b.nbcmb end nbcmb,b.nbkgs,b.nbw,b.nbd, "+;				
		"case when b.nbh is null then 0 else b.nbh end nbh,b.innerbarcode "+;				
		" FROM BOMMD INNER JOIN INVMB ON MB001=MD003 LEFT JOIN INVMA ON MB006=MA002 AND MA001='2' LEFT JOIN INVMC ON MB017 = MC002 AND MB001 = MC001 left join bincode b on MB001=b.code "+;
		"WHERE MD014='Y' AND MD001=?m14code AND MD012=''","TMP5",XT)<0
		WAIT WINDOW 'BOM1'
	ENDIF	

	knote='主件['+ALLTRIM(m14code )+']'&&源自'+m1wcode

	IF xt[2]>0
		SELECT TMP5
		GO TOP
		DO WHIL .NOT. EOF()
			TCODE=MD003
			t1code=MD003
			tname=MB002
			tspec=MB003
			tquan=组成用量*mquan2
			M1=MB057*tquan
			M2=MB058*tquan
			M3=MB059*tquan
			M4=MB060*tquan

			M5=M1+M4+M2+M3
			tsupplyid=MB032
			n1=nbcmb
			n2=nbh 			
			mby=MB032
			
			t67=MB067
			t25=mb025
			tn5=n1+n2
			IF t25='M'
				mclassid1='511'
				tsupplyid=MB068
			ENDIF	
			IF t25='S'
				mclassid1='512'
				tsupplyid=MB032
			ENDIF			

			IF TN5=0
				SQLEXEC(CON,"UPDATE pmocta set nocashid=1 where detailinterid=?w10")
			ENDIF
			cinterid5=maxinterid("pmoctb")
			SQLEXEC(CON,"INSERT INTO pmoctb (interid,maininterid,tb003,quan,price,addi,stprice,name,spec,ta021,buyer,attr,source) "+;
			"values (?cinterid5,?t35interid,?t1code,?tquan,?tn5,0,?m5,?tname,?tspec,?tsupplyid,?t68,?t25,?n3)")

			SELECT TMP5
			t25=mb025
			IF T25<>'P'
				minterid5=maxinterid("pmocta")
				SQLEXEC(CON,"INSERT INTO pmocta (interid,detailinterid,code,ta015,ta030,ta021,ta010,classid,name,spec,lowlevel,source,buyer) "+;
				"values (?minterid5,?w10,?t1code,?tquan,?t25,?tsupplyid,?e34,?mclassid1,?tname,?tspec,5,?n3,?t67)")
				M5=M1+M4
				n5=n1+n2
				IF Sqlexec(con,"update pmocta set mb057=?m1,mb058=?m2,mb059=?m3,mb060=?m4,mbuyprice=?m5,p57=?n1,p60=?n2,buyer=?t67,note=?knote WHERE interid=?minterid5")<0  &&pbuyprice=?n5,
					WAIT windows '?F4FF??' NOWAIT 
				ENDIF 	

				getbom6(t1code,tquan,e34,mclassid,minterid5)
				IF SQLEXEC(con,"update pmocta set pbuyprice=(select SUM(addi) price from pmoctb where maininterid=?minterid5),"+;
					"p57=(select SUM(price*quan) price from pmoctb where maininterid=?minterid5)  where interid=?minterid5")<0
					WAIT windows '?1FFFP432??' NOWAIT 
				ENDIF 
				IF SQLEXEC(con,"update pmoctb set price=(SELECT (p57/ta015 +p58+p59+p60) price from pmocta where interid=?minterid5) where interid=?cinterid5")<0
					WAIT windows '?1FFFP234??' NOWAIT 
				ENDIF 
			ENDIF 	
			SELECT TMP5
			SKIP
		ENDDO	
	ENDIF
ENDFUNC 
FUNCTION getbom6
PARAMETERS m1code,mquan,medate,mclassid,minterid
	m1code6 =m1code
	mquan6=mquan
	ec6=medate
	cdinterid6=minterid

	IF SQLEXEC(CON,"SELECT MD001,MD003,MD006/MD007 组成用量,MB002,MB003, MB046 单价,'标准进价' AS 来源,MB057,MB058,MB059,MB060,MB067,MB068,MB025,MC012,MA003,MB032,"+;
		"case when b.nbcmb is null then 0 else b.nbcmb end nbcmb,b.nbkgs,b.nbw,b.nbd, "+;				
		"case when b.nbh is null then 0 else b.nbh end nbh,b.innerbarcode "+;				
		" FROM BOMMD INNER JOIN INVMB ON MB001=MD003 LEFT JOIN INVMA ON MB006=MA002 AND MA001='2' LEFT JOIN INVMC ON MB017 = MC002 AND MB001 = MC001 left join bincode b on MB001=b.code "+;
		"WHERE MD014='Y' AND MD001=?m1code6 AND MD012=''","TMP5",XT)<0
		WAIT WINDOW 'BOM1'
	ENDIF	

	knote='主件['+ALLTRIM(m14code )+']'&&源自'+m1wcode


	IF xt[2]>0
		SELECT TMP6
		GO TOP
		DO WHIL .NOT. EOF()
			TCODE=MD003
			t1code=MD003
			tname=MB002
			tspec=MB003
			tquan=组成用量*mquan6
			M1=MB057*tquan
			M2=MB058*tquan
			M3=MB059*tquan
			M4=MB060*tquan
			n3=innerbarcode
			M5=M1+M4+M2+M3
			tsupplyid=MB032
			t68=MB067
			IF LEFT(T68,1)='Y'
				tsupplyid=MB032
			ENDIF
			t25=mb025
			n1=nbcmb
			n2=nbh 				
			tn5=n1+n2
			mby=MB032
			e4=DTOC(CTOD(LEFT(ec4,4)+'.'+SUBSTR(ec4,5,2)+'.'+SUBSTR(ec4,7,2))-7,1)
			IF t25='M'
				mclassid='511'
			ENDIF	
			IF t25='S'
				mclassid='512'
			ENDIF
			IF TN5=0
				SQLEXEC(CON,"UPDATE pmocta set nocashid=1 where detailinterid=?w10")
			ENDIF
			cinterid6=maxinterid("pmoctb")
			SQLEXEC(CON,"INSERT INTO pmoctb (interid,maininterid,tb003,quan,price,addi,stprice,name,spec,ta021,buyer,attr,source) "+;
			"values (?cinterid6,?cdinterid6,?t1code,?tquan,?tn5,0,?m5,?tname,?tspec,?tsupplyid,?t68,?t25,?n3)")
			SELECT TMP6
			SKIP
		ENDDO	
	ENDIF
ENDFUNC 


 
FUNCTION CopyFiles2Clipboard
PARAMETERS taFileList
DIMENSION taFileList(1)
LOCAL lnDataLen, lcDropFiles, llOk, i, lhMem, lnPtr
#DEFINE CF_HDROP 15
 
*  Global Memory Variables with Compile Time Constants
#DEFINE GMEM_MOVABLE 	0x0002
#DEFINE GMEM_ZEROINIT	0x0040
#DEFINE GMEM_SHARE	0x2000
 
* Load required Windows API functions
=LoadApiDlls()
 
llOk = .T.
* Build DROPFILES structure
lcDropFiles = ;
		CHR(20) + REPLICATE(CHR(0),3) + ; 	&& pFiles
		REPLICATE(CHR(0),8) + ; 		&& pt
		REPLICATE(CHR(0),8)  			&& fNC + fWide
* Add zero delimited file list
FOR i= 1 TO ALEN(taFileList,1)
	* 1-D and 2-D (1st column) arrays
	lcDropFiles = lcDropFiles + IIF(ALEN(taFileList,2)=0, taFileList[i], taFileList[i,1]) + CHR(0)
ENDFOR
* Final CHR(0)
lcDropFiles = lcDropFiles + CHR(0)
lnDataLen = LEN(lcDropFiles)
* Copy DROPFILES structure into the allocated memory
lhMem = GlobalAlloc(GMEM_MOVABLE+GMEM_ZEROINIT+GMEM_SHARE, lnDataLen)
lnPtr = GlobalLock(lhMem)
=CopyFromStr(lnPtr, @lcDropFiles, lnDataLen)
=GlobalUnlock(lhMem)
* Open clipboard and store DROPFILES into it
llOk = (OpenClipboard(0) <> 0)
IF llOk
	=EmptyClipboard()
	llOk = (SetClipboardData(CF_HDROP, lhMem) <> 0)
	* If call to SetClipboardData() is successful, the system will take ownership of the memory
	*   otherwise we have to free it
	IF NOT llOk
		=GlobalFree(lhMem)
	ENDIF
	* Close clipboard 
	=CloseClipboard()
ENDIF
RETURN llOk
 
FUNCTION LoadApiDlls
*  Clipboard Functions
DECLARE LONG OpenClipboard IN WIN32API LONG HWND
DECLARE LONG CloseClipboard IN WIN32API
DECLARE LONG EmptyClipboard IN WIN32API
DECLARE LONG SetClipboardData IN WIN32API LONG uFormat, LONG hMem
*  Memory Management Functions
DECLARE LONG GlobalAlloc IN WIN32API LONG wFlags, LONG dwBytes
DECLARE LONG GlobalFree IN WIN32API LONG HMEM
DECLARE LONG GlobalLock IN WIN32API LONG HMEM
DECLARE LONG GlobalUnlock IN WIN32API LONG HMEM
DECLARE LONG RtlMoveMemory IN WIN32API As CopyFromStr LONG lpDest, String @lpSrc, LONG iLen
RETURN

FUNCTION getgd1
PARAMETERS mwcode,m1code,mquan,medate,mclassid,minterid
	m1wcode=mwcode
	m1code =m1code
	mquan1=mquan
	t2interid=minterid
	ec1=medate
	IF SQLEXEC(con,"select DISTINCT TA006 MD001,TB003 MD003,TB004/TA015 组成用量,MB002,MB003, MB046 单价,'标准进价' AS 来源,MB057,MB058,MB059,MB060,MB067,MB068,MB025,'' MC012,MA003,MB032,"+;
	"case when b.nbcmb is null then 0 else b.nbcmb end nbcmb,b.nbkgs,b.nbw,b.nbd, "+;				
	"case when b.nbh is null then 0 else b.nbh end nbh,b.innerbarcode,TA001,TA002 "+;				
	" FROM MOCTA INNER JOIN MOCTB ON TA001=TB001 AND TA002=TB002 INNER JOIN INVMB ON MB001=TB003 "+;
	"LEFT JOIN INVMA ON MB006=MA002  LEFT JOIN INVMC ON MB017 = MC002 AND MB001 = MC001 left join bincode b on MB001=b.code "+;
	"WHERE TA033=?m1wcode and TA006=?m1code","TMP1",XT)<0
	WAIT WINDOW 'BOM1'
	ENDIF
	IF xt[2]>0
		SELECT TMP1
		GO TOP
		DO WHIL .NOT. EOF()
			TCODE=MD003
			t1code=MD003
			tname=MB002
			tspec=MB003
			tquan=组成用量*mquan1
			M1=MB057*tquan
			M2=MB058*tquan
			M3=MB059*tquan
			M4=MB060*tquan
			M5=M1+M4+M2+M3
			t68=MB067
			t25=mb025
			tn5=nbcmb+nbh&&单价
			tsupplyid=MB032
			CBCT=MA003
			RKSJ=ALLTRIM(MC012)
			n1=nbcmb
			n2=nbh 			
			n3=innerbarcode
			IF t25='M'
				mclassid1='511'
				tsupplyid=MB068
			ENDIF	
			IF t25='S'
				mclassid1='512'
				tsupplyid=MB032
			ENDIF		
			GDH=TA001+TA002	
			e1=DTOC(CTOD(LEFT(ec1,4)+'.'+SUBSTR(ec1,5,2)+'.'+SUBSTR(ec1,7,2))-7,1)
			knote='主件['+ALLTRIM(m1code)+'],源自'+GDH


			IF TN5=0
				SQLEXEC(CON,"UPDATE pmocta set nocashid=1 where detailinterid=?w10")
			ENDIF
			cinterid1=maxinterid("pmoctb")
			SQLEXEC(CON,"INSERT INTO pmoctb (interid,maininterid,tb003,quan,price,addi,stprice,name,spec,ta021,buyer,attr,source) "+;
			"values (?cinterid1,?t2interid,?t1code,?tquan,?tn5,0,?m5,?tname,?tspec,?tsupplyid,?t68,?t25,?n3)")

			SELECT tmp1
			t25=mb025
			IF T25<>'P'
				m1interid=maxinterid("pmocta")
				SQLEXEC(CON,"INSERT INTO pmocta (interid,detailinterid,code,ta015,ta030,ta021,ta010,classid,name,spec,lowlevel,source,note) "+;
				"values (?m1interid,?w10,?t1code,?tquan,?t25,?tsupplyid,?e1,?mclassid1,?tname,?tspec,1,?n3,?knote)")
				M5=M1+M4
				n5=n1+n2
				IF Sqlexec(con,"update pmocta set mb057=?m1,mb058=?m2,mb059=?m3,mb060=?m4,mbuyprice=?m5,p57=?n1,p60=?n2,buyer=?T68 WHERE interid=?m1interid")<0  &&pbuyprice=?n5,
					WAIT windows '?F4FF??' NOWAIT 
				ENDIF 	

				getbom2(TCODE,tquan,e1,mclassid1,m1interid)

				IF SQLEXEC(con,"update pmocta set pbuyprice=(select SUM(addi) price from pmoctb where maininterid=?m1interid),"+;
					"p57=(select SUM(price*quan) price from pmoctb where maininterid=?m1interid)  where interid=?m1interid")<0
					WAIT windows '?1FFFP542347??' NOWAIT 
				ENDIF 
				IF SQLEXEC(con,"update pmoctb set price=(select (p57/ta015 +p58+p59+p60)   price from pmocta where interid=?m1interid) where interid=?cinterid1")<0
					WAIT windows '?1FFFP234571??' NOWAIT 
				ENDIF 
			ELSE  &&自产的检测包装
				IF CBCT='彩包' OR  CBCT='彩贴'
					SQLEXEC(CON,"SELECT SUM(TD008-TD015) as 在途量 FROM PURTD WHERE TD016='N' AND TD018='Y' AND TD004=?TCODE")
					zt=在途量
					DO CASE
						CASE CBCT='彩包'
							IF RKSJ=='' AND zt=0
								DO CASE
									CASE tquan<600
						 				xx='新制版费:400,起步费:400元;'
						 				YY=800
						 			CASE tquan<1000 AND tquan>=600
						 				xx='新制版费:400,起步费:免;'
						 				YY=400
						 			OTHERWISE
						 				XX='新制版够数,免附加费'	
						 				YY=0
						 		ENDCASE		
					 		ELSE
								DO CASE
									CASE tquan<600
						 				xx='老版起步费:400元;'
						 				YY=400
						 			OTHERWISE
						 				XX='老版够数,免起步费'	
						 				YY=0
						 		ENDCASE		
					 		ENDIF	
						CASE CBCT='彩贴'
							IF RKSJ=='' AND zt=0
								DO CASE
						 			CASE tquan<1000 
						 				xx='新版起步费:200;'
						 				YY=200
						 			OTHERWISE
						 				XX='新版够数,免附加费'	
						 				YY=0
						 		ENDCASE		
					 		ELSE
				 				XX='老版,免起步费'	
						 		YY=0
					 		ENDIF	
					ENDCASE	
					SQLEXEC(CON,"UPDATE pmoctb set addi=?yy,note=?xx where interid=?cinterid1")
				ENDIF	
			ENDIF 


			SELECT TMP1
			SKIP
		ENDDO	
	ELSE 
		ccodeid=maxinterid("piapprove")
		m1codec2='['+ALLTRIM(m1code)+']该品号没有工单,在PI审批中执行[重新生成审批单据]重新计算成本!'
		CON1=ODBC(6)
		SQLEXEC(CON1,"INSERT INTO piapprove (interid,note,chkname,chkdate,keyinterid,dept,action) values (?ccodeid,?m1codec2, ?P_UserName,GETDATE(), ?keyid,?HR_DEPT,'缺BOM')")
		SQLDISCONNECT(CON1)
		tmpkeyid=maxinterid("rtxmessage")
		CON1=ODBC(6)
		mrev=ALLTRIM(P_UserName)+';王文雅;彭秀娟;陈冲俞;桑丹丹;'
		SQLEXEC(con1,"insert rtxmessage (interid,toman,billname,creatdate,note,title) values (?tmpkeyid,?mrev,?P_UserName,getdate(),?m1codec2,'缺BOM')")
		SQLDISCONNECT(CON1)
	ENDIF	
ENDFUNC 
Function ReadMail&&( toFolder )
	PARAMETERS toFolder
    Local loItems, loItem, loFolders, loFolder,ds
    codeid=0
   	P_ASS=''
   	IF toFolder.Items.COUNT>0
	    IF toFolder.Items.Item[ 1 ].CLASS=43
    		toFolder1=toFolder.Items.Restrict(mwhere)
			FOR mkeyid  = 1 TO toFolder1.COUNT
				Lcmsg='提取OutLook邮件:'+ALLTRIM(STR(mkeyid  ))+'/'+ALLTRIM(STR(toFolder1.COUNT))
				WAIT WINDOW  LcMsg  NOWAIT AT SROW()/2, (SCOLS()-LEN(lcMsg))/2
			
				IF  toFolder1.Item[ mkeyid  ].CLASS=43 AND !EMPTY(toFolder1.Item[ mkeyid  ].SenderName)
					*TRY 
					
				   	a1=toFolder1.Item[ mkeyid  ].ReceivedTime
					a2=LEFT(toFolder1.Item[ mkeyid  ].subject,250) 
					a3=LEFT(toFolder1.Item[ mkeyid  ].SenderName,130)
					a4=LEFT(ALLT(toFolder1.Item[ mkeyid  ].SenderEmailAddress),130)
					p_cash=toFolder1.Item[ mkeyid  ].EntryID
					a6=LEFT(toFolder1.Item[ mkeyid  ].to,100)
					a7=LEFT(toFolder1.Item[ mkeyid  ].CC,100)
					a8=LEFT(toFolder1.Item[ mkeyid  ].BCC,100)
					a9=toFolder1.Item[ mkeyid  ].BodyFormat
					a10=LEFT(toFolder1.Item[ mkeyid  ].ReceivedByName,100)
					a11=toFolder1.Item[ mkeyid  ].SentOn
					IF EMPTY(A11)
						A11=NULL
					ENDIF	
					a113=LEFT(toFolder1.Item[ mkeyid  ].ReplyRecipientNames,100)
					a12=LEFT(toFolder1.Item[ mkeyid  ].Body,1500)
					*a112=INT(IIF(LEN(ALLTRIM(toFolder1.Item[ mkeyid  ].Body))/1024<1,1,LEN(ALLTRIM(toFolder1.Item[ mkeyid  ].Body))/1024+1))
					a112=INT(toFolder1.Item[ mkeyid  ].Size/1024)+1
					xx=ALLTRIM(toFolder.NAME)
					CURSORSETPROP("MapBinary",.T.,0)

					DO case
						CASE a9=0 OR a9=1
							a13=CAST(toFolder1.Item[ mkeyid  ].Body as w)
						CASE a9=2
*!*								a13=STRTOFILE(STRCONV(toFolder1.Item[ mkeyid  ].HTMLBody,13),"d:\1.txt")
*!*								a13=CAST(STRCONV(STRCONV(FILETOSTR("d:\1.txt"),14),6) as w)
							a13=CAST(toFolder1.Item[ mkeyid  ].HTMLBody as w)
						CASE a9=3
							a13=CAST(toFolder1.Item[ mkeyid  ].RTFBody as w)
					ENDCASE 	 
					IF SUBSTR(txtkey,len(txtkey)-LEN(xx)+1,LEN(xx))<>xx
		      			TXTKEY=txtkey+'.'+xx
	      			ENDIF 
					IF mwhere1=a4&&LEFT(a4,AT(A4,'@')-1)=KEYTXT
						MID=1
					ELSE
						MID=0
					ENDIF	
					CON=ODBC(5)
					SQLEXEC(con,"select foritem from contacts where email=?a4")
					IF RECCOUNT()=1
						a21=foritem 
					ELSE 
						IF SQLEXEC(con,"INSERT INTO [contacts] ([email]) values (?a4)")>0
							a21='业务员往来'
							A22='PURMA'
							DO CASE
								CASE HR_DEPT='销售部'
									a21='业务员往来'
									A22='COPMA'
								CASE HR_DEPT='市场部'
									a21='业务员往来'
									A22='marketcustom'
								CASE HR_DEPT='单证'	OR HR_DEPT='计划部' OR HR_DEPT='财务部'
									a21='业务员往来'
									A22='PURMA'
							ENDCASE 
							SQLEXEC(CON,"UPDATE [contacts] SET  [hrdept]=?HR_DEPT,[fordept]=?HR_DEPT,[creatdate]=GETDATE() ,[billname]=?P_USERNAME,[source]=?KEYTXT,[senddate]=?a1,foritem =?a21,fromtable=?A22 WHERE [email]=?a4")
							a=LEFT(HR_DEPT,10)
							keyidc=maxinterid("Remotion")
							CON1=ODBC(6)
							a41=LEFT(a4,40)
							IF SQLEXEC(CON1,"INSERT INTO remotion (interid,dateid,dept,truckno,note,statusid,keyvalue,billname,creatdate,remotion) values "+;
								"(?keyidc,getdate(),?a,?A4,'','新建','邮箱登记',?p_username,getdate(),'ALL')")<0
								WAIT windows ',DDD,,,,' &&,keyvalue,dept,billname,creatdate,?mkeyvalue,?P_DEPT,?p_username,getdate()
							ENDIF 
							SQLDISCONNECT(con1)				      		
				      	ENDIF 	
					ENDIF 
					IF SQLEXEC(CON,"INSERT INTO [declaration_email] ([entryid]) VALUES (?p_cash)")>0
						IF SQLEXEC(CON,"UPDATE [declaration_email] SET  [bodyformat]=?a9,[sendername]=?a3,[senderemaiaAddress]=?a4,[sendon]=?a11 "+;
				      		",[receivedbyname]=?a10,[toreceive]=?a6 ,[cc]=?a7, [bcc]=?a8 ,[outin]=?MID,[receivedtime]=?a1,[subject]=?a2,[mac]=?P_VICE "+;
				      		",[creatdate]=GETDATE() ,[dept]=?HR_DEPT,[billname]=?P_USERNAME,[sourcedir]=?TXTKEY,[body]=?a12,bodysize=?a112,replyrecipientnames=?a113,"+;
				      		"classto=?HR_DEPT,classitem=?a21 WHERE [entryid]=?p_cash")>0
							SQLDISCONNECT(CON)
							a=LEFT(HR_DEPT,10)
							keyidc=maxinterid("Remotion")
							CON1=ODBC(6)
							IF SQLEXEC(CON1,"INSERT INTO remotion (interid,dateid,dept,truckno,note,statusid,keyvalue,billname,creatdate,remotion) values "+;
								"(?keyidc,getdate(),?a,?A4,'','读取','邮件收发',?p_username,getdate(),'ALL')")<0
*								WAIT windows ',,,,,'  no&&,keyvalue,dept,billname,creatdate,?mkeyvalue,?P_DEPT,?p_username,getdate()
							ENDIF 
							SQLDISCONNECT(con1)		
			            	con=odbc(6)
				            SQLEXEC(CON,"insert into Attachments (interid,filename,Attachments,[filesize]  ) values (?p_cash,'MainBody.Lutec',?A13,?A112)")
							SQLDISCONNECT(Con)
							attfolder=toFolder1.Item[ mkeyid  ].Attachments
							x1=attfolder.COUNT
							IF attfolder.COUNT>0
								FOR lnSub1 = 1 TO attfolder.COUNT
						            cFilename= attfolder.item(lnSub1 ).filename &&filename
						            IF !EMPTY(cFilename) AND !ISNULL(cFilename)
							            lcFileName = Fullpath( Curdir() ) + cFilename
							            attfolder.item(lnSub1).SaveAsFile(lcFilename )	
							            
							            x=INT(FSIZE(lcFilename )/1024)
							            mFileName=CAST(filetostr(lcFilename) as w)
							            ERASE lcFilename 
							            con=odbc(6)
							            SQLEXEC(CON,"insert into Attachments (interid,filename,Attachments,[filesize] ) values (?p_cash,?cFilename,?mFileName,?x)")
										SQLDISCONNECT(Con)
									ENDIF 	
								ENDFOR
								con=odbc(5)
								SQLEXEC(CON,"UPDATE [declaration_email] SET  [attacount]=?x1 WHERE [entryid]=?p_cash")
								SQLDISCONNECT(con)
							ENDIF 
						ENDIF 
					ENDIF
*!*						CATCH 
*!*							MESSAGEBOX( '系统将读取你邮件内容,OutLook警告必需选择允许,或者WINDOWS操作安全级别设置最低',0,'无法继续')
*!*							EXIT 
*!*						FINALLY
*!*						ENDTRY
				ELSE
					TXTKEY=keytxt
				ENDIF
			ENDFOR 
		ELSE 
			TXTKEY=keytxt
		ENDIF
	ELSE 
		TXTKEY=keytxt
	ENDIF
	IF  toFolder.Folders.COUNT>0
    	FOR DS = 1 TO toFolder.Folders.COUNT
	    	loFolders = toFolder.Folders(DS)
        	ReadMail( loFolders)
      	ENDFOR
	ENDIF	
    Return
Endfunc    