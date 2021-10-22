SET DEFAULT TO d:\trade\alert
SET PROCEDURE TO LOCFILE("testsample.prg")
oMgr = CREATEOBJECT("VFPAlert.AlertManager")
oAlert = oMgr.NewAlert()
SET PROCEDURE TO testsample.prg ADDITIVE
oCB = CREATEOBJECT("MyInvoice")

	cText = 'ºú½ÁÂù²ø'
	cTitle = 'ÂÒÆß°ËÔã'
	cSubject = '¹«¹²»ù´¡'
	nType = 1
	nIcon = 32
	cIcon = ""	&&d:\trade\alert\invoice.ico

	cTask1 = ""
	cTask1Icon = ""
	cTask2 = ""
	cTask2Icon = ""		
oAlert.SetCallback(oCB)	
oAlert.Alert(cText,nType+nIcon,cTitle,cSubject,cIcon,cTask1,cTask1Icon,cTask2,cTask2Icon)				

oMgr = NULL
SET PROCEDURE TO 

CLEAR EVENTS