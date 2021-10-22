CON=ODBC(5)
SQLEXEC(CON,"SELECT * FROM quotation","tmp")
DO WHILE .not. EOF()
	
ENDDO 