********************************************************************
* mpScaffold
* author: Marco Plaza 2012 - plazamarco@hotmail.com
* this will generate a simple html form file from a open table
********************************************************************
Parameters filename,IEVERSION


IF VARTYPE(filename) # 'C'
	RETURN
ENDIF

html = ''

If Empty(ALIAS())

	html = '<html> NO TABLE OPEN IN CURRENT AREA </HTML>'

Else

	Dbc = CursorGetProp("Database" )

	If Empty( Dbc )
		html = '<html> table '+lctable+' must belong to a dbc </html>'
	Else
		Open Database (m.dbc)
	Endif

Endif

If !Empty(m.html)
	Strtofile(m.html,m.filename)
	Return
Endif



Set Textmerge To (m.filename)
Set Textmerge On Noshow
\<!DOCTYPE html>
\<HTML>
\	<head>
\ <meta http-equiv="X-UA-Compatible" content = "IE=<<M.IEVERSION>>" />
\<style>
\
\	body
\	{
\   text-align:left;
\	border-style:solid;
\	border-width:1px;
\	border-collapse:collapse;
\	font-family:"Segoe UI Light","Segoe UI","Segoe UI Web Regular","Segoe UI Symbol","Helvetica Neue","BBAlpha Sans";
\	font-size:16px;
\	margin-left:15px;
\   margin-top:3px;
\	overflow-y: auto;
\  	overflow: auto;
\ 	
\	}
\
\  p.banner {
\  text-align:center;
\  background-color:#6993E6;
\	color:white;
\	padding:25px;
\  Font-Size:24px;
\	}
\
\ input {
\ height:22px;
\ margin-top:5px;
\ }
\
\  button {
\ border-style:none;
\	font-family:"Segoe UI Light","Segoe UI","Segoe UI Web Regular","Segoe UI Symbol","Helvetica Neue","BBAlpha Sans";
\  background-color:#6993E6;
\	color:white;
\ padding:20px;
\ font-size:16px;
\ margin:5px;
\}

\</style>
\</head>

\<BODY scroll=no>
\ <img src="<<fullpath('no-fox.jpg')>>" style="float:left;heigth:75px;width:75px;" >
\ <p>
\  <h2  style="text-align:center;"> nfWebBrowserSink Demo IE Mode: 
\ <script>
\ document.write(  document.documentMode )
\ </script>
\ </h2>
\ <p>

\ <p class='banner'>  Scaffolding Form Table: << lower(alias()) >> </p>

\<FORM>

\<p class='formList'>

ncampos = Afields(af)

For N = 1 To ncampos  && Loop for number of fields

	If  af(N,2) $ 'GQ'
		Loop
	Endif

	thisfield = af(N,1)
	fieldval  = Evaluate(thisfield)

\ <<dbgetprop(alias()+'.'+thisField,'FIELD','caption')>>

	If !Empty(fieldval)
\ ( <<dbgetprop(alias()+'.'+thisField,'FIELD','comment')>> )
	Endif

\ :
\ <INPUT id="<<thisField>>"  value="<<fieldVal>>" />
\ </br>

Endfor
\</p>


\<button type='reset' > Reset  </button>
\<button type='submit'> Send </button>
\</FORM>
\</BODY>
\</HTML>

Set Textmerge Off
Set Textmerge To

