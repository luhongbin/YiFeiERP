
SELECT tmppiInfoDetailsc 
mkeyid=interid
WAIT WINDOWS '���ڶ�ȡPI��ӡ��Ϣ...' NOWAIT 
Delete File Sys(5) + Curdir()+"PI"+ALLTRIM(STR(KEYID))+"���Ŷ���.xls"


ef=CREATEOBJECT('Excel.application')

&&����Excel����
ef.Workbooks.add
&&��ӹ�����
ef.Worksheets("sheet1").Activate
&&�����һ��������
ef.visible=.t.

Delete File Sys(5) + Curdir() +"PI"+ALLTRIM(STR(KEYID))+"���Ŷ���.xls"

If !File(Sys(5) + Curdir() +"PI"+ALLTRIM(STR(KEYID))+"���Ŷ���.xls")
    ef.ActiveWorkbook.SaveAs(Sys(5) + Curdir() +"PI"+ALLTRIM(STR(KEYID))+"���Ŷ���.xls")
ELSE
	WAIT WINDOWS '�����Ѿ��򿪣��رպ����·��Ŷ���'
	RETURN
    lcFileName = ef.GetSaveAsFilename(Sys(5) + Curdir() +"PI"+ALLTRIM(STR(KEYID))+"���Ŷ���", "Excel (*.xls), *.xls")
    If !Empty(lcFileName)
        If File(lcFileName)
            Delete File (lcFileName)
        Endif
        ef.ActiveWorkbook.SaveAs(lcFileName)
    Endif
Endif


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
Sqlexec(CON,"select discharge  from pi where interid=?keyid")
SQLDISCONNECT(con)

*=SYS(3101,65001)
IF LEN(ALLTRIM(STRCONV(discharge,14)))>2
xxxx='ж���ۣ�'+ALLTRIM(STRCONV(discharge,14))
ELSE 
xxxx='ж����ûָ��'
ENDIF 
SELECT tmppiInfoDetailsc 
erpbill=ALLTRIM(tmppiInfoDetailsc .coptd)&&TD001)+'-'+ALLTRIM(tmppiInfoDetailsc .TD002)+'  ERP����:'+ERPBILL
ERPMD=ALLTRIM(tmppiInfoDetailsc .UDF04)
ef.Range("A2").value='PI:'+ALLTRIM(STR(TmpTrack.PI����))+'   ҵ��Ա:'+ALLTRIM(TmpTrack.ҵ��Ա)+'('+ALLTRIM(TmpTrack.�Ƶ���)+') ����ʱ��:'+TTOC(TmpTrack.CHKDATE)
XXXX=XXXX+'����Ʒ��׼:'+ALLTRIM(TmpTrack.standard)
IF TmpTrack.rose=1
	XXXX=xxxx+'��Ҫ�����ROHS��׼'
ENDIF	
IF TmpTrack.boxnum=1
	XXXX=XXXX+'����Ҫ���'
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
		TRY
			_Screen.RemoveObject( 'pic1' )
		CATCH TO oException2
			WAIT WINDOWS '' NOWAIT
		ENDTRY
	IF RECCOUNT()=2
		GO 2

		STRTOFILE(pic,OldPath+"\TMPLH2W2"+'2')
		_Screen.AddObject( 'pic1', 'Image' )
		_Screen.pic1.Picture=OldPath+"\TMPLH2W2"+'2'
		ef.Cells( 1,10).Activate
		ef.ActiveSheet.PictureS.Insert(OldPath+"\TMPLH2W2"+'2').Select
		ef.Selection.ShapeRange.LockAspectRatio =.T.
		Target =ef.Cells( 1,10)
		ef.Selection.Top = Target.Top + 2
		ef.Selection.Left = Target.Left + 2
	ENDIF
		TRY
			_Screen.RemoveObject( 'pic1' )
		CATCH TO oException2
			WAIT WINDOWS '' NOWAIT
		ENDTRY
ELSE	
	XXXX=XXXX+'������ͷ'
