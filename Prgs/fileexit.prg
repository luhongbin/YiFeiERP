*
quit
DO WHILE TxnLevel() > 0
ROLLBACK
ENDDO
CLEAR EVENTS
DO WHILE _SCREEN.FormCount > 0
_SCREEN.Forms(1).Release
ENDDO
