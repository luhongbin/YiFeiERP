closedb("TMPBUYERDETAIL")
con=odbc(5)
	?SQLEXEC(CON,"SELECT INVMB_1.MB002 AS 配件名称,SUBSTRING(COPTC.TC003,7,2) AS 每日, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='01'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 一号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='02'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 二号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='03'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 三号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='04'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 四号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='05'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 五号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='06'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 六号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='07'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 七号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='08'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 八号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='09'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 九号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='10'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 十号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='11'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 十一号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='12'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 十二号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='13'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 十三号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='14'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 十四号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='15'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 十五号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='16'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 十六号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='17'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 十七号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='18'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 十八号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='19'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 十九号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='20'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 二十号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='21'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 二十一号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='22'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 二十二号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='23'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 二十三号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='24'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 二十四号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='25'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 二十五号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='26'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 二十六号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='27'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 二十七号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='28'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 二十八号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='29'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 二十九号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='30'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 三十号, "+;
		"SUM(CASE WHEN SUBSTRING(COPTC.TC003,7,2)='31'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 三十一号, "+;		
		"SUM( BOMMD.MD006 * COPTD.TD008 ) AS 合计 "+;
		"FROM COPTC INNER JOIN COPTD ON COPTC.TC001 = COPTD.TD001 AND COPTC.TC002 = COPTD.TD002 INNER JOIN "+;
        "BOMMD ON COPTD.TD004 = BOMMD.MD001 INNER JOIN INVMB INVMB_1 ON BOMMD.MD003 = INVMB_1.MB001 CROSS JOIN INVMA INVMA_1 "+;
      " GROUP BY INVMB_1.MB002 ,SUBSTRING(COPTC.TC003,7,2) ORDER BY 1" ,"TMPBUYERDETAIL") 
      SQLDISCONNECT(con)
SELECT  TMPBUYERDETAIL
BROWSE
*!*	, "+;
*!*			"AVG(CASE WHEN SUBSTRING(COPTC.TC003,5,2)='01'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 一月, "+;
*!*			"AVG(CASE WHEN SUBSTRING(COPTC.TC003,5,2)='02'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 二月, "+;
*!*			"AVG(CASE WHEN SUBSTRING(COPTC.TC003,5,2)='03'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 三月, "+;
*!*			"AVG(CASE WHEN SUBSTRING(COPTC.TC003,5,2)='04'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 四月, "+;
*!*			"AVG(CASE WHEN SUBSTRING(COPTC.TC003,5,2)='05'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 五月, "+;
*!*			"AVG(CASE WHEN SUBSTRING(COPTC.TC003,5,2)='06'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 六月, "+;
*!*			"AVG(CASE WHEN SUBSTRING(COPTC.TC003,5,2)='07'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 七月, "+;
*!*			"AVG(CASE WHEN SUBSTRING(COPTC.TC003,5,2)='08'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 八月, "+;
*!*			"AVG(CASE WHEN SUBSTRING(COPTC.TC003,5,2)='09'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 九月, "+;
*!*			"AVG(CASE WHEN SUBSTRING(COPTC.TC003,5,2)='10'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 十月, "+;
*!*			"AVG(CASE WHEN SUBSTRING(COPTC.TC003,5,2)='11'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 十一月, "+;
*!*			"AVG(CASE WHEN SUBSTRING(COPTC.TC003,5,2)='12'  THEN BOMMD.MD006 * COPTD.TD008 ELSE 0 END) AS 十二月, "+;
*!*			"AVG( BOMMD.MD006 * COPTD.TD008 ) AS 合计 "+;