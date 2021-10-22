Public oForm
oForm = Createobject('form1')
oForm.Show()

Define Class form1 As Form
      Height = 600
      Width = 900
      Caption = "Chrome Inside VFP Form"
      Desktop = .T.
      AutoCenter = .T.

      Procedure Load
            Declare Integer FindWindow In user32;
                  STRING lpClassName, String lpWindowName

            Declare Integer GetActiveWindow  In user32

            Declare Integer GetWindow In user32 Integer HWnd, Integer wFlag

            Declare Integer GetWindowLong In User32 Integer HWnd, Integer nIndex

            Declare Integer GetWindowTextLength In user32 Integer HWnd

            Declare Integer IsWindow In user32 Integer HWnd

            Declare Integer IsWindowVisible In user32 Integer HWnd

            Declare Integer GetWindowText In user32;
                  INTEGER HWnd, String @lpString, Integer cch

            Declare Integer ShellExecute In shell32.Dll ;
                  INTEGER hndWin, ;
                  STRING cAction, ;
                  STRING cFileName, ;
                  STRING cParams, ;
                  STRING cDir, ;
                  INTEGER nShowWin

            Declare Integer SetWindowLong In user32 Integer HWnd,;
                  INTEGER nIndex, Integer dwNewLong

            Declare Integer SetWindowPos In user32;
                  INTEGER HWnd,;
                  INTEGER hWndInsertAfter,;
                  INTEGER x,;
                  INTEGER Y,;
                  INTEGER cx,;
                  INTEGER cy,;
                  INTEGER uFlags

            Declare Integer SetParent In user32;
                  INTEGER hWndChild,;
                  INTEGER hWndNewParent

            Declare Sleep In kernel32 Integer

            #Define GW_HWNDFIRST  0
            #Define GW_HWNDLAST   1
            #Define GW_HWNDNEXT   2
      Endproc

      Procedure KeyPress
            Lparameters nKeyCode, nCtrlShift
            If nKeyCode = 27
                  Thisform.Release
            Endif
      Endproc

      Procedure Init
            Local lcURL
            lcURL = 'http://www.BAIDU.COM'
            ShellExecute(0,'open','chrome.exe',m.lcURL,'',1)
            Activate Window (Thisform.Name)
            Sleep(1000)
            Thisform.SearchProcess()
      Endproc

      Procedure SearchProcess()
            With This
                  Local hWinActive, hWindow, lcWinText, lSuccess, lnMove
                  hWinActive = GetActiveWindow()
                  hWindow = -1
                  lSuccess = .F.
                  Do While hWindow <> GetWindow(hWinActive, GW_HWNDLAST)
                        If hWindow = -1
                              hWindow = GetWindow(hWinActive, GW_HWNDFIRST)
                        Else
                              hWindow = GetWindow(hWindow, GW_HWNDNEXT)
                        Endif

                        If IsWindow(hWindow) <> 0 And IsWindowVisible(hWindow) <> 0;
                                    And GetWindowTextLength(hWindow) > 0
                              lcWinText = .GetWinText(hWindow)
                              nHwnd = FindWindow(Null, m.lcWinText)
                              If 'Google Chrome' $ m.lcWinText
                                    lSuccess = .T.
                                    Exit
                              Endif
                        Endif
                  Enddo
                  If m.lSuccess
                        lnStyle = GetWindowLong(m.nHwnd, -6)
                        SetWindowLong(m.nHwnd, -16, Bitxor(lnStyle, 0x00400000))

                        * The trick to hide the pesky built-in titlebar of chrome is to
                        * move chrome up that it won't display the titlebar anymore.  Since there is a difference in settings
                        * on each of our machines such as in my end, my bookmarks are shown, then here is my setting
                        * Adjust it based on your end settings of Chrome

                        lnMove = 100

                        With This
                              SetParent(m.nHwnd,.HWnd)
                              SetWindowPos(m.nHwnd, 1, 0, -m.lnMove, .Width, .Height + m.lnMove,0x0040)
                        Endwith
                  Endif
            Endwith

      Endproc

      Function  GetWinText(hWindow)
            Local lnBufsize, lcBuffer
            lnBufsize = 1024
            lcBuffer = Repli(Chr(0), lnBufsize)
            lnBufsize = GetWindowText(hWindow, @lcBuffer, lnBufsize)
            Return  Iif(lnBufsize=0, "", Left(lcBuffer,lnBufsize))
      Endfunc

Enddefine

