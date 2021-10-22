con=odbc(5)
SQLEXEC(con,"select distinct priceinterid from pidetail inner join quotationprice on priceinterid=quotationprice.interid where priceinterid>2010000000 order by 1 ","tmp")
SELECT tmp
DO whil .not. EOF()
	x=priceinterid
	SQLEXEC(con,"select top 1 pidetail.interid,maininterid,pi.billname,pi.creatdate from pidetail inner join pi on pi.interid=pidetail.maininterid where priceinterid=?x order by 1")
	y=interid
	x3='т╢вт:'+ALLTRIM(billname)+ALLTRIM(STR(maininterid ))
	x4=billname
	x5=creatdate
	SQLEXEC(con,"select * from [exportcode] where [pidetailinterid]=?y","tmp1")
	SELECT tmp1
	IF RECCOUNT()>=1
		SQLEXEC(con,"update quotation set bomchkid=1,bomman=?x4,bomdate=?x5 where interid=?x")
	ENDIF 
	SELECT tmp1
	GO top
	DO WHILE .not. EOF()
		x1=code
		x2=pcs
		IF SQLEXEC(con,"insert into salebom ([interid],[code],[quan],[rate],[note],[replacements]) values (?x,?x1,?x2,1,?x3,2)")<0
		SELECT tmp1
		brow
		ENDIF 
		SELECT tmp1
		SKIP
	ENDDO 		
	SELECT tmp
	skip
ENDDO 
SQLDISCONNECT(con)
