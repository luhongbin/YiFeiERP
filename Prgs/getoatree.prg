
closedb("LHB1")
ERASE LHB1.*
CREATE DBF LHB1 FREE (keyid i,fkey i,nodeicon i ,selecticon i,exicon i,name Character(30),code Character(26),main Character(26))
*!*	USE LHB1 IN 0

con=odbc(13)
IF SQLEXEC(con,"select sysak002,sysak001,sysak005 from sysak "+;
"where sysak006='Y'  order by 3","tmp1")<0
WAIT windows '????' nowait
ENDIF 
SELECT tmp1
DO WHILE .not. EOF()
	s1=sysak002
	s2=sysak001
	s3=sysak005
	SELECT LHB1
	APPEND BLANK 
	replace keyid WITH s3,fkey WITH 0,name WITH s1,main WITH s2,nodeicon WITH 1,selecticon  WITH 4,exicon  WITH 1
	x=keyid

	SELECT tmp1
	SKIP
ENDDO 

x=x+1
SQLEXEC(con,"select resca001,resca002,resca024,sysal002 as resca024n,CAST(left(resca025,CHARINDEX('-',resca025)-1) as char(10)) as resca025  "+;
"from resca inner join sysal on resca024=sysal001 where resca026='Y' and resca086='2'and resca084='1' order by 3","tmp1")
closedb("tmp2")
SELECT resca024	,resca024n,resca025   FROM tmp1 GROUP BY resca024	,resca024n,resca025  INTO CURSOR tmp2
SELECT tmp2
GO top
DO whil .not. EOF()
	s1=resca024	
	s2=resca024n
	s3=ALLTRIM(resca025)
	SELECT LHB1
	LOCATE FOR ALLTRIM(main)=s3
	IF FOUND()
		y=keyid
		SELECT LHB1
		replace exicon  WITH 2
		c1=main
		APPEND BLANK 	
		replace keyid WITH x,fkey WITH y,name WITH s2,code WITH s1,nodeicon WITH 1,selecticon  WITH 4,exicon  WITH 2,main WITH c1
	ENDIF 
	SELECT tmp2
	x=x+1
	SKIP
ENDDO 

x=x+1
SELECT tmp1
DO whil .not. EOF()
	s1=resca001	
	s2=resca002
	s3=ALLTRIM(resca024)
	s4=ALLTRIM(resca024n)
	S5=ALLTRIM(resca025)
	SELECT lhb1
	LOCATE FOR ALLTRIM(main)=s5 AND ALLTRIM(code)=s3
	IF FOUND()
		replace exicon  WITH 5
	y=keyid
	c1=main
	APPEND BLANK 	
	replace keyid WITH x,fkey WITH y,name WITH s2,code WITH s1,nodeicon WITH 1,selecticon  WITH 4,exicon  WITH 5,main WITH c1
	ENDIF 
	SELECT tmp1
	x=x+1
	SKIP
ENDDO 
SQLDISCONNECT(CON)
SELECT lhb1
*!*	DELETE FOR exicon=1 and fkey=0

*!*	DELETE FOR exicon=2 and fkey<>0
*!*	PACK
GO TOP
