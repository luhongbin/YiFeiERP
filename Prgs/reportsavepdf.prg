LPARA LcFrxName,LcPdfName,LcTableName
&&��Ҫ���bBullzip PDF Printer
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
&&WAIT WINDOW "����ݔ����PDF�ļ�,Ո�Ժ�......" NOWAIT
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
.SetValue("ConFirMoverWrite","No") &&���@ʾ��ӡ�^��
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
IF WEXIST('������ӡ...')
MOVE WINDOW ('������ӡ...') TO -100,-100
ENDIF
THISFORM.ALWAYSONTOP=.F.
THISFORM.LOCKSCREEN=.F.
ON ESCAPE &Escape_wk.
i=0
cMessage="����ݔ����PDF�ļ�,Ո�Ժ�......"
DO WHILE !FILE(LcPdfName)&&�o�ԕr�g�����ļ�
WAIT WINDOW cMessage AT SROW()/2,(SCOLS()-LEN(cMessage))/2  NOWAIT NOCLEAR
i=i+1
=INKEY(1)
IF FILE(LcPdfName) OR i=200
  EXIT
ELSE
  LOOP
ENDIF
ENDDO
RELEASE BullZip &&��β
SET PRINTER TO NAME (OldPrinter)
WAIT CLEAR
SELECT (lOldSelect)
RETURN FILE(LcPdfName)

LPARA LcFrxName,LcPdfName
Escape_wk = ON("escape")
ON ESCAPE tNoWait=.T.
lcOldPrinter = SET("printer",2)
SET PRINTER TO NAME ('PDFCREATOR')
oPDFC = CREATEOBJECT("PDFCreator.clsPDFCreator","PDFCreator")    &&����oPDFC���
WITH oPDFC
    .cStart("/NoProcessingAtStartup")                                                          &&����PDFCreator̓�Mӡ��C
    .cVISIBLE=.F.
    .cOption("UseAutosave") = 1
    .cOption("UseAutosaveDirectory") = 1                                                  &&�Ƿ�ʹ���Ԅӱ����·��
    .cOption("AutosaveFormat") = 0                                                           &&ݔ����0=PDF��ʽ &&AutosaveFormat��0=PDF��1=PNG��2=JPG��3=BMP��4=PCX��5=TIF��6=PS�� 7=EPS��8=TXT��9=PDF��10=PDF��11=PSD��12=PCL��13=RAW��14=SVG
    .cDefaultprinter = "PDFCreator"                                                            &&��̓�MPDFCreator̓�Mӡ��C�O����ϵ�y�A�Oӡ��C
    .cClearCache                                                                                         &&�����ȡӛ���w
    .ReadyState = 0
    .cOption("UseAutosaveDirectory")=1
    .cOption("AutosaveFilename") = JUSTSTEM(LcPdfName)                   &&ָ���ԄӃ���ęn�����Q
    .cOption("AutosaveDirectory") = JUSTPATH(LcPdfName)                   &&ָ���ԄӃ�����Y�ϊA·��
    .cprinterstop=.F.                                                                                     &&���_ʼ������ӡ֮ǰ�����ָ��cPrinterStop��False����ʾ����ֹͣ��B
    REPORT FORM (LcFrxName) TO PRINTER NOCONSOLE
    IF WEXIST('������ӡ...')
        MOVE WINDOW ('������ӡ...') TO -100,-100
    ENDIF
    ON ESCAPE &Escape_wk.
    SET PRINTER TO NAME (lcOldPrinter)                                               &&����ǰVFP�A�Oӡ��C�O����ԭϵ�y�A�Oӡ��C
    .cDefaultprinter = lcOldPrinter                                                                &&����ǰVFP�A�Oӡ��C�O����ԭϵ�y�A�Oӡ��C
    .cClearCache
ENDWITH                                                                                                      &&�����ȡӛ���w
RELEASE oPDFC                                                                                           &&ጷ�oPDFC���
i=0
DO WHILE !FILE(LcPdfName)                                                                      &&�o�ԕr�g�����ļ�
    i=i+1
    =INKEY(1)
    IF FILE(LcPdfName) OR i=1000
        EXIT
    ELSE
        LOOP
    ENDIF
ENDDO
RETURN  FILE(LcPdfName)