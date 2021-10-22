CON=ODBC(5)
*!*	IF SQLEXEC(CON,"UPDATE pidetailpro SET  from pi inner join pidetail on pi.interid=pidetail.maininterid "+;
*!*	"left join pidetailpro as pipro on pipro.interid=pi.interid inner join COPTD ON COPTD.UDF56=pidetail.interid where chkid>0 and TD008>TD009 order by 2 ","tmpPIInfo1")<0
*!*	     WAIT windows '????' nowait&&left join COPTC ON interid=COPTC.UDF55TC027,left join COPTD ON TC001=TD001 AND TC002=TD002AND pi.statusid<>'已核销' AND classid>='226'
*!*		 SQLDISCONNECT(CON)
*!*	     RETURN
*!*	ENDIF   

IF SQLEXEC(CON,"SELECT DISTINCT pipro.interid pinterid,pipipro.interid,pi.classid,pi.chkid,pi.boxnum from pi inner join pidetail on pi.interid=pidetail.maininterid "+;
"left join pidetailpro as pipro on pipro.interid=pi.interid inner join COPTD ON COPTD.UDF56=pidetail.interid where chkid>0 and TD008>TD009 order by 2 ","tmpPIInfo1")<0
     WAIT windows '????' nowait&&left join COPTC ON interid=COPTC.UDF55TC027,left join COPTD ON TC001=TD001 AND TC002=TD002AND pi.statusid<>'已核销' AND classid>='226'
	 SQLDISCONNECT(CON)
     RETURN
ENDIF   

SELECT tmpPIInfo1
 
GO TOP
DO WHILE .NOT. EOF()
	mclassid=classid
	df=interid 
	sfyh=boxnum
	SQLEXEC(con,"select interid from pidetailpro where interid=?df")
	IF RECCOUNT()<1
		SQLEXEC(con,"insert into pidetailpro (interid ) values (?df)")
	ENDIF 
	

