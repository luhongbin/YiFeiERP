=SYS(3101,936)
rqmd="D:\PI"+ALLTRIM(STR(KEYID))+".xlsx"  &&Sys(5) + Curdir() +

Delete File rqmd
*ON ERROR DO errHandler WITH  ERROR( ), MESSAGE( ), MESSAGE(1), PROGRAM( ), LINENO( )
ON ERROR wait windows '' nowait
ef=CREATEOBJECT('Excel.application')

&&����Excel����
ef.Workbooks.add
&&��ӹ�����
ef.Worksheets("sheet1").Activate
&&�����һ��������
ef.visible=.f.
Delete FILE &rqmd

*!*	If !File(rqmd)
*!*	    ef.ActiveWorkbook.SaveAs(rqmd)
*!*	ELSE
*!*		WAIT WINDOWS '�����Ѿ��򿪣��رպ����·��Ŷ���'
*!*		RETURN
*!*	    lcFileName = ef.GetSaveAsFilename(rqmd, "Excel (*.xls), *.xls")
*!*	    If !Empty(lcFileName)
*!*	        If File(lcFileName)
*!*	            Delete File (lcFileName)
*!*	        Endif
*!*	        ef.ActiveWorkbook.SaveAs(lcFileName)
*!*	    Endif
*!*	Endif


&&��ʾExcel����
*!*	ef.Cells.Select
&&ѡ�����ű�
ef.Selection.Font.Size = 10
&&��������Ĭ�������СΪ10
*!*	ef.range("A1:K1").Select
&&ѡ����������ڵ�Ԫ��
ef.Selection.Merge
&&�ϲ���Ԫ��
*!*	with ef.range("A1")
*etContinuous  ������   1
*!*	etDash  ����   -4115
*!*	etDashDot  �㻮��   4
*!*	etDashDotDot  ˫��Ļ���   5
*!*	etDot  ����  -4118
*!*	etDouble  ˫����  -4119
*!*	etSlantDashDot  ��б�㻮��   -4142
*!*	etLineStyleNone  ��   13 
ef.range("A1").HorizontalAlignment=2
ef.Rows(1).RowHeight=1/0.0035/6
ef.ActiveSheet.Cells(3,1).Font.Name="����"
ef.ActiveSheet.Cells(1,1).Font.Name="����"
ef.ActiveSheet.Cells(2,1).Font.Name="����"
ef.ActiveSheet.Cells(1,1).Font.Size=25
ef.ActiveSheet.Cells(2,1).Font.Size=14
ef.ActiveSheet.Cells(3,1).Font.Size=14

ef.Range("A1:F1").Select
ef.Selection.Merge
ef.Range("A1").value='����ҫ̩�������޹�˾���Ŷ���'
ef.range("A1").HorizontalAlignment=2
ef.range("A2").HorizontalAlignment=2
ef.range("A3").HorizontalAlignment=2

ef.Range("A2:H2").Select
ef.Selection.Merge
ef.Range("A3:H3").Select
ef.Selection.Merge
CON=ODBC(5)
Sqlexec(CON,"select pi.classid ���� ,pi.interid AS PI����,discharge,MA002 AS �ͻ����,MV002 ҵ��Ա,pi.po, pi.billname AS �Ƶ���,"+;
  	"chkdate,po,standard,rose,boxnum,p.EXTO,MA001  from pi INNER JOIN pipro p on pi.interid=p.interid inner join COPMA ON customid=MA001"+;
  	" LEFT JOIN CMSMV ON MA016=MV001   where pi.interid=?keyid","tmp")
SQLDISCONNECT(con)

