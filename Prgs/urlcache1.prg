Create Cursor ttt ( ;
    f1 V(250), f2 V(250), f3 V(30), f4 V(10), f5 V(20), f6 V(20), f7 V(20), f8 V(20))
 
*-- 获取缓冲文件及属性
oo = Createobject("Shell.Application")
oo = oo.Namespace(32)
For each o1 in oo.Items
    Insert into ttt (f1, f2, f3, f4, f5, f6, f7, f8) values ( ;
         oo.GetDetailsOf(o1, 0) ;
        ,oo.GetDetailsOf(o1, 1) ;
        ,oo.GetDetailsOf(o1, 2) ;
        ,oo.GetDetailsOf(o1, 3) ;
        ,oo.GetDetailsOf(o1, 4) ;
        ,oo.GetDetailsOf(o1, 5) ;
        ,oo.GetDetailsOf(o1, 6) ;
        ,oo.GetDetailsOf(o1, 7) ;
        )
EndFor
Locate
 
*-- 显示处理
oh = NewObject('Empty')
For ii = 1 to 8
    AddProperty(oh, Textmerge('f<<ii>>'), oo.GetDetailsOf(Null, ii-1))
EndFor
Browse nowait name oo
With oo as grid
    .AllowCellSelection = .f.
    .HighlightBackColor = Rgb(49,106,197)
    .HighlightForeColor = Rgb(255,255,255)
    For ii = 1 to .ColumnCount
        .Columns(ii).Header1.Caption = GetPem(oh, Textmerge('f<<ii>>'))
    EndFor
    .FontName = 'MS Sans Serif'
    .Columns(1).Width = 250
    .Columns(2).Width = 200
    .Columns(3).Width = 90
    .Columns(4).Width = 40
    .Columns(4).Alignment = 1
    .Columns(5).Width = 90
    .Columns(6).Width = 90
    .Columns(7).Width = 90
    .Columns(8).Width = 90
EndWith
