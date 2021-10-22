Local miDoc,miLayout,lcStr,cFile
lcStr=''
CREATE CURSOR mondocument (mondococr m)
miDoc = Createobject('MODI.Document')
    oMyProg = NEWOBJECT( 'MyProg' )         && 创建自己的 OCR 识别进度显示
    EVENTHANDLER( miDoc , oMyProg )         && 绑定到 oMiDoc 这个 COM 对象上
    m.cFile = GETFILE( 'bmp;gif;jpg;png;tif')
    IF !EMPTY( m.cFile )
        miDoc.Create( m.cFile )


*miDoc.Create( "D:\无标题.tif")
miDoc.Images(0).OCR
miLayout = miDoc.Images(0).Layout
strLayoutInfo ="Language: " + Transform(miLayout.Language )+Chr(13)+Chr(10)
strLayoutInfo=strLayoutInfo+"Number of characters: " + Transform(miLayout.NumChars)+Chr(13)+Chr(10)
strLayoutInfo=strLayoutInfo+"Number of fonts: "+ Transform(miLayout.NumFonts )+Chr(13)+Chr(10)
strLayoutInfo=strLayoutInfo+"Number of words: " + Transform(miLayout.NumWords)+Chr(13)+Chr(10)+Chr(13)+Chr(10)
strLayoutinfo = strLayoutinfo+miLayout.text
INSERT INTO mondocument (mondococr) VALUES (strLayoutinfo)
MODIFY MEMO mondocument.mondococr
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