*=SYS(3101,65001)
IF LEN(ALLTRIM(STRCONV(discharge,14)))>2
xxxx='ж���ۣ�'+ALLTRIM(STRCONV(discharge,14))
ELSE 
xxxx='ж����ûָ��'
ENDIF 
*!*	SELECT tmppiInfoDetailsc 
*!*	erpbill=ALLTRIM(tmppiInfoDetailsc.coptd)&&TD001)+'-'+ALLTRIM(tmppiInfoDetailsc .TD002)+'  ERP����:'+ERPBILL
*!*	ERPMD=ALLTRIM(tmppiInfoDetailsc.UDF04)
ef.Range("A2").value='����:'+ALLTRIM(����)+',PI:'+ALLTRIM(STR(PI����))+',�ͻ�:'+ALLTRIM(MA001)+'   ҵ��Ա:'+ALLTRIM(ҵ��Ա)+'('+ALLTRIM(�Ƶ���)+') ����ʱ��:'+TTOC(CHKDATE)
XXXX=XXXX+'����Ʒ��׼:'+ALLTRIM(standard)
IF rose=1
	XXXX=xxxx+'��Ҫ�����ROHS��׼'
ENDIF	
IF boxnum=1
	XXXX=XXXX+'����Ҫ�����'+ALLTRIM(EXTO)
ENDIF	
*=SYS(3101,936)

CON=ODBC(5)


Sqlexec(CON,"select filedata pic,filename,classid from billpic where interid=?keyid and classid<=2 ORDER BY classid","temp")
SELECT temp
TRY
	_Screen.RemoveObject( 'pic1' )
CATCH TO oException2
	WAIT WINDOWS '' NOWAIT
ENDTRY
IF RECCOUNT()>=1
		ERASE OldPath+"\TMPLH2W11"
		ERASE OldPath+"\TMPLH2W22"
		GO 1
		ef.Range("A1:F1").Select
		ef.Selection.Merge
		ef.ActiveSheet.Cells(1,7).Font.Size=14
		ef.Range("G1").value='��ͷ:'
		TRY

		STRTOFILE(pic,OldPath+"\TMPLH2W1"+'1')
		_Screen.AddObject( 'pic1', 'Image' )
		_Screen.pic1.Picture=OldPath+"\TMPLH2W1"+'1'
		ef.Cells( 1,8).Activate
		ef.ActiveSheet.PictureS.Insert(OldPath+"\TMPLH2W1"+'1').Select
		ef.Selection.ShapeRange.LockAspectRatio =.T.
		Target =ef.Cells( 1,8)
		ef.Selection.Top = Target.Top + 2
		ef.Selection.Left = Target.Left + 2
		ef.Selection.ShapeRange.Height =100
		ef.Rows(1).RowHeight=70
			_Screen.RemoveObject( 'pic1' )
		CATCH TO oException2
			WAIT WINDOWS '' NOWAIT
		ENDTRY
	IF RECCOUNT()=2
		GO 2
		TRY

		STRTOFILE(pic,OldPath+"\TMPLH2W2"+'2')
		_Screen.AddObject( 'pic1', 'Image' )
		_Screen.pic1.Picture=OldPath+"\TMPLH2W2"+'2'
		ef.Cells( 1,10).Activate
		ef.ActiveSheet.PictureS.Insert(OldPath+"\TMPLH2W2"+'2').Select
		ef.Selection.ShapeRange.LockAspectRatio =.T.
		Target =ef.Cells( 1,10)
		ef.Selection.Top = Target.Top + 2
		ef.Selection.Left = Target.Left + 2
		CATCH TO oException2
			WAIT WINDOWS '' NOWAIT
		ENDTRY
	ENDIF
		TRY
			_Screen.RemoveObject( 'pic1' )
		CATCH TO oException2
			WAIT WINDOWS '' NOWAIT
		ENDTRY
ELSE	
	XXXX=XXXX+'������ͷ'
ENDIF	
SELECT TMP
IF ALLTRIM(po)<>''
	ef.Range("A3").value='�ͻ�������:'+ALLTRIM(po)+' '+XXXX  &&'�����첿��:'+ERPMD+
ELSE
	ef.Range("A3").value=XXXX
