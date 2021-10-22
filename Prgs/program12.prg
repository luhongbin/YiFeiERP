con=odbc(10)
*!*		IF sqlexec(con,"SELECT MV002 AS 业务员,Coptc.TC001+Coptc.TC002 订单号码,MA002 客户名称,Coptc.TC012 PO, "+;
*!*			"CASE WHEN exfrom IS NULL THEN ''  ELSE SUBSTRING(exfrom,1,4)+'.'+SUBSTRING(exfrom,5,2)+'.'+SUBSTRING(exfrom,7,2) END AS 验货起始日,"+;
*!*			"CASE WHEN exto IS NULL THEN ''  ELSE SUBSTRING(exto,1,4)+'.'+SUBSTRING(exto,5,2)+'.'+SUBSTRING(exto,7,2) END AS 验货截止日,"+;
*!*			" enddate as 最晚发货, shipdate 船期, excorp 验货公司,batch 批次,transfer 是否接送, transnote 接送人员时间地点, "+;
*!*	  		" hq45 , hq40,  flc40, flc20, lcl,note 备注,  pur 采购回复, moc 生管回复, ware 仓库回复, commodity 通过单是否已做, piexamine.billname 修改人,"+;
*!*	  		"piexamine.creatdate 修改日期,Coptc.TC001,Coptc.TC002 "+;
*!*	 		"FROM COPTC Coptc LEFT JOIN dbo.piexamine Piexamine  ON  Coptc.TC001 = Piexamine.tc001 AND Coptc.TC002 = Piexamine.tc002 "+;
*!*	 		" LEFT JOIN CMSMV ON Coptc.TC006=MV001 left join COPMA on Coptc.TC004=MA001 left join pi on Coptc.UDF55=pi.interid "+;
*!*	 		" WHERE Coptc.TC027='Y' &mWhere","TmpPiexamine")<0
*!*			WAIT WINDOWS '???'
*!*			RETURN 
*!*		ENDIF	
*? SQLEXEC(con,"select syscolumns.name,syscolumns.length,systypes.name as tname,CAST(sys.extended_properties.[value] as char(20) )AS tname,"+;
"syscolumns.isnullable from syscolumns join systypes on syscolumns.xtype=systypes.xtype and systypes.name <> 'sysname ' "+;
"LEFT OUTER JOIN sys.extended_properties ON (sys.extended_properties.minor_id = syscolumns.colid "+;
"  AND sys.extended_properties.major_id = syscolumns.id) "+;
"where syscolumns.id in (select id from sysobjects where name= 'AgeGroup') ","tmpPIInfo")
*?SQLEXEC(con,"select sysobjects.name,sys.extended_properties.value as note from sysobjects "+;
"left join sys.extended_properties on sysobjects.id=sys.extended_properties.major_id "+;
" order by name","tmptable")

*IF SQLEXEC(CON,"SELECT resda031 主题,gys.*,username 制表人,resda015 制作日期,resda018 起始传送日期,resda019 结案日期, "+;
	"case when resda020='1' then '1.未传送' when resda020='2' then '2.审批中' when resda020='3' then '3.已审批' when resda020='4' then '4.已撤销' end as 审批状态,"+;
	"case when resda021='1' then '1.未完成' when resda021='2' then '2.同意' when resda021='3' then '3.不同意' when resda021='4' then '4.已撤销' end as 审批结果, "+;
	"case when resda032='0' then '0.低' when resda032='1' then '1.普通' when resda032='2' then '2.高'  end as 重要性,resal002 部门 "+;
	" FROM resda inner join gys on resda001=gys001 and resda002=gys002 inner join users on resda016=uid inner join resan on resda016=resan003"+;
	" inner join resal on resan001=resal001 ","cursor_tmp")<0
IF SQLEXEC(CON,"SELECT DISTINCT CAST(resda031 as char(230)) 主题,CAST(username as char(10)) 制表人,resda015 制作日期,resda018 起始传送日期,resda019 结案日期, "+;
	"case when resda020='1' then '1.未传送' when resda020='2' then '2.审批中' when resda020='3' then '3.已审批' when resda020='4' then '4.已撤销' end as 审批状态,"+;
	"case when resda021='1' then '1.未完成' when resda021='2' then '2.同意' when resda021='3' then '3.不同意' when resda021='4' then '4.已撤销' end as 审批结果, "+;
	"case when resda032='0' then '0.低' when resda032='1' then '1.普通' when resda032='2' then '2.高'  end as 重要性,"+;
	"cast((select top 1 resal002 from resda as resda1 inner join resan on resda016=resan003 inner join resal on resan001=resal001 where resda1.resda016=resda.resda016 ) as char(10)) as 部门, "+;
	"&f1 as 单别,&f2 "+;
	"&t1  "+;
	"&t2  "+;
	" FROM resda inner join &p_driver as a on resda001=&f1 and resda002=&f2 inner join users on resda016=uid left join resdd on resda016=resdd007 "+;
	"where &a9 "+;
	" &mWhere &a8 order by 3","cursor_tmp1")<0
	WAIT windows '???'
	ENDIF
SQLDISCONNECT(CON)
BROWSE &&where &F1"+;	"&t2 "+;
	"&t3 		"&t4 "+;
	"&t5 "+;
	"&t6 "+;
	" &mWhere &tj,resal002 部门inner join resal on resda904=resal001 inner join resan on resda016=resan003"+;
	" inner join resal on resan001=resal001 ,resal002 部门