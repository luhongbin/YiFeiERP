LPARA LcFrxName,LcPdfName,LcTableName
&&需要安裝Bullzip PDF Printer
IF VARTYPE(LcFrxName)<>'C'
RETU .F.
ENDIF
IF VARTYPE(LcPdfName)<>'C'
RETU .F.
ENDIF
IF UPPER(JUSTEXT(LcFrxName))<>'FRX'
LcFrxName=ADDBS(JUSTPATH(LcFrxName))+JUSTSTEM(LcFrxName)+'.FRX'
ENDIF
IF UPPER(JUSTEXT(LcPdfName))<>'PDF'
LcPdfName=ADDBS(JUSTPATH(LcPdfName))+JUSTSTEM(LcPdfName)+'.PDF'
ENDIF
IF !FILE(LcFrxName)
RETU .F.
ENDIF
lOldSelect=SELECT()
IF VARTYPE(LcTableName)='C' AND !EMPTY(LcTableName) AND USED(LcTableName)
SELECT (LcTableName)
ELSE
lNewSelect=ALIAS()
IF EMPTY(lNewSelect)
  RETU .F.
ENDIF
IF !USED(lNewSelect)
  RETU .F.
ENDIF
ENDIF
LOCAL OldPrinter
&&WAIT WINDOW "正在輸出到PDF文件,請稍候......" NOWAIT
OldPrinter=SET('Printer',2)
Escape_wk = ON("escape")
ON ESCAPE tNoWait=.T.
SET PRINTER TO NAME ("Bullzip PDF Printer")
BullZip=CREATEOBJECT("BullZip.Pdfprintersettings")
WITH BullZip
.SetValue("ShowProgress",'no')
.SetValue('mergeposition','bottom')
.SetValue('ShowProgressFinished',"no")
.SetValue('SuppressErrors','Yes')
.SetValue('ConfirmOverwrite','no')
.SetValue("ShowSettings" ,"never")
.SetValue('ShowSaveAs','never')
.SetValue("ConFirMoverWrite","No") &&不顯示打印過程
.SetValue("ShowPDF" ,"no")
.SetValue("RememberLastFileName", "no")
.SetValue("RememberLastFolderName", "no")
.WriteSettings(.T.)
.SetValue("Output",LcPdfName)
.WriteSettings(.T.)
ENDWITH
m.PTalk=SET('Talk')
m.PSafe=SET('Safe')
THISFORM.LOCKSCREEN=.T.
*!* THISFORM.Timer1.ENABLED=.T.
*!* THISFORM.Timer1.INTERVAL=1
THISFORM.ALWAYSONTOP=.T.
REPORT FORM (LcFrxName) TO PRINTER NOCONSOLE
IF WEXIST('正在列印...')
MOVE WINDOW ('正在列印...') TO -100,-100
ENDIF
THISFORM.ALWAYSONTOP=.F.
THISFORM.LOCKSCREEN=.F.
ON ESCAPE &Escape_wk.
i=0
cMessage="正在輸出到PDF文件,請稍候......"
DO WHILE !FILE(LcPdfName)&&給以時間保存文件
WAIT WINDOW cMessage AT SROW()/2,(SCOLS()-LEN(cMessage))/2  NOWAIT NOCLEAR
i=i+1
=INKEY(1)
IF FILE(LcPdfName) OR i=200
  EXIT
ELSE
  LOOP
ENDIF
ENDDO
RELEASE BullZip &&收尾
SET PRINTER TO NAME (OldPrinter)
WAIT CLEAR
SELECT (lOldSelect)
RETURN FILE(LcPdfName)

LPARA LcFrxName,LcPdfName
Escape_wk = ON("escape")
ON ESCAPE tNoWait=.T.
lcOldPrinter = SET("printer",2)
SET PRINTER TO NAME ('PDFCREATOR')
oPDFC = CREATEOBJECT("PDFCreator.clsPDFCreator","PDFCreator")    &&建立oPDFC物件
WITH oPDFC
    .cStart("/NoProcessingAtStartup")                                                          &&啟動PDFCreator虛擬印表機
    .cVISIBLE=.F.
    .cOption("UseAutosave") = 1
    .cOption("UseAutosaveDirectory") = 1                                                  &&是否使用自動保存的路徑
    .cOption("AutosaveFormat") = 0                                                           &&輸出成0=PDF格式 &&AutosaveFormat：0=PDF，1=PNG，2=JPG，3=BMP，4=PCX，5=TIF，6=PS， 7=EPS，8=TXT，9=PDF，10=PDF，11=PSD，12=PCL，13=RAW，14=SVG
    .cDefaultprinter = "PDFCreator"                                                            &&把虛擬PDFCreator虛擬印表機設定為系統預設印表機
    .cClearCache                                                                                         &&清除快取記憶體
    .ReadyState = 0
    .cOption("UseAutosaveDirectory")=1
    .cOption("AutosaveFilename") = JUSTSTEM(LcPdfName)                   &&指定自動儲存的檔案名稱
    .cOption("AutosaveDirectory") = JUSTPATH(LcPdfName)                   &&指定自動儲存的資料夾路徑
    .cprinterstop=.F.                                                                                     &&在開始執行列印之前必須先指定cPrinterStop為False，表示不是停止狀態
    REPORT FORM (LcFrxName) TO PRINTER NOCONSOLE
    IF WEXIST('正在列印...')
        MOVE WINDOW ('正在列印...') TO -100,-100
    ENDIF
    ON ESCAPE &Escape_wk.
    SET PRINTER TO NAME (lcOldPrinter)                                               &&將當前VFP預設印表機設定回原系統預設印表機
    .cDefaultprinter = lcOldPrinter                                                                &&將當前VFP預設印表機設定回原系統預設印表機
    .cClearCache
ENDWITH                                                                                                      &&清除快取記憶體
RELEASE oPDFC                                                                                           &&釋放oPDFC物件
i=0
DO WHILE !FILE(LcPdfName)                                                                      &&給以時間保存文件
    i=i+1
    =INKEY(1)
    IF FILE(LcPdfName) OR i=1000
        EXIT
    ELSE
        LOOP
    ENDIF
ENDDO
RETURN  FILE(LcPdfName)