ENDIF 	
ef.Range(ef.Cells(4,1),ef.Cells(4,11)).BorderS.LineStyle=-4142
ef.Range(ef.Cells(4,1),ef.Cells(4,11)).BorderS.weight = -4138
ef.Range(ef.Cells(4,1),ef.Cells(4,11)).HorizontalAlignment=3 &&ˮƽ(1-Ĭ�ϡ�2-����3-���С�4-���ҡ�5-��䡢6=���˶��롢7=���о��С�8=��ɢ����)
ef.ActiveSheet.ROWS(4).Font.Bold=.T.
ef.Range("A4").value='ERPƷ��'
ef.Range("B4").value='��˾����'
ef.Range("C4").value='�ͻ�Ʒ��'
ef.Range("D4").value='��Ʒ����'
ef.Range("E4").value='��Ʒ��ɫ'
ef.Range("F4").value='��������'
ef.Range("G4").value='��������'
ef.Range("H4").value='����'
ef.Range("I4").value='���'
ef.Range("J4").value='��ע������Ҫ��'
ef.Range("K4").value="˵����Ʒ��"

ef.ActiveSheet.Columns(1).ColumnWidth =20
ef.ActiveSheet.Columns(2).ColumnWidth =10
ef.ActiveSheet.Columns(3).ColumnWidth =10
ef.ActiveSheet.Columns(4).ColumnWidth =30
ef.ActiveSheet.Columns(5).ColumnWidth =30
ef.ActiveSheet.Columns(6).ColumnWidth =10
ef.ActiveSheet.Columns(7).ColumnWidth =12
ef.ActiveSheet.Columns(8).ColumnWidth =10
ef.ActiveSheet.Columns(9).ColumnWidth =10
ef.ActiveSheet.Columns(10).ColumnWidth =50
ef.ActiveSheet.Columns(11).ColumnWidth =20
Sys(987,.F.) 

IF 	SQLEXEC(CON,"SELECT distinct case when COPTD.TD001 IS NULL THEN '' ELSE RTRIM(COPTD.TD001)+rTRIM(COPTD.TD002)+'-'+COPTD.TD003 END+ "+;
"CASE WHEN p.piinterid is null THEN '' when p.cid=1 then '[��'+rtrim(MF001)+']' when p.cid=2 then '[��'+RTRIM(x.TD001)+RTRIM(x.TD002)+']' "+;
"ELSE '[��'+RTRIM(COPTD.TD015)+']' end   AS COPTD "+;
",pidetail.itemno AS  ��˾����,"+;
"pidetail.customcode,pidetail.code,pidetail.name,pidetail.spec,pidetail.supply UDF04,case when e.pidetailinterid is null then 0 else 1 end UDF54,pidetail.customcode,"+;
"CASE WHEN COPTD.TD008 IS NULL THEN pidetail.quan ELSE COPTD.TD008 END quan,case when COPTD.TD016<>'N' THEN COPTD.TD009 ELSE tppcs END ��� ,"+;
"case when COPTD.TD016='V' AND (COPTD.TD001>='227' OR COPTD.TD001='220') THEN  MF009 ELSE COPTD.TD009 END ���� ,pidetail.outerbarcode ,"+;
	"CONVERT(CHAR(10),CAST(pidetail.edate AS DATETIME),102) AS TD013,xx.LOSEMAT,CAST(pidetail.note as char(254)) ��ע ,pidetail.mcpcs ÿ��ֻ��,boxto-boxfrom+1  as ������,"+;
	"RTRIM(CAST(boxfrom as char(5)))+'-'+CAST(boxto as char(5)) as box,"+;
	"COPTD.TD003,COPTD.UDF56 PIDETAILINTERID,pidetail.interid,pidetail.chksms,pidetail.smscode,pidetail.boxok,pidetail.nw,pidetail.gw as weight,mf002,e.pidetailinterid  as pidetailinteridc "+;
	" FROM pidetail left join COPTD COPTD on pidetail.interid=COPTD.UDF56 LEFT JOIN pidetailcallforecast p on p.piinterid=  pidetail.interid "+;
     " LEFT join COPMF as COPMF on p.forecastinterid=COPMF.UDF56 LEFT join COPTD x on p.forecastinterid=x.UDF56 LEFT JOIN pidetailpro xx on xx.interid=pidetail.interid "+;
     "left join exportcode e on e.pidetailinterid=pidetail.interid  WHERE pidetail.maininterid=?keyid and LEFT(pidetail.code,1)<>'X' "+;
	 " ORDER BY 1,pidetail.interid","tmppiInfoXX")	<0
	 WAIT WINDOWS '???'
	 WAIT windows '������' &&&left join pidetail on COPTD.UDF56=pidetail.interidINNER JOIN INVMB ON code = MB001 "
