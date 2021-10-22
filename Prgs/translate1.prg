*!*	DECLARE INTEGER InternetOpen IN wininet.DLL STRING, INTEGER, STRING, STRING, INTEGER
*!*	DECLARE INTEGER InternetOpenUrl IN wininet.DLL INTEGER, STRING, STRING, INTEGER, INTEGER, INTEGER
*!*	DECLARE INTEGER InternetReadFile IN wininet.DLL INTEGER, STRING @, INTEGER, INTEGER @
*!*	DECLARE short InternetCloseHandle IN wininet.DLL INTEGER
*!*	Private hfile
*!*	hopen = internetopen("vfp 6.0",1,0,0,0)
*!*	hfile = InternetOpenUrl(hopen,"http://translate.google.cn","",0,16,0)
*!*	If hfile <> 0
	oExcel=Createobject("Excel.application")
	oExcel.Workbooks.Open("D:\11.xls")
	oExcel.Visible=.T.	
	With oExcel
	    lnSheetCount=.WorkBooks(1).Sheets.Count &&统计工作表数量
	Endwith
	For Each oMyVar In oExcel.sheets
		mlhb=translate(oMyVar.Name)
		oExcel.Worksheets(oMyVar.Name).Select
		oExcel.Worksheets(oMyVar.Name).Name=mlhb&&+'('+oMyVar.Name+')'
		oExcel.Worksheets(oMyVar.Name).Activate
		R=oExcel.ActiveSheet.UsedRange.Rows.Count &&有数据的总行数
		C=oExcel.ActiveSheet.UsedRange.Columns.Count &&有数据的总列数

		FOR r1=1 TO r 
			FOR C1=1 TO C
				TR=ALLTRIM(STR(R1))
				TC=ALLTRIM(STR(C1))
				oExcel.ActiveSheet.Cells(&TR,&TC).Select &&选中数据	
				*ct=oExcel.ActiveSheet.Cells(&TR,&TC).Comment.Text
*				IF TYPE(oExcel.ActiveSheet.Cells(&TR,&TC).value)='C'
				IF  vartype(oExcel.ActiveSheet.Cells(&TR,&TC).value)='C'
					mlht=ALLTRIM(oExcel.ActiveSheet.Cells(&TR,&TC).value)
					IF LEN(MLHT)>1
						mlhb=translate(mlht)
						oExcel.ActiveSheet.Cells(&TR,&TC).value=mlhb
					ENDIF	
*!*					IF CT<>mlht
*!*						IF LEN(ALLTRIM(ct))=0 
*!*							oExcel.ActiveSheet.Cells(&TR,&TC).Comment.Text.VALUE=mlht
*!*						ELSE
*!*							oExcel.ActiveSheet.Cells(&TR,&TC).addcomment(mlht+'('+ct+')')
*!*						ENDIF 	
*!*					ENDIF 	
				ENDIF 
			ENDFOR 	
		ENDFOR 	
		WAIT WINDOW oMyVar 
	Next oMyVar
*!*	Else
*!*	    Messagebox("获取GOOGLE在线翻译信息失败！",48,"信息提示")
*!*	Endif
	?'当前EXCEL表中工作表的数目为：'+Alltrim(Str(lnSheetCount))
oExcel.ActiveWorkbook.Save
oExcel.Quit
Release oExcel
*!*	 = InternetCloseHandle(hfile)

