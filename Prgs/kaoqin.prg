*!*	Declare integer sio_kqDOWNLOAD in SeriIo.dll integer @port, integer @num, integer @year1,integer @month1,integer @day1,integer @year2,integer @month2,integer @day2
*!*	mmac=04293
*!*	mport=2003
*!*	myear1=2011
*!*	mmonth1=5
*!*	mday1=1
*!*	myear2=2011
*!*	mmonth2=5
*!*	mday2=20
*!*	?sio_kqDOWNLOAD(1,4293,myear1,mmonth1,mday1,myear2,mmonth2,mday2)
*!*	WAIT windows 'read end' nowait


DECLARE INTEGER WritePrivateProfileString IN Win32API AS WritePrivStr ;
  String cSection, String cKey, String cValue, String cINIFile

DECLARE INTEGER GetPrivateProfileString IN Win32API AS GetPrivStr ;
  String cSection, String cKey, String cDefault, String @cBuffer, ;
  Integer nBufferSize, String cINIFile

* ��������
Private fileName,summaryName,fieldName,fieldValue,Buffer

fileName = "test.ini"   && INI�ļ���
summaryName = "Summary"  && С����
fieldName = "Field"   && �ֶ�����
fieldValue = "test"   && �ֶε�ֵ

* д��INI�ļ�
=WritePrivStr(summaryName, fieldName, fieldValue, fileName)

lcBuffer = space(100) + chr(0)

* ��ȡINI�ļ�
=GetPrivStr(summaryName, fieldName, "", @Buffer, LEN(Buffer), fileName)
?lcBuffer