*	",CASE WHEN COPTD.TD001 IS NULL THEN 'X' WHEN COPTD.TD001>='227' THEN "+;
	"RTRIM(COPTD.TD001)+RTRIM(COPTD.TD002)+'%'  WHEN COPTD.TD001<'227' THEN RTRIM(COPTD.TD001)+'-'+RTRIM(COPTD.TD002)+'%' ELSE 'X' END as TA033"+;
	*" LEFT JOIN  extable on tname='��Ʒ������' and f1=TD001 AND f2=TD002 AND f3=TD003 ,TD001,TD002,TD201,TD202,TD203,smscode,chksms,pidetail.mf002
ENDIF   
SELECT tmppiInfoXX
hh1='5'
i=5
go top
DO WHILE .not. EOF()
	mkeyid=interid
	j=ALLTRIM(STR(i))
	ef.Range(ef.Cells(I,1),ef.Cells(I,11)).BorderS.LineStyle=-4142
	ef.Range(ef.Cells(I,1),ef.Cells(I,11)).BorderS.weight = -4138
	ef.ActiveSheet.ROWS(I).Font.Bold=.T.
	*ef.Range(ef.Cells(I,1),ef.Cells(I,11)).Font.Bold = True
	ef.Range(ef.Cells(I,1),ef.Cells(I+1,11)).HorizontalAlignment=3 &&ˮƽ(1-Ĭ�ϡ�2-����3-���С�4-���ҡ�5-��䡢6=���˶��롢7=���о��С�8=��ɢ����)
	ef.Range(ef.Cells(I,1),ef.Cells(I+1,11)).VerticalAlignment=3 &&��ֱ(1=���ϡ�2=���С�3=���¡�4=���˶��롢5=��ɢ����)	
	ef.Range("A&j").value=ALLTRIM(COPTD)+'['+ALLTRIM(UDF04)+']'+chr(13)+chr(10)+ALLTRIM(CODE)
	IF UDF54=1
		ef.Range("B&j").value=ALLTRIM(��˾����)+'[�е���������]'
	ELSE
		ef.Range("B&j").value=ALLTRIM(��˾����)
	ENDIF
	ef.Range("J&J").WrapText=.T.	
	ef.Range("C&j").value=ALLTRIM(customcode)
	ef.Range("C&j").Select
	ef.Selection.NumberFormatLocal = "@"	
	ef.Range("B&j").Select
	ef.Selection.NumberFormatLocal = "@"	
	ef.Range("D&j").value= ALLTRIM(name)
	ef.Range("E&j").value=ALLTRIM(spec)
	ef.Range("F&j").value=quan
	ef.Range("G&j").value=ALLTRIM(TD013)
	ef.Range("H&j").value=ALLTRIM(STR(������))
	ef.Range("I&j").Select
	ef.Selection.NumberFormatLocal = "@" 	
	ef.Range("I&j").value=ALLTRIM(box)
	gd=''
	IF chksms=1
		gd=',˵�������'
	ENDIF 
	IF boxok=1
		gd=gd+',��װ����'
	ENDIF 
	ef.Range("J&j").value=ALLTRIM(ALLTRIM(��ע))+gd
	ef.Range("K&j").value=ALLTRIM(smscode)
	CCCCC=quan
	IF SQLEXEC(CON,"SELECT classid,packagecode,B1.MB002,B1.MB003,long MB093,width MB094, deep MB095,quan,long*width*deep/1000000 vol,weight,des,barcode "+;
		"FROM packageinfo LEFT join INVMB B1 ON packagecode=B1.MB001 where billid=2 and interid=?mkeyid ORDER BY 1,2","TmpP")<0
		WAIT WINDOWS '??xxx?'
		RETURN
	ENDIF
	i=i+1
	j=ALLTRIM(STR(i))		
	ef.Range(ef.Cells(I,1),ef.Cells(I,10)).BorderS.LineStyle=13
	ef.Range(ef.Cells(I,1),ef.Cells(I,10)).BorderS.weight = 2  
