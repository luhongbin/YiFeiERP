SELECT tmpBuyDetailsc
mkeyid=interid
WAIT WINDOWS '正在读取PI打印信息...' NOWAIT 
*!*	TRY 
*!*		Delete File "询价单"
*!*		Delete File Sys(5) + Curdir() +ALLTRIM(UDF043)+ALLTRIM(STR(keyid))+"询价单.xlsx"
*!*	CATCH 
*!*	FINALLY
*!*	ENDTRY 
ef=CREATEOBJECT('Excel.application')

&&调用Excel程序
ef.Workbooks.add
&&添加工作簿
ef.Worksheets("sheet1").Activate
&&激活第一个工作表
ef.visible=.f.



IF File(Sys(5) + Curdir() +ALLTRIM(UDF043)+ ALLTRIM(STR(keyid))+"询价单.xls")
	WAIT WINDOWS '文件已存在'
    lcFileName = ef.GetSaveAsFilename(Sys(5)  +Curdir() +ALLTRIM(UDF043)+ ALLTRIM(STR(keyid))+"询价单", "Excel (*.xlsx), *.xlsx")
    If !Empty(lcFileName)
        If File(lcFileName)
            Delete File (lcFileName)
        Endif
        ef.ActiveWorkbook.SaveAs(lcFileName)
    ENDIF
    RETURN 
ELSE 
    ef.ActiveWorkbook.SaveAs(Sys(5) + Curdir() +ALLTRIM(UDF043)+ALLTRIM(STR(keyid))+"询价单.xlsx")
Endif
ef.ActiveSheet.PageSetup.Papersize=9


&&显示Excel界面
*!*	ef.Cells.Select
&&选择整张表
ef.Selection.Font.Size = 10
&&设置整表默认字体大小为10
*!*	ef.range("A1:K1").Select
&&选择标题栏所在单元格
ef.Selection.Merge
&&合并单元格
*!*	with ef.range("A1")
*etContinuous  连续线   1
*!*	etDash  划线   -4115
*!*	etDashDot  点划线   4
*!*	etDashDotDot  双点的划线   5
*!*	etDot  点线  -4118
*!*	etDouble  双划线  -4119
*!*	etSlantDashDot  倾斜点划线   -4142
*!*	etLineStyleNone  无   13 
ef.range("A1").HorizontalAlignment=2
ef.Rows(1).RowHeight=1/0.0035/5
ef.ActiveSheet.Cells(3,1).Font.Name="黑体"
ef.ActiveSheet.Cells(1,1).Font.Name="黑体"
ef.ActiveSheet.Cells(2,1).Font.Name="黑体"
ef.ActiveSheet.Cells(1,1).Font.Size=25
ef.ActiveSheet.Cells(2,1).Font.Size=12
ef.ActiveSheet.Cells(3,1).Font.Size=12
ef.Caption="宁波耀泰电器有限公司外购订单"

ef.Range("A1:G1").Select
ef.Selection.Merge
ef.Range("A1").value='宁波耀泰电器有限公司外购订单'
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
xxxx='卸货港：'+ALLTRIM(STRCONV(discharge,14))
ELSE 
xxxx='卸货港没指定'
ENDIF 
=SYS(3101,936)
*erpbill=ALLTRIM(tmpBuyDetailscsc .TD001)+'-'+ALLTRIM(tmpBuyDetailscsc .TD002)
SELECT tmpBuyDetailscsc
ERPMD=ALLTRIM(UDF04)
ef.Range("A3").value=xxxx+'，'+p_ass
CURSORSETPROP("MapBinary",.T.,0)&&非常关键

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
		ef.Range("I1").value='唛头:'
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
	*XXXX=XXXX+'，无唛头'
ENDIF	
ef.Range("A2").value=TXTKEY

