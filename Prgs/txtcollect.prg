*--------------------------------------------------------------------------------------------------------------------------------------------------------
* (ES) AUTOGENERADO - 　ATENCI覰!! - 　NO PENSADO PARA EJECUTAR!! USAR SOLAMENTE PARA INTEGRAR CAMBIOS Y ALMACENAR CON HERRAMIENTAS SCM!!
* (EN) AUTOGENERATED - ATTENTION!! - NOT INTENDED FOR EXECUTION!! USE ONLY FOR MERGING CHANGES AND STORING WITH SCM TOOLS!!
*--------------------------------------------------------------------------------------------------------------------------------------------------------
*< FOXBIN2PRG: Version="1.19" SourceFile="txtcollect.scx" /> (Solo para binarios VFP 9 / Only for VFP 9 binaries)
*
*
DEFINE CLASS dataenvironment AS dataenvironment 
 	*< CLASSDATA: Baseclass="dataenvironment" Timestamp="" Scale="" Uniqueid="" ClassIcon="1" />

	DataSource = .NULL.
	Height = 200
	Left = 272
	Name = "Dataenvironment"
	Top = 244
	Width = 520

ENDDEFINE

DEFINE CLASS frmtxtcollect AS form 
 	*< CLASSDATA: Baseclass="form" Timestamp="" Scale="" Uniqueid="" />

	*-- OBJECTDATA items order determines ZOrder / El orden de los items OBJECTDATA determina el ZOrder 
	*< OBJECTDATA: ObjPath="OO" UniqueID="" Timestamp="" />
	*< OBJECTDATA: ObjPath="Text3" UniqueID="" Timestamp="" />
	*< OBJECTDATA: ObjPath="Label6" UniqueID="" Timestamp="" />
	*< OBJECTDATA: ObjPath="Command1" UniqueID="" Timestamp="" />
	*< OBJECTDATA: ObjPath="Label1" UniqueID="" Timestamp="" />

	*<DefinedPropArrayMethod>
		*m: getqichacha
	*</DefinedPropArrayMethod>

	AutoCenter = .T.
	BackColor = RGB(255,255,255)
	BorderStyle = 1
	Caption = "企业信息整理"
	Closable = .T.
	Comment = ""
	ControlBox = .F.
	DoCreate = .T.
	Height = 119
	Icon = '..\others\shipping.ico'
	MaxButton = .T.
	MinButton = .T.
	Movable = .T.
	Name = "frmtxtcollect"
	ShowTips = .T.
	ShowWindow = 2
	Visible = .T.
	Width = 562
	WindowState = 0
	WindowType = 1

	ADD OBJECT 'Command1' AS commandbutton WITH ;
		Caption = "Command1", ;
		Height = 27, ;
		Left = 12, ;
		Name = "Command1", ;
		Top = 84, ;
		Visible = .F., ;
		Width = 84
		*< END OBJECT: BaseClass="commandbutton" />

	ADD OBJECT 'Label1' AS label WITH ;
		AutoSize = .F., ;
		Caption = "注意:不要关闭无解浏览，否则会整理失败；无解浏览会使用代理服务器，请在IE的INTERNET选项中设置：连接->局域网设置->勾选对于本地地址不使用代理服务器(B),以保证OA和ERP等软件正常运行。", ;
		FontSize = 12, ;
		ForeColor = RGB(255,0,0), ;
		Height = 60, ;
		Left = 48, ;
		Name = "Label1", ;
		Top = 12, ;
		Width = 492, ;
		WordWrap = .T.
		*< END OBJECT: BaseClass="label" />

	ADD OBJECT 'Label6' AS label WITH ;
		AutoSize = .T., ;
		BackColor = RGB(255,255,255), ;
		BackStyle = 0, ;
		Caption = "最近工作时间", ;
		Height = 17, ;
		Left = 184, ;
		Name = "Label6", ;
		TabIndex = 3, ;
		Top = 86, ;
		Width = 74
		*< END OBJECT: BaseClass="label" />

	ADD OBJECT 'OO' AS olecontrol WITH ;
		Height = 24, ;
		Left = 0, ;
		Name = "OO", ;
		Top = 48, ;
		Visible = .T., ;
		Width = 36
		*< END OBJECT: BaseClass="olecontrol" OLEObject="c:\windows\syswow64\ieframe.dll" Value="0M8R4KGxGuEAAAAAAAAAAAAAAAAAAAAAPgADAP7/CQAGAAAAAAAAAAAAAAABAAAAAQAAAAAAAAAAEAAAAgAAAAEAAAD+////AAAAAAAAAAD////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////9/////v////7////+/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////1IAbwBvAHQAIABFAG4AdAByAHkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWAAUA//////////8BAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALDpBIxZR9MBAwAAAEABAAAAAAAAAwBPAGwAZQBPAGIAagBlAGMAdABEAGEAdABhAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB4AAgEDAAAAAgAAAP////8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAArAAAAAAAAAADAEEAYwBjAGUAcwBzAE8AYgBqAFMAaQB0AGUARABhAHQAYQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJgACAP///////////////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAA4AAAAAAAAAAMAQwBoAGEAbgBnAGUAZABQAHIAbwBwAHMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcAAIA////////////////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAABgAAAAAAAAAAwAAAP7////+////BAAAAP7///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////9h+VaICjTQEalrAMBP1wWiTAAAALkDAAB7AgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAATAAAAAAAAAAAAAAAOAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAIAHAAAAU2lsZW50AAUAAABMAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAA4NBXAHM1zxGuaQgAKy4SYgoAAAAAAAAATAAAAAEUAgAAAAAAwAAAAAAAAEaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==" />

	ADD OBJECT 'Text3' AS textbox WITH ;
		Alignment = 3, ;
		Enabled = .T., ;
		Height = 23, ;
		Left = 264, ;
		Name = "Text3", ;
		TabIndex = 17, ;
		Top = 84, ;
		Value = '', ;
		Width = 150
		*< END OBJECT: BaseClass="textbox" />
	
	PROCEDURE Activate
		thisform.command1.Click()
	ENDPROC

	PROCEDURE Destroy
		ON ERROR RETURN
	ENDPROC

	PROCEDURE getqichacha
		lcmsg = '启动搜索引擎中...'
		WAIT WINDOW lcmsg NOWAIT
		*WAIT WINDOW AT SROWS() / 2,   (SCOLS() - LEN(lcmsg)) / 2   NOCLEAR NOWAIT lcmsg
		CON=ODBC(1)
		MEXIT=1
		CPUSER=P_UserName+'/'+ALLTRIM(SYS(0))
		
		DO whil 1=1
			RUN /N u1701a.EXE
			
			THISFORM.TEXT3.Value=DATETIME()
			IF SQLEXEC(CON,"SELECT TOP 1 NAME,website,namesource,creatdate  FROM fromweb WHERE BILLNAME=?P_USERNAME AND result IS NULL ORDER BY 4","wods")<0  && result IS NULL  AND  creatdate IS not NULL 
				WAIT WINDOWS '1'
			ENDIF	
			SELECT wods
			IF RECCOUNT()=1
				lnSecs = SECONDS()
		
				c=ALLTRIM(name)
				cweb=ALLTRIM(website)
				CGS=ALLTRIM(namesource)
			ELSE
				WAIT windows '没有记录，请反馈给信息部鲁红斌' 
							mrev='鲁红斌;'+P_USERNAME+';'
					TXTKEY=mrev&&STRCONV(aLLTRIM(mrev),9)
		*			mtitle='没有需要爬取的数据，请联系鲁红斌设置'
							objApi = CreateObject('RTXClient.RTXAPI')
							objApp = objApi.GetObject("AppRoot")
							objIm = objApp.GetAppObject("RTXPlugin.IM")
							objIm.SendIM(TXTKEY)
				LOOP
			ENDIF
			IF SQLEXEC(CON,"SELECT creatdate FROM headinfodetail WHERE NAME=?C AND [source]='qichacha'")<0
				*WAIT WINDOWS '2'
			ENDIF	
			IF RECCOUNT()=1
				IF SQLEXEC(CON,"update fromweb set webdate=getdate(),machine=?CPUSER,result= '曾经爬取' WHERE NAME=?C")<0
					*WAIT WINDOWS '3'
				ENDIF	
				*WAIT WINDOWS '存在' NOWAIT
				LOOP
		*!*		ELSE
		*!*			WAIT WINDOWS 'WU2'
		*!*			LOOP	
			ENDIF	
		*	IF ISNULL(cweb) OR 'firm_'$cweb=.F. &&AND ALLTRIM(cweb)<>'http://www.qichacha.com/' &&OR 1=1
				url='http://www.qichacha.com/search?key='+urlEncode(STRCONV(c,9))
				lcRemoteUrl=url
				THISFORM.OO.Navigate(lcRemoteUrl) 
				XXXX=SECONDS()
				Do While THISFORM.OO.readyState <> 4 
				Enddo 
		
				P_HRDEPT=THISFORM.OO.Document.body.innerHTML
				IF 'HTTP 500'$P_HRDEPT OR '手机动态密码登录'$P_HRDEPT   OR 'data-toggle="tab">最新注册公司</a>'$P_HRDEPT OR '很抱歉'$P_HRDEPT &&OR '请在这里直接填写您想询问的内容'$P_HRDEPT
					lcmsg = C+'查询时出现点问题，程序跳转重新查询1'
					WAIT WINDOW AT SROWS() / 2,   (SCOLS() - LEN(lcmsg)) / 2   NOCLEAR TIMEOUT 10 lcmsg
					IF  'data-toggle="tab">最新注册公司</a>'$P_HRDEPT 
					ELSE
								XGG=NULL
					IF SQLEXEC(CON,"update fromweb set result= ?XGG WHERE NAME=?C")<0
						*WAIT WINDOWS '31'
					ENDIF
					ENDIF
					LOOP
				ENDIF
				IF STREXTRACT(P_HRDEPT,'<em><em>','</em>')==C
					IF SQLEXEC(CON,"update fromweb set webdate=getdate(),machine=?CPUSER,result= '曾经爬取' WHERE NAME=?C")<0
						*WAIT WINDOWS '4'
					ENDIF	
		
					Y=AT('<em><em>'+C+'</em></em>',P_HRDEPT)-120
					x=STREXTRACT(SUBSTR(P_HRDEPT,Y,250),'href="','"')
					xyz=STREXTRACT(x,'_','.')
				ELSE
					IF LEN(STREXTRACT(P_HRDEPT,'<em>','</em>'))=0
						IF SQLEXEC(CON,"update fromweb set webdate=getdate(),machine=?CPUSER,result= '无结果' WHERE NAME=?C")<0
							*WAIT WINDOWS '5'
						ENDIF	
						LOOP
					else	
						IF SQLEXEC(CON,"update fromweb set webdate=getdate(),machine=?CPUSER,result= '爬取相似' WHERE NAME=?C")<0
							*WAIT WINDOWS '6'
						ENDIF	
						Y=AT('<em>',P_HRDEPT)-120
						x=STREXTRACT(SUBSTR(P_HRDEPT,Y,250),'href="','"')
						xyz=STREXTRACT(x,'_','.')
						CGS='规上相似'
						IF X==''
							SQLEXEC(CON,"update fromweb set webdate=getdate(),machine=?CPUSER,result= '无结果' WHERE NAME=?C")
							LOOP
						ENDIF
					ENDIF 	
				ENDIF	
		*!*		ELSE 
		*!*			x=cweb	
		*!*			x=STREXTRACT(x,'http://www.qichacha.com/','')
		*!*			xyz=STREXTRACT(x,'_','.')
		
		*!*		ENDIF 
			url='http://www.qichacha.com/'+x
			lcRemoteUrl=url
			THISFORM.OO.Navigate(lcRemoteUrl) 
			XXXX=SECONDS()
			Do While THISFORM.OO.readyState <> 4 
			Enddo 
			P_HRDEPT=THISFORM.OO.Document.body.innerHTML
			IF 'HTTP 500'$P_HRDEPT OR '手机动态密码登录'$P_HRDEPT  OR 'data-toggle="tab">最新注册公司</a>'$P_HRDEPT  OR '很抱歉'$P_HRDEPT &&OR '请在这里直接填写您想询问的内容'$P_HRDEPT
				lcmsg = ALLTRIM(C)+':取明细时,企查查服务器内部出现错误，程序跳转重新查询2'+ALLTRIM(X)
				WAIT WINDOW AT SROWS() / 2,   (SCOLS() - LEN(lcmsg)) / 2   NOCLEAR NOWAIT lcmsg
					IF  'data-toggle="tab">最新注册公司</a>'$P_HRDEPT 
					ELSE
								XGG=NULL
					IF SQLEXEC(CON,"update fromweb set result= ?XGG WHERE NAME=?C")<0
						*WAIT WINDOWS '31'
					ENDIF
					ENDIF
					LOOP
			ENDIF
		
			lcText  = THISFORM.OO.Document.body.innerText 
			IF SQLEXEC(CON,"update fromweb set webdate=getdate(),machine=?CPUSER,result= '基本信息'  WHERE NAME=?C")<0
				*WAIT WINDOWS '7'
			ENDIF	
			
			XX=(ALLT(STREXTRACT(STREXTRACT(P_HRDEPT,'对外投资','</a>'),'class="badge">','</span')))
			XX=VAL(STRTRAN(XX,CHR(10),''))
			IF SQLEXEC(CON,"update fromweb set website=?lcRemoteUrl,body=?P_HRDEPT,bodytxt=?lcText,outnum=?XX WHERE NAME=?C")<0
				*WAIT WINDOWS '8'
			ENDIF	
			IF XX>=1
				DWID=1
				DO WHILE 1=1
					url='http://www.qichacha.com/cinvestment_'+xyz
					lcRemoteUrl=url
					THISFORM.OO.Navigate(lcRemoteUrl) 
					XXXX=SECONDS()
					Do While THISFORM.OO.readyState <> 4 
					Enddo 
					P_HRDEPTg=THISFORM.OO.Document.body.innerHTML
					lcTextg= THISFORM.OO.Document.body.innerText 
		
					IF 'HTTP 500'$P_HRDEPT OR '手机动态密码登录'$P_HRDEPT   OR 'data-toggle="tab">最新注册公司</a>'$P_HRDEPT OR '很抱歉'$P_HRDEPT &&
						lcmsg = '服务器内部出现错误，程序跳转重新查询3'
						WAIT WINDOW AT SROWS() / 2,   (SCOLS() - LEN(lcmsg)) / 2   NOCLEAR TIMEOUT 10 lcmsg
					IF  'data-toggle="tab">最新注册公司</a>'$P_HRDEPT 
					ELSE
								XGG=NULL
					IF SQLEXEC(CON,"update fromweb set result= ?XGG WHERE NAME=?C")<0
						*WAIT WINDOWS '31'
					ENDIF
					ENDIF
					LOOP
					ELSE
						IF SQLEXEC(CON,"update fromweb set outinvistbody=?P_HRDEPTg,outsite=?lcRemoteUrl WHERE NAME=?C")<0
							*WAIT WINDOWS '9'
						ENDIF	
						EXIT	
					ENDIF
				ENDDO
			ELSE
				DWID=0	
			ENDIF	
		
		*!*		IF 'getCaptcha'$P_HRDEPT
		*!*			MESSAGEBOX("请登陆企查查2")
		*!*			RETURN
		*!*		ENDIF
			qude=STREXTRACT(P_HRDEPT,'company-top-name">','</div>')
			IF STREXTRACT(P_HRDEPT,'company-top-name">','</div>')==C
				IF SQLEXEC(CON,"update fromweb set result= '基本信息OK',getname=?c WHERE NAME=?C")<0
					*WAIT WINDOWS '10'
				ENDIF	
		
			ELSE 
				IF SQLEXEC(CON,"update fromweb set result= '爬取相似',getname=?qude WHERE NAME=?C")<0
					*WAIT WINDOWS '11'
				ENDIF	
			ENDIF 
				x1=ALLTRIM(STREXTRACT(lcText ,'统一社会信用代码：','纳税人识别号：'))
				X2=ALLTRIM(STREXTRACT(lcText ,'登记机关：',chr(13)))
				X3=ALLTRIM(STREXTRACT(lcText ,'法定代表人：','对外投资与任职'))
				IF LEN(x3)>60
					X3=ALLTRIM(STREXTRACT(lcText ,'法定代表人：','注册资本'))
				ENDIF 		
				X4=ALLTRIM(STREXTRACT(lcText ,'注册资本：',chr(13)))
				X5=ALLTRIM(STREXTRACT(lcText ,'注册号：','组织机构代码'))
				X6=ALLTRIM(STREXTRACT(lcText ,'组织机构代码：',chr(13)))
				X7=ALLTRIM(STREXTRACT(lcText ,'经营状态：','成立日期'))
				X8=ALLTRIM(STREXTRACT(lcText ,'公司类型：','人员规模'))
				X9=ALLTRIM(STREXTRACT(lcText ,'成立日期：',chr(13)))
				X10=ALLTRIM(STREXTRACT(lcText ,'营业期限：','登记机关'))
				X11=ALLTRIM(STREXTRACT(lcText ,'核准日期：','公司规模'))
				X12=ALLTRIM(STREXTRACT(lcText ,'人员规模：',chr(13)))
				X13=ALLTRIM(STREXTRACT(lcText ,'所属行业',chr(13)))
				X14=ALLTRIM(STREXTRACT(lcText ,'英文名：',chr(13)))
				X15=ALLTRIM(STREXTRACT(lcText ,'曾用名：',chr(13)))
				X17=ALLTRIM(STREXTRACT(lcText ,'地址：','查看地图'))
				mtel=ALLTRIM(STREXTRACT(lcText ,'电话','邮箱'))
				mtel=STRTRAN(mtel,'：','')
				X18=ALLTRIM(STREXTRACT(lcText ,'经营范围：',chr(13)))
			    X19= SUBSTR(x9,1,4)+SUBSTR(x9,6,2)+SUBSTR(x9,9,2)
			    X20= SUBSTR(x11,1,4)+SUBSTR(x11,6,2)+SUBSTR(x11,9,2)
			    X22=ALLTRIM(STREXTRACT(lcText ,'所属地区','所属行业'))
			    SQLEXEC(CON,"INSERT INTO headinfodetail (name) values (?qude)")
			    IF SQLEXEC(CON,"UPDATE headinfodetail SET businessTimeLimitTo =?X10,regLocation =?X17,businessScope =?X18,creditCode =?X1,regInstitute =?X2,regCapital =?x4,regdate=?X19  WHERE name=?qude")<0
		*!*		    	WAIT WINDOWS X5+X6+X7
				    	*WAIT WINDOWS '12'
			    ENDIF	
			    IF SQLEXEC(CON,"UPDATE headinfodetail SET regStatus =?X7,approvedTime =?X20,creatdate=GETDATE(),nameid=?x,SOURCE='qichacha',[levelid]=?CGS,prov=?X22,"+;
				" legalPersonName =?X3,regNumber =?X5,orgNumber =?X6  WHERE name=?qude")<0
				    	*WAIT WINDOWS X3
				    	*WAIT WINDOWS '121'
			    ENDIF
			    IF SQLEXEC(CON,"UPDATE headinfodetail SET  beforename =?x15,enname =?x14,"+;
			    " companyOrgType =?X8 ,industry =?X13 ,phoneNumber =?mtel WHERE name=?qude")<0
		*!*			    	WAIT WINDOWS '133'+X14+X8
		*!*			    	WAIT WINDOWS '132' +X13+x15
		*!*			    	WAIT WINDOWS '131'+mtel
		*!*			    	WAIT WINDOWS '13'
			    ENDIF	
			    
			    gdxx=ALLTRIM(STREXTRACT(P_HRDEPT,'股东类型','主要人员'))
				IF LEN(gdxx)>0
					IF SQLEXEC(CON,"DELETE FROM [investInfo] WHERE [company]=?qude")<0
						*WAIT WINDOWS '14'
					ENDIF	
					i=OCCURS('class="text-lg c_a',gdxx)-1
					FOR I1=0 TO I
						X1=ALLTRIM(STREXTRACT(STREXTRACT(gdxx,'class="m-t-xs">','</a>',I1+1),'>',''))
						x2=STREXTRACT(GDXX,'class="text-center">','</td>',I1*4+1)
						x2=STRTRAN(X2,CHR(13),'')
						x2=STRTRAN(X2,CHR(10),'')
						x2=VAL(STRTRAN(x2,'%',''))
						x3=STREXTRACT(GDXX,'class="text-center">','</td>',I1*4+2)
						IF 'br'$X3
							x3=STREXTRACT(X3,'','<br')
						ENDIF 	
						x3=STRTRAN(X3,CHR(13),'')
						x3=ALLTRIM(STRTRAN(X3,CHR(10),''))
		
						x5=ALLTRIM(STREXTRACT(GDXX,'class="text-center">','</td>',I1*4+3))
						IF 'br'$x5
							x5=STREXTRACT(X5,'','<br')
						ENDIF 
						x5=STRTRAN(X5,CHR(13),'')
						x5=ALLTRIM(STRTRAN(X5,CHR(10),''))
						x4=ALLTRIM(STREXTRACT(GDXX,'class="text-center">','</td>',I1*4+4))
						IF 'br'$x4
							x4=STREXTRACT(X4,'','<br')
						ENDIF 
		
						X6=STREXTRACT(GDXX,'class="m-t-xs"> <a href="','>',I1+1)
		
						IF SQLEXEC(CON,"INSERT INTO investInfo ([company],[investorType] ,[investor],[radio],[cash] ,[dateid],[href]) "+;
						" values (?qude,?X4,?X1,?X2,?X3,?X5,?X6)")<0
		*!*					*WAIT WINDOWS 'x4:'+X4
							*WAIT WINDOWS '15'+x4+x1+x3+x5+ALLTRIM(str(x2))
						
						ENDIF
						IF LEN(x1)>10
							IF SQLEXEC(CON,"SELECT  website FROM fromweb WHERE NAME =?X1")<0
								*WAIT WINDOWS '16'
							ENDIF	
							IF RECCOUNT()<1 
								IF SQLEXEC(CON,"SELECT [nameid]  FROM [headinfodetail] WHERE NAME =?X1")<0
									*WAIT WINDOWS '17'
								ENDIF	
								IF RECCOUNT()<1 OR ISNULL(nameid)
									IF SQLEXEC(con,"INSERT INTO fromweb (name,BILLNAME,namesource,website) values (?X1,?p_username,'股东信息',?x6)")<0
										*WAIT WINDOWS '18'
									ENDIF	
								ENDIF 
							ENDIF 	
						ENDIF 
					ENDFOR
				ENDIF 
				gdxx=ALLTRIM(STREXTRACT(P_HRDEPT,'主要人员','</section>'))
				IF LEN(gdxx)<10
					gdxx=ALLTRIM(STREXTRACT(P_HRDEPT,'主要人员','以上工商数据来源'))
				ENDIF 
				IF LEN(gdxx)>0
					IF SQLEXEC(CON,"DELETE FROM [staffInfo] WHERE [company]=?qude")<0
						*WAIT WINDOWS '19'
					ENDIF	
					i=OCCURS('title="',gdxx)
					FOR I1=1 TO I
						X1=ALLTRIM(STREXTRACT(gdxx,'class="text-center">','</td>',I1))
						X1=STRTRAN(X1,CHR(13),'')
						X1=ALLTRIM(STRTRAN(X1,CHR(10),''))
						X2=allt(STREXTRACT(gdxx,'title="','"',I1))
						X3=allt(STREXTRACT(gdxx,'href="','">',i1*2))
						IF SQLEXEC(CON,"INSERT INTO staffInfo ([company],position,name,[cryptor]) values (?qude,?X1,?X2,?x3)")<0
								*WAIT WINDOWS '20'+x1+x2+x3
						ENDIF
					ENDFOR
				ENDIF 	
				gdxx=ALLTRIM(STREXTRACT(P_HRDEPT,'分支机构</span>','变更记录</span>'))
				
				IF LEN(gdxx)<10
					gdxx=ALLTRIM(STREXTRACT(P_HRDEPT,'分支机构</span>','以上工商数据来源'))
				ENDIF 
				IF LEN(gdxx)>0
					i=val(STREXTRACT(gdxx,'class="badge">','</span>'))
					SQLEXEC(CON,"DELETE FROM [branchInfo] WHERE [company]=?qude")
					FOR I1=1 TO I
						X1=STREXTRACT(gdxx,'target="_blank"><span>','</span>',I1)
						X2=allt(STREXTRACT(gdxx,'href="','"',i1))
						IF !EMPTY(X1)
						IF SQLEXEC(CON,"INSERT INTO branchInfo ([company],incName,href) values (?qude,?X1,?x2)")<0
							*WAIT WINDOWS '21'
						endif	
						ENDIF 
					ENDFOR
				ENDIF 
				gdxx=STREXTRACT(P_HRDEPT,'text-dark"> 变更记录</span>','公司简介')
				IF LEN(gdxx)<10
					gdxx=ALLTRIM(STREXTRACT(P_HRDEPT,'变更记录','以上工商数据来源'))
				ENDIF 		
				IF LEN(gdxx)>0
					Y1='变更记录'
					gdxx=STREXTRACT(P_HRDEPT,'text-dark"> 变更记录</span>','公司简介')
					SQLEXEC(CON,"DELETE FROM [alterInfo] WHERE [company]=?C")
					i=OCCURS('<td width="15%">',gdxx)
					J=OCCURS('id="ma_twoword" style="text-align: center;" colspan="4">',gdxx)
					J1=1
					FOR I1=1 TO I
						IF STREXTRACT(gdxx,'class="ma_twoword">','</td>',I1)=='1'
							Y1=STREXTRACT(gdxx,'id="ma_twoword" style="text-align: center;" colspan="4">','</th>',J1)
							J1=J1+1
						ELSE	
						ENDIF	
						Y2=STREXTRACT(gdxx,'<td width="15%">','</td>',I1)
						Z2=AT('<td width="15%">',gdxx,I1)
						Y3=STREXTRACT(SUBSTR(gdxx,Z2,4000),'<td width="40%"> <div>','</div>')
						Y4=STREXTRACT(SUBSTR(gdxx,Z2,4000),'<td width="40%"> <div>','</div>',2)
						Y3=STRTRAN(Y3,'</em>','')
						Y4=STRTRAN(Y4,'</em>','')
						Y3=STRTRAN(Y3,'<em>','')
						Y4=STRTRAN(Y4,'<em>','')
						Y3=STRTRAN(Y3,'<br>','')
						Y4=STRTRAN(Y4,'<br>','')
						IF SQLEXEC(CON,"INSERT INTO alterInfo ([company],[item],[dateid],[before],[after]) values (?qude,?Y1,?Y2,?Y3,?Y4)")<0
							*WAIT WINDOWS '22'
						ENDIF	
					ENDFOR
				ENDIF
				IF DWID=1
					gdxx=STREXTRACT(P_HRDEPTg,'被投资法定代表人','发票抬头')
					IF LEN(gdxx)=0
						gdxx=STREXTRACT(P_HRDEPTg,'被投资法定代表人','onclick="getCaptcha()')
					ENDIF 	
					SQLEXEC(CON,"DELETE FROM [outinvestinfo] WHERE [company]=?qude")
					i=OCCURS('class="text-lg c_a"',gdxx)
					FOR I1=1 TO I
						X1=STREXTRACT(STREXTRACT(gdxx,'class="m-t-xs">','</a>',I1),'>','')
						SQLEXEC(CON,"INSERT INTO [outinvestinfo] ([company],[outcompany]) values (?qude,?X1)")
						X2=STREXTRACT(STREXTRACT(gdxx,X1,'对外投资与任职'),'target="_blank">','</a>') &&法人
						x4=ALLTRIM(STREXTRACT(STREXTRACT(gdxx,'对外投资与任职','<span',I1),CHR(10),CHR(10))) &&注册资金
						x4=STRTRAN(x4,' ','')
						x7=ALLTRIM(STREXTRACT(STREXTRACT(gdxx,'对外投资与任职','<span',I1),'class="text-center">'+CHR(10),CHR(10),2)) &&投资比例
						x3=left(STREXTRACT(STREXTRACT(gdxx,'对外投资与任职','<span',I1),'class="text-center">'+CHR(10),'</td>',3),10) &&成立日期
						x5=STREXTRACT(STREXTRACT(gdxx,'<span','</span>',I1),'">','') &&状态
						x6='firm_'+STREXTRACT(gdxx, 'href="/firm_','"',i1)  &&链接
						IF SQLEXEC(CON,"update [outinvestinfo] set [href]=?x6,[dateid]=?x3 , [boss]=?x2,[cash]=?x4,[radio]=?x7,[statusid]=?x5 where [company]=?qude and [outcompany]=?X1")<0
							*WAIT WINDOWS '23'+x2+x1+x5+X7+X4+X3
							*WAIT WINDOWS X6
						ENDIF	
						IF LEN(x1)>10
							IF SQLEXEC(CON,"SELECT  website FROM fromweb WHERE NAME =?X1")<0
								*WAIT WINDOWS '24'
							ENDIF	
							IF RECCOUNT()<1 
								IF SQLEXEC(CON,"SELECT [nameid]  FROM [headinfodetail] WHERE NAME =?X1")<0
									*WAIT WINDOWS '25'
								ENDIF	
								IF RECCOUNT()<1 OR ISNULL(nameid)
									IF SQLEXEC(con,"INSERT INTO fromweb (name,BILLNAME,namesource,website) values (?X1,?p_username,'对外投资',?x6)")<0
										*WAIT WINDOWS '27'
									ENDIF	
								ENDIF 
							ENDIF 	
						ENDIF 
					ENDFOR
				ENDIF
		
			WAIT WINDOWS   "当前系统操作耗时： " +  allt(TRANS(SECONDS()-lnSecs,"999.99")) + " 秒"  NOWAIT
			DO ReduceMemory
		ENDDO 
		
		SQLDISCONNECT(CON)
		
		
		
		
	ENDPROC

	PROCEDURE Init
		ON ERROR 
		
		DECLARE INTEGER FindWindow IN USER32.DLL AS Find_Window STRING,STRING
		LOCAL cTitle
		cTitle="u1701a.exe"
		IF Find_Window(0,cTitle)=0
			RUN /N u1701a.EXE
			*MESSAGEBOX("必需启动无界代理服务器,不得关闭,否则无法整理企业数据")
			WAIT WINDOWS '必需启动无界代理服务器,不得关闭,否则无法整理企业数据!' NOWAIT
		ENDIF
		*thisform.command1.Click()
		
		
		
		
	ENDPROC

	PROCEDURE Command1.Click
		THISFORM.GETQichacha()
	ENDPROC

ENDDEFINE
