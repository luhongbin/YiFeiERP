WAIT WINDOWS '���ڶ�ȡ���۵���ӡ��Ϣ...' NOWAIT 
CURSORSETPROP("MapBinary",.T.,0)&&�ǳ��ؼ�
CON=ODBC(5)
SQLEXEC(CON,"SELECT currency, customid, pricelist.dateid, mainnote, paycon,"+;
  "effectivedate as edateid,CASE WHEN incoterm ='FOB' THEN 'FOB '+loading WHEN incoterm ='CNF' OR incoterm ='CIF' THEN RTRIM(incoterm)+' ' +discharge "+;
  "WHEN incoterm ='EXW' THEN 'EXW' ELSE '' END AS incoterm, "+;
  "loading, discharge, enote, salescode, toway,"+;
  "maininterid, code,  attr, customcode, name, spec, quan, profit,"+;
  "price, cash, note, stprice, lastdate, lastcurrency, lastprice,"+;
  "lastquan, lastcash,  costdate, lastcost, gw,  nw, volume, defarate,"+;
  "lastgp, orderid,  unitcost, unitprice,  shape, lightsource,"+;
  "bulb, iprating,  unitcode, unitname,  unitspec, unitbarcode,"+;
  "smscode, smsname,  smsspec, outerbarcode,  outercode, outername,"+;
  "outerspec, innerbarcode,  smsbarcode, spkg, spw,  spd, sph, spcmb,"+;
  "mcpcs, mckgs, mcw,  mcd, mch, mccmb,matcost, productname, itemno,  descripe, material,"+;
  "approval, moq,  qty20fcl, qty40fcl,  qty40h, size,"+;
"codeclass, saleclass,  package, unitrequ, innerquan, supply,"+;
  " codeseries, codecolor,  lastbb,nbkgs,nbw,nbd,nbh,nbcmb, pic,enote,note "+;
 " from pricelist inner join pricelistdetail on pricelist.interid=pricelistdetail.maininterid "+;
"  where pricelist.interid=?keyid","t1")
SQLDISCONNECT(CON)

PUBLIC goPic AS Image
m.goPic = NEWOBJECT( 'Image' )
SET REPORTBEHAVIOR 80

WAIT WINDOWS '��ȡ���' nowait
*!*	*!*	REPORT FORM d:\trade\���۵� PREVIEW
*!*	m.outfilename=putfile('������','���۵�','xls')
*!*	&&ȡ�����ļ�����
*!*	ef=CREATEOBJECT('Excel.application')
*!*	&&����Excel����
*!*	ef.Workbooks.add
*!*	&&��ӹ�����
*!*	ef.Worksheets("sheet1").Activate
*!*	&&�����һ��������
*!*	ef.visible=.t.
*!*	SELECT t1
*!*	I=RECCOUNT()+3
*!*	ef.Range(ef.Cells(2,1),ef.Cells(I,33)).BorderS.LineStyle=1
*!*	ef.Range(ef.Cells(2,1),ef.Cells(I,33)).HorizontalAlignment=6 &&ˮƽ(1-Ĭ�ϡ�2-����3-���С�4-���ҡ�5-��䡢6=���˶��롢7=���о��С�8=��ɢ����)
*!*	ef.Range(ef.Cells(2,1),ef.Cells(I,33)).VerticalAlignment=2 &&��ֱ(1=���ϡ�2=���С�3=���¡�4=���˶��롢5=��ɢ����)

*!*	&&��ʾExcel����
*!*	*!*	ef.Cells.Select
*!*	&&ѡ�����ű�
*!*	ef.Selection.Font.Size = 10
*!*	&&��������Ĭ�������СΪ10
*!*	ef.range("A1:F1").Select
*!*	&&ѡ����������ڵ�Ԫ��
*!*	ef.Selection.Merge
*!*	&&�ϲ���Ԫ��
*!*	*!*	with ef.range("A1")
*!*	ef.range("A1").HorizontalAlignment=4
*!*	ef.Rows(1).RowHeight=1/0.0035/3
*!*	*!*	ef.Range("A1").Select
*!*	ef.Cells(1, 1).Activate
*!*	ef.ActiveSheet.PictureS.Insert("d:\trade\imgs\log.gif").Select
*!*	ef.Selection.ShapeRange.LockAspectRatio =.T.
*!*	Target =ef.Cells(1, 1)
*!*	ef.Selection.Top = Target.Top + 1
*!*	ef.Selection.Left = Target.Left + 1

*!*	*!*	ef.Selection.ShapeRange.Height =160
*!*	&&���ñ��⼰��������
*!*	*value='�ͻ�����ҵ������������ͳ�Ʊ�'
*!*	*Font.Name="����"
*!*	*Font.size=18
*!*	*!*	endwith

*!*	&&���õڶ��и߶�Ϊ1cm

*!*	&&�ϲ���Ԫ��
*!*	*!*	ef.range("H2").Font.size=10
*!*	*!*	ef.range("H2").HorizontalAlignment=4
*!*	&&�������ݶ��뷽ʽΪ�Ҷ���,3Ϊ���У�4Ϊ�Ҷ���

