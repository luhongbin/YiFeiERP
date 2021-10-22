

*	***************************************************************
*	*
*	*			2008-03-25		Begin.PRG			21:00:00
*	*
*	***************************************************************
*	*	Programmer:	Lu_HongBin
*	*
*	*	CopyRight(R)	ShenTaMyMis   V1.0
*	*
*	*	Description:	This is first file of ShenTaMyMis   
*	*
*	***************************************************************
*	Call By :	No file
FUNCTION _GetPicforqr
  m.goPic.pictureval = TMPID.photo
  RETURN .T.
ENDFUNC
DEFINE CLASS MyInvoice AS CUSTOM
	PROCEDURE AlertResult (tnResult)
		DO CASE
			CASE tnResult < 0
				** Faded away. Do nothing.
			CASE tnResult = 1
				** Clicked close button. Do nothing
			CASE tnResult = 2
				** Clicked link
				DO FORM FRMS\picost
			CASE tnResult = 3
				Answer=MESSAGEBOX('你真的要删除这个提醒记录吗?',4+32+256,P_Caption)
	
				IF Answer=6
					con=odbc(6)
					xxx=ALLTRIM(STR(KEYID))
					SQLEXEC(con,"update remotion set statusid='不再提醒' WHERE remotion=?P_USERNAME  AND keyvalue=?XXX ")
					SQLDISCONNECT(con)
				ENDIF 
			CASE tnResult = 4
				Answer=MESSAGEBOX('你真的要删除这个提醒记录吗?',4+32+256,P_Caption)
	
				IF Answer=6
					con=odbc(5)
					xxx=ALLTRIM(STR(KEYID))
					SQLEXEC(con,"update remotion set statusid='不再提醒' WHERE remotion=?P_USERNAME AND keyvalue=?XXX ")
					SQLDISCONNECT(con)
				ENDIF 
			OTHERWISE
				MESSAGEBOX("Got this result: " + TRANSFORM(tnResult) + ".",16,"Error")
		ENDCASE	
	ENDPROC
ENDDEFINE	
FUNCTION GetServerDate
	CON5=ODBC(5)
	llReturn=SQLEXEC(CON5,"SELECT Getdate() AS GetSeverDate")
	SQLDISCONNECT(CON5)
	RETURN GetSeverDate
ENDFUNC 

FUNCTION stoptrace

	CON5=ODBC(5)
	SQLEXEC(CON5,"select id from sys.traces where id <> 1 ","tmptmp")
	DO whil .not. EOF()
		aaa=id
		SQLEXEC(CON5," exec  sp_trace_setstatus ?aaa,0 ")
		SQLEXEC(CON5," exec  sp_trace_setstatus ?aaa,2 ")
		SELECT tmptmp
		skip
	ENDD
	SQLDISCONNECT(CON5)
ENDFUNC 
Function CaseMoney &&Edit By daly
PARA Money
*辨别是否是数字金额
IF TYPE("Money") #"N"
    =messagebox(" 金额类型出错",0,_screen.caption)
    Return " "
EndIF
*转换金额为字符型
IF Money>9999999999999.99
    =messagebox(" 数值太大,无法处理",0,_screen.caption)
    Return " "
EndIF
CMoney=Allt(Str(Money,16,2))

*定义数组
DIME CaseFormat(10)
CaseFormat(1) ="壹"
CaseFormat(2) ="贰"
CaseFormat(3) ="叁"
CaseFormat(4) ="肆"
CaseFormat(5) ="伍"
CaseFormat(6) ="陆"
CaseFormat(7) ="柒"
CaseFormat(8) ="捌"
CaseFormat(9) ="玖"
Dime Unit(3)
Unit(1) ="拾"
Unit(2) ="佰"
Unit(3) ="仟"
*开始转换
M_Cmoney=""
m_C=''
MoneyLen=len(CMoney)
J=0
For i=MoneyLen To 1 step -1
    Nowmoney=val(substr(CMoney,i,1))
    IF Nowmoney>0
        do case
            Case i = MoneyLen
                M_Cmoney=CaseFormat(Nowmoney)+"分"
            Case i = MoneyLen-1
                M_Cmoney="元"+CaseFormat(Nowmoney)+"角"+M_Cmoney
            Case i = MoneyLen-3
                M_Cmoney=CaseFormat(Nowmoney)+M_Cmoney
            Case i < MoneyLen-3
                IF mod((J+1),4)>0
                    M_Cmoney=CaseFormat(Nowmoney)+Unit(mod(J+1,4))+M_Cmoney
                Else
                    M_J = int((j+1)/4)-1
                    IF M_J>0
                        IF M_J = 1 or M_J = 3
                            M_C = "万"+m_C
                        Else
                            M_C = "亿"+m_C
                        Endif 
                    EndIF 
                    IF left(M_Cmoney,2)="万" 
                        M_Cmoney=right(M_Cmoney,len(M_Cmoney)-2)
                    EndIF 
                    M_Cmoney=CaseFormat(Nowmoney)+M_C+M_Cmoney
                EndIF
            EndCase
    Else
        do case
            Case i = MoneyLen-1
                IF Empty(M_Cmoney)
                    M_Cmoney="元整"
                Else
                    M_Cmoney="元零"+M_Cmoney
                EndIF 
            Case i < MoneyLen-3
                IF mod((J+1),4)>0
                    IF substr(M_Cmoney,1,2)#"零" and !substr(M_Cmoney,1,2)$"万亿元" 
                        M_Cmoney="零" +M_Cmoney
                    EndIF 
                Else
                    M_J = int((j+1)/4)-1
                    IF M_J>0
                        IF M_J = 1 or M_J = 3
                            M_C = "万"+m_C
                        Else
                            M_C = "亿"+m_C
                        Endif 
                    EndIF 
                    IF substr(M_Cmoney,1,2)="万" 
                        M_Cmoney=right(M_Cmoney,len(M_Cmoney)-2)
                    EndIF 
                    M_Cmoney=M_C+M_Cmoney
                EndIF
          EndCase 
EndIf 
j=j+1 
EndFor
Return M_Cmoney
ENDFUNC


*!*	oOutlook=CREATEOBJECT("Outlook.Application")&&读取OUTLOOK联系人的
*!*	oNameSpace=oOutlook.GetNameSpace("MAPI")

*!*	i=0

*!*	DO parsecontacts WITH oNameSpace.GetDefaultFolder(10),''
*!*	return

*!*	PROC parsecontacts
*!*	PARAMETERS oTargetFolder,folderpath
*!*	PRIVATE ALL EXCEPT I
*!*	oContacts=oTargetFolder.Items
*!*	oFolders=oTargetFolder.Folders

