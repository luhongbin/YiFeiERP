SELECT tmpBuyDetailsc
mkeyid=interid
WAIT WINDOWS '���ڶ�ȡPI��ӡ��Ϣ...' NOWAIT 
*!*	TRY 
*!*		Delete File "ѯ�۵�"
*!*		Delete File Sys(5) + Curdir() +ALLTRIM(UDF043)+ALLTRIM(STR(keyid))+"ѯ�۵�.xlsx"
*!*	CATCH 
*!*	FINALLY
*!*	ENDTRY 
ef=CREATEOBJECT('Excel.application')

&&����Excel����
ef.Workbooks.add
&&��ӹ�����
ef.Worksheets("sheet1").Activate
&&�����һ��������
ef.visible=.f.



IF File(Sys(5) + Curdir() +ALLTRIM(UDF043)+ ALLTRIM(STR(keyid))+"ѯ�۵�.xls")
	WAIT WINDOWS '�ļ��Ѵ���'
    lcFileName = ef.GetSaveAsFilename(Sys(5)  +Curdir() +ALLTRIM(UDF043)+ ALLTRIM(STR(keyid))+"ѯ�۵�", "Excel (*.xlsx), *.xlsx")
    If !Empty(lcFileName)
        If File(lcFileName)
            Delete File (lcFileName)
        Endif
        ef.ActiveWorkbook.SaveAs(lcFileName)
    ENDIF
    RETURN 
ELSE 
    ef.ActiveWorkbook.SaveAs(Sys(5) + Curdir() +ALLTRIM(UDF043)+ALLTRIM(STR(keyid))+"ѯ�۵�.xlsx")
Endif
ef.ActiveSheet.PageSetup.Papersize=9


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
ef.Rows(1).RowHeight=1/0.0035/5
ef.ActiveSheet.Cells(3,1).Font.Name="����"
ef.ActiveSheet.Cells(1,1).Font.Name="����"
ef.ActiveSheet.Cells(2,1).Font.Name="����"
ef.ActiveSheet.Cells(1,1).Font.Size=25
ef.ActiveSheet.Cells(2,1).Font.Size=12
ef.ActiveSheet.Cells(3,1).Font.Size=12
ef.Caption="����ҫ̩�������޹�˾�⹺����"

ef.Range("A1:G1").Select
ef.Selection.Merge
ef.Range("A1").value='����ҫ̩�������޹�˾�⹺����'
ef.range("A1").HorizontalAlignment=2
ef.range("A2").HorizontalAlignment=2
ef.range("A3").HorizontalAlignment=2

ef.Range("A2:K2").Select
ef.Selection.Merge
ef.Range("A3:K3").Select
ef.Selection.Merge
CON=ODBC(5)
Sqlexec(CON,"select discharge  from pi where interid=?keyid")
SQLDISCONNECT(con)

=SYS(3101,65001)
IF LEN(ALLTRIM(STRCONV(discharge,14)))>2
xxxx='ж���ۣ�'+ALLTRIM(STRCONV(discharge,14))
ELSE 
xxxx='ж����ûָ��'
ENDIF 
=SYS(3101,936)
*erpbill=ALLTRIM(tmpBuyDetailscsc .TD001)+'-'+ALLTRIM(tmpBuyDetailscsc .TD002)
SELECT tmpBuyDetailscsc
ERPMD=ALLTRIM(UDF04)
ef.Range("A3").value=xxxx+'��'+p_ass
CURSORSETPROP("MapBinary",.T.,0)&&�ǳ��ؼ�

CON=ODBC(5)

Sqlexec(CON,"select filedata ,filename,classid from billpic where interid=?keyid and classid<=2 and filedata is not null ORDER BY classid","temp")
SELECT temp
TRY
	_Screen.RemoveObject( 'pic1' )
CATCH && TO oException2
	WAIT WINDOWS '' NOWAIT