SELECT tmpPIInfo1
IF chkid=1 

	SQLEXEC(con,"select TOP 1 TC003,RTRIM(TD001)+TD002 AS BILLNO,CASE WHEN TD016='Y' THEN '自动结束' when TD016='y' then '指定结束' else '未结束' end TD "+;
	"FROM COPTD inner join COPTC ON TC001=TD001 AND TC002=TD002 WHERE UDF56=?df AND TC027='Y' ORDER BY 1")
	IF LEFT(TC003,1)='2'
		MT=TC003
		MBILL=BILLNO
		SQLEXEC(con,"update pidetailpro set erpchk=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2)  where interid=?df")
		
		tid=0
		SQLEXEC(con,"select TA040,TA010,UDF56,TA012 TA038,TA014 TA039, "+;
		"case when TA011='1' then '未生产' WHEN TA011='2' THEN '已发料' when TA011='3' THEN '生产中' when TA011='Y' THEN '已完工' when TA011='y' THEN '指定完工' end 生产状态 "+;
		"FROM MOCTA INNER JOIN COPTD ON RTRIM(TD001)+TD002=TA033 AND TD004=TA006 WHERE TA033=?MBILL AND TA013='Y' AND COPTD.UDF56=?df  ORDER BY 2 DESC,5,1 ")
		IF RECCOUNT()=1
			IF LEFT(TA040,1)='2'
				MT=TA040
				YWG=TA010
				X1=TA038
				X2=TA039
				X3=生产状态
				IF UDF56=0
					TT=''
				ELSE
					TT=''
				ENDIF	
				SQLEXEC(con,"update pidetailpro set TA040=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2),TA010=LEFT(?YWG,4)+'.'+SUBSTRING(?YWG,5,2)+'.'+RIGHT(?YWG,2)"+;
				",TA038=LEFT(?X1,4)+'.'+SUBSTRING(?X1,5,2)+'.'+RIGHT(?X1,2),TA039=LEFT(?X2,4)+'.'+SUBSTRING(?X2,5,2)+'.'+RIGHT(?X2,2) where interid=?df")
				SQLEXEC(con,"update pi set statusid=?X3  where interid=?df")
				IF (mclassid>='226' OR mclassid='220') AND  '完工'$X3=.T.
					SQLEXEC(con,"update pi set statusid='已核销'  where interid=?df")
				ENDIF	
			ENDIF 
		ENDIF 
		SQLEXEC(con,"select TOP 1 TC003 FROM PURTD INNER JOIN PURTC ON TC001=TD001 AND TC002=TD002 WHERE TD024=?MBILL  and TD004>='A' ORDER BY 1 DESC")
			IF RECCOUNT()=1
				IF LEFT(TC003 ,1)='2'	
					MT=TC003
					SQLEXEC(con,"update pidetailpro set TC003=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2)  where interid=?df")
					SQLEXEC(con,"update pi set statusid='外购采购'  where interid=?df")
					SQLEXEC(con,"select TOP 1 TD016 FROM PURTD  WHERE TD024=?MBILL  and TD004>='A' AND TD016='N' ORDER BY 1 DESC")
					IF RECCOUNT()<1
					SQLEXEC(con,"update pi set statusid='已核销'  where interid=?df")
					ENDIF
				ELSE	
					SQLEXEC(con,"update pidetailpro set TC003=''  where interid=?df")
				ENDIF	
			ENDIF
		IF sfyh=1
			IF sqlexec(con,"SELECT top 1 CASE WHEN exto IS NULL THEN ''  ELSE SUBSTRING(exto,1,4)+'.'+SUBSTRING(exto,5,2)+'.'+SUBSTRING(exto,7,2) END AS 验货截止日 FROM piexamine Piexamine  "+;
			 	" WHERE RTRIM(tc001)+tc002=?MBILL ","tmp1")<0
				WAIT WINDOWS '?TH??'
				RETURN 
			ENDIF	
			IF RECCOUNT()=1
				XX=验货截止日
				SQLEXEC(con,"update pidetailpro set EXTO=?XX  where interid=?df")
				SQLEXEC(con,"update pi set statusid='已验货'  where interid=?df")
			ENDIF 	
		ENDIF 
		IF Sqlexec(con,"select TOP 1 SUBSTRING(COPTF.CREATE_DATE ,1,8) CDATE "+;
			"from COPTF INNER JOIN COPTD ON TD001=TF001 AND TD002=TF002 where COPTD.UDF54=?DF ORDER BY 1 DESC","TMP1")<0
			WAIT WINDOW '?F??'  && NOWAIT 
		ENDIF 
		IF RECCOUNT()=1
			MT=CDATE  
			SQLEXEC(con,"update pidetailpro set TE004=LEFT(?MT,4)+'.'+SUBSTRING(?MT,5,2)+'.'+RIGHT(?MT,2)  where interid=?df")
		ELSE	
			SQLEXEC(con,"update pidetailpro set TE004='' where interid=?df")
		endif
	IF mclassid<='226' AND mclassid<>'220'
		
		IF SQLEXEC(CON,"SELECT top 1  CASE WHEN TA003 >'1' then CONVERT(VARCHAR(10),CAST(TA003 AS DATETIME),102) END "+;
	     	" AS 出货通知日期  FROM COPTC COPTC1 INNER JOIN EPSTB ON COPTC1.TC001=TB004 AND COPTC1.TC002=TB005  "+;
	    	 " INNER JOIN EPSTA ON TA001=TB001 AND TA002=TB002  WHERE COPTC1.UDF55=?df","TMP1")<0 &&结关日期
		    WAIT windows 'EPSTA ????11'  && NOWAIT 
	    ENDIF 	 
		IF RECCOUNT()=1
			xxXX=出货通知日期	
			SELECT tmpPIInfo1
			SQLEXEC(con,"update pidetailpro set ETA003=?XXXX  where interid=?df")
			SQLEXEC(con,"update pi set statusid='出货通知'  where interid=?df")
			IF SQLEXEC(CON,"SELECT TOP 1 CONVERT(VARCHAR(10),CAST(TG003 AS DATETIME),102) TD FROM COPTC LEFT JOIN  COPTH ON "+;
				" TC001=TH014 AND TC002=TH015  LEFT JOIN COPTG ON TH001=TG001 AND TH002=TG002 "+;
				"  WHERE COPTC.UDF55=?df ORDER BY 1 DESC","TMP1")<0 &&结关日期
			    WAIT windows 'EPSTA ??2??'  && NOWAIT 
		    ENDIF 	 
			IF RECCOUNT()=1
				xxXX=TD 	
				SQLEXEC(con,"update pidetailpro set CTG003=?XXXX  where interid=?df")
				SQLEXEC(con,"update pi set statusid='已销货'  where interid=?df")

				IF SQLEXEC(CON,"SELECT TOP 1 CONVERT(VARCHAR(10),CAST(TA003 AS DATETIME),102) TD,"+;
					"CASE WHEN TA100='1' then '未核销' when  TA100='2' then '部分核销' when TA100='3' then '已核销' end  AS 核销状态 FROM COPTC LEFT JOIN  COPTH ON "+;
					" TC001=TH014 AND TC002=TH015  LEFT JOIN COPTG ON TH001=TG001 AND TH002=TG002 "+;
					"   LEFT JOIN ACRTB ON  TH001=TB005 and TH002=TB006  "+;
					" LEFT JOIN ACRTA ON ACRTA.TA001=TB001 and ACRTA.TA002=TB002 WHERE COPTC.UDF55=?df ORDER BY 1 DESC","TMP1")<0 &&结关日期
	   				 WAIT windows 'EPSTA ??3??'  && NOWAIT 
 			   ENDIF 	
 			   IF RECCOUNT()=1
					xxXX=TD 	
					XX=核销状态
					SQLEXEC(con,"update pi set statusid=?XX  where interid=?df")
					SQLEXEC(con,"update pidetailpro set ATA003=?XXXX,ATA100=?XX  where interid=?df")
				   	IF SQLEXEC(CON,"SELECT TOP 1 CONVERT(VARCHAR(10),CAST(TK003 AS DATETIME),102) TD "+;
						"FROM  COPTD INNER JOIN COPTH ON TH014=TD001 AND TH015=TD002 AND TH016=TD003 INNER JOIN ACRTB ON TH001=TB005 and TH002=TB006 and TH003=TB007 "+;
						" INNER JOIN ACRTL ON ACRTL.TL005=TB001 and ACRTL.TL006=TB002  INNER JOIN ACRTK  ON TK001=TL001 AND TK002=TL002  "+;
						"   inner join COPTC ON TC001=TD001 AND TC002=TD002 WHERE COPTC.UDF55=?df ORDER BY 1 DESC","TMP1")<0 &&结关日期
						    WAIT windows 'EPSTA ??4??' 
				   ENDIF 	 
	 			   IF RECCOUNT()=1
						xxXX=TD 	
						SQLEXEC(con,"update pidetailpro set ATK003=?XXXX  where interid=?df")
				   ENDIF  &&收款
			   ENDIF &&	开票   
			ENDIF  &&销货
		ENDIF  &&销货
	
	ENDIF 	&&ERP审批	
ENDIF &&终审
		ENDIF

			SELECT tmpPIInfo1
	     	SKIP
	     ENDDO
	     SQLDISCONNECT(CON)