*!*		ef.Range(ef.Cells(I,1),ef.Cells(I,10)).Font.Bold = FALSE
	ef.Range(ef.Cells(I,2),ef.Cells(I,10)).Font.Size=8

	&&ef.Selection.Font.Size = 10
*!*		ef.Range(ef.Cells(I,1),ef.Cells(I+1,11)).BorderS.LineStyle=0
	*ef.Range("A3:"+activecellname).Characters.Font.Size= 9
	ef.ActiveSheet.ROWS(I).Font.Bold=.F.

	ef.Range("B&j").value='��װ���'
	ef.Range("C&j").value='Ʒ��'
	ef.Range("D&j").value='Ʒ��'
	ef.Range("E&j").value='���'
	ef.Range("F&j").value='ÿ������'
	ef.Range("G&j").value='���'
	ef.Range("H&j").value='����'
	ef.Range("I&j").value='����'
	ef.Range("J&j").value='����'
	ef.Range("K&j").value='����'
	SELECT tmpp
	GO top
	DO whil .not. EOF()
		i=i+1
		j=ALLTRIM(STR(i))	
		ef.ActiveSheet.ROWS(I).Font.Bold=.F.
		ef.Range(ef.Cells(I,1),ef.Cells(I,11)).Font.Size=8
		ef.Range(ef.Cells(I,1),ef.Cells(I+1,11)).HorizontalAlignment=3 &&ˮƽ(1-Ĭ�ϡ�2-����3-���С�4-���ҡ�5-��䡢6=���˶��롢7=���о��С�8=��ɢ����)

		ef.Range(ef.Cells(I,1),ef.Cells(I,11)).BorderS.LineStyle=13
		ef.Range(ef.Cells(I,1),ef.Cells(I,11)).BorderS.weight = 2  
		ef.Range("B&j").value=ALLTRIM(classid)
		ef.Range("C&j").value=ALLTRIM(packagecode)
		ef.Range("D&j").value= ALLTRIM(MB002)
		ef.Range("E&j").value=ALLTRIM(MB003)
		ef.Range("F&j").value=quan
		ef.Range("G&j").value=vol*CCCCC/quan
		ef.ActiveSheet.Range("G&j:G&j").NumberFormatLocal =  "0.000"

		ef.Range("H&j").value=weight
		ef.Range("I&j").value=weight*CCCCC/quan
		ef.Range("J&j").value=des
		ef.Range("K&j").value=barcode 
		skip
	ENDDO 
	SQLEXEC(con,"select 'ͨ��Ʒ��' classid,b.tb003,B1.MB002,B1.MB003,B1.MB004,b.quan MB094,b.price MB053 ,b.quan * b.price CASH "+;
	"FROM pmoctb b inner join pmocta a on b.maininterid=a.interid inner join pidetail p on a.detailinterid=p.interid  LEFT join INVMB B1 ON b.tb003=B1.MB001 "+;
	"  WHERE p.code='Z00000' AND p.maininterid=?keyid")

	IF RECCOUNT()>=1
	i=i+1
	j=ALLTRIM(STR(i))		
	ef.Range(ef.Cells(I,1),ef.Cells(I,14)).BorderS.LineStyle=13
	ef.Range(ef.Cells(I,1),ef.Cells(I,14)).BorderS.weight = 2  
*!*		ef.Range(ef.Cells(I,1),ef.Cells(I,10)).Font.Bold = FALSE
	ef.Range(ef.Cells(I,2),ef.Cells(I,14)).Font.Size=8

	&&ef.Selection.Font.Size = 10
