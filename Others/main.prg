*       *********************************************************
*       *                                                         
*       * 04/04/02              MAIN.PRG                09:30:18  
*       *                                                         
*       *********************************************************
*       *                                                         
*       * 作者名称                                                
*       *                                                         
*       * 版权所有 (C) 2002 公司名称                             
*       * 地址                                                    
*       * 城市,     邮编                                          
*       * 国家                                              
*       *                                                         
*       * 说明:                                            
*       * 此程序由 GENMENU 自动生成。    
*       *                                                         
*       *********************************************************


*       *********************************************************
*       *                                                         
*       *                         菜单定义                        
*       *                                                         
*       *********************************************************
*

SET SYSMENU TO
SET SYSMENU AUTOMATIC

DEFINE PAD _0n00kdesu OF _MSYSMENU PROMPT "系统信息(\<S)" COLOR SCHEME 3 ;
	KEY ALT+S, "ALT+S"
DEFINE PAD _0n00kdesv OF _MSYSMENU PROMPT "市场生产管理(\<B)" COLOR SCHEME 3 ;
	KEY ALT+B, "ALT+B"
DEFINE PAD _0n00kdesw OF _MSYSMENU PROMPT "仓库采购管理(\<R)" COLOR SCHEME 3 ;
	KEY ALT+R, "ALT+R"
DEFINE PAD _0n00kdesx OF _MSYSMENU PROMPT "基本信息(\<F)" COLOR SCHEME 3 ;
	KEY ALT+F, "ALT+F"
DEFINE PAD _0n00kdesy OF _MSYSMENU PROMPT "报表管理(\<P)" COLOR SCHEME 3 ;
	KEY ALT+P, "ALT+P"
DEFINE PAD _0n00kdesz OF _MSYSMENU PROMPT "自我介绍(\<H)" COLOR SCHEME 3 ;
	KEY ALT+H, "ALT+H"
ON PAD _0n00kdesu OF _MSYSMENU ACTIVATE POPUP 系统信息s
ON PAD _0n00kdesv OF _MSYSMENU ACTIVATE POPUP 市场生产管
ON PAD _0n00kdesw OF _MSYSMENU ACTIVATE POPUP 仓库管理r
ON PAD _0n00kdesx OF _MSYSMENU ACTIVATE POPUP 基本信息f
ON PAD _0n00kdesy OF _MSYSMENU ACTIVATE POPUP 报表管理p
ON PAD _0n00kdesz OF _MSYSMENU ACTIVATE POPUP 自我介绍h

DEFINE POPUP 系统信息s MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF 系统信息s PROMPT "公司信息设置"
DEFINE BAR 2 OF 系统信息s PROMPT "系统日记"
DEFINE BAR 3 OF 系统信息s PROMPT "\-"
DEFINE BAR 4 OF 系统信息s PROMPT "密码管理"
DEFINE BAR 5 OF 系统信息s PROMPT "修改密码"
DEFINE BAR 6 OF 系统信息s PROMPT "权限管理"
DEFINE BAR 7 OF 系统信息s PROMPT "\-"
DEFINE BAR 8 OF 系统信息s PROMPT "数据备份"
DEFINE BAR 9 OF 系统信息s PROMPT "数据整理"
DEFINE BAR 10 OF 系统信息s PROMPT "清空数据库"
DEFINE BAR 11 OF 系统信息s PROMPT "\-"
DEFINE BAR 12 OF 系统信息s PROMPT "退出系统(\<X)"
ON SELECTION BAR 1 OF 系统信息s Do &P_Prgs.Systeminfo
ON SELECTION BAR 2 OF 系统信息s Do &P_Prgs.Every
ON SELECTION BAR 4 OF 系统信息s Do &P_Prgs.Managepsd
ON SELECTION BAR 5 OF 系统信息s Do &P_Prgs.Changepsd
ON SELECTION BAR 6 OF 系统信息s Do form &P_Frms.Rights
ON SELECTION BAR 8 OF 系统信息s DO &P_PRGS.BACKUP
ON SELECTION BAR 9 OF 系统信息s Do form &P_Frms.PACKFORM
ON SELECTION BAR 10 OF 系统信息s Do form &P_Frms.ZAPFORM
ON SELECTION BAR 12 OF 系统信息s Do &P_Prgs.Logout.PRG

