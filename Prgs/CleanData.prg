*!*	With   Thisform  
*!*	  If   Empty(.ETSQLPATH.Value)  
*!*	  Messagebox('����·������Ϊ��!',16,'����')  
*!*	  .ETSQLPATH.SetFocus  
*!*	  Return  
*!*	  Endif  
*!*	  NSQLPATH   =   Left(Alltrim(.ETSQLPATH.Value),Rat('\',Alltrim(.ETSQLPATH.Value)))  
*!*	  If   Not   Directory("&nSQLPath")   Then  
*!*	  If   Messagebox('��Ŀ¼�����ڣ���Ҫ������?',36,'Ŀ¼������!')   =   7  
*!*	  Return  
*!*	  Endif  
*!*	  Md   &nSQLPath  
*!*	  If   Not   Directory("&nSQLPath")   Then  
*!*	  Messagebox('����Ŀ¼ʧ��,��¼���Ŀ¼�ǷǷ�Ŀ¼!������¼����Ŀ¼',16,'�Ƿ�Ŀ¼')  
*!*	  .ETLOCAPATH.SetFocus  
*!*	  .ETLOCAPATH.SelStart   =   0  
*!*	  .ETLOCAPATH.SelLength   =   Len(.ETLOCAPATH.Value)  
*!*	  .ETSQLPATH.SetFocus  
*!*	  Return  
*!*	  Endif  
*!*	  Endif  
*!*	   
*!*	  Wait   Window   Nowait   '���ڽ����ױ��ݵ�'   +   Alltrim(.ETSQLPATH.Value)   +   '...'  
*!*	  CSTR   =   'Backup   Log   ['   +'YDGL'+   ']   With   No_log'  
*!*	  HANDLE1   =   SQLEXEC(nhandle,CSTR)  
*!*	  If   HANDLE1   <   1  
*!*	 =   Messagebox('�������ӹ��ϻ�����æ,���Ժ�����!',64,'��ʾ')  
*!*	  .PRESS.Value   =   0  
*!*	  Return  
*!*	  Endif  
*!*	  .PRESS.Value   =   50  
*!*	  BACKUPSTR   =     ;  
*!*	  'BackUp   Database   ['   +   'YDGL'   +   "]   To   disk=N'"   +     ;  
*!*	  ALLTRIM(.ETSQLPATH.Value)   +   "'   With   Init,name=N'databak',skip,noformat"  
*!*	  HANDLE1   =   SQLEXEC(nhandle,BACKUPSTR)  
*!*	  If   HANDLE1   <   1  
*!*	  Messagebox('���ݳ���!����ϵͳ����Ա��ϵ.',16,'����')  
*!*	  .PRESS.Visible   =   .F.  
*!*	  .PRESS.Value   =   0  
*!*	  Return  
*!*	  Endif  
*!*	  .PRESS.Value   =   90  
*!*	  .PRESS.Value   =   100  
*!*	  Messagebox('���ݳɹ�!',64,'�ɹ�')  
*!*	  Endwith   

