#INCLUDE vfpalert.h

LOCAL oMgr && As vfpalert.AlertManager

** Create the AlertManager
oMgr = NEWOBJECT("vfpalert.AlertManager")

*?"oMgr Count = " + TRANSFORM(oMgr.Alerts.Count)

** Create an event handler for the first alert (o)
x=CREATEOBJECT("myregularclass")

** Create an event handler for the second alert (o2)
y=NEWOBJECT("myclass")

** We won't do any event handler for the third alert (o3)

** First alert
lO = oMgr.NewAlert()

*?"oMgr Count = " + TRANSFORM(oMgr.Alerts.Count)

** Second alert
lO2 = oMgr.NewAlert()

*?"oMgr Count = " + TRANSFORM(oMgr.Alerts.Count)

** Third alert
lO3 = oMgr.NewAlert()

*?"oMgr Count = " + TRANSFORM(oMgr.Alerts.Count)

** SetCallback() for the first two alerts
lO.SetCallback(x)
lO2.SetCallback(y)

** Launch the first alert form
lO.Alert("This is a test of the alert system.",64,"First Alert")
INKEY(.5,"hc")

** Second alert form
lO2.Alert("This is a test of the alert system.",DA_TYPEMULTI+DA_ICONINFORMATION,"Second Alert","How about this subject?",,"Delete whatever this is","e:\delete16.ico","What history?","e:\history16.ico")
INKEY(.5,"hc")

** Third alert form
lO3.Alert("This is a test of the alert system.",129 + 4096,"Third Alert","This one has no callback","f:\test.ico")

ACTIVATE SCREEN

*?"oMgr Count = " + TRANSFORM(oMgr.Alerts.Count)

** Just for demonstration purposes, 'hang' the system 
** long enough to see the results.
WAIT WINDOW "" TIMEOUT 20

y = null
x = null
oMgr = null

DEFINE CLASS myregularclass AS Custom 
	PROCEDURE AlertResult(tnResult AS Number) AS Number
		?("You selected: " + TRANSFORM(tnresult) + " using AlertResult() in a normal Session class")
	ENDPROC
ENDDEFINE

DEFINE CLASS myclass AS Custom OLEPUBLIC
	IMPLEMENTS Ialertevents IN "vfpalert.AlertEvents"

	PROCEDURE Ialertevents_AlertResult(tnResult AS Number) AS Number
		?("You selected: " + TRANSFORM(tnresult) + " in the Ialertevents.")
	ENDPROC
ENDDEFINE

