RELEASE A1,A2,A3,A4,A6,A5
PUBLIC  A1,A2,A3,A4,A6,A5
WAIT WINDOWS '正在读取PI打印信息...' NOWAIT 
CURSORSETPROP("MapBinary",.T.,0)&&非常关键

CON=ODBC(5)
SQLEXEC(con,"update pi set repi=getdate() where interid=?keyid")  &&回复PI日期

SQLEXEC(CON,"SELECT pi.*,pidetail.* ,CASE WHEN incoterm ='FOB' THEN 'FOB '+loading WHEN incoterm ='CNF' OR incoterm ='CIF' THEN RTRIM(incoterm)+' ' +discharge "+;
  "WHEN incoterm ='EXW' THEN 'EXW' ELSE '' END AS incoterm1,NA003 "+;
  " from pi inner join pidetail on pi.interid=pidetail.maininterid left join CMSNA  on NA001='2' and paycon =NA002 "+;
  "where pi.interid=?keyid","t1")
SQLDISCONNECT(CON)
SELECT t1

P_Ass=ALLTRIM(getbank)

CON=ODBC(6)
SQLEXEC(CON,"SELECT note,interid from bankname where name=?P_Ass ORDER BY interid","t3")
SQLDISCONNECT(con)
SELECT t3
IF RECCOUNT()<1
a1=''
a2=''
a3=''
a4=''
else
GO 1
A1=NOTE
GO 2
A2=NOTE
GO 3
A3=NOTE
GO 4
A4=NOTE
GO 5
A5=NOTE
IF RECCOUNT()=6
GO 6
A6=NOTE
ELSE
A6=''
ENDIF
endif
*ERASE lhbpic?
con=odbc(5)
SQLEXEC(CON,"SELECT classid,filedata  from billpic where interid=?keyid AND classid=1","t2")
IF RECCOUNT()=1
STRTOFILE(filedata  ,"lhbpic1")
ELSE
STRTOFILE(''  ,"lhbpic1")

ENDIF 
SQLEXEC(CON,"SELECT classid,filedata  from billpic where interid=?keyid AND classid=2","t2")
IF RECCOUNT()=1
STRTOFILE(filedata  ,"lhbpic2")
ELSE
STRTOFILE(''  ,"lhbpic2")

ENDIF 
SQLDISCONNECT(CON)
WAIT windows '读取完毕' NOWAIT

codeid=2011100000 
PUBLIC goPic AS Image
m.goPic = NEWOBJECT( 'Image' )
SET REPORTBEHAVIOR 80
SELECT t1

DO &P_Others.OrderInfoPrint.Mpr

FUNCTION _GetPic
  IF empty(t1.pic) OR  isnull(t1.pic)
	  m.goPic.pictureval = ''
  ELSE
	  m.goPic.pictureval = t1.pic
  ENDIF 	  
  RETURN .T.
ENDFUNC

