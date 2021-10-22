*!* ***********************************************************************
*!* 功能: 使用 Microsoft Office Document Imaging 2003 提供的 OCR 功能
*!*       实现简单的 OCR 识别。
*!* 作者: dkfdtf  - 2007.07.01
*!* ***********************************************************************
LOCAL oMiDoc, cFile

TRY
    oMiDoc = Createobject('MODI.Document')
CATCH
    oMiDoc = NULL
ENDTRY
IF ISNULL( oMiDoc )
    MESSAGEBOX( '没有安装 Office 2007 吧 !?' )
ELSE
    oMyProg = NEWOBJECT( 'MyProg' )         && 创建自己的 OCR 识别进度显示
    EVENTHANDLER( oMiDoc, oMyProg )         && 绑定到 oMiDoc 这个 COM 对象上
    
    m.cFile = GETFILE( 'bmp;gif;jpg;png;tif')
    IF !EMPTY( m.cFile )
        oMidoc.Create( m.cFile )
        ShowStatus(0)
        oMidoc.OCR( 2052 )            && 按简体中文来识别
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
        NOWAIT '  正在识别, 已完成 ' + TRANSFORM( m.tnVal ) + '%  '
ENDFUNC

*!* COM 事件接口实现
DEFINE CLASS MyProg AS Session OLEPUBLIC
 IMPLEMENTS _IDocumentEvents IN "c:/program files/common files/microsoft shared/modi/12.0/mdivwctl.dll"
*    IMPLEMENTS _IDocumentEvents IN "mdivwctl.dll"
    
    PROCEDURE _IDocumentEvents_OnOCRProgress( Progress AS Integer, Cancel AS LOGICAL @ ) AS VOID ;
        HELPSTRING "method OnOCRProgress"
        ShowStatus( Progress )
    ENDPROC
ENDDEFINE