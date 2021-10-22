CON=ODBC(5)
Closedb("TEMP1")
IF SQLEXEC(CON,"SELECT TOP 1 CODE FROM BINCODE","TEMP1")<0
	SQLEXEC(CON,"drop table [dbo].[costinginfo]")
	SQLEXEC(CON,"CREATE TABLE [dbo].[costinginfo] ("+;
	"[BillId] [char] (10) COLLATE Chinese_PRC_CI_AS NOT NULL ,"+;
	"[BillClass] [char] (30) COLLATE Chinese_PRC_CI_AS NOT NULL ,"+;
	"[BillNo] [char] (20) COLLATE Chinese_PRC_CI_AS NOT NULL ,"+;
	"[CreatDate] [datetime] NOT NULL ,"+;
	"[ClassId] [char] (10) COLLATE Chinese_PRC_CI_AS NOT NULL ,"+;
	"[Code] [char] (60) COLLATE Chinese_PRC_CI_AS NOT NULL ,"+;
	"[unit] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,"+;
	"[SupplyID] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,"+;
	"[WareHouse] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,"+;
	"[WarePosition] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,"+;
	"[Price] [money] NULL ,"+;
	"[Quan] [money] NULL ,"+;
	"[Cash] [money] NULL ,"+;
	"[TruckId] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,"+;
	"[Note] [char] (100) COLLATE Chinese_PRC_CI_AS NULL ,"+;
	"[ActionName] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,"+;
	"[BillName] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,"+;
	"[interid] [int] NOT NULL PRIMARY KEY CLUSTERED,"+;
	"[checkid] [tinyint] NULL ,"+;
	"[checkname] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,"+;
	"[checkdate] [datetime] NULL ,"+;
	"[SendWay] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ) ON [PRIMARY]")
	SQLEXEC(CON,"CREATE TABLE [dbo].[bincode] ("+;
	"[classid] [char] (10) COLLATE Chinese_PRC_CI_AS NOT NULL ,"+;
	"[code] [char] (60) COLLATE Chinese_PRC_CI_AS NOT NULL ,"+;
	"[note] [char] (100) COLLATE Chinese_PRC_CI_AS NULL ,"+;
	"[creatdate] [datetime] NOT NULL ,"+;
	"[warehouse] [char] (20) COLLATE Chinese_PRC_CI_AS NULL ,"+;
	"[codeposition] [char] (20) COLLATE Chinese_PRC_CI_AS NULL ,"+;
	"[weight] [decimal](9, 3) NULL ,"+;
	"[price] [decimal](9, 3) NULL ,"+;
	"[unit] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,"+;
	"[safeq] [decimal](10, 2) NULL ,"+;
	"[stopid] [tinyint] NULL ,"+;
	"[stopdate] [datetime] NULL ,"+;
	"[TruckInfo] [char] (60) COLLATE Chinese_PRC_CI_AS NULL ,"+;
	"[interid] [int] NOT NULL PRIMARY KEY CLUSTERED,"+;
	"[BillName] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ) ON [PRIMARY]")
	MESSAGEBOX('完成数据库升级，你已经可以启用仓库存储模块！',0+47+1,P_Caption)
ELSE
	MESSAGEBOX('不用升级！',0+47+1,P_Caption)
ENDIF