ENDTRY
IF RECCOUNT()>=1
	GO top
		ef.Rows(2).RowHeight=1/0.0035/5
		GO 1
		ef.Range("A1:H1").Select
		ef.Selection.Merge
		ef.ActiveSheet.Cells(1,10).Font.Size=12
		ef.Range("I1").value='��ͷ:'
		IF LEN(ALLTRIM(filename))<5
			ttt=UPPER(filename)
		ELSE 	
			TTT =UPPER( substr(filename,rat(".",filename)+1)  )
		ENDIF	
		IF TTT='JPG' OR TTT='BMP' OR TTT='PNG' OR TTT='GIF' OR TTT='JPEG' OR TTT='TIF' OR TTT='TIFF'  OR TTT='JIFF'  OR TTT='RAW'
			SELECT temp

			TRY
				STRTOFILE(filedata ,OldPath+"\TMPLH2W11")
				_Screen.AddObject( 'pic1', 'Image' )
				*_Screen.pic1.Picture=OldPath+"\TMPLH2W11"
				ef.Cells( 1,10).Activate
				Target =ef.Cells( 1,10)
				*ef.ActiveSheet.PictureS.Insert(OldPath+"\TMPLH2W1"+'1').Select
				ef.ActiveSheet.Shapes.AddPicture(OldPath+"\TMPLH2W11",.f., .T., 0, 0, -1, -1).Select
				ef.Selection.ShapeRange.LockAspectRatio =.T.
				Target =ef.Cells( 1,10)
				ef.Selection.Top = Target.Top + 2
				ef.Selection.Left = Target.Left + 2
				ef.Selection.ShapeRange.Height =110
				TRY
					_Screen.RemoveObject( 'pic1' )
				CATCH TO oException2
					WAIT WINDOWS '' NOWAIT
				ENDTRY
			CATCH TO oException2
				WAIT WINDOWS '' NOWAIT
			ENDTRY
		ENDIF	
	IF RECCOUNT()=2
		GO 2
		IF LEN(ALLTRIM(filename))<5
			ttt=UPPER(filename)
		ELSE 	
			TTT =UPPER( substr(filename,rat(".",filename)+1)  )
		ENDIF	
		IF TTT='JPG' OR TTT='BMP' OR TTT='PNG' OR TTT='GIF' OR TTT='JPEG' OR TTT='TIF' OR TTT='TIFF'  OR TTT='JIFF'  OR TTT='RAW'
			TRY
			STRTOFILE(filedata ,OldPath+"\TMPLH2W2"+'2')
			_Screen.AddObject( 'pic1', 'Image' )
			*_Screen.pic1.Picture=OldPath+"\TMPLH2W2"+'2'
			ef.Cells( 1,10).Activate
			*ef.ActiveSheet.PictureS.Insert(OldPath+"\TMPLH2W2"+'2').Select
			ef.ActiveSheet.Shapes.AddPicture(OldPath+"\TMPLH2W22",.f., .T., 0, 0, -1, -1).Select

			ef.Selection.ShapeRange.LockAspectRatio =.T.
			Target =ef.Cells( 1,10)
				ef.Selection.Top = Target.Top + 2
				ef.Selection.Left = Target.Left + 2
			CATCH TO oException2
				WAIT WINDOWS '' NOWAIT
			ENDTRY

		ENDIF	
	
	ENDIF
		TRY
			_Screen.RemoveObject( 'pic1' )
		CATCH TO oException2
			WAIT WINDOWS '' NOWAIT
		ENDTRY
ELSE	
	*XXXX=XXXX+'������ͷ'
ENDIF	
ef.Range("A2").value=TXTKEY

ef.Range(ef.Cells(4,1),ef.Cells(4,14)).BorderS.LineStyle=-4142
ef.Range(ef.Cells(4,1),ef.Cells(4,14)).BorderS.weight = -4138
ef.Range(ef.Cells(4,1),ef.Cells(4,14)).HorizontalAlignment=3 &&ˮƽ(1-Ĭ�ϡ�2-����3-���С�4-���ҡ�5-��䡢6=���˶��롢7=���о��С�8=��ɢ����)
ef.Range("A4:L14").select 
ef.selection.WrapText = .T. 

ef.Range(ef.Cells(4,1),ef.Cells(4,14)).Font.Size=9
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
ef.Range("J4").value='��ע'
ef.Range("K4").value="˵����Ʒ��"
ef.Range("L4").value="����˵��"
ef.Range("M4").value="����"
ef.Range("N4").value="���"