*!*		ef.Range(ef.Cells(I,1),ef.Cells(I+1,11)).BorderS.LineStyle=0
	*ef.Range("A3:"+activecellname).Characters.Font.Size= 9
	ef.ActiveSheet.ROWS(I).Font.Bold=.F.

	ef.Range("B&j").value='����'
	ef.Range("C&j").value='Ʒ��'
	ef.Range("D&j").value='Ʒ��'
	ef.Range("E&j").value='���'
	ef.Range("F&j").value='��λ'
	ef.Range("G&j").value='����'
	ef.Range("H&j").value='����'
	ef.Range("I&j").value='���'
	ef.Range("J&j").value='����'
	SELECT tmpp
	GO top
	DO whil .not. EOF()
		i=i+1
		j=ALLTRIM(STR(i))	
		ef.ActiveSheet.ROWS(I).Font.Bold=.F.
		ef.Range(ef.Cells(I,1),ef.Cells(I,14)).Font.Size=8
		ef.Range(ef.Cells(I,1),ef.Cells(I+1,14)).HorizontalAlignment=3 &&ˮƽ(1-Ĭ�ϡ�2-����3-���С�4-���ҡ�5-��䡢6=���˶��롢7=���о��С�8=��ɢ����)

		ef.Range(ef.Cells(I,1),ef.Cells(I,14)).BorderS.LineStyle=13
		ef.Range(ef.Cells(I,1),ef.Cells(I,14)).BorderS.weight = 2  
		ef.Range("B&j").value=ALLTRIM(classid)
		ef.Range("C&j").value=ALLTRIM(code)
		ef.Range("D&j").value= ALLTRIM(MB002)
		ef.Range("E&j").value=ALLTRIM(MB003)
		ef.Range("F&j").value=MB004
		ef.Range("G&j").value=MB094
		ef.Range("H&j").value=MB053 
		ef.Range("I&j").value=CASH 
		skip
	ENDDO 
	ENDIF 


	IF SQLEXEC(CON,"SELECT '�ϼ�����' classid,exportcode.code,B1.MB002,B1.MB003,B1.MB004,totalpcs MB094, B1.MB053 ,B1.MB053 *pcs*pidetail.quan CASH "+;
		"FROM exportcode LEFT join INVMB B1 ON code=B1.MB001 inner join pidetail on pidetail.interid=pidetailinterid "+;
		" where pidetailinterid=?mkeyid ORDER BY 1,2","TmpP")<0
		WAIT WINDOWS '??xxx?'
		RETURN
	ENDIF
	IF RECCOUNT()>=1
	i=i+1
	j=ALLTRIM(STR(i))		
	ef.Range(ef.Cells(I,1),ef.Cells(I,14)).BorderS.LineStyle=13
	ef.Range(ef.Cells(I,1),ef.Cells(I,14)).BorderS.weight = 2  
*!*		ef.Range(ef.Cells(I,1),ef.Cells(I,10)).Font.Bold = FALSE
	ef.Range(ef.Cells(I,2),ef.Cells(I,14)).Font.Size=8

	&&ef.Selection.Font.Size = 10
