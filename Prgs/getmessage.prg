PUBLIC  mSender,mReceive,mTime,mContent,oGet,MsgOgj,UserAuth,MsgObj 
 
RootO = CreateObject('RTXSAPIRootObj.RTXSAPIRootObj') 
*!*	UserAuth.StopApp()
*!*	UserAuth.UnRegisterApp()
UserAuth=RootO.CreateAPIObj
UserAuth.ServerIP='127.0.0.1'
UserAuth.ServerPort='8006'
UserAuth.AppGUID='{9FEF6E5D-136C-4b2c-83A5-25B05FDBAC02}' &&����Ӧ��GUID
UserAuth.AppName='AppTest1'
UserAuth.AppAction=1
UserAuth.FilterAppName='all'
UserAuth.FilterRequestType="Tencent.RTX.IM" &&����Ӧ��GUID
UserAuth.FilterResponseType="none"
UserAuth.FilterSender="anyone"
UserAuth.FilterReceiver="anyone"
UserAuth.FilterReceiverState= "anystate"
UserAuth.FilterKey= "" &&����Ӧ��GUID
IF UserAuth.RegisterApp()='S_OK'
	WAIT WINDOWS 'ע��ɹ�' NOWAIT 
ELSE
	WAIT WINDOWS 'ע��ʧ��' NOWAIT  
ENDIF	
IF UserAuth.StartApp("", 4)='S_OK'
	WAIT WINDOWS '�����ɹ�' NOWAIT 
ELSE
	WAIT WINDOWS '����ʧ��'	NOWAIT 
ENDIF	
MsgObj = UserAuth.CreateMessage  
*!*	MsgOgj=RootO.CreateAPIStateObj


oGet= NEWOBJECT("myclass")
*EVENTHANDLER("UserAuth.OnRecvMessage",oGet) &&'���յ���Ϣʱ�������¼�

BINDEVENT("UserAuth","OnRecvMessage",oGet,"rtxwrite1") 