ef.ActiveSheet.Columns(1).ColumnWidth =13
ef.ActiveSheet.Columns(2).ColumnWidth =8
ef.ActiveSheet.Columns(3).ColumnWidth =8
ef.ActiveSheet.Columns(4).ColumnWidth =10
ef.ActiveSheet.Columns(5).ColumnWidth =10
ef.ActiveSheet.Columns(6).ColumnWidth =7
ef.ActiveSheet.Columns(7).ColumnWidth =8
ef.ActiveSheet.Columns(8).ColumnWidth =6
ef.ActiveSheet.Columns(9).ColumnWidth =8
ef.ActiveSheet.Columns(10).ColumnWidth =15
ef.ActiveSheet.Columns(11).ColumnWidth =10
ef.ActiveSheet.Columns(12).ColumnWidth =5
ef.ActiveSheet.Columns(13).ColumnWidth =6
ef.ActiveSheet.Columns(14).ColumnWidth =8
SELECT tmpBuyDetailscsc 
hh1='5'
i=5
go top
DO WHILE .not. EOF()
	mkeyid=interid
	j=ALLTRIM(STR(i))
	ef.Range(ef.Cells(I,1),ef.Cells(I,14)).BorderS.LineStyle=-4142
	ef.Range(ef.Cells(I,1),ef.Cells(I,14)).BorderS.weight = -4138
	ef.ActiveSheet.ROWS(I).Font.Bold=.T.
	*ef.Range(ef.Cells(I,1),ef.Cells(I,11)).Font.Bold = True
	ef.Range(ef.Cells(I,1),ef.Cells(I+1,14)).HorizontalAlignment=3 &&ˮƽ(1-Ĭ�ϡ�2-����3-���С�4-���ҡ�5-��䡢6=���˶��롢7=���о��С�8=��ɢ����)
	ef.Range(ef.Cells(I,1),ef.Cells(I+1,14)).VerticalAlignment=2 &&��ֱ(1=���ϡ�2=���С�3=���¡�4=���˶��롢5=��ɢ����)	
	ef.Range(ef.Cells(I,1),ef.Cells(I+1,14)).Font.Size=10
	ef.Range("A&j").value=ALLTRIM(CODE)+CHR(13)+CHR(10)+COPTD
	ef.Range("B&j").value=ALLTRIM(��˾����)
	ef.Range("C&j").Select
	ef.Selection.NumberFormatLocal = "@"	
	ef.Range("C&j").value=ALLTRIM(customcode)
	ef.Range("D&j").Select
	ef.selection.WrapText = .T. 
	ef.Range("D&j").value= ALLTRIM(name)
	
	ef.Range("E&j").value=ALLTRIM(spec)
	ef.Range("F&j").value=quan
	dlsl=quan
	ef.Range("G&j").value=ALLTRIM(TD013)
	ef.Range("H&j").value=ALLTRIM(STR(TD201,5))
	ef.Range("I&j").Select
	ef.Selection.NumberFormatLocal = "@" 	
	ef.Range("I&j").value=ALLTRIM(STR(TD202,5))+'-'+ALLTRIM(STR(TD203,5))
	gd=''
	IF UDF54=1
		gd='[�е���������]'
	ENDIF
	IF chksms=1
		gd=gd+',˵�������'
	ENDIF 
	IF boxok=1
		gd=gd+',��װ����'
	ENDIF 
	ef.Range("J&J").WrapText=.T.	
	ef.Range("J&j").value=ALLTRIM(TD020)+gd
	ef.Range("K&j").value=ALLTRIM(smscode)
	*ef.Range("L&j").value=ALLTRIM(doc)
	ef.ActiveSheet.Range("M&j:N&j").NumberFormatLocal =  "0.00"

	ef.Range("M&j").value=ALLTRIM(STR(PRICE))
	ef.Range("N&j").value=ALLTRIM(STR(PRICE*QUAN))
	CCCCC=quan
	IF SQLEXEC(CON,"SELECT classid,packagecode,B1.MB002,B1.MB003,long MB093,width MB094, deep MB095,quan,long*width*deep/1000000 vol,weight,des,barcode "+;
		"FROM packageinfo LEFT join INVMB B1 ON packagecode=B1.MB001 where billid=2 and interid=?mkeyid ORDER BY 1,2","TmpP")<0
		WAIT WINDOWS '??xxx?'
		RETURN
	ENDIF
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
		ef.Range(ef.Cells(I,1),ef.Cells(I,14)).Font.Size=8
		ef.Range(ef.Cells(I,1),ef.Cells(I+1,14)).HorizontalAlignment=3 &&ˮƽ(1-Ĭ�ϡ�2-����3-���С�4-���ҡ�5-��䡢6=���˶��롢7=���о��С�8=��ɢ����)

		ef.Range(ef.Cells(I,1),ef.Cells(I,14)).BorderS.LineStyle=13
		ef.Range(ef.Cells(I,1),ef.Cells(I,14)).BorderS.weight = 2  
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
		ef.Range("K&j").value="'"+ALLTRIM(barcode)
		skip
	ENDDO 

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
*!*			ef.Range(ef.Cells(I,1),ef.Cells(I+1,14)).BorderS.LineStyle=13
*!*			ef.Range(ef.Cells(I,1),ef.Cells(I+1,14)).BorderS.weight = 2  
		IF !ISNULL(pic)
			ef.Rows(I).RowHeight=88
