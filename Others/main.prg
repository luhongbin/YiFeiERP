*       *********************************************************
*       *                                                         
*       * 04/04/02              MAIN.PRG                09:30:18  
*       *                                                         
*       *********************************************************
*       *                                                         
*       * ��������                                                
*       *                                                         
*       * ��Ȩ���� (C) 2002 ��˾����                             
*       * ��ַ                                                    
*       * ����,     �ʱ�                                          
*       * ����                                              
*       *                                                         
*       * ˵��:                                            
*       * �˳����� GENMENU �Զ����ɡ�    
*       *                                                         
*       *********************************************************


*       *********************************************************
*       *                                                         
*       *                         �˵�����                        
*       *                                                         
*       *********************************************************
*

SET SYSMENU TO
SET SYSMENU AUTOMATIC

DEFINE PAD _0n00kdesu OF _MSYSMENU PROMPT "ϵͳ��Ϣ(\<S)" COLOR SCHEME 3 ;
	KEY ALT+S, "ALT+S"
DEFINE PAD _0n00kdesv OF _MSYSMENU PROMPT "�г���������(\<B)" COLOR SCHEME 3 ;
	KEY ALT+B, "ALT+B"
DEFINE PAD _0n00kdesw OF _MSYSMENU PROMPT "�ֿ�ɹ�����(\<R)" COLOR SCHEME 3 ;
	KEY ALT+R, "ALT+R"
DEFINE PAD _0n00kdesx OF _MSYSMENU PROMPT "������Ϣ(\<F)" COLOR SCHEME 3 ;
	KEY ALT+F, "ALT+F"
DEFINE PAD _0n00kdesy OF _MSYSMENU PROMPT "�������(\<P)" COLOR SCHEME 3 ;
	KEY ALT+P, "ALT+P"
DEFINE PAD _0n00kdesz OF _MSYSMENU PROMPT "���ҽ���(\<H)" COLOR SCHEME 3 ;
	KEY ALT+H, "ALT+H"
ON PAD _0n00kdesu OF _MSYSMENU ACTIVATE POPUP ϵͳ��Ϣs
ON PAD _0n00kdesv OF _MSYSMENU ACTIVATE POPUP �г�������
ON PAD _0n00kdesw OF _MSYSMENU ACTIVATE POPUP �ֿ����r
ON PAD _0n00kdesx OF _MSYSMENU ACTIVATE POPUP ������Ϣf
ON PAD _0n00kdesy OF _MSYSMENU ACTIVATE POPUP �������p
ON PAD _0n00kdesz OF _MSYSMENU ACTIVATE POPUP ���ҽ���h

DEFINE POPUP ϵͳ��Ϣs MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF ϵͳ��Ϣs PROMPT "��˾��Ϣ����"
DEFINE BAR 2 OF ϵͳ��Ϣs PROMPT "ϵͳ�ռ�"
DEFINE BAR 3 OF ϵͳ��Ϣs PROMPT "\-"
DEFINE BAR 4 OF ϵͳ��Ϣs PROMPT "�������"
DEFINE BAR 5 OF ϵͳ��Ϣs PROMPT "�޸�����"
DEFINE BAR 6 OF ϵͳ��Ϣs PROMPT "Ȩ�޹���"
DEFINE BAR 7 OF ϵͳ��Ϣs PROMPT "\-"
DEFINE BAR 8 OF ϵͳ��Ϣs PROMPT "���ݱ���"
DEFINE BAR 9 OF ϵͳ��Ϣs PROMPT "��������"
DEFINE BAR 10 OF ϵͳ��Ϣs PROMPT "������ݿ�"
DEFINE BAR 11 OF ϵͳ��Ϣs PROMPT "\-"
DEFINE BAR 12 OF ϵͳ��Ϣs PROMPT "�˳�ϵͳ(\<X)"
ON SELECTION BAR 1 OF ϵͳ��Ϣs Do &P_Prgs.Systeminfo
ON SELECTION BAR 2 OF ϵͳ��Ϣs Do &P_Prgs.Every
ON SELECTION BAR 4 OF ϵͳ��Ϣs Do &P_Prgs.Managepsd
ON SELECTION BAR 5 OF ϵͳ��Ϣs Do &P_Prgs.Changepsd
ON SELECTION BAR 6 OF ϵͳ��Ϣs Do form &P_Frms.Rights
ON SELECTION BAR 8 OF ϵͳ��Ϣs DO &P_PRGS.BACKUP
ON SELECTION BAR 9 OF ϵͳ��Ϣs Do form &P_Frms.PACKFORM
ON SELECTION BAR 10 OF ϵͳ��Ϣs Do form &P_Frms.ZAPFORM
ON SELECTION BAR 12 OF ϵͳ��Ϣs Do &P_Prgs.Logout.PRG

