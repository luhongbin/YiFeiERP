CON=ODBC(5)
IF SQLEXEC(CON,"SELECT DISTINCT pipro.interid pinterid,pi.interid,pi.classid,pi.chkid,pi.boxnum from pi inner join pidetail on pi.interid=pidetail.maininterid "+;
"left join pipro on pipro.interid=pi.interid where chkid>0  order by 2 ","tmpPIInfo1")<0
     WAIT windows '????' nowait&&left join COPTC ON interid=COPTC.UDF55TC027,left join COPTD ON TC001=TD001 AND TC002=TD002AND pi.statusid<>'?Ѻ???' AND classid>='226'
	 SQLDISCONNECT(CON)
     RETURN
ENDIF   

SELECT tmpPIInfo1
 
GO TOP
DO WHILE .NOT. EOF()
	mclassid=classid
	df=interid 
	sfyh=boxnum
	IF ISNULL(pinterid) and 1=2
		SQLEXEC(con,"select interid from pipro where interid=?df")
		IF RECCOUNT()<1
			SQLEXEC(con,"insert into pipro (interid ) values (?df)")
		ENDIF 
		IF SQLEXEC(CON,"SELECT SUM(quan) quan,SUM(price*quan*pi.rate) as cash ,SUM(price*quan*pi.rate*profit)/100 a11,pi.classid,"+;
		"sum(CASE WHEN MF019 IS NULL OR MF019=0 THEN 0 ELSE MF009/3600+(MF010/MF019/3600)*quan END) gs FROM pidetail INNER JOIN INVMB ON code = MB001 "+;
		" LEFT JOIN BOMMF ON MB010=MF001 AND MB011=MF002 AND (MF005='1' OR MF005 IS NULL) inner join pi on pi.interid=pidetail.maininterid "+;
		"where maininterid=?df group by pi.classid","tmpdetail")<0
			brow
			WAIT windows '???d???????'
		ENDIF 	
		SELECT tmpdetail
		a2=cash
		cdsd=quan
		gggs=gs
		XCX=A11
		mclassid=classid
		IF a2<>0
			lv=xcx/a2*100
		ELSE
			lv=0
		ENDIF 	
		IF mclassid<='226'and mclassid<>'220'
			SQLEXEC(con,"update pipro set profit=?xcx,profitrate=?lv,quan=?cdsd,worktime=?gggs/8 where interid=?df")
		ELSE
			SQLEXEC(con,"update pipro set quan=?cdsd,worktime=?gggs/8 where interid=?df")

		ENDIF 
		IF SQLEXEC(con,"select SUM(p.long*p.width*p.deep*p.boxnum)/1000000 vol,SUM(p.weight*pd.quan) net,SUM(case when p.wet is null then 0 else p.wet*pd.quan end) wet,"+;
		"SUM(case when p.boxnum is null then 0 else p.boxnum end ) boxnum FROM pidetail pd  "+;
		"inner join packageinfo p on p.interid=pd.interid inner join pi on pd.maininterid=pi.interid  where  pi.interid=?df and p.classid='????' ","TMP")<0
			WAIT windows '??????????'
		ENDIF 	
		SELECT tmp
		IF RECCOUNT()=1 AND !ISNULL(vol)

			xx=net
			IF !ISNULL(WET)
				yy=wet
			ELSE
				YY=0
			ENDIF	
			vold=vol
			IF ISNULL(boxnum)
				mbox=0
			else
				mbox=boxnum
			ENDIF 
		ELSE 	

			mbox=0
			vold=0
			xx =0
			yy=0
		ENDIF 
		SQLEXEC(con,"update pipro set box=?mbox,vol=?vold,net=?xx,wet=?yy  where interid=?df")
	ENDIF 

