MDEPTs=1.5
MDEPT='样品组'
CON1=odbc(11)
IF SQLEXEC(CON1,"SELECT distinct DATENAME(weekday,A.Date) as XQ ,T.Name AS jiaq,CONVERT(varchar(10), A.Date, 112) date "+;
	" FROM  AttendanceCalendar AS A LEFT JOIN  AttendanceHolidayType AS T ON A.AttendanceHolidayTypeId = T.AttendanceHolidayTypeId "+;
	"WHERE LEFT( CONVERT(varchar(12), a.Date, 112),4)+'.'+substring( CONVERT(varchar(12), a.Date, 112),5,2)>='2015.11' order by 3 desc","tmp2")<0
	WAIT windows '?????lu'
ENDIF 
SELECT tmp2
DO whil .not. EOF()
	x1=ALLTRIM(xq)
	x2=ALLTRIM(jiaq)
	x3=date 

	IF X1='星期三' OR X1='星期日' 
		XJB=0
	ELSE
		XJB=0
	ENDIF
	IF X2='节日' OR X2='假日'
		XJB=0
		SB=0
	ELSE
		IF X1='星期日' 
			SB=0
		ELSE
			SB=7.5
		ENDIF	
	ENDIF	
	IF SQLEXEC(CON1,"INSERT workshopouttime (dateid,dept,calc,hours,outhours,worker,outworker,billname,creatdate) values "+;
	"(?x3,?MDEPT,?x2,?sb,?xjb,?MDEPTs,?MDEPTs,'刘建宁',getdate())")<0
		WAIT windows '????'
		RETURN
	endif	
	SELECT tmp2
	skip
ENDDO
SQLDISCONNECT(con1)