*!*	ef.Range("A2").value='Product Name'
*!*	ef.Range("B2").value='PICTURE'
*!*	ef.Range("C2").value='ITEM NO.'
*!*	ef.Range("D2").value='FOB PRICE'
*!*	ef.Range("E2").value='DESCRIPTION'
*!*	ef.Range("F2").value='Material'
*!*	ef.Range("G2").value='Shade'
*!*	ef.Range("H2").value='Light Source'
*!*	ef.Range("I2").value='Bulb (incl/excl)'
*!*	ef.Range("J2").value='IP Rating'
*!*	ef.Range("K2").value='Dimension'
*!*	ef.Range("L2:P2").Select
*!*	ef.Selection.Merge
*!*	ef.range("L2").HorizontalAlignment=3
*!*	ef.Range("L2").value='SINGLE PACK�а��ߴ磬����'
*!*	ef.Range("Q2:V2").Select
*!*	ef.Selection.Merge
*!*	ef.range("Q2").HorizontalAlignment=3

*!*	ef.Range("Q2").value='INNER �ڰ�װ�ߴ磬����'
*!*	ef.Range("W2:AB2").Select
*!*	ef.Selection.Merge
*!*	ef.range("W2").HorizontalAlignment=3

*!*	ef.Range("W2").value='MASTER CARTON����ߴ�,����'

*!*	ef.Range("AC2").value='APPROVAL'
*!*	ef.Range("AD2").value='MOQ(PCS)'
*!*	ef.Range("AE2:AG2").Select
*!*	ef.Selection.Merge
*!*	ef.range("AE2").HorizontalAlignment=3

*!*	ef.Range("AE2").value='QTY��װ����װ����'

*!*	ef.Range("A3").value='��Ʒ����'
*!*	ef.Range("B3").value='ͼƬ'
*!*	ef.Range("C3").value='��˾����'
*!*	ef.Range("D3").value='�۸�'
*!*	ef.Range("E3").value='��Ʒ����'
*!*	ef.Range("F3").value='����'
*!*	ef.Range("G3").value='͸���'
*!*	ef.Range("H3").value='��Դ'
*!*	ef.Range("I3").value='�Ƿ��������'
*!*	ef.Range("J3").value='������ˮ�ȼ�'
*!*	ef.Range("K3").value='��Ʒ�ߴ�'
*!*	ef.Range("L3").value='KG'
*!*	ef.Range("M3").value='WIDTH��'
*!*	ef.Range("N3").value='DEPTH��'
*!*	ef.Range("O3").value='HEIGHT��'
*!*	ef.Range("P3").value='CBM'
*!*	ef.Range("Q3").value='PCS/INNERֻ/�ڰ�'
*!*	ef.Range("R3").value='KG'
*!*	ef.Range("S3").value='WIDTH��'
*!*	ef.Range("T3").value='DEPTH��'
*!*	ef.Range("U3").value='HEIGHT��'
*!*	ef.Range("V3").value='CBM'
*!*	ef.Range("W3").value='PCS/CTN'
*!*	ef.Range("X3").value='KG'
*!*	ef.Range("Y3").value='WIDTH��'
*!*	ef.Range("Z3").value='DEPTH��'
*!*	ef.Range("AA3").value='HEIGHT��'
*!*	ef.Range("AB3").value='CBM'

*!*	ef.Range("AC3").value='�к�֤��/ʵ����'
*!*	ef.Range("AD3").value='��С�ɹ���'
*!*	ef.Range("AE3").value="20'FCL"
*!*	ef.Range("AF3").value="40'FCL"
*!*	ef.Range("AG3").value="40'H"

*!*	select 0
*!*	SELECT t1
*!*	CURSORSETPROP("MapBinary",.T.,0)&&�ǳ��ؼ�

*!*	i=4
*!*	go top
*!*	DO WHILE .not. EOF()
*!*		j=ALLTRIM(STR(i))
*!*		ef.Rows(i).RowHeight=1/0.0035/4
*!*		ef.Range("A&j").value=productname
*!*		ef.ActiveSheet.Columns(1).ColumnWidth =26
*!*		STRTOFILE(pic,OldPath+"TMPLHB"+'&j')
*!*		*ef.Range("B&j").value="TMPLHB"+'&j'
*!*		ef.Cells( I,2).Activate
*!*		ef.ActiveSheet.PictureS.Insert(OldPath+"TMPLHB"+'&j').Select
*!*		ef.Selection.ShapeRange.LockAspectRatio =.T.
*!*		Target =ef.Cells( I,2)
*!*		ef.Selection.Top = Target.Top + 1
*!*		ef.Selection.Left = Target.Left + 1	
*!*		ef.Selection.ShapeRange.Height =1/0.0035/4