DEFINE POPUP 市场生产管 MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF 市场生产管 PROMPT "客户代码表"
DEFINE BAR 2 OF 市场生产管 PROMPT "成品代码表"
DEFINE BAR 3 OF 市场生产管 PROMPT "客户产品价格"
DEFINE BAR 4 OF 市场生产管 PROMPT "\-"
DEFINE BAR 5 OF 市场生产管 PROMPT "订单输入"
DEFINE BAR 6 OF 市场生产管 PROMPT "发货单"
DEFINE BAR 7 OF 市场生产管 PROMPT "货款回笼"
DEFINE BAR 8 OF 市场生产管 PROMPT "\-"
DEFINE BAR 9 OF 市场生产管 PROMPT "客户资金月报"
DEFINE BAR 10 OF 市场生产管 PROMPT "分销商库存管理"
DEFINE BAR 11 OF 市场生产管 PROMPT "过程检验"
DEFINE BAR 12 OF 市场生产管 PROMPT "换料表"
DEFINE BAR 13 OF 市场生产管 PROMPT "\-"
DEFINE BAR 14 OF 市场生产管 PROMPT "成品检验"
DEFINE BAR 15 OF 市场生产管 PROMPT "成品入库单"
DEFINE BAR 16 OF 市场生产管 PROMPT "成品盘仓表"
DEFINE BAR 17 OF 市场生产管 PROMPT "工资计算"
ON SELECTION BAR 1 OF 市场生产管 Do FORM &P_Frms.BinInfo
ON SELECTION BAR 2 OF 市场生产管 Do FORM &P_Frms.CostingInfo
ON SELECTION BAR 3 OF 市场生产管 Do FORM &P_Frms.CC_price
ON SELECTION BAR 5 OF 市场生产管 Do Form &P_Frms.OrderInfo
ON SELECTION BAR 6 OF 市场生产管 DO FORM &P_Frms.shipmentInfo
ON SELECTION BAR 7 OF 市场生产管 DO FORM &P_Frms.Billreclaim
ON SELECTION BAR 9 OF 市场生产管 DO FORM &P_Frms.CustomReport
ON SELECTION BAR 10 OF 市场生产管 Do FORM &P_Frms.CUSTOMSALES
ON SELECTION BAR 11 OF 市场生产管 DO FORM &P_Frms.品管日报
ON SELECTION BAR 12 OF 市场生产管 DO FORM &P_Frms.matmove
ON SELECTION BAR 15 OF 市场生产管 DO FORM &P_Frms.PRODUCTIN
ON SELECTION BAR 16 OF 市场生产管 DO FORM &P_Frms.CheckWarehouse
ON SELECTION BAR 17 OF 市场生产管 DO FORM &P_Frms.SALARY

DEFINE POPUP 仓库管理r MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF 仓库管理r PROMPT "供应商管理"
DEFINE BAR 2 OF 仓库管理r PROMPT "材料代码维护"
DEFINE BAR 3 OF 仓库管理r PROMPT "购买价格管理"
DEFINE BAR 4 OF 仓库管理r PROMPT "\-"
DEFINE BAR 5 OF 仓库管理r PROMPT "采购单"
DEFINE BAR 6 OF 仓库管理r PROMPT "付款管理"
DEFINE BAR 7 OF 仓库管理r PROMPT "采购欠款"
DEFINE BAR 8 OF 仓库管理r PROMPT "公司应付款"
DEFINE BAR 9 OF 仓库管理r PROMPT "\-"
DEFINE BAR 10 OF 仓库管理r PROMPT "材料余缺表"
DEFINE BAR 11 OF 仓库管理r PROMPT "来料检验单"
DEFINE BAR 12 OF 仓库管理r PROMPT "材料入库单"
DEFINE BAR 13 OF 仓库管理r PROMPT "材料领用单"
DEFINE BAR 14 OF 仓库管理r PROMPT "仓库材料盘点"
DEFINE BAR 15 OF 仓库管理r PROMPT "\-"
DEFINE BAR 16 OF 仓库管理r PROMPT "原料库存管理"
DEFINE BAR 17 OF 仓库管理r PROMPT "材料库存月报"
ON SELECTION BAR 1 OF 仓库管理r Do FORMS &P_Frms.BuysInfo
ON SELECTION BAR 2 OF 仓库管理r Do FORM &P_Frms.BinInfo
ON SELECTION BAR 3 OF 仓库管理r Do FORM &P_Frms.MC_price
ON SELECTION BAR 5 OF 仓库管理r Do FORM &P_Frms.BUYSMAT
ON SELECTION BAR 6 OF 仓库管理r DO FORM &P_Frms.MoneyOut
ON SELECTION BAR 7 OF 仓库管理r DO FORM &P_Frms.judmat
ON SELECTION BAR 8 OF 仓库管理r Do FORM &P_Frms.outmoney.scx
ON SELECTION BAR 10 OF 仓库管理r Do Form &P_Frms.材料余缺表
ON SELECTION BAR 11 OF 仓库管理r Do Form &P_Frms.部件检验
ON SELECTION BAR 12 OF 仓库管理r DO FORM &P_Frms.MatIn
ON SELECTION BAR 13 OF 仓库管理r DO FORM &P_Frms.MatOut
ON SELECTION BAR 14 OF 仓库管理r DO FORM &P_Frms.材料盘点单
ON SELECTION BAR 16 OF 仓库管理r Do FORM &P_Frms.材料库存日报
ON SELECTION BAR 17 OF 仓库管理r DO FORM &P_Frms.材料库存月报

