*!*	loWord = CREATEOBJECT("Word.Application")
*!*	loEmOpt = loWord.EmailOptions
*!*	loOlSig = loEmOpt.EmailSignature
*!*	lcSigFileName = ALLTRIM(loOlSig.NewMessageSignature )
*!*	* Text signature
*!*	lcPathAndFile = lcFilePath + lcSigFileName + ".txt"
*!*	IF FILE(lcPathAndFile )
*!*		lcTextIn = FILETOSTR(lcPathAndFile  )
*!*		IF  LEFT( lcTextIn ,2) = 0hFFFE
*!*			lcTextIn = SUBSTR(lcTextIn,3)		
*!*		ENDIF	
*!*	 	p_Ass = '<small><br>'+STRTRAN(STRCONV(lcTextIn ,6),CHR(13)+CHR(10),'<br>')+'</small>'
*!*	ENDI

con=odbc(5)
IF 	SQLEXEC(CON,"SELECT distinct RTRIM(COPTD.TD001)+RTRIM(COPTD.TD002)+'-'+RTRIM(COPTD.TD003)+"+;
	"CASE  WHEN p.piinterid is null  THEN '' when p.cid=1 then '[调'+rtrim(COPTD.TD015)+']' when p.cid=2 then '[借'+RTRIM(CAST(COPTD.UDF05 AS char(30)))+']' "+;
		"when p.cid=3 then '[调用库存]' ELSE '[调'+RTRIM(COPTD.TD015)+']' end AS 订单号,pidetail.itemno AS  公司货号,"+;
	"pidetail.customcode 客户货号,pidetail.code 品号,pidetail.name 品名,pidetail.spec 规格,pidetail.supply 供应商,"+;
	"CONVERT(CHAR(10),CAST(pidetail.edate AS DATETIME),102)+'(第'+RTRIM(DATENAME( Wk,CAST(pidetail.edate AS DATETIME) ))+'周)'  AS 要求交期,"+;
	"boxok ,CAST(COPTD.TD020 AS CHAR(1500)) AS 备注, pidetail.quan 数量, 0000.0 gs,p.cid,pi.chkdate,mf002 "+;
	",A.MA002,pi.po,pi.billname,MV002,pipro.EXTO,pi.discharge,0.000 vol,pidetail.quan boxtotal,pi.mainnote,pidetail.interid,pi.classid "+;
	" FROM pidetail left join COPTD COPTD on pidetail.interid=COPTD.UDF56 "+;
     "  left join pi on pidetail.maininterid=pi.interid left join COPMA A ON A.MA001=customid left join CMSMV ON "+;
     "salescode=MV001 LEFT JOIN pipro on pipro.interid=pi.interid LEFT JOIN pidetailcallforecast p on p.piinterid=  pidetail.interid "+;
	 " LEFT join COPTD x on p.forecastinterid=x.UDF56 and p.cid<3  WHERE pidetail.maininterid=?keyid ORDER BY 1","tmpBuyDe")<0
 	 SQLDISCONNECT(CON)  
	 WAIT windows '出错了'  &&&left join pidetail on COPTD.UDF56=pidetail.interid AND LEFT(pidetail.code,1)<>'X' 
ENDIF   
SELECT tmpBuyDe
lcMsg=  '正在生产PDF采购单...' 
WAIT WINDOW  lcMsg NOWAIT AT SROW()/2, (SCOLS()-LEN(lcMsg))/2 