*!*		ef.Range(ef.Cells(I,1),ef.Cells(I+1,11)).BorderS.LineStyle=0
	*ef.Range("A3:"+activecellname).Characters.Font.Size= 9
	ef.ActiveSheet.ROWS(I).Font.Bold=.F.

	ef.Range("B&j").value='����'
	ef.Range("C&j").value='Ʒ��'
	ef.Range("D&j").value='Ʒ��'
	ef.Range("E&j").value='���'
	ef.Range("F&j").value='��λ'
	ef.Range("G&j").value='����'
	ef.Range("H&j").value='����'
	ef.Range("I&j").value='���'
	ef.Range("J&j").value='����'
	SELECT tmpp
	GO top
	DO whil .not. EOF()
		i=i+1
		j=ALLTRIM(STR(i))	
		ef.ActiveSheet.ROWS(I).Font.Bold=.F.
		ef.Range(ef.Cells(I,1),ef.Cells(I,14)).Font.Size=8
		ef.Range(ef.Cells(I,1),ef.Cells(I+1,14)).HorizontalAlignment=3 &&ˮƽ(1-Ĭ�ϡ�2-����3-���С�4-���ҡ�5-��䡢6=���˶��롢7=���о��С�8=��ɢ����)

		ef.Range(ef.Cells(I,1),ef.Cells(I,14)).BorderS.LineStyle=13
		ef.Range(ef.Cells(I,1),ef.Cells(I,14)).BorderS.weight = 2  
		ef.Range("B&j").value=ALLTRIM(classid)
		ef.Range("C&j").value=ALLTRIM(code)
		ef.Range("D&j").value= ALLTRIM(MB002)
		ef.Range("E&j").value=ALLTRIM(MB003)
		ef.Range("F&j").value=MB004
		ef.Range("G&j").value=MB094
		ef.Range("H&j").value=MB053 
		ef.Range("I&j").value=CASH 
		skip
	ENDDO 
	ENDIF 
	Sqlexec(CON,"select filedata pic,filename,classid from billpic where interid=?mkeyid and classid>10 and classid<19 ORDER BY classid","temp")
	SELECT temp
	IF RECCOUNT()>=1
		i=i+1
		j=ALLTRIM(STR(i))	
	ENDIF	
	GO TOP
	DO whil .not. EOF()
		IF !ISNULL(pic)
			ef.Rows(I).RowHeight=88
*!*				ef.range("A&J:K&J").Select
*!*				ef.Selection.Merge
				ef.Range(ef.Cells(I,1),ef.Cells(I+1,11)).HorizontalAlignment=2 &&ˮƽ(1-Ĭ�ϡ�2-����3-���С�4-���ҡ�5-��䡢6=���˶��롢7=���о��С�8=��ɢ����)
				ef.Range(ef.Cells(I,1),ef.Cells(I+1,11)).VerticalAlignment=1 &&��ֱ(1=���ϡ�2=���С�3=���¡�4=���˶��롢5=��ɢ����)	

			DO CASE 
				J1=ALLTRIM(STR(classid))	

				CASE classid=11
					ef.range("B&J:C&J").Select
					ef.Selection.Merge
					mccc='�ʺ�'
					ef.Range("B&j").value=mccc		

					STRTOFILE(pic,OldPath+"\TMPLHB"+'&j1')
					_Screen.AddObject( 'pic1', 'Image' )
					_Screen.pic1.Picture=OldPath+"\TMPLHB"+'&j1'
					ef.Cells( I,2).Activate
					ef.ActiveSheet.PictureS.Insert(OldPath+"\TMPLHB"+'&j1').Select
					ef.Selection.ShapeRange.LockAspectRatio =.T.
					Target =ef.Cells( I,2)

				CASE classid=12

					mccc='����'
					ef.Range("D&j").value=mccc		

					STRTOFILE(pic,OldPath+"\TMPLHB"+'&j1')
					_Screen.AddObject( 'pic1', 'Image' )
					_Screen.pic1.Picture=OldPath+"\TMPLHB"+'&j1'
					ef.Cells( I,4).Activate
					ef.ActiveSheet.PictureS.Insert(OldPath+"\TMPLHB"+'&j1').Select
					ef.Selection.ShapeRange.LockAspectRatio =.T.
					Target =ef.Cells( I,4)
