*************************************************************
* Marco plaza, 2016
* vfp2nofox@gmail.com
* github: https://github.com/vfp2nofox/nfWebBrowserSink
*************************************************************
parameters noJs

#define cr CHR(13)+CHR(10)

* 1) implement events however you want by subclassing  eventController class you'll find in nfWebBrowserSink.prg
eventController  = newOBJECT('myEventController','nfWebBrowserSink.prg')

* 2) for this demo, we create a form with a textBox just to show some events as they occur:
eventViewer = CREATEOBJECT( 'eventViewer', m.eventController )

* 3) create the web browser based on nfWebBrowserSink , pass the eventController & clearEventsOnDestroy flag

#define clearEventsOndestroy .t.

oForm = newObject('nfWebBrowserSink','nfWebBrowserSink.prg','',m.eventController , clearEventsOndestroy , noJs )

* position windows...

WITH oForm

	.Width = 900
	.Height = 800
	.left = _screen.Width-650
	.top = 10
	.visible = .t.
	.webbrowser.silent = .t.

ENDWITH

with eventViewer
	.width = 500
	.left = oForm.left - .width - 10
	.visible = .t.
endwith


* 4) test dynamically created html form from a northwind table:
Clear
Close Data
close tables all

Use (SYS(2004)+'samples\northwind\orders')
nfScaffold( 'testForm.html' , 'Edge') && will generate a html form in current folder

* 5) open url/file path:

*oForm.navigateToString(tableX())
*oForm.Navigate( fullpath('testForm.html') )
*oForm.Navigate( "http://getbootstrap.com/javascript" )
*oForm.Navigate( "http://amsul.ca/pickadate.js/")
oForm.navigate('http://m.mlb.com/player/408234/miguel-cabrera#sectionType=career')
Read Events



*********************************************************************
Define Class myeventcontroller As eventController Of nfWebBrowserSink
*********************************************************************
	sm = ''


*----------------------------------------------------
	Procedure onmousedown( oevent, osource, ctagname )
*----------------------------------------------------

	Do Case
	Case m.ctagname = 'a' AND oevent.Button = 2
		This.sm = 'Right mouse button over  <a> tag: '+cr+osource.innertext+cr+'Leads to:'+osource.href+' Id: '+osource.id
	Case m.ctagname = 'img' AND oevent.Button = 2
		This.sm = 'Right mouse button Over Image Source '+cr+osource.src+' Id: '+osource.id
	Endcase

*----------------------------------------------------------------------
	Procedure onmouseEnter( oevent, osource, ctagname )
*----------------------------------------------------------------------
	This.sm = 'MOUSEENTER  Tag: '+upper(m.tagName)+' ID: '+osource.id   +' innerText: '+osource.innertext

	if ctagname = 'td'
		this.sm =  'Row '+ transform( osource.parentNode.rowIndex )+' Column '+transform( osource.cellIndex +1 )
	endif

*-------------------------------------------------------
	Procedure onkeydown( oevent, osource, ctagname )
*-------------------------------------------------------
	This.sm =  'onKeyDown - tagName: '+ctagname

*-----------------------------------------------------
	Procedure onwheel( oevent, osource, ctagname )
*-----------------------------------------------------
	this.sm = 'MOUSE WHEEL OVER '+m.ctagname

*-----------------------------------------------------
	Procedure onchange( oevent, osource, ctagname )
*-----------------------------------------------------

	this.sm = 'You changed tag '+m.ctagname+' value: "'+Rtrim(osource.Value)+'" on element ID:'+Evl(osource.Id,'undefined')+' NAME:'+Evl(osource.Name,'undefined')
	MESSAGEBOX(this.sm,0)

*-----------------------------------------------------
	Procedure onclick(oevent, osource, ctagname )
*-----------------------------------------------------

	this.sm =  ' ONCLICK event phase '+transform(oevent.eventPhase)+' '+IIF(oevent.button=2,'Right','Left') +' button - TagName:'+ctagname+' Id '+osource.id
	if ctagname = 'a' and Messagebox( 	'go to URL: '+osource.href+cr+' Allow navigation? ', 4 ) = 7
		return .f.  && cancel event default
	Endif

*------------------------------------------------------------
	procedure onContextMenu(oevent, osource, ctagname )
*------------------------------------------------------------
	this.sm = ' CONTEXT MENU DISABLED - OVER '+M.ctagname
	return .f.


*-------------------------------------------------------
	procedure onSubmit(oevent, osource, ctagname )
*-------------------------------------------------------

	cJson = '{'
	oDocument = osource.ownerDocument

	Alines(e,'input/select/textarea',1,'/')

	For Each element In e

		oElements = oDocument.getelementsbytagname(element)

		For Each inputvar In oElements

			With inputvar

				Do Case
				Case .Type = 'text' or element = 'select' or ( element = 'input' And ( .Type = 'radio' And .checked ) )
					valor = .Value
				Case element = 'input' And .Type = 'checkbox'
					valor = .checked
				Case element = 'textarea'
					valor = .innertext
				Otherwise
					Loop
				endcase

				cJson = cJson + ["]+.id+[":"]+transform(m.valor)+[",]+cr

			Endwith

		Endfor

	Endfor

	cJson = rtrim(m.cJson,1,','+cr)+'}'

	messagebox( m.cJson,0)


***************************************************
Enddefine
***************************************************



*************************************************
DEFINE CLASS eventViewer as Form
*************************************************

	top = 10
	height = 700
	Width = 300
	left = 20

	ShowWindow = 2

	fontName = 'consolas'
	fontsize = 12
	eventController = .f.

	Add Object eventDisplay As EditBox 	;
		With Left=5,Top=5,Height=695,Width=495,ScrollBars=2,Anchor=15


*---------------------------------
	PROCEDURE init( eventController )
*---------------------------------

	WITH this

		.eventController = m.eventController

		BINDEVENT(.eventController,'sm',this,'showevent',1)

	Endwith


*------------------------------------------
	PROCEDURE showEvent()
*------------------------------------------

	WITH thisform.eventDisplay
		.value = .value + cr + thisform.eventController.sm
		.selStart = LEN(.value)
		.refresh()
	Endwith

*****************************************
ENDDEFINE
*****************************************




*-----------------------------------------
function bubblingtest
*-----------------------------------------

text to html noshow

<!doctype html>

<html>
<head>
 <meta http-equiv="X-UA-Compatible" content = "IE=Edge" />

<style type="text/css">
div.container {
	margin: 0;
	padding: 20px;
	border: thin black solid;
	background-color: #cfc;
}
#d1, #d3, #d5 {
	background-color: #ffc;
}
#d1 {
	width: 450px;
	margin: 10px;
}
#d5 {
	text-align: center;
	font-weight: bold;
}
</style>

</head>
<body>

	<div id="capture">
		<div id="d1" class="container">
			<div id="d2" class="container">
				<div id="d3" class="container">
					<div id="d4" class="container">
						<div id="d5" class="container">
							Click here. </div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>

ENDTEXT

return m.html