*!*		ef.Range("C&j").value=itemno
*!*		ef.Range("D&j").value=price
*!*		ef.Range("E&j").value= descripe
*!*		ef.Range("F&j").value=material
*!*		ef.Range("G&j").value=shape
*!*		ef.Range("H&j").value=lightsource
*!*		ef.Range("I&j").value=bulb
*!*		ef.Range("J&j").value=iprating
*!*		ef.Range("K&j").value=size
*!*		ef.Range("L&j").value=spkg
*!*		ef.Range("M&j").value=spw
*!*		ef.Range("N&j").value=spd
*!*		ef.Range("O&j").value=sph
*!*		ef.Range("P&j").value=spcmb
*!*		ef.Range("Q&j").value=innerquan
*!*		ef.Range("R&j").value=nbkgs
*!*		ef.Range("S&j").value=nbw
*!*		ef.Range("T&j").value=nbd
*!*		ef.Range("U&j").value=nbh
*!*		ef.Range("V&j").value=nbcmb
*!*		ef.Range("W&j").value=mcpcs
*!*		ef.Range("X&j").value=mckgs
*!*		ef.Range("Y&j").value=mcw
*!*		ef.Range("Z&j").value= mcd
*!*		ef.Range("AA&j").value=mch
*!*		ef.Range("AB&j").value=mccmb

*!*		ef.Range("AC&j").value=approval
*!*		ef.Range("AD&j").value=moq
*!*		ef.Range("AE&j").value=qty20fcl
*!*		ef.Range("AF&j").value=qty40fcl
*!*		ef.Range("AG&j").value=qty40h
*!*		i=i+1
*!*		SKIP
*!*		
*!*	ENDDO 
*!*	i=i+1
*!*	j=ALLTRIM(STR(i))
*!*	*!*	ef.Rows(i).RowHeight=1/0.0035/4
*!*	ef.Range("A&j").value='Offer Date:'
*!*	ef.Range("B&j").value=substr(dateid,1,4)+'.'+substr(dateid,5,2)+'.'+substr(dateid,7,2)
*!*	ef.Range("C&j").value= 'Contact:'
*!*	ef.Range("D&j").value=P_Title
*!*	i=i+1
*!*	j=ALLTRIM(STR(i))
*!*	ef.Range("A&j").value='Expiry Date'
*!*	ef.Range("B&j").value=substr(edateid,1,4)+'.'+substr(edateid,5,2)+'.'+substr(edateid,7,2)
*!*	ef.Range("C&j").value= 'Email:'
*!*	ef.Range("D&j").value=P_Email
*!*	i=i+1
*!*	j=ALLTRIM(STR(i))
*!*	ef.Range("A&j").value='Currency'
*!*	ef.Range("B&j").value=currency
*!*	ef.Range("C&j").value= 'Tel'
*!*	ef.Range("D&j").value='86-574-62760156, 62760540'
*!*	i=i+1
*!*	j=ALLTRIM(STR(i))
*!*	ef.Range("A&j").value='Incoterm'
*!*	ef.Range("B&j").value=incoterm
*!*	ef.Range("C&j").value= 'Fax'
*!*	ef.Range("D&j").value='86-574-62760807, 62702807'

*!*	i=i+1
*!*	j=ALLTRIM(STR(i))
*!*	ef.Range("A&j").value='Port of Loading'
*!*	ef.Range("B&j").value=loading
*!*	ef.Range("C&j").value= 'web site'
*!*	ef.Range("D&j").value='www.cnymec.com'
*!*	i=i+1
*!*	j=ALLTRIM(STR(i))
*!*	ef.Range("A&j").value='Port of Discharge'
*!*	ef.Range("B&j").value=discharge
*!*	ef.Range("C&j").value= ' '
*!*	ef.Range("D&j").value='www.yaohualux.com'

*!*	i=i+1
*!*	j=ALLTRIM(STR(i))
*!*	ef.Range("A&j").value='RemarkS:'

*!*	i=i+1
*!*	j=ALLTRIM(STR(i))
*!*	ef.Range("A&j").value='1)DELIVERY TIME:'
*!*	i=i+1
*!*	j=ALLTRIM(STR(i))
*!*	ef.Range("A&j").value='2)OUR GOVERMENT MAY CHANGE TAX-REBATE POLICY FROM JULY 1,  TO AVOID THE RISK OF THIS POLICY,  WE'
*!*	i=i+1
*!*	j=ALLTRIM(STR(i))
*!*	ef.Range("A&j").value='CONFIRM OUR ABOVE PRICE IS BASED ON EXISTING TAX-REBATE 13%, IF THERE IS ANY TAX-REBATE POLICY CHANGE'

*!*	i=i+1
*!*	j=ALLTRIM(STR(i))
*!*	ef.Range("A&j").value='BEFORE THE SHIPMENT, WE WILL ADJUST OUR PRICE ACCORDINGLY. PLS NOTE'

*ef.Range(ef.Cells(2,1),ef.Cells(5,33)).EntireColumn.Autofit
codeid=2011080000
*!*	P_ReportFile='���Ŀͻ����۵�'
*!*	P_ReportName=P_CAPTION+P_ReportFile
DO &P_Others.OrderInfoPrint.Mpr

FUNCTION _GetPic
  m.goPic.pictureval = t1.pic
  RETURN .T.
ENDFUNC

