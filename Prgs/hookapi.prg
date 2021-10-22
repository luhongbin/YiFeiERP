*!*     step:
*!*     1.execute hookexample.scx
*!*     2.click load libraries button
*!*     3.double click user32.dll libraried used item.
*!*     4.select messageboxA item in function used listbox
*!*     5.click hook api   button
*!*     6.click testMessageBox button

*!*     luyis(coolyylu)
*!*     qq:95865818
*!*     mail:95865818@qq.com
*!*     date:2009-02-10

PUBLIC oform1

oform1=NEWOBJECT("hookexample")
oform1.Show
RETURN



 **************************************************
*-- Form:          form1 (d:\editplus\vfptool\hookexample.scx)
*-- ParentClass:   form
*-- BaseClass:     form
*-- Time Stamp:    02/10/09 02:37:14 PM
*
DEFINE CLASS hookexample AS form


    Height = 510
    Width = 631
    ShowWindow = 2
    DoCreate = .T.
    AutoCenter = .T.
    Caption = "Example of API Hook in Visual Foxpro 9"
    AllowOutput = .F.
     hm = .F.


    ADD OBJECT command1 AS commandbutton WITH ;
        Top = 209, ;
        Left = 474, ;
        Height = 27, ;
        Width = 120, ;
        Anchor = 8, ;
        Caption = "TestMessageBox", ;
        Name = "Command1"


    ADD OBJECT command2 AS commandbutton WITH ;
        Top = 165, ;
        Left = 474, ;
        Height = 27, ;
        Width = 120, ;
        Anchor = 8, ;
        Caption = "Start   API Hook", ;
        Name = "Command2"


    ADD OBJECT command3 AS commandbutton WITH ;
        Top = 255, ;
        Left = 474, ;
        Height = 27, ;
        Width = 120, ;
        Anchor = 8, ;
        Caption = "Cancel API Hook", ;
        Name = "Command3"


    ADD OBJECT label1 AS label WITH ;
        AutoSize = .T., ;
        Caption = "Libraries Used:", ;
        Height = 17, ;
        Left = 4, ;
        Top = 8, ;
        Width = 87, ;
        Name = "Label1"


    ADD OBJECT lstlib AS listbox WITH ;
        Anchor = 10, ;
        BoundColumn = 1, ;
        ColumnCount = 2, ;
        ColumnWidths = "240,120", ;
        Height = 105, ;
        ColumnLines = .T., ;
        Left = 0, ;
        Sorted = .T., ;
        Top = 30, ;
        Width = 443, ;
        BoundTo = .F., ;
        Name = "lstlib"


    ADD OBJECT label2 AS label WITH ;
        AutoSize = .T., ;
        Caption = "Funtions Used:", ;
        Height = 17, ;
        Left = 7, ;
        Top = 141, ;
        Width = 86, ;
        Name = "Label2"


    ADD OBJECT lstfunc AS listbox WITH ;
        Anchor = 15, ;
        BoundColumn = 1, ;
        ColumnCount = 2, ;
        ColumnWidths = "240,120", ;
        Height = 326, ;
        ColumnLines = .T., ;
        Left = 0, ;
        Sorted = .T., ;
        Top = 162, ;
        Width = 443, ;
        BoundTo = .F., ;
        Name = "lstfunc"


    ADD OBJECT command4 AS commandbutton WITH ;
        Top = 299, ;
        Left = 474, ;
        Height = 27, ;
        Width = 120, ;
        Anchor = 8, ;
        Caption = "E\<xit Example", ;
        Name = "Command4"


    ADD OBJECT command5 AS commandbutton WITH ;
        Top = 48, ;
        Left = 468, ;
        Height = 27, ;
        Width = 120, ;
        Anchor = 8, ;
        Caption = "List Libraries", ;
        Name = "Command5"


    ADD OBJECT text1 AS textbox WITH ;
        Anchor = 8, ;
        Value = [messagebox("my first time hook" ,16 ,"caption me")], ;
        Height = 84, ;
        Left = 456, ;
        Top = 359, ;
        Width = 156, ;
        Name = "Text1"


    ADD OBJECT label3 AS label WITH ;
        AutoSize = .T., ;
        Caption = "Test Code:", ;
        Height = 17, ;
        Left = 456, ;
        Top = 336, ;
        Width = 62, ;
        Name = "Label3", ;
        Anchor = 8


    PROCEDURE libcallback
        lparameters tcName ,tcAddr

        with This.lstlib
             .AddItem(tcName)
              .List[.NewIndex, 2] = tcAddr
        endwith
    ENDPROC


    PROCEDURE functioncallback
        lparameters tcName ,tcAddr

        with This.lstfunc 
             .AddItem(tcName)
              .List[.NewIndex, 2] = tcAddr
        endwith
    ENDPROC


    PROCEDURE Init
        set procedure to hookapiinvfp.prg additive 
         =declaredll()
    ENDPROC


    PROCEDURE command1.Click

         *messagebox([my first time hook] ,16 ,"caption me")
        local lc
         lc = alltrim(thisform.text1.Value )
         &lc
    ENDPROC


    PROCEDURE command2.Click

        local hi as hookinfo of hookapiinvfp.prg
        local lc
         lc = seconds()
        set message to [Hooking function '] + thisform.lstfunc.DisplayValue    + ;
            [' of lib '] + thisform.lstlib.DisplayValue   + [' ...]
            
            
         hi = thisform.hm.addhookinfo(thisform.lstlib.DisplayValue ,;
                                    thisform.lstfunc.DisplayValue ,"HookFunc")

         hi.addparams("long" ,4)
         hi.addparams("string" ,4)
         hi.addparams("string" ,4)
         hi.addparams("long" ,4)
         hi.hook()
        set message to [Compelted!]
         ?'Executed time:'+transform(seconds()-lc)+'sec'
    ENDPROC


    PROCEDURE command3.Click

        thisform.hm.removehookinfo(thisform.lstlib.DisplayValue ,;
                                    thisform.lstfunc.DisplayValue)
    ENDPROC


    PROCEDURE lstlib.DblClick
         #define GETTYPE_ALL 0
        public _ofc 
         _ofc = thisform 
        thisform.lstfunc.Clear()
        Thisform.FunctionCallBack("\ Function Name" ,"\   Function Address")
         HookAPIByName(thisform.hm.hMODULE ,This.DisplayValue ,"_ofc.functioncallback" ,GETTYPE_ALL)
         _ofc = null
        release _ofc 
    ENDPROC


    PROCEDURE lstlib.Init
        Thisform.libcallback("\ Library Name" ,"\   Library Address" )
    ENDPROC


    PROCEDURE lstfunc.Click
        _cliptext = this.DisplayValue 
    ENDPROC


    PROCEDURE lstfunc.Init
        Thisform.FunctionCallBack("\ Function Name" ,"\   Function Address")
    ENDPROC


    PROCEDURE lstfunc.DblClick
        messagebox(this.DisplayValue)
    ENDPROC


    PROCEDURE command4.Click
        if vartype(thisform.hm)=[O] and !isnull(thisform.hm)
            thisform.hm.RemoveAllHookInfo()
        endif
         UnDeclareDLL()
        ThisForm.Release 
    ENDPROC


    PROCEDURE command5.Click
         #define GETTYPE_ALL 0
        local hm as HookManager of hookapiinvfp.prg
         hm = createobject([HookManager])
        thisform.hm = hm

        public ohex
         ohex = thisform
         LookupIAT(hm.hMODULE ,[ohex.libcallback] ,GETTYPE_ALL)
         ohex = NULL
        release ohex
    ENDPROC


ENDDEFINE
*
*-- EndDefine: form1
************************************************** 