ENDIF	
IF ALLTRIM(TmpTrack.po)<>''
	ef.Range("A3").value='�ͻ�������:'+ALLTRIM(TmpTrack.po)+' '+XXXX  &&'�����첿��:'+ERPMD+
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
SELECT tmppiInfoDetailsc 
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
	IF SQLEXEC(CON,"SELECT classid,packagecode,B1.MB002,B1.MB003,long MB093,width MB094, deep MB095,quan,long*width*deep/1000000 vol,weight,des,barcode,boxfrom,boxto "+;
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
	ef.Range("F&j").value='ÿ������(���)'
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
		ef.Range("F&j").value=ALLTRIM(STR(quan))+'('+ALLTRIM(STR(boxfrom))+'-'+ALLTRIM(STR(boxto))+')'
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
	SELECT tmppiInfoDetailsc 
	SKIP
ENDDO 
ef.Range(ef.Cells(4,1),ef.Cells(I+1,1)).BorderS.LineStyle=-4142
ef.Range(ef.Cells(4,1),ef.Cells(I+1,1)).BorderS.weight = -4138
X1X=ALLTRIM(STR(i))

i=i+1
j=ALLTRIM(STR(i))


*!*	ef.Range("A&j").RowHeight=1/0.0035/4
ef.Range("A&j").Font.Name="����"
ef.Range("A&j").Font.size=14
SELECT tmppiInfoDetailsc 
SUM QUAN,������ TO XX,YY
ef.Range("A&j").value='-----����['+ALLTRIM(STR(RECC()))+']����¼����Ʒ������'+ALLTRIM(STR(XX))+'����������'+ALLTRIM(STR(YY))
ef.range("A&X1X:J&J").Select
ef.Selection.Merge

*!*	i=i+1
*!*	j=ALLTRIM(STR(i))
*!*	I=RECCOUNT()+4
*!*	ef.Range(ef.Cells(3,1),ef.Cells(I,54)).BorderS.LineStyle=1
*!*	ef.Range(ef.Cells(3,1),ef.Cells(I,54)).HorizontalAlignment=3 &&ˮƽ(1-Ĭ�ϡ�2-����3-���С�4-���ҡ�5-��䡢6=���˶��롢7=���о��С�8=��ɢ����)
*!*	ef.Range(ef.Cells(3,1),ef.Cells(I,54)).VerticalAlignment=2 &&��ֱ(1=���ϡ�2=���С�3=���¡�4=���˶��롢5=��ɢ����)
*!*	ef.Range(ef.Cells(5,1),ef.Cells(I,54)).HorizontalAlignment=2 &&ˮƽ(1-Ĭ�ϡ�2-����3-���С�4-���ҡ�5-��䡢6=���˶��롢7=���о��С�8=��ɢ����)
WAIT windows '��ȡ���' NOWAIT 


*ef.Range("A&j").value='Expiry Date'

*SQLEXEC(CON,"SELECT pi.*,pidetail.*, zm.filedata zm,cm.filedata cm,bt.filedata bt, qt.filedata qt,sj.filedata.sj "+;
  " from pi inner join pidetail on pi.interid=pidetail.maininterid left join billpic zm on pi.interid=zm.interid and classid=1 "+;
  "left join billpic bt on pi.interid=bt.interid and classid=3 left join billpic qt on pi.interid=qt.interid and classid=4 "+;
  " left join billpic sj on pi.interid=sj.interid and classid=5  left join billpic cm on pi.interid=cm.interid and classid=2 "+;
  "where pi.interid=?keyid","t1")
*!*	codeid=2011100000
*!*	PUBLIC goPic AS Image
*!*	m.goPic = NEWOBJECT( 'Image' )
*!*	SET REPORTBEHAVIOR 80
*!*	SELECT t1
*!*	*!*	REPORT FORM d:\trade\pi�� PREVIEW
*!*	*!*	codeid=2011080001
*!*	*!*	P_ReportFile='���Ŀͻ����۵�'
*!*	*!*	P_ReportName=P_CAPTION+P_ReportFile
*!*	DO &P_Others.OrderInfoPrint.Mpr

*!*	FUNCTION _GetPic
*!*	  IF empty(pic) OR  isnull(pic)
*!*		  m.goPic.pictureval = ''
*!*	  ELSE
*!*		  m.goPic.pictureval = t1.pic
*!*	  ENDIF 	  
*!*	  RETURN .T.
*!*	ENDFUNC