SELECT tmpPIInfo1
IF chkid=1 

	SQLEXEC(con,"select TOP 1 TC003,RTRIM(TC001)+TC002 AS BILLNO FROM COPTC WHERE UDF55=?df ORDER BY 1")
	IF LEFT(TC003,1)='2'
		MT=TC003
		MBILL=BILLNO
		SQLEXEC(con,"update pipro set erpchk=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2)  where interid=?df")
		
		tid=0
		SQLEXEC(con,"select TOP 1 TA040,TA010,UDF56,TA012 TA038,TA014 TA039, "+;
		"case when TA011='1' then 'δ????' WHEN TA011='2' THEN '?ѷ???' when TA011='3' THEN '??????' when TA011='Y' THEN '???깤' when TA011='y' THEN 'ָ???깤' end ????״̬ "+;
		"FROM MOCTA WHERE TA033=?MBILL AND TA013='Y' AND TA006>='A' ORDER BY 2 DESC,5,1 ")
		IF RECCOUNT()=1
			IF LEFT(TA040,1)='2'
				MT=TA040
				YWG=TA010
				X1=TA038
				X2=TA039
				X3=????״̬
				IF UDF56=0
					TT=''
				ELSE
					TT=''
				ENDIF	
				SQLEXEC(con,"update pipro set TA040=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),TA010=LEFT(?YWG,4)+'.'+SUBSTRING(?YWG,5,2)+'.'+RIGHT(?YWG,2)"+;
				",TA038=LEFT(?X1,4)+'.'+SUBSTRING(?X1,5,2)+'.'+RIGHT(?X1,2),TA039=LEFT(?X2,4)+'.'+SUBSTRING(?X2,5,2)+'.'+RIGHT(?X2,2) where interid=?df")
				SQLEXEC(con,"update pi set statusid=?X3  where interid=?df")
				IF (mclassid>='226' OR mclassid='220') AND  '?깤'$X3=.T.
					SQLEXEC(con,"update pi set statusid='?Ѻ???'  where interid=?df")
				ENDIF	
			ENDIF 
		ENDIF 
		SQLEXEC(con,"select TOP 1 TC003 FROM PURTD INNER JOIN PURTC ON TC001=TD001 AND TC002=TD002 WHERE TD024=?MBILL  and TD004>='A' ORDER BY 1 DESC")
			IF RECCOUNT()=1
				IF LEFT(TC003 ,1)='2'	
					MT=TC003
					SQLEXEC(con,"update pipro set TC003=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2)  where interid=?df")
					SQLEXEC(con,"update pi set statusid='?⹺?ɹ?'  where interid=?df")
					SQLEXEC(con,"select TOP 1 TD016 FROM PURTD  WHERE TD024=?MBILL  and TD004>='A' AND TD016='N' ORDER BY 1 DESC")
					IF RECCOUNT()<1
					SQLEXEC(con,"update pi set statusid='?Ѻ???'  where interid=?df")
					ENDIF
				ELSE	
					SQLEXEC(con,"update pipro set TC003=''  where interid=?df")
				ENDIF	
			ENDIF
		IF sfyh=1
			IF sqlexec(con,"SELECT top 1 CASE WHEN exto IS NULL THEN ''  ELSE SUBSTRING(exto,1,4)+'.'+SUBSTRING(exto,5,2)+'.'+SUBSTRING(exto,7,2) END AS ??????ֹ?? FROM piexamine Piexamine  "+;
			 	" WHERE RTRIM(tc001)+tc002=?MBILL ","tmp1")<0
				WAIT WINDOWS '?TH??'
				RETURN 
			ENDIF	
			IF RECCOUNT()=1
				XX=??????ֹ??
				SQLEXEC(con,"update pipro set EXTO=?XX  where interid=?df")
				SQLEXEC(con,"update pi set statusid='??????'  where interid=?df")
			ENDIF 	
		ENDIF 
		IF Sqlexec(con,"select TOP 1 SUBSTRING(COPTF.CREATE_DATE ,1,8) CDATE "+;
			"from COPTF INNER JOIN COPTD ON TD001=TF001 AND TD002=TF002 where COPTD.UDF54=?DF ORDER BY 1 DESC","TMP1")<0
			WAIT WINDOW '?F??'  && NOWAIT 
		ENDIF 
		IF RECCOUNT()=1
			MT=CDATE  
			SQLEXEC(con,"update pipro set TE004=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2)  where interid=?df")
		ELSE	
			SQLEXEC(con,"update pipro set TE004='' where interid=?df")
		endif
	IF mclassid<='226' AND mclassid<>'220'
		
		IF SQLEXEC(CON,"SELECT top 1  CASE WHEN TA003 >'1' then CONVERT(VARCHAR(10),CAST(TA003 AS DATETIME),102) END "+;
	     	" AS ????֪ͨ????  FROM COPTC COPTC1 INNER JOIN EPSTB ON COPTC1.TC001=TB004 AND COPTC1.TC002=TB005  "+;
	    	 " INNER JOIN EPSTA ON TA001=TB001 AND TA002=TB002  WHERE COPTC1.UDF55=?df","TMP1")<0 &&????????
		    WAIT windows 'EPSTA ????11'  && NOWAIT 
	    ENDIF 	 
		IF RECCOUNT()=1
			xxXX=????֪ͨ????	
			SELECT tmpPIInfo1
			SQLEXEC(con,"update pipro set ETA003=?XXXX  where interid=?df")
			SQLEXEC(con,"update pi set statusid='????֪ͨ'  where interid=?df")
			IF SQLEXEC(CON,"SELECT TOP 1 CONVERT(VARCHAR(10),CAST(TG003 AS DATETIME),102) TD FROM COPTC LEFT JOIN  COPTH ON "+;
				" TC001=TH014 AND TC002=TH015  LEFT JOIN COPTG ON TH001=TG001 AND TH002=TG002 "+;
				"  WHERE COPTC.UDF55=?df ORDER BY 1 DESC","TMP1")<0 &&????????
			    WAIT windows 'EPSTA ??2??'  && NOWAIT 
		    ENDIF 	 
			IF RECCOUNT()=1
				xxXX=TD 	
				SQLEXEC(con,"update pipro set CTG003=?XXXX  where interid=?df")
				SQLEXEC(con,"update pi set statusid='??????'  where interid=?df")

				IF SQLEXEC(CON,"SELECT TOP 1 CONVERT(VARCHAR(10),CAST(TA003 AS DATETIME),102) TD,"+;
					"CASE WHEN TA100='1' then 'δ????' when  TA100='2' then '???ֺ???' when TA100='3' then '?Ѻ???' end  AS ????״̬ FROM COPTC LEFT JOIN  COPTH ON "+;
					" TC001=TH014 AND TC002=TH015  LEFT JOIN COPTG ON TH001=TG001 AND TH002=TG002 "+;
					"   LEFT JOIN ACRTB ON  TH001=TB005 and TH002=TB006  "+;
					" LEFT JOIN ACRTA ON ACRTA.TA001=TB001 and ACRTA.TA002=TB002 WHERE COPTC.UDF55=?df ORDER BY 1 DESC","TMP1")<0 &&????????
	   				 WAIT windows 'EPSTA ??3??'  && NOWAIT 
 			   ENDIF 	
 			   IF RECCOUNT()=1
					xxXX=TD 	
					XX=????״̬
					SQLEXEC(con,"update pi set statusid=?XX  where interid=?df")
					SQLEXEC(con,"update pipro set ATA003=?XXXX,ATA100=?XX  where interid=?df")
				   	IF SQLEXEC(CON,"SELECT TOP 1 CONVERT(VARCHAR(10),CAST(TK003 AS DATETIME),102) TD "+;
						"FROM  COPTD INNER JOIN COPTH ON TH014=TD001 AND TH015=TD002 AND TH016=TD003 INNER JOIN ACRTB ON TH001=TB005 and TH002=TB006 and TH003=TB007 "+;
						" INNER JOIN ACRTL ON ACRTL.TL005=TB001 and ACRTL.TL006=TB002  INNER JOIN ACRTK  ON TK001=TL001 AND TK002=TL002  "+;
						"   inner join COPTC ON TC001=TD001 AND TC002=TD002 WHERE COPTC.UDF55=?df ORDER BY 1 DESC","TMP1")<0 &&????????
						    WAIT windows 'EPSTA ??4??' 
				   ENDIF 	 
	 			   IF RECCOUNT()=1
						xxXX=TD 	
						SQLEXEC(con,"update pipro set ATK003=?XXXX  where interid=?df")
				   ENDIF  &&?տ?
			   ENDIF &&	??Ʊ   
			ENDIF  &&????
		ENDIF  &&????
	
	ENDIF 	&&ERP????	
ENDIF &&????
		ENDIF

			SELECT tmpPIInfo1
	     	SKIP
	     ENDDO
	     SQLDISCONNECT(CON)