DO WHILE .not. EOF()
	mkeyid=interid
	gq=数量

	IF EMPTY(备注) OR ISNULL(备注) OR LEN(ALLTRIM(备注))=0
		bzid=0
	ELSE
		bzid=1	
	ENDIF 
	mls=''
	X3=0
	IF mf002='N' 
		IF sqlexec(CON,"SELECT SUM(CAST(CASE WHEN MF019 IS NULL OR MF019=0 THEN 0 ELSE (MF010/MF019/3600)*quan END+"+;
		"CASE WHEN MF009 IS NULL  THEN 0 ELSE MF009/3600 end AS  numeric(10,1))) GS "+;
			" FROM pidetail LEFT JOIN INVMB ON code=MB001 inner JOIN BOMMF ON MB010=MF001 AND MB011=MF002 AND (MF005='1' OR MF005 IS NULL)  "+;
		 	"WHERE interid=?mkeyid  and  not exists (select 'x' from pidetailcallforecast x where x.piinterid=pidetail.interid)")<0
			WAIT WINDOWS '??2?'
		ENDIF 
		IF RECCOUNT()=1 AND !ISNULL(gs)
			x3=gs
			SELECT tmpBuyDe
			REPLACE GS WITH X3
		ENDIF 
	ENDIF	
	IF SQLEXEC(CON,"SELECT classid,packagecode,B1.MB002,B1.MB003,long MB093,width MB094, deep MB095,quan,long*width*deep/1000000 vol,boxnum,boxfrom,boxto "+;
		",weight,wet,des,barcode FROM packageinfo LEFT join INVMB B1 ON packagecode=B1.MB001 where interid=?mkeyid and billid=2 ORDER BY 1","TmpP")<0  &&billid=2 and 
		WAIT WINDOWS '??xgggxx?'
		RETURN
	ENDIF
	
	SELECT TmpP
	LOCATE FOR '外箱'$classid
	IF FOUND()
		WXID=1
	ELSE
		WXID=0
	ENDIF	
	GO TOP
	X1=0
	X2=0
	x3=0
	DO whil .not. EOF()
		IF '外箱'$classid
			IF  '外箱外购'$packagecode
				mls=mls+'['+ALLTRIM(classid)+']每箱'+ALLTRIM(STR(quan))+'只,共'+ALLTRIM(STR(boxnum))+'箱('+ALLTRIM(STR(boxfrom))+'-'+ALLTRIM(STR(boxto))+')；'
			ELSE
				mls=mls+'['+ALLTRIM(classid)+']'+ALLTRIM(MB002)+ALLTRIM(MB003)+'['+ALLTRIM(packagecode)+']每箱'+ALLTRIM(STR(quan))+'只,共'+ALLTRIM(STR(boxnum))+'箱('+ALLTRIM(STR(boxfrom))+'-'+ALLTRIM(STR(boxto))+')；'
			ENDIF	
			X1=boxnum+X1
			X2=vol+X2
		ELSE
			IF WXID=0 AND '中包'$classid
				IF  '中包外购'$packagecode
					mls=mls+'['+ALLTRIM(classid)+']每箱'+ALLTRIM(STR(quan))+'只,共'+ALLTRIM(STR(boxnum))+'箱('+ALLTRIM(STR(boxfrom))+'-'+ALLTRIM(STR(boxto))+')；'
				ELSE
					mls=mls+'['+ALLTRIM(classid)+']'+ALLTRIM(MB002)+ALLTRIM(MB003)+'['+ALLTRIM(packagecode)+']每箱'+ALLTRIM(STR(quan))+'只,共'+ALLTRIM(STR(boxnum))+'箱('+ALLTRIM(STR(boxfrom))+'-'+ALLTRIM(STR(boxto))+')；'
				ENDIF	
				X1=boxnum+X1
				X2=vol+X2
			ELSE
				IF !ISNULL(MB002)
					mls=mls+'['+ALLTRIM(classid)+']'+ALLTRIM(MB002)+ALLTRIM(MB003)+'['+ALLTRIM(packagecode)+']；'
				ELSE
					mls=mls+'['+ALLTRIM(classid)+':'+ALLTRIM(packagecode)+']；'
				ENDIF 
			ENDIF	
		ENDIF 
		SELECT tmpp
		SKIP
	ENDDO 	
	SELECT tmpBuyDe

	IF bzid=0
		REPLACE 备注 WITH '包装信息:'+mls
		bzid=1
	ELSE
		REPLACE 备注 WITH '1.'+ALLTRIM(备注)+CHR(13)+CHR(10)+'2.包装信息:'+mls
		bzid=2
	ENDIF
	REPLACE vol WITH X2,boxtotal WITH x1
	IF SQLEXEC(CON,"SELECT '料件调拨' classid,exportcode.code,B1.MB002,B1.MB003,B1.MB004,totalpcs MB094, B1.MB053 ,B1.MB053 *pcs*pidetail.quan CASH "+;
		"FROM exportcode LEFT join INVMB B1 ON code=B1.MB001 inner join pidetail on pidetail.interid=pidetailinterid "+;
		" where pidetailinterid=?mkeyid ORDER BY 1,2","TmpP")<0
		WAIT WINDOWS '??xxx?'
	ENDIF
	mls=''
	SELECT TmpP
	IF RECCOUNT()>0
		GO TOP 
		DO WHILE .not. EOF()
			mls=mls+ALLTRIM(MB002)+ALLTRIM(MB003)+'['+ALLTRIM(code)+']:'+ALLTRIM(STR(MB094))+'PCS;'
			SELECT tmpp
			SKIP
		ENDDO 	
		SELECT tmpBuyDe

		IF bzid=1
			REPLACE 备注 WITH  '1.'+ALLTRIM(备注)+CHR(13)+CHR(10)+'2.调拨料件:'+mls
		ELSE
			REPLACE 备注 WITH  ALLTRIM(备注)+CHR(13)+CHR(10)+'3.调拨料件:'+mls
		ENDIF
	ENDIF 	
	SELECT tmpBuyDe
	IF CID=1
		SQLEXEC(con,"SELECT COPMF.UDF52-MF009 MF FROM COPMF as COPMF inner join  pidetailcallforecast p on p.forecastinterid=COPMF.UDF56 WHERE p.piinterid=?MKEYID")
		IF MF>=GQ
			SELECT tmpBuyDe
			REPLACE 备注 WITH  ALLTRIM(备注)+CHR(13)+CHR(10)+'--有库存无需生产！',CID WITH 9
		ENDIF 
	ENDIF 
	SELECT tmpBuyDe

	IF CID=2
		SQLEXEC(con,"SELECT COPTD.UDF52-COPTD.UDF51-COPTD.TD009 AS MF FROM COPTD as COPTD "+;
			"inner join  pidetailcallforecast p on p.forecastinterid=COPTD.UDF56 WHERE p.piinterid=?MKEYID")
		IF MF>=GQ
			SELECT tmpBuyDe
			REPLACE 备注 WITH  ALLTRIM(备注)+CHR(13)+CHR(10)+'--有库存无需生产！',CID WITH 9
		ENDIF 
	ENDIF	
	SELECT tmpBuyDe

	SKIP
ENDDO	
SQLDISCONNECT(CON)

=ReduceMemory()
*ERASE 	shippingMARK
CURSORSETPROP("MapBinary",.T.,0)
CON=ODBC(5)
Sqlexec(CON,"select filedata pic,filename,classid from billpic where interid=?keyid and classid<=2 and filedata is not null ORDER BY classid","t1")
SQLDISCONNECT(CON)	
IF RECCOUNT()=1	
	STRTOFILE(pic,'shippingMARK')
	mwhere='ok'&&ALLTRIM(STR(keyid))+'.'+filename
*			COPY ALLTRIM(STR(keyid))+'.'+filename to 'shippingMARK'
ELSE
	mwhere='no'
	*MESSAGEBOX('无唛头')
ENDIF 	

codeid=2015090000
DO GetReport WITH codeid
ERASE ALLTRIM(STR(keyid))+'下发.pdf'
SELECT tmpBuyDe

WITH _Screen.oFoxyPreviewer 
    .cPdfSubject ='order form'
    .cPdfKeyWords =ALLTRIM(STR(keyid))
ENDWITH 
REPORT FORM 报表打印5.frx OBJECT TYPE 11 TO FILE ALLTRIM(STR(keyid))+'下发.pdf'