*˵���鲻��ӡ
				CASE classid=14
					mccc='��ǩ'
					ef.Range("E&j").value=mccc		

					STRTOFILE(pic,OldPath+"\TMPLHB"+'&j1')
					_Screen.AddObject( 'pic1', 'Image' )
					_Screen.pic1.Picture=OldPath+"\TMPLHB"+'&j1'
					ef.Cells( I,5).Activate
					ef.ActiveSheet.PictureS.Insert(OldPath+"\TMPLHB"+'&j1').Select
					ef.Selection.ShapeRange.LockAspectRatio =.T.
					Target =ef.Cells( I,5)
				CASE classid=15
					mccc='����'
					ef.range("F&J:G&J").Select
					ef.Selection.Merge
					ef.Range("F&j").value=mccc		

					STRTOFILE(pic,OldPath+"\TMPLHB"+'&j1')
					_Screen.AddObject( 'pic1', 'Image' )
					_Screen.pic1.Picture=OldPath+"\TMPLHB"+'&j1'
					ef.Cells( I,6).Activate
					ef.ActiveSheet.PictureS.Insert(OldPath+"\TMPLHB"+'&j1').Select
					ef.Selection.ShapeRange.LockAspectRatio =.T.
					Target =ef.Cells( I,6)


				CASE classid=16
					mccc='����'
					ef.range("H&J:I&J").Select
					ef.Selection.Merge
					ef.Range("H&j").value=mccc		

					STRTOFILE(pic,OldPath+"\TMPLHB"+'&j1')
					_Screen.AddObject( 'pic1', 'Image' )
					_Screen.pic1.Picture=OldPath+"\TMPLHB"+'&j1'
					ef.Cells( I,8).Activate
					ef.ActiveSheet.PictureS.Insert(OldPath+"\TMPLHB"+'&j1').Select
					ef.Selection.ShapeRange.LockAspectRatio =.T.
					Target =ef.Cells( I,8)
*!*					CASE classid=16
*!*						mccc='����'
*!*						ef.Range("J&j").value=mccc		

*!*						STRTOFILE(pic,OldPath+"\TMPLHB"+'&j1')
*!*						_Screen.AddObject( 'pic1', 'Image' )
*!*						_Screen.pic1.Picture=OldPath+"\TMPLHB"+'&j1'
*!*						ef.Cells( I,10).Activate
*!*						ef.ActiveSheet.PictureS.Insert(OldPath+"\TMPLHB"+'&j1').Select
*!*						ef.Selection.ShapeRange.LockAspectRatio =.T.
*!*						Target =ef.Cells( I,10)

			ENDCASE 
			ef.Selection.Top = Target.Top + 20
			ef.Selection.Left = Target.Left + 20
			ef.Selection.ShapeRange.Height =70
		ENDIF 
		TRY
			_Screen.RemoveObject( 'pic1' )
		CATCH TO oException2
			WAIT WINDOWS '' NOWAIT
		ENDTRY
		SELECT temp	
		SKIP 
	ENDDO 		
	ef.Range(ef.Cells(5,1),ef.Cells(I,1)).VerticalAlignment=2 &&��ֱ(1=���ϡ�2=���С�3=���¡�4=���˶��롢5=��ɢ����)	
	ef.range("A&HH1:A&J").Select
	ef.Selection.Merge
	hh1=ALLTRIM(STR(I+1))
	i=i+1
	SELECT tmppiInfoXX
	SKIP
ENDDO 
ef.Range(ef.Cells(4,1),ef.Cells(I+1,1)).BorderS.LineStyle=-4142
ef.Range(ef.Cells(4,1),ef.Cells(I+1,1)).BorderS.weight = -4138
X1X=ALLTRIM(STR(i))

i=i+1
j=ALLTRIM(STR(i))
SQLDISCONNECT(CON)

ef.Range("A&j").Font.Name="����"
ef.Range("A&j").Font.size=14
SELECT tmppiInfoXX
SUM QUAN,������ TO XX,YY
ef.Range("A&j").value='-----����['+ALLTRIM(STR(RECC()))+']����¼����Ʒ������'+ALLTRIM(STR(XX))+'����������'+ALLTRIM(STR(YY))
ef.range("A&X1X:J&J").Select
ef.Selection.Merge
ef.ActiveWorkbook.SaveAs(rqmd)
ef.ActiveWorkbook.Save
EF.ActiveWorkbook.CLOSE
ef.Quit
ON ERROR RETURN
=SYS(3101,65001)