oMgr = CREATEOBJECT("VFPAlert.AlertManager")
oAlert = oMgr.NewAlert()

x=NEWOBJECT("myclass")

oAlert.SetCallback(x)

oAlert.Alert("Hello World")

INKEY(15,"hc")

DEFINE CLASS myclass AS session OLEPUBLIC

	IMPLEMENTS Ialertevents IN "vfpalert.AlertEvents"

	PROCEDURE Ialertevents_AlertResult(tnResult AS Number) AS Number
	 	?"You selected: " + TRANSFORM(tnResult)
	ENDPROC

ENDDEFINE