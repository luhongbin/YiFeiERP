con=odbc(6)
SQLEXEC(con,"update Workdaily set chkid=1,chkname='Â³ºì±ó',chkdate=getdate() where chkid=0 and  DATEDIFF(day, creatdate, GETDATE())>1 and diagnosis=1")
SQLEXEC(con,"select case when SUBstring(scode,5,1) NOT LIKE '%[^0-9]%' then LEFT(scode,4) else LEFT(scode,5) end scode,"+;
"workorder,SUM(okquan),SUM(badquan) badquan from Workdaily where LEN(RTRIM(scode))>3 and diagnosis=0 and LEFT(scode,1)<='9' "+;
"group by case when SUBstring(scode,5,1) NOT LIKE '%[^0-9]%' then LEFT(scode,4) else LEFT(scode,5) end,workorder","tmp")

SQLEXEC(con,"select scode,dateid,workorder,code,okquan,badquan,interid from Workdaily where LEN(RTRIM(scode))>3 and diagnosis=0 order by scode,dateid,workorder,code","tmp")