DEFINE POPUP 基本信息f MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF 基本信息f PROMPT "员工信息表"
DEFINE BAR 2 OF 基本信息f PROMPT "代码管理"
DEFINE BAR 3 OF 基本信息f PROMPT "开户银行"
DEFINE BAR 4 OF 基本信息f PROMPT "\-"
DEFINE BAR 5 OF 基本信息f PROMPT "生产制成规划"
DEFINE BAR 6 OF 基本信息f PROMPT "产品齐套明细"
DEFINE BAR 7 OF 基本信息f PROMPT "拆分组合表"
ON SELECTION BAR 1 OF 基本信息f Do FORM &P_Frms.雇员基本信息 WITH 'C'
ON SELECTION BAR 2 OF 基本信息f Do FORM &P_Frms.代码管理
ON SELECTION BAR 3 OF 基本信息f Do FORM &P_Frms.BANKINFO
ON SELECTION BAR 5 OF 基本信息f Do FORM &P_Frms.PRONO
ON SELECTION BAR 6 OF 基本信息f Do FORM &P_Frms.产品齐套明细
ON SELECTION BAR 7 OF 基本信息f Do FORM &P_Frms.拆分组合表

DEFINE POPUP 报表管理p MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF 报表管理p PROMPT "发货单审核"
DEFINE BAR 2 OF 报表管理p PROMPT "发货单明细帐"
DEFINE BAR 3 OF 报表管理p PROMPT "\-"
DEFINE BAR 4 OF 报表管理p PROMPT "成品库日报"
DEFINE BAR 5 OF 报表管理p PROMPT "成品库月报"
DEFINE BAR 6 OF 报表管理p PROMPT "\-"
DEFINE BAR 7 OF 报表管理p PROMPT "销售部日报"
DEFINE BAR 8 OF 报表管理p PROMPT "销售部月报"
DEFINE BAR 9 OF 报表管理p PROMPT "客户资金月报"
DEFINE BAR 10 OF 报表管理p PROMPT "\-"
DEFINE BAR 11 OF 报表管理p PROMPT "客户信息报表"
DEFINE BAR 12 OF 报表管理p PROMPT "客户供货单价信息报表"
DEFINE BAR 13 OF 报表管理p PROMPT "产品信息报表"
DEFINE BAR 14 OF 报表管理p PROMPT "材料代码信息报表"
ON SELECTION BAR 1 OF 报表管理p DO &P_PRGS.SHIPMENTAUDITING
ON SELECTION BAR 2 OF 报表管理p DO &P_PRGS.SHIPMENTDETAILACCOUNT
ON SELECTION BAR 11 OF 报表管理p DO &P_PRGS.PRINTFILE WITH 'B'
ON SELECTION BAR 12 OF 报表管理p DO &P_PRGS.PRINTFILE WITH 'C'
ON SELECTION BAR 13 OF 报表管理p DO &P_PRGS.PRINTFILE WITH 'D'
ON SELECTION BAR 14 OF 报表管理p DO &P_PRGS.PRINTFILE WITH 'K'

DEFINE POPUP 自我介绍h MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF 自我介绍h PROMPT "版本信息(\<V)"
DEFINE BAR 2 OF 自我介绍h PROMPT "\-"
DEFINE BAR 3 OF 自我介绍h PROMPT "义丰木业介绍(\<A)..."
ON SELECTION BAR 1 OF 自我介绍h Do FORM &P_Frms.Version.SCX
ON SELECTION BAR 3 OF 自我介绍h Do Form &P_Frms.About