*!*	store iif(not empty(folderpath),folderpath+'\','')+oTargetFolder.Name to folderpath,parentpath

*!*	FOR EACH loFolder IN oFolders
*!*	   DO parsecontacts WITH oTargetFolder.Folders(loFolder.NAME), folderpath
*!*	   folderpath=parentpath
*!*	ENDFOR

*!*	oContacts = oContacts.RESTRICT("[MessageClass] >= 'IPM.Contact' AND [MessageClass] <= 'IPM.Contact'")
*!*	*SCAN THRU CONTACTS IN CURRENT FOLDER
*!*	FOR EACH loContact IN oContacts
*!*	   i=i+1
*!*	   WITH loContact
*!*	      WAIT WINDOW ;
*!*	         .FileAs+CHR(13)+;
*!*	         .CompanyName TIMEOUT .1
*!*	         ? .FileAs
*!*	   ENDWITH
*!*	ENDFOR
*!*	RETURN

*!*	WAIT WINDOW ALLTRIM(STR(i))+' Total Contacts found'

*******************************************
PROCEDURE SendViaOutlook(tcReturn, tcTo, tcSubject, tcBody, taFiles, tcCC, tcBCC, tlHTMLFormat, tnImportance, tlOpenEmail)
 *******************************************
 LOCAL loOutlook, loItem, lnCountAttachments, loMapi
 TRY
  loOutlook = CREATEOBJECT("outlook.application")
  loMapi = loOutLook.GetNameSpace("MAPI")
  *loMapi.Logon()
  loItem = loOutlook.CreateItem(0)
  WITH loItem
   .Subject = tcSubject
   .TO = tcTo
   IF tlHTMLFormat
    .HTMLBody = tcBody
   ELSE
    .Body = tcBody
   ENDIF
   IF TYPE("tcCC") = "C"
    .CC = tcCC
   ENDIF
   IF TYPE("tcBCC") = "C"
    .BCC = tcBCC
   ENDIF
   IF TYPE("tnImportance") != "N"
    tnImportance = 1 && normal importance
   ENDIF
   .Importance = tnImportance
	.ReadReceiptRequested = .T.
&&	.OriginatorDeliveryReportRequested=.T.
   IF TYPE("tafiles",1) = "A" OR TYPE("tafiles",1) = "N"
    FOR lnCountAttachments = 1 TO ALEN(taFiles)
     .Attachments.ADD(taFiles(lnCountAttachments))
    ENDFOR
   ENDIF
   IF tlOpenEmail
    .DISPLAY()
   ELSE
    .SEND()
   ENDIF
  ENDWITH
 CATCH TO loError
  tcReturn = [Error: ] + STR(loError.ERRORNO) + CHR(13) + ;
   [LineNo: ] + STR(loError.LINENO) + CHR(13) + ;
   [Message: ] + loError.MESSAGE + CHR(13) + ;
   [Procedure: ] + loError.PROCEDURE + CHR(13) + ;
   [Details: ] + loError.DETAILS + CHR(13) + ;
   [StackLevel: ] + STR(loError.STACKLEVEL) + CHR(13) + ;
   [LineContents: ] + loError.LINECONTENTS
	lcErrReturn=''
 FINALLY
  RELEASE oOutlook, oItem
  STORE .NULL. TO oOutlook, oItem
 ENDTRY
ENDPROC

*!*	procedure InsertPicture
*!*	PARAMETERS ActiveSheet, ImageFilePath, ImageHeight, PictureTop
*!*	  Picture OleVariant
*!*	  Picture = ActiveSheet.Pictures.Insert(ImageFilePath)
*!*	  Picture.Width = ImageHeight * Picture.Width / Picture.Height
*!*	  Picture.Height = ImageHeight
*!*	  Picture.ShapeRange.Left= 0
*!*	  Picture.ShapeRange.Top = PictureTop
*!*	  Picture.Placement = xlMove
*!*	ENDPROC
PROCEDURE GetReport
PARAMETERS TLD

	CURSORSETPROP("MapBinary",.T.,0)&&非常关键
	cond=odbc(6)
	Sqlexec(CONd,"select frx,frt from printcaption where interid=?TLD","temp")
	SQLDISCONNECT(cond)
	CLOSEDB("报表打印")
	IF FILE("报表打印.frx")
		ERASE 报表打印.*
	ENDIF 
	SELECT temp
	IF ISNULL(frx) OR EMPTY(frx)
		cfile=''
		cfile1=''
*!*			this.Parent.txtreport.Value=''	
	ELSE 
		cfile=frx
		cfile1=frt
	ENDIF 

	STRTOFILE(cfile,'报表打印.frx')	
	STRTOFILE(cfile1,'报表打印.frt')	
	CLOSEDB("报表打印")

ENDPROC

FUNCTION _GetPic
  SELECT T1
  IF empty(t1.pic) OR  isnull(t1.pic)
	  m.goPic.pictureval = ''
  ELSE
	  m.goPic.pictureval = t1.pic
  ENDIF 	  
  RETURN .T.
ENDFUNC
FUNCTION _GetPic1
  SELECT T1

  IF empty(t1.pic1) OR  isnull(t1.pic1)
	  m.goPic1.pictureval = ''
  ELSE
	  m.goPic1.pictureval = t1.pic1
  ENDIF 	  
  RETURN .T.
ENDFUNC

PROCEDURE FRX2TIFF
PARAMETERS TL
SET REPORTBEHAVIOR 90

oldAlias=ALIAS()
local lcDirectory, ;
	loListener, ;
	loShell,;
	loError
DO GetReport WITH TL
TRY
lcDirectory = sys(16)
lcDirectory = addbs(justpath(substr(lcDirectory, at(' ', lcDirectory, 2) + 1)))
loListener = newobject('MPTiffListener',  'Class\europa.vcx')
loListener.TargetFileName = SYS(5)+SYS(2003) +'\MyReport.tif'&&forcepath('MyReport.tif', sys(2023))
loListener.QuietMode      = .T.

wait window '正在形成 TIFF 文件...' nowait

SELECT &OldAlias
erase (loListener.TargetFileName)
report form reporttest object loListener NOCONSOLE 

* Display the results.

*!*	loShell = newobject('_shellexecute', 'Class\_environ.vcx')
*!*	loShell.ShellExecute(loListener.TargetFileName)
CATCH TO loError
	MESSAGEBOX(loError.Message)
ENDTRY
*SET REPORTBEHAVIOR 90

WAIT WINDOWS '报表文件数据导出到TIFF完毕!' NOWAIT
*DO EveryDay WITH P_FileName,P_Id,'导出到TIFF'
ENDPROC


*****
PROCEDURE FRX2XLS
PARAMETERS TL
DO CASE 
	CASE TL=2011080000 &&中文客户报价单

		m.outfilename=putfile('输出结果','报价单','xls')
		&&取导出文件名称
		ef=CREATEOBJECT('Excel.application')
		&&调用Excel程序
		ef.Workbooks.add
		&&添加工作簿
		ef.Worksheets("sheet1").Activate
		ef.Caption=m.outfilename
		&&激活第一个工作表
		ef.visible=.t.
		SELECT t1
		I=RECCOUNT()+3
		ef.Range(ef.Cells(2,1),ef.Cells(I,34)).BorderS.LineStyle=1
		ef.Range(ef.Cells(2,1),ef.Cells(I,34)).HorizontalAlignment=3 &&水平(1-默认、2-靠左、3-居中、4-靠右、5-填充、6=两端对齐、7=跨列居中、8=分散对齐)
		ef.Range(ef.Cells(2,1),ef.Cells(I,34)).VerticalAlignment=2 &&垂直(1=靠上、2=居中、3=靠下、4=两端对齐、5=分散对齐)

		&&显示Excel界面
		*!*	ef.Cells.Select
		&&选择整张表
		ef.Selection.Font.Size = 10
		&&设置整表默认字体大小为10
		ef.range("A1:F1").Select
		&&选择标题栏所在单元格
		ef.Selection.Merge
		&&合并单元格
		*!*	with ef.range("A1")
		ef.range("A1").HorizontalAlignment=4
		ef.Rows(1).RowHeight=1/0.0035/3
		*!*	ef.Range("A1").Select
		ef.Cells(1, 1).Activate
		ef.ActiveSheet.PictureS.Insert(OldPath+"\imgs\log.gif").Select
		ef.Selection.ShapeRange.LockAspectRatio =.T.
		Target =ef.Cells(1, 1)
		ef.Selection.Top = Target.Top + 1
		ef.Selection.Left = Target.Left + 1

		*!*	ef.Selection.ShapeRange.Height =160
		&&设置标题及字体属性
		*value='客户服务部业务代表工作量情况统计表'
		*Font.Name="黑体"
		*Font.size=18
		*!*	endwith
		*!*	ef.range("H2").Font.size=10
		*!*	ef.range("H2").HorizontalAlignment=4
		&&设置内容对齐方式为右对齐,3为居中，4为右对齐
		ef.ActiveSheet.Columns(1).ColumnWidth =25

		ef.Range("A2").value='Product Name'
		ef.Range("B2").value='PICTURE'
		ef.Range("C2").value='ITEM NO.'
		ef.range("D2").HorizontalAlignment=2
		ef.Range("D2").value=ALLTRIM(incoterm)
		ef.Range("E2").value='DESCRIPTION'
		ef.Range("F2").value='Material'
		ef.Range("G2").value='Shade'
		ef.Range("H2").value='Light Source'
		ef.Range("I2").value='Bulb (incl/excl)'
		ef.Range("J2").value='IP Rating'
		ef.Range("K2").value='Dimension'
		ef.Range("L2:P2").Select
		ef.Selection.Merge
		ef.range("L2").HorizontalAlignment=3
		ef.Range("L2").value='SINGLE PACK中包尺寸，重量'
		ef.Range("Q2:V2").Select
		ef.Selection.Merge
		ef.range("Q2").HorizontalAlignment=3

		ef.Range("Q2").value='INNER 内包装尺寸，重量'
		ef.Range("W2:AB2").Select
		ef.Selection.Merge
		ef.range("W2").HorizontalAlignment=3

		ef.Range("W2").value='MASTER CARTON外箱尺寸,重量'

		ef.Range("AC2").value='APPROVAL'
		ef.Range("AD2").value='MOQ(PCS)'
		ef.Range("AE2:AG2").Select
		ef.Selection.Merge
		ef.range("AE2").HorizontalAlignment=3

		ef.Range("AE2").value='QTY集装箱所装数量'
		
		ef.Range("AH2").value='Remark'
		
		ef.Range("A3").value='产品名称'
		ef.Range("B3").value='图片'
		ef.Range("C3").value='公司货号'
		ef.Range("D3").value='价格'
		ef.Range("E3").value='产品描述'
		ef.Range("F3").value='材料'
		ef.Range("G3").value='透光件'
		ef.Range("H3").value='光源'
		ef.Range("I3").value='是否包含灯泡'
		ef.Range("J3").value='防尘防水等级'
		ef.Range("K3").value='产品尺寸'
		ef.Range("L3").value='KG'
		ef.Range("M3").value='WIDTH长'
		ef.Range("N3").value='DEPTH宽'
		ef.Range("O3").value='HEIGHT高'
		ef.Range("P3").value='CBM'
		ef.Range("Q3").value='PCS/INNER只/内包'
		ef.Range("R3").value='KG'
		ef.Range("S3").value='WIDTH长'
		ef.Range("T3").value='DEPTH宽'
		ef.Range("U3").value='HEIGHT高'
		ef.Range("V3").value='CBM'
		ef.Range("W3").value='PCS/CTN'
		ef.Range("X3").value='KG'
		ef.Range("Y3").value='WIDTH长'
		ef.Range("Z3").value='DEPTH宽'
		ef.Range("AA3").value='HEIGHT高'
		ef.Range("AB3").value='CBM'

		ef.Range("AC3").value='有何证书/实验室'
		ef.Range("AD3").value='最小采购量'
		ef.Range("AE3").value="20'FCL"
		ef.Range("AF3").value="40'FCL"
		ef.Range("AG3").value="40'H"

		CURSORSETPROP("MapBinary",.T.,0)&&非常关键
		SELECT t1
		ef.ActiveSheet.Columns(2).ColumnWidth =20
		ef.ActiveSheet.Columns(3).ColumnWidth =15
		ef.ActiveSheet.Columns(4).ColumnWidth =20
		ef.ActiveSheet.Columns(5).ColumnWidth =35
		ef.ActiveSheet.Columns(6).ColumnWidth =15
		ef.ActiveSheet.Columns(7).ColumnWidth =15
		ef.ActiveSheet.Columns(8).ColumnWidth =15
		ef.ActiveSheet.Columns(9).ColumnWidth =15
		ef.ActiveSheet.Columns(10).ColumnWidth =15
		ef.ActiveSheet.Columns(11).ColumnWidth =20
		i=4
		go top
		DO WHILE .not. EOF()
			j=ALLTRIM(STR(i))
			ef.range("A&J").HorizontalAlignment=2
			ef.range("E&J").HorizontalAlignment=2
			ef.Range("A&j").value=ALLTRIM(productname)
			
			IF OCCURS(CHR(13),descripe)>4
				ef.Rows(&J).RowHeight=OCCURS(CHR(13),descripe)*20
			ELSE 
				ef.Rows(&J).RowHeight=1/0.0035/4
			ENDIF 	
			
			IF !ISNULL(pic) AND !EMPTY(pic)
				ERASE OldPath+"\TMPLHB"+'&j'
				STRTOFILE(pic,OldPath+"\TMPLHB"+'&j')
				_Screen.AddObject( 'pic1', 'Image' )
				_Screen.pic1.Picture=OldPath+"\TMPLHB"+'&j'
				*ef.Range("B&j").value="TMPLHB"+'&j'
				ef.Cells( I,2).Activate
				ef.ActiveSheet.PictureS.Insert(OldPath+"\TMPLHB"+'&j').Select
				ef.Selection.ShapeRange.LockAspectRatio =.T.
*				ef.ActiveSheet.Columns(2).ColumnWidth =22
				Target =ef.Cells( I,2)
				ef.Selection.Top = Target.Top + 2
				ef.Selection.Left = Target.Left + 10
				ef.Selection.ShapeRange.Height =1/0.0035/3

*!*					IF _Screen.pic1.Width<_Screen.pic1.Height
*!*						ef.Selection.ShapeRange.Height =ef.Rows(&J).RowHeight-4
*!*					ELSE
*!*						ef.Selection.ShapeRange.WIDTH =_Screen.pic1.Width/1.5
*!*					ENDIF
			ELSE 
				WAIT windows '没有图片' NOWAIT
				RETURN 	
			ENDIF 
			_Screen.RemoveObject( 'pic1' )
			ef.range("B&J").HorizontalAlignment=2

			ef.Range("C&j").value=ALLTRIM(itemno)
			ef.ActiveSheet.Range("D&j:D&j").NumberFormatLocal =  "0.00"
			ef.Range("D&j").value=price
*!*				ef.Range(ef.Cells(2,1),ef.Cells(I,33)).HorizontalAlignment=3 &&水平(1-默认、2-靠左、3-居中、4-靠右、5-填充、6=两端对齐、7=跨列居中、8=分散对齐)
		
			ef.Range("E&j").value= ALLTRIM(descripe)
			ef.Range("F&j").value=ALLTRIM(material)
			ef.Range("G&j").value=ALLTRIM(shape)
			ef.Range("H&j").value=ALLTRIM(lightsource)
			ef.Range("I&j").value=ALLTRIM(bulb)
			ef.Range("J&j").value=ALLTRIM(iprating)
			ef.Range("K&j").value=ALLTRIM(size)
			ef.ActiveSheet.Range("L&j:O&j").NumberFormatLocal =  "0.00"
			mkeyid=pidetail.maininterid
			ttt=i
			con=odbc(5)
			IF SQLEXEC(CON,"SELECT classid,packagecode,B1.MB002,B1.MB003,long MB093,width MB094, deep MB095,quan,long*width*deep/1000000 vol,boxnum,boxfrom,boxto "+;
				",weight,des,barcode FROM packageinfo LEFT join INVMB B1 ON packagecode=B1.MB001 where billid=2 and interid=?mkeyid and classid='中包' ORDER BY 11,1,2","TmpP")<0
				WAIT WINDOWS '??xxx?'
				RETURN
			ENDIF
			SQLDISCONNECT(con)
			SELECT tmpp
			GO top
			DO whil .not. EOF()			
				ef.Range("L&j").value=weight
				ef.Range("M&j").value=MB093
				ef.Range("N&j").value=MB094
				ef.Range("O&j").value=MB095
				ef.ActiveSheet.Range("P&j:P&j").NumberFormatLocal =  "0.000"
				ef.Range("P&j").value=vol
				ef.Range("Q&j").value=0
				ef.ActiveSheet.Range("R&j:U&j").NumberFormatLocal =  "0.00"
				ef.Range("R&j").value=0
				ef.Range("S&j").value=0
				ef.Range("T&j").value=0
				ef.Range("U&j").value=0
				ef.ActiveSheet.Range("V&j:V&j").NumberFormatLocal ="0.000"
				ef.Range("V&j").value=0

				ttt=ttt+1
				j=ALLTRIM(STR(ttt))
				SELECT tmpp
				SKIP
			ENDDO 
			ttt=i
			j=ALLTRIM(STR(i))

			con=odbc(5)
			IF SQLEXEC(CON,"SELECT classid,packagecode,B1.MB002,B1.MB003,long MB093,width MB094, deep MB095,quan,long*width*deep/1000000 vol,boxnum,boxfrom,boxto "+;
				",weight,des,barcode FROM packageinfo LEFT join INVMB B1 ON packagecode=B1.MB001 where billid=2 and interid=?mkeyid and classid='外箱' ORDER BY 11,1,2","TmpP")<0
				WAIT WINDOWS '??xxx?'
				RETURN
			ENDIF
			SQLDISCONNECT(con)
			SELECT tmpp
			GO top
			DO whil .not. EOF()					
				ef.Range("W&j").value=quan
				ef.ActiveSheet.Range("X&j:AA&j").NumberFormatLocal="0.00"
				ef.Range("X&j").value=weight
				ef.Range("Y&j").value=MB093
				ef.Range("Z&j").value= MB094
				ef.Range("AA&j").value=MB095
				ef.ActiveSheet.Range("AB&j:AB&j").NumberFormatLocal ="0.000"
				ef.Range("AB&j").value=vol
				ttt=ttt+1
				j=ALLTRIM(STR(ttt))
				SELECT tmpp
				SKIP
			ENDDO 			SELECT T1
			ef.Range("AC&j").value=ALLTRIM(approval)
			ef.Range("AD&j").value=moq
			ef.Range("AE&j").value=qty20fcl
			ef.Range("AF&j").value=qty40fcl
			ef.Range("AG&j").value=qty40h
			ef.Range("AH&j").value=note
			i=i+1
			SKIP
		ENDDO 
		i=i+1
		SELECT T1
		GO TOP
		j=ALLTRIM(STR(i))
		*!*	ef.Rows(i).RowHeight=1/0.0035/4
		ef.Range("A&j").value='Offer Date:'
		ef.Range("B&j").value=substr(dateid,1,4)+'.'+substr(dateid,5,2)+'.'+substr(dateid,7,2)
		ef.Range("C&j").value= 'Contact:'
		ef.Range("D&j").value=P_Title
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='Expiry Date'
		ef.Range("B&j").value=substr(edateid,1,4)+'.'+substr(edateid,5,2)+'.'+substr(edateid,7,2)
		ef.Range("C&j").value= 'Email:'
		ef.Range("D&j").value=P_Email
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='Currency'
		ef.Range("B&j").value=currency
		ef.Range("C&j").value= 'Tel'
		ef.Range("D&j").value='86-574-62760156, 62760540'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='Incoterm'
		ef.Range("B&j").value=incoterm
		ef.Range("C&j").value= 'Fax'
		ef.Range("D&j").value='86-574-62760807, 62702807'

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='Port of Loading'
		ef.Range("B&j").value=loading
		ef.Range("C&j").value= 'web site'
		ef.Range("D&j").value='www.cnymec.com'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='Port of Discharge'
		ef.Range("B&j").value=discharge
		ef.Range("C&j").value= ' '
		ef.Range("D&j").value='www.yaohualux.com'

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='RemarkS:'

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='1)DELIVERY TIME:'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='2)OUR GOVERMENT MAY CHANGE TAX-REBATE POLICY FROM JULY 1,  TO AVOID THE RISK OF THIS POLICY,  WE'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='CONFIRM OUR ABOVE PRICE IS BASED ON EXISTING TAX-REBATE 13%, IF THERE IS ANY TAX-REBATE POLICY CHANGE'

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='BEFORE THE SHIPMENT, WE WILL ADJUST OUR PRICE ACCORDINGLY. PLS NOTE'

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value=ALLTRIM(enote)

		ef.Range("A&J:J&J").select
		ef.selection.MergeCells = .T.                          && 合并单元

		*ef.ActiveWorkbook.Save  
	CASE TL=2011100000 &&PI2EXCEL

		*m.outfilename=putfile('输出结果','PI','xls')
		&&取导出文件名称
		ef=CREATEOBJECT('Excel.application')
		&&调用Excel程序
		ef.Workbooks.add
		&&添加工作簿
		ef.Worksheets("sheet1").Activate
		ef.Caption='PI'&&m.outfilename
		&&激活第一个工作表
		ef.visible=.t.
		SELECT t1
		I=RECCOUNT()+3
		ef.Range(ef.Cells(2,1),ef.Cells(I+1,37)).BorderS.LineStyle=1
		ef.Range(ef.Cells(2,1),ef.Cells(I+1,37)).HorizontalAlignment=3 &&水平(1-默认、2-靠左、3-居中、4-靠右、5-填充、6=两端对齐、7=跨列居中、8=分散对齐)
		ef.Range(ef.Cells(2,1),ef.Cells(I+1,37)).VerticalAlignment=2 &&垂直(1=靠上、2=居中、3=靠下、4=两端对齐、5=分散对齐)

		&&显示Excel界面
		*!*	ef.Cells.Select
		&&选择整张表
		ef.Selection.Font.Size = 10
		&&设置整表默认字体大小为10
		ef.range("A1:F1").Select
		&&选择标题栏所在单元格
		ef.Selection.Merge
		&&合并单元格
		*!*	with ef.range("A1")
		ef.range("A1").HorizontalAlignment=4
		ef.Rows(1).RowHeight=1/0.0035/3
		*!*	ef.Range("A1").Select
		ef.Cells(1, 1).Activate
		ef.ActiveSheet.PictureS.Insert(OldPath+"\imgs\log.gif").Select
		ef.Selection.ShapeRange.LockAspectRatio =.T.
		Target =ef.Cells(1, 1)
		ef.Selection.Top = Target.Top + 1
		ef.Selection.Left = Target.Left + 1

		ef.Range("A2").value='Product Name'
		ef.Range("B2").value='PICTURE'
		ef.Range("C2").value='ITEM NO.'
		ef.Range("D2").value='COLOR'
		ef.Range("E2").value='Customer ref.'
		ef.Range("F2").value=ALLTRIM(incoterm1)
		ef.Range("G2").value='DESCRIPTION'
		ef.Range("H2").value='Material'
		ef.Range("I2").value='Shade'
		ef.Range("J2").value='Light Source'
		ef.Range("K2").value='Bulb (incl/excl)'
		ef.Range("L2").value='IP Rating'
		ef.Range("M2").value='Dimension'
		ef.Range("N2").value='QTY'

		ef.Range("O2:S2").Select
		ef.Selection.Merge
		ef.range("O2").HorizontalAlignment=3
		ef.Range("O2").value='SINGLE PACK中包尺寸，重量'
		ef.Range("T2:Y2").Select
		ef.Selection.Merge
		ef.range("T2").HorizontalAlignment=3

		ef.Range("T2").value='INNER 内包装尺寸，重量'
		ef.Range("Z2:AE2").Select
		ef.Selection.Merge
		ef.range("Z2").HorizontalAlignment=3

		ef.Range("Z2").value='MASTER CARTON外箱尺寸,重量'

		ef.Range("AF2:AJ2").Select
		ef.Selection.Merge
		ef.range("AF2").HorizontalAlignment=3

		ef.Range("AF2").value='Total'

*!*			ef.Range("AF2").value='箱数'
*!*			ef.Range("AG2").value='体积'
*!*			ef.Range("AH2").value='总毛重'
*!*			ef.Range("AI2").value='总净重'
*!*			
		ef.Range("AK3").value='APPROVAL'

		ef.Range("A3").value='产品名称'
		ef.Range("B3").value='图片'
		ef.Range("C3").value='公司货号'
		ef.Range("D3").value='颜色'
		ef.Range("E3").value='客户货号'
		ef.Range("F3").value='价格'
		ef.Range("G3").value='产品描述'
		ef.Range("H3").value='材料'
		ef.Range("I3").value='透光件'
		ef.Range("J3").value='光源'
		ef.Range("K3").value='是否包含灯泡'
		ef.Range("L3").value='防尘防水等级'
		ef.Range("M3").value='产品尺寸'
		ef.Range("N3").value='订单数量'
		ef.Range("O3").value='KG'
		ef.Range("P3").value='WIDTH长'
		ef.Range("Q3").value='DEPTH宽'
		ef.Range("R3").value='HEIGHT高'
		ef.Range("S3").value='CBM'
		ef.Range("T3").value='PCS/INNER只/内包'
		ef.Range("U3").value='KG'
		ef.Range("V3").value='WIDTH长'
		ef.Range("W3").value='DEPTH宽'
		ef.Range("X3").value='HEIGHT高'
		ef.Range("Y3").value='CBM'
		ef.Range("Z3").value='PCS/CTN'
		ef.Range("AA3").value='KG'
		ef.Range("AB3").value='WIDTH长'
		ef.Range("AC3").value='DEPTH宽'
		ef.Range("AD3").value='HEIGHT高'
		ef.Range("AE3").value='CBM'
		ef.Range("AF3").value='CTNS'
		ef.Range("AG3").value='CMB'
		ef.Range("AH3").value='G.W.'
		ef.Range("AI3").value='N.W.'
		ef.Range("AJ3").value='总金额'
		ef.Range("AK2").value='有何证书/实验室'


		SELECT t1
		CURSORSETPROP("MapBinary",.T.,0)&&非常关键
*!*			ERASE TMPLHB??
		ef.ActiveSheet.Columns(2).ColumnWidth =20
		ef.ActiveSheet.Columns(3).ColumnWidth =15
		ef.ActiveSheet.Columns(4).ColumnWidth =15
		ef.ActiveSheet.Columns(5).ColumnWidth =15
		ef.ActiveSheet.Columns(6).ColumnWidth =15
		ef.ActiveSheet.Columns(8).ColumnWidth =20
		ef.ActiveSheet.Columns(9).ColumnWidth =15
		ef.ActiveSheet.Columns(11).ColumnWidth =15
		ef.ActiveSheet.Columns(13).ColumnWidth =20
		ef.ActiveSheet.Columns(37).ColumnWidth =20
		i=4
		go top
		S1=0
		S2=0
		S3=0
		S4=0
		DO WHILE .not. EOF()
			j=ALLTRIM(STR(i))
			ef.Rows(i).RowHeight=1/0.0035/4
			ef.range("a&J").HorizontalAlignment=2
			ef.range("G&J").HorizontalAlignment=2
			ef.Range("A&j").value=ALLTRIM(productname)
			
			ef.ActiveSheet.Columns(1).ColumnWidth =32
			ef.ActiveSheet.Columns(2).ColumnWidth =20
			ef.ActiveSheet.Columns(7).ColumnWidth =32

			
			IF OCCURS(CHR(13),descripe)>4
				ef.Rows(&J).RowHeight=OCCURS(CHR(13),descripe)*20
			ELSE 
				ef.Rows(&J).RowHeight=1/0.0035/4
			ENDIF 	
			
			IF !ISNULL(pic)
*!*					ERASE OldPath+"\TMPLHB"+'&j'
				STRTOFILE(pic,OldPath+"\TMPLHB"+'&j')
				_Screen.AddObject( 'pic1', 'Image' )
				_Screen.pic1.Picture=OldPath+"\TMPLHB"+'&j'
				*ef.Range("B&j").value="TMPLHB"+'&j'
				ef.Cells( I,2).Activate
				ef.ActiveSheet.PictureS.Insert(OldPath+"\TMPLHB"+'&j').Select
				ef.Selection.ShapeRange.LockAspectRatio =.T.
*				ef.ActiveSheet.Columns(2).ColumnWidth =22
				Target =ef.Cells( I,2)
				ef.Selection.Top = Target.Top + 2
				ef.Selection.Left = Target.Left + 10
					ef.Selection.ShapeRange.Height =1/0.0035/4

*!*					IF _Screen.pic1.Width<_Screen.pic1.Height
*!*						ef.Selection.ShapeRange.Height =ef.Rows(&J).RowHeight-4
*!*					ELSE
*!*						ef.Selection.ShapeRange.WIDTH =_Screen.pic1.Width/1.5
*!*					ENDIF
			ENDIF 
			TRY
				_Screen.RemoveObject( 'pic1' )
			CATCH TO oException2
				WAIT WINDOWS '' NOWAIT
			ENDTRY
			ef.range("B&J").HorizontalAlignment=2


			ef.Range("C&j").value=ALLTRIM(itemno)
			ef.Range("D&j").value=ALLTRIM(color)
			ef.Range("E&j").value= ALLTRIM(customcode)	
			ef.ActiveSheet.Range("F&j:F&j").NumberFormatLocal =  "0.00"

			ef.Range("F&j").value=price
			ef.Range("G&j").value= ALLTRIM(descripe)
			ef.Range("H&j").value=ALLTRIM(material)
			ef.Range("I&j").value=ALLTRIM(shape)
			ef.Range("J&j").value=ALLTRIM(lightsource)
			ef.Range("K&j").value=ALLTRIM(bulb)
			ef.Range("L&j").value=ALLTRIM(iprating)
			ef.Range("M&j").value=ALLTRIM(size)
			ef.Range("N&j").value=quan
			ef.ActiveSheet.Range("O&j:R&j").NumberFormatLocal =  "0.00"
			mkeyid=pidetail.maininterid
			con=odbc(5)
			IF SQLEXEC(CON,"SELECT classid,packagecode,B1.MB002,B1.MB003,long MB093,width MB094, deep MB095,quan,long*width*deep/1000000 vol,boxnum,boxfrom,boxto "+;
				",weight,des,barcode FROM packageinfo LEFT join INVMB B1 ON packagecode=B1.MB001 where billid=2 and interid=?mkeyid and classid='中包' ORDER BY 11,1,2","TmpP")<0
				WAIT WINDOWS '??xxx?'
				RETURN
			ENDIF
			ttt=i
			j=ALLTRIM(STR(i))
			
			SELECT tmpp
			GO top
			DO whil .not. EOF()
				ef.Range("O&j").value=weight
				ef.Range("P&j").value=MB093
				ef.Range("Q&j").value=MB094
				ef.Range("R&j").value=MB095
				ef.ActiveSheet.Range("S&j:S&j").NumberFormatLocal =  "0.000"
				ef.Range("S&j").value=vol
				ef.Range("T&j").value=0
				ef.ActiveSheet.Range("U&j:X&j").NumberFormatLocal =  "0.00"
*!*					IF ISNULL(nbkgs)
*!*						replace nbkgs WITH 0
*!*					ENDIF 	
				ef.Range("U&j").value=0
				ef.Range("V&j").value=0
				ef.Range("W&j").value=0
				ef.Range("X&j").value=0
				ef.ActiveSheet.Range("Y&j:Y&j").NumberFormatLocal =  "0.000"
				ef.Range("Y&j").value=0
				ttt=ttt+1
				j=ALLTRIM(STR(ttt))
				SELECT tmpp
				SKIP
			ENDDO 	
			con=odbc(5)
			IF SQLEXEC(CON,"SELECT classid,packagecode,B1.MB002,B1.MB003,long MB093,width MB094, deep MB095,quan,long*width*deep/1000000 vol,boxnum,boxfrom,boxto "+;
				",weight,des,barcode FROM packageinfo LEFT join INVMB B1 ON packagecode=B1.MB001 where billid=2 and interid=?mkeyid and classid='外箱' ORDER BY 11,1,2","TmpP")<0
				WAIT WINDOWS '??xxx?'
				RETURN
			ENDIF
			SQLDISCONNECT(con)
			ttt=i
			j=ALLTRIM(STR(i))
			
			SELECT tmpp
			GO top
			DO whil .not. EOF()
				ef.Range("Z&j").value=quan
				ef.ActiveSheet.Range("AA&j:AD&j").NumberFormatLocal =  "0.00"
				ef.Range("AA&j").value=weight
				ef.Range("AB&j").value=MB093
				ef.Range("AC&j").value= MB094
				ef.Range("AD&j").value=MB095
				ef.ActiveSheet.Range("AE&j:AG&j").NumberFormatLocal =  "0.000"
				ef.Range("AE&j").value=vol
				ef.ActiveSheet.Range("AA&j:AD&j").NumberFormatLocal =  "0.00"
				ttt=ttt+1
				j=ALLTRIM(STR(ttt))
				SELECT tmpp
				SKIP
			ENDDO 	
			SELECT t1
			IF ef.Range("Z&j").value<>0 
				ef.Range("AF&j").value=ef.Range("N&j").value/ef.Range("Z&j").value&&mcw
			ENDIF 
			ef.Range("AK&j").value=ALLTRIM(approval)
			ef.ActiveSheet.Range("AG&j:AG&j").NumberFormatLocal =  "0.000"
			ef.ActiveSheet.Range("AJ&j:AJ&j").NumberFormatLocal =  "0.00"

			ef.Range("AG&j").value= ef.Range("AF&j").value*ef.Range("AE&j").value&&mcd
			ef.Range("AH&j").value=ef.Range("U&j").value*ef.Range("AF&j").value&&mch
			ef.Range("AI&j").value=ef.Range("N&j").value*ef.Range("O&j").value&&mccmb
			ef.ActiveSheet.Range("AJ&j:AJ&j").NumberFormatLocal =  "0.00"
			ef.Range("AJ&j").value=ef.Range("F&j").value*ef.Range("N&j").value&&CASH
			S1=S1+quan
			S2=S2+ef.Range("AF&j").value
			S3=S3+ef.Range("AG&j").value
			S4=S4+ef.Range("AJ&j").value
			i=i+1
			SKIP
			
		ENDDO 
		*I=I+1
		j=ALLTRIM(STR(i))
		X=ALLTRIM(STR(i-3))
		ef.Range("A&j").value='合计（Total）'
		ef.Range("N&j").value=S1	
		ef.Range("AF&j").value=S2	
		ef.Range("AG&j").value=S3		
		ef.Range("AJ&j").value=S4	
		
		i=i+1
		j=ALLTRIM(STR(i))
		SELECT T1
		GO top
		*!*	ef.Rows(i).RowHeight=1/0.0035/4
		ef.Range("A&j").value='Offer Date:'
		ef.Range("B&j").value=substr(dateid,1,4)+'.'+substr(dateid,5,2)+'.'+substr(dateid,7,2)
		ef.Range("C&j").value= 'Contact:'
		ef.Range("D&j").value=P_Title
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='Expiry Date'
		ef.Range("B&j").value=substr(effectivedate,1,4)+'.'+substr(effectivedate,5,2)+'.'+substr(effectivedate,7,2)
		ef.Range("C&j").value= 'Email:'
		ef.Range("D&j").value=P_Email
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='Currency'
		ef.Range("B&j").value=currency
		ef.Range("C&j").value= 'Tel'
		ef.Range("D&j").value='86-574-62760156, 62760540'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='Incoterm'
		ef.Range("B&j").value=incoterm
		ef.Range("C&j").value= 'Fax'
		ef.Range("D&j").value='86-574-62760807, 62702807'

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='Port of Loading'
		ef.Range("B&j").value=loading
		ef.Range("C&j").value= 'web site'
		ef.Range("D&j").value='www.cnymec.com'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='Port of Discharge'
		ef.Range("B&j").value=discharge
		ef.Range("C&j").value= ' '
		ef.Range("D&j").value='www.yaohualux.com'

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='RemarkS:'

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:F&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='1)DELIVERY TIME:'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:I&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='2)OUR GOVERMENT MAY CHANGE TAX-REBATE POLICY FROM JULY 1,  TO AVOID THE RISK OF THIS POLICY,  WE'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:I&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='CONFIRM OUR ABOVE PRICE IS BASED ON EXISTING TAX-REBATE 13%, IF THERE IS ANY TAX-REBATE POLICY CHANGE'

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:I&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='BEFORE THE SHIPMENT, WE WILL ADJUST OUR PRICE ACCORDINGLY. PLS NOTE'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:I&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='TERMS AND CONDISTION:合同条款:'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:I&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='买卖双方经协商同意按下列条款成交：'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:I&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='The undersigned Seller and Buyer have agreed to close the following transactions according to the terms and conditions set forth as below：'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:I&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='1.产品质量标准:：'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='Quality standard:：'
		ef.Range("B&j").value=standard
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='1)Product label:'
		ef.Range("B&j").value=bt
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='2)Instruction manual：'
		ef.Range("B&j").value=sms
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='3)color box descriptions'
		ef.Range("B&j").value=ch
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='4)shipping marks:'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:I&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='买卖双方经协商同意按下列条款成交：'
*!*			IF FSIZE('\lhbpic1')>0

*!*			i=i+1
*!*			j=ALLTRIM(STR(i))
*!*			ef.Rows(i).RowHeight=1/0.0035/3
*!*			ef.Cells( i,1).Activate
*!*			
*!*			ef.ActiveSheet.PictureS.Insert(OldPath+"\lhbpic1").Select
*!*			ef.Selection.ShapeRange.LockAspectRatio =.T.
*!*			Target =ef.Cells( i,1)
*!*			ef.Selection.Top = Target.Top + 1
*!*			ef.Selection.Left = Target.Left + 1	
*!*			ef.Selection.ShapeRange.Height =1/0.0035/3

*!*			*ef.Range("B&j").value="TMPLHB"+'&j'
*!*			ef.Cells( i,2).Activate
*!*			ef.ActiveSheet.PictureS.Insert(OldPath+"\lhbpic2").Select
*!*			ef.Selection.ShapeRange.LockAspectRatio =.T.
*!*			Target =ef.Cells( i,2)
*!*			ef.Selection.Top = Target.Top + 1
*!*			ef.Selection.Left = Target.Left + 1	
*!*			ef.Selection.ShapeRange.Height =1/0.0035/3
*!*			endif
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='5)container load:'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='集装箱型号数量'
		ef.Range("B&j").value=loading
		ef.Range("C&j").value=incoterm
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:I&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='（除非另有规定，“FOB”、“CFR”和“CIF”均应依照国际'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:T&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='The terms FOB,CFR or CIF shall be subject to the International Rules for the Interpretation of Trade Terms （INCOTERMS 2000） provided by International Chamber of Commerce （ICC） unless otherwise stipulated herein.）'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:B&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='3. 付款条件（Terms of Payment）：'
		ef.Range("C&j").value=NA003

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:B&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='4.BANK INFORMATION:'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:B&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='受益人银行资料'

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:B&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='BENEFICIARY NAME:'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:B&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='NINGBO YAOMING ELECTRIC CO. LTD.'

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:B&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='tel: 86-574-62760946/62702946,'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:B&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='fax:86-574-62760807'

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='BANK:'
		SELECT T3
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:T&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value=A1

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:T&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value=A2

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:T&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value=A3

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:T&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value=A4
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:T&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value=A5
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:T&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value=A6
		SELECT T1
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:T&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='5.装运期限（Time of Delivery）：'
		ef.Range("B&j").value=subs(seadate,1,4)+subs(seadate,5,2)+subs(seadate,7,2)

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:B&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='收到可以转船及分批装运之'

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:T&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='Within '+ALLTRIM(STR(sea1))+' days after receipt of '+ALLTRIM(STR(sea1))+' allowing transhipment and partial shipment.'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:T&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='6.允许溢短装（More or Less）：'

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='7.保险（Insurance）：'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:T&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='受益人银行资料按发票金额的'+ALLTRIM(STR(insurance))+'%投保'+ALLTRIM(insurclass)+'险，由'+ALLTRIM(insurcorp)+ '负责投保。'

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='7.保险（Insurance）：'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:T&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='Covering '+ALLTRIM(insurclass)+' Risks for '+ALLTRIM(STR(insurance))+'% of Invoice Value To be '+ALLTRIM(insurcorp)

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:I&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='8.品质/数量异议 （Quality/Quantity discrepancy）：'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:I&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='如买方提出索赔，凡属品质异议须于货到目的口岸之日起30天内提出，凡属数量异议须于货到目的口岸之日起15天内提出，对所装货物所提任何异议于保险公司、轮船公司、其他有关运输机构或邮递机构所负责者，卖方不负任何责任。'

		s1='In case of quality discrepancy,claim should be filed by the Buyer within 30 days after the arrival of the goods at port of destination,'
		s2='while for quantity discrepancy,claim should be filed by the Buyer within 15 days after the arrival of the goods at port of destination.'
		s3='It is understood that the Seller shall not be liable for any discrepancy of the goods shipped due to causes for which the Insurance Company,Shipping Company,other Transportation Organization/or Post Office are liable.'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:AI&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value=s1+s2+S3

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:AI&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='9.由于发生人力不可抗拒的原因，致使本合约不能履行，部分或全部商品延误交货，卖方概不负责。本合同所指的不可抗力系指不可干预、不能避免且不能克服的客观情况。'
		S1='The Seller shall not be held responsible for failure or delay in delivery of the entire lot or a portion of the goods under this Sales Contract in consequence of any Force Majeure incidents which might occur.'
		S2='Force Majeure as referred to in this contract means unforeseeable， unavoidable and insurmountable objective conditions.'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:AI&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value=S1+S2

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:AI&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='10.仲裁（Arbitration）：'

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:AI&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='因凡本合同引起的或与本合同有关的任何争议，如果协商不能解决，应提交中国国际经济贸易仲裁委员会深圳分会。按照申请仲裁时该会当时施行的仲裁规则进行仲裁。仲裁裁决是终局的，对双方均有约束力。'

		S1='Any dispute arising from or in connection with the Sales Contract shall be settled through friendly negotiation. In case no settlement can be reached，'
		S2='the dispute shall then be submitted to China International Economic and Trade Arbitration Commission （CIETAC）,'
		S3='Shenzhe Commission for arbitration in accordance with its rules in effect at the time of applying for arbitration.'
		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:AI&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value=S1+S2+S3

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:AI&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='11.通知（Notices）：'+ALLTRIM(ENOTE)

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&J:AI&J").Select
		ef.Selection.Merge
		ef.Range("A&j").value='12.本合同为中英文两种文本，两种文本具有同等效力。本合同一式'+ALLTRIM(STR(contractnum))+'份。自双方签字（盖章）之日起生效。'

		i=i+2
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='The Seller：'
		ef.Range("G&j").value='The Buyer：'

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Range("A&j").value='买方：'
		ef.Range("G&j").value='卖方：'

		i=i+1
		j=ALLTRIM(STR(i))
		ef.Cells( i,7).Activate
		ef.ActiveSheet.PictureS.Insert(OldPath+'\imgs\fangyi.jpg').Select
		ef.Selection.ShapeRange.LockAspectRatio =.T.
		Target =ef.Cells( i,7)
		ef.Selection.Top = Target.Top + 1
		ef.Selection.Left = Target.Left + 1	
		ef.Selection.ShapeRange.Height =1/0.0035/4

*!*			THISFORM.Image1.Picture=F2
	
		P_FileName='PI生成EXCEL'
		P_ID=Keytxt+':PI-4'
		DO &P_Prgs.EveryDay WITH P_FileName,P_ID,P_EditMode
		ERASE PI.xls
*!*			ef.ActiveWorkbook.SaveAs("PI.xls")
		If !File(Sys(5) + Curdir() + "PI.xls")
		    ef.ActiveWorkbook.SaveAs(Sys(5) + Curdir() + "PI.xls")
		Else
		    lcFileName = ef.GetSaveAsFilename("result", "Excel (*.xls), *.xls")
		    If !Empty(lcFileName)
		        If File(lcFileName)
		            Delete File (lcFileName)
		        Endif
		        ef.ActiveWorkbook.SaveAs(lcFileName)
		    Endif
		Endif

	CASE TL=2011100003 &&PI2EXCEL－－－－－－－发放订单

		CONd=ODBC(5)
		?SQLEXEC(CONd,"SELECT pi.*,pidetail.* ,NA003,B.MA003 MB007 "+;
		  " from pi inner join pidetail on pi.interid=pidetail.maininterid left join CMSNA  on NA001='2' and paycon =NA002 INNER JOIN INVMB A ON  code=A.MB001 "+;
		  "INNER JOIN INVMA AS B ON MB007=B.MA002 AND B.MA001='3' where pi.interid=?keyid","t1")
		SQLDISCONNECT(CONd)

		*ERASE lhbpic?

		*!*	SELECT t2
		*!*	GO top
		*!*	DO whil .not. EOF()

		*!*		STRTOFILE(FileData ,"lhbpic"+STR(classid,1))
		*!*		SKIP
		*!*	enddo	
		WAIT WINDOWS '正在读取PI打印信息...' NOWAIT 

		*!*	REPORT FORM d:\trade\报价单 PREVIEW
		m.outfilename=putfile('输出结果','发放订单','xls')
		&&取导出文件名称
		ef=CREATEOBJECT('Excel.application')
		&&调用Excel程序
		ef.Workbooks.add
		&&添加工作簿
		ef.Worksheets("sheet1").Activate
		&&激活第一个工作表
		ef.visible=.t.

		&&显示Excel界面
		*!*	ef.Cells.Select
		&&选择整张表
		ef.Selection.Font.Size = 10
		&&设置整表默认字体大小为10
		ef.range("A1:F1").Select
		&&选择标题栏所在单元格
		ef.Selection.Merge
		&&合并单元格
		*!*	with ef.range("A1")
		ef.range("A1").HorizontalAlignment=4
		ef.Rows(1).RowHeight=1/0.0035/3
		ef.Range("A1").Select
		ef.Cells(1, 1).Activate
		ef.ActiveSheet.PictureS.Insert(OldPath+"\imgs\log.gif").Select
		ef.Selection.ShapeRange.LockAspectRatio =.T.
		Target =ef.Cells(1, 1)
		ef.Selection.Top = Target.Top + 1
		ef.Selection.Left = Target.Left + 1

		ef.Range("A2").value='PI单号'
		ef.Range("B2").value='生产厂家'
		ef.Range("C2").value='ERP品号'
		ef.Range("D2").value='公司货号'
		ef.Range("E2").value='客户品号'
		ef.Range("F2").value='产品名称'
		ef.Range("G2").value='图片'
		ef.Range("H2").value='Shade'
		ef.Range("I2").value='Light Source'
		ef.Range("J2").value='Bulb (incl/excl)'
		ef.Range("K2").value='IP Rating'
		ef.Range("L2").value='Dimension'
		ef.Range("M2").value='产品颜色'
		ef.Range("N2").value='订单数量'
		ef.Range("O2").value='只／箱'
		ef.Range("P2").value='箱数'
		ef.Range("Q2").value='箱号'
		ef.Range("R2:V2").Select
		ef.Selection.Merge

		ef.Range("R2").value='SINGLE PACK中包尺寸，重量'
		ef.range("R2").HorizontalAlignment=3

		ef.Range("W2:AB2").Select
		ef.Selection.Merge
		ef.range("W2").HorizontalAlignment=3
		ef.range("W2:AB2").HorizontalAlignment=3

		ef.Range("W2").value='INNER 内包装尺寸，重量'
		ef.Range("AC2:AH2").Select
		ef.Selection.Merge

		ef.Range("AC2").value='MASTER CARTON外箱尺寸,重量'
		ef.Range("AC2:AH2").HorizontalAlignment=3

		ef.Range("AI2:AO2").Select
		ef.Selection.Merge

		ef.Range("AI2").value='PALLET托盘尺寸,重量'

		ef.range("AI2:AO2").HorizontalAlignment=3


		*!*	ef.Rows(2).RowHeight=1/0.0035/3

		ef.Range("H3").value='透光件'
		ef.Range("I3").value='光源'
		ef.Range("J3").value='是否包含灯泡'
		ef.Range("K3").value='防尘防水等级'
		ef.Range("L3").value='产品尺寸'
		ef.Range("R3").value='KG'
		ef.Range("S3").value='WIDTH长'
		ef.Range("T3").value='DEPTH宽'
		ef.Range("U3").value='HEIGHT高'
		ef.Range("V3").value='CBM'
		ef.Range("W3").value='PCS/INNER只/内包'
		ef.Range("X3").value='KG'
		ef.Range("Y3").value='WIDTH长'
		ef.Range("Z3").value='DEPTH宽'
		ef.Range("AA3").value='HEIGHT高'
		ef.Range("AB3").value='CBM'
		ef.Range("AC3").value='PCS/CTN'
		ef.Range("AD3").value='KG'
		ef.Range("AE3").value='WIDTH长'
		ef.Range("AF3").value='DEPTH宽'
		ef.Range("AG3").value='HEIGHT高'
		ef.Range("AH3").value='CBM'
		ef.Range("AI3").value='每托只数'
		ef.Range("AJ3").value='每托箱数'
		ef.Range("AK3").value='毛重'
		ef.Range("AL3").value='WIDTH长'
		ef.Range("AM3").value='DEPTH宽'
		ef.Range("AN3").value='HEIGHT高'
		ef.Range("AO3").value='CBM'

		ef.Range("AP3:AR3").Select
		ef.Selection.Merge
		ef.range("AP3").HorizontalAlignment=3
		ef.Range("AP3").value='备注（其他要求）'
		ef.Range("AS3").value='颜色英文描述'
		ef.Range("AT3").value='产品描述'
		ef.Range("AU3").value="彩盒描述"
		ef.Range("AV3").value="产品系列名"
		ef.Range("AW3").value="包装品牌名称"
		ef.Range("AX3").value="中包要求"
		ef.Range("AY3").value="中包条形码"
		ef.Range("AZ3").value="内包数量"
		ef.Range("BA3").value="内包条形码"
		ef.Range("BB3").value="外箱条形码"
		ef.Range("BC3").value="中包品号"
		ef.Range("BD3").value="内包品号"
		ef.Range("BE3").value="外箱品号"
		ef.Range("BF3").value="说明书品号"
		SELECT t1

		CURSORSETPROP("MapBinary",.T.,0)&&非常关键
		ef.ActiveSheet.Columns(1).ColumnWidth =15
		ef.ActiveSheet.Columns(2).ColumnWidth =10
		ef.ActiveSheet.Columns(3).ColumnWidth =20
		ef.ActiveSheet.Columns(4).ColumnWidth =10
		ef.ActiveSheet.Columns(5).ColumnWidth =10
		ef.ActiveSheet.Columns(6).ColumnWidth =10
		ef.ActiveSheet.Columns(7).ColumnWidth =15
		ef.ActiveSheet.Columns(8).ColumnWidth =20
		ef.ActiveSheet.Columns(9).ColumnWidth =20
		ef.ActiveSheet.Columns(10).ColumnWidth =15
		ef.ActiveSheet.Columns(11).ColumnWidth =15
		ef.ActiveSheet.Columns(12).ColumnWidth =10
		ef.ActiveSheet.Columns(13).ColumnWidth =10
		ef.ActiveSheet.Columns(14).ColumnWidth =10
		ef.ActiveSheet.Columns(15).ColumnWidth =10
		ef.ActiveSheet.Columns(16).ColumnWidth =10
		ef.ActiveSheet.Columns(17).ColumnWidth =10
		ef.ActiveSheet.Columns(18).ColumnWidth =10
		ef.ActiveSheet.Columns(19).ColumnWidth =10
		ef.ActiveSheet.Columns(20).ColumnWidth =10
		ef.ActiveSheet.Columns(21).ColumnWidth =10
		ef.ActiveSheet.Columns(22).ColumnWidth =10
		ef.ActiveSheet.Columns(23).ColumnWidth =10
		ef.ActiveSheet.Columns(24).ColumnWidth =10
		ef.ActiveSheet.Columns(25).ColumnWidth =10
		ef.ActiveSheet.Columns(26).ColumnWidth =10
		ef.ActiveSheet.Columns(27).ColumnWidth =10
		ef.ActiveSheet.Columns(28).ColumnWidth =10
		ef.ActiveSheet.Columns(29).ColumnWidth =10
		ef.ActiveSheet.Columns(30).ColumnWidth =10
		ef.ActiveSheet.Columns(31).ColumnWidth =10
		ef.ActiveSheet.Columns(32).ColumnWidth =10
		ef.ActiveSheet.Columns(33).ColumnWidth =10
		ef.ActiveSheet.Columns(34).ColumnWidth =10
		ef.ActiveSheet.Columns(35).ColumnWidth =10
		ef.ActiveSheet.Columns(36).ColumnWidth =10
		ef.ActiveSheet.Columns(37).ColumnWidth =10
		ef.ActiveSheet.Columns(38).ColumnWidth =10
		ef.ActiveSheet.Columns(39).ColumnWidth =10
		ef.ActiveSheet.Columns(40).ColumnWidth =10
		ef.ActiveSheet.Columns(41).ColumnWidth =15
		ef.ActiveSheet.Columns(42).ColumnWidth =15
		ef.ActiveSheet.Columns(43).ColumnWidth =15
		ef.ActiveSheet.Columns(44).ColumnWidth =15
		ef.ActiveSheet.Columns(45).ColumnWidth =15
		ef.ActiveSheet.Columns(46).ColumnWidth =15
		ef.ActiveSheet.Columns(47).ColumnWidth =15
		ef.ActiveSheet.Columns(48).ColumnWidth =15
		ef.ActiveSheet.Columns(49).ColumnWidth =15
		ef.ActiveSheet.Columns(50).ColumnWidth =15
		ef.ActiveSheet.Columns(51).ColumnWidth =15
		ef.ActiveSheet.Columns(52).ColumnWidth =10
		ef.ActiveSheet.Columns(53).ColumnWidth =20
		ef.ActiveSheet.Columns(54).ColumnWidth =20
		ef.ActiveSheet.Columns(55).ColumnWidth =20
		ef.ActiveSheet.Columns(56).ColumnWidth =20
		ef.ActiveSheet.Columns(57).ColumnWidth =20
		ef.ActiveSheet.Columns(58).ColumnWidth =20
		hh1=1
		hh2=0
		i=4
		go top
		DO WHILE .not. EOF()
			j=ALLTRIM(STR(i))
			ef.Rows(i).RowHeight=1/0.0035/3
			ef.Range("A&j").value=classid+'-'+STR(interid)
			ef.Range("B&j").value=SUPPLY

			ef.Range("C&j").value=CODE
		*!*		ef.ActiveSheet.Columns(1).ColumnWidth =26
			STRTOFILE(pic,OldPath+"TMPLHB"+'&j')
			*ef.Range("B&j").value="TMPLHB"+'&j'
			IF !ISNULL(PIC)
	ef.ActiveSheet.Columns(1).ColumnWidth =26
	STRTOFILE(pic,OldPath+"TMPLHB"+'&j')
	*ef.Range("B&j").value="TMPLHB"+'&j'
	ef.Cells( I,2).Activate
	ef.ActiveSheet.PictureS.Insert(OldPath+"TMPLHB"+'&j').Select
	ef.Selection.ShapeRange.LockAspectRatio =.T.
	Target =ef.Cells( I,2)
	ef.Selection.Top = Target.Top + 1
	ef.Selection.Left = Target.Left + 1	
	ef.Selection.ShapeRange.Height =1/0.0035/4
*!*					ef.Cells( I,7).Activate
*!*					ef.ActiveSheet.PictureS.Insert(OldPath+"TMPLHB"+'&j').Select
*!*					ef.Selection.ShapeRange.LockAspectRatio =.T.
*!*					Target =ef.Cells( I,7)
*!*					ef.Selection.Top = Target.Top + 1
*!*					ef.Selection.Left = Target.Left + 1	
*!*					ef.Selection.ShapeRange.Height =1/0.0035/3
			ENDIF 
			ef.Range("D&j").value=ALLTRIM(itemno)
			ef.Range("E&j").value= customcode	
			ef.Range("F&j").value=name
			ef.Range("H&j").value=shape
			ef.Range("I&j").value=lightsource
			ef.Range("J&j").value=bulb
			ef.Range("K&j").value=iprating
			ef.Range("L&j").value=size
			ef.Range("M&j").value=spec
			ef.Range("N&j").value=quan
			ef.Range("O&j").value=mcpcs
			ef.Range("P&j").value=quan/mcpcs &&boxnum
			IF RECNO()=1
				hh1=1
				hh2=quan/mcpcs+hh2
			ELSE 
				hh1=hh1+quan/mcpcs
				hh2=quan/mcpcs+hh1
			ENDIF 
			ef.Range("Q&j").value=ALLTRIM(STR(hh1)+'-'+allt(str(hh2))&&allt(str(boxfrom))+'-'+allt(str(boxto))


			ef.Range("R&j").value=spkg
			ef.Range("S&j").value=spw
			ef.Range("T&j").value=spd
			ef.Range("U&j").value=sph
			ef.Range("V&j").value=spcmb
			ef.Range("W&j").value=innerquan
			ef.Range("X&j").value=nbkgs
			ef.Range("Y&j").value=nbw
			ef.Range("Z&j").value=nbd
			ef.Range("AA&j").value=nbh
			ef.Range("AB&j").value=nbcmb
			ef.Range("AC&j").value=mcpcs
			ef.Range("AD&j").value=mckgs
			ef.Range("AE&j").value=mcw
			ef.Range("AF&j").value= mcd
			ef.Range("AG&j").value=mch
			ef.Range("AH&j").value=mccmb
			ef.Range("AI&j").value=tppcs
			ef.Range("AJ&j").value= tpquan
			ef.Range("AK&j").value=tpkg
			ef.Range("AL&j").value=tpw
			ef.Range("AM&j").value=tpd
			ef.Range("AN&j").value=tph
			ef.Range("AO&j").value=tpcmb
			ef.Range("AP&j").Select
			ef.Selection.Merge
			ef.range("AP&j").HorizontalAlignment=3	
			ef.Range("AP&j").value=note
			ef.Range("AS&j").value=codecolor
			ef.Range("AT&j").value= ALLTRIM(descripe)
			ef.Range("AU&j").value=ALLTRIM(unitname)
			ef.Range("AV&j").value=ALLTRIM(MB007)
			ef.Range("AW&j").value=ALLTRIM(package)
			ef.Range("AX&j").value=unitrequ
			ef.Range("AY&j").value=unitBARCODE
			ef.Range("AZ&j").value=INNERQUAN
			ef.Range("BA&j").value= innerbarcode
			ef.Range("BB&j").value=outerbarcode
			ef.Range("BC&j").value=unitcode
			ef.Range("BD&j").value=INNERcode
			ef.Range("BE&j").value=outercode
			ef.Range("BF&j").value=smscode

			i=i+1
			SKIP
			
		ENDDO 
		i=i+1
		j=ALLTRIM(STR(i))
		*!*	ef.Range("A&j").RowHeight=1/0.0035/4
		ef.Range("A&j").Font.Name="黑体"
		ef.Range("A&j").Font.size=14
		ef.Range("A&j").value='要求'
		i=i+1
		j=ALLTRIM(STR(i))
		SELECT t1
		I=RECCOUNT()+3
		ef.Range(ef.Cells(2,1),ef.Cells(I,58)).BorderS.LineStyle=1
		ef.Range(ef.Cells(2,1),ef.Cells(I,58)).HorizontalAlignment=3 &&水平(1-默认、2-靠左、3-居中、4-靠右、5-填充、6=两端对齐、7=跨列居中、8=分散对齐)
		ef.Range(ef.Cells(2,1),ef.Cells(I,58)).VerticalAlignment=2 &&垂直(1=靠上、2=居中、3=靠下、4=两端对齐、5=分散对齐)
		ef.Range(ef.Cells(4,1),ef.Cells(I,58)).HorizontalAlignment=2 &&水平(1-默认、2-靠左、3-居中、4-靠右、5-填充、6=两端对齐、7=跨列居中、8=分散对齐)
		WAIT windows '读取完毕' NOWAIT 	
	
	OTHERWISE 
		oldAlias=ALIAS()
	*!*		CURSORSETPROP("MapBinary",.T.,0)&&非常关键
		cond=odbc(6)
		Sqlexec(CONd,"select frx,frt from printcaption where interid=?TL ","temp")
		SQLDISCONNECT(cond)
		IF FILE("报表打印.frx")
			ERASE 报表打印.*
		ENDIF 
		SELECT temp
		IF ISNULL(frx) OR EMPTY(frx)
			cfile=''
			cfile1=''
			this.Parent.txtreport.Value=''	
		ELSE 
			cfile=frx
			cfile1=frt
		ENDIF 

		STRTOFILE(cfile,'报表打印.frx')	
		STRTOFILE(cfile1,'报表打印.frt')	

*!*			SET CLASSLIB TO Class\frx2xls
*!*			SET CLASSLIB TO Class\alap additive

	*!*	SELECT 0
	*!*	USE (HOME()+"samples\northwind\orders.dbf")
	*!*	SET ORDER TO tag customerid
	*!*	lo = SECONDS()

*!*		ofrx2xls = CREATEOBJECT("frx2xls")
*!*		ofrx2xls.rdata = oldAlias
*!*		ofrx2xls.frxname = "报表打印.frx"
*!*		ofrx2xls.frx2xls
ENDCASE

	WAIT WINDOWS '报表文件数据导出到excel完毕!' NOWAIT
	DO EveryDay WITH P_FileName,P_Id,'预览打印'
ENDPROC

PROCEDURE PreviewReport
	PARAMETERS TL
	oldAlias=ALIAS()

	DO GetReport WITH TL
	IF !EMPTY(oldAlias) AND !ISNULL(oldAlias)
	SELECT &OldAlias
	ENDIF 
	DO LOCFILE("FoxyPreviewer.App")

	REPORT FORM 报表打印  PREVIEW &&NODIALOG
	DO EveryDay WITH P_FileName,P_Id,'预览打印'
ENDPROC

PROCEDURE ModifyReport
PARAMETERS TL
	DO GetReport WITH TL
	
	F4=''
	F5=''
	MODIFY REPORT 报表打印 PROTECTED  SAVE
	Mode=MESSAGEBOX('保存修改过的报表吗?',4+32,P_CAPTION)
		IF Mode=6	
		cond=odbc(6)

		F4=CAST(filetostr('报表打印.FRX') as w)&&文件内容
		F5=CAST(filetostr('报表打印.FRT') as w)&&文件内容
	*!*		mFileName=JUSTFNAME(F2)&&文件名
		IF SQLEXEC(CONd,"update printcaption SET FRX=?F4,FRT=?F5  WHERE  interid=?TL")<0
			MESSAGEBOX('修改报表保存失败!',0+47+1,P_Caption)
			RETURN 
		ELSE 
			WAIT WINDOWS '修改成功'	 NOWAIT
		ENDIF	
		P_EditMode='Edit'

		SQLDISCONNECT(CONd)
		P_FileName='修改报表'
		P_ID=STR(CODEID)
		DO &P_Prgs.EveryDay WITH P_FileName,P_ID,P_EditMode
	ENDIF		
ENDPROC
***** Begin of ODBC
PROCEDURE ODBC
PARAMETERS TL
IF USED("Buys")
	SELECT buys
	USE
ENDIF 	
USE Buys.dbf IN 0 SHARED
*!*	SQLDISCONNECT(0)
SELECT BUYS
DECLARE INTEGER SQLConfigDataSource IN odbccp32 INTEGER, INTEGER, STRING, STRING
lnWindowHandle=0
GO tl

mNote=ALLTRIM(Des)
IF LEN(ALLTRIM(mNote))<10
	MessageBox('没有设置'+ALLTRIM(NAME)+'数据源，请与系统管理员用Config文件配置正确的odbc！',16,'警告')
	RETURN 
ENDIF 	
**先试图修改已有的ODBC，如果不存在，返回0。
lreturn=SQLConfigDataSource(lnWindowHandle, 2, &mNote)
SQLSETPROP(0,'DispLogin',3)
IF lreturn=0 &&不存在，则添加新的ODBC
	lreturn=SQLConfigDataSource(lnWindowHandle, 1, &mNote)
	IF lreturn=0 &&失败
*!*			MessageBox('添加'+ALLTRIM(NAME)+'数据源失败，请与系统管理员联系！',16,'警告')
	ENDIF
ENDIF
&&DRIVER=SQL Server;SERVER=GZAPPSERVER;UID=sa;PWD=hongweilu8341;APP=Microsoft Visual FoxPro;WSID=GZAPPSERVER;Network=DBMSLPCN
mNote=ALLTRIM(OpenPsd(Note))
gnConnhandle = SQLSTRINGCONNECT(mNote)
SQLSETPROP(0,'DispLogin',3)
SQLSETPROP(0,"IdleTimeout",0) 
*!*	SQLSETPROP(0,"ConnectTimeOut",300)
IF gnConnhandle>0
	ODBCOK=0
	* MESSAGEBOX(ALLTRIM(NAME)+'连接成功！')
ELSE
	IF RECNO()=5 OR RECNO()=12
		*MESSAGEBOX('连接失败，请与系统管理员联系！',16,'警告') 
		*quit &&连接不成功则退出系统。
	ENDIF
	ODBCOK=RECNO()
ENDIF
RETURN gnConnhandle
USE
ENDPROC
***** End of  ODBC
*****
***** Begin of  ClosePsd
PROCEDURE ClosePsd
PARAMETERS mPassWord
mLenWord=LEN(ALLT(mPassWord))
ML=1
PASS=""
FOR I=1 TO mLenWord
	IF mL>10
		mL=10
	ENDIF	
	nPASSWORD=CHR(ASC(SUBSTR(ALLT(mPassWord),I,1))+ML)
	ML=ML+1
	PASS=PASS+nPASSWORD
ENDFOR
RETURN Pass
ENDPROC
***** End of  ClosePsd

***** Begin of  OpenPsd
PROCEDURE OpenPsd
PARA	mPassWord
mLenWord=LEN(ALLT(mPassWord))
ML=1
PASS=""
FOR I=1 TO mLenWord
	IF mL>10
		mL=10
	ENDIF	
	nPASSWORD=CHR(ASC(SUBSTR(ALLT(mPassWord),I,1))-ML)
	ML=ML+1
	PASS=PASS+nPASSWORD
ENDFOR
RETURN Pass
ENDPROC

FUNCTION OpenDB
LPARAMETERS tcDBFname,tcAliasName,tlOpenExclusive
LOCAL lcErrorHandExp,isNoError,isOpenError,lcErrorMsg
lcErrorHandExp = on("error")

IF !USED('&tcDBFname')
	OPEN DATABASE MyMIS
	USE '&tcDBFname' IN 0
ENDIF	


on error &lcErrorHandExp
retu isNoError
ENDFUNC 

*-- ===============================================================
FUNCTION CloseDB
LPARAMETERS tcAliasName
IF USED("&tcAliasName")
   SELECT "&tcAliasName"
   USE 
ENDIF
RETURN
ENDFUNC 
*-- ===============================================================
*-- 显示 wait 信息
*-- ===============================================================
Func ShowWait
para wait_info,wait_second
local lcWaitMode
if empty(wait_info)
	wait clear
	retu
endif
if type("wait_info") <> "C"
	wait_info = ""
endif
if type("wait_second") <> "N"
	lcWaitMode = "nowait"
else
	lcWaitMode = "timeout "+allt(str(wait_second))
endif
set message to wait_info
*-- wait window wait_info &lcWaitMode
*-- 使提示的信息居中
lcInfoCaption = "          === 提示信息 ===          "
lnInfoLen	= len(lcInfoCaption)
lnWaitInfo	= len(wait_info)
if	lnInfoLen	>	lnWaitInfo
	lcAddCaption	= ""
	lcAddWaitInfo	= repl(" ",(lnInfoLen-lnWaitInfo)/2)
else
	lcAddCaption	= repl(" ",(lnWaitInfo-lnInfoLen)/2)
	lcAddWaitInfo	= ""
endif

wait window lcAddCaption + lcInfoCaption ;
	+chr(13)+chr(13)+ ;
	lcAddWaitInfo + wait_info ;
	at ;
	SYSMETRIC(2)/17/2 - 4 ,;
	SYSMETRIC(1)/6.4/2-iif(lnWaitInfo>lnInfoLen,lnWaitInfo,lnInfoLen)/2 ;
	&lcWaitMode
RETURN
ENDFUNC 
*-- ===============================================================
*-- 打开连接
*-- ===============================================================
FUNCTION  OpenURL
LPARAMETERS tcURL

DECLARE INTEGER ShellExecute ;
    IN SHELL32.DLL ;
    INTEGER nWinHandle,;
    STRING cOperation,; 
    STRING cFileName,;
    STRING cParameters,;
    STRING cDirectory,;
    INTEGER nShowWindow
return shellexecute(0,"open","&tcURL","","",1)
ENDFUNC 
*************    自定义函数 结束   *****************************

PROCEDURE ycorder
lnSecs = SECONDS()
con=odbc(5)
Lcmsg='读取ERP预测订单记录...'
WAIT WINDOW  LcMsg  NOCLEAR NOWAIT AT SROW()/2, (SCOLS()-LEN(lcMsg))/2 
if sqlexec(con,"SELECT  COPMF.MF001 as 备料编号,CASE WHEN COPMA.MA002 IS NULL THEN ''"+;
 " ELSE COPMA.MA002 END as 客户名称,CASE WHEN COPMA1.MA002 IS NULL THEN '' "+;
 " ELSE COPMA1.MA002 END as 预测客户名,case when INVMB.MB080 IS NULL THEN '' ELSE rtrim(INVMB.MB080) END as 公司货号,"+;
"cast(COPMF.UDF01 as char(12)) as 客户货号,"+;
"COPMF.MF003 as 品号,"+;
"COPMF.MF004 as 名称,"+;
"COPMF.MF005 as 颜色,"+;
"COPMF.MF010 as 单位,"+;
"SUBSTRING(COPMF.MF006,1,4)+'.'+SUBSTRING(COPMF.MF006,5,2)+'.'+SUBSTRING(COPMF.MF006,7,2) as 要求完成日,"+;
"COPMF.MF008 as 数量,"+;
"CAST(COPMF.MF013 AS CHAR(60)) as 备注,"+;
"COPMF.UDF53 as 每箱只数,"+;
"COPMF.MF009 as 备料已使用,"+;
"COPMF.MF008-COPMF.MF009 as  备料可用量,"+;
"RTRIM(COPTC.TC001)+COPTC.TC002 as 使用的订单,"+;
"COPTD.TD008 as 订单数量,"+;
"COPTD.TD013 as 订单交货 "+;
"FROM COPMF as COPMF  Left JOIN COPTD as COPTD On COPMF.MF001=COPTD.TD015 and COPMF.MF002=COPTD.TD028 AND COPTD.TD021='Y' and COPMF.MF003=COPTD.TD004 "+;
"and  (COPTD.TD016<>'y' OR (COPTD.TD016='y' AND COPTD.TD009>0) )  Left JOIN INVMB as INVMB "+;
"On COPMF.MF003=INVMB.MB001 Left JOIN COPTC as COPTC On COPTD.TD001=COPTC.TC001 AND COPTD.TD002=COPTC."+;
"TC002  left join COPME ON MF001=ME001 Left JOIN COPMA as COPMA On COPME.ME002=COPMA.MA001 "+;
" Left JOIN COPMA as COPMA1 On SUBSTRING(COPME.UDF02,1,10)=COPMA1.MA001 "+;
" WHERE   (COPMF.MF008-COPMF.MF009)>0 "+;
"&p_Ass"+;
"&f2"+;
" ORDER BY COPMF.MF001 ","tmp")<0 &&COPMF.MF001 like '228%' AND
WAIT WINDOW '???'
ENDIF 

*!*	if sqlexec(con,"SELECT  COPMF.MF001 as 备料编号,CASE WHEN COPMA.MA002 IS NULL THEN ''"+;
*!*	 " ELSE COPMA.MA002 END as 客户名称,CASE WHEN COPMA1.MA002 IS NULL THEN '' "+;
*!*	 " ELSE COPMA1.MA002 END as 预测客户名称,rtrim(INVMB.MB080) as 公司货号,"+;
*!*	"cast(COPMF.UDF01 as char(12)) as 客户货号,"+;
*!*	"COPMF.MF003 as 品号,"+;
*!*	"COPMF.MF004 as 名称,"+;
*!*	"COPMF.MF005 as 颜色,"+;
*!*	"COPMF.MF010 as 单位,"+;
*!*	"COPMF.MF006 as 要求完成日,"+;
*!*	"COPMF.MF008 as 数量,"+;
*!*	"CAST(COPMF.MF013 AS CHAR(60)) as 备注,"+;
*!*	"COPMF.UDF53 as 每箱只数,"+;
*!*	"COPMF.MF009 as 备料已使用,"+;
*!*	"COPMF.MF008-COPMF.MF009 as  备料可用量,"+;
*!*	"RTRIM(COPTC.TC001)+COPTC.TC002 as 使用的订单,"+;
*!*	"COPTD.TD008 as 订单数量,"+;
*!*	"COPTD.TD013 as 订单交货 "+;
*!*	"FROM COPMF as COPMF  "+;
*!*	"Left JOIN COPTD as COPTD On COPMF.MF001=COPTD.TD015 and COPMF.MF002=COPTD.TD028 "+;
*!*	"Left JOIN INVMB as INVMB On COPMF.MF003=INVMB.MB001 "+;
*!*	"Left JOIN COPTC as COPTC On COPTD.TD001=COPTC.TC001 AND COPTD.TD002=COPTC.TC002 "+;
*!*	"left join COPME ON MF001=ME001 Left JOIN COPMA as COPMA On COPME.ME002=COPMA.MA001 "+;
*!*	"Left JOIN COPMA as COPMA1 On SUBSTRING(COPME.UDF02,1,10)=COPMA1.MA001 "+;
*!*	 "WHERE  (SUBSTRING(COPMF.MF001,8,2)= '30' AND SUBSTRING(COPMF.MF001,1,3)= '222' and (COPMF.MF008-COPMF.MF009)>0) ORDER BY COPMF.MF001","tmp1")<0
*!*	WAIT WINDOWS '????'
*!*	ENDIF
*!*	closedb("tmplhb")
*!*	SQLDISCONNECT(con)
*!*	SELECT tmp1
*!*	COPY TO tmplhb
*!*	SELECT tmp
*!*	APPEND FROM tmplhb
*SELECT  COPMF.MF001 as 备料编号,CASE WHEN COPMA.MA002 IS NULL THEN ''"+;
 " ELSE COPMA.MA002 END as 客户名称,CASE WHEN COPMA1.MA002 IS NULL THEN '' "+;
 " ELSE COPMA1.MA002 END as 预测客户名称,rtrim(INVMB.MB080) as 公司货号,"+;
"cast(COPMF.UDF01 as char(12)) as 客户货号,"+;
"COPMF.MF003 as 品号,"+;
"COPMF.MF004 as 名称,"+;
"COPMF.MF005 as 颜色,"+;
"COPMF.MF010 as 单位,"+;
"COPMF.MF006 as 要求完成日,"+;
"COPMF.MF008 as 数量,"+;
"CAST(COPMF.MF013 AS CHAR(60)) as 备注,"+;
"COPMF.UDF53 as 每箱只数,"+;
"COPMF.MF009 as 备料已使用量,"+;
"COPMF.MF008-COPMF.MF009 as  备料可用量,"+;
"RTRIM(COPTC.TC001)+COPTC.TC002 as 使用的订单号,"+;
"COPTD.TD008 as 订单数量,"+;
"COPTD.TD013 as 订单交货 "+;
"FROM COPMF as COPMF  Left JOIN COPTD as COPTD On COPMF.MF001=COPTD.TD015 and COPMF.MF002=COPTD.TD028 AND COPTD.TD021='Y' "+;
"and  (COPTD.TD016<>'y' OR (COPTD.TD016='y' AND COPTD.TD009>0) )  Left JOIN INVMB as INVMB "+;
"On COPMF.MF003=INVMB.MB001 Left JOIN COPTC as COPTC On COPTD.TD001=COPTC.TC001 AND COPTD.TD002=COPTC."+;
"TC002  left join COPME ON MF001=ME001 Left JOIN COPMA as COPMA On COPME.ME002=COPMA.MA001 "+;
" Left JOIN COPMA as COPMA1 On SUBSTRING(COPME.UDF02,1,10)=COPMA1.MA001 "+;
" WHERE (COPMF.MF008-COPMF.MF009)>0"+;
" &p_Ass"+;
" &f2"+;
" ORDER BY COPMF.MF001 UNION ALL "+;
"
	
SELECT DISTINCT 使用的订单  FROM tmp WHERE !ISNULL(使用的订单) AND SUBSTR(使用的订单,1,3)<>'223' INTO CURSOR TMPORDER &&

SELECT DISTINCT 备料编号,客户名称,预测客户名,"'"+公司货号 as 公司货号,客户货号,要求完成日,名称,颜色,单位,SUM(数量) AS 数量,每箱只数,000000.0 AS 箱数,SPACE(10) AS 箱号,;
 000000 as 已使用,000000 AS 剩余库存,000000 样品,品号  FROM TMP  ORDER BY 备料编号 GROUP BY 1,2,3,4,5,6,7,8,9,11,12,13,14,15,16,17 INTO CURSOR TMPBL READWRITE 
 
 replace 箱数 WITH 数量/每箱只数 FOR 每箱只数<>0
 replace 箱号 WITH '1 - '+STR(IIF(INT(箱数)<>箱数,箱数+1,箱数),5,1)
SQL_STR=''
 CSTR=''
 
*!*	*!*	  UNION ALL "+;
*!*	"SELECT  COPMF.MF001 as 备料编号,CASE WHEN COPMA.MA002 IS NULL THEN ''"+;
*!*	 " ELSE COPMA.MA002 END as 客户名称,CASE WHEN COPMA1.MA002 IS NULL THEN '' "+;
*!*	 " ELSE COPMA1.MA002 END as 预测客户名称,rtrim(INVMB.MB080) as 公司货号,"+;
*!*	"cast(COPMF.UDF01 as char(12)) as 客户货号,"+;
*!*	"COPMF.MF003 as 品号,"+;
*!*	"COPMF.MF004 as 名称,"+;
*!*	"COPMF.MF005 as 颜色,"+;
*!*	"COPMF.MF010 as 单位,"+;
*!*	"COPMF.MF006 as 要求完成日,"+;
*!*	"COPMF.MF008 as 数量,"+;
*!*	"CAST(COPMF.MF013 AS CHAR(60)) as 备注,"+;
*!*	"COPMF.UDF53 as 每箱只数,"+;
*!*	"COPMF.MF009 as 备料已使用量,"+;
*!*	"COPMF.MF008-COPMF.MF009 as  备料可用量,"+;
*!*	"RTRIM(COPTC.TC001)+COPTC.TC002 as 使用的订单号,"+;
*!*	"COPTD.TD008 as 订单数量,"+;
*!*	"COPTD.TD013 as 订单交货 "+;
*!*	"FROM COPMF as COPMF  "+;
*!*	"Left JOIN COPTD as COPTD On COPMF.MF001=COPTD.TD015 and COPMF.MF002=COPTD.TD028 "+;
*!*	"Left JOIN INVMB as INVMB On COPMF.MF003=INVMB.MB001 "+;
*!*	"Left JOIN COPTC as COPTC On COPTD.TD001=COPTC.TC001 AND COPTD.TD002=COPTC.TC002 "+;
*!*	"left join COPME ON MF001=ME001 Left JOIN COPMA as COPMA On COPME.ME002=COPMA.MA001 "+;
*!*	"Left JOIN COPMA as COPMA1 On SUBSTRING(COPME.UDF02,1,10)=COPMA1.MA001 "+;
*!*	 "WHERE  (SUBSTRING(COPMF.MF001,8,2)= '30' AND SUBSTRING(COPMF.MF001,1,3)= '222' and (COPMF.MF008-COPMF.MF009)>0) ORDER BY COPMF.MF001 ascSELECT A.*,SUM(B.订单数量) 订单总是 FROM TMPBL A LEFT JOIN TMPORDER B ON A.品号=B.品号 GROUP BY 1,2,3,4,5,6,7,8,9,10 INTO CURSOR CUR_TMP
*!*	 

SQL_STR="SELECT space(11) 备料编号,space(60) 客户名称,space(60) 预测客户名,space(12) 公司货号,space(10) 要求完成日,space(12) 客户货号,SPACE(60) 名称, space(60) 颜色,"
SQL_STR=SQL_STR+"SPACE(4) 单位,000000 数量,000000 箱数,000000 每箱只数,SPACE(10) 箱号,SPACE(60) 备注,000000 as 已使用,000000 AS 剩余库存,000000 样品,SPACE(20) 品号"
SELECT '000000 AS Y' + 使用的订单 AS STR_C FROM TMPORDER  INTO CURSOR TMP1
*!*	IF RECCOUNT()<240
*!*	xx=RECCOUNT()
*!*	ELSE
*!*	xx=240
*!*	endif
IF RECCOUNT()>=200
	MESSAGEBOX('使用的订单数量超出系统极限200个,禁止导出!',0+47+1,P_Caption)
	RETURN
ENDIF 	
FOR I = 1 TO RECCOUNT()
     GO I
     CSTR=CSTR+','+ALLTRIM(STR_C)+';'+CHR(13)+CHR(10)
ENDFOR
 
SQL_STR=SQL_STR +CSTR+' FROM  TMPORDER where 1=2 INTO CURSOR RESU READWRITE '
EXECSCRIPT(SQL_STR)	
SELECT TMPBL
XX=RECCOUNT()

GO TOP
DO WHIL .NOT. EOF()
	SCATTER NAME oTest
	P_VICE=备料编号
	TXTKEY=品号
	SELECT RESU 
	APPEND BLANK 
	GATHER NAME oTest
	SELECT TMPBL
	closedb("cctmo")
	SELECT 使用的订单,订单数量,备料编号 FROM TMP WHERE 品号=TXTKEY AND !ISNULL(使用的订单)  AND 备料编号=P_VICE INTO CURSOR cctmo &&AND  SUBSTR(使用的订单号,1,3)<>'223'

	GO TOP
	DO WHIL .NOT. EOF() 
		CCTB=订单数量
		KEYTXT='Y'+ALLTRIM(使用的订单)
		P_Ass=使用的订单
		P_VICE=备料编号
		CLOSEDB("A223")
		CLOSEDB("A222")
		CLOSEDB("A224")
		CLOSEDB("A225")
		SELECT 备料编号,数量,品号 FROM TMP WHERE 品号=TXTKEY AND 备料编号=P_VICE GROUP BY 1,2,3 INTO CURSOR A225
		SELECT SUM(数量) AS A224 FROM A225 INTO CURSOR A224
		SELECT SUM(订单数量) AS A223 FROM TMP WHERE SUBSTR(使用的订单,1,3)='223' AND 品号=TXTKEY AND 备料编号=P_VICE INTO CURSOR A223
		SELECT SUM(订单数量) AS A222 FROM TMP WHERE SUBSTR(使用的订单,1,3)<>'223' AND 品号=TXTKEY AND 备料编号=P_VICE INTO CURSOR A222
		SELECT A223
		
		IF ISNULL(A223.A223) OR RECCOUNT()<1
			X1=0
			x3=0
		ELSE
			X1=A223.A223
			SELECT RESU 
			REPLACE 样品 WITH X1
		ENDIF
		SELECT A222
		IF ISNULL(A222.A222) OR RECCOUNT()<1
			X2=0
			x4=0
		ELSE
			X2=A222.A222
		ENDIF
		X6=A224.A224
		SELECT RESU 
		IF FCOUNT( )>235
			xx=FCOUNT()
		ELSE
			xs=235
		ENDIF 	
		FOR gnCount = 17 TO FCOUNT( )
			IF  FIELD(gnCount)=KEYTXT &&**FIELD(&P_Ass)=P_Ass
				REPLACE &KEYTXT WITH CCTB
				EXIT
			ENDIF
		NEXT
		REPLACE 数量 WITH X6
		REPLACE 已使用 WITH X1+X2
		replace 剩余库存 WITH 数量-X1-X2
		SELECT cctmo
		SKIP
	ENDDO
	SELECT resu
	replace 剩余库存 WITH 数量-已使用 all
	SELECT	TMPBL
	Lcmsg='数据整理中：'+STR(RECNO())+'/'+STR(XX)+'...'
	WAIT WINDOW  LcMsg  NOCLEAR NOWAIT AT SROW()/2, (SCOLS()-LEN(lcMsg))/2 
		SKIP
ENDDO
	lcmsg =  "本次操作耗时： " +  allt(TRANS(SECONDS()-lnSecs,"999.99")) + " 秒 " 
	WAIT WINDOW  LcMsg   NOWAIT 	
	SELECT RESU 
	P_ReportFile='预测销售订单统计表'
	P_ReportName=P_ReportFile
 	COPY TO '&P_ReportFile' csv
	
	P_FileName='预测销售订单统计表'
	P_Id='预测销售订单统计表'
	P_EditMode='导出EXCEL'
	DO &P_Prgs.EveryDay WITH P_FileName,P_Id,P_EditMode
	DECLARE  INTEGER  ShellExecute  IN  "Shell32.dll"  ;  
	INTEGER  hwnd,  ;  
	STRING  lpVerb,  ;  
	STRING  lpFile,  ;  
	STRING  lpParameters,  ;  
	STRING  lpDirectory,  ;  
	LONG  nShowCmd  
	 
	*  打开  Word  来编辑文件  "c:\mywordfile.doc"  
	=Shellexecute(0,"Open",P_ReportName+'.csv',"","",0)  
  
ENDPROC

PROCEDURE maxinteridt
PARAMETERS TABLENAME

CON5=ODBC(6)
SQLEXEC(CON5,"SELECT id  FROM sixplusone..tablemaxid WHERE UPPER(tablename)=UPPER('&TABLENAME')" ,'tempinsert')
SELECT tempinsert
T=tempinsert.ID
IF YEAR(DATE())*1000000+MONTH(DATE())*10000>T
	P_ChkBill=YEAR(DATE())*1000000+MONTH(DATE())*10000
	CKEYID=STR(P_ChkBill)
	SQLEXEC(con5,"UPDATE sixplusone..tablemaxid SET id='&CKEYID' WHERE UPPER(tablename)=UPPER('&TABLENAME') ")
ELSE
	P_ChkBill=T
	CKEYID=STR(P_ChkBill+1)
	SQLEXEC(con5,"UPDATE sixplusone..tablemaxid SET id='&CKEYID' WHERE UPPER(tablename)=UPPER('&TABLENAME') ")
ENDIF
IF USED("tempinsert")
	SELECT tempinsert
	USE
ENDIF	
SQLDISCONNECT(con5)
RETURN P_ChkBill
ENDPROC
PROCEDURE maxinterid
PARAMETERS TABLENAME

CON5=ODBC(6)
SQLEXEC(CON5,"SELECT id  FROM tablemaxid WHERE UPPER(tablename)=UPPER('&TABLENAME')" ,'tempinsert')
SELECT tempinsert
T=tempinsert.ID
IF YEAR(DATE())*1000000+MONTH(DATE())*10000>T
	P_ChkBill=YEAR(DATE())*1000000+MONTH(DATE())*10000
	CKEYID=STR(P_ChkBill)
	SQLEXEC(con5,"UPDATE tablemaxid SET id='&CKEYID' WHERE UPPER(tablename)=UPPER('&TABLENAME') ")
ELSE
	P_ChkBill=T
	CKEYID=STR(P_ChkBill+1)
	SQLEXEC(con5,"UPDATE tablemaxid SET id='&CKEYID' WHERE UPPER(tablename)=UPPER('&TABLENAME') ")
ENDIF
IF USED("tempinsert")
	SELECT tempinsert
	USE
ENDIF	
SQLDISCONNECT(con5)
RETURN P_ChkBill
ENDPROC

PROCEDURE maxorderid
PARAMETERS TABLENAME

CON5=ODBC(6)
SQLEXEC(CON5,"SELECT id  FROM tablemaxid WHERE UPPER(tablename)=UPPER('&TABLENAME')" ,'tempinsert')
SELECT tempinsert
T=tempinsert.ID
IF YEAR(DATE())*10000+MONTH(DATE())*100>T
	P_ChkBill=YEAR(DATE())*10000+MONTH(DATE())*100
	CKEYID=STR(P_ChkBill)
	SQLEXEC(con5,"UPDATE tablemaxid SET id='&CKEYID' WHERE UPPER(tablename)=UPPER('&TABLENAME') ")
ELSE
	P_ChkBill=T
	CKEYID=STR(P_ChkBill+1)
	SQLEXEC(con5,"UPDATE tablemaxid SET id='&CKEYID' WHERE UPPER(tablename)=UPPER('&TABLENAME') ")
ENDIF
IF USED("tempinsert")
	SELECT tempinsert
	USE
ENDIF	
SQLDISCONNECT(con5)
RETURN P_ChkBill
ENDPROC

PROCEDURE everyday
PARA mFile,mId,mEditMode
cmac=getmac()
CPUSER=P_UserName+'/'+ALLTRIM(SYS(0))
CON5=ODBC(6)
SQLEXEC(CON5,"execute everylog '&CPUSER','&mFile','&mId','&mEditMode'",'&cmac')
SQLDISCONNECT(con5)
RETURN 
ENDPROC

Function ReduceMemory()

Declare Integer SetProcessWorkingSetSize In kernel32 As SetProcessWorkingSetSize ;
Integer hProcess , ;
Integer dwMinimumWorkingSetSize , ;
Integer dwMaximumWorkingSetSize
Declare Integer GetCurrentProcess In kernel32 As GetCurrentProcess
nProc = GetCurrentProcess()
bb = SetProcessWorkingSetSize(nProc,-1,-1)
RETURN 

ENDFUNC 

FUNCTION GetCpu
LOCAL oWMI AS OBJECT,oLocal AS OBJECT,oHARDWARE AS OBJECT,object1 AS OBJECT,lcCPUID,LcMAC,lcHDID,lcSerial  
oWMI=CREATEOBJECT("WbemScripting.SWbemLocator")  
oLocal=oWMI.ConnectServer(".",  "root\cimv2")  
oHARDWARE=oLocal.ExecQuery("SELECT * FROM Win32_Processor")  
FOR EACH object1 IN oHARDWARE  
    lcCPUID=object1.Properties_('ProcessorId').VALUE  
    EXIT  
ENDFOR  
oHARDWARE=oLocal.ExecQuery("SELECT * FROM Win32_PhysicalMedia")  
FOR EACH object1 IN oHARDWARE  
    lcHDID=object1.Properties_('SerialNumber').VALUE  
    EXIT  
ENDFOR  
oHARDWARE=oLocal.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration Where IPEnabled=1")  
FOR  EACH  object1  IN  oHARDWARE  
    LcMAC=object1.Properties_('MACAddress').VALUE  
    EXIT  
ENDFOR 

RETURN lcCPUID 
ENDFUNC

FUNCTION Getmac
LOCAL oWMI AS OBJECT,oLocal AS OBJECT,oHARDWARE AS OBJECT,object1 AS OBJECT,lcCPUID,LcMAC,lcHDID,lcSerial  
oWMI=CREATEOBJECT("WbemScripting.SWbemLocator")  
oLocal=oWMI.ConnectServer(".",  "root\cimv2")  
*!*	oHARDWARE=oLocal.ExecQuery("SELECT * FROM Win32_Processor")  
*!*	FOR EACH object1 IN oHARDWARE  
*!*	    lcCPUID=object1.Properties_('ProcessorId').VALUE  
*!*	    EXIT  
*!*	ENDFOR  
*!*	oHARDWARE=oLocal.ExecQuery("SELECT * FROM Win32_PhysicalMedia")  
*!*	FOR EACH object1 IN oHARDWARE  
*!*	    lcHDID=object1.Properties_('SerialNumber').VALUE  
*!*	    EXIT  
*!*	ENDFOR  
oHARDWARE=oLocal.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration Where IPEnabled=1")  
FOR  EACH  object1  IN  oHARDWARE  
    LcMAC=object1.Properties_('MACAddress').VALUE  
    EXIT  
ENDFOR 

RETURN LcMAC
ENDFUNC

*!*	?'CPU序号：',lcCPUID  
*!*	?'硬盘序号：',lcHDID  
*!*	?'网卡MAC地址：',LcMAC
PROCEDURE PROCerrOR
PARAMETER errnum,MESSAGE
IF  (ALLTRIM(STR(errnum)))="125"
	RELE WINDOW
	RETU
ENDIF
ENDPROC

Function getjpg(openfile)
PARAMETERS openfile
*!*            *把BMP转为JPG
openfile1=Juststem(openfile)+".bmp"
savefile1=Juststem(openfile)+".jpg"
lqEncoderClsID_BMP=0h00F47C55041AD3119A730000F81EF32E &&BMP
lqEncoderClsID_JPG=0h01F47C55041AD3119A730000F81EF32E &&JPG
*!*        lqEncoderClsID_GIF=0h02F47C55041AD3119A730000F81EF32E &&GIF
*!*        lqEncoderClsID_TIF=0h05F47C55041AD3119A730000F81EF32E &&TIF
*!*        lqEncoderClsID_PNG=0h06F47C55041AD3119A730000F81EF32E &&PNG
Declare Long GdipLoadImageFromFile In GDIPlus.Dll String cFile, Long @ nativeImage
Declare Long GdipSaveImageToFile In GDIPlus.Dll Long nativeImage, String cFile, ;
        String EncoderClsID, String EncoderParameters
Declare Long GdipDisposeImage In GDIPlus.Dll Long nativeImage
lcInputFile=Strconv(openfile1+Chr(0),5)
lcOutputFile=Strconv(savefile1+Chr(0),5)
lnImage=0
GdipLoadImageFromFile(lcInputFile,@lnImage)
GdipSaveImageToFile(lnImage, lcOutputFile, Evaluate('lqEncoderClsID_'+Upper(Justext(savefile1))), Null)
GdipDisposeImage(lnImage)
Clear Dlls
*!*        ERASE &openfile1
Endfunc 


PROCEDURE getipaddress

	Local oWMI As Object,oLocal As Object,oHARDWARE As Object,object1 As Object,lcCPUID,LcMAC,lcHDID,lcSerial
	oWMI=Createobject("WbemScripting.SWbemLocator")
	oLocal=oWMI.ConnectServer(".", "root\cimv2")

	oHARDWARE=oLocal.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration Where IPEnabled=1")
	For Each object1 In oHARDWARE
	    LcIP=object1.Properties_('IPAddress').Value
	    Exit
	ENDFOR 
	RETURN LcIP


ENDPROC

PROCEDURE errHandler

   PARAMETER merror, mess, mess1, mprog, mlineno

   *CLEAR

   ? 'Error number: ' + LTRIM(STR(merror))

   WAIT WINDOWS 'Error message: ' + mess

   ? 'Line of code with error: ' + mess1

   ? 'Line number of error: ' + LTRIM(STR(mlineno))

   ? 'Program with error: ' + mprog

WAIT WINDOWS 'Line of code with error: ' + mess1
ENDPROC
Function VerifyEmail(tcAddress)
     Local oReg as vbscript.regexp
     oReg = NewObject('vbscript.regexp')
     oReg.Pattern = '^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$'
     Return oReg.Test(tcAddress)
EndFunc

function setpager
parameters pagername,pagerwith,pagerheight
declare integer OpenPrinter in winspool.drv string,integer @,integer
declare integer ClosePrinter in winspool.drv integer
declare integer AddForm in winspool.drv integer,integer,string  @
declare integer HeapCreate in kernel32 integer,integer,integer
declare integer HeapAlloc in kernel32 integer,integer,integer
declare integer HeapFree in kernel32 integer,integer,integer
declare HeapDestroy in kernel32 integer  
declare RtlMoveMemory in kernel32 AS RtlCopy integer,string,integer
local lhPrinter
lhPrinter=0
if OpenPrinter(set("Printer",2),@lhPrinter,0)=0
  return .F.
endif
local hHeap,lnFormName,lcForm,lnretval
hHeap=HeapCreate(0,4096,0)
lnFormName=HeapAlloc(hHeap,0,len(pagername)+1) 
=RtlCopy(lnFormName,pagername+chr(0),LEN(pagername)+1)
lcForm=numtolong(0)+;
numtolong(lnFormName)+;
numtolong(pagerwith*1000) +;
numtolong(pagerheight*1000)+;
numtolong(0)+;
numtolong(0)+;
numtolong(pagerwith*1000)+;
numtolong(pagerheight*1000)
lnretval=AddForm(lhPrinter,1,@lcForm) 
=HeapFree(hHeap,0,lnFormName)
=ClosePrinter(lhPrinter)
if hHeap<>0
  HeapDestroy(hHeap)
endif
return !lnretval=0
endfunc
function numtolong(tnNum)
local lcString
lcString=space(4)
declare RtlMoveMemory in kernel32 AS RtlCopyLong strinG @,Long @,Long
=RtlCopyLong(@lcString,bitor(tnNum,0),4)
return lcString
ENDFUNC

 *!* -------------------------------------------------------------
*!* 作者: dkfdtf - 2008.03.03
*!* 功能: 保存当前的屏幕图像到指定的文件
*!* 入口: tcFile - 要保存的文件 路径+文件名+扩展名
*!* 出口: 保存是否成功
*!* 注释: 该方法根据文件扩展名判断要保存到的图形文件类型
*!* 　　　当前仅支持 bmp/jpg/gif/png/tif 缺省保存为 bmp
*!* 授权: 你可以任意修改和发布它, 但请不要去掉原作者名
*!* 运行环境: 需要 vfp9
*!* -------------------------------------------------------------
FUNCTION SaveScreen( tcFile )

#define CF_BITMAP        2
#define VK_SNAPSHOT      0x2C
#define KEYEVENTF_KEYUP  0x0002

LOCAL cFileExtName, cEncoder, iInputBuf, iResult
LOCAL hBitmap, hToken, hGdipBitmap

m.cFileExtName = LOWER( JUSTEXT( m.tcFile ))

decl_api()

keybd_event( VK_SNAPSHOT, 0, 0, 0 )
keybd_event( VK_SNAPSHOT, 0, KEYEVENTF_KEYUP, 0 )
INKEY(0.1)

m.iResult = -1
IF ( 0 != OpenClipboard( 0 ))
    m.hBitmap = GetClipboardData( CF_BITMAP )
    IF ( 0 != m.hBitmap )
        m.hToken = 0
        m.iInputBuf = 0h01 + REPLICATE( CHR(0),15 )
        IF ( 0 == GdiplusStartup( @ m.hToken, @ m.iInputBuf, 0 ))
            m.hGdipBitmap = 0
            IF ( 0 == GdipCreateBitmapFromHBITMAP( ;
                m.hBitmap, 0, @ m.hGdipBitmap ))
                m.cEncoder = ICASE( ;
                'jpg' == m.cFileExtName, 0h01, ;
                'gif' == m.cFileExtName, 0h02, ;
                'tif' == m.cFileExtName, 0h05, ;
                'png' == m.cFileExtName, 0h06, 0h00 ) ;
                + 0hF47C55041AD3119A730000F81EF32E
                m.iResult = GdipSaveImageToFile( ;
                    m.hGdipBitmap, ;
                    STRCONV( m.tcFile+CHR(0), 5 ), ;
                    m.cEncoder, 0 )
                GdipDisposeImage( m.hGdipBitmap )
            ENDIF
            GdiplusShutdown( m.hToken )
        ENDIF
        EmptyClipboard()
        CloseClipboard()
    ENDIF
ENDIF

RETURN ( 0 == m.iResult )
ENDFUNC

FUNCTION decl_api
    DECLARE Long keybd_event IN WIN32API ;
        Long bVk, Long bScan, Long dwFlags, Long dwExtraInfo
    DECLARE Long OpenClipboard IN WIN32API ;
        Long hWndNewOwner
    DECLARE Long EmptyClipboard IN WIN32API
    DECLARE Long CloseClipboard IN WIN32API
    DECLARE Long GetClipboardData IN WIN32API ;
        Long uFormat

    DECLARE Long GdiplusStartup IN gdiplus ;
        Long @ token, String @ inputbuf, Long @ outputbuf
    DECLARE Long GdiplusShutdown IN gdiplus ;
        Long token
    DECLARE Long GdipCreateBitmapFromHBITMAP IN gdiplus ;
        Long hbitmap, Long hpalette, Long @ hGpBitmap
    DECLARE Long GdipDisposeImage IN gdiplus ;
        Long image
    DECLARE Long GdipSaveImageToFile IN gdiplus ;
        Long nImage, String FileName, ;
        String clsIdEncoder, Long encoderParams
ENDFUNC

 FUNCTION HWND2JPG(wHwnd as INTEGER,imagefile as string)
**wHwnd 窗口句柄
***imagefile 要保存到本地的文件名，我这里只定义了JPG格式，大家可以扩展
CF_BITMAP=2    
SRCCOPY=13369376 
Declare SHORT GetWindowRect IN user32 INTEGER hwnd, STRING @ lpRect
Declare INTEGER GetWindowDC IN user32 INTEGER hwnd
Declare INTEGER CreateCompatibleDC IN gdi32 INTEGER hdc
Declare INTEGER DeleteDC IN gdi32 INTEGER hdc
Declare INTEGER ReleaseDC IN user32 INTEGER hwnd, INTEGER hdc
Declare INTEGER CreateCompatibleBitmap IN gdi32;
    INTEGER hdc,;
    INTEGER nWidth,;
    INTEGER nHeight
Declare INTEGER SelectObject IN gdi32 INTEGER hdc, INTEGER hObject
Declare INTEGER DeleteObject IN gdi32 INTEGER hObject
Declare INTEGER BitBlt IN gdi32;
    INTEGER hDestDC,;
    INTEGER x, INTEGER y,;
    INTEGER nWidth, INTEGER nHeight,;
    INTEGER hSrcDC,;
    INTEGER xSrc, INTEGER ySrc,;
    INTEGER dwRop
Declare INTEGER OpenClipboard IN user32 INTEGER hwnd
Declare INTEGER CloseClipboard IN user32
Declare INTEGER EmptyClipboard IN user32
Declare INTEGER SetClipboardData IN user32;
    INTEGER wFormat,;
    INTEGER hMem
DECLARE INTEGER GetClipboardData IN user32;
    INTEGER uFormat
DECLARE INTEGER GdipCreateBitmapFromHBITMAP IN gdiplus;
    INTEGER   hbm,;
    INTEGER   hpal,;
    INTEGER @ hbitmap
DECLARE INTEGER GdipSaveImageToFile IN gdiplus;
    INTEGER img,;
    STRING filename,;
    STRING clsidEncoder,;
    INTEGER encoderParams
DECLARE Long GdipDisposeImage IN Gdiplus.dll Long nativeImage        
*-----------------------------------------------------------------*
*-VFP应用程式算法群 
*-----------------------------------------------------------------*             
lpRect = REPLI (Chr(0), 16)
GetWindowRect (wHwnd, @lpRect)
lnWidth=ctob(SUBS(lpRect,9,4),'4rs')-ctob(SUBS(lpRect,1,4),'4rs')&&窗口宽度
lnHeight=ctob(SUBS(lpRect,13,4),'4rs')-ctob(SUBS(lpRect,5,4),'4rs')&&窗口高度
hdc = GetWindowDC (wHwnd)
hVdc = CreateCompatibleDC (hdc)
hBitmap = CreateCompatibleBitmap(hdc, lnWidth, lnHeight)
SelectObject (hVdc, hBitmap) 
BitBlt (hVdc, 0,0, lnWidth,lnHeight, hdc, 0,0, SRCCOPY)
OpenClipboard (wHwnd)
EmptyClipboard()
SetClipboardData (CF_BITMAP, hBitmap)&&我在这里顺便把图像放到了剪切板，如果不需要可删除。
hClipBmp=GetClipboardData(CF_BITMAP)
hbitmap=0
GdipCreateBitmapFromHBITMAP(hClipBmp,2,@hbitmap)
lcOutputFile=STRCONV(imagefile+CHR(0),5)
jpg=0h01F47C55041AD3119A730000F81EF32E&&JPG格式
GdipSaveImageToFile(hbitmap,lcOutputFile,jpg,0)
GdipDisposeImage(hbitmap)
CloseClipboard()
DeleteObject (hBitmap)
DeleteDC (hVdc)
ReleaseDC (wHwnd, hdc)
ENDFUNC

FUNCTION ShowStatus( tnVal )
    WAIT WINDOW AT SROWS()/2, SCOLS()/2-20 ;
        NOWAIT '  正在识别, 已完成 ' + TRANSFORM( m.tnVal ) + '%  '
ENDFUNC

FUNCTION   GetAllProcessID   (   lpProcTable   )   
lpProcTable   =   IIF(PARAMETERS()=1   AND   TYPE([lpProcTable])=[C],   lpProcTable,   [AllProclists]   )   
DECLARE   INTEGER   CreateToolhelp32Snapshot   IN   kernel32   INTEGER   lFlags,   INTEGER   lProcessID   
DECLARE   INTEGER   Process32First   IN   kernel32   INTEGER   hSnapShot,   STRING   @PROCESSENTRY32_uProcess   
DECLARE   INTEGER   Process32Next   IN   kernel32   INTEGER   hSnapShot,   STRING   @PROCESSENTRY32_uProcess   
DECLARE   INTEGER   CloseHandle   IN   kernel32   INTEGER   hObject   
DECLARE   INTEGER   GetLastError   IN   kernel32   
    
CREA   CURSOR   (lpProcTable)   (PdwSize   N(3),   PcntUsage   N(12),   ;   
Pth32ProcessID   N(12),   Pth32DefaultHeapID   N(12),   ;   
Pth32ModuleID   N(12),   PcntThreads   N(12),   ;   
Pth32ParentProcessID   N(12),   PpcPriClassBase   N(3),   ;   
PdwFlags   N(3),   PszExeFile   C(254)   )   
lnHand   =   0   
lnHand   =   CreateToolhelp32Snapshot(3,0)   
IF   lnHand>0   
dwSize   =   Num2Dword(296)   
cntUsage   =   Num2Dword(0)   
th32ProcessID   =   Num2Dword(0)   
th32DefaultHeapID   =   Num2Dword(0)   
th32ModuleID   =   Num2Dword(0)   
cntThreads   =   Num2Dword(0)   
th32ParentProcessID   =   Num2Dword(0)   
pcPriClassBase   =   Num2Dword(0)   
dwFlags   =   Num2Dword(0)   
szExeFile   =   REPLI(CHR(0),   260)   
lcTitle   =   dwSize   +   cntUsage   +   th32ProcessID   +   th32DefaultHeapID   ;   
+   th32ModuleID   +   cntThreads   +   th32ParentProcessID   ;   
+   pcPriClassBase   +   dwFlags   +   szExeFile   
IF   Process32First(lnHand,@lcTitle)   >   0     &&   第一个进程是   kernel32.dll，没必要列出   
DO   WHILE   Process32Next(lnHand,@lcTitle)>   0   
INSERT   INTO   (lpProcTable)   (PdwSize,   PcntUsage,   Pth32ProcessID,   Pth32DefaultHeapID,   ;   
Pth32ModuleID,   PcntThreads,   Pth32ParentProcessID,   ;   
PpcPriClassBase,   PdwFlags,   PszExeFile)   ;   
VALUES   (   ;   
Dword2Num(SUBSTR(lcTitle,   1,4)),   ;   
Dword2Num(SUBSTR(lcTitle,   5,4)),   ;   
Dword2Num(SUBSTR(lcTitle,   9,4)),   ;   
Dword2Num(SUBSTR(lcTitle,13,4)),   ;   
Dword2Num(SUBSTR(lcTitle,17,4)),   ;   
Dword2Num(SUBSTR(lcTitle,21,4)),   ;   
Dword2Num(SUBSTR(lcTitle,25,4)),   ;   
Dword2Num(SUBSTR(lcTitle,29,4)),   ;   
Dword2Num(SUBSTR(lcTitle,33,4)),   ;   
SUBSTR(SUBSTR(lcTitle,   37),   1,   AT(CHR(0),SUBSTR(lcTitle,   37))-1)   )   
ENDDO   
ENDIF   
=   CloseHandle(lnHand)   
RETURN   .T.   
ELSE   
RETURN   .F.   
ENDIF   
ENDFUNC   
    
FUNCTION   Num2Dword   (   lpnNum   )   
DECLARE   INTEGER   RtlMoveMemory   IN   kernel32   AS   RtlCopyDword   STRING   @pDeststring,   INTEGER   @pVoidSource,   INTEGER   nLength   
lcDword   =   SPACE(4)   
=   RtlCopyDword(@lcDword,   BITOR(lpnNum,0),   4)   
RETURN   lcDword   
ENDFUNC   
    
FUNCTION   Dword2Num   (   tcDword   )   
DECLARE   INTEGER   RtlMoveMemory   IN   kernel32   AS   RtlCopyNum   INTEGER   @DestNumeric,   STRING   @pVoidSource,   INTEGER   nLength   
lnNum   =   0   
=RtlCopyNum(@lnNum,   tcDword,   8)   
RETURN   lnNum   
ENDFUNC   


FUNCTION CopyUnicodeText2Clipboard(tcUnicodeText)
LOCAL lnDataLen, lcDropFiles, llOk, i, lhMem, lnPtr, lcUnicodeText
#DEFINE CF_UNICODETEXT  13
 
*  Global Memory Variables with Compile Time Constants
#DEFINE GMEM_MOVABLE 	0x0002
#DEFINE GMEM_ZEROINIT	0x0040
#DEFINE GMEM_SHARE		0x2000
 
* Load required Windows API functions
=LoadApiDlls()
 
llOk = .T.
lcUnicodeText = tcUnicodeText + CHR(0)+CHR(0)
lnDataLen = LEN(lcUnicodeText)
* Copy Unicode text into the allocated memory
lhMem = GlobalAlloc(GMEM_MOVABLE+GMEM_ZEROINIT+GMEM_SHARE, lnDataLen)
lnPtr = GlobalLock(lhMem)
=CopyFromStr(lnPtr, @lcUnicodeText, lnDataLen)
=GlobalUnlock(lhMem)
* Open clipboard and store Unicode text into it
llOk = (OpenClipboard(0) <> 0)
IF llOk
	=EmptyClipboard()
	llOk = (SetClipboardData(CF_UNICODETEXT, lhMem) <> 0)
	* If call to SetClipboardData() is successful, the system will take ownership of the memory
	*   otherwise we have to free it
	IF NOT llOk
		=GlobalFree(lhMem)
	ENDIF
	* Close clipboard
	=CloseClipboard()
ENDIF
RETURN llOk
ENDFUNC    
FUNCTION LoadApiDlls
*  Clipboard Functions
DECLARE LONG OpenClipboard IN WIN32API LONG HWND
DECLARE LONG CloseClipboard IN WIN32API
DECLARE LONG EmptyClipboard IN WIN32API
DECLARE LONG SetClipboardData IN WIN32API LONG uFormat, LONG hMem
*  Memory Management Functions
DECLARE LONG GlobalAlloc IN WIN32API LONG wFlags, LONG dwBytes
DECLARE LONG GlobalFree IN WIN32API LONG HMEM
DECLARE LONG GlobalLock IN WIN32API LONG HMEM
DECLARE LONG GlobalUnlock IN WIN32API LONG HMEM
DECLARE LONG RtlMoveMemory IN WIN32API As CopyFromStr LONG lpDest, String @lpSrc, LONG iLen
RETURN

ENDFUNC   
FUNCTION CursorToHTML
* Generates an HTML table from a Foxpro table or cursor.
* The resulting string is a formatted HTML table which 
* can be inserted into a web page. Each column represents 
* a field from the cursor. The first row contains the 
* field names (in proper case, with underscores converted 
* to spaces).

* Parameter:
* tcAalias: Alias of table or cusor, which
* must already be open. The parameter is 
* mandatory.
LPARAMETER tcAlias

LOCAL lcRetVal, lnI, lcColHead, lcCell

* Check the parameters (these two lines 
* require SET ASSERT ON)
ASSERT PCOUNT()>0 MESSAGE "Parameter required"
ASSERT USED(tcAlias) ;
  MESSAGE "Alias "+tcAlias+" not found"

SELECT (tcAlias)

* string to hold returned value
lRetVal = ""


lcRetVal ='<body bgcolor="silver">'
* define the table
lcRetVal = lcRetVal +'<TABLE id="GenTable" border=1>'

* insert column headings from field names
lcRetVal = lcRetVal + "<TR>"
FOR lnI = 1 to FCOUNT()
  lcColHead = PROPER(STRTRAN(FIELD(lnI),"_"," "))
  lcRetVal = lcRetVal +"<TH>"+lcColHead + "</TH>"
ENDFOR
lcRetVal = lcRetVal + "</TR>"

* scan the cursor, creating a row for each record
SCAN
  lcRetVal = lcRetVal + "<TR>"
  FOR lnI = 1 TO FCOUNT()
    lcCell = TRANSFORM(EVALUATE(FIELDS(lnI)))
    lcRetVal = lcRetVal + "<TD>"+lcCell + "</TD>"
  ENDFOR
  lcRetVal = lcRetVal + "</TR>"
ENDSCAN

* end the table
lcRetVal = lcRetVal + "</TABLE></body>"
RETURN lcRetVal

ENDFUNC


*!*	loWord = CREATEOBJECT("Word.Application")
*!*	loEmOpt = loWord.EmailOptions
*!*	loOlSig = loEmOpt.EmailSignature
*!*	lcSigFileName = ALLTRIM(loOlSig.NewMessageSignature )
*!*	* Text signature
*!*	lcPathAndFile = lcFilePath + lcSigFileName + ".txt"
*!*	IF FILE(lcPathAndFile )
*!*		lcTextIn = FILETOSTR(lcPathAndFile  )
*!*		IF  LEFT( lcTextIn ,2) = 0hFFFE
*!*			lcTextIn = SUBSTR(lcTextIn,3)		
*!*		ENDIF	
*!*	 	p_Ass = '<small><br>'+STRTRAN(STRCONV(lcTextIn ,6),CHR(13)+CHR(10),'<br>')+'</small>'
*!*	ENDI
PROCEDURE genorder
con=odbc(5)
IF 	SQLEXEC(CON,"SELECT distinct RTRIM(COPTD.TD001)+RTRIM(COPTD.TD002)+'-'+RTRIM(COPTD.TD003)+"+;
	"CASE  WHEN p.piinterid is null  THEN '' when p.cid=1 then '[调'+rtrim(COPTD.TD015)+']' when p.cid=2 then '[借'+RTRIM(CAST(COPTD.UDF05 AS char(30)))+']' "+;
		"when p.cid=3 then '[调用库存]' ELSE '[调'+RTRIM(COPTD.TD015)+']' end AS 订单号,pidetail.itemno AS  公司货号,"+;
	"pidetail.customcode 客户货号,pidetail.code 品号,pidetail.name 品名,pidetail.spec 规格,pidetail.supply 供应商,"+;
	"CONVERT(CHAR(10),CAST(pidetail.edate AS DATETIME),102)+'(第'+RTRIM(DATENAME( Wk,CAST(pidetail.edate AS DATETIME) ))+'周)'  AS 要求交期,"+;
	"boxok ,CAST(COPTD.TD020 AS CHAR(1500)) AS 备注, pidetail.quan 数量, 0000.0 gs,p.cid,pi.chkdate,mf002 "+;
	",A.MA002,pi.po,pi.billname,MV002,pipro.EXTO,pi.discharge,0.000 vol,pidetail.quan boxtotal,pi.mainnote,pidetail.interid,pi.classid "+;
	" FROM pidetail left join COPTD COPTD on pidetail.interid=COPTD.UDF56 "+;
     "  left join pi on pidetail.maininterid=pi.interid left join COPMA A ON A.MA001=customid left join CMSMV ON "+;
     "salescode=MV001 LEFT JOIN pipro on pipro.interid=pi.interid LEFT JOIN pidetailcallforecast p on p.piinterid=  pidetail.interid "+;
	 " LEFT join COPTD x on p.forecastinterid=x.UDF56 and p.cid<3  WHERE pidetail.maininterid=?keyid ORDER BY 1","tmpBuyDe")<0
 	 SQLDISCONNECT(CON)  
	 WAIT windows '出错了'  &&&left join pidetail on COPTD.UDF56=pidetail.interid AND LEFT(pidetail.code,1)<>'X' 
ENDIF   
SELECT tmpBuyDe
lcMsg=  '正在生产PDF采购单...' 
WAIT WINDOW  lcMsg NOWAIT AT SROW()/2, (SCOLS()-LEN(lcMsg))/2 


DO WHILE .not. EOF()
	mkeyid=interid
	gq=数量

	IF EMPTY(备注) OR ISNULL(备注) OR LEN(ALLTRIM(备注))=0
		bzid=0
	ELSE
		bzid=1	
	ENDIF 
	mls=''
	X3=0
	IF mf002='N' 
		IF sqlexec(CON,"SELECT SUM(CAST(CASE WHEN MF019 IS NULL OR MF019=0 THEN 0 ELSE (MF010/MF019/3600)*quan END+"+;
		"CASE WHEN MF009 IS NULL  THEN 0 ELSE MF009/3600 end AS  numeric(10,1))) GS "+;
			" FROM pidetail LEFT JOIN INVMB ON code=MB001 inner JOIN BOMMF ON MB010=MF001 AND MB011=MF002 AND (MF005='1' OR MF005 IS NULL)  "+;
		 	"WHERE interid=?mkeyid  and  not exists (select 'x' from pidetailcallforecast x where x.piinterid=pidetail.interid)")<0
			WAIT WINDOWS '??2?'
		ENDIF 
		IF RECCOUNT()=1 AND !ISNULL(gs)
			x3=gs
			SELECT tmpBuyDe
			REPLACE GS WITH X3
		ENDIF 
	ENDIF	
	IF SQLEXEC(CON,"SELECT classid,packagecode,B1.MB002,B1.MB003,long MB093,width MB094, deep MB095,quan,long*width*deep/1000000 vol,boxnum,boxfrom,boxto "+;
		",weight,wet,des,barcode FROM packageinfo LEFT join INVMB B1 ON packagecode=B1.MB001 where interid=?mkeyid and billid=2 ORDER BY 1","TmpP")<0  &&billid=2 and 
		WAIT WINDOWS '??xgggxx?'
		RETURN
	ENDIF
	
	SELECT TmpP
	LOCATE FOR '外箱'$classid
	IF FOUND()
		WXID=1
	ELSE
		WXID=0
	ENDIF	
	GO TOP
	X1=0
	X2=0
	x3=0
	DO whil .not. EOF()
		CDD=''
		IF !ISNULL(barcode ) AND !EMPTY(barcode)
			CDD='[条形码]'+ALLTRIM(barcode)
		ENDIF
		IF !ISNULL(DES) AND !EMPTY(DES)
			CDD=CDD+'[提醒]'+ALLTRIM(DES)
		ENDIF

		CDD=CDD+'；'
		IF '外箱'$classid
			IF  '外箱外购'$packagecode
				mls=mls+'['+ALLTRIM(classid)+']每箱'+ALLTRIM(STR(quan))+'只,共'+ALLTRIM(STR(boxnum))+'箱('+ALLTRIM(STR(boxfrom))+'-'+ALLTRIM(STR(boxto))+')'+CDD
			ELSE
				mls=mls+'['+ALLTRIM(classid)+']'+ALLTRIM(MB002)+ALLTRIM(MB003)+'['+ALLTRIM(packagecode)+']每箱'+ALLTRIM(STR(quan))+'只,共'+ALLTRIM(STR(boxnum))+'箱('+ALLTRIM(STR(boxfrom))+'-'+ALLTRIM(STR(boxto))+')'+CDD
			ENDIF	
			X1=boxnum+X1
			X2=vol+X2
		ELSE
			IF WXID=0 AND '中包'$classid
				IF  '中包外购'$packagecode
					mls=mls+'['+ALLTRIM(classid)+']每箱'+ALLTRIM(STR(quan))+'只,共'+ALLTRIM(STR(boxnum))+'箱('+ALLTRIM(STR(boxfrom))+'-'+ALLTRIM(STR(boxto))+')'+CDD
				ELSE
					mls=mls+'['+ALLTRIM(classid)+']'+ALLTRIM(MB002)+ALLTRIM(MB003)+'['+ALLTRIM(packagecode)+']每箱'+ALLTRIM(STR(quan))+'只,共'+ALLTRIM(STR(boxnum))+'箱('+ALLTRIM(STR(boxfrom))+'-'+ALLTRIM(STR(boxto))+')'+CDD
				ENDIF	
				X1=boxnum+X1
				X2=vol+X2
			ELSE
				IF !ISNULL(MB002)
					mls=mls+'['+ALLTRIM(classid)+']'+ALLTRIM(MB002)+ALLTRIM(MB003)+'['+ALLTRIM(packagecode)+']'+CDD
*!*					ELSE
*!*						mls=mls+'['+ALLTRIM(classid)+':'+ALLTRIM(packagecode)+']；'
				ENDIF 	
			ENDIF	
		ENDIF 
		SELECT tmpp
		SKIP
	ENDDO 	
	
	SELECT tmpBuyDe

	IF bzid=0
		REPLACE 备注 WITH '包装信息:'+mls
		bzid=1
	ELSE
		REPLACE 备注 WITH '1.'+ALLTRIM(备注)+CHR(13)+CHR(10)+'2.包装信息:'+mls
		bzid=2
	ENDIF
	REPLACE vol WITH X2,boxtotal WITH x1
	IF SQLEXEC(CON,"SELECT '料件调拨' classid,exportcode.code,B1.MB002,B1.MB003,B1.MB004,totalpcs MB094, B1.MB053 ,B1.MB053 *pcs*pidetail.quan CASH "+;
		"FROM exportcode LEFT join INVMB B1 ON code=B1.MB001 inner join pidetail on pidetail.interid=pidetailinterid "+;
		" where pidetailinterid=?mkeyid ORDER BY 1,2","TmpP")<0
		WAIT WINDOWS '??xxx?'
	ENDIF
	mls=''
	SELECT TmpP
	IF RECCOUNT()>0
		GO TOP 
		DO WHILE .not. EOF()
			mls=mls+ALLTRIM(MB002)+ALLTRIM(MB003)+'['+ALLTRIM(code)+']:'+ALLTRIM(STR(MB094))+'PCS;'
			SELECT tmpp
			SKIP
		ENDDO 	
		SELECT tmpBuyDe

		IF bzid=1
			REPLACE 备注 WITH  '1.'+ALLTRIM(备注)+CHR(13)+CHR(10)+'2.调拨料件:'+mls
		ELSE
			REPLACE 备注 WITH  ALLTRIM(备注)+CHR(13)+CHR(10)+'3.调拨料件:'+mls
		ENDIF
	ENDIF 	
	SELECT tmpBuyDe
	IF CID=1
		SQLEXEC(con,"SELECT COPMF.UDF52-MF009 MF FROM COPMF as COPMF inner join  pidetailcallforecast p on p.forecastinterid=COPMF.UDF56 WHERE p.piinterid=?MKEYID")
		IF MF>=GQ
			SELECT tmpBuyDe
			REPLACE CID WITH 9
		ENDIF 
	ENDIF 
	SELECT tmpBuyDe

	IF CID=2
		SQLEXEC(con,"SELECT COPTD.UDF52-COPTD.UDF51-COPTD.TD009 AS MF FROM COPTD as COPTD "+;
			"inner join  pidetailcallforecast p on p.forecastinterid=COPTD.UDF56 WHERE p.piinterid=?MKEYID")
		IF MF>=GQ
			SELECT tmpBuyDe
			REPLACE CID WITH 9  &&备注 WITH  ALLTRIM(备注)+CHR(13)+CHR(10)+'--有库存无需生产！',
		ENDIF 
	ENDIF	
	SELECT tmpBuyDe

	SKIP
ENDDO	
SQLDISCONNECT(CON)

=ReduceMemory()
*ERASE 	shippingMARK
CURSORSETPROP("MapBinary",.T.,0)
CON=ODBC(5)
Sqlexec(CON,"select filedata pic,filename,classid from billpic where interid=?keyid and classid<=2 and filedata is not null ORDER BY classid","t1")
SQLDISCONNECT(CON)	
IF RECCOUNT()=1	
	STRTOFILE(pic,'shippingMARK')
	mwhere='ok'&&ALLTRIM(STR(keyid))+'.'+filename
*			COPY ALLTRIM(STR(keyid))+'.'+filename to 'shippingMARK'
ELSE
	mwhere='no'
	*MESSAGEBOX('无唛头')
ENDIF 	
*ON ERROR  wait windows '' nowait 
codeid=2015090000
DO GetReport WITH codeid
ERASE ALLTRIM(STR(keyid))+'下发.pdf'
SELECT tmpBuyDe

WITH _Screen.oFoxyPreviewer 
    .cPdfSubject ='order form'
    .cPdfKeyWords =ALLTRIM(STR(keyid))
ENDWITH 
*REPORT FORM 报表打印.frx PREVIEW 
REPORT FORM 报表打印.frx OBJECT TYPE 11 TO FILE ALLTRIM(STR(keyid))+'下发.pdf'
ENDPROC 
PROCEDURE stopit
	MEXIT=2
	WAIT WINDOWS '正在退出，稍后....'
*!*		Declare keybd_event In Win32API Short bVk,Short bScan,Integer dwFlags, Integer deExtraInfo
*!*		keybd_event(17, 0, 0, 0)
*!*		keybd_event(18, 0, 0, 0)
*!*		keybd_event(Asc('D'), 0, 0, 0)
*!*		keybd_event(Asc('D'), 0, 2, 0)
*!*		keybd_event(17, 0, 2, 0)
*!*		keybd_event(18, 0, 2, 0)
*!*		RUN /N reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f
ENDPROC 
** 用DllRegisterServer() 或者 DllUnregisterServer() 注册 ActiveX控件 **
***********************************************************************
** lpLibFileName 需要注册的ActiveX控件名称，包含路径   **
** isReg         注册或者注销，.T.为注册，.F.为注销    **
** =DllRegister( ocx_name, .T.) &&注册，返回0表示成功，-1表示文件不存在
** =DllRegister( ocx_name, .F.) &&注销，返回0表示成功，-1表示文件不存在
***********************************************************************
Function DllRegister(lpLibFileName,isReg)
	IF FILE(lpLibFileName)
	   isReg = iif(type("isReg")="U", .T., isReg)
	   lpProcName = iif(isReg, "DllRegisterServer", "DllUnregisterServer" )
	   Declare INTEGER (lpProcName) in (lpLibFileName)
	   return &lpProcName.()
	ELSE
	   return -1
	ENDIF
ENDFUNC

** 用创建对象时通过捕捉异常来判断控件是否已注册 **
FUNCTION IsOleReg3(OleClsName) 
  LOCAL oApp,oErr
  TRY 
    oApp = CREATEOBJECT(OleClsName)
  CATCH TO oErr
  ENDTRY
  RETURN IIF(TYPE("oErr.ErrorNo")="U",.T.,.F.) &&变量不存在，没错误返回 .T.
ENDFUNC 

** 用获取类标识符来检测控件是否已注册 **
FUNCTION IsOleReg2(OleClsName) 
  LOCAL sCLSID 
  DECLARE LONG CLSIDFromProgID IN Ole32 STRING@, STRING@ 
  sCLSID = REPLICATE(0h00, 16) 
  RETURN (CLSIDFromProgID(STRCONV(OleClsName + 0h00, 5), @sCLSID) == 0) 
ENDFUNC 


*本程序也可以检查DLL有没有被注册，以收发邮件的jmail.dll为例
*if IsOleReg('jmail.SMTPMail')   &&参数也可以用jmail.POP3
*   =MessageBox("jmail.dll 已经注册",64,"信息提示")
*else
*   =MessageBox("jmail.dll 没有注册",48,"信息提示")
*endif

** 用检查注册表方法来检测控件是否已注册 **
FUNCTION  IsOleReg1(OleClsName)

	DECLARE INTEGER RegOpenKeyEx IN advapi32 INTEGER nKey,STRING @cSubKey,INTEGER nReserved,INTEGER nAccessMask,INTEGER @nResult
	DECLARE LONG RegCloseKey IN advapi32 INTEGER nHKey
	#DEFINE HKEY_CLASSES_ROOT -2147483648
	LOCAL lnHKEY,lnRes,lcName1,lcGUID,guiddesc,OcxFile

	*在 HKEY_CLASSES_ROOT\MSComctlLib.TreeCtrl.2中查找控件的名称
	lnHKEY=0
	lnRes=RegOpenKeyEx(HKEY_CLASSES_ROOT,OleClsName,0,131097,@lnHKey)
	IF lnRes<>0
	   RETURN .F.
	ENDIF
	lcName1=GetRegVal(lnHKey,'')
	RegCloseKey(lnHKey)
	IF ISNULL(lcName1)
	   RETURN .F.
	ENDIF

	*在HKEY_CLASSES_ROOT\MSComctlLib.TreeCtrl.2\CLSID中查找控件的类标识符 GUID
	lnRes=RegOpenKeyEx(HKEY_CLASSES_ROOT,OleClsName+'\CLSID',0,131097,@lnHKey)
	IF lnRes<>0
	   RETURN .F.
	ENDIF
	lcGUID=GetRegVal(lnHKey,'')
	RegCloseKey(lnHKey)
	IF ISNULL(lcGUID)
	   RETURN .F.
	ENDIF

	*在 HKEY_CLASSES_ROOT\CLSID\… 中查找控件的类标识符 GUID 的备注
	lnRes=RegOpenKeyEx(HKEY_CLASSES_ROOT,'CLSID\'+lcGUID,0,131097,@lnHKey)
	IF lnRes<>0
	   RETURN .F.
	ENDIF
	guiddesc=GetRegVal(lnHKey,'')
	RegCloseKey(lnHKey)
	IF ISNULL(guiddesc)
	   RETURN .F.
	ENDIF

	*在 HKEY_CLASSES_ROOT\CLSID\…\InprocServer32 中查找控件的文件名（含路径）
	lnRes=RegOpenKeyEx(HKEY_CLASSES_ROOT,'CLSID\'+lcGUID+'\InprocServer32',0,131097,@lnHKey)
	IF lnRes<>0
	   RETURN .F.
	ENDIF
	OcxFile=GetRegVal(lnHKey,'')
	RegCloseKey(lnHKey)
	IF ISNULL(OcxFile)
	   RETURN .F.
	ENDIF

	IF FILE((OcxFile))
	    RETURN .T.
	ELSE
	    RETURN .F.
	ENDIF

ENDFUNC

PROCEDURE GetRegVal(nHKey,cProperty)
	LOCAL Result,lcValue,lnValLen,lnType

	DECLARE INTEGER RegQueryValueEx IN advapi32 INTEGER nKey,STRING cValueName,INTEGER nReserved,INTEGER @nType,STRING @cBuffer,INTEGER @nBufferSize
	IF ISNULL(nHKey)
	    RETURN .NULL.
	ENDIF
	lnType=1
	lcValue=space(255)
	lnValLen=255
	result=RegQueryValueEx(nHKey,@cProperty,0,@lnType,@lcValue,@lnValLen)
	IF result=0 and lcValue<>CHR(0)
	   lcValue=Left(lcValue,lnValLen-1)
	   RETURN lcValue
	ELSE
	   RETURN .NULL.
	ENDIF
ENDPROC
    