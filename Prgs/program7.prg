loTest = Createobject("Form1")
loTest.Show(1)

Define Class Form1 As Form
      AutoCenter= .T.
      Height = 493
      Width = 955
      Caption = 'Excel within our Form'
      _nHwnd = .F.
      _oExcel = .F.

      Add Object Shape1 As Shape With ;
            Top = 36, Left = 6, Height= 445, Width = 936,;
            BackColor = Rgb(255,255,255), BorderColor = Rgb(0,128,192)

      Add Object label1 As Label With ;
            Top = 15, Left = 6, Caption = 'Preview', FontBold = .T.,;
            FontName = 'Calibri', FontSize = 12, AutoSize = .T.

      Add Object label2 As Label With ;
            Top = 12, Left = 836, Caption = 'Zoom', FontBold = .T.,;
            FontName = 'Calibri', FontSize = 12, AutoSize = .T.,;
            Anchor = 9

      Add Object cmdOpen As CommandButton With ;
            Top = 8, Left = 312, Caption = '\<Open', Width = 84, Height = 24

      Add Object cmdSave As CommandButton With ;
            Top = 8, Left = 399, Caption = '\<Save', Width = 84, Height = 24

      Add Object cmdClose As CommandButton With ;
            Top = 8, Left = 486, Caption = '\<Close', Width = 84, Height = 24

      Add Object chkShowTabs As Checkbox With ;
            Top = 12, Left = 732, Caption = 'Show \<Tabs', AutoSize = .T.,;
            Anchor = 9

      Add Object SpinZoom As Spinner With ;
            Top = 10, Left = 882, KeyboardLowValue = 10, SpinnerLowValue = 10,;
            Value = 100, Anchor = 9, Width = 60

      Procedure Load
            Declare Integer SetParent In user32;
                  INTEGER hWndChild,;
                  INTEGER hWndNewParent

            Declare Integer FindWindow In user32;
                  STRING lpClassName, String lpWindowName

            Declare Integer SetWindowPos In user32;
                  INTEGER HWnd,;
                  INTEGER hWndInsertAfter,;
                  INTEGER x,;
                  INTEGER Y,;
                  INTEGER cx,;
                  INTEGER cy,;
                  INTEGER uFlags

            Declare Integer GetWindowLong In User32;
                  Integer HWnd, Integer nIndex

            Declare Integer SetWindowLong In user32 ;
                  Integer HWnd,;
                  INTEGER nIndex,;
                  Integer dwNewLong
      Endproc

      Procedure Resize
            Thisform._SetCoord()
      Endproc

      Procedure Destroy
            If Type('thisform._oexcel') = 'O'
                  This._Clear()
            Endif
      Endproc

      Procedure cmdOpen.Click
            If Type('thisform._oexcel') = 'O'
                  Thisform._Clear()
            Endif
            Thisform._linkapp()
      Endproc

      Procedure cmdSave.Click
            If Type('thisform._oexcel') = 'O'
                  Thisform._oExcel.activeworkbook.Save()
                  Messagebox('Changes made are saved!',64,'Save')
            Else
                  Messagebox('Nothing to save yet!',64,'Opppppssss!')
            Endif
      Endproc

      Procedure cmdClose.Click
            If Type('thisform._oexcel') = 'O'
                  Thisform._Clear()
            Endif
      Endproc

      Procedure SpinZoom.InteractiveChange
            Thisform._oExcel.ActiveWindow.Zoom=Thisform.SpinZoom.Value
      Endproc

      Procedure chkShowTabs.Click
            Thisform._oExcel.ActiveWindow.DisplayWorkbookTabs=This.Value
      Endproc

      Procedure _Clear
            With This
                  With  .Shape1
                        * Show shape
                        .Visible = .T.
                        * Hide window via uFlags
                        SetWindowPos(This._nHwnd, 1, .Left, .Top, .Width, .Height,0x0080)
                  Endwith

                  With ._oExcel
                        * Restore those we have hidden
                        .DisplayFormulaBar = .T.
                        .DisplayStatusBar = .T.
                        .ActiveWindow.DisplayWorkbookTabs=.T.
                        .ActiveWindow.DisplayHeadings=.T.

                        .activeworkbook.Close()
                        .Visible = .F.
                        .Quit
                  Endwith
                  ._oExcel = .F.
            Endwith
      Endproc

      Procedure _HideRibbon
            Local loRibbon
            loRibbon =This._oExcel.CommandBars.Item("Ribbon")
            If m.loRibbon.Height > 0
                  This._oExcel.ExecuteExcel4Macro('Show.Toolbar("Ribbon",False)')
            Endif
      Endproc

      Procedure _linkapp
            Local loExcel As excel.Application, lcFile
            loExcel = Createobject('excel.application')
            lcFile = Getfile('xls,xlsx')
            If !Empty(m.lcFile)
                  loExcel.Workbooks.Open(m.lcFile)

                  * This is so we can tap into it on other methods/events
                  This._oExcel = loExcel

                  With loExcel
                        .Visible = .T.
                        .DisplayAlerts = .F.
                        .Application.ShowWindowsInTaskbar=.F.

                        .DisplayFormulaBar = .F.
                        .DisplayDocumentActionTaskPane=.F.
                        .DisplayStatusBar = .F.

                        * Ensure scroll bars are shown
                        .ActiveWindow.DisplayVerticalScrollBar=.T.
                        .ActiveWindow.DisplayHorizontalScrollBar=.T.

                        * Hide Workbook Tabs
                        .ActiveWindow.DisplayWorkbookTabs=Thisform.chkShowTabs.Value

                        .ActiveWindow.DisplayHeadings=.F.
                        .ActiveWindow.WindowState = -4137  && xlMaximized
                        .ActiveWindow.Zoom=Thisform.SpinZoom.Value

                        * Get a handle on Window
                        nHwnd = FindWindow('XLMain', .Caption)
                  Endwith

                  * Add this so we can work on other methods
                  This._nHwnd = m.nHwnd

                  * Hide Ribbon
                  Thisform._HideRibbon()


                  * Hide the title bar, disallow drag and drop of the excel window
                  Local lnStyle

                  * Get the current style of the window
                  lnStyle = GetWindowLong(nHwnd, -6)

                  * Set the new style for the window
                  SetWindowLong(nHwnd, -16, Bitxor(lnStyle, 0x00400000))

                  * force it inside our form
                  SetParent(nHwnd,Thisform.HWnd)

                  * Size it
                  Thisform._SetCoord()

                  * Hide shape
                  Thisform.Shape1.Visible = .F.
            Endif
      Endproc

      Procedure _SetCoord
            * size it based on Invisible shape
            With This.Shape1
                  SetWindowPos(This._nHwnd, 0, .Left, .Top, .Width, .Height, 2)
            Endwith
      Endproc

Enddefine