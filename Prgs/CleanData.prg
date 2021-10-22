*!*	With   Thisform  
*!*	  If   Empty(.ETSQLPATH.Value)  
*!*	  Messagebox('备份路径不能为空!',16,'错误')  
*!*	  .ETSQLPATH.SetFocus  
*!*	  Return  
*!*	  Endif  
*!*	  NSQLPATH   =   Left(Alltrim(.ETSQLPATH.Value),Rat('\',Alltrim(.ETSQLPATH.Value)))  
*!*	  If   Not   Directory("&nSQLPath")   Then  
*!*	  If   Messagebox('该目录不存在，你要建立吗?',36,'目录不存在!')   =   7  
*!*	  Return  
*!*	  Endif  
*!*	  Md   &nSQLPath  
*!*	  If   Not   Directory("&nSQLPath")   Then  
*!*	  Messagebox('创建目录失败,你录入的目录是非法目录!请重新录入新目录',16,'非法目录')  
*!*	  .ETLOCAPATH.SetFocus  
*!*	  .ETLOCAPATH.SelStart   =   0  
*!*	  .ETLOCAPATH.SelLength   =   Len(.ETLOCAPATH.Value)  
*!*	  .ETSQLPATH.SetFocus  
*!*	  Return  
*!*	  Endif  
*!*	  Endif  
*!*	   
*!*	  Wait   Window   Nowait   '正在将帐套备份到'   +   Alltrim(.ETSQLPATH.Value)   +   '...'  
*!*	  CSTR   =   'Backup   Log   ['   +'YDGL'+   ']   With   No_log'  
*!*	  HANDLE1   =   SQLEXEC(nhandle,CSTR)  
*!*	  If   HANDLE1   <   1  
*!*	 =   Messagebox('网络连接故障或网络忙,请稍后再试!',64,'提示')  
*!*	  .PRESS.Value   =   0  
*!*	  Return  
*!*	  Endif  
*!*	  .PRESS.Value   =   50  
*!*	  BACKUPSTR   =     ;  
*!*	  'BackUp   Database   ['   +   'YDGL'   +   "]   To   disk=N'"   +     ;  
*!*	  ALLTRIM(.ETSQLPATH.Value)   +   "'   With   Init,name=N'databak',skip,noformat"  
*!*	  HANDLE1   =   SQLEXEC(nhandle,BACKUPSTR)  
*!*	  If   HANDLE1   <   1  
*!*	  Messagebox('备份出错!请与系统管理员联系.',16,'错误')  
*!*	  .PRESS.Visible   =   .F.  
*!*	  .PRESS.Value   =   0  
*!*	  Return  
*!*	  Endif  
*!*	  .PRESS.Value   =   90  
*!*	  .PRESS.Value   =   100  
*!*	  Messagebox('备份成功!',64,'成功')  
*!*	  Endwith   