*!*				ef.range("A&J:K&J").Select
*!*				ef.Selection.Merge
				ef.Range(ef.Cells(I,1),ef.Cells(I+1,14)).HorizontalAlignment=2 &&ˮƽ(1-Ĭ�ϡ�2-����3-���С�4-���ҡ�5-��䡢6=���˶��롢7=���о��С�8=��ɢ����)
				ef.Range(ef.Cells(I,1),ef.Cells(I+1,14)).VerticalAlignment=1 &&��ֱ(1=���ϡ�2=���С�3=���¡�4=���˶��롢5=��ɢ����)	

			DO CASE 
				J1=ALLTRIM(STR(classid))	

				CASE classid=11
					ef.range("B&J:D&J").Select
					ef.Selection.Merge
					mccc='�ʺ�'
					ef.Range("B&j").value=mccc		
					IF LEN(ALLTRIM(filename))<5
						ttt=UPPER(filename)
					ELSE 	
						TTT =UPPER( substr(filename,rat(".",filename)+1)  )
					ENDIF	
					IF TTT='JPG' OR TTT='BMP' OR TTT='PNG' OR TTT='GIF' OR TTT='JPEG' OR TTT='TIF' OR TTT='TIFF'  OR TTT='JIFF'  OR TTT='RAW'

					STRTOFILE(pic,OldPath+"\TMPLHB"+'&j1')
					_Screen.AddObject( 'pic1', 'Image' )
					_Screen.pic1.Picture=OldPath+"\TMPLHB"+'&j1'
					ef.Cells( I,2).Activate

					*ef.ActiveSheet.PictureS.Insert(OldPath+"\TMPLHB"+'&j1').Select
					ef.ActiveSheet.Shapes.AddPicture(OldPath+"\TMPLHB"+'&j1',.f., .T., 0, 0, -1, -1).Select

					ef.Selection.ShapeRange.LockAspectRatio =.T.
					Target =ef.Cells( I,2)
					ENDIF 
				CASE classid=12

					mccc='����'
					ef.Range("E&j").value=mccc		
					IF LEN(ALLTRIM(filename))<5
						ttt=UPPER(filename)
					ELSE 	
						TTT =UPPER( substr(filename,rat(".",filename)+1)  )
					ENDIF	
					IF TTT='JPG' OR TTT='BMP' OR TTT='PNG' OR TTT='GIF' OR TTT='JPEG' OR TTT='TIF' OR TTT='TIFF'  OR TTT='JIFF'  OR TTT='RAW'

					STRTOFILE(pic,OldPath+"\TMPLHB"+'&j1')
					_Screen.AddObject( 'pic1', 'Image' )
					*_Screen.pic1.Picture=OldPath+"\TMPLHB"+'&j1'
					ef.Cells( I,5).Activate
					*ef.ActiveSheet.PictureS.Insert(OldPath+"\TMPLHB"+'&j1').Select
					ef.ActiveSheet.Shapes.AddPicture(OldPath+"\TMPLHB"+'&j1',.f., .T., 0, 0, -1, -1).Select

					ef.Selection.ShapeRange.LockAspectRatio =.T.
					Target =ef.Cells( I,5)
					ENDIF 
