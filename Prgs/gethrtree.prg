
closedb("LHB11111111111")
ERASE LHB11111111111.*
CREATE CURSOR  LHB11111111111 (keyid n(18,0) ,fkey n(18,0),nodeicon i ,selecticon i,exicon i,name Character(30),code Character(26),main Character(26))

con=odbc(11)
IF SQLEXEC(con,"select D.shortname as name,D.floorcode,A.CnName boss from Corporation d "+;
	"LEFT JOIN Employee  a ON d.Principal=A.EmployeeID where d.levelcode=2  and D.floorcode<>'1.1.1.11'order by 1 DESC","tmp1")<0
	WAIT windows '????a' 
ENDIF 
IF SQLEXEC(con,"select D.name,D.floorcode,A.CnName boss "+;
" from Department d LEFT JOIN Employee A ON d.Principal=A.EmployeeID   order by 2","tmp2")<0
	WAIT windows '????f' 
ENDIF
SELECT tmp1
xx=0
GO top
DO whil .not. EOF()
	s1=name
	s2=boss
	IF ISNULL(boss)
		s2=''
	endif
	s3=ALLTRIM(floorcode)
	s5=LEN(s3)
	S4=VAL(CHRTRAN(floorcode,'.',''))
	SELECT LHB11111111111
     IF s3 <> '1.1.1.11'
	  	APPEND BLANK 
		replace keyid WITH s4,fkey WITH 0,name WITH s1,main WITH s2,nodeicon WITH 1,selecticon  WITH 4,exicon  WITH 1,code WITH s3
	ENDIF 	
	SQLEXEC(con,"select COUNT(*) b from Employee a inner join EmployeeState q on a.EmployeeStateId=q.EmployeeStateId"+;
	" AND (q.EmployeeStateTypeId='EmployeeStateType_001' OR q.EmployeeStateTypeId='EmployeeStateType_002') left join Department as e on a.DepartmentId=e.DepartmentId  "+;
        "where LEFT(e.floorcode,?s5)=?s3 AND A.code<>'439' ","tmpsa1")
     IF ISNULL(b)
     	x=''
     else
	     x=ALLTRIM(STR(b))+'人,'
	 	SQLEXEC(con,"select SUM(SalaryFixedDetail.KeyValue) b from Employee a inner join EmployeeState q on a.EmployeeStateId=q.EmployeeStateId"+;
		" AND (q.EmployeeStateTypeId='EmployeeStateType_001' OR q.EmployeeStateTypeId='EmployeeStateType_002') inner join SalaryFixedDetail on SalaryFixedDetail.EmployeeId=a.EmployeeId "+;
		"inner join SalaryKey on SalaryFixedDetail.SalaryKeyId=SalaryKey.SalaryKeyId left join Department as e on a.DepartmentId=e.DepartmentId  "+;
	        "where LEFT(e.floorcode,?s5)=?s3 AND A.code<>'439'   AND SalaryFixedDetail.enddate>=getdate()","tmpsa1")
	     SELECT    tmpsa1
	     IF ISNULL(b)
	     else
		     x=x+ALLTRIM(STR(b/10000,10,1))+'万元'
		 ENDIF     
	ENDIF 	 
     SELECT LHB11111111111
    	replace name WITH ALLTRIM(name)+'('+ALLTRIM(main)+')'+x
	SELECT tmp1
	SKIP
ENDDO 

SELECT tmp2
replace boss WITH '' FOR ISNULL(boss)
GO top
DO whil .not. EOF()
	s1=name
	s2=boss
	IF ISNULL(boss)
		s2=''
	endif
	s3=ALLTRIM(floorcode)
	s5=LEN(s3)
	S4=VAL(CHRTRAN(floorcode,'.',''))

	xx=VAL(CHRTRAN(SUBSTR(ALLTRIM(floorcode),1,LEN(ALLTRIM(floorcode))-2),'.',''))
	SELECT LHB11111111111
     IF s3 <> '1.1.1.11'
	  	APPEND BLANK 
	  	replace keyid WITH s4,fkey WITH xx,name WITH s1,main WITH s2,nodeicon WITH 1,selecticon  WITH 4,exicon  WITH 1,code WITH s3
	 ENDIF  	
	SQLEXEC(con,"select COUNT(*) b from Employee a inner join EmployeeState q on a.EmployeeStateId=q.EmployeeStateId"+;
	" AND (q.EmployeeStateTypeId='EmployeeStateType_001' OR q.EmployeeStateTypeId='EmployeeStateType_002') left join Department as e on a.DepartmentId=e.DepartmentId  "+;
        "where LEFT(e.floorcode,?s5)=?s3 AND A.code<>'439' ","tmpsa1")
     IF ISNULL(b)
     	x=''
     else
	     x=ALLTRIM(STR(b))+'人,'
	 	SQLEXEC(con,"select SUM(SalaryFixedDetail.KeyValue) b from Employee a inner join EmployeeState q on a.EmployeeStateId=q.EmployeeStateId"+;
		" AND (q.EmployeeStateTypeId='EmployeeStateType_001' OR q.EmployeeStateTypeId='EmployeeStateType_002') inner join SalaryFixedDetail on SalaryFixedDetail.EmployeeId=a.EmployeeId "+;
		"inner join SalaryKey on SalaryFixedDetail.SalaryKeyId=SalaryKey.SalaryKeyId left join Department as e on a.DepartmentId=e.DepartmentId  "+;
	        "where LEFT(e.floorcode,?s5)=?s3 AND A.code<>'439'  AND SalaryFixedDetail.enddate>=getdate() ","tmpsa1")
	     SELECT    tmpsa1
	     IF ISNULL(b)
	     else
		     x=x+ALLTRIM(STR(b/10000,10,1))+'万元'
		 ENDIF     
	ENDIF 	 
     SELECT LHB11111111111
    	replace name WITH ALLTRIM(name)+'('+ALLTRIM(main)+')'+x	
     SELECT tmp2
	SKIP
ENDDO 
SELECT LHB11111111111
*replace name WITH ALLTRIM(name)+'('+ALLTRIM(main)+')'&& all
SQLDISCONNECT(con)

GO top
*!*	closedb("tmp2")
*!*	closedb("tmp1")