ef.Range(ef.Cells(4,1),ef.Cells(4,14)).BorderS.LineStyle=-4142
ef.Range(ef.Cells(4,1),ef.Cells(4,14)).BorderS.weight = -4138
ef.Range(ef.Cells(4,1),ef.Cells(4,14)).HorizontalAlignment=3 &&水平(1-默认、2-靠左、3-居中、4-靠右、5-填充、6=两端对齐、7=跨列居中、8=分散对齐)
ef.Range("A4:L14").select 
ef.selection.WrapText = .T. 

ef.Range(ef.Cells(4,1),ef.Cells(4,14)).Font.Size=9
ef.ActiveSheet.ROWS(4).Font.Bold=.T.
ef.Range("A4").value='ERP品号'
ef.Range("B4").value='公司货号'
ef.Range("C4").value='客户品号'
ef.Range("D4").value='产品名称'
ef.Range("E4").value='产品颜色'
ef.Range("F4").value='订单数量'
ef.Range("G4").value='交货日期'
ef.Range("H4").value='箱数'
ef.Range("I4").value='箱号'
ef.Range("J4").value='备注'
ef.Range("K4").value="说明书品号"
ef.Range("L4").value="工艺说明"
ef.Range("M4").value="单价"
ef.Range("N4").value="金额"

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
	ef.Range(ef.Cells(I,1),ef.Cells(I+1,14)).HorizontalAlignment=3 &&水平(1-默认、2-靠左、3-居中、4-靠右、5-填充、6=两端对齐、7=跨列居中、8=分散对齐)
	ef.Range(ef.Cells(I,1),ef.Cells(I+1,14)).VerticalAlignment=2 &&垂直(1=靠上、2=居中、3=靠下、4=两端对齐、5=分散对齐)	
	ef.Range(ef.Cells(I,1),ef.Cells(I+1,14)).Font.Size=10
	ef.Range("A&j").value=ALLTRIM(CODE)+CHR(13)+CHR(10)+COPTD
	ef.Range("B&j").value=ALLTRIM(公司货号)
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
		gd='[有调拨见附件]'
	ENDIF
	IF chksms=1
		gd=gd+',说明书待定'
	ENDIF 
	IF boxok=1
		gd=gd+',包装待定'
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

	ef.Range("B&j").value='包装类别'
	ef.Range("C&j").value='品号'
	ef.Range("D&j").value='品名'
	ef.Range("E&j").value='规格'
	ef.Range("F&j").value='每箱数量'
	ef.Range("G&j").value='体积'
	ef.Range("H&j").value='单重'
	ef.Range("I&j").value='总重'
	ef.Range("J&j").value='描述'
	ef.Range("K&j").value='条码'
	SELECT tmpp
	GO top
	DO whil .not. EOF()
		i=i+1
		j=ALLTRIM(STR(i))	
		ef.ActiveSheet.ROWS(I).Font.Bold=.F.
		ef.Range(ef.Cells(I,1),ef.Cells(I,14)).Font.Size=8
		ef.Range(ef.Cells(I,1),ef.Cells(I+1,14)).HorizontalAlignment=3 &&水平(1-默认、2-靠左、3-居中、4-靠右、5-填充、6=两端对齐、7=跨列居中、8=分散对齐)

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

	IF SQLEXEC(CON,"SELECT '料件调拨' classid,exportcode.code,B1.MB002,B1.MB003,B1.MB004,totalpcs MB094, B1.MB053 ,B1.MB053 *pcs*pidetail.quan CASH "+;
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

	ef.Range("B&j").value='属性'
	ef.Range("C&j").value='品号'
	ef.Range("D&j").value='品名'
	ef.Range("E&j").value='规格'
	ef.Range("F&j").value='单位'
	ef.Range("G&j").value='数量'
	ef.Range("H&j").value='单价'
	ef.Range("I&j").value='金额'
	ef.Range("J&j").value='描述'
	SELECT tmpp
	GO top
	DO whil .not. EOF()
		i=i+1
		j=ALLTRIM(STR(i))	
		ef.ActiveSheet.ROWS(I).Font.Bold=.F.
		ef.Range(ef.Cells(I,1),ef.Cells(I,14)).Font.Size=8
		ef.Range(ef.Cells(I,1),ef.Cells(I+1,14)).HorizontalAlignment=3 &&水平(1-默认、2-靠左、3-居中、4-靠右、5-填充、6=两端对齐、7=跨列居中、8=分散对齐)

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
				ef.Range(ef.Cells(I,1),ef.Cells(I+1,14)).HorizontalAlignment=2 &&水平(1-默认、2-靠左、3-居中、4-靠右、5-填充、6=两端对齐、7=跨列居中、8=分散对齐)
				ef.Range(ef.Cells(I,1),ef.Cells(I+1,14)).VerticalAlignment=1 &&垂直(1=靠上、2=居中、3=靠下、4=两端对齐、5=分散对齐)	

			DO CASE 
				J1=ALLTRIM(STR(classid))	

				CASE classid=11
					ef.range("B&J:D&J").Select
					ef.Selection.Merge
					mccc='彩盒'
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

					mccc='彩贴'
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
*说明书不打印
				CASE classid=14
					mccc='标签'
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
					mccc='外箱'
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
					mccc='其他'
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
*!*						mccc='其他'
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
	ef.Range(ef.Cells(5,1),ef.Cells(I,1)).VerticalAlignment=2 &&垂直(1=靠上、2=居中、3=靠下、4=两端对齐、5=分散对齐)	
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
ef.Range("A&j").Font.Name="黑体"
ef.Range("A&j").Font.size=10
ef.Rows(i).RowHeight=1/0.0035/11
SELECT tmpBuyDetailscsc 
SUM QUAN,TD201,quan*price TO XX,YY,zz
ef.Range("A&j").value='-----共：['+ALLTRIM(STR(RECC()))+']条记录，产品总数：'+ALLTRIM(STR(XX))+'，总箱数：'+ALLTRIM(STR(YY))+'，总价：'+ALLTRIM(STR(zz))+'   备注:'+keytxt
ef.range("A&X1X:N&J").Select
ef.Selection.Merge

*!*	i=i+1
*!*	j=ALLTRIM(STR(i))
*!*	I=RECCOUNT()+4
*!*	ef.Range(ef.Cells(3,1),ef.Cells(I,54)).BorderS.LineStyle=1
*!*	ef.Range(ef.Cells(3,1),ef.Cells(I,54)).HorizontalAlignment=3 &&水平(1-默认、2-靠左、3-居中、4-靠右、5-填充、6=两端对齐、7=跨列居中、8=分散对齐)
*!*	ef.Range(ef.Cells(3,1),ef.Cells(I,54)).VerticalAlignment=2 &&垂直(1=靠上、2=居中、3=靠下、4=两端对齐、5=分散对齐)
*!*	ef.Range(ef.Cells(5,1),ef.Cells(I,54)).HorizontalAlignment=2 &&水平(1-默认、2-靠左、3-居中、4-靠右、5-填充、6=两端对齐、7=跨列居中、8=分散对齐)
*ef.ActiveSheet.PageSetup.RightHeader="联系人:陈姚银,联系电话:62760949-202(13065854221),传真:0574-62760270,Email:mybb@yaohualux.com"
ef.ActiveSheet.PageSetup.RightFooter="联系人:陈姚银,联系电话:62760547-8403(13065854221),传真:0574-62760270,Email:mybb@yaohualux.com"
ef.ActiveSheet.PageSetup.RightHeader="第 &P 页/ 共 &N 页"
ef.ActiveSheet.PageSetup.LeftHeader="打印时间：&D - &T"
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
	MESSAGEBOX("不行")
ENDTRY 		
WAIT windows '读取完毕' NOWAIT 

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
*!*	*!*	REPORT FORM d:\trade\pi单 PREVIEW
*!*	*!*	codeid=2011080001
*!*	*!*	P_ReportFile='中文客户报价单'
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

