con=odbc(10)
*!*		IF sqlexec(con,"SELECT MV002 AS ҵ��Ա,Coptc.TC001+Coptc.TC002 ��������,MA002 �ͻ�����,Coptc.TC012 PO, "+;
*!*			"CASE WHEN exfrom IS NULL THEN ''  ELSE SUBSTRING(exfrom,1,4)+'.'+SUBSTRING(exfrom,5,2)+'.'+SUBSTRING(exfrom,7,2) END AS �����ʼ��,"+;
*!*			"CASE WHEN exto IS NULL THEN ''  ELSE SUBSTRING(exto,1,4)+'.'+SUBSTRING(exto,5,2)+'.'+SUBSTRING(exto,7,2) END AS �����ֹ��,"+;
*!*			" enddate as ������, shipdate ����, excorp �����˾,batch ����,transfer �Ƿ����, transnote ������Աʱ��ص�, "+;
*!*	  		" hq45 , hq40,  flc40, flc20, lcl,note ��ע,  pur �ɹ��ظ�, moc ���ܻظ�, ware �ֿ�ظ�, commodity ͨ�����Ƿ�����, piexamine.billname �޸���,"+;
*!*	  		"piexamine.creatdate �޸�����,Coptc.TC001,Coptc.TC002 "+;
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

*IF SQLEXEC(CON,"SELECT resda031 ����,gys.*,username �Ʊ���,resda015 ��������,resda018 ��ʼ��������,resda019 �᰸����, "+;
	"case when resda020='1' then '1.δ����' when resda020='2' then '2.������' when resda020='3' then '3.������' when resda020='4' then '4.�ѳ���' end as ����״̬,"+;
	"case when resda021='1' then '1.δ���' when resda021='2' then '2.ͬ��' when resda021='3' then '3.��ͬ��' when resda021='4' then '4.�ѳ���' end as �������, "+;
	"case when resda032='0' then '0.��' when resda032='1' then '1.��ͨ' when resda032='2' then '2.��'  end as ��Ҫ��,resal002 ���� "+;
	" FROM resda inner join gys on resda001=gys001 and resda002=gys002 inner join users on resda016=uid inner join resan on resda016=resan003"+;
	" inner join resal on resan001=resal001 ","cursor_tmp")<0
IF SQLEXEC(CON,"SELECT DISTINCT CAST(resda031 as char(230)) ����,CAST(username as char(10)) �Ʊ���,resda015 ��������,resda018 ��ʼ��������,resda019 �᰸����, "+;
	"case when resda020='1' then '1.δ����' when resda020='2' then '2.������' when resda020='3' then '3.������' when resda020='4' then '4.�ѳ���' end as ����״̬,"+;
	"case when resda021='1' then '1.δ���' when resda021='2' then '2.ͬ��' when resda021='3' then '3.��ͬ��' when resda021='4' then '4.�ѳ���' end as �������, "+;
	"case when resda032='0' then '0.��' when resda032='1' then '1.��ͨ' when resda032='2' then '2.��'  end as ��Ҫ��,"+;
	"cast((select top 1 resal002 from resda as resda1 inner join resan on resda016=resan003 inner join resal on resan001=resal001 where resda1.resda016=resda.resda016 ) as char(10)) as ����, "+;
	"&f1 as ����,&f2 "+;
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
	" &mWhere &tj,resal002 ����inner join resal on resda904=resal001 inner join resan on resda016=resan003"+;
	" inner join resal on resan001=resal001 ,resal002 ����