*˵���鲻��ӡ
				CASE classid=14
					mccc='��ǩ'
					ef.Range("H&j").value=mccc		
					IF LEN(ALLTRIM(filename))<5
						ttt=UPPER(filename)
					ELSE 	
						TTT =UPPER( substr(filename,rat(".",filename)+1)  )
					ENDIF	
					IF TTT='JPG' OR TTT='BMP' OR TTT='PNG' OR TTT='GIF' OR TTT='JPEG' OR TTT='TIF' OR TTT='TIFF'  OR TTT='JIFF'  OR TTT='RAW'

					STRTOFILE(pic,OldPath+"\TMPLHB"+'&j1')
					_Screen.AddObject( 'pic1', 'Image' )
					*_Screen.pic1.Picture=OldPath+"\TMPLHB"+'&j1'
					ef.Cells( I,8).Activate
					*ef.ActiveSheet.PictureS.Insert(OldPath+"\TMPLHB"+'&j1').Select
					ef.ActiveSheet.Shapes.AddPicture(OldPath+"\TMPLHB"+'&j1',.f., .T., 0, 0, -1, -1).Select

					ef.Selection.ShapeRange.LockAspectRatio =.T.
					Target =ef.Cells( I,8)
					ENDIF 
				CASE classid=15
					mccc='����'
					ef.range("K&J:M&J").Select
					ef.Selection.Merge
					ef.Range("K&j").value=mccc		
					IF LEN(ALLTRIM(filename))<5
						ttt=UPPER(filename)
					ELSE 	
						TTT =UPPER( substr(filename,rat(".",filename)+1)  )
					ENDIF	
					IF TTT='JPG' OR TTT='BMP' OR TTT='PNG' OR TTT='GIF' OR TTT='JPEG' OR TTT='TIF' OR TTT='TIFF'  OR TTT='JIFF'  OR TTT='RAW'

					STRTOFILE(pic,OldPath+"\TMPLHB"+'&j1')
					_Screen.AddObject( 'pic1', 'Image' )
					*_Screen.pic1.Picture=OldPath+"\TMPLHB"+'&j1'
					ef.Cells( I,11).Activate
					*ef.ActiveSheet.PictureS.Insert(OldPath+"\TMPLHB"+'&j1').Select
					ef.ActiveSheet.Shapes.AddPicture(OldPath+"\TMPLHB"+'&j1',.f., .T., 0, 0, -1, -1).Select

					ef.Selection.ShapeRange.LockAspectRatio =.T.
					Target =ef.Cells( I,11)

					ENDIF 
				CASE classid=16
					mccc='����'
					ef.range("N&J:N&J").Select
					ef.Selection.Merge
					ef.Range("N&j").value=mccc		
					IF LEN(ALLTRIM(filename))<5
						ttt=UPPER(filename)
					ELSE 	
						TTT =UPPER( substr(filename,rat(".",filename)+1)  )
					ENDIF	
					IF TTT='JPG' OR TTT='BMP' OR TTT='PNG' OR TTT='GIF' OR TTT='JPEG' OR TTT='TIF' OR TTT='TIFF'  OR TTT='JIFF'  OR TTT='RAW'

					STRTOFILE(pic,OldPath+"\TMPLHB"+'&j1')
					_Screen.AddObject( 'pic1', 'Image' )
					_Screen.pic1.Picture=OldPath+"\TMPLHB"+'&j1'
					ef.Cells( I,14).Activate
					*ef.ActiveSheet.PictureS.Insert(OldPath+"\TMPLHB"+'&j1').Select
					ef.ActiveSheet.Shapes.AddPicture(OldPath+"\TMPLHB"+'&j1',.f., .T., 0, 0, -1, -1).Select
					ef.Selection.ShapeRange.LockAspectRatio =.T.
					Target =ef.Cells( I,14)
					ENDIF 
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
*!*				ef.Selection.Left = Target.Left + 20
			ef.Selection.ShapeRange.Height =110
			ef.Rows(i).RowHeight=1/0.0035/2


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

	
	SELECT tmpBuyDetailscsc 
	SKIP
ENDDO 
SQLDISCONNECT(con)
*!*	ef.ActiveSheet.Range("a4:a&i").Borders(1).LineStyle=1
*!*	ef.ActiveSheet.Range("a4:a&i").Borders(2).LineStyle=1
*!*	ef.ActiveSheet.Range("a4:a&i").Borders(1).Weight=3
*!*	ef.ActiveSheet.Range("a4:a&i").Borders(2).Weight=3

ef.Range(ef.Cells(4,1),ef.Cells(I,1)).BorderS.LineStyle=-4142
ef.Range(ef.Cells(4,14),ef.Cells(I,14)).BorderS.LineStyle=-4142
ef.Range(ef.Cells(4,1),ef.Cells(I,1)).BorderS.weight = -4138
ef.Range(ef.Cells(4,14),ef.Cells(I,14)).BorderS.weight = -4138

ef.Range(ef.Cells(i,1),ef.Cells(I,14)).BorderS.LineStyle=-4142
ef.Range(ef.Cells(i,1),ef.Cells(I,14)).BorderS.weight = -4138
X1X=ALLTRIM(STR(i))

i=i
j=ALLTRIM(STR(i))


*!*	ef.Range("A&j").RowHeight=1/0.0035/4
ef.Range("A&j").Font.Name="����"
ef.Range("A&j").Font.size=10
ef.Rows(i).RowHeight=1/0.0035/11
SELECT tmpBuyDetailscsc 
SUM QUAN,TD201,quan*price TO XX,YY,zz
ef.Range("A&j").value='-----����['+ALLTRIM(STR(RECC()))+']����¼����Ʒ������'+ALLTRIM(STR(XX))+'����������'+ALLTRIM(STR(YY))+'���ܼۣ�'+ALLTRIM(STR(zz))+'   ��ע:'+keytxt
ef.range("A&X1X:N&J").Select
ef.Selection.Merge

*!*	i=i+1
*!*	j=ALLTRIM(STR(i))
*!*	I=RECCOUNT()+4
*!*	ef.Range(ef.Cells(3,1),ef.Cells(I,54)).BorderS.LineStyle=1
*!*	ef.Range(ef.Cells(3,1),ef.Cells(I,54)).HorizontalAlignment=3 &&ˮƽ(1-Ĭ�ϡ�2-����3-���С�4-���ҡ�5-��䡢6=���˶��롢7=���о��С�8=��ɢ����)
*!*	ef.Range(ef.Cells(3,1),ef.Cells(I,54)).VerticalAlignment=2 &&��ֱ(1=���ϡ�2=���С�3=���¡�4=���˶��롢5=��ɢ����)
*!*	ef.Range(ef.Cells(5,1),ef.Cells(I,54)).HorizontalAlignment=2 &&ˮƽ(1-Ĭ�ϡ�2-����3-���С�4-���ҡ�5-��䡢6=���˶��롢7=���о��С�8=��ɢ����)
*ef.ActiveSheet.PageSetup.RightHeader="��ϵ��:��Ҧ��,��ϵ�绰:62760949-202(13065854221),����:0574-62760270,Email:mybb@yaohualux.com"
ef.ActiveSheet.PageSetup.RightFooter="��ϵ��:��Ҧ��,��ϵ�绰:62760547-8403(13065854221),����:0574-62760270,Email:mybb@yaohualux.com"
ef.ActiveSheet.PageSetup.RightHeader="�� &P ҳ/ �� &N ҳ"
ef.ActiveSheet.PageSetup.LeftHeader="��ӡʱ�䣺&D - &T"
ef.ActiveSheet.PageSetup.Papersize=9
ef.ActiveSheet.PageSetup.Orientation=2
ef.ActiveWorkbook.Save
ef.visible=.t.
*!*	ef.close

*ef.ActiveSheet.PrintPreview
*ef.Range("A&j").value='Expiry Date'
*!*	ef.Workbooks.Close
*!*	RELEASE ef
*!*	ef.Quit()
ef= .NULL.
SELECT temp
use

TRY 
		RELEASE TMPLH2W11
		
		ERASE OldPath+"\TMPLH2W11.*"
		ERASE OldPath+"\TMPLH2W22.*"
CATCH 
	MESSAGEBOX("����")
ENDTRY 		
WAIT windows '��ȡ���' NOWAIT 

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

