*********************************************
* MARCO PLAZA, 2016
* plazamarco@hotmail.com
* @vfp2nofox
* see webbrowsersink_demo
*********************************************
define class nfwebbrowsersink as form
****************************************************************
	add object webbrowser as shellexplorer
	add object eventcontroller as custom
	ousereventcontroller = ''
	cleareventsondestroy = .t.
	showwindow = 2
	scrollbars = 3
	noLink = .f.

*------------------------------------------------------------------------------
	procedure init( ousereventcontroller  , cleareventsondestroy , noLink )
*------------------------------------------------------------------------------

	with this
		.ousereventcontroller = m.ousereventcontroller
		.cleareventsondestroy = m.cleareventsondestroy
		.noLink = m.noLink
	endwith

*-----------------------------------------------------------------
	procedure eventcontroller.onevent( oevent , oSrc )
*-----------------------------------------------------------------

	 if oevent.eventPhase # 2 
	 	return
	 endif

	tagname = lower(oSrc.tagname)
	eventname = 'on'+lower(oevent.type)

	return thisform.ousereventcontroller.&eventname( oevent, oSrc, m.tagname )

*-----------------------------------------
	procedure navigate( lcurl)
*-----------------------------------------

	with this.webbrowser
		.urlbase = lcurl
		.navigate(lcurl,0x4)
	endwith

*-----------------------------------------
	procedure navigatetostring( lchtml )
*-----------------------------------------

	this.webbrowser.navigatetostring( m.lchtml )

*-----------------------------------------
	procedure destroy
*-----------------------------------------

	declare Sleep in win32api integer

	with this.webbrowser

		.navigate('about:blank')

		do while .readystate # 4 or .busy
			Sleep(50)
			doevents force
		enddo

		if this.cleareventsondestroy
			clear events
		endif

	endwith


**********************************************
enddefine
**********************************************

*********************************************************
define class shellexplorer as olecontrol
*********************************************************
	oleclass = 'shell.explorer.2'
	jscript = ''
	anchor=15
	urlbase = ''
	ninj=0


*---------------------------------------
	function init
*---------------------------------------
	_vfp.autoyield=.f.
	with this as shell.explorer.2
		.jscript = this.genjscript()
		.width=.parent.width
		.height=.parent.height
		.silent = .f.
	endwith

*---------------------------------------------
	function destroy
*---------------------------------------------
	_vfp.autoyield=.t.

*-----------------------------------------
	procedure navigatetostring( lchtml )
*-----------------------------------------

	WITH this

		if vartype(.document ) # 'O'
			this.navigate('about:blank')
		endif

		with .document
			.open()
			.write( m.lchtml )
			.close()
		endwith

		.injectjs()

	ENDWITH

*-----------------------------------------
	protected procedure documentcomplete
*-----------------------------------------
		lparameters pdisp, url

		if thisform.noLink
			return
		endif

		if url # 'about:blank'  and type('this.document') = 'O' and not 'ae2vfp' $ this.document.documentelement.innerhtml
			this.injectjs()
		endif

*-------------------------------------------
function injectjs()
*-------------------------------------------

		tsec = seconds()

		with this.document

			messagebox( 'IE Mode:'+transform(.documentmode) , 0 )

*Link events

			js = .createelement('Script')
			js.type='text/javascript'
			js.text = this.jscript
			js.id ='vfpScript'
			.getelementsbytagname("head").item(0).appendchild(m.js)

			.script.linkevents(thisform.eventcontroller)

		endwith

*---------------------------------------------
	protected function genjscript()
*---------------------------------------------

#define formelements 'image,input,a,textarea,table,div,button,p,h1,h2,h3,td,th,tr,span,text'

		text to _jsText noshow textmerge

function linkevents(oeventController) {

    ovfp = oeventController;

    ae2vfp('change', 'select,input');
    ae2vfp('select', 'input,select,textarea,checkbox');
    ae2vfp('focus', 'label,input,select,textarea,button');
    ae2vfp('blur', FORMELEMENTS);
    ae2vfp('cut', 'input,textarea');
    ae2vfp('paste', 'input,textarea');
    ae2vfp('reset', 'form');
    ae2vfp('submit', 'form');
    ae2vfp('load', 'body');
    ae2vfp('unload', 'body');
    ae2vfp('mouseup', FORMELEMENTS);
    ae2vfp('mousedown', FORMELEMENTS);
    ae2vfp('mouseover', FORMELEMENTS);
    ae2vfp('mouseenter', FORMELEMENTS);
    ae2vfp('wheel', 'textarea,input' );
    ae2vfp('click', FORMELEMENTS);
    ae2vfp('dblclick', FORMELEMENTS);
    ae2vfp('keypress', 'input,button,textarea');
    ae2vfp('keyup', 'input,textarea');
    ae2vfp('keydown', 'input,textarea');
    ae2vfp('contextmenu', 'body');
}

function ae2vfp(cEvent, cTags) {

var  cTags = cTags.split(',')

    for (var t = 0; t < cTags.length; t++) {
        var oTags = document.getElementsByTagName(cTags[t]);
        for (var i = 0; i < oTags.length; i++) {

            if (oTags(i).addEventListener) {

                oTags(i).addEventListener(cEvent, passEvent2vfpIE9, false );

            }

        }

    }
}


function passEvent2vfpIE9() {


    var _doDefault = ovfp.onEvent( event, event.currentTarget );

    if (!_doDefault) {
        window.event.preventDefault();
	}

}


		ENDTEXT

		return _jstext




*************************************************
enddefine
*************************************************


*****************************************************
define class eventcontroller as custom
*****************************************************

	procedure onchange( oevent, osource, ctagname )
	procedure onselect( oevent, osource, ctagname )
	procedure onfocus( oevent, osource, ctagname )
	procedure onblur( oevent, osource, ctagname )
	procedure oncut( oevent, osource, ctagname )
	procedure onpaste( oevent, osource, ctagname )
	procedure onreset( oevent, osource, ctagname )
	procedure onsubmit( oevent, osource, ctagname )
	procedure onload( oevent, osource, ctagname )
	procedure onunload( oevent, osource, ctagname )
	procedure onmouseup( oevent, osource, ctagname )
	procedure onmousedown( oevent, osource, ctagname )
	procedure onmouseover( oevent, osource, ctagname )
	procedure onmouseenter( oevent, osource, ctagname )
	procedure onclick( oevent, osource, ctagname )
	procedure ondblclick( oevent, osource, ctagname )
	procedure onkeypress( oevent, osource, ctagname )
	procedure onkeyup( oevent, osource, ctagname )
	procedure onkeydown( oevent, osource, ctagname )
	procedure contextmenu( oevent, osource, ctagname )

****************************************************
enddefine
****************************************************