*!*	lcRemoteUrl="http://translate.google.com.hk/?hl=zh-CN&tab=wT#en/zh-CN/hello" &&CHXX0008表示：北京
*!*	lcRemoteFile=lcRemoteUrl
*!*	lcLocalFile = "c:/weather.txt"
*!*	Declare Integer DeleteUrlCacheEntry In Wininet.Dll String szUrl
*!*	Declare Integer URLDownloadToFile In urlmon.Dll Integer pCaller,String szURL,;
*!*	    String szFileName,Integer dwReserved,Integer lpfnCB
*!*	=DeleteUrlCacheEntry(lcRemoteUrl) &&清理缓存
*!*	If URLDownloadToFile(0,lcRemoteFile,lcLocalFile,0,0)<>0
*!*	    Messagebox('读取数据失败！',48,'信息提示')
*!*	    Return
*!*	Endif
*!*	lcWeather=Filetostr("c:/weather.txt")
*!*	        public string TranslateBabelFish(string Text, string FromCulture, string ToCulture)
*!*	        {
*!*	            FromCulture = GetNeutralCulture(FromCulture).TwoLetterISOLanguageName;
*!*	            ToCulture = GetNeutralCulture(ToCulture).TwoLetterISOLanguageName;
*!*	 
*!*	            // Override since yahoo doesn't understand zh-Hans/zh-Hant
*!*	            if (FromCulture == "zh")
*!*	            {
*!*	                if (GetNeutralCulture(FromCulture).ThreeLetterISOLanguageName == "CHT")
*!*	                {
*!*	                    FromCulture = "zt";
*!*	                }
*!*	            }
*!*	 
*!*	            if (ToCulture == "zh")
*!*	            {
*!*	                if (GetNeutralCulture(ToCulture).ThreeLetterISOLanguageName == "CHT")
*!*	                {
*!*	                    ToCulture = "zt";
*!*	                }
*!*	            }
*!*	            string LangPair = FromCulture + "_" + ToCulture;
*!*	 
*!*	            string url = string.Format(@"http://babelfish.yahoo.com/translate_txt?ei=UTF-8&doit=done&fr=bf-home&intl=1&tt=urltext&trtext={0}&lp={1}&btnTrTxt=Translate",
*!*	                                       HttpUtility.UrlEncode(Text), LangPair);
*!*	 
*!*	            // Retrieve Translation with HTTP GET call
*!*	            string Html = null;
*!*	            try
*!*	            {
*!*	                WebClient web = new WebClient();
*!*	 
*!*	                // MUST add the following browser user agent or else yahoo doesn't respond correctly (WTF Yahoo?)
*!*	                web.Headers.Add(HttpRequestHeader.UserAgent, "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)");
*!*	 
*!*	                // Make sure we have response encoding to UTF-8
*!*	                web.Encoding = Encoding.UTF8;
*!*	                Html = web.DownloadString(url);
*!*	            }
*!*	            catch (Exception ex)
*!*	            {
*!*	                ErrorMessage = Resources.Resources.ConnectionFailed + ": " +
*!*	                                    ex.GetBaseException().Message;
*!*	                return null;
*!*	            }
*!*	 
*!*	            // <div id="result"><div style="padding:0.6em;">Hallo</div></div>
*!*	            string Result = StringUtils.ExtractString(Html, "<div id=\"result\">", "</div>");
*!*	            if (Result == "")
*!*	            {
*!*	                ErrorMessage = "Invalid search result. Couldn't find marker.";
*!*	                return null;
*!*	            }
*!*	            Result = Result.Substring(Result.LastIndexOf(">") + 1);
*!*	 
*!*	            return HttpUtility.HtmlDecode(Result);
*!*	        }


*!*	oGt = NEWOBJECT("ugt","ugt.prg")
*!*	?oGt.translate("en","es","The rain in spain falls mainly in the plain")

*!*	DEFINE CLASS ugt AS custom
*!*		apiUrl = "http://translate.google.com.hk/translate_t?&"+"hl=en&"+"ie=UTF8"
*!*		apiStartTags = "<"+"div id=result_box dir=ltr>"
*!*		apiEndTags = "<"+"/div>"
*!*		FUNCTION translate(lcFrom,lcTo,lcText)
*!*			LOCAL lcHttp AS MSXML2.XMLHTTP
*!*			LOCAL lcRequest AS String
*!*			lcRequest = this.apiUrl+"langpair="+this.urlEncode(lcFrom+"|"+lcTo)+"&"+"text="+this.urlEncode(lcText)
*!*			lcHttp = CREATEOBJECT("MSXML2.XMLHTTP")
*!*			*!-- lcHttp.open("GET",this.apiUrl,.f.)
*!*	                lcHttp.open("GET",lcRequest,.f.)
*!*			lcHttp.send()
*!*			IF lcHttp.status == 200
*!*				lcText = STREXTRACT(lcHttp.responseText,this.apiStartTags,this.apiEndTags)
*!*			ENDIF
*!*			RETURN lcText
*!*		ENDFUNC
*!*		
*!*		FUNCTION urlEncode
*!*			PARAMETERS tcValue, llNoPlus
*!*			LOCAL lcResult, lcChar, lnSize, lnX
*!*			
*!*			*** Do it in VFP Code
*!*			lcResult=""
*!*			
*!*			FOR lnX=1 to len(tcValue)
*!*			   lcChar = SUBSTR(tcValue,lnX,1)
*!*			   IF ATC(lcChar,"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") > 0
*!*			      lcResult=lcResult + lcChar
*!*			      LOOP
*!*			   ENDIF
*!*			   IF lcChar=" " AND !llNoPlus
*!*			      lcResult = lcResult + "+"
*!*			      LOOP
*!*			   ENDIF
*!*			   *** Convert others to Hex equivalents
*!*			   lcResult = lcResult + "%" + RIGHT(transform(ASC(lcChar),"@0"),2)
*!*			ENDFOR
*!*		
*!*			RETURN lcResult
*!*		ENDFUNC
*!*	ENDDEFINE