DEFINE POPUP �г������� MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF �г������� PROMPT "�ͻ������"
DEFINE BAR 2 OF �г������� PROMPT "��Ʒ�����"
DEFINE BAR 3 OF �г������� PROMPT "�ͻ���Ʒ�۸�"
DEFINE BAR 4 OF �г������� PROMPT "\-"
DEFINE BAR 5 OF �г������� PROMPT "��������"
DEFINE BAR 6 OF �г������� PROMPT "������"
DEFINE BAR 7 OF �г������� PROMPT "�������"
DEFINE BAR 8 OF �г������� PROMPT "\-"
DEFINE BAR 9 OF �г������� PROMPT "�ͻ��ʽ��±�"
DEFINE BAR 10 OF �г������� PROMPT "�����̿�����"
DEFINE BAR 11 OF �г������� PROMPT "���̼���"
DEFINE BAR 12 OF �г������� PROMPT "���ϱ�"
DEFINE BAR 13 OF �г������� PROMPT "\-"
DEFINE BAR 14 OF �г������� PROMPT "��Ʒ����"
DEFINE BAR 15 OF �г������� PROMPT "��Ʒ��ⵥ"
DEFINE BAR 16 OF �г������� PROMPT "��Ʒ�ֱ̲�"
DEFINE BAR 17 OF �г������� PROMPT "���ʼ���"
ON SELECTION BAR 1 OF �г������� Do FORM &P_Frms.BinInfo
ON SELECTION BAR 2 OF �г������� Do FORM &P_Frms.CostingInfo
ON SELECTION BAR 3 OF �г������� Do FORM &P_Frms.CC_price
ON SELECTION BAR 5 OF �г������� Do Form &P_Frms.OrderInfo
ON SELECTION BAR 6 OF �г������� DO FORM &P_Frms.shipmentInfo
ON SELECTION BAR 7 OF �г������� DO FORM &P_Frms.Billreclaim
ON SELECTION BAR 9 OF �г������� DO FORM &P_Frms.CustomReport
ON SELECTION BAR 10 OF �г������� Do FORM &P_Frms.CUSTOMSALES
ON SELECTION BAR 11 OF �г������� DO FORM &P_Frms.Ʒ���ձ�
ON SELECTION BAR 12 OF �г������� DO FORM &P_Frms.matmove
ON SELECTION BAR 15 OF �г������� DO FORM &P_Frms.PRODUCTIN
ON SELECTION BAR 16 OF �г������� DO FORM &P_Frms.CheckWarehouse
ON SELECTION BAR 17 OF �г������� DO FORM &P_Frms.SALARY

DEFINE POPUP �ֿ����r MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF �ֿ����r PROMPT "��Ӧ�̹���"
DEFINE BAR 2 OF �ֿ����r PROMPT "���ϴ���ά��"
DEFINE BAR 3 OF �ֿ����r PROMPT "����۸����"
DEFINE BAR 4 OF �ֿ����r PROMPT "\-"
DEFINE BAR 5 OF �ֿ����r PROMPT "�ɹ���"
DEFINE BAR 6 OF �ֿ����r PROMPT "�������"
DEFINE BAR 7 OF �ֿ����r PROMPT "�ɹ�Ƿ��"
DEFINE BAR 8 OF �ֿ����r PROMPT "��˾Ӧ����"
DEFINE BAR 9 OF �ֿ����r PROMPT "\-"
DEFINE BAR 10 OF �ֿ����r PROMPT "������ȱ��"
DEFINE BAR 11 OF �ֿ����r PROMPT "���ϼ��鵥"
DEFINE BAR 12 OF �ֿ����r PROMPT "������ⵥ"
DEFINE BAR 13 OF �ֿ����r PROMPT "�������õ�"
DEFINE BAR 14 OF �ֿ����r PROMPT "�ֿ�����̵�"
DEFINE BAR 15 OF �ֿ����r PROMPT "\-"
DEFINE BAR 16 OF �ֿ����r PROMPT "ԭ�Ͽ�����"
DEFINE BAR 17 OF �ֿ����r PROMPT "���Ͽ���±�"
ON SELECTION BAR 1 OF �ֿ����r Do FORMS &P_Frms.BuysInfo
ON SELECTION BAR 2 OF �ֿ����r Do FORM &P_Frms.BinInfo
ON SELECTION BAR 3 OF �ֿ����r Do FORM &P_Frms.MC_price
ON SELECTION BAR 5 OF �ֿ����r Do FORM &P_Frms.BUYSMAT
ON SELECTION BAR 6 OF �ֿ����r DO FORM &P_Frms.MoneyOut
ON SELECTION BAR 7 OF �ֿ����r DO FORM &P_Frms.judmat
ON SELECTION BAR 8 OF �ֿ����r Do FORM &P_Frms.outmoney.scx
ON SELECTION BAR 10 OF �ֿ����r Do Form &P_Frms.������ȱ��
ON SELECTION BAR 11 OF �ֿ����r Do Form &P_Frms.��������
ON SELECTION BAR 12 OF �ֿ����r DO FORM &P_Frms.MatIn
ON SELECTION BAR 13 OF �ֿ����r DO FORM &P_Frms.MatOut
ON SELECTION BAR 14 OF �ֿ����r DO FORM &P_Frms.�����̵㵥
ON SELECTION BAR 16 OF �ֿ����r Do FORM &P_Frms.���Ͽ���ձ�
ON SELECTION BAR 17 OF �ֿ����r DO FORM &P_Frms.���Ͽ���±�

DEFINE POPUP ������Ϣf MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF ������Ϣf PROMPT "Ա����Ϣ��"
DEFINE BAR 2 OF ������Ϣf PROMPT "�������"
DEFINE BAR 3 OF ������Ϣf PROMPT "��������"
DEFINE BAR 4 OF ������Ϣf PROMPT "\-"
DEFINE BAR 5 OF ������Ϣf PROMPT "�����Ƴɹ滮"
DEFINE BAR 6 OF ������Ϣf PROMPT "��Ʒ������ϸ"
DEFINE BAR 7 OF ������Ϣf PROMPT "�����ϱ�"
ON SELECTION BAR 1 OF ������Ϣf Do FORM &P_Frms.��Ա������Ϣ WITH 'C'
ON SELECTION BAR 2 OF ������Ϣf Do FORM &P_Frms.�������
ON SELECTION BAR 3 OF ������Ϣf Do FORM &P_Frms.BANKINFO
ON SELECTION BAR 5 OF ������Ϣf Do FORM &P_Frms.PRONO
ON SELECTION BAR 6 OF ������Ϣf Do FORM &P_Frms.��Ʒ������ϸ
ON SELECTION BAR 7 OF ������Ϣf Do FORM &P_Frms.�����ϱ�

DEFINE POPUP �������p MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF �������p PROMPT "���������"
DEFINE BAR 2 OF �������p PROMPT "��������ϸ��"
DEFINE BAR 3 OF �������p PROMPT "\-"
DEFINE BAR 4 OF �������p PROMPT "��Ʒ���ձ�"
DEFINE BAR 5 OF �������p PROMPT "��Ʒ���±�"
DEFINE BAR 6 OF �������p PROMPT "\-"
DEFINE BAR 7 OF �������p PROMPT "���۲��ձ�"
DEFINE BAR 8 OF �������p PROMPT "���۲��±�"
DEFINE BAR 9 OF �������p PROMPT "�ͻ��ʽ��±�"
DEFINE BAR 10 OF �������p PROMPT "\-"
DEFINE BAR 11 OF �������p PROMPT "�ͻ���Ϣ����"
DEFINE BAR 12 OF �������p PROMPT "�ͻ�����������Ϣ����"
DEFINE BAR 13 OF �������p PROMPT "��Ʒ��Ϣ����"
DEFINE BAR 14 OF �������p PROMPT "���ϴ�����Ϣ����"
ON SELECTION BAR 1 OF �������p DO &P_PRGS.SHIPMENTAUDITING
ON SELECTION BAR 2 OF �������p DO &P_PRGS.SHIPMENTDETAILACCOUNT
ON SELECTION BAR 11 OF �������p DO &P_PRGS.PRINTFILE WITH 'B'
ON SELECTION BAR 12 OF �������p DO &P_PRGS.PRINTFILE WITH 'C'
ON SELECTION BAR 13 OF �������p DO &P_PRGS.PRINTFILE WITH 'D'
ON SELECTION BAR 14 OF �������p DO &P_PRGS.PRINTFILE WITH 'K'

DEFINE POPUP ���ҽ���h MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF ���ҽ���h PROMPT "�汾��Ϣ(\<V)"
DEFINE BAR 2 OF ���ҽ���h PROMPT "\-"
DEFINE BAR 3 OF ���ҽ���h PROMPT "���ľҵ����(\<A)..."
ON SELECTION BAR 1 OF ���ҽ���h Do FORM &P_Frms.Version.SCX
ON SELECTION BAR 3 OF ���ҽ���h Do Form &P_Frms.About
