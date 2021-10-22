PUBLIC  mSender,mReceive,mTime,mContent,oGet,MsgOgj,UserAuth,MsgObj 
 
RootO = CreateObject('RTXSAPIRootObj.RTXSAPIRootObj') 
*!*	UserAuth.StopApp()
*!*	UserAuth.UnRegisterApp()
UserAuth=RootO.CreateAPIObj
UserAuth.ServerIP='127.0.0.1'
UserAuth.ServerPort='8006'
UserAuth.AppGUID='{9FEF6E5D-136C-4b2c-83A5-25B05FDBAC02}' &&设置应用GUID
UserAuth.AppName='AppTest1'
UserAuth.AppAction=1
UserAuth.FilterAppName='all'
UserAuth.FilterRequestType="Tencent.RTX.IM" &&设置应用GUID
UserAuth.FilterResponseType="none"
UserAuth.FilterSender="anyone"
UserAuth.FilterReceiver="anyone"
UserAuth.FilterReceiverState= "anystate"
UserAuth.FilterKey= "" &&设置应用GUID
IF UserAuth.RegisterApp()='S_OK'
	WAIT WINDOWS '注册成功' NOWAIT 
ELSE
	WAIT WINDOWS '注册失败' NOWAIT  
ENDIF	
IF UserAuth.StartApp("", 4)='S_OK'
	WAIT WINDOWS '启动成功' NOWAIT 
ELSE
	WAIT WINDOWS '启动失败'	NOWAIT 
ENDIF	
MsgObj = UserAuth.CreateMessage  
*!*	MsgOgj=RootO.CreateAPIStateObj


oGet= NEWOBJECT("myclass")
*EVENTHANDLER("UserAuth.OnRecvMessage",oGet) &&'接收到消息时触发该事件

BINDEVENT("UserAuth","OnRecvMessage",oGet,"rtxwrite1") 
