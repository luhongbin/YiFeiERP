*!* ***********************************************************************
*!* ����: ʹ�� Microsoft Office Document Imaging 2003 �ṩ�� OCR ����
*!*       ʵ�ּ򵥵� OCR ʶ��
*!* ����: dkfdtf  - 2007.07.01
*!* ***********************************************************************
LOCAL oMiDoc, cFile

TRY
    oMiDoc = Createobject('MODI.Document')
CATCH
    oMiDoc = NULL
ENDTRY
IF ISNULL( oMiDoc )
    MESSAGEBOX( 'û�а�װ Office 2007 �� !?' )
ELSE
    oMyProg = NEWOBJECT( 'MyProg' )         && �����Լ��� OCR ʶ�������ʾ
    EVENTHANDLER( oMiDoc, oMyProg )         && �󶨵� oMiDoc ��� COM ������
    
    m.cFile = GETFILE( 'bmp;gif;jpg;png;tif')
    IF !EMPTY( m.cFile )
        oMidoc.Create( m.cFile )
        ShowStatus(0)
        oMidoc.OCR( 2052 )            && ������������ʶ��
        WAIT CLEAR
        CLEAR
        ? oMiDoc.Images(0).Layout.text
        ?Chr(13)+Chr(10)
		miLayout = oMiDoc.Images(0).Layout
		strLayoutInfo ="Language: " + Transform(miLayout.Language )+Chr(13)+Chr(10)
		strLayoutInfo=strLayoutInfo+"Number of characters: " + Transform(miLayout.NumChars)+Chr(13)+Chr(10)
		strLayoutInfo=strLayoutInfo+"Number of fonts: "+ Transform(miLayout.NumFonts )+Chr(13)+Chr(10)
		strLayoutInfo=strLayoutInfo+"Number of words: " + Transform(miLayout.NumWords)+Chr(13)+Chr(10)+Chr(13)+Chr(10)
		strLayoutinfo = strLayoutinfo+miLayout.text    
		?    strLayoutinfo 
    ENDIF 
    oMiDoc.Close()
    RELEASE oMiDoc
ENDIF

FUNCTION ShowStatus( tnVal )
    WAIT WINDOW AT SROWS()/2, SCOLS()/2-20 ;
        NOWAIT '  ����ʶ��, ����� ' + TRANSFORM( m.tnVal ) + '%  '
ENDFUNC

*!* COM �¼��ӿ�ʵ��
DEFINE CLASS MyProg AS Session OLEPUBLIC
 IMPLEMENTS _IDocumentEvents IN "c:/program files/common files/microsoft shared/modi/12.0/mdivwctl.dll"
*    IMPLEMENTS _IDocumentEvents IN "mdivwctl.dll"
    
    PROCEDURE _IDocumentEvents_OnOCRProgress( Progress AS Integer, Cancel AS LOGICAL @ ) AS VOID ;
        HELPSTRING "method OnOCRProgress"
        ShowStatus( Progress )
    ENDPROC
ENDDEFINE