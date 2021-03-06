USE [master]
GO
/****** Object:  Database [trade]    Script Date: 2021/10/21 17:35:08 ******/
CREATE DATABASE [trade]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'trade', FILENAME = N'D:\database\trade.mdf' , SIZE = 105357824KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%), 
 FILEGROUP [ftfg_lhbcreatforqq] 
( NAME = N'ftrow_lhbcreatforqq', FILENAME = N'D:\database\ftrow_lhbcreatforqq.ndf' , SIZE = 4964608KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N'trade_log', FILENAME = N'D:\database\trade_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [trade] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [trade].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [trade] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [trade] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [trade] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [trade] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [trade] SET ARITHABORT OFF 
GO
ALTER DATABASE [trade] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [trade] SET AUTO_SHRINK ON 
GO
ALTER DATABASE [trade] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [trade] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [trade] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [trade] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [trade] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [trade] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [trade] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [trade] SET  DISABLE_BROKER 
GO
ALTER DATABASE [trade] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [trade] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [trade] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [trade] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [trade] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [trade] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [trade] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [trade] SET RECOVERY FULL 
GO
ALTER DATABASE [trade] SET  MULTI_USER 
GO
ALTER DATABASE [trade] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [trade] SET DB_CHAINING OFF 
GO
ALTER DATABASE [trade] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [trade] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [trade] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'trade', N'ON'
GO
ALTER DATABASE [trade] SET QUERY_STORE = OFF
GO
USE [trade]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [trade]
GO
/****** Object:  User [lu3]    Script Date: 2021/10/21 17:35:08 ******/
CREATE USER [lu3] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [lu3]
GO
/****** Object:  FullTextCatalog [lhbcreatforqq]    Script Date: 2021/10/21 17:35:08 ******/
CREATE FULLTEXT CATALOG [lhbcreatforqq] WITH ACCENT_SENSITIVITY = ON
AS DEFAULT
GO
/****** Object:  UserDefinedFunction [dbo].[DecodePwd]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[DecodePwd]
(
	@user nvarchar(32),
	@userPwd nvarchar(128)
)
RETURNS nvarchar(128)
AS
BEGIN
DECLARE @Return NVARCHAR(100)
SET @Return =''
DECLARE @KeyLen INT,@i INT,@n1 INT,@n2 INT
DECLARE @FStr1 CHAR(1),@FStr2 CHAR(1),@FStr3 CHAR(1),@FStr4 CHAR(1)
DECLARE @fnil nvarchar(128),@FF1 NVARCHAR(128)
SET @fnil = '''(&.&!''%&$"''&)" ",&)$(%#$-$#$$" '
SET @FF1 = ' !"#$%&''()*+,-./'
DECLARE @n int, @d int
DECLARE @Result nvarchar(100)
SET @i = LEN(@user)
SET @Result = SUBSTRING(@fnil,(@i-1)*2+1, 30-(@i-1)*2)
SET @n = @i-1
WHILE(@n>=0)
BEGIN
	SET @i = (ASCII(SUBSTRING(@user,@n+1,1)) - 32) % 16
	SET @d = (ASCII(SUBSTRING(@user,@n+1,1)) - 32) / 16 + 1
	SET @Result = @Result + CHAR(32 + @d + 1) + SUBSTRING(@FF1,@i+1,1)
	SET @n = @n-1
END
SET @KeyLen =0
SET @i =28
WHILE(@i>=1)
BEGIN
	IF(SUBSTRING(@userPwd,@i,1)<>SUBSTRING(@Result,@i,1))
	BEGIN
		SET @KeyLen = @i
		BREAK;
	END
	SET @i = @i-1
END
IF(@KeyLen =0) RETURN ''
SET @i = @KeyLen
WHILE(@i>=1)
BEGIN
	IF(@i<=4)
	BEGIN
		SET @FStr1 = SUBSTRING(@Result,@i,1)
		SET @FStr3 = SUBSTRING(@userPwd,@i,1)
		SET @FStr4 = SUBSTRING(@userPwd,32-4+@i,1)
		SET @n1 = ASCII(@FStr1) ^ ASCII(@FStr3)
		SET @n2 = ((ASCII(@FStr4)-32) / 16)
		SET @Return = CHAR((16*@n2)+32+@n1) + @Return
		SET @FStr4 = CHAR((ASCII(@FStr4) % 16)+32)
		SET @userPwd = SUBSTRING(@userPwd,1,32-4+@i-1)+@FStr4+SUBSTRING(@userPwd,32-4+@i+1,4-@i)
	END
	ELSE
	BEGIN
		SET @FStr1 = SUBSTRING(@Result,@i,1)
		SET @FStr3 = SUBSTRING(@userPwd,@i,1)
		SET @FStr4 = SUBSTRING(@userPwd,@i-4,1)
		SET @n1 = ASCII(@FStr1) ^ ASCII(@FStr3)
		SET @n2 = ((ASCII(@FStr4)-32) / 16)
		SET @Return = CHAR((16*@n2)+32+@n1) + @Return
		SET @FStr4 = CHAR((ASCII(@FStr4) % 16)+32)
		SET @userPwd = SUBSTRING(@userPwd,1,@i-4-1)+@FStr4+SUBSTRING(@userPwd,@i-4+1,32-@i+4)
	END
	SET @i = @i-1
END
RETURN @Return
END

GO
/****** Object:  UserDefinedFunction [dbo].[EncodePwd]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[EncodePwd]
(
	@user nvarchar(32),
	@userPwd nvarchar(32)
)
RETURNS nvarchar(128)
AS
BEGIN
DECLARE @fnil nvarchar(128),@FF1 NVARCHAR(128)
SET @fnil = '''(&.&!''%&$"''&)" ",&)$(%#$-$#$$" '
SET @FF1 = ' !"#$%&''()*+,-./'
DECLARE @n int, @i int, @d int
DECLARE @Result nvarchar(100)
SET @i = LEN(@user)
SET @Result = SUBSTRING(@fnil,(@i-1)*2+1, 30-(@i-1)*2)
SET @n = @i-1
WHILE(@n>=0)
BEGIN
	SET @i = (ASCII(SUBSTRING(@user,@n+1,1)) - 32) % 16
	SET @d = (ASCII(SUBSTRING(@user,@n+1,1)) - 32) / 16 + 1
	SET @Result = @Result + CHAR(32 + @d + 1) + SUBSTRING(@FF1,@i+1,1)
	SET @n = @n-1
END
DECLARE @n1 int	, @n2 int
DECLARE @FStr1 NCHAR(1), @FStr2 NCHAR(1), @FStr3 NCHAR(1), @Fchar1 NCHAR(1)
SET @i =1
WHILE(@i<=LEN(@userPwd))
BEGIN
	IF(@i<=4)
	BEGIN
		SET @FStr1 = SUBSTRING(@userPwd,@i,1)
		SET @FStr2 = SUBSTRING(@Result,@i,1)
		SET @FStr3 = SUBSTRING(@Result,28+@i,1)
		SET @n1 = ((ASCII(SUBSTRING(@userPwd,@i,1)) - 32) % 8)
		SET @n2 = ((ASCII(SUBSTRING(@userPwd,@i,1)) - 32) / 16)
		SET @Fchar1 = CHAR(@n2 * 16 + 32)
		SET @n2 = ASCII(@FStr2) ^ ASCII(@FStr1)
		SET @n2 = (@n2 & 0x0F) + 0x20
		SET @FStr2 =CHAR(@n2)
		SET @FStr3 = CHAR(ASCII(@Fchar1) + ((ASCII(@FStr3) + ASCII(@Fchar1)) % 16))
		SET @Result = SUBSTRING(@Result,1, @i-1) + @FStr2 + Substring(@Result,@i + 1, 31 - @i+1)
		SET @Result = Substring(@Result,1, 28 + @i-1) + @FStr3 + Substring(@Result,29 + @i, 3 - @i+1)
	END
	ELSE
	BEGIN
		SET @FStr1 = SUBSTRING(@userPwd,@i,1)
		SET @FStr2 = SUBSTRING(@Result,@i,1)
		SET @FStr3 = SUBSTRING(@Result,@i-4,1)
		SET @n1 = ((ASCII(SUBSTRING(@userPwd,@i,1)) - 32) % 16)
		SET @n2 = ((ASCII(SUBSTRING(@userPwd,@i,1)) - 32) / 16)
		SET @Fchar1 = CHAR(@n2 * 16 + 32)
		SET @n2 = ASCII(@FStr2) ^ ASCII(@FStr1)
		SET @n2 = (@n2 & 0x0F) + 0x20
		SET @FStr2 =CHAR(@n2)
		SET @FStr3 = CHAR(ASCII(@Fchar1) + ((ASCII(@FStr3) + ASCII(@Fchar1)) % 16))
		SET @Result = SUBSTRING(@Result,1, @i-1) + @FStr2 + Substring(@Result,@i + 1, 31 - @i+1)
		SET @Result = Substring(@Result,1, @i-4-1) + @FStr3 + Substring(@Result,@i-3, 35 - @i+1)
	END
	SET @i = @i+1
	
END
RETURN @Result
END
GO
/****** Object:  UserDefinedFunction [dbo].[helperpwd]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[helperpwd] 
(
	@user nvarchar(32),
	@userPwd nvarchar(128)
)
RETURNS nvarchar(128)
AS
BEGIN
DECLARE @Return NVARCHAR(100)
SET @Return =''
DECLARE @KeyLen INT,@i INT,@n1 INT,@n2 INT
DECLARE @FStr1 CHAR(1),@FStr2 CHAR(1),@FStr3 CHAR(1),@FStr4 CHAR(1)
DECLARE @fnil nvarchar(128),@FF1 NVARCHAR(128)
SET @fnil = '''(&.&!''%&$"''&)" ",&)$(%#$-$#$$" '
SET @FF1 = ' !"#$%&''()*+,-./'
DECLARE @n int, @d int
DECLARE @Result nvarchar(100)
SET @i = LEN(@user)
SET @Result = SUBSTRING(@fnil,(@i-1)*2+1, 30-(@i-1)*2)
SET @n = @i-1
WHILE(@n>=0)
BEGIN
	SET @i = (ASCII(SUBSTRING(@user,@n+1,1)) - 32) % 16
	SET @d = (ASCII(SUBSTRING(@user,@n+1,1)) - 32) / 16 + 1
	SET @Result = @Result + CHAR(32 + @d + 1) + SUBSTRING(@FF1,@i+1,1)
	SET @n = @n-1
END
SET @KeyLen =0
SET @i =28
WHILE(@i>=1)
BEGIN
	IF(SUBSTRING(@userPwd,@i,1)<>SUBSTRING(@Result,@i,1))
	BEGIN
		SET @KeyLen = @i
		BREAK;
	END
	SET @i = @i-1
END
IF(@KeyLen =0) RETURN ''
SET @i = @KeyLen
WHILE(@i>=1)
BEGIN
	IF(@i<=4)
	BEGIN
		SET @FStr1 = SUBSTRING(@Result,@i,1)
		SET @FStr3 = SUBSTRING(@userPwd,@i,1)
		SET @FStr4 = SUBSTRING(@userPwd,32-4+@i,1)
		SET @n1 = ASCII(@FStr1) ^ ASCII(@FStr3)
		SET @n2 = ((ASCII(@FStr4)-32) / 16)
		SET @Return = CHAR((16*@n2)+32+@n1) + @Return
		SET @FStr4 = CHAR((ASCII(@FStr4) % 16)+32)
		SET @userPwd = SUBSTRING(@userPwd,1,32-4+@i-1)+@FStr4+SUBSTRING(@userPwd,32-4+@i+1,4-@i)
	END
	ELSE
	BEGIN
		SET @FStr1 = SUBSTRING(@Result,@i,1)
		SET @FStr3 = SUBSTRING(@userPwd,@i,1)
		SET @FStr4 = SUBSTRING(@userPwd,@i-4,1)
		SET @n1 = ASCII(@FStr1) ^ ASCII(@FStr3)
		SET @n2 = ((ASCII(@FStr4)-32) / 16)
		SET @Return = CHAR((16*@n2)+32+@n1) + @Return
		SET @FStr4 = CHAR((ASCII(@FStr4) % 16)+32)
		SET @userPwd = SUBSTRING(@userPwd,1,@i-4-1)+@FStr4+SUBSTRING(@userPwd,@i-4+1,32-@i+4)
	END
	SET @i = @i-1
END
RETURN @Return
END
GO
/****** Object:  Table [dbo].[getsmm]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[getsmm](
	[note] [char](40) NULL,
	[name] [varchar](60) NULL,
	[price] [varchar](30) NULL,
	[aver] [numeric](18, 2) NULL,
	[change] [numeric](18, 2) NULL,
	[today] [char](10) NULL,
	[creatdate] [datetime] NOT NULL,
	[interid] [int] NOT NULL,
	[getid] [tinyint] NULL,
 CONSTRAINT [PK_getsmm_1] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[testview]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[testview]
AS
SELECT   name, price, aver, interid, creatdate
FROM      dbo.getsmm
GO
/****** Object:  Table [dbo].[201806]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[201806](
	[note] [varchar](50) NULL,
	[name] [varchar](50) NULL,
	[price] [varchar](50) NULL,
	[aver] [varchar](50) NULL,
	[change] [varchar](50) NULL,
	[today] [varchar](50) NULL,
	[creatdate] [varchar](50) NULL,
	[interid] [varchar](50) NULL,
	[getid] [varchar](50) NULL,
	[日期] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[addendancesource]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[addendancesource](
	[sourceattendance] [char](32) NOT NULL,
 CONSTRAINT [PK_addendancesource] PRIMARY KEY CLUSTERED 
(
	[sourceattendance] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AdjustTable]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AdjustTable](
	[interid] [int] NOT NULL,
	[MoldNo] [char](10) NULL,
	[DateId] [datetime] NULL,
	[NumId] [char](10) NULL,
	[MoldType] [char](10) NULL,
	[Adjustor] [char](10) NULL,
	[Checker] [char](10) NULL,
	[ProduceName] [char](60) NULL,
	[MaterialName] [char](60) NULL,
	[proportion] [char](10) NULL,
	[Color] [char](20) NULL,
	[MoldSpec] [char](20) NULL,
	[Pick] [char](10) NULL,
	[Gross] [decimal](18, 2) NULL,
	[Net] [decimal](18, 2) NULL,
	[Tempreture] [decimal](18, 2) NULL,
	[Temp_Control] [tinyint] NULL,
	[OiledMach] [tinyint] NULL,
	[oiledMachine] [decimal](18, 2) NULL,
	[Ice] [decimal](18, 2) NULL,
	[MouthT] [decimal](18, 2) NULL,
	[one] [decimal](18, 2) NULL,
	[two] [decimal](18, 0) NULL,
	[three] [decimal](18, 2) NULL,
	[four] [decimal](18, 2) NULL,
	[five] [decimal](18, 2) NULL,
	[RejustWay] [char](10) NULL,
	[APosition] [char](18) NULL,
	[bTime] [char](18) NULL,
	[RejustTime] [decimal](18, 2) NULL,
	[FrozenTime] [decimal](18, 2) NULL,
	[Cycle] [decimal](18, 2) NULL,
	[P1] [smallint] NULL,
	[P2] [smallint] NULL,
	[P3] [smallint] NULL,
	[P4] [smallint] NULL,
	[P5] [smallint] NULL,
	[P6] [smallint] NULL,
	[S1] [smallint] NULL,
	[S2] [smallint] NULL,
	[S3] [smallint] NULL,
	[S4] [smallint] NULL,
	[S5] [smallint] NULL,
	[S6] [smallint] NULL,
	[A1] [char](10) NULL,
	[A2] [char](10) NULL,
	[A3] [char](10) NULL,
	[A4] [char](10) NULL,
	[A5] [char](10) NULL,
	[A6] [char](10) NULL,
	[P11] [smallint] NULL,
	[P12] [smallint] NULL,
	[P13] [smallint] NULL,
	[P14] [smallint] NULL,
	[S11] [smallint] NULL,
	[S12] [smallint] NULL,
	[S13] [smallint] NULL,
	[S14] [smallint] NULL,
	[T11] [decimal](5, 2) NULL,
	[T12] [decimal](5, 2) NULL,
	[T13] [decimal](5, 2) NULL,
	[T14] [decimal](5, 2) NULL,
	[P21] [smallint] NULL,
	[P22] [smallint] NULL,
	[P23] [smallint] NULL,
	[P24] [smallint] NULL,
	[U1] [smallint] NULL,
	[U2] [smallint] NULL,
	[U3] [smallint] NULL,
	[U4] [smallint] NULL,
	[U5] [char](10) NULL,
	[U6] [decimal](18, 2) NULL,
	[S21] [smallint] NULL,
	[S22] [smallint] NULL,
	[S23] [smallint] NULL,
	[S24] [smallint] NULL,
	[A11] [char](10) NULL,
	[A12] [char](10) NULL,
	[A13] [char](10) NULL,
	[A14] [char](10) NULL,
	[A15] [decimal](18, 2) NULL,
	[RejustFast] [char](10) NULL,
	[Sustain] [char](10) NULL,
	[Way] [char](10) NULL,
	[FunctionSelect] [char](10) NULL,
	[Control] [char](10) NULL,
	[Pressure1] [smallint] NULL,
	[Pressure2] [smallint] NULL,
	[Pressure3] [smallint] NULL,
	[Pressure4] [smallint] NULL,
	[Speed1] [smallint] NULL,
	[Speed2] [smallint] NULL,
	[Speed3] [smallint] NULL,
	[Speed4] [smallint] NULL,
	[Delay1] [decimal](5, 2) NULL,
	[Delay2] [decimal](5, 2) NULL,
	[Delay3] [decimal](5, 2) NULL,
	[Delay4] [decimal](5, 2) NULL,
	[Position1] [char](10) NULL,
	[Position2] [char](10) NULL,
	[Position3] [char](10) NULL,
	[Position4] [char](10) NULL,
	[Te_P1] [smallint] NULL,
	[Te_P2] [smallint] NULL,
	[Te_P3] [smallint] NULL,
	[Te_P4] [smallint] NULL,
	[Te_S1] [smallint] NULL,
	[Te_S2] [smallint] NULL,
	[Te_S3] [smallint] NULL,
	[Te_S4] [smallint] NULL,
	[AT1] [decimal](5, 2) NULL,
	[AT2] [decimal](5, 2) NULL,
	[AT3] [decimal](5, 2) NULL,
	[AT4] [decimal](5, 2) NULL,
	[TC1] [smallint] NULL,
	[TC2] [smallint] NULL,
	[TC3] [smallint] NULL,
	[TC4] [smallint] NULL,
	[AP1] [char](10) NULL,
	[AP2] [char](10) NULL,
	[AP3] [char](10) NULL,
	[AP4] [char](10) NULL,
	[Package] [char](30) NULL,
	[Inside] [char](30) NULL,
	[bp] [int] NULL,
	[pcsb] [int] NULL,
	[pcsp] [int] NULL,
	[cardboard] [char](30) NULL,
	[Paper] [char](30) NULL,
	[Specialist] [char](10) NULL,
	[Exchange] [char](10) NULL,
	[Re_production] [char](10) NULL,
	[finalize_design] [char](10) NULL,
	[Tools] [char](10) NULL,
	[Note] [char](200) NULL,
	[ChkId] [tinyint] NULL,
	[ChkMan] [char](10) NULL,
	[ChkDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[appalarmset]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[appalarmset](
	[sn] [char](20) NULL,
	[snid] [varchar](40) NULL,
	[creatdate] [datetime] NOT NULL,
	[uuid] [varchar](150) NULL,
	[action] [char](20) NULL,
	[devname] [varchar](150) NULL,
	[mobname] [varchar](40) NULL,
	[mobtype] [varchar](40) NULL,
	[mobver] [varchar](40) NULL,
	[mobid] [varchar](40) NULL,
	[mobidver] [varchar](40) NULL,
	[firmver] [varchar](40) NULL,
	[longitude] [varchar](40) NULL,
	[latitude] [varchar](40) NULL,
	[Country] [varchar](40) NULL,
	[password] [varchar](40) NULL,
	[mobidname] [varchar](40) NULL,
	[speed] [decimal](8, 2) NULL,
	[altitude] [varchar](40) NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_appalarmsetx] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[appalarmsety]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[appalarmsety](
	[sn] [char](20) NULL,
	[snid] [varchar](40) NULL,
	[creatdate] [datetime] NOT NULL,
	[uuid] [varchar](150) NULL,
	[action] [char](20) NULL,
	[devname] [varchar](150) NULL,
	[mobname] [varchar](40) NULL,
	[mobtype] [varchar](40) NULL,
	[mobver] [varchar](40) NULL,
	[mobid] [varchar](40) NULL,
	[mobidver] [varchar](40) NULL,
	[firmver] [varchar](40) NULL,
	[longitude] [varchar](40) NULL,
	[latitude] [varchar](40) NULL,
	[Country] [varchar](40) NULL,
	[password] [varchar](40) NULL,
	[mobidname] [varchar](40) NULL,
	[speed] [decimal](8, 2) NULL,
	[altitude] [varchar](40) NULL,
	[id] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[approve]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[approve](
	[interid] [int] NOT NULL,
	[roundid] [tinyint] NULL,
	[orderid] [tinyint] NULL,
	[action] [char](10) NULL,
	[name] [char](10) NULL,
	[creatdate] [datetime] NULL,
	[billname] [char](10) NULL,
	[note] [char](100) NULL,
 CONSTRAINT [PK_approve] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[approveaction]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[approveaction](
	[interid] [int] NOT NULL,
	[maininterid] [int] NULL,
	[roundid] [tinyint] NULL,
	[orderid] [tinyint] NULL,
	[action] [char](10) NULL,
	[name] [char](10) NULL,
	[note] [char](300) NULL,
	[readdate] [datetime] NULL,
	[approvedate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AskLevel]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AskLevel](
	[interid] [int] NOT NULL,
	[dateid] [datetime] NOT NULL,
	[code] [char](10) NOT NULL,
	[datefrom] [char](14) NOT NULL,
	[dateto] [char](14) NULL,
	[classid] [char](10) NULL,
	[classdetail] [char](40) NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL,
	[chkid] [tinyint] NULL,
	[chkname] [char](10) NULL,
	[chkdate] [datetime] NULL,
	[note] [char](300) NULL,
	[dept] [char](10) NULL,
	[id] [char](10) NULL,
	[chkid1] [tinyint] NULL,
	[chkid2] [tinyint] NULL,
	[chkid3] [tinyint] NULL,
	[chkname1] [char](10) NULL,
	[chkname3] [char](10) NULL,
	[chkname2] [char](10) NULL,
	[chkdate1] [datetime] NULL,
	[chkdate2] [datetime] NULL,
	[chkdate3] [datetime] NULL,
	[price] [numeric](4, 1) NULL,
	[cash] [decimal](18, 2) NULL,
	[chgday] [tinyint] NULL,
	[examination] [tinyint] NULL,
	[sanction] [char](10) NULL,
	[hours] [numeric](4, 1) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Attachments]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Attachments](
	[interid] [char](48) NOT NULL,
	[filename] [char](100) NOT NULL,
	[Attachments] [varbinary](max) NOT NULL,
	[filesize] [int] NULL,
 CONSTRAINT [PK_Attachments] PRIMARY KEY CLUSTERED 
(
	[interid] ASC,
	[filename] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AttdanceBalance]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AttdanceBalance](
	[code] [char](10) NOT NULL,
	[dateid] [char](8) NOT NULL,
	[hours] [numeric](18, 2) NOT NULL,
	[note] [char](100) NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[attendancereal]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[attendancereal](
	[numid] [char](10) NULL,
	[name] [char](10) NULL,
	[dept] [char](10) NULL,
	[dateid] [char](8) NULL,
	[time1] [nchar](5) NULL,
	[time2] [char](5) NULL,
	[time3] [char](5) NULL,
	[time4] [char](5) NULL,
	[hint] [char](10) NULL,
	[statusid] [char](10) NULL,
	[exectime] [numeric](3, 1) NULL,
	[frequency] [tinyint] NULL,
	[interid] [int] NOT NULL,
	[note] [char](150) NULL,
	[appo] [char](10) NULL,
	[creatdate] [datetime] NULL,
	[billname] [char](10) NULL,
	[chkid] [tinyint] NULL,
	[time5] [char](5) NULL,
	[time6] [char](5) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[attendancerecord]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[attendancerecord](
	[numid] [char](10) NULL,
	[name] [char](10) NULL,
	[dept] [char](20) NULL,
	[dateid] [char](8) NULL,
	[time1] [nchar](5) NULL,
	[time2] [char](5) NULL,
	[time3] [char](5) NULL,
	[time4] [char](5) NULL,
	[time5] [char](5) NULL,
	[time6] [char](5) NULL,
	[hint] [char](10) NULL,
	[statusid] [char](10) NULL,
	[exectime] [numeric](3, 1) NULL,
	[frequency] [tinyint] NULL,
	[interid] [int] NOT NULL,
	[note] [char](50) NULL,
	[appo] [char](10) NULL,
	[creatdate] [datetime] NULL,
	[billname] [char](10) NULL,
	[chkid] [tinyint] NULL,
 CONSTRAINT [PK_attendancerecord] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditLog]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Command] [nvarchar](1000) NULL,
	[PostTime] [nvarchar](24) NULL,
	[HostName] [nvarchar](100) NULL,
	[LoginName] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_group]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_group](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](80) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_group_permissions]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_group_permissions](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[group_id] [int] NOT NULL,
	[permission_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [auth_group_permissions_group_id_permission_id_0cd325b0_uniq] UNIQUE NONCLUSTERED 
(
	[group_id] ASC,
	[permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_permission]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_permission](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[content_type_id] [int] NOT NULL,
	[codename] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [auth_permission_content_type_id_codename_01ab375a_uniq] UNIQUE NONCLUSTERED 
(
	[content_type_id] ASC,
	[codename] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_user]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_user](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[password] [nvarchar](128) NOT NULL,
	[last_login] [datetime2](7) NULL,
	[is_superuser] [bit] NOT NULL,
	[username] [nvarchar](150) NOT NULL,
	[first_name] [nvarchar](30) NOT NULL,
	[last_name] [nvarchar](150) NOT NULL,
	[email] [nvarchar](254) NOT NULL,
	[is_staff] [bit] NOT NULL,
	[is_active] [bit] NOT NULL,
	[date_joined] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [auth_user_username_6821ab7c_uniq] UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_user_groups]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_user_groups](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[group_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [auth_user_groups_user_id_group_id_94350c0c_uniq] UNIQUE NONCLUSTERED 
(
	[user_id] ASC,
	[group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_user_user_permissions]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_user_user_permissions](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[permission_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [auth_user_user_permissions_user_id_permission_id_14a6b632_uniq] UNIQUE NONCLUSTERED 
(
	[user_id] ASC,
	[permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[backfire]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[backfire](
	[interid] [int] NOT NULL,
	[num] [char](20) NOT NULL,
	[name] [char](40) NOT NULL,
	[spec] [char](40) NULL,
	[classid] [char](20) NULL,
	[fixreason] [char](200) NOT NULL,
	[applydept] [char](10) NULL,
	[applyman] [char](10) NULL,
	[applydate] [datetime] NULL,
	[makedate] [datetime] NULL,
	[totalquan] [int] NULL,
	[moldstatus] [char](100) NOT NULL,
	[disposal] [char](100) NULL,
	[prefee] [int] NULL,
	[feeout] [char](10) NULL,
	[checkman] [char](10) NULL,
	[checkdate] [datetime] NULL,
	[backfirefee] [int] NULL,
	[backfiredate] [datetime] NULL,
	[approvalnote] [char](100) NULL,
	[moldmanage] [char](10) NULL,
	[moldmanagedate] [datetime] NULL,
	[note] [char](100) NULL,
	[creatdate] [datetime] NULL,
	[billname] [char](10) NULL,
	[fixcycle] [smallint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bankname]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bankname](
	[name] [char](10) NULL,
	[note] [char](200) NULL,
	[interid] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_bankname] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BankRecord]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BankRecord](
	[creatdate] [char](20) NULL,
	[billname] [char](10) NULL,
	[dateid] [char](20) NULL,
	[billclass] [char](4) NULL,
	[bank] [char](20) NULL,
	[item] [char](20) NULL,
	[abstract] [char](40) NULL,
	[cash] [decimal](18, 2) NULL,
	[itemclass] [char](10) NULL,
	[dept] [char](10) NULL,
	[actionname] [char](10) NULL,
	[note] [char](100) NULL,
	[interid] [int] NOT NULL,
	[currcash] [decimal](18, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[billpic]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[billpic](
	[classid] [tinyint] NOT NULL,
	[interid] [int] NOT NULL,
	[filename] [char](20) NOT NULL,
	[filedata] [varbinary](max) NULL,
	[keyid] [int] IDENTITY(1,1) NOT NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL,
 CONSTRAINT [PK_billpic] PRIMARY KEY CLUSTERED 
(
	[keyid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bincode]    Script Date: 2021/10/21 17:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bincode](
	[code] [char](20) NOT NULL,
	[name] [char](60) NULL,
	[spec] [char](60) NULL,
	[unit] [char](10) NULL,
	[attr] [char](10) NULL,
	[dateid] [char](8) NULL,
	[creatdate] [datetime] NULL,
	[billname] [char](10) NULL,
	[rate] [decimal](18, 2) NULL,
	[matcost] [numeric](18, 2) NULL,
	[MB057] [numeric](18, 2) NULL,
	[MB058] [numeric](18, 2) NULL,
	[MB059] [numeric](18, 2) NULL,
	[MB060] [numeric](18, 2) NULL,
	[MB046] [numeric](18, 2) NULL,
	[customcode] [char](20) NULL,
	[pictid] [int] NULL,
	[productname] [char](60) NULL,
	[itemno] [char](20) NULL,
	[descripe] [char](400) NULL,
	[material] [char](60) NULL,
	[shape] [char](60) NULL,
	[lightsource] [char](60) NULL,
	[bulb] [char](60) NULL,
	[iprating] [char](60) NULL,
	[spkg] [numeric](18, 2) NULL,
	[spw] [numeric](18, 2) NULL,
	[spd] [numeric](18, 2) NULL,
	[sph] [numeric](18, 2) NULL,
	[spcmb] [numeric](18, 6) NULL,
	[mcpcs] [numeric](18, 2) NULL,
	[mckgs] [numeric](18, 2) NULL,
	[mcw] [numeric](18, 2) NULL,
	[mcd] [numeric](18, 2) NULL,
	[mch] [numeric](18, 2) NULL,
	[mccmb] [numeric](18, 6) NULL,
	[approval] [char](60) NULL,
	[moq] [numeric](18, 2) NULL,
	[qty20fcl] [numeric](18, 2) NULL,
	[qty40fcl] [numeric](18, 2) NULL,
	[qty40h] [numeric](18, 2) NULL,
	[size] [char](120) NULL,
	[codeclass] [char](60) NULL,
	[saleclass] [char](40) NULL,
	[package] [char](60) NULL,
	[unitrequ] [char](60) NULL,
	[unitbarcode] [char](60) NULL,
	[innerquan] [int] NULL,
	[unitcode] [char](40) NULL,
	[unitname] [char](60) NULL,
	[unitspec] [char](60) NULL,
	[smscode] [char](40) NULL,
	[smsname] [char](60) NULL,
	[smsspec] [char](60) NULL,
	[outerbarcode] [char](60) NULL,
	[outercode] [char](40) NULL,
	[outername] [char](60) NULL,
	[outerspec] [char](60) NULL,
	[customcode2] [char](100) NULL,
	[supply] [char](40) NULL,
	[codeseries] [char](40) NULL,
	[innerbarcode] [char](40) NULL,
	[codecolor] [char](40) NULL,
	[oldid] [int] NULL,
	[nbkgs] [numeric](18, 2) NULL,
	[nbw] [numeric](18, 2) NULL,
	[nbd] [numeric](18, 2) NULL,
	[nbh] [numeric](18, 2) NULL,
	[nbcmb] [numeric](18, 2) NULL,
	[oem] [tinyint] NULL,
	[obm] [tinyint] NULL,
	[odm] [tinyint] NULL,
 CONSTRAINT [PK_bincode1] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bincode12]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bincode12](
	[itemno] [char](20) NULL,
	[name] [char](60) NULL,
	[spec] [char](60) NULL,
	[code] [char](20) NOT NULL,
	[unit] [char](10) NULL,
	[attr] [char](10) NULL,
	[dateid] [char](8) NULL,
	[creatdate] [datetime] NULL,
	[billname] [char](10) NULL,
	[rate] [decimal](18, 2) NULL,
	[matcost] [numeric](18, 2) NULL,
	[MB057] [numeric](18, 2) NULL,
	[MB058] [numeric](18, 2) NULL,
	[MB059] [numeric](18, 2) NULL,
	[MB060] [numeric](18, 2) NULL,
	[MB046] [numeric](18, 2) NULL,
	[customcode] [char](20) NULL,
	[pictid] [int] NULL,
	[productname] [char](60) NULL,
	[descripe] [char](300) NULL,
	[material] [char](60) NULL,
	[shape] [char](60) NULL,
	[lightsource] [char](60) NULL,
	[bulb] [char](60) NULL,
	[iprating] [char](60) NULL,
	[spkg] [numeric](18, 2) NULL,
	[spw] [numeric](18, 2) NULL,
	[spd] [numeric](18, 2) NULL,
	[sph] [numeric](18, 2) NULL,
	[spcmb] [numeric](18, 6) NULL,
	[mcpcs] [numeric](18, 2) NULL,
	[mckgs] [numeric](18, 2) NULL,
	[mcw] [numeric](18, 2) NULL,
	[mcd] [numeric](18, 2) NULL,
	[mch] [numeric](18, 2) NULL,
	[mccmb] [numeric](18, 6) NULL,
	[approval] [char](60) NULL,
	[moq] [numeric](18, 2) NULL,
	[qty20fcl] [numeric](18, 2) NULL,
	[qty40fcl] [numeric](18, 2) NULL,
	[qty40h] [numeric](18, 2) NULL,
	[size] [char](120) NULL,
	[codeclass] [char](40) NULL,
	[saleclass] [char](40) NULL,
	[package] [char](60) NULL,
	[unitrequ] [char](60) NULL,
	[unitbarcode] [char](60) NULL,
	[innerquan] [int] NULL,
	[unitcode] [char](40) NULL,
	[unitname] [char](60) NULL,
	[unitspec] [char](60) NULL,
	[smscode] [char](40) NULL,
	[smsname] [char](60) NULL,
	[smsspec] [char](60) NULL,
	[outerbarcode] [char](60) NULL,
	[outercode] [char](40) NULL,
	[outername] [char](60) NULL,
	[outerspec] [char](60) NULL,
	[customcode2] [char](40) NULL,
	[supply] [char](40) NULL,
	[codeseries] [char](40) NULL,
	[innerbarcode] [char](40) NULL,
	[codecolor] [char](40) NULL,
	[oldid] [tinyint] NULL,
	[nbkgs] [numeric](18, 2) NULL,
	[nbw] [numeric](18, 2) NULL,
	[nbd] [numeric](18, 2) NULL,
	[nbh] [numeric](18, 2) NULL,
	[nbcmb] [numeric](18, 2) NULL,
	[123] [nchar](10) NULL,
 CONSTRAINT [PK_bincode] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bincodepic]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bincodepic](
	[code] [char](20) NOT NULL,
	[classid] [tinyint] NOT NULL,
	[filedata] [varbinary](max) NULL,
	[filename] [char](200) NULL,
 CONSTRAINT [PK_bincodepic] PRIMARY KEY CLUSTERED 
(
	[code] ASC,
	[classid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cdf]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cdf](
	[interid] [int] NOT NULL,
	[no] [char](10) NOT NULL,
	[lightno] [char](10) NULL,
	[classid] [char](20) NULL,
	[parameters] [char](50) NULL,
	[holder] [char](10) NULL,
	[suppliers] [char](10) NULL,
	[laboratory] [char](10) NULL,
	[gs] [char](10) NULL,
	[lvd_certificate] [char](20) NULL,
	[lvd_report] [char](20) NULL,
	[lvd_standard] [char](100) NULL,
	[lvd_issuing] [char](10) NULL,
	[emc_certificate] [char](20) NULL,
	[emc_report] [char](20) NULL,
	[emc_standard] [char](100) NULL,
	[emc_issuing] [char](10) NOT NULL,
	[en_certificate] [char](20) NULL,
	[en_report] [char](20) NULL,
	[en_standard] [char](100) NULL,
	[en_issuing] [char](10) NULL,
	[checkid] [tinyint] NULL,
	[chkman] [char](10) NULL,
	[chkdate] [datetime] NULL,
	[creatdate] [datetime] NULL,
	[billname] [char](10) NULL,
	[note] [char](100) NULL,
 CONSTRAINT [PK_cdf] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cdfdetail]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cdfdetail](
	[no] [char](10) NOT NULL,
	[supplyid] [char](10) NULL,
	[supplier] [char](20) NULL,
	[code] [char](10) NULL,
	[name] [char](50) NULL,
	[spec] [char](50) NULL,
	[standard] [char](150) NULL,
	[ClassID] [char](20) NULL,
	[CertNum] [char](20) NULL,
	[interid] [int] NOT NULL,
 CONSTRAINT [PK_cdfdetail] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cdfmain]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cdfmain](
	[interid] [int] NOT NULL,
	[classid] [char](10) NULL,
	[certificate] [char](20) NULL,
	[report] [char](20) NULL,
	[standard] [char](100) NULL,
	[issuing] [char](10) NULL,
 CONSTRAINT [PK_cdfmain] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ceotable]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ceotable](
	[NAME] [char](20) NOT NULL,
	[Y1] [char](4) NOT NULL,
	[M1] [numeric](18, 2) NULL,
	[M2] [numeric](18, 2) NULL,
	[M3] [numeric](18, 2) NULL,
	[M4] [numeric](18, 2) NULL,
	[M5] [numeric](18, 2) NULL,
	[M6] [numeric](18, 2) NULL,
	[M7] [numeric](18, 2) NULL,
	[M8] [numeric](18, 2) NULL,
	[M9] [numeric](18, 2) NULL,
	[M10] [numeric](18, 2) NULL,
	[M11] [numeric](18, 2) NULL,
	[M12] [numeric](18, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[checkweb]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[checkweb](
	[classid] [char](20) NULL,
	[name] [char](30) NULL,
	[checktime] [datetime] NULL,
	[note] [varbinary](max) NULL,
	[interid] [int] IDENTITY(1,1) NOT NULL,
	[endid] [tinyint] NULL,
 CONSTRAINT [PK_checkweb] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[chgrecord]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chgrecord](
	[interid] [int] NOT NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL,
	[billclass] [char](20) NULL,
	[oldvalue] [char](20) NULL,
	[newvalue] [char](20) NULL,
	[chgcontent] [char](60) NULL,
	[keyvalue] [char](30) NULL,
 CONSTRAINT [PK_chgrecord] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[chksend]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chksend](
	[sender] [char](10) NULL,
	[receivers] [char](100) NULL,
	[sendcontent] [char](2000) NULL,
	[interid] [int] NULL,
	[classid] [char](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[codeinfo]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[codeinfo](
	[classid] [char](10) NOT NULL,
	[name] [char](20) NOT NULL,
	[des] [char](40) NOT NULL,
 CONSTRAINT [PK_codeinfo] PRIMARY KEY CLUSTERED 
(
	[classid] ASC,
	[name] ASC,
	[des] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[costinginfo]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[costinginfo](
	[BillId] [char](10) NOT NULL,
	[BillClass] [char](30) NOT NULL,
	[BillNo] [char](20) NOT NULL,
	[CreatDate] [datetime] NOT NULL,
	[ClassId] [char](10) NOT NULL,
	[Code] [char](60) NOT NULL,
	[unit] [char](10) NULL,
	[SupplyID] [char](10) NULL,
	[WareHouse] [char](10) NULL,
	[WarePosition] [char](10) NULL,
	[Price] [money] NULL,
	[Quan] [money] NULL,
	[Cash] [money] NULL,
	[TruckId] [char](10) NULL,
	[Note] [char](100) NULL,
	[ActionName] [char](10) NULL,
	[BillName] [char](10) NULL,
	[interid] [int] NOT NULL,
	[checkid] [tinyint] NULL,
	[checkname] [char](10) NULL,
	[checkdate] [datetime] NULL,
	[SendWay] [char](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[currency]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[currency](
	[currency] [char](10) NULL,
	[rate] [numeric](18, 6) NULL,
	[creatdate] [datetime] NOT NULL,
	[ok] [tinyint] NULL,
	[interid] [int] NOT NULL,
	[note] [char](100) NULL,
	[billname] [char](10) NULL,
 CONSTRAINT [PK_currency] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[currencyrate]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[currencyrate](
	[dateid] [char](10) NOT NULL,
	[currency] [char](10) NOT NULL,
	[rate] [numeric](18, 6) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[customcost]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[customcost](
	[customid] [char](20) NOT NULL,
	[name] [char](50) NULL,
	[code] [char](20) NOT NULL,
	[cost] [numeric](18, 2) NULL,
	[ta001] [char](4) NULL,
	[ta002] [char](20) NULL,
	[tc003] [char](10) NULL,
	[orderid] [char](50) NULL,
	[rate] [numeric](18, 2) NULL,
	[quan] [int] NULL,
	[yb] [numeric](18, 2) NULL,
	[price] [numeric](18, 2) NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL,
	[defarate] [numeric](18, 2) NULL,
 CONSTRAINT [PK_customcost_1] PRIMARY KEY CLUSTERED 
(
	[customid] ASC,
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomInfo]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomInfo](
	[Code] [char](20) NOT NULL,
	[TableID] [tinyint] NOT NULL,
	[PayCustom] [char](60) NULL,
	[PayAcc] [char](60) NULL,
	[RevCond] [char](60) NULL,
	[RevAcc] [char](60) NULL,
	[QuoteName] [char](60) NULL,
	[QuoteEmail] [char](60) NULL,
	[QuoteCC] [char](60) NULL,
	[PIName] [char](60) NULL,
	[PIEmail] [char](60) NULL,
	[PICC] [char](60) NULL,
	[StatName] [char](60) NULL,
	[StatEmail] [char](60) NULL,
	[StatCC] [char](60) NULL,
	[Quote] [int] NULL,
	[PI] [int] NULL,
	[Stat] [int] NULL,
	[Inv] [int] NULL,
	[Package] [int] NULL,
	[Customs] [int] NULL,
	[creatdate] [datetime] NULL,
	[billname] [char](10) NULL,
	[consignee] [char](200) NULL,
	[notifyparty] [char](40) NULL,
	[way] [char](10) NULL,
	[tel] [char](40) NULL,
	[fax] [char](40) NULL,
	[attn] [char](40) NULL,
	[crop] [char](40) NULL,
	[freight] [char](40) NULL,
	[country] [char](20) NULL,
	[trade] [char](10) NULL,
	[exchange] [char](10) NULL,
	[cpbz] [char](40) NULL,
	[unit] [char](20) NULL,
	[autopackage] [tinyint] NULL,
 CONSTRAINT [PK_CustomInfo] PRIMARY KEY CLUSTERED 
(
	[Code] ASC,
	[TableID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[customreport]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[customreport](
	[interid] [int] NOT NULL,
	[customid] [char](40) NULL,
	[reportinterid] [int] NULL,
	[defaultreportid] [char](40) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[daily]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[daily](
	[interid] [int] NOT NULL,
	[important] [tinyint] NULL,
	[classid] [char](20) NULL,
	[dateid] [char](10) NULL,
	[billname] [char](10) NULL,
	[lab] [char](50) NULL,
	[topic] [char](100) NULL,
	[dept] [char](20) NULL,
	[appo] [char](20) NULL,
	[creatdate] [datetime] NULL,
	[RichID] [int] NULL,
	[FileID] [int] NULL,
	[readid] [int] NULL,
	[othid] [int] NULL,
	[PutFile] [char](180) NULL,
	[note] [char](6000) NULL,
	[newread] [char](50) NULL,
 CONSTRAINT [PK_daily] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dailyfile]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dailyfile](
	[interid] [int] NOT NULL,
	[filedata] [varbinary](max) NULL,
	[filename] [char](200) NULL,
 CONSTRAINT [PK_dailyfile] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dailyread]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dailyread](
	[interid] [int] NOT NULL,
	[readid] [int] NOT NULL,
	[readman] [char](10) NULL,
	[dateid] [datetime] NULL,
	[feedback] [char](2250) NULL,
	[dept] [char](10) NULL,
	[appo] [char](10) NULL,
	[fileid] [int] NULL,
 CONSTRAINT [PK_dailyread] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dailyreadfile]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dailyreadfile](
	[interid] [int] NOT NULL,
	[filedata] [varbinary](max) NULL,
	[filename] [char](200) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dailyrich]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dailyrich](
	[interid] [int] NOT NULL,
	[richtx] [varchar](max) NULL,
 CONSTRAINT [PK_dailyrich] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dailyrich1]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dailyrich1](
	[interid] [int] NOT NULL,
	[richtx] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dashboard]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dashboard](
	[interid] [int] NOT NULL,
	[name] [char](90) NULL,
	[keydate] [char](16) NULL,
	[getval] [numeric](18, 2) NOT NULL,
	[planval] [numeric](18, 2) NULL,
	[good] [numeric](18, 2) NULL,
	[better] [numeric](18, 2) NULL,
	[middle] [numeric](18, 2) NULL,
	[poor] [numeric](18, 2) NULL,
	[bad] [numeric](18, 2) NULL,
	[keyweight] [numeric](18, 2) NULL,
	[score] [numeric](18, 2) NULL,
	[creatdate] [datetime] NULL,
	[billname] [char](10) NULL,
	[preval] [numeric](18, 2) NOT NULL,
	[note] [char](60) NULL,
	[odbc] [tinyint] NULL,
	[orderid] [tinyint] NULL,
 CONSTRAINT [PK_dashboard] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[defaultval]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[defaultval](
	[interid] [int] NOT NULL,
	[name] [char](40) NOT NULL,
	[item] [char](25) NOT NULL,
	[val] [decimal](18, 3) NULL,
	[allowdel] [int] NULL,
 CONSTRAINT [PK_defaultval] PRIMARY KEY CLUSTERED 
(
	[name] ASC,
	[item] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[deftruck]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[deftruck](
	[interid] [int] NOT NULL,
	[classid] [char](10) NULL,
	[name] [char](60) NULL,
	[long] [int] NULL,
	[width] [int] NULL,
	[high] [int] NULL,
	[loadw] [int] NULL,
	[selfw] [int] NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL,
 CONSTRAINT [PK_deftruck] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dingdingchat]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dingdingchat](
	[chatid] [varchar](80) NOT NULL,
	[member_id] [varchar](2000) NULL,
	[member_name] [varchar](200) NULL,
	[title] [varchar](80) NULL,
 CONSTRAINT [PK_dingdingchat] PRIMARY KEY CLUSTERED 
(
	[chatid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dingdinguser]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dingdinguser](
	[userid] [varchar](50) NOT NULL,
	[name] [varchar](20) NULL,
	[jobnumber] [varchar](20) NULL,
	[orderInDepts] [varchar](200) NULL,
	[dept] [varchar](30) NULL,
	[mobile] [char](11) NULL,
 CONSTRAINT [PK_dingdinguser] PRIMARY KEY CLUSTERED 
(
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[django_admin_log]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[django_admin_log](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[action_time] [datetime2](7) NOT NULL,
	[object_id] [nvarchar](max) NULL,
	[object_repr] [nvarchar](200) NOT NULL,
	[action_flag] [smallint] NOT NULL,
	[change_message] [nvarchar](max) NOT NULL,
	[content_type_id] [int] NULL,
	[user_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[django_content_type]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[django_content_type](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[app_label] [nvarchar](100) NOT NULL,
	[model] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [django_content_type_app_label_model_76bd3d3b_uniq] UNIQUE NONCLUSTERED 
(
	[app_label] ASC,
	[model] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[django_migrations]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[django_migrations](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[app] [nvarchar](255) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[applied] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[django_session]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[django_session](
	[session_key] [nvarchar](40) NOT NULL,
	[session_data] [nvarchar](max) NOT NULL,
	[expire_date] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[session_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dzapprove]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dzapprove](
	[interid] [int] NOT NULL,
	[keyinterid] [int] NULL,
	[keyorder] [tinyint] NULL,
	[chkname] [char](10) NULL,
	[chkdate] [datetime] NULL,
	[note] [char](100) NULL,
	[chkid] [tinyint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[employee]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[employee](
	[numid] [char](10) NULL,
	[name] [char](10) NULL,
	[passcode] [char](18) NULL,
	[birthday] [datetime] NULL,
	[sexer] [int] NULL,
	[peoples] [char](10) NULL,
	[kultur] [char](10) NULL,
	[grad] [char](30) NULL,
	[spec] [char](40) NULL,
	[prov] [char](10) NULL,
	[city] [char](10) NULL,
	[tel] [char](40) NULL,
	[introduce] [char](10) NULL,
	[addr] [char](60) NULL,
	[census] [char](60) NULL,
	[factory] [char](10) NULL,
	[dept] [char](10) NULL,
	[appo] [char](10) NULL,
	[grade] [char](10) NULL,
	[saldate] [datetime] NULL,
	[marriage] [char](10) NULL,
	[workdate] [datetime] NULL,
	[sign] [datetime] NULL,
	[exprie] [datetime] NULL,
	[account] [char](30) NULL,
	[salclass] [char](10) NULL,
	[salary] [int] NULL,
	[tex] [int] NULL,
	[insure] [int] NULL,
	[singleson] [int] NULL,
	[picture] [varbinary](max) NULL,
	[note] [char](100) NULL,
	[attrib] [char](10) NULL,
	[interid] [int] NOT NULL,
	[sdate] [char](20) NULL,
	[bank] [char](30) NULL,
	[ChkDelim] [tinyint] NULL,
	[DeimitDate] [datetime] NULL,
	[Reason] [char](30) NULL,
	[DemitReason] [char](30) NULL,
	[Deduct] [decimal](18, 2) NULL,
	[Other] [decimal](18, 2) NULL,
	[deductpercent] [decimal](18, 2) NULL,
	[deductCash] [decimal](18, 2) NULL,
	[Creatdate] [datetime] NULL,
	[BillName] [char](10) NULL,
 CONSTRAINT [PK_employee] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[energy]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[energy](
	[interid] [int] NOT NULL,
	[item] [char](10) NULL,
	[workshop] [char](10) NULL,
	[dateid] [char](8) NULL,
	[tableid] [char](20) NULL,
	[startid] [int] NULL,
	[endid] [int] NULL,
	[quan] [int] NULL,
	[price] [decimal](18, 3) NULL,
	[note] [char](100) NULL,
	[creatdate] [datetime] NULL,
	[billname] [char](10) NULL,
 CONSTRAINT [PK_energy] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[entBookmark]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[entBookmark](
	[bookmarkID] [bigint] NOT NULL,
	[bookmarkType] [varchar](50) NOT NULL,
	[bookmarkName] [nvarchar](255) NOT NULL,
	[bookmarkValue] [nvarchar](1024) NOT NULL,
	[isGlobal] [int] NOT NULL,
 CONSTRAINT [entBookmark_pk] PRIMARY KEY CLUSTERED 
(
	[bookmarkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[entBookmarkPerm]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[entBookmarkPerm](
	[bookmarkID] [bigint] NOT NULL,
	[bookmarkType] [tinyint] NOT NULL,
	[name] [nvarchar](255) NOT NULL,
 CONSTRAINT [entBookmarkPerm_pk] PRIMARY KEY CLUSTERED 
(
	[bookmarkID] ASC,
	[name] ASC,
	[bookmarkType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[entConParticipant]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[entConParticipant](
	[conversationID] [bigint] NOT NULL,
	[joinedDate] [bigint] NOT NULL,
	[leftDate] [bigint] NULL,
	[bareJID] [nvarchar](255) NOT NULL,
	[jidResource] [nvarchar](255) NOT NULL,
	[nickname] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[entConversation]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[entConversation](
	[conversationID] [bigint] NOT NULL,
	[room] [nvarchar](1024) NULL,
	[isExternal] [tinyint] NOT NULL,
	[startDate] [bigint] NOT NULL,
	[lastActivity] [bigint] NOT NULL,
	[messageCount] [int] NOT NULL,
 CONSTRAINT [entConversation_pk] PRIMARY KEY CLUSTERED 
(
	[conversationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[entMessageArchive]    Script Date: 2021/10/21 17:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[entMessageArchive](
	[conversationID] [bigint] NOT NULL,
	[fromJID] [nvarchar](1024) NOT NULL,
	[toJID] [nvarchar](1024) NOT NULL,
	[sentDate] [bigint] NOT NULL,
	[body] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[entRRDs]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[entRRDs](
	[id] [nvarchar](100) NOT NULL,
	[updatedDate] [bigint] NOT NULL,
	[bytes] [image] NULL,
 CONSTRAINT [entRRDs_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[everyday]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[everyday](
	[interid] [int] IDENTITY(1,1) NOT NULL,
	[username] [char](42) NOT NULL,
	[datetime] [datetime] NOT NULL,
	[filename] [char](30) NOT NULL,
	[id] [char](100) NOT NULL,
	[editmode] [char](20) NOT NULL,
	[mac] [char](20) NULL,
 CONSTRAINT [PK_everyday] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fixmoldapply]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fixmoldapply](
	[interid] [int] NOT NULL,
	[num] [char](20) NOT NULL,
	[name] [char](40) NOT NULL,
	[spec] [char](40) NULL,
	[classid] [char](20) NULL,
	[fixreason] [char](200) NULL,
	[applydept] [char](10) NULL,
	[applyman] [char](10) NULL,
	[applydate] [datetime] NULL,
	[makedate] [datetime] NULL,
	[totalquan] [int] NULL,
	[moldstatus] [char](100) NULL,
	[disposal] [char](100) NULL,
	[prefee] [int] NULL,
	[feeout] [char](10) NULL,
	[checkman] [char](10) NULL,
	[checkdate] [datetime] NULL,
	[approvalman] [char](10) NULL,
	[approvaldate] [datetime] NULL,
	[approvalnote] [char](100) NULL,
	[moldmanage] [char](10) NULL,
	[moldmanagedate] [datetime] NULL,
	[note] [char](100) NULL,
	[creatdate] [datetime] NULL,
	[billname] [char](10) NULL,
	[fixcycle] [smallint] NULL,
 CONSTRAINT [PK_fixmoldapply] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FIXMOLDDETAIL]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FIXMOLDDETAIL](
	[MOldNO] [char](20) NULL,
	[REASON] [char](100) NULL,
	[PROVE] [char](200) NULL,
	[WAY] [char](100) NULL,
	[ENDDATE] [char](8) NULL,
	[NOTE] [char](200) NULL,
	[NAME] [char](10) NULL,
	[BILLSTATUS] [char](10) NULL,
	[BILLNAME] [char](10) NULL,
	[CREATDATE] [datetime] NULL,
	[INTERID] [int] NOT NULL,
	[moldname] [char](60) NULL,
	[dateid] [char](8) NULL,
	[cc] [int] NULL,
	[mc] [int] NULL,
	[xc] [int] NULL,
	[xqg] [int] NULL,
	[dhh] [int] NULL,
	[sh] [int] NULL,
	[ch] [int] NULL,
	[dh] [int] NULL,
	[zk] [int] NULL,
	[qg] [int] NULL,
	[zc] [int] NULL,
	[qt] [int] NULL,
 CONSTRAINT [PK_FIXMOLDDETAIL] PRIMARY KEY CLUSTERED 
(
	[INTERID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[flat]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[flat](
	[code] [char](20) NOT NULL,
	[blankflat] [char](20) NOT NULL,
	[creatdate] [datetime] NULL,
	[billname] [char](10) NULL,
 CONSTRAINT [PK_flat] PRIMARY KEY CLUSTERED 
(
	[code] ASC,
	[blankflat] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fordashboad]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fordashboad](
	[MA001] [char](10) NULL,
	[MA002] [char](20) NULL,
	[MA028] [char](1) NULL,
	[TD001] [char](4) NULL,
	[TD002] [char](11) NULL,
	[TD003] [char](4) NULL,
	[TB039] [varchar](20) NULL,
	[MB002] [varchar](60) NULL,
	[MB003] [varchar](60) NULL,
	[TD008] [numeric](15, 6) NULL,
	[TH008] [numeric](15, 6) NULL,
	[MB080] [char](20) NULL,
	[MA065] [char](10) NULL,
	[MA021] [char](8) NULL,
	[MA022] [char](8) NULL,
	[TB022] [numeric](17, 6) NULL,
	[TB023] [numeric](17, 8) NULL,
	[LA012] [numeric](17, 8) NULL,
	[TB019] [numeric](17, 2) NULL,
	[XHCB] [numeric](35, 14) NULL,
	[MLR] [numeric](36, 14) NULL,
	[TA003] [char](8) NULL,
	[TB001] [char](4) NOT NULL,
	[ME001] [char](6) NULL,
	[ME002] [char](20) NULL,
	[MV001] [char](10) NULL,
	[MV002] [char](10) NULL,
	[COH] [varchar](20) NULL,
	[TC003] [char](8) NULL,
	[TD038] [numeric](15, 2) NULL,
	[TD039] [numeric](15, 2) NULL,
	[AREA] [char](10) NULL,
	[COUNTRY] [char](10) NULL,
	[TC001] [char](4) NULL,
	[TC002] [varchar](15) NULL,
	[SB001] [char](4) NULL,
	[SB002] [varchar](15) NULL,
	[TB002] [varchar](15) NULL,
	[KJFL] [varchar](37) NULL,
	[SPFL] [varchar](37) NULL,
	[CPXL] [varchar](37) NULL,
	[YS] [varchar](37) NULL,
	[TG003] [char](8) NULL,
	[TA009] [char](4) NULL,
	[BZCB] [numeric](36, 14) NULL,
	[TB018] [numeric](17, 2) NULL,
	[TH007] [char](10) NULL,
	[MA017] [char](6) NULL,
	[TA001] [char](4) NULL,
	[GYS] [char](20) NULL,
	[MAKE] [char](20) NULL,
	[YCMAKE] [char](20) NULL,
	[LEIBIE] [char](10) NULL,
	[MQNAME] [char](10) NULL,
	[PACKAGE] [char](60) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[formcaption]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[formcaption](
	[classid] [char](40) NULL,
	[name] [char](30) NULL,
	[defaname] [char](30) NULL,
	[tableid] [int] NULL,
	[useid] [int] NULL,
	[interid] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[formula]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[formula](
	[name] [char](30) NOT NULL,
	[formula] [char](600) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fpAgentProp]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fpAgentProp](
	[ownerID] [int] NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[propValue] [nvarchar](3900) NOT NULL,
 CONSTRAINT [fpAgentProp_pk] PRIMARY KEY CLUSTERED 
(
	[ownerID] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fpAgentSession]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fpAgentSession](
	[sessionID] [nvarchar](31) NOT NULL,
	[agentJID] [nvarchar](255) NOT NULL,
	[joinTime] [char](15) NOT NULL,
	[leftTime] [char](15) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fpChatSetting]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fpChatSetting](
	[workgroupNode] [nvarchar](100) NULL,
	[type] [int] NULL,
	[label] [nvarchar](100) NULL,
	[description] [nvarchar](255) NULL,
	[name] [nvarchar](100) NULL,
	[value] [text] NULL,
	[defaultValue] [text] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fpDispatcher]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fpDispatcher](
	[queueID] [int] NOT NULL,
	[name] [nvarchar](50) NULL,
	[description] [nvarchar](255) NULL,
	[offerTimeout] [int] NOT NULL,
	[requestTimeout] [int] NOT NULL,
 CONSTRAINT [fpDispatcher_pk] PRIMARY KEY CLUSTERED 
(
	[queueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fpDispatcherProp]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fpDispatcherProp](
	[ownerID] [int] NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[propValue] [nvarchar](3900) NOT NULL,
 CONSTRAINT [fpDispatcherProp_pk] PRIMARY KEY CLUSTERED 
(
	[ownerID] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fpOfflineSetting]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fpOfflineSetting](
	[workgroupID] [int] NOT NULL,
	[redirectPage] [nvarchar](255) NULL,
	[emailAddress] [nvarchar](255) NULL,
	[subject] [nvarchar](255) NULL,
	[offlineText] [text] NULL,
 CONSTRAINT [fpOfflineSetting_pk] PRIMARY KEY CLUSTERED 
(
	[workgroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fpQueue]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fpQueue](
	[queueID] [int] NOT NULL,
	[workgroupID] [int] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[description] [nvarchar](255) NULL,
	[priority] [int] NOT NULL,
	[maxchats] [int] NOT NULL,
	[minchats] [int] NOT NULL,
	[overflow] [int] NOT NULL,
	[backupQueue] [int] NULL,
 CONSTRAINT [fpQueue_pk] PRIMARY KEY CLUSTERED 
(
	[workgroupID] ASC,
	[queueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fpQueueAgent]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fpQueueAgent](
	[queueID] [int] NOT NULL,
	[objectID] [int] NOT NULL,
	[objectType] [int] NOT NULL,
	[administrator] [int] NULL,
 CONSTRAINT [jive_fpGroupQueue_pk] PRIMARY KEY CLUSTERED 
(
	[queueID] ASC,
	[objectID] ASC,
	[objectType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fpQueueGroup]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fpQueueGroup](
	[queueID] [int] NOT NULL,
	[groupName] [nvarchar](50) NOT NULL,
 CONSTRAINT [jive_fpQueueAgent_pk] PRIMARY KEY CLUSTERED 
(
	[queueID] ASC,
	[groupName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fpQueueProp]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fpQueueProp](
	[ownerID] [int] NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[propValue] [nvarchar](3900) NOT NULL,
 CONSTRAINT [fpQueueProp_pk] PRIMARY KEY CLUSTERED 
(
	[ownerID] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fpRouteRule]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fpRouteRule](
	[workgroupID] [int] NOT NULL,
	[queueID] [int] NOT NULL,
	[rulePosition] [int] NOT NULL,
	[query] [text] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fpSearchIndex]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fpSearchIndex](
	[workgroupID] [int] NOT NULL,
	[lastUpdated] [char](15) NOT NULL,
	[lastOptimization] [char](15) NOT NULL,
 CONSTRAINT [fpSearchIndex_pk] PRIMARY KEY CLUSTERED 
(
	[workgroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fpSession]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fpSession](
	[sessionID] [nvarchar](31) NOT NULL,
	[userID] [nvarchar](200) NOT NULL,
	[workgroupID] [int] NOT NULL,
	[transcript] [text] NULL,
	[startTime] [char](15) NOT NULL,
	[endTime] [char](15) NOT NULL,
	[queueWaitTime] [int] NULL,
	[state] [int] NOT NULL,
	[caseID] [nvarchar](20) NULL,
	[status] [char](15) NULL,
	[notes] [text] NULL,
 CONSTRAINT [fpSession_pk] PRIMARY KEY CLUSTERED 
(
	[sessionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fpSessionMetadata]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fpSessionMetadata](
	[sessionID] [nvarchar](31) NOT NULL,
	[metadataName] [nvarchar](200) NOT NULL,
	[metadataValue] [text] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fpSessionProp]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fpSessionProp](
	[sessionID] [nvarchar](31) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[propValue] [text] NOT NULL,
 CONSTRAINT [fpSessionProp_pk] PRIMARY KEY CLUSTERED 
(
	[sessionID] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fpSetting]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fpSetting](
	[workgroupName] [nvarchar](100) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[namespace] [nvarchar](245) NOT NULL,
	[value] [text] NOT NULL,
 CONSTRAINT [fpSetting_pk] PRIMARY KEY CLUSTERED 
(
	[workgroupName] ASC,
	[name] ASC,
	[namespace] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fpWorkgroup]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fpWorkgroup](
	[workgroupID] [int] NOT NULL,
	[jid] [varchar](255) NOT NULL,
	[displayName] [nvarchar](50) NULL,
	[description] [nvarchar](255) NULL,
	[status] [int] NOT NULL,
	[modes] [int] NOT NULL,
	[creationDate] [char](15) NOT NULL,
	[modificationDate] [char](15) NOT NULL,
	[maxchats] [int] NOT NULL,
	[minchats] [int] NOT NULL,
	[requestTimeout] [int] NOT NULL,
	[offerTimeout] [int] NOT NULL,
	[schedule] [nvarchar](3400) NULL,
 CONSTRAINT [fpWorkgroup_pk] PRIMARY KEY CLUSTERED 
(
	[workgroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fpWorkgroupProp]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fpWorkgroupProp](
	[ownerID] [int] NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[propValue] [text] NULL,
 CONSTRAINT [fpWorkgroupProp_pk] PRIMARY KEY CLUSTERED 
(
	[ownerID] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fpWorkgroupRoster]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fpWorkgroupRoster](
	[workgroupID] [int] NOT NULL,
	[jid] [nvarchar](444) NOT NULL,
	[lastContact] [char](15) NULL,
 CONSTRAINT [fpWorkgroupRoster_pk] PRIMARY KEY CLUSTERED 
(
	[workgroupID] ASC,
	[jid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gatewayAvatars]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gatewayAvatars](
	[jid] [nvarchar](255) NOT NULL,
	[imageData] [ntext] NOT NULL,
	[xmppHash] [nvarchar](255) NULL,
	[legacyIdentifier] [nvarchar](255) NULL,
	[createDate] [bigint] NOT NULL,
	[lastUpdate] [bigint] NULL,
	[imageType] [nvarchar](25) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gatewayPseudoRoster]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gatewayPseudoRoster](
	[registrationID] [bigint] NOT NULL,
	[username] [nvarchar](255) NOT NULL,
	[nickname] [nvarchar](255) NULL,
	[groups] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gatewayRegistration]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gatewayRegistration](
	[registrationID] [bigint] NOT NULL,
	[jid] [nvarchar](255) NOT NULL,
	[transportType] [nvarchar](15) NOT NULL,
	[username] [nvarchar](255) NOT NULL,
	[password] [nvarchar](255) NULL,
	[nickname] [nvarchar](255) NULL,
	[registrationDate] [bigint] NOT NULL,
	[lastLogin] [bigint] NULL,
 CONSTRAINT [gatewayReg_pk] PRIMARY KEY CLUSTERED 
(
	[registrationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gatewayRestrictions]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gatewayRestrictions](
	[transportType] [nvarchar](15) NOT NULL,
	[username] [nvarchar](255) NULL,
	[groupname] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gatewayVCards]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gatewayVCards](
	[jid] [nvarchar](255) NOT NULL,
	[value] [ntext] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[getweb]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[getweb](
	[interid] [int] NOT NULL,
	[classid] [char](10) NULL,
	[caption] [char](100) NULL,
	[linkweb] [char](254) NULL,
	[timeid] [char](100) NULL,
	[abs] [char](254) NULL,
	[sendto] [char](100) NULL,
	[creatdate] [datetime] NULL,
	[modidate] [datetime] NULL,
	[keyword] [char](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[goodsforest]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[goodsforest](
	[goods] [char](140) NOT NULL,
	[s1] [int] NOT NULL,
	[s2] [int] NOT NULL,
	[s3] [int] NOT NULL,
	[s4] [int] NOT NULL,
	[s5] [int] NOT NULL,
	[s6] [int] NOT NULL,
	[s7] [int] NOT NULL,
	[s8] [int] NOT NULL,
	[s9] [int] NOT NULL,
	[s10] [int] NOT NULL,
	[s11] [int] NOT NULL,
	[s12] [int] NOT NULL,
	[e1] [int] NOT NULL,
	[e2] [int] NOT NULL,
	[e3] [int] NOT NULL,
	[e4] [int] NOT NULL,
	[e5] [int] NOT NULL,
	[e6] [int] NOT NULL,
	[e7] [int] NOT NULL,
	[e8] [int] NOT NULL,
	[e9] [int] NOT NULL,
	[e10] [int] NOT NULL,
	[e11] [int] NOT NULL,
	[e12] [int] NOT NULL,
	[yearn] [char](6) NOT NULL,
	[mine] [int] NOT NULL,
	[id] [int] NOT NULL,
	[total] [int] NULL,
	[ton] [char](20) NULL,
	[ng] [decimal](18, 3) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gridtree]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gridtree](
	[frootid] [int] NOT NULL,
	[fchildid] [int] NOT NULL,
	[fcode] [char](30) NOT NULL,
	[fname] [char](20) NOT NULL,
	[flayer] [int] NOT NULL,
	[fqty] [int] NOT NULL,
	[fchildqty] [int] NOT NULL,
	[ffirstnode] [int] NOT NULL,
	[flastnode] [int] NOT NULL,
	[fvisible] [bit] NOT NULL,
	[fnode] [bit] NOT NULL,
	[fopen] [bit] NOT NULL,
	[fcheck] [bit] NOT NULL,
	[fpicid] [char](20) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HangIncome]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HangIncome](
	[InterID] [int] NOT NULL,
	[OrderInterId] [int] NULL,
	[CustomId] [char](10) NULL,
	[CustomName] [char](40) NULL,
	[DateID] [char](10) NULL,
	[shipdate] [char](10) NULL,
	[BillNo] [char](20) NULL,
	[Contract] [char](20) NULL,
	[Note] [char](200) NULL,
	[Total] [decimal](18, 2) NULL,
	[other] [decimal](18, 2) NULL,
	[DetainFund] [decimal](18, 2) NULL,
	[Income] [decimal](18, 2) NULL,
	[CheckID] [tinyint] NULL,
	[CheckName] [char](10) NULL,
	[CheckDate] [char](20) NULL,
	[CreatDate] [char](20) NULL,
	[Billname] [char](10) NULL,
	[tableid] [tinyint] NULL,
	[sendway] [char](20) NULL,
	[DEPT] [char](10) NULL,
	[paycustom] [char](20) NULL,
	[revacc] [char](20) NULL,
	[currency] [char](20) NULL,
	[invno] [char](20) NULL,
	[revcond] [char](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[INVMA]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INVMA](
	[COMPANY] [char](10) NULL,
	[CREATOR] [char](10) NULL,
	[USR_GROUP] [char](10) NULL,
	[CREATE_DATE] [char](17) NULL,
	[MODIFIER] [char](10) NULL,
	[MODI_DATE] [char](17) NULL,
	[FLAG] [numeric](3, 0) NULL,
	[MA001] [char](1) NOT NULL,
	[MA002] [char](6) NOT NULL,
	[MA003] [char](30) NULL,
	[MA004] [char](20) NULL,
	[MA005] [char](20) NULL,
	[MA006] [char](20) NULL,
	[MA007] [char](20) NULL,
	[MA008] [char](20) NULL,
	[MA009] [char](1) NULL,
	[MA010] [char](12) NULL,
	[MA011] [char](1) NULL,
	[MA012] [char](20) NULL,
	[MA013] [char](1) NULL,
	[MA014] [char](8) NULL,
	[MA015] [varchar](30) NULL,
	[MA016] [numeric](13, 2) NULL,
	[MA017] [numeric](13, 2) NULL,
	[MA018] [numeric](13, 2) NULL,
	[UDF01] [varchar](255) NULL,
	[UDF02] [varchar](255) NULL,
	[UDF03] [varchar](255) NULL,
	[UDF04] [varchar](255) NULL,
	[UDF05] [varchar](255) NULL,
	[UDF06] [varchar](255) NULL,
	[UDF51] [numeric](15, 6) NULL,
	[UDF52] [numeric](15, 6) NULL,
	[UDF53] [numeric](15, 6) NULL,
	[UDF54] [numeric](15, 6) NULL,
	[UDF55] [numeric](15, 6) NULL,
	[UDF56] [numeric](15, 6) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[INVMB]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INVMB](
	[MB001] [char](20) NOT NULL,
	[MB002] [varchar](60) NOT NULL,
	[MB003] [varchar](60) NULL,
	[MB014] [numeric](10, 3) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ipchange]    Script Date: 2021/10/21 17:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ipchange](
	[piinterid] [int] NULL,
	[interid] [int] NOT NULL,
	[chgdate] [char](10) NULL,
	[item] [char](60) NULL,
	[note] [char](1000) NULL,
	[sender] [char](10) NULL,
	[receivers] [char](80) NULL,
	[sendim] [int] NOT NULL,
 CONSTRAINT [PK_ipchange] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lutec_bom]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lutec_bom](
	[item] [varchar](100) NULL,
	[child] [varchar](100) NULL,
	[quantity] [varchar](100) NULL,
	[uom] [varchar](100) NULL,
	[write_date] [varchar](100) NULL,
	[id] [varchar](100) NULL,
	[creatdate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lutec_mrp_routing]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lutec_mrp_routing](
	[item] [varchar](100) NULL,
	[Workcenter] [varchar](100) NULL,
	[UPH] [varchar](100) NULL,
	[NbWorker] [varchar](100) NULL,
	[Cost] [varchar](100) NULL,
	[write_date] [varchar](100) NULL,
	[id] [varchar](100) NULL,
	[creatdate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lutec_product]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lutec_product](
	[item] [varchar](100) NULL,
	[name] [varchar](100) NULL,
	[description] [varchar](1000) NULL,
	[status] [varchar](100) NULL,
	[type] [varchar](100) NULL,
	[mfg] [varchar](100) NULL,
	[scrap_rate] [varchar](100) NULL,
	[bom_unit] [varchar](100) NULL,
	[purchase_unit] [varchar](100) NULL,
	[write_date] [varchar](100) NULL,
	[id] [varchar](100) NULL,
	[creatdate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lutec_purchase_order]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lutec_purchase_order](
	[purchase] [varchar](100) NULL,
	[supplier] [varchar](100) NULL,
	[due_date] [varchar](100) NULL,
	[item] [varchar](100) NULL,
	[quantity_ordered] [varchar](100) NULL,
	[quantity_received] [varchar](100) NULL,
	[uom] [varchar](100) NULL,
	[price_unit] [varchar](100) NULL,
	[currency] [varchar](100) NULL,
	[write_date] [varchar](100) NULL,
	[id] [varchar](100) NULL,
	[id_line] [varchar](100) NULL,
	[creatdate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lutec_revisions]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lutec_revisions](
	[object] [varchar](100) NULL,
	[name] [varchar](100) NULL,
	[filed] [varchar](100) NULL,
	[before] [varchar](1000) NULL,
	[after] [varchar](1000) NULL,
	[write_date] [varchar](100) NULL,
	[id] [varchar](100) NULL,
	[id_line] [varchar](100) NULL,
	[creatdate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lutec_sale_order]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lutec_sale_order](
	[customer] [varchar](100) NULL,
	[sale_order] [varchar](100) NULL,
	[product] [varchar](100) NULL,
	[quantity] [varchar](100) NULL,
	[quantity_delivered] [varchar](100) NULL,
	[quantity_pending] [varchar](100) NULL,
	[price_unit] [varchar](100) NULL,
	[price_subtotal] [varchar](100) NULL,
	[value_delivered] [varchar](100) NULL,
	[value_pending] [varchar](100) NULL,
	[order_date] [varchar](100) NULL,
	[crd_date] [varchar](100) NULL,
	[psi_date] [varchar](100) NULL,
	[loading_date] [varchar](100) NULL,
	[shipping_date] [varchar](100) NULL,
	[write_date] [varchar](100) NULL,
	[currency_id] [varchar](100) NULL,
	[creatdate] [datetime] NULL,
	[id] [varchar](100) NULL,
	[id_line] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lutec_supplierinfo]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lutec_supplierinfo](
	[item] [varchar](100) NULL,
	[priority] [varchar](100) NULL,
	[supplier] [varchar](100) NULL,
	[price] [varchar](100) NULL,
	[currency] [varchar](100) NULL,
	[lead_time] [varchar](100) NULL,
	[moq] [varchar](100) NULL,
	[spq] [varchar](100) NULL,
	[spq_uom] [varchar](100) NULL,
	[write_date] [varchar](100) NULL,
	[id] [varchar](100) NULL,
	[creatdate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LutecApp]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LutecApp](
	[ApkVersion] [char](20) NOT NULL,
	[DateId] [datetime] NULL,
	[ApkContent] [varbinary](max) NULL,
	[UpdateMan] [char](20) NULL,
	[UpdateDescription] [varchar](200) NULL,
	[ApkName] [char](20) NULL,
	[ApkSize] [int] NULL,
 CONSTRAINT [PK_LutecApp] PRIMARY KEY CLUSTERED 
(
	[ApkVersion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[madeapprove]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[madeapprove](
	[interid] [int] NOT NULL,
	[keyinterid] [int] NULL,
	[keyorder] [tinyint] NULL,
	[chkname] [char](10) NULL,
	[chkdate] [datetime] NULL,
	[note] [char](100) NULL,
	[chkid] [tinyint] NULL,
	[ver] [tinyint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[madedetail]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[madedetail](
	[interid] [int] NOT NULL,
	[maininterid] [int] NULL,
	[workline] [char](20) NULL,
	[ta001] [char](4) NULL,
	[ta002] [char](20) NULL,
	[code] [char](20) NULL,
	[name] [char](60) NULL,
	[spec] [char](60) NULL,
	[planquan] [int] NULL,
	[okquan] [int] NULL,
	[note] [char](60) NULL,
	[statusid] [char](10) NULL,
	[ta033] [char](20) NULL,
	[manhour] [decimal](18, 2) NULL,
	[badquan] [int] NULL,
 CONSTRAINT [PK_madedetail] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[madeline]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[madeline](
	[interid] [int] NULL,
	[workline] [char](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mademain]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mademain](
	[interid] [int] NOT NULL,
	[workshopid] [char](10) NULL,
	[workshopname] [char](10) NULL,
	[dateid] [char](10) NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL,
	[note] [char](1000) NULL,
	[statusid] [char](10) NULL,
	[chkid] [tinyint] NULL,
	[chkname] [char](10) NULL,
	[chkdate] [datetime] NULL,
	[requid] [tinyint] NULL,
	[requdate] [datetime] NULL,
 CONSTRAINT [PK_mademain] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[madeok]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[madeok](
	[interid] [int] NOT NULL,
	[getinterid] [int] NULL,
	[quan] [int] NULL,
	[dateid] [datetime] NULL,
	[note] [char](60) NULL,
	[badquan] [nchar](10) NULL,
 CONSTRAINT [PK_madeok] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[makecheck]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[makecheck](
	[numid] [char](10) NULL,
	[operator] [char](10) NULL,
	[orderid] [int] NULL,
	[goodsname] [char](30) NULL,
	[goodsspec] [char](20) NULL,
	[mat] [char](20) NULL,
	[color] [char](20) NULL,
	[ptime] [char](10) NULL,
	[quan] [int] NULL,
	[bad] [int] NULL,
	[note] [char](100) NULL,
	[dateid] [datetime] NOT NULL,
	[pdept] [char](10) NULL,
	[edept] [char](10) NULL,
	[dept] [char](10) NULL,
	[checkbill] [int] NULL,
	[goodscode] [char](10) NULL,
	[unit] [char](10) NULL,
	[reason] [char](60) NULL,
	[progress] [char](30) NULL,
	[result] [char](10) NULL,
	[package] [char](20) NULL,
	[checkman] [char](10) NULL,
	[leader] [char](10) NULL,
	[class] [char](10) NULL,
	[interid] [int] NULL,
	[rowguid] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MakeDayDetail]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MakeDayDetail](
	[InterID] [int] NOT NULL,
	[MainInterID] [int] NOT NULL,
	[MainId] [tinyint] NULL,
	[SHIFT] [char](10) NULL,
	[makeline] [char](20) NULL,
	[PLANNO] [char](20) NULL,
	[Code] [char](20) NULL,
	[Name] [char](60) NULL,
	[Spec] [char](60) NULL,
	[quan] [int] NULL,
	[okquan] [int] NULL,
	[badquan] [int] NULL,
	[Note] [char](300) NULL,
	[TA001] [char](4) NULL,
	[TA002] [char](20) NULL,
	[BILLNAME] [char](10) NULL,
	[CREATDATE] [datetime] NULL,
	[blankflat] [char](20) NULL,
 CONSTRAINT [PK_MakeDayDetail] PRIMARY KEY CLUSTERED 
(
	[InterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MakeDayDetail1]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MakeDayDetail1](
	[InterID] [int] NOT NULL,
	[MainInterID] [int] NOT NULL,
	[MainId] [tinyint] NULL,
	[SHIFT] [char](10) NULL,
	[makeline] [char](20) NULL,
	[PLANNO] [char](20) NULL,
	[Code] [char](20) NULL,
	[Name] [char](60) NULL,
	[Spec] [char](60) NULL,
	[quan] [int] NULL,
	[okquan] [int] NULL,
	[Note] [char](300) NULL,
	[TA001] [char](3) NULL,
	[TA002] [char](20) NULL,
	[BILLNAME] [char](10) NULL,
	[CREATDATE] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[makemold]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[makemold](
	[interid] [int] NOT NULL,
	[dateid] [char](8) NOT NULL,
	[workshop] [char](10) NULL,
	[workorder] [char](10) NULL,
	[OKID] [tinyint] NULL,
	[CODE] [char](20) NOT NULL,
	[DRAWINGNUM] [char](20) NULL,
	[NAME] [char](60) NULL,
	[SPEC] [char](60) NULL,
	[worker] [char](10) NULL,
	[cotentdes] [char](100) NULL,
	[worktime] [numeric](6, 2) NULL,
	[price] [decimal](18, 2) NULL,
	[cash] [int] NULL,
	[mantime] [numeric](6, 2) NULL,
	[note] [char](100) NULL,
	[workposition] [char](10) NULL,
	[creatdate] [datetime] NOT NULL,
	[billname] [char](10) NULL,
	[ta001] [char](3) NULL,
	[ta002] [char](20) NULL,
	[ta009] [char](8) NULL,
	[ta010] [char](8) NULL,
	[outid] [int] NULL,
 CONSTRAINT [PK_makemold] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Makeplan]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Makeplan](
	[cDateId] [char](10) NOT NULL,
	[CreatDate] [datetime] NULL,
	[BillName] [char](10) NULL,
	[CheckID] [tinyint] NULL,
	[CheckName] [char](10) NULL,
	[CheckDate] [datetime] NULL,
	[modifydate] [datetime] NULL,
	[ordernum] [int] NULL,
	[zjnum] [int] NULL,
	[sjnum] [int] NULL,
	[note] [char](100) NULL,
	[StatusID] [char](10) NULL,
	[gs] [decimal](18, 2) NULL,
	[WorkShop] [char](3) NULL,
	[WorkShopName] [char](20) NULL,
	[INTERID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_Makeplan] PRIMARY KEY CLUSTERED 
(
	[INTERID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MakePlanDetail]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MakePlanDetail](
	[InterID] [int] NOT NULL,
	[DateID] [char](8) NOT NULL,
	[WorkShop] [char](20) NOT NULL,
	[WorkOrder] [char](20) NOT NULL,
	[CreatDate] [char](20) NULL,
	[BillName] [char](10) NULL,
	[Note] [varchar](max) NULL,
	[checkid] [tinyint] NULL,
	[checkname] [char](10) NULL,
	[checkdate] [datetime] NULL,
	[AddDes] [varchar](max) NULL,
	[getorder] [char](20) NULL,
 CONSTRAINT [PK_MakePlanDetail] PRIMARY KEY CLUSTERED 
(
	[InterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MakePlanDetail1]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MakePlanDetail1](
	[InterID] [int] NOT NULL,
	[DateID] [char](8) NOT NULL,
	[WorkShop] [char](20) NOT NULL,
	[WorkOrder] [char](20) NOT NULL,
	[CreatDate] [char](20) NULL,
	[BillName] [char](10) NULL,
	[Note] [varchar](max) NOT NULL,
	[checkid] [tinyint] NULL,
	[checkname] [char](10) NULL,
	[checkdate] [datetime] NULL,
	[AddDes] [varchar](max) NULL,
	[getorder] [char](20) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mathistory]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mathistory](
	[interid] [int] NOT NULL,
	[订单年月] [char](8) NULL,
	[配件类码] [char](6) NULL,
	[配件类别] [char](30) NULL,
	[配件代码] [char](20) NULL,
	[配件名称] [char](60) NULL,
	[配件规格] [char](60) NULL,
	[数量] [numeric](20, 0) NULL,
	[次数] [int] NULL,
	[客户数] [int] NULL,
	[吨位] [char](30) NULL,
	[重量] [numeric](18, 3) NULL,
	[体积] [decimal](18, 3) NULL,
	[最大] [int] NULL,
	[最小] [int] NULL,
	[平均] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mathistory1]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mathistory1](
	[sender] [char](15) NOT NULL,
	[receiver] [char](480) NULL,
	[dtime] [datetime] NULL,
	[interid] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[talkcontent] [text] NULL,
 CONSTRAINT [pk_interid] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[moldcard]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[moldcard](
	[interid] [int] IDENTITY(1,1) NOT NULL,
	[filenameid] [char](20) NULL,
	[workshopno] [char](20) NULL,
	[moldno] [char](10) NULL,
	[moldname] [char](30) NULL,
	[matname] [char](30) NULL,
	[workdept] [char](10) NULL,
	[equitment] [char](30) NULL,
	[workshop] [char](20) NULL,
	[diameter] [char](20) NULL,
	[cavities] [char](10) NULL,
	[weight] [numeric](18, 0) NULL,
	[reset] [char](20) NULL,
	[pulling] [char](20) NULL,
	[paintname] [char](20) NULL,
	[injection] [char](10) NULL,
	[overwhelming] [char](10) NULL,
	[radiomat] [tinyint] NULL,
	[fastover] [char](10) NULL,
	[addover] [char](10) NULL,
	[twovalve] [char](10) NULL,
	[addvalve] [char](10) NULL,
	[acqvalve] [char](10) NULL,
	[castingtemp] [char](10) NULL,
	[handlemat] [char](10) NULL,
	[castingover] [char](10) NULL,
	[ejection] [tinyint] NULL,
	[backoftop] [tinyint] NULL,
	[mold] [tinyint] NULL,
	[makedate] [datetime] NULL,
	[makeman] [char](10) NULL,
	[modifydate] [datetime] NULL,
	[modifyman] [char](10) NULL,
	[approvedate] [datetime] NULL,
	[approveman] [char](10) NULL,
	[creatdate] [datetime] NULL,
	[billname] [char](10) NULL,
	[checkid] [tinyint] NULL,
	[checkdate] [datetime] NULL,
	[checkman] [char](10) NULL,
	[quality] [char](4000) NULL,
	[moldmap] [varbinary](max) NULL,
	[quan] [tinyint] NULL,
 CONSTRAINT [PK_moldcard] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[molddetail]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[molddetail](
	[code] [char](20) NOT NULL,
	[name] [char](60) NOT NULL,
	[spec] [char](60) NULL,
	[codesize] [char](40) NULL,
	[quan] [int] NULL,
	[note] [char](1000) NULL,
	[codeattr] [char](20) NULL,
	[goodsattr] [char](20) NULL,
	[moldno] [char](20) NOT NULL,
	[interid] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[moldinfo]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[moldinfo](
	[moldno] [char](20) NOT NULL,
	[name] [char](40) NOT NULL,
	[spec] [char](40) NULL,
	[diameter] [char](40) NULL,
	[loosecore] [char](10) NULL,
	[priceton] [char](20) NULL,
	[productton] [char](20) NULL,
	[makedate] [datetime] NULL,
	[statusid] [char](10) NULL,
	[note] [char](1000) NULL,
	[recycle] [tinyint] NULL,
	[repalce] [tinyint] NULL,
	[creatdate] [datetime] NULL,
	[billname] [char](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofConParticipant]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofConParticipant](
	[conversationID] [bigint] NOT NULL,
	[joinedDate] [bigint] NOT NULL,
	[leftDate] [bigint] NULL,
	[bareJID] [nvarchar](255) NOT NULL,
	[jidResource] [nvarchar](255) NOT NULL,
	[nickname] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofConversation]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofConversation](
	[conversationID] [bigint] NOT NULL,
	[room] [nvarchar](1024) NULL,
	[isExternal] [tinyint] NOT NULL,
	[startDate] [bigint] NOT NULL,
	[lastActivity] [bigint] NOT NULL,
	[messageCount] [int] NOT NULL,
 CONSTRAINT [ofConversation_pk] PRIMARY KEY CLUSTERED 
(
	[conversationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofExtComponentConf]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofExtComponentConf](
	[subdomain] [nvarchar](255) NOT NULL,
	[wildcard] [int] NOT NULL,
	[secret] [nvarchar](255) NULL,
	[permission] [nvarchar](10) NOT NULL,
 CONSTRAINT [ofExtComponentConf_pk] PRIMARY KEY CLUSTERED 
(
	[subdomain] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofGatewayAvatars]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofGatewayAvatars](
	[jid] [nvarchar](255) NOT NULL,
	[imageData] [ntext] NOT NULL,
	[xmppHash] [nvarchar](255) NULL,
	[legacyIdentifier] [nvarchar](255) NULL,
	[createDate] [bigint] NOT NULL,
	[lastUpdate] [bigint] NULL,
	[imageType] [nvarchar](25) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofGatewayPseudoRoster]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofGatewayPseudoRoster](
	[registrationID] [bigint] NOT NULL,
	[username] [nvarchar](255) NOT NULL,
	[nickname] [nvarchar](255) NULL,
	[groups] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofGatewayRegistration]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofGatewayRegistration](
	[registrationID] [bigint] NOT NULL,
	[jid] [nvarchar](255) NOT NULL,
	[transportType] [nvarchar](15) NOT NULL,
	[username] [nvarchar](255) NOT NULL,
	[password] [nvarchar](255) NULL,
	[nickname] [nvarchar](255) NULL,
	[registrationDate] [bigint] NOT NULL,
	[lastLogin] [bigint] NULL,
 CONSTRAINT [ofGatewayRegistration_pk] PRIMARY KEY CLUSTERED 
(
	[registrationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofGatewayRestrictions]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofGatewayRestrictions](
	[transportType] [nvarchar](15) NOT NULL,
	[username] [nvarchar](255) NULL,
	[groupname] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofGatewayVCards]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofGatewayVCards](
	[jid] [nvarchar](255) NOT NULL,
	[value] [ntext] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofGroup]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofGroup](
	[groupName] [nvarchar](50) NOT NULL,
	[description] [nvarchar](255) NULL,
 CONSTRAINT [ofGroup_pk] PRIMARY KEY CLUSTERED 
(
	[groupName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofGroupProp]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofGroupProp](
	[groupName] [nvarchar](50) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[propValue] [nvarchar](2000) NOT NULL,
 CONSTRAINT [ofGroupProp_pk] PRIMARY KEY CLUSTERED 
(
	[groupName] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofGroupUser]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofGroupUser](
	[groupName] [nvarchar](50) NOT NULL,
	[username] [nvarchar](100) NOT NULL,
	[administrator] [int] NOT NULL,
 CONSTRAINT [ofGroupUser_pk] PRIMARY KEY CLUSTERED 
(
	[groupName] ASC,
	[username] ASC,
	[administrator] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofID]    Script Date: 2021/10/21 17:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofID](
	[idType] [int] NOT NULL,
	[id] [int] NOT NULL,
 CONSTRAINT [ofID_pk] PRIMARY KEY CLUSTERED 
(
	[idType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofMessageArchive]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofMessageArchive](
	[conversationID] [bigint] NOT NULL,
	[fromJID] [nvarchar](1024) NOT NULL,
	[toJID] [nvarchar](1024) NOT NULL,
	[sentDate] [bigint] NOT NULL,
	[body] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofmocta]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofmocta](
	[COMPANY] [char](10) NULL,
	[CREATOR] [char](10) NULL,
	[USR_GROUP] [char](10) NULL,
	[CREATE_DATE] [char](17) NULL,
	[MODIFIER] [char](10) NULL,
	[MODI_DATE] [char](17) NULL,
	[FLAG] [numeric](3, 0) NULL,
	[TA001] [char](4) NOT NULL,
	[TA002] [char](11) NOT NULL,
	[TA003] [char](8) NULL,
	[TA004] [char](8) NULL,
	[TA005] [char](4) NULL,
	[TA006] [char](20) NULL,
	[TA007] [char](4) NULL,
	[TA008] [char](4) NULL,
	[TA009] [char](8) NULL,
	[TA010] [char](8) NULL,
	[TA011] [char](1) NULL,
	[TA012] [char](8) NULL,
	[TA013] [char](1) NULL,
	[TA014] [char](8) NULL,
	[TA015] [numeric](15, 6) NULL,
	[TA016] [numeric](15, 6) NULL,
	[TA017] [numeric](15, 6) NULL,
	[TA018] [numeric](15, 6) NULL,
	[TA019] [char](6) NULL,
	[TA020] [char](10) NULL,
	[TA021] [char](10) NULL,
	[TA022] [numeric](17, 8) NULL,
	[TA023] [char](4) NULL,
	[TA024] [char](4) NULL,
	[TA025] [char](11) NULL,
	[TA026] [char](4) NULL,
	[TA027] [char](11) NULL,
	[TA028] [char](4) NULL,
	[TA029] [varchar](250) NULL,
	[TA030] [char](1) NULL,
	[TA031] [numeric](1, 0) NULL,
	[TA032] [char](10) NULL,
	[TA033] [char](20) NULL,
	[TA034] [varchar](60) NULL,
	[TA035] [varchar](60) NULL,
	[TA036] [char](1) NULL,
	[TA037] [char](1) NULL,
	[TA038] [char](1) NULL,
	[TA039] [char](1) NULL,
	[TA040] [char](8) NULL,
	[TA041] [char](10) NULL,
	[TA042] [char](4) NULL,
	[TA043] [numeric](10, 7) NULL,
	[TA044] [char](1) NULL,
	[TA045] [numeric](15, 6) NULL,
	[TA046] [numeric](15, 6) NULL,
	[TA047] [numeric](15, 6) NULL,
	[TA048] [char](4) NULL,
	[TA049] [char](1) NULL,
	[TA050] [varchar](100) NULL,
	[TA051] [varchar](100) NULL,
	[TA052] [varchar](100) NULL,
	[TA053] [varchar](100) NULL,
	[TA054] [numeric](1, 0) NULL,
	[TA055] [char](1) NULL,
	[TA056] [numeric](15, 6) NULL,
	[TA057] [char](20) NULL,
	[TA058] [varchar](80) NULL,
	[TA059] [char](1) NULL,
	[TA060] [numeric](15, 6) NULL,
	[TA061] [numeric](15, 6) NULL,
	[TA062] [numeric](1, 0) NULL,
	[TA063] [char](8) NULL,
	[TA064] [char](6) NULL,
	[TA065] [char](1) NULL,
	[TA066] [char](8) NULL,
	[TA067] [varchar](30) NULL,
	[TA068] [numeric](13, 2) NULL,
	[TA069] [numeric](13, 2) NULL,
	[TA070] [numeric](13, 2) NULL,
	[TA071] [char](6) NULL,
	[TA072] [numeric](5, 4) NULL,
	[TA073] [char](15) NULL,
	[TA074] [char](4) NULL,
	[TA200] [numeric](11, 3) NULL,
	[UDF01] [varchar](20) NULL,
	[UDF02] [varchar](20) NULL,
	[UDF03] [varchar](20) NULL,
	[UDF04] [varchar](80) NULL,
	[UDF05] [varchar](20) NULL,
	[UDF06] [varchar](20) NULL,
	[UDF51] [numeric](15, 6) NULL,
	[UDF52] [numeric](15, 6) NULL,
	[UDF53] [numeric](15, 6) NULL,
	[UDF54] [numeric](15, 6) NULL,
	[UDF55] [numeric](15, 6) NULL,
	[UDF56] [numeric](15, 6) NULL,
	[BFID] [tinyint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofMucAffiliation]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofMucAffiliation](
	[roomID] [int] NOT NULL,
	[jid] [nvarchar](424) NOT NULL,
	[affiliation] [int] NOT NULL,
 CONSTRAINT [ofMucAffiliation_pk] PRIMARY KEY CLUSTERED 
(
	[roomID] ASC,
	[jid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofMucConversationLog]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofMucConversationLog](
	[roomID] [int] NOT NULL,
	[sender] [nvarchar](1024) NOT NULL,
	[nickname] [nvarchar](255) NULL,
	[logTime] [char](15) NOT NULL,
	[subject] [nvarchar](255) NULL,
	[body] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofMucRoom]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofMucRoom](
	[serviceID] [int] NOT NULL,
	[roomID] [int] NOT NULL,
	[creationDate] [char](15) NOT NULL,
	[modificationDate] [char](15) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[naturalName] [nvarchar](255) NOT NULL,
	[description] [nvarchar](255) NULL,
	[lockedDate] [char](15) NOT NULL,
	[emptyDate] [char](15) NULL,
	[canChangeSubject] [int] NOT NULL,
	[maxUsers] [int] NOT NULL,
	[publicRoom] [int] NOT NULL,
	[moderated] [int] NOT NULL,
	[membersOnly] [int] NOT NULL,
	[canInvite] [int] NOT NULL,
	[roomPassword] [nvarchar](50) NULL,
	[canDiscoverJID] [int] NOT NULL,
	[logEnabled] [int] NOT NULL,
	[subject] [nvarchar](100) NULL,
	[rolesToBroadcast] [int] NOT NULL,
	[useReservedNick] [int] NOT NULL,
	[canChangeNick] [int] NOT NULL,
	[canRegister] [int] NOT NULL,
 CONSTRAINT [ofMucRoom_pk] PRIMARY KEY CLUSTERED 
(
	[serviceID] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofMucRoomProp]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofMucRoomProp](
	[roomID] [int] NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[propValue] [nvarchar](2000) NOT NULL,
 CONSTRAINT [ofMucRoomProp_pk] PRIMARY KEY CLUSTERED 
(
	[roomID] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofMucService]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofMucService](
	[serviceID] [int] NOT NULL,
	[subdomain] [nvarchar](255) NOT NULL,
	[description] [nvarchar](255) NULL,
	[isHidden] [int] NOT NULL,
 CONSTRAINT [ofMucService_pk] PRIMARY KEY CLUSTERED 
(
	[subdomain] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofMucServiceProp]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofMucServiceProp](
	[serviceID] [int] NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[propValue] [nvarchar](2000) NOT NULL,
 CONSTRAINT [ofMucServiceProp_pk] PRIMARY KEY CLUSTERED 
(
	[serviceID] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofOffline]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofOffline](
	[username] [nvarchar](64) NOT NULL,
	[messageID] [int] NOT NULL,
	[creationDate] [char](15) NOT NULL,
	[messageSize] [int] NOT NULL,
	[stanza] [ntext] NOT NULL,
 CONSTRAINT [ofOffline_pk] PRIMARY KEY CLUSTERED 
(
	[username] ASC,
	[messageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofPresence]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofPresence](
	[username] [nvarchar](64) NOT NULL,
	[offlinePresence] [ntext] NULL,
	[offlineDate] [char](15) NOT NULL,
 CONSTRAINT [ofPresence_pk] PRIMARY KEY CLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofPrivacyList]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofPrivacyList](
	[username] [nvarchar](64) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[isDefault] [int] NOT NULL,
	[list] [ntext] NOT NULL,
 CONSTRAINT [ofPrivacyList_pk] PRIMARY KEY CLUSTERED 
(
	[username] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofPrivate]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofPrivate](
	[username] [nvarchar](64) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[namespace] [nvarchar](200) NOT NULL,
	[privateData] [ntext] NOT NULL,
 CONSTRAINT [ofPrivate_pk] PRIMARY KEY CLUSTERED 
(
	[username] ASC,
	[name] ASC,
	[namespace] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofProperty]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofProperty](
	[name] [nvarchar](100) NOT NULL,
	[propValue] [ntext] NOT NULL,
 CONSTRAINT [ofProperty_pk] PRIMARY KEY CLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofPubsubAffiliation]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofPubsubAffiliation](
	[serviceID] [nvarchar](100) NOT NULL,
	[nodeID] [nvarchar](100) NOT NULL,
	[jid] [nvarchar](250) NOT NULL,
	[affiliation] [nvarchar](10) NOT NULL,
 CONSTRAINT [ofPubsubAffiliation_pk] PRIMARY KEY CLUSTERED 
(
	[serviceID] ASC,
	[nodeID] ASC,
	[jid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofPubsubDefaultConf]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofPubsubDefaultConf](
	[serviceID] [nvarchar](100) NOT NULL,
	[leaf] [int] NOT NULL,
	[deliverPayloads] [int] NOT NULL,
	[maxPayloadSize] [int] NOT NULL,
	[persistItems] [int] NOT NULL,
	[maxItems] [int] NOT NULL,
	[notifyConfigChanges] [int] NOT NULL,
	[notifyDelete] [int] NOT NULL,
	[notifyRetract] [int] NOT NULL,
	[presenceBased] [int] NOT NULL,
	[sendItemSubscribe] [int] NOT NULL,
	[publisherModel] [nvarchar](15) NOT NULL,
	[subscriptionEnabled] [int] NOT NULL,
	[accessModel] [nvarchar](10) NOT NULL,
	[language] [nvarchar](255) NULL,
	[replyPolicy] [nvarchar](15) NULL,
	[associationPolicy] [nvarchar](15) NOT NULL,
	[maxLeafNodes] [int] NOT NULL,
 CONSTRAINT [ofPubsubDefaultConf_pk] PRIMARY KEY CLUSTERED 
(
	[serviceID] ASC,
	[leaf] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofPubsubItem]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofPubsubItem](
	[serviceID] [nvarchar](100) NOT NULL,
	[nodeID] [nvarchar](100) NOT NULL,
	[id] [nvarchar](100) NOT NULL,
	[jid] [nvarchar](1024) NOT NULL,
	[creationDate] [char](15) NOT NULL,
	[payload] [ntext] NULL,
 CONSTRAINT [ofPubsubItem_pk] PRIMARY KEY CLUSTERED 
(
	[serviceID] ASC,
	[nodeID] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofPubsubNode]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofPubsubNode](
	[serviceID] [nvarchar](100) NOT NULL,
	[nodeID] [nvarchar](100) NOT NULL,
	[leaf] [int] NOT NULL,
	[creationDate] [char](15) NOT NULL,
	[modificationDate] [char](15) NOT NULL,
	[parent] [nvarchar](100) NULL,
	[deliverPayloads] [int] NOT NULL,
	[maxPayloadSize] [int] NULL,
	[persistItems] [int] NULL,
	[maxItems] [int] NULL,
	[notifyConfigChanges] [int] NOT NULL,
	[notifyDelete] [int] NOT NULL,
	[notifyRetract] [int] NOT NULL,
	[presenceBased] [int] NOT NULL,
	[sendItemSubscribe] [int] NOT NULL,
	[publisherModel] [nvarchar](15) NOT NULL,
	[subscriptionEnabled] [int] NOT NULL,
	[configSubscription] [int] NOT NULL,
	[accessModel] [nvarchar](10) NOT NULL,
	[payloadType] [nvarchar](100) NULL,
	[bodyXSLT] [nvarchar](100) NULL,
	[dataformXSLT] [nvarchar](100) NULL,
	[creator] [nvarchar](255) NOT NULL,
	[description] [nvarchar](255) NULL,
	[language] [nvarchar](255) NULL,
	[name] [nvarchar](50) NULL,
	[replyPolicy] [nvarchar](15) NULL,
	[associationPolicy] [nvarchar](15) NULL,
	[maxLeafNodes] [int] NULL,
 CONSTRAINT [ofPubsubNode_pk] PRIMARY KEY CLUSTERED 
(
	[serviceID] ASC,
	[nodeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofPubsubNodeGroups]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofPubsubNodeGroups](
	[serviceID] [nvarchar](100) NOT NULL,
	[nodeID] [nvarchar](100) NOT NULL,
	[rosterGroup] [nvarchar](100) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofPubsubNodeJIDs]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofPubsubNodeJIDs](
	[serviceID] [nvarchar](100) NOT NULL,
	[nodeID] [nvarchar](100) NOT NULL,
	[jid] [nvarchar](250) NOT NULL,
	[associationType] [nvarchar](20) NOT NULL,
 CONSTRAINT [ofPubsubNodeJIDs_pk] PRIMARY KEY CLUSTERED 
(
	[serviceID] ASC,
	[nodeID] ASC,
	[jid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofPubsubSubscription]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofPubsubSubscription](
	[serviceID] [nvarchar](100) NOT NULL,
	[nodeID] [nvarchar](100) NOT NULL,
	[id] [nvarchar](100) NOT NULL,
	[jid] [nvarchar](1024) NOT NULL,
	[owner] [nvarchar](1024) NOT NULL,
	[state] [nvarchar](15) NOT NULL,
	[deliver] [int] NOT NULL,
	[digest] [int] NOT NULL,
	[digest_frequency] [int] NOT NULL,
	[expire] [char](15) NULL,
	[includeBody] [int] NOT NULL,
	[showValues] [nvarchar](30) NOT NULL,
	[subscriptionType] [nvarchar](10) NOT NULL,
	[subscriptionDepth] [int] NOT NULL,
	[keyword] [nvarchar](200) NULL,
 CONSTRAINT [ofPubsubSubscription_pk] PRIMARY KEY CLUSTERED 
(
	[serviceID] ASC,
	[nodeID] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofRemoteServerConf]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofRemoteServerConf](
	[xmppDomain] [nvarchar](255) NOT NULL,
	[remotePort] [int] NULL,
	[permission] [nvarchar](10) NOT NULL,
 CONSTRAINT [ofRemoteServerConf_pk] PRIMARY KEY CLUSTERED 
(
	[xmppDomain] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofRoster]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofRoster](
	[rosterID] [int] NOT NULL,
	[username] [nvarchar](64) NOT NULL,
	[jid] [nvarchar](1024) NOT NULL,
	[sub] [int] NOT NULL,
	[ask] [int] NOT NULL,
	[recv] [int] NOT NULL,
	[nick] [nvarchar](255) NULL,
 CONSTRAINT [ofRoster_pk] PRIMARY KEY CLUSTERED 
(
	[rosterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofSASLAuthorized]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofSASLAuthorized](
	[username] [nvarchar](64) NOT NULL,
	[principal] [nvarchar](2000) NOT NULL,
 CONSTRAINT [ofSASLAuthorized_pk] PRIMARY KEY CLUSTERED 
(
	[username] ASC,
	[principal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofSecurityAuditLog]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofSecurityAuditLog](
	[msgID] [int] NOT NULL,
	[username] [nvarchar](64) NOT NULL,
	[entryStamp] [bigint] NOT NULL,
	[summary] [nvarchar](255) NOT NULL,
	[node] [nvarchar](255) NOT NULL,
	[details] [ntext] NULL,
 CONSTRAINT [ofSecurityAuditLog_pk] PRIMARY KEY CLUSTERED 
(
	[msgID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofSipPhoneLog]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofSipPhoneLog](
	[username] [nvarchar](255) NULL,
	[addressFrom] [nvarchar](255) NULL,
	[addressTo] [nvarchar](255) NULL,
	[datetime] [bigint] NULL,
	[duration] [int] NULL,
	[callType] [nvarchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofSipUser]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofSipUser](
	[username] [nvarchar](255) NOT NULL,
	[sipUsername] [nvarchar](255) NULL,
	[sipAuthuser] [nvarchar](255) NULL,
	[sipDisplayname] [nvarchar](255) NULL,
	[sipPassword] [nvarchar](255) NULL,
	[sipServer] [nvarchar](255) NULL,
	[stunServer] [nvarchar](255) NULL,
	[stunPort] [nvarchar](255) NULL,
	[useStun] [int] NULL,
	[voicemail] [nvarchar](255) NULL,
	[enabled] [int] NULL,
	[status] [nvarchar](255) NULL,
	[outboundproxy] [varchar](255) NULL,
	[promptCredentials] [int] NULL,
 CONSTRAINT [sipUser_pk] PRIMARY KEY CLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofUser]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofUser](
	[username] [nvarchar](64) NOT NULL,
	[plainPassword] [nvarchar](32) NULL,
	[encryptedPassword] [nvarchar](255) NULL,
	[name] [nvarchar](100) NULL,
	[email] [varchar](100) NULL,
	[creationDate] [char](15) NOT NULL,
	[modificationDate] [char](15) NOT NULL,
 CONSTRAINT [ofUser_pk] PRIMARY KEY CLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofUserFlag]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofUserFlag](
	[username] [nvarchar](64) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[startTime] [char](15) NULL,
	[endTime] [char](15) NULL,
 CONSTRAINT [ofUserFlag_pk] PRIMARY KEY CLUSTERED 
(
	[username] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofUserProp]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofUserProp](
	[username] [nvarchar](64) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[propValue] [nvarchar](2000) NOT NULL,
 CONSTRAINT [ofUserProp_pk] PRIMARY KEY CLUSTERED 
(
	[username] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ofVCard]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ofVCard](
	[username] [nvarchar](64) NOT NULL,
	[vcard] [ntext] NOT NULL,
 CONSTRAINT [ofVCard_pk] PRIMARY KEY CLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[online]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[online](
	[macid] [char](30) NOT NULL,
	[userid] [char](20) NOT NULL,
	[creatdate] [datetime] NULL,
	[lastdate] [datetime] NULL,
	[rtxuser] [char](10) NULL,
	[rtxdept] [char](30) NULL,
	[sock] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PassWord]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PassWord](
	[username] [char](22) NULL,
	[ncolour] [int] NULL,
	[dechanged] [datetime] NULL,
	[dcreated] [datetime] NULL,
	[dept] [char](20) NULL,
	[email] [char](42) NULL,
	[password] [char](20) NULL,
	[name] [char](10) NULL,
	[isactive] [tinyint] NULL,
	[mobile] [char](20) NULL,
	[phone] [char](150) NULL,
	[appo] [char](10) NULL,
	[syncid] [char](10) NULL,
	[teamid] [char](10) NULL,
	[title] [char](10) NULL,
	[usercode] [char](10) NULL,
	[interid] [int] NOT NULL,
	[usersynctype] [char](10) NULL,
	[usertype] [char](10) NULL,
	[rights] [char](30) NULL,
	[CropId] [char](20) NULL,
	[note] [char](240) NULL,
	[userip] [char](20) NULL,
	[userport] [int] NULL,
	[online] [tinyint] NULL,
	[friendlist] [char](1000) NULL,
	[facepic] [varbinary](max) NULL,
	[md5] [char](80) NULL,
	[mobilelogin] [char](200) NULL,
 CONSTRAINT [PK_PassWord_1] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PC曾用名]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PC曾用名](
	[公司名] [varchar](1000) NULL,
	[曾用名] [varchar](1000) NULL,
	[注册号] [varchar](100) NULL,
	[组织机构代码] [varchar](50) NULL,
	[URL] [varchar](100) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[phoneDevice]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[phoneDevice](
	[deviceID] [int] NOT NULL,
	[device] [nvarchar](255) NOT NULL,
	[extension] [nvarchar](255) NOT NULL,
	[callerID] [nvarchar](255) NULL,
	[isPrimary] [int] NOT NULL,
	[userID] [bigint] NULL,
	[serverID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[deviceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[phoneServer]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[phoneServer](
	[serverID] [int] NOT NULL,
	[serverName] [nvarchar](255) NOT NULL,
	[hostname] [nvarchar](255) NOT NULL,
	[port] [int] NOT NULL,
	[username] [nvarchar](255) NOT NULL,
	[password] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[serverID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[serverName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[phoneUser]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[phoneUser](
	[userID] [int] NOT NULL,
	[username] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[userID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pi]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pi](
	[interid] [int] NOT NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL,
	[currency] [char](10) NULL,
	[statusid] [char](10) NULL,
	[customid] [char](10) NULL,
	[dateid] [char](10) NULL,
	[mainnote] [char](500) NULL,
	[paycon] [char](10) NULL,
	[effectivedate] [char](10) NULL,
	[incoterm] [char](10) NULL,
	[loading] [char](50) NULL,
	[discharge] [char](50) NULL,
	[enote] [char](500) NULL,
	[salescode] [char](10) NULL,
	[rate] [numeric](18, 4) NULL,
	[classid] [char](4) NULL,
	[toway] [char](1) NULL,
	[chkid] [tinyint] NULL,
	[chkname] [char](10) NULL,
	[chkdate] [datetime] NULL,
	[tex] [char](1) NULL,
	[texrate] [numeric](18, 4) NULL,
	[settlement] [char](1) NULL,
	[payman] [char](30) NULL,
	[getbank] [char](40) NULL,
	[pricelistinterid] [int] NULL,
	[target] [char](60) NULL,
	[po] [char](30) NULL,
	[texfee] [numeric](18, 4) NULL,
	[cash] [numeric](18, 4) NULL,
	[boxnum] [int] NULL,
	[pichkinterid] [int] NULL,
	[seadate] [char](10) NULL,
	[sea1] [tinyint] NULL,
	[sea2] [tinyint] NULL,
	[seafee] [numeric](18, 4) NULL,
	[insurance] [numeric](18, 4) NULL,
	[insurclass] [char](30) NULL,
	[insurcorp] [char](30) NULL,
	[contractnum] [tinyint] NULL,
	[bt] [char](60) NULL,
	[sms] [char](60) NULL,
	[ch] [char](60) NULL,
	[standard] [char](10) NULL,
	[dept] [char](10) NULL,
	[chknote] [char](300) NULL,
	[chknote1] [char](300) NULL,
	[chknote2] [char](300) NULL,
	[chknote3] [char](300) NULL,
	[chknote4] [char](300) NULL,
	[chkid1] [tinyint] NULL,
	[chkid2] [tinyint] NULL,
	[chkid3] [tinyint] NULL,
	[chkid4] [tinyint] NULL,
	[chkdate1] [datetime] NULL,
	[chkdate2] [datetime] NULL,
	[chkdate3] [datetime] NULL,
	[chkdate4] [datetime] NULL,
	[chkname1] [char](10) NULL,
	[chkname2] [char](10) NULL,
	[chkname3] [char](10) NULL,
	[chkname4] [char](10) NULL,
	[sendaddr] [char](100) NULL,
	[repi] [datetime] NULL,
	[requreview] [datetime] NULL,
	[requid] [tinyint] NULL,
	[chknum] [char](30) NULL,
	[packageid] [tinyint] NULL,
	[packagedate] [datetime] NULL,
	[customdate] [datetime] NULL,
	[custompi] [datetime] NULL,
	[orderdate] [datetime] NULL,
	[chgdate] [datetime] NULL,
	[keyid] [int] IDENTITY(1,1) NOT NULL,
	[rose] [tinyint] NULL,
 CONSTRAINT [PK_pi] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[piapprove]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[piapprove](
	[interid] [int] NOT NULL,
	[keyinterid] [int] NULL,
	[keyorder] [tinyint] NULL,
	[chkname] [char](10) NULL,
	[chkdate] [datetime] NULL,
	[note] [char](250) NULL,
	[chkid] [tinyint] NULL,
	[ver] [tinyint] NULL,
	[dept] [char](10) NULL,
	[detailinterid] [int] NULL,
	[action] [char](10) NULL,
 CONSTRAINT [PK_piapprove] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pichange]    Script Date: 2021/10/21 17:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pichange](
	[interid] [int] NOT NULL,
	[attr] [char](40) NULL,
	[chgcontent] [char](500) NULL,
	[pic] [varbinary](max) NULL,
	[filename] [char](40) NULL,
	[maininterid] [int] NULL,
	[cancle] [tinyint] NULL,
 CONSTRAINT [PK_pichange] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pichangeapprove]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pichangeapprove](
	[interid] [int] NOT NULL,
	[keyinterid] [int] NULL,
	[keyorder] [tinyint] NULL,
	[chkname] [char](10) NULL,
	[chkdate] [datetime] NULL,
	[note] [char](100) NULL,
	[chkid] [tinyint] NULL,
	[ver] [tinyint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pichangemain]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pichangemain](
	[interid] [int] NOT NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL,
	[ver] [tinyint] NULL,
	[chkname] [char](10) NULL,
	[chkdate] [datetime] NULL,
	[chkid] [tinyint] NULL,
	[note] [char](250) NULL,
	[piinterid] [int] NULL,
	[dateid] [char](10) NULL,
	[requid] [tinyint] NULL,
	[requreview] [datetime] NULL,
	[chkname1] [char](10) NULL,
	[chkname2] [char](10) NULL,
	[chkname3] [char](10) NULL,
	[chkname4] [char](10) NULL,
	[chkdate1] [datetime] NULL,
	[chkdate2] [datetime] NULL,
	[chkdate3] [datetime] NULL,
	[chkdate4] [datetime] NULL,
	[chkid1] [tinyint] NULL,
	[chkid2] [tinyint] NULL,
	[chkid3] [tinyint] NULL,
	[chkid4] [tinyint] NULL,
	[sendto] [char](100) NULL,
	[chknote1] [char](100) NULL,
	[chknote2] [char](100) NULL,
	[chknote3] [char](100) NULL,
	[chknote4] [char](100) NULL,
	[chknote] [char](100) NULL,
 CONSTRAINT [PK_pichangemain] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pidetail]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pidetail](
	[interid] [int] NOT NULL,
	[maininterid] [int] NOT NULL,
	[code] [char](20) NULL,
	[attr] [char](20) NULL,
	[customcode] [char](20) NULL,
	[name] [char](60) NULL,
	[spec] [char](60) NULL,
	[quan] [int] NULL,
	[profit] [int] NULL,
	[price] [numeric](18, 2) NULL,
	[cash] [numeric](18, 2) NULL,
	[note] [varchar](500) NULL,
	[stprice] [numeric](18, 2) NULL,
	[lastdate] [char](10) NULL,
	[lastcurrency] [char](10) NULL,
	[lastprice] [numeric](18, 2) NULL,
	[lastquan] [int] NULL,
	[lastcash] [numeric](18, 2) NULL,
	[costdate] [char](10) NULL,
	[lastcost] [numeric](18, 2) NULL,
	[gw] [numeric](18, 2) NULL,
	[nw] [numeric](18, 2) NULL,
	[volume] [numeric](18, 2) NULL,
	[defarate] [char](10) NULL,
	[lastgp] [numeric](18, 2) NULL,
	[orderid] [char](25) NULL,
	[unitcost] [numeric](18, 2) NULL,
	[unitprice] [numeric](18, 2) NULL,
	[shape] [char](20) NULL,
	[lightsource] [char](20) NULL,
	[bulb] [char](20) NULL,
	[iprating] [char](60) NULL,
	[unitcode] [char](20) NULL,
	[unitname] [char](60) NULL,
	[unitspec] [char](60) NULL,
	[unitbarcode] [char](20) NULL,
	[smscode] [char](20) NULL,
	[smsname] [char](60) NULL,
	[smsspec] [char](60) NULL,
	[outerbarcode] [char](20) NULL,
	[outercode] [char](20) NULL,
	[outername] [char](60) NULL,
	[outerspec] [char](60) NULL,
	[innerbarcode] [char](20) NULL,
	[smsbarcode] [char](20) NULL,
	[spkg] [numeric](18, 2) NULL,
	[spw] [numeric](18, 2) NULL,
	[spd] [numeric](18, 2) NULL,
	[sph] [numeric](18, 2) NULL,
	[spcmb] [numeric](18, 2) NULL,
	[mcpcs] [numeric](18, 0) NULL,
	[mckgs] [numeric](18, 2) NULL,
	[mcw] [numeric](18, 2) NULL,
	[mcd] [numeric](18, 2) NULL,
	[mch] [numeric](18, 2) NULL,
	[mccmb] [numeric](18, 2) NULL,
	[creatdate] [datetime] NULL,
	[billname] [char](10) NULL,
	[rate] [decimal](18, 2) NULL,
	[matcost] [decimal](18, 2) NULL,
	[pictid] [int] NULL,
	[productname] [char](60) NULL,
	[itemno] [char](20) NULL,
	[descripe] [char](300) NULL,
	[material] [char](60) NULL,
	[approval] [char](60) NULL,
	[moq] [numeric](18, 2) NULL,
	[qty20fcl] [numeric](18, 2) NULL,
	[qty40fcl] [numeric](18, 2) NULL,
	[qty40h] [numeric](18, 2) NULL,
	[size] [char](120) NULL,
	[codeclass] [char](60) NULL,
	[saleclass] [char](40) NULL,
	[package] [char](60) NULL,
	[unitrequ] [char](60) NULL,
	[innerquan] [int] NULL,
	[supply] [char](40) NULL,
	[codeseries] [char](40) NULL,
	[codecolor] [char](40) NULL,
	[oldid] [tinyint] NULL,
	[dateid] [char](10) NULL,
	[lastbb] [numeric](18, 2) NULL,
	[nbkgs] [numeric](18, 2) NULL,
	[nbw] [numeric](18, 2) NULL,
	[nbd] [numeric](18, 2) NULL,
	[nbh] [numeric](18, 2) NULL,
	[nbcmb] [numeric](18, 2) NULL,
	[priceinterid] [int] NULL,
	[edate] [char](10) NULL,
	[pic] [varbinary](max) NULL,
	[warehouse] [char](10) NULL,
	[boxfrom] [int] NULL,
	[boxto] [int] NULL,
	[boxok] [tinyint] NULL,
	[tp] [tinyint] NULL,
	[tpnote] [char](200) NULL,
	[tpquan] [int] NULL,
	[tppcs] [int] NULL,
	[boxnum] [int] NULL,
	[supplyid] [char](20) NULL,
	[tpw] [numeric](18, 2) NULL,
	[tpd] [numeric](18, 2) NULL,
	[tph] [numeric](18, 2) NULL,
	[tpcmb] [numeric](18, 2) NULL,
	[tpkg] [numeric](18, 2) NULL,
	[chksms] [tinyint] NULL,
	[chkct] [tinyint] NULL,
	[innercode] [char](20) NULL,
	[innername] [char](60) NULL,
	[innerspec] [char](60) NULL,
	[color] [char](30) NULL,
	[keyid] [int] IDENTITY(1,1) NOT NULL,
	[chgdate] [datetime] NULL,
 CONSTRAINT [PK_pidetail] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[practicereport]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[practicereport](
	[timefrom] [char](8) NOT NULL,
	[timeto] [char](8) NOT NULL,
	[trainee] [char](10) NOT NULL,
	[dept] [char](20) NOT NULL,
	[contents] [char](50) NOT NULL,
	[note] [char](50) NULL,
	[keywordid] [int] NOT NULL,
 CONSTRAINT [PK_practicereport] PRIMARY KEY CLUSTERED 
(
	[keywordid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pricelist]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pricelist](
	[interid] [int] NOT NULL,
	[billname] [char](10) NULL,
	[country] [char](10) NULL,
	[countryid] [char](10) NULL,
	[creatdate] [datetime] NULL,
	[currency] [char](10) NULL,
	[customid] [char](10) NULL,
	[customname] [char](30) NULL,
	[dateid] [char](10) NULL,
	[lastorder] [char](10) NULL,
	[local] [char](10) NULL,
	[mainnote] [char](500) NULL,
	[paycode] [char](10) NULL,
	[paycon] [char](30) NULL,
	[rate] [decimal](18, 5) NULL,
	[sales] [char](10) NULL,
	[nowgp] [decimal](18, 2) NULL,
	[nowyb] [decimal](18, 2) NULL,
	[nowbb] [decimal](18, 2) NULL,
	[effectivedate] [char](10) NULL,
	[incoterm] [char](10) NULL,
	[loading] [char](10) NULL,
	[discharge] [char](30) NULL,
	[standardgpmin] [decimal](18, 2) NULL,
	[customgpmin] [decimal](18, 2) NULL,
	[lastgpmin] [decimal](18, 2) NULL,
	[billcode] [char](10) NULL,
	[salescode] [char](10) NULL,
	[salesname] [char](10) NULL,
 CONSTRAINT [PK_pricelist] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pricelistdetail]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pricelistdetail](
	[interid] [int] NOT NULL,
	[maininterid] [int] NOT NULL,
	[code] [char](20) NULL,
	[customcode] [char](20) NULL,
	[name] [char](60) NULL,
	[spec] [char](60) NULL,
	[quan] [int] NULL,
	[profit] [int] NULL,
	[price] [numeric](18, 2) NULL,
	[cash] [numeric](18, 2) NULL,
	[note] [varchar](500) NULL,
	[stprice] [numeric](18, 2) NULL,
	[lastdate] [char](10) NULL,
	[lastcurrency] [char](10) NULL,
	[lastprice] [numeric](18, 2) NULL,
	[lastquan] [int] NULL,
	[lastcash] [numeric](18, 2) NULL,
	[costdate] [char](10) NULL,
	[lastcost] [numeric](18, 2) NULL,
	[gw] [numeric](18, 2) NULL,
	[nw] [numeric](18, 2) NULL,
	[volume] [numeric](18, 2) NULL,
	[defarate] [char](10) NULL,
	[lastgp] [numeric](18, 2) NULL,
	[orderid] [char](20) NULL,
	[unitcost] [numeric](18, 2) NULL,
	[unitprice] [numeric](18, 2) NULL,
	[shape] [char](20) NULL,
	[lightsource] [char](20) NULL,
	[bulb] [char](20) NULL,
	[iprating] [char](60) NULL,
	[unitcode] [char](20) NULL,
	[unitname] [char](60) NULL,
	[unitspec] [char](60) NULL,
	[unitbarcode] [char](20) NULL,
	[smscode] [char](20) NULL,
	[smsname] [char](60) NULL,
	[smsspec] [char](60) NULL,
	[outerbarcode] [char](20) NULL,
	[outercode] [char](20) NULL,
	[outername] [char](60) NULL,
	[outerspec] [char](60) NULL,
	[innerbarcode] [char](20) NULL,
	[smsbarcode] [char](20) NULL,
	[spkg] [numeric](18, 2) NULL,
	[spw] [numeric](18, 2) NULL,
	[spd] [numeric](18, 2) NULL,
	[sph] [numeric](18, 2) NULL,
	[spcmb] [numeric](18, 2) NULL,
	[mcpcs] [numeric](18, 2) NULL,
	[mckgs] [numeric](18, 2) NULL,
	[mcw] [numeric](18, 2) NULL,
	[mcd] [numeric](18, 2) NULL,
	[mch] [numeric](18, 2) NULL,
	[mccmb] [numeric](18, 2) NULL,
 CONSTRAINT [PK_pricelistdetail] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[printcaption]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[printcaption](
	[classid] [char](40) NULL,
	[name] [char](30) NULL,
	[defaname] [char](30) NULL,
	[tableid] [int] NULL,
	[useid] [int] NULL,
	[interid] [int] NOT NULL,
	[frx] [varbinary](max) NULL,
	[frt] [varbinary](max) NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL,
 CONSTRAINT [PK_printcaption] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[printcaption1]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[printcaption1](
	[classid] [char](40) NULL,
	[name] [char](30) NULL,
	[defaname] [char](30) NULL,
	[tableid] [int] NULL,
	[useid] [int] NULL,
	[interid] [int] NOT NULL,
	[frx] [varbinary](max) NULL,
	[frt] [varbinary](max) NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[printcaption2]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[printcaption2](
	[classid] [char](40) NULL,
	[name] [char](30) NULL,
	[defaname] [char](30) NULL,
	[tableid] [int] NULL,
	[useid] [int] NULL,
	[interid] [int] NOT NULL,
	[frx] [varbinary](max) NULL,
	[frt] [varbinary](max) NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[printcaption3]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[printcaption3](
	[classid] [char](40) NULL,
	[name] [char](30) NULL,
	[defaname] [char](30) NULL,
	[tableid] [int] NULL,
	[useid] [int] NULL,
	[interid] [int] NOT NULL,
	[frx] [varbinary](max) NULL,
	[frt] [varbinary](max) NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[printcaption4]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[printcaption4](
	[classid] [char](40) NULL,
	[name] [char](30) NULL,
	[defaname] [char](30) NULL,
	[tableid] [int] NULL,
	[useid] [int] NULL,
	[interid] [int] NOT NULL,
	[frx] [varbinary](max) NULL,
	[frt] [varbinary](max) NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[printcaption5]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[printcaption5](
	[classid] [char](40) NULL,
	[name] [char](30) NULL,
	[defaname] [char](30) NULL,
	[tableid] [int] NULL,
	[useid] [int] NULL,
	[interid] [int] NOT NULL,
	[frx] [varbinary](max) NULL,
	[frt] [varbinary](max) NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[printcaption6]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[printcaption6](
	[classid] [char](40) NULL,
	[name] [char](30) NULL,
	[defaname] [char](30) NULL,
	[tableid] [int] NULL,
	[useid] [int] NULL,
	[interid] [int] NOT NULL,
	[frx] [varbinary](max) NULL,
	[frt] [varbinary](max) NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[printcaption7]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[printcaption7](
	[classid] [char](40) NULL,
	[name] [char](30) NULL,
	[defaname] [char](30) NULL,
	[tableid] [int] NULL,
	[useid] [int] NULL,
	[interid] [int] NOT NULL,
	[frx] [varbinary](max) NULL,
	[frt] [varbinary](max) NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PURTC]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PURTC](
	[COMPANY] [char](10) NULL,
	[CREATOR] [char](10) NULL,
	[USR_GROUP] [char](10) NULL,
	[CREATE_DATE] [char](17) NULL,
	[MODIFIER] [char](10) NULL,
	[MODI_DATE] [char](17) NULL,
	[FLAG] [numeric](3, 0) NULL,
	[TC001] [char](4) NOT NULL,
	[TC002] [char](11) NOT NULL,
	[TC003] [char](8) NULL,
	[TC004] [char](10) NULL,
	[TC005] [char](4) NULL,
	[TC006] [numeric](10, 7) NULL,
	[TC007] [char](16) NULL,
	[TC008] [char](16) NULL,
	[TC009] [varchar](255) NULL,
	[TC010] [char](6) NULL,
	[TC011] [char](10) NULL,
	[TC012] [char](1) NULL,
	[TC013] [numeric](1, 0) NULL,
	[TC014] [char](1) NULL,
	[TC015] [char](8) NULL,
	[TC016] [char](20) NULL,
	[TC017] [char](20) NULL,
	[TC018] [char](1) NULL,
	[TC019] [numeric](16, 2) NULL,
	[TC020] [numeric](16, 2) NULL,
	[TC021] [char](72) NULL,
	[TC022] [char](72) NULL,
	[TC023] [numeric](15, 6) NULL,
	[TC024] [char](8) NULL,
	[TC025] [char](10) NULL,
	[TC026] [numeric](5, 4) NULL,
	[TC027] [char](6) NULL,
	[TC028] [numeric](5, 4) NULL,
	[TC029] [numeric](15, 6) NULL,
	[TC030] [char](1) NULL,
	[TC031] [numeric](1, 0) NULL,
	[TC032] [char](2) NULL,
	[TC033] [char](1) NULL,
	[TC034] [char](10) NULL,
	[TC035] [char](1) NULL,
	[TC036] [char](8) NULL,
	[TC037] [varchar](30) NULL,
	[TC038] [numeric](13, 2) NULL,
	[TC039] [numeric](13, 2) NULL,
	[TC040] [numeric](13, 2) NULL,
	[TC041] [char](25) NULL,
	[TC042] [char](4) NULL,
	[TC043] [char](1) NULL,
	[TC044] [numeric](15, 2) NULL,
	[TC045] [numeric](15, 2) NULL,
	[UDF01] [varchar](255) NULL,
	[UDF02] [varchar](255) NULL,
	[UDF03] [varchar](255) NULL,
	[UDF04] [varchar](255) NULL,
	[UDF05] [varchar](255) NULL,
	[UDF06] [varchar](255) NULL,
	[UDF51] [numeric](15, 6) NULL,
	[UDF52] [numeric](15, 6) NULL,
	[UDF53] [numeric](15, 6) NULL,
	[UDF54] [numeric](15, 6) NULL,
	[UDF55] [numeric](15, 6) NULL,
	[UDF56] [numeric](15, 6) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PURTD]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PURTD](
	[COMPANY] [char](10) NULL,
	[CREATOR] [char](10) NULL,
	[USR_GROUP] [char](10) NULL,
	[CREATE_DATE] [char](17) NULL,
	[MODIFIER] [char](10) NULL,
	[MODI_DATE] [char](17) NULL,
	[FLAG] [numeric](3, 0) NULL,
	[TD001] [char](4) NOT NULL,
	[TD002] [char](11) NOT NULL,
	[TD003] [char](4) NOT NULL,
	[TD004] [char](20) NULL,
	[TD005] [varchar](60) NULL,
	[TD006] [varchar](60) NULL,
	[TD007] [char](10) NULL,
	[TD008] [numeric](15, 6) NULL,
	[TD009] [char](4) NULL,
	[TD010] [numeric](17, 8) NULL,
	[TD011] [numeric](15, 2) NULL,
	[TD012] [char](8) NULL,
	[TD013] [char](4) NULL,
	[TD014] [varchar](255) NULL,
	[TD015] [numeric](15, 6) NULL,
	[TD016] [char](1) NULL,
	[TD017] [char](10) NULL,
	[TD018] [char](1) NULL,
	[TD019] [numeric](15, 6) NULL,
	[TD020] [char](4) NULL,
	[TD021] [char](11) NULL,
	[TD022] [char](20) NULL,
	[TD023] [char](4) NULL,
	[TD024] [char](20) NULL,
	[TD025] [char](1) NULL,
	[TD026] [char](4) NULL,
	[TD027] [char](11) NULL,
	[TD028] [char](4) NULL,
	[TD029] [char](20) NULL,
	[TD030] [numeric](15, 6) NULL,
	[TD031] [numeric](15, 6) NULL,
	[TD032] [char](4) NULL,
	[TD033] [numeric](5, 4) NULL,
	[TD034] [numeric](15, 2) NULL,
	[TD035] [numeric](15, 2) NULL,
	[TD036] [numeric](15, 6) NULL,
	[TD037] [numeric](15, 6) NULL,
	[TD038] [char](4) NULL,
	[TD039] [numeric](15, 6) NULL,
	[TD040] [char](10) NULL,
	[TD041] [char](2) NULL,
	[TD042] [char](1) NULL,
	[TD043] [char](8) NULL,
	[TD044] [varchar](30) NULL,
	[TD045] [numeric](13, 2) NULL,
	[TD046] [numeric](13, 2) NULL,
	[TD047] [numeric](13, 2) NULL,
	[UDF01] [varchar](255) NULL,
	[UDF02] [varchar](255) NULL,
	[UDF03] [varchar](255) NULL,
	[UDF04] [varchar](255) NULL,
	[UDF05] [varchar](255) NULL,
	[UDF06] [varchar](255) NULL,
	[UDF51] [numeric](15, 6) NULL,
	[UDF52] [numeric](15, 6) NULL,
	[UDF53] [numeric](15, 6) NULL,
	[UDF54] [numeric](15, 6) NULL,
	[UDF55] [numeric](15, 6) NULL,
	[UDF56] [numeric](15, 6) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[quotationXX]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[quotationXX](
	[customid] [char](20) NOT NULL,
	[code] [char](20) NOT NULL,
	[name] [char](60) NOT NULL,
	[spec] [char](60) NULL,
	[chkid] [tinyint] NULL,
	[currency] [char](10) NULL,
	[payment] [char](10) NULL,
	[customcode] [char](40) NULL,
	[customspec] [char](40) NULL,
	[itemno] [char](20) NULL,
	[cost] [numeric](18, 5) NULL,
	[price] [numeric](18, 5) NULL,
	[profit] [numeric](7, 2) NULL,
	[note] [char](180) NULL,
	[pricenote] [char](20) NULL,
	[begindate] [char](8) NULL,
	[enddate] [char](8) NULL,
	[taxrate] [numeric](18, 5) NULL,
	[exchangerate] [numeric](18, 5) NULL,
	[moq] [int] NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL,
	[chkdate] [datetime] NULL,
	[chkman] [char](10) NULL,
	[tosupplyid] [char](1) NULL,
	[supplyid] [char](20) NULL,
	[supplyname] [char](40) NULL,
	[color] [char](20) NULL,
	[ecolor] [char](20) NULL,
	[classid] [char](20) NULL,
	[interid] [int] NOT NULL,
	[mb057] [numeric](18, 5) NULL,
	[mb058] [numeric](18, 5) NULL,
	[mb059] [numeric](18, 5) NULL,
	[mb060] [numeric](18, 5) NULL,
	[bomchkid] [tinyint] NULL,
	[bomman] [char](20) NULL,
	[bomdate] [datetime] NULL,
	[stopid] [tinyint] NULL,
	[discount] [numeric](8, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[quoteprice]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[quoteprice](
	[dateid] [char](8) NOT NULL,
	[creatdate] [datetime] NULL,
	[billname] [char](10) NULL,
	[code] [char](20) NOT NULL,
	[name] [char](60) NULL,
	[spec] [char](60) NULL,
	[unit] [char](10) NULL,
	[attr] [char](10) NULL,
	[rate] [decimal](18, 2) NULL,
	[matcost] [numeric](18, 2) NULL,
	[MB057] [numeric](18, 2) NULL,
	[MB058] [numeric](18, 2) NULL,
	[MB059] [numeric](18, 2) NULL,
	[MB060] [numeric](18, 2) NULL,
	[MB046] [numeric](18, 2) NULL,
 CONSTRAINT [PK_quotecost] PRIMARY KEY CLUSTERED 
(
	[dateid] ASC,
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[remotion]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[remotion](
	[interid] [int] NOT NULL,
	[dateid] [datetime] NULL,
	[truckno] [char](60) NULL,
	[remotion] [char](40) NULL,
	[note] [varchar](1000) NULL,
	[billname] [char](10) NULL,
	[dept] [char](10) NULL,
	[keyvalue] [char](20) NULL,
	[statusid] [char](20) NULL,
	[creatdate] [datetime] NULL,
 CONSTRAINT [PK_remotion] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[reportlevel]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reportlevel](
	[interid] [int] NOT NULL,
	[classid] [char](20) NULL,
	[orderid] [int] NULL,
	[levelname] [char](20) NULL,
	[minnum] [int] NULL,
	[maxnum] [int] NULL,
	[cycle] [char](10) NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[rtxmessage]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rtxmessage](
	[interid] [int] NOT NULL,
	[title] [char](60) NOT NULL,
	[toman] [char](250) NOT NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NOT NULL,
	[note] [char](4000) NULL,
	[sysid] [tinyint] NULL,
 CONSTRAINT [PK_rtxmessage] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SalaryOther]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SalaryOther](
	[Dept] [char](10) NULL,
	[Name] [char](10) NULL,
	[InterID] [int] NOT NULL,
	[DateID] [datetime] NULL,
	[Abstract] [char](40) NULL,
	[Cash] [decimal](18, 2) NULL,
	[ItemClass] [char](10) NULL,
	[Note] [char](100) NULL,
	[BillName] [char](10) NULL,
	[CreatDate] [datetime] NULL,
	[Appo] [char](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SalaryTable]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SalaryTable](
	[interid] [int] NOT NULL,
	[Name] [char](10) NULL,
	[Dept] [char](10) NULL,
	[Appo] [char](10) NULL,
	[Salary] [decimal](18, 2) NULL,
	[Other] [decimal](18, 2) NULL,
	[FixCash] [decimal](18, 2) NULL,
	[Bonus] [decimal](18, 2) NULL,
	[DriverCash] [decimal](18, 2) NULL,
	[OtherCash] [decimal](18, 2) NULL,
	[Deduct] [decimal](18, 2) NULL,
	[SMonth] [char](7) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[salehistory]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[salehistory](
	[订单年月] [char](8) NULL,
	[客户简称] [char](20) NULL,
	[交易币种] [char](4) NULL,
	[汇率] [numeric](11, 7) NULL,
	[客户编号] [char](10) NULL,
	[品号] [char](20) NULL,
	[品名] [char](60) NULL,
	[规格] [char](60) NULL,
	[数量] [numeric](19, 6) NULL,
	[金额] [numeric](19, 4) NULL,
	[interid] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[selfreport]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[selfreport](
	[interid] [int] NOT NULL,
	[reportid] [char](40) NULL,
	[reportfilename] [char](40) NULL,
	[reportclass] [char](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sendto]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sendto](
	[interid] [int] NOT NULL,
	[creatdate] [datetime] NULL,
	[sendto] [char](100) NULL,
	[keyword] [char](100) NULL,
	[note] [char](100) NULL,
	[billname] [char](10) NULL,
	[classid] [char](10) NULL,
 CONSTRAINT [PK_sendto] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[shangshigongsi]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[shangshigongsi](
	[name] [char](10) NOT NULL,
	[url] [char](100) NULL,
	[id] [tinyint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[shenzhen]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[shenzhen](
	[name] [text] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[suppliedmaterials]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[suppliedmaterials](
	[interid] [int] NOT NULL,
	[billno] [char](20) NULL,
	[creatdate] [datetime] NULL,
	[billname] [char](10) NULL,
	[tocustom] [char](100) NULL,
	[numberno] [char](30) NULL,
	[applycustom] [char](30) NULL,
	[orderno] [char](30) NULL,
	[invno] [char](30) NULL,
	[lcno] [char](30) NULL,
	[scno] [char](30) NULL,
	[senddate] [char](10) NULL,
	[note] [char](100) NULL,
	[mark] [char](30) NULL,
	[des] [char](30) NULL,
	[item] [char](30) NULL,
	[cnts] [numeric](18, 2) NULL,
	[tip] [char](100) NULL,
	[cmb] [numeric](18, 2) NULL,
	[gw] [numeric](18, 2) NULL,
	[nw] [numeric](18, 2) NULL,
	[pcs] [int] NULL,
	[price] [numeric](18, 2) NULL,
	[amount] [numeric](18, 2) NULL,
	[chkid] [tinyint] NULL,
	[chkname] [char](10) NULL,
	[chkdate] [datetime] NULL,
	[code] [char](30) NULL,
	[name] [char](60) NULL,
	[spec] [char](60) NULL,
	[okpcs] [int] NULL,
	[boxpcs] [int] NULL,
 CONSTRAINT [PK_suppliedmaterials] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[supplycapacity]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[supplycapacity](
	[interid] [int] NOT NULL,
	[supplyid] [char](20) NOT NULL,
	[classid1] [char](10) NULL,
	[classid2] [char](10) NULL,
	[classid3] [char](10) NULL,
	[quan] [numeric](18, 2) NULL,
	[DayQuan] [numeric](18, 2) NULL,
	[WeekQuan] [numeric](18, 2) NULL,
	[Rand] [tinyint] NULL,
	[Note] [char](100) NULL,
	[Supply] [char](20) NULL,
	[ClassName1] [char](20) NULL,
	[ClassName2] [char](20) NULL,
	[BuyerID] [char](10) NULL,
	[Buyer] [char](20) NULL,
	[randtime] [decimal](18, 2) NULL,
 CONSTRAINT [PK_supplycapacity] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[systeminfo]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[systeminfo](
	[simpname] [char](20) NOT NULL,
	[company] [char](40) NOT NULL,
	[addr] [char](70) NOT NULL,
	[contact] [char](60) NOT NULL,
	[phone] [char](40) NOT NULL,
	[email] [char](40) NULL,
	[bp] [char](40) NULL,
	[note] [char](40) NULL,
	[autobill] [tinyint] NULL,
	[version] [char](20) NULL,
	[start] [tinyint] NULL,
	[interid] [int] NULL,
 CONSTRAINT [PK_systeminfo] PRIMARY KEY CLUSTERED 
(
	[simpname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tablemaxid]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tablemaxid](
	[tablename] [char](30) NOT NULL,
	[id] [int] NULL,
 CONSTRAINT [PK_tablemaxid] PRIMARY KEY CLUSTERED 
(
	[tablename] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tao_sale_order_bop]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tao_sale_order_bop](
	[name] [nvarchar](255) NOT NULL,
	[creatdate] [datetime] NULL,
	[id] [int] NULL,
 CONSTRAINT [fpAgent_pk] PRIMARY KEY CLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TB_City]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_City](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[CityName] [nvarchar](50) NULL,
	[ZipCode] [nvarchar](50) NULL,
	[ProvinceID] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TB_District]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_District](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[DistrictName] [nvarchar](50) NULL,
	[CityID] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TB_Province]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_Province](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ProvinceName] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[testitem]    Script Date: 2021/10/21 17:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[testitem](
	[interid] [int] NOT NULL,
	[sttime] [int] NOT NULL,
	[note] [char](30) NULL,
	[maininterid] [int] NOT NULL,
	[item] [char](10) NOT NULL,
 CONSTRAINT [PK_testitem] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[testmach]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[testmach](
	[interid] [int] NOT NULL,
	[machine] [char](40) NOT NULL,
	[item] [char](20) NOT NULL,
	[dutyman] [char](10) NULL,
	[testpara] [int] NULL,
	[dismounting] [int] NULL,
	[testtime] [int] NULL,
	[exportfile] [int] NULL,
	[limittime] [int] NULL,
	[standardtime] [int] NULL,
	[note] [char](32) NULL,
	[intest] [tinyint] NULL,
 CONSTRAINT [PK_test] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[testplan]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[testplan](
	[machine] [char](40) NOT NULL,
	[dateid] [char](8) NOT NULL,
	[calendar] [char](10) NOT NULL,
	[worktime] [decimal](6, 1) NULL,
	[outworktime] [decimal](6, 1) NULL,
	[note] [char](40) NULL,
	[pcs] [decimal](6, 1) NULL,
	[etime] [decimal](6, 1) NULL,
	[htime] [decimal](6, 1) NULL,
	[intest] [tinyint] NULL,
 CONSTRAINT [PK_testplan] PRIMARY KEY CLUSTERED 
(
	[machine] ASC,
	[dateid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[testrequ]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[testrequ](
	[interid] [int] NOT NULL,
	[dept] [char](10) NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL,
	[testname] [char](40) NULL,
	[testspec] [char](40) NULL,
	[quan] [int] NULL,
	[lang] [char](10) NULL,
	[volv] [int] NULL,
	[volhz] [int] NULL,
	[plevel] [char](2) NULL,
	[power] [int] NULL,
	[iplevel] [char](2) NULL,
	[driver] [char](40) NULL,
	[light] [char](40) NULL,
	[shape] [char](40) NULL,
	[other] [char](40) NULL,
	[note] [char](140) NULL,
	[chkid] [tinyint] NULL,
	[chkdate] [datetime] NULL,
	[chkname] [char](10) NULL,
	[appid] [tinyint] NULL,
	[appdate] [datetime] NULL,
	[appname] [char](10) NULL,
	[requid] [tinyint] NULL,
	[requdate] [datetime] NULL,
	[requname] [char](10) NULL,
	[endid] [tinyint] NULL,
	[enddate] [datetime] NULL,
	[endname] [char](10) NULL,
	[picture] [varbinary](max) NULL,
	[statusid] [char](10) NULL,
	[plandate] [datetime] NULL,
	[planname] [char](10) NULL,
	[planid] [tinyint] NULL,
	[needdate] [datetime] NULL,
 CONSTRAINT [PK_testrequ] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[testrequdetail]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[testrequdetail](
	[interid] [int] NOT NULL,
	[maininterid] [int] NULL,
	[statusid] [char](10) NULL,
	[machine] [char](40) NULL,
	[item] [char](20) NULL,
	[plandate] [char](8) NULL,
	[testpara] [int] NULL,
	[dismounting] [int] NULL,
	[testtime] [int] NULL,
	[exportfile] [int] NOT NULL,
	[begindate] [datetime] NULL,
	[enddate] [datetime] NULL,
	[ok] [tinyint] NULL,
	[dobeging] [datetime] NULL,
	[doend] [datetime] NULL,
	[beforetemperature] [tinyint] NULL,
	[aftetemperature] [tinyint] NULL,
	[beforehumidity] [tinyint] NULL,
	[afterhumidity] [tinyint] NULL,
	[testnote] [char](100) NULL,
	[testman] [char](10) NULL,
	[note] [char](130) NULL,
	[submit] [datetime] NULL,
	[submitman] [char](10) NULL,
	[planname] [char](10) NULL,
	[plantime] [datetime] NULL,
	[planid] [tinyint] NULL,
	[submitchkid] [tinyint] NULL,
	[beforecase] [char](10) NULL,
	[aftercase] [char](10) NULL,
	[duty] [char](10) NULL,
	[machman] [char](10) NULL,
	[intest] [tinyint] NULL,
 CONSTRAINT [PK_testrequdetail] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[treecode]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[treecode](
	[keyid] [smallint] NOT NULL,
	[fkey] [smallint] NOT NULL,
	[nodeicon] [tinyint] NULL,
	[selecticon] [tinyint] NULL,
	[exicon] [tinyint] NULL,
	[name] [char](40) NOT NULL,
	[note] [char](40) NULL,
	[CONTENT] [nchar](40) NULL,
 CONSTRAINT [PK_treecode] PRIMARY KEY CLUSTERED 
(
	[keyid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[trymold]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trymold](
	[interid] [int] NOT NULL,
	[moldnum] [char](20) NOT NULL,
	[name] [char](40) NULL,
	[spec] [char](40) NULL,
	[makedept] [char](10) NULL,
	[trydept] [char](10) NULL,
	[moldlevel] [char](10) NULL,
	[classid] [char](10) NULL,
	[useclassid] [char](10) NULL,
	[trynum] [tinyint] NULL,
	[senddate] [datetime] NULL,
	[trybegindate] [datetime] NULL,
	[tryenddate] [datetime] NULL,
	[totalnum] [tinyint] NULL,
	[okquan] [tinyint] NULL,
	[trystatus] [char](200) NULL,
	[moldstatus] [char](200) NULL,
	[tryprocess] [char](200) NULL,
	[note] [char](200) NULL,
	[moldmanage] [char](10) NULL,
	[creatdate] [datetime] NULL,
	[billname] [char](10) NULL,
	[getman] [char](10) NULL,
 CONSTRAINT [PK_trymold] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[trymolddetail]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trymolddetail](
	[maininterid] [int] NOT NULL,
	[interid] [int] NOT NULL,
	[code] [char](20) NULL,
	[name] [char](40) NULL,
	[spec] [char](40) NULL,
	[quan] [int] NULL,
	[totalquan] [int] NULL,
	[note] [char](100) NULL,
 CONSTRAINT [PK_trymolddetail] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[update]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[update](
	[filename] [char](20) NOT NULL,
	[filedata] [varbinary](max) NULL,
	[des] [nvarchar](max) NULL,
	[creatdate] [datetime] NULL,
	[newid] [tinyint] NULL,
	[billname] [char](10) NULL,
	[ver] [char](20) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[userStatus]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[userStatus](
	[username] [varchar](64) NOT NULL,
	[resource] [varchar](64) NOT NULL,
	[online] [tinyint] NOT NULL,
	[presence] [char](15) NULL,
	[lastIpAddress] [char](15) NOT NULL,
	[lastLoginDate] [char](15) NOT NULL,
	[lastLogoffDate] [char](15) NULL,
 CONSTRAINT [PK_userStatus] PRIMARY KEY CLUSTERED 
(
	[username] ASC,
	[resource] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[userStatusHistory]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[userStatusHistory](
	[historyID] [bigint] NOT NULL,
	[username] [varchar](64) NOT NULL,
	[resource] [varchar](64) NOT NULL,
	[lastIpAddress] [char](15) NOT NULL,
	[lastLoginDate] [char](15) NOT NULL,
	[lastLogoffDate] [char](15) NOT NULL,
 CONSTRAINT [PK_userStatusHistory] PRIMARY KEY CLUSTERED 
(
	[historyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[W_chiba]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[W_chiba](
	[ID] [char](8) NOT NULL,
	[CHIBA] [varchar](1000) NULL,
	[HUANGLI] [varchar](1000) NULL,
 CONSTRAINT [PK_W_chiba] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[workdaily]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[workdaily](
	[interid] [int] NOT NULL,
	[dateid] [char](8) NULL,
	[workshop] [char](20) NULL,
	[workorder] [char](10) NULL,
	[workgroup] [char](10) NULL,
	[package] [char](40) NULL,
	[checkman] [char](10) NULL,
	[workhead] [char](10) NULL,
	[workposition] [char](20) NULL,
	[worker] [char](10) NULL,
	[code] [char](20) NULL,
	[name] [char](60) NULL,
	[spec] [char](60) NULL,
	[runtime] [decimal](18, 2) NULL,
	[stoptime] [decimal](18, 2) NULL,
	[totalquan] [int] NULL,
	[okquan] [int] NULL,
	[badquan] [decimal](18, 1) NULL,
	[note] [char](60) NULL,
	[workcode] [char](3) NULL,
	[price] [decimal](18, 3) NULL,
	[classid] [char](10) NULL,
	[classname] [char](20) NULL,
	[weight] [decimal](18, 3) NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL,
	[text4] [tinyint] NULL,
	[text5] [tinyint] NULL,
	[text6] [tinyint] NULL,
	[text7] [tinyint] NULL,
	[text8] [tinyint] NULL,
	[text9] [tinyint] NULL,
	[text10] [tinyint] NULL,
	[statusid] [char](20) NULL,
	[gathers] [int] NULL,
	[scode] [char](20) NULL,
	[hrcode] [char](10) NULL,
	[ta001] [char](4) NULL,
	[ta002] [char](20) NULL,
	[chkid] [tinyint] NULL,
	[chkname] [char](10) NULL,
	[chkdate] [datetime] NULL,
	[manhour] [numeric](5, 1) NULL,
	[diagnosis] [tinyint] NULL,
	[billid] [tinyint] NULL,
 CONSTRAINT [PK_workdaily] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[workdaily1]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[workdaily1](
	[interid] [int] NOT NULL,
	[dateid] [char](8) NOT NULL,
	[workshop] [char](20) NOT NULL,
	[workorder] [char](10) NULL,
	[workgroup] [char](10) NOT NULL,
	[package] [char](40) NULL,
	[checkman] [char](10) NULL,
	[workhead] [char](10) NULL,
	[workposition] [char](10) NULL,
	[worker] [char](10) NULL,
	[code] [char](20) NOT NULL,
	[name] [char](60) NULL,
	[spec] [char](60) NULL,
	[runtime] [decimal](18, 2) NULL,
	[stoptime] [decimal](18, 2) NULL,
	[totalquan] [int] NULL,
	[okquan] [int] NULL,
	[badquan] [int] NULL,
	[note] [char](60) NULL,
	[workcode] [char](3) NULL,
	[price] [decimal](18, 3) NULL,
	[classid] [char](10) NULL,
	[classname] [char](20) NULL,
	[weight] [decimal](18, 3) NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL,
	[text4] [tinyint] NULL,
	[text5] [tinyint] NULL,
	[text6] [tinyint] NULL,
	[text7] [tinyint] NULL,
	[text8] [tinyint] NULL,
	[text9] [tinyint] NULL,
	[text10] [tinyint] NULL,
	[statusid] [char](20) NULL,
	[gathers] [int] NULL,
	[scode] [char](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[workdailybad]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[workdailybad](
	[interid] [int] NOT NULL,
	[maininterid] [int] NOT NULL,
	[workorderbad] [char](10) NOT NULL,
	[quanbad] [int] NOT NULL,
	[notebad] [char](100) NOT NULL,
 CONSTRAINT [PK_workdailybad] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[workhouse]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[workhouse](
	[interid] [int] NOT NULL,
	[billno] [char](20) NULL,
	[dateid] [char](8) NULL,
	[workshop] [char](20) NULL,
	[workorder] [char](10) NULL,
	[statusid] [char](10) NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL,
	[CheckId] [tinyint] NULL,
	[CheckMan] [char](10) NULL,
	[CheckDate] [datetime] NULL,
	[note] [char](100) NULL,
	[billid] [tinyint] NULL,
	[classid] [char](10) NULL,
	[classname] [char](20) NULL,
	[code] [char](20) NULL,
	[name] [char](50) NULL,
	[spec] [char](50) NULL,
	[weight] [numeric](18, 3) NULL,
	[quan] [int] NULL,
	[badquan] [int] NULL,
	[related] [char](20) NULL,
	[AutoId] [int] NULL,
	[moctfid] [char](30) NULL,
 CONSTRAINT [PK_workhouse] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[workhouse1]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[workhouse1](
	[interid] [int] NOT NULL,
	[billno] [char](20) NULL,
	[dateid] [char](8) NULL,
	[workshop] [char](12) NULL,
	[workorder] [char](10) NULL,
	[statusid] [char](10) NULL,
	[billname] [char](10) NULL,
	[creatdate] [datetime] NULL,
	[CheckId] [tinyint] NULL,
	[CheckMan] [char](10) NULL,
	[CheckDate] [datetime] NULL,
	[note] [char](100) NULL,
	[billid] [tinyint] NOT NULL,
	[classid] [char](10) NULL,
	[classname] [char](20) NULL,
	[code] [char](20) NULL,
	[name] [char](50) NULL,
	[spec] [char](50) NULL,
	[weight] [numeric](18, 3) NULL,
	[quan] [int] NULL,
	[badquan] [int] NULL,
	[related] [char](20) NULL,
	[AutoId] [int] NULL,
	[moctfid] [char](30) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[workshoppricedetail]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[workshoppricedetail](
	[interid] [int] NOT NULL,
	[mf001] [char](10) NOT NULL,
	[pcs] [smallint] NULL,
	[price] [numeric](8, 3) NULL,
	[mf009] [int] NULL,
	[mf010] [int] NULL,
 CONSTRAINT [PK_workshoppricedetail] PRIMARY KEY CLUSTERED 
(
	[interid] ASC,
	[mf001] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[worktqc]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[worktqc](
	[checktime] [char](10) NULL,
	[okquan] [int] NULL,
	[badquan] [int] NULL,
	[badclass] [char](10) NULL,
	[reason] [char](30) NULL,
	[improve] [char](60) NULL,
	[result] [char](30) NULL,
	[note] [char](100) NULL,
	[interid] [int] NOT NULL,
	[workinterid] [int] NOT NULL,
 CONSTRAINT [PK_makedetail] PRIMARY KEY CLUSTERED 
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[xadmin_bookmark]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xadmin_bookmark](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](128) NOT NULL,
	[url_name] [nvarchar](64) NOT NULL,
	[query] [nvarchar](1000) NOT NULL,
	[is_share] [bit] NOT NULL,
	[content_type_id] [int] NOT NULL,
	[user_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[xadmin_log]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xadmin_log](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[action_time] [datetime2](7) NOT NULL,
	[ip_addr] [nvarchar](39) NULL,
	[object_id] [nvarchar](max) NULL,
	[object_repr] [nvarchar](200) NOT NULL,
	[action_flag] [nvarchar](32) NOT NULL,
	[message] [nvarchar](max) NOT NULL,
	[content_type_id] [int] NULL,
	[user_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[xadmin_usersettings]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xadmin_usersettings](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[key] [nvarchar](256) NOT NULL,
	[value] [nvarchar](max) NOT NULL,
	[user_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[xadmin_userwidget]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xadmin_userwidget](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[page_id] [nvarchar](256) NOT NULL,
	[widget_type] [nvarchar](50) NOT NULL,
	[value] [nvarchar](max) NOT NULL,
	[user_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[zhejiang_COMPANY]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[zhejiang_COMPANY](
	[_id_oid] [nvarchar](255) NULL,
	[staffInfo_position] [nvarchar](255) NULL,
	[staffInfo_id] [nvarchar](255) NULL,
	[staffInfo_name] [nvarchar](255) NULL,
	[basicInfo_incName] [nvarchar](255) NULL,
	[basicInfo_businessTimeLimitFrom] [nvarchar](255) NULL,
	[basicInfo_establishDate] [nvarchar](255) NULL,
	[basicInfo_incAddress] [nvarchar](255) NULL,
	[basicInfo_registOrganization] [nvarchar](255) NULL,
	[basicInfo_registCode] [nvarchar](255) NULL,
	[basicInfo_registCapital] [nvarchar](255) NULL,
	[basicInfo_incType] [nvarchar](255) NULL,
	[basicInfo_businessScope] [nvarchar](255) NULL,
	[basicInfo_approveDate] [nvarchar](255) NULL,
	[basicInfo_businessTimeLimitTo] [nvarchar](255) NULL,
	[basicInfo_registStatus] [nvarchar](255) NULL,
	[basicInfo_legalPerson] [nvarchar](255) NULL,
	[key] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[zhejiang_staffinfo]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[zhejiang_staffinfo](
	[position] [nvarchar](255) NULL,
	[id] [nvarchar](255) NULL,
	[name] [nvarchar](255) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [_dta_index_appalarmset_6_426484598__K1_K5_K3_2]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [_dta_index_appalarmset_6_426484598__K1_K5_K3_2] ON [dbo].[appalarmsety]
(
	[sn] ASC,
	[action] ASC,
	[creatdate] ASC
)
INCLUDE ( 	[snid]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [indexlu]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [indexlu] ON [dbo].[attendancerecord]
(
	[numid] ASC,
	[name] ASC,
	[dept] ASC,
	[dateid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [auth_group_permissions_group_id_b120cbf9]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [auth_group_permissions_group_id_b120cbf9] ON [dbo].[auth_group_permissions]
(
	[group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [auth_group_permissions_permission_id_84c5c92e]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [auth_group_permissions_permission_id_84c5c92e] ON [dbo].[auth_group_permissions]
(
	[permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [auth_permission_content_type_id_2f476e4b]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [auth_permission_content_type_id_2f476e4b] ON [dbo].[auth_permission]
(
	[content_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [auth_user_groups_group_id_97559544]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [auth_user_groups_group_id_97559544] ON [dbo].[auth_user_groups]
(
	[group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [auth_user_groups_user_id_6a12ed8b]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [auth_user_groups_user_id_6a12ed8b] ON [dbo].[auth_user_groups]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [auth_user_user_permissions_permission_id_1fbb5f2c]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [auth_user_user_permissions_permission_id_1fbb5f2c] ON [dbo].[auth_user_user_permissions]
(
	[permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [auth_user_user_permissions_user_id_a95ead1b]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [auth_user_user_permissions_user_id_a95ead1b] ON [dbo].[auth_user_user_permissions]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [code-orderby-oldid]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [code-orderby-oldid] ON [dbo].[bincode]
(
	[oldid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [no_cdf]    Script Date: 2021/10/21 17:35:14 ******/
CREATE UNIQUE NONCLUSTERED INDEX [no_cdf] ON [dbo].[cdf]
(
	[no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [BILLNAME]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [BILLNAME] ON [dbo].[daily]
(
	[billname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [DATEID]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [DATEID] ON [dbo].[daily]
(
	[dateid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
/****** Object:  Index [dd]    Script Date: 2021/10/21 17:35:14 ******/
CREATE UNIQUE NONCLUSTERED INDEX [dd] ON [dbo].[defaultval]
(
	[interid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [django_admin_log_content_type_id_c4bce8eb]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [django_admin_log_content_type_id_c4bce8eb] ON [dbo].[django_admin_log]
(
	[content_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [django_admin_log_user_id_c564eba6]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [django_admin_log_user_id_c564eba6] ON [dbo].[django_admin_log]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [django_session_expire_date_a5c62663]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [django_session_expire_date_a5c62663] ON [dbo].[django_session]
(
	[expire_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [fpWorkgroup_workgroupid_idx]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [fpWorkgroup_workgroupid_idx] ON [dbo].[fpWorkgroup]
(
	[workgroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [MB001]    Script Date: 2021/10/21 17:35:14 ******/
CREATE UNIQUE NONCLUSTERED INDEX [MB001] ON [dbo].[INVMB]
(
	[MB001] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [dateid]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [dateid] ON [dbo].[Makeplan]
(
	[cDateId] ASC,
	[WorkShopName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [PK_DATEANDWORKSHOP]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [PK_DATEANDWORKSHOP] ON [dbo].[Makeplan]
(
	[cDateId] ASC,
	[WorkShop] ASC,
	[WorkShopName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [pkorder]    Script Date: 2021/10/21 17:35:14 ******/
CREATE UNIQUE NONCLUSTERED INDEX [pkorder] ON [dbo].[MakePlanDetail]
(
	[DateID] ASC,
	[WorkShop] ASC,
	[WorkOrder] ASC,
	[getorder] ASC,
	[InterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [name]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [name] ON [dbo].[mathistory1]
(
	[sender] ASC,
	[receiver] ASC,
	[dtime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ofGatewayAvatars_jid_idx]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [ofGatewayAvatars_jid_idx] ON [dbo].[ofGatewayAvatars]
(
	[jid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ofGatewayPseudoRoster_regid_idx]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [ofGatewayPseudoRoster_regid_idx] ON [dbo].[ofGatewayPseudoRoster]
(
	[registrationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ofGatewayPseudoRoster_uname_idx]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [ofGatewayPseudoRoster_uname_idx] ON [dbo].[ofGatewayPseudoRoster]
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ofGatewayRegistration_jid_idx]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [ofGatewayRegistration_jid_idx] ON [dbo].[ofGatewayRegistration]
(
	[jid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ofGatewayRegistration_type_idx]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [ofGatewayRegistration_type_idx] ON [dbo].[ofGatewayRegistration]
(
	[transportType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ofGatewayRestrictions_ttype_idx]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [ofGatewayRestrictions_ttype_idx] ON [dbo].[ofGatewayRestrictions]
(
	[transportType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ofGatewayRestrictions_uname_idx]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [ofGatewayRestrictions_uname_idx] ON [dbo].[ofGatewayRestrictions]
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ofGatewayVCards_jid_idx]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [ofGatewayVCards_jid_idx] ON [dbo].[ofGatewayVCards]
(
	[jid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [interid]    Script Date: 2021/10/21 17:35:14 ******/
CREATE UNIQUE NONCLUSTERED INDEX [interid] ON [dbo].[PassWord]
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NonClusteredIndex-20180712-094348]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20180712-094348] ON [dbo].[PC曾用名]
(
	[曾用名] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [pk_purtc]    Script Date: 2021/10/21 17:35:14 ******/
CREATE UNIQUE NONCLUSTERED INDEX [pk_purtc] ON [dbo].[PURTC]
(
	[TC001] ASC,
	[TC002] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [purtc_pk01]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [purtc_pk01] ON [dbo].[PURTC]
(
	[TC003] ASC,
	[TC001] ASC,
	[TC002] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [PK_PURTD]    Script Date: 2021/10/21 17:35:14 ******/
CREATE UNIQUE NONCLUSTERED INDEX [PK_PURTD] ON [dbo].[PURTD]
(
	[TD001] ASC,
	[TD002] ASC,
	[TD003] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [PURTD_PK01]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [PURTD_PK01] ON [dbo].[PURTD]
(
	[TD012] ASC,
	[TD004] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [PURTD_PK02]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [PURTD_PK02] ON [dbo].[PURTD]
(
	[TD013] ASC,
	[TD021] ASC,
	[TD004] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [supplyid]    Script Date: 2021/10/21 17:35:14 ******/
CREATE UNIQUE NONCLUSTERED INDEX [supplyid] ON [dbo].[supplycapacity]
(
	[supplyid] ASC,
	[classid2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [Search]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [Search] ON [dbo].[workdaily]
(
	[dateid] ASC,
	[workshop] ASC,
	[workorder] ASC,
	[workgroup] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [billno]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [billno] ON [dbo].[workhouse]
(
	[billno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [pk_workshop]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [pk_workshop] ON [dbo].[workhouse]
(
	[dateid] ASC,
	[workshop] ASC,
	[workorder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
/****** Object:  Index [xadmin_bookmark_content_type_id_60941679]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [xadmin_bookmark_content_type_id_60941679] ON [dbo].[xadmin_bookmark]
(
	[content_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [xadmin_bookmark_user_id_42d307fc]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [xadmin_bookmark_user_id_42d307fc] ON [dbo].[xadmin_bookmark]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [xadmin_log_content_type_id_2a6cb852]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [xadmin_log_content_type_id_2a6cb852] ON [dbo].[xadmin_log]
(
	[content_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [xadmin_log_user_id_bb16a176]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [xadmin_log_user_id_bb16a176] ON [dbo].[xadmin_log]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [xadmin_usersettings_user_id_edeabe4a]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [xadmin_usersettings_user_id_edeabe4a] ON [dbo].[xadmin_usersettings]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [xadmin_userwidget_user_id_c159233a]    Script Date: 2021/10/21 17:35:14 ******/
CREATE NONCLUSTERED INDEX [xadmin_userwidget_user_id_c159233a] ON [dbo].[xadmin_userwidget]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[appalarmset] ADD  CONSTRAINT [DF_appalarmsetx_creatdate]  DEFAULT (getdate()) FOR [creatdate]
GO
ALTER TABLE [dbo].[appalarmsety] ADD  CONSTRAINT [DF_appalarmset_creatdate]  DEFAULT (getdate()) FOR [creatdate]
GO
ALTER TABLE [dbo].[backfire] ADD  CONSTRAINT [DF_backfire_backfirefee]  DEFAULT ((0)) FOR [backfirefee]
GO
ALTER TABLE [dbo].[bincode] ADD  CONSTRAINT [DF_bincode_descripe_1]  DEFAULT ('') FOR [descripe]
GO
ALTER TABLE [dbo].[bincode] ADD  CONSTRAINT [DF_bincode_spkg_1]  DEFAULT ((0)) FOR [spkg]
GO
ALTER TABLE [dbo].[bincode] ADD  CONSTRAINT [DF_bincode_spw_1]  DEFAULT ((0)) FOR [spw]
GO
ALTER TABLE [dbo].[bincode] ADD  CONSTRAINT [DF_bincode_spd_1]  DEFAULT ((0)) FOR [spd]
GO
ALTER TABLE [dbo].[bincode] ADD  CONSTRAINT [DF_bincode_sph_1]  DEFAULT ((0)) FOR [sph]
GO
ALTER TABLE [dbo].[bincode] ADD  CONSTRAINT [DF_bincode_mcpcs_1]  DEFAULT ((0)) FOR [mcpcs]
GO
ALTER TABLE [dbo].[bincode] ADD  CONSTRAINT [DF_bincode_mckgs_1]  DEFAULT ((0)) FOR [mckgs]
GO
ALTER TABLE [dbo].[bincode] ADD  CONSTRAINT [DF_bincode_mcw_1]  DEFAULT ((0)) FOR [mcw]
GO
ALTER TABLE [dbo].[bincode] ADD  CONSTRAINT [DF_bincode_mcd_1]  DEFAULT ((0)) FOR [mcd]
GO
ALTER TABLE [dbo].[bincode] ADD  CONSTRAINT [DF_bincode_mch_1]  DEFAULT ((0)) FOR [mch]
GO
ALTER TABLE [dbo].[bincode] ADD  CONSTRAINT [DF_bincode_mccmb_1]  DEFAULT ((0)) FOR [mccmb]
GO
ALTER TABLE [dbo].[bincode] ADD  CONSTRAINT [DF_bincode_moq_1]  DEFAULT ((0)) FOR [moq]
GO
ALTER TABLE [dbo].[bincode] ADD  CONSTRAINT [DF_bincode_qty20fcl_1]  DEFAULT ((0)) FOR [qty20fcl]
GO
ALTER TABLE [dbo].[bincode] ADD  CONSTRAINT [DF_bincode_qty40fcl_1]  DEFAULT ((0)) FOR [qty40fcl]
GO
ALTER TABLE [dbo].[bincode] ADD  CONSTRAINT [DF_bincode_qty40h_1]  DEFAULT ((0)) FOR [qty40h]
GO
ALTER TABLE [dbo].[bincode] ADD  CONSTRAINT [DF_bincode_oldid_1]  DEFAULT ((0)) FOR [oldid]
GO
ALTER TABLE [dbo].[bincode] ADD  CONSTRAINT [DF_bincode_nbkgs_1]  DEFAULT ((0)) FOR [nbkgs]
GO
ALTER TABLE [dbo].[bincode] ADD  CONSTRAINT [DF_bincode_nbw_1]  DEFAULT ((0)) FOR [nbw]
GO
ALTER TABLE [dbo].[bincode] ADD  CONSTRAINT [DF_bincode_nbd_1]  DEFAULT ((0)) FOR [nbd]
GO
ALTER TABLE [dbo].[bincode] ADD  CONSTRAINT [DF_bincode_nbh_1]  DEFAULT ((0)) FOR [nbh]
GO
ALTER TABLE [dbo].[bincode] ADD  CONSTRAINT [DF_bincode_nbcmb_1]  DEFAULT ((0)) FOR [nbcmb]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_pictid]  DEFAULT ((0)) FOR [pictid]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_descripe]  DEFAULT ('') FOR [descripe]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_spkg]  DEFAULT ((0)) FOR [spkg]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_spw]  DEFAULT ((0)) FOR [spw]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_spd]  DEFAULT ((0)) FOR [spd]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_sph]  DEFAULT ((0)) FOR [sph]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_spcmb]  DEFAULT ((0)) FOR [spcmb]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_mcpcs]  DEFAULT ((0)) FOR [mcpcs]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_mckgs]  DEFAULT ((0)) FOR [mckgs]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_mcw]  DEFAULT ((0)) FOR [mcw]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_mcd]  DEFAULT ((0)) FOR [mcd]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_mch]  DEFAULT ((0)) FOR [mch]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_mccmb]  DEFAULT ((0)) FOR [mccmb]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_moq]  DEFAULT ((0)) FOR [moq]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_qty20fcl]  DEFAULT ((0)) FOR [qty20fcl]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_qty40fcl]  DEFAULT ((0)) FOR [qty40fcl]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_qty40h]  DEFAULT ((0)) FOR [qty40h]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_innerquan]  DEFAULT ((0)) FOR [innerquan]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_oldid]  DEFAULT ((0)) FOR [oldid]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_nbkgs]  DEFAULT ((0)) FOR [nbkgs]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_nbw]  DEFAULT ((0)) FOR [nbw]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_nbd]  DEFAULT ((0)) FOR [nbd]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_nbh]  DEFAULT ((0)) FOR [nbh]
GO
ALTER TABLE [dbo].[bincode12] ADD  CONSTRAINT [DF_bincode_nbcmb]  DEFAULT ((0)) FOR [nbcmb]
GO
ALTER TABLE [dbo].[cdf] ADD  CONSTRAINT [DF_cdf_checkid]  DEFAULT ((0)) FOR [checkid]
GO
ALTER TABLE [dbo].[checkweb] ADD  CONSTRAINT [DF_checkweb_endid]  DEFAULT ((0)) FOR [endid]
GO
ALTER TABLE [dbo].[CustomInfo] ADD  CONSTRAINT [DF_CustomInfo_TableID]  DEFAULT ((1)) FOR [TableID]
GO
ALTER TABLE [dbo].[CustomInfo] ADD  CONSTRAINT [DF_CustomInfo_autopackage]  DEFAULT ((1)) FOR [autopackage]
GO
ALTER TABLE [dbo].[daily] ADD  CONSTRAINT [DF_daily_classid]  DEFAULT ('') FOR [classid]
GO
ALTER TABLE [dbo].[daily] ADD  CONSTRAINT [DF_daily_billname]  DEFAULT ('') FOR [billname]
GO
ALTER TABLE [dbo].[daily] ADD  CONSTRAINT [DF_daily_lab]  DEFAULT ('') FOR [lab]
GO
ALTER TABLE [dbo].[daily] ADD  CONSTRAINT [DF_daily_topic]  DEFAULT ('') FOR [topic]
GO
ALTER TABLE [dbo].[daily] ADD  CONSTRAINT [DF_daily_dept]  DEFAULT ('') FOR [dept]
GO
ALTER TABLE [dbo].[daily] ADD  CONSTRAINT [DF_daily_appo]  DEFAULT ('') FOR [appo]
GO
ALTER TABLE [dbo].[daily] ADD  CONSTRAINT [DF_daily_RichID]  DEFAULT ((0)) FOR [RichID]
GO
ALTER TABLE [dbo].[daily] ADD  CONSTRAINT [DF_daily_FileID]  DEFAULT ((0)) FOR [FileID]
GO
ALTER TABLE [dbo].[daily] ADD  CONSTRAINT [DF_daily_readid]  DEFAULT ((0)) FOR [readid]
GO
ALTER TABLE [dbo].[daily] ADD  CONSTRAINT [DF_daily_othid]  DEFAULT ((0)) FOR [othid]
GO
ALTER TABLE [dbo].[daily] ADD  CONSTRAINT [DF_daily_PutFile]  DEFAULT ('') FOR [PutFile]
GO
ALTER TABLE [dbo].[dashboard] ADD  CONSTRAINT [DF_dashboard_getval]  DEFAULT ((0)) FOR [getval]
GO
ALTER TABLE [dbo].[dashboard] ADD  CONSTRAINT [DF_dashboard_preval]  DEFAULT ((0)) FOR [preval]
GO
ALTER TABLE [dbo].[FIXMOLDDETAIL] ADD  CONSTRAINT [DF_FIXMOLDDETAIL_cc]  DEFAULT ((0)) FOR [cc]
GO
ALTER TABLE [dbo].[FIXMOLDDETAIL] ADD  CONSTRAINT [DF_FIXMOLDDETAIL_mc]  DEFAULT ((0)) FOR [mc]
GO
ALTER TABLE [dbo].[FIXMOLDDETAIL] ADD  CONSTRAINT [DF_FIXMOLDDETAIL_xc]  DEFAULT ((0)) FOR [xc]
GO
ALTER TABLE [dbo].[FIXMOLDDETAIL] ADD  CONSTRAINT [DF_FIXMOLDDETAIL_xqg]  DEFAULT ((0)) FOR [xqg]
GO
ALTER TABLE [dbo].[FIXMOLDDETAIL] ADD  CONSTRAINT [DF_FIXMOLDDETAIL_dhh]  DEFAULT ((0)) FOR [dhh]
GO
ALTER TABLE [dbo].[FIXMOLDDETAIL] ADD  CONSTRAINT [DF_FIXMOLDDETAIL_sh]  DEFAULT ((0)) FOR [sh]
GO
ALTER TABLE [dbo].[FIXMOLDDETAIL] ADD  CONSTRAINT [DF_FIXMOLDDETAIL_ch]  DEFAULT ((0)) FOR [ch]
GO
ALTER TABLE [dbo].[FIXMOLDDETAIL] ADD  CONSTRAINT [DF_FIXMOLDDETAIL_dh]  DEFAULT ((0)) FOR [dh]
GO
ALTER TABLE [dbo].[getsmm] ADD  CONSTRAINT [DF_getsmm_getid]  DEFAULT ((0)) FOR [getid]
GO
ALTER TABLE [dbo].[lutec_bom] ADD  CONSTRAINT [DF_lutec_bom_creatdate]  DEFAULT (getdate()) FOR [creatdate]
GO
ALTER TABLE [dbo].[lutec_mrp_routing] ADD  CONSTRAINT [DF_lutec_mrp_routing_creatdate]  DEFAULT (getdate()) FOR [creatdate]
GO
ALTER TABLE [dbo].[lutec_product] ADD  CONSTRAINT [DF_lutec_product_creatdate]  DEFAULT (getdate()) FOR [creatdate]
GO
ALTER TABLE [dbo].[lutec_purchase_order] ADD  CONSTRAINT [DF_lutec_purchase_order_creatdate]  DEFAULT (getdate()) FOR [creatdate]
GO
ALTER TABLE [dbo].[lutec_revisions] ADD  CONSTRAINT [DF_lutec_revisions_creatdate]  DEFAULT (getdate()) FOR [creatdate]
GO
ALTER TABLE [dbo].[lutec_sale_order] ADD  CONSTRAINT [DF_lutec_sale_order_creatdate]  DEFAULT (getdate()) FOR [creatdate]
GO
ALTER TABLE [dbo].[lutec_supplierinfo] ADD  CONSTRAINT [DF_lutec_supplierinfo_creatdate]  DEFAULT (getdate()) FOR [creatdate]
GO
ALTER TABLE [dbo].[LutecApp] ADD  CONSTRAINT [DF_LutecApp_ApkSize]  DEFAULT ((0)) FOR [ApkSize]
GO
ALTER TABLE [dbo].[mademain] ADD  CONSTRAINT [DF_mademain_requid]  DEFAULT ((0)) FOR [requid]
GO
ALTER TABLE [dbo].[MakeDayDetail] ADD  CONSTRAINT [DF_MakeDayDetail_MainId]  DEFAULT ((1)) FOR [MainId]
GO
ALTER TABLE [dbo].[MakeDayDetail] ADD  CONSTRAINT [DF_MakeDayDetail_badquan]  DEFAULT ((0)) FOR [badquan]
GO
ALTER TABLE [dbo].[makemold] ADD  CONSTRAINT [DF_makemold_workshop]  DEFAULT ('模具车间') FOR [workshop]
GO
ALTER TABLE [dbo].[MakePlanDetail] ADD  CONSTRAINT [DF_MakePlanDetail_Note]  DEFAULT ('') FOR [Note]
GO
ALTER TABLE [dbo].[MakePlanDetail] ADD  CONSTRAINT [DF_MakePlanDetail_AddDes]  DEFAULT ('') FOR [AddDes]
GO
ALTER TABLE [dbo].[mathistory] ADD  CONSTRAINT [DF_mathistory_配件规格]  DEFAULT ('') FOR [配件规格]
GO
ALTER TABLE [dbo].[moldcard] ADD  CONSTRAINT [DF_moldcard_weight]  DEFAULT ((2)) FOR [weight]
GO
ALTER TABLE [dbo].[moldcard] ADD  CONSTRAINT [DF_moldcard_checkid]  DEFAULT ((0)) FOR [checkid]
GO
ALTER TABLE [dbo].[ofUser] ADD  CONSTRAINT [DF_ofUser_creationDate]  DEFAULT ((0)) FOR [creationDate]
GO
ALTER TABLE [dbo].[ofUser] ADD  CONSTRAINT [DF_ofUser_modificationDate]  DEFAULT ((0)) FOR [modificationDate]
GO
ALTER TABLE [dbo].[PassWord] ADD  CONSTRAINT [DF_PassWord_ncolour]  DEFAULT ((1)) FOR [ncolour]
GO
ALTER TABLE [dbo].[PassWord] ADD  CONSTRAINT [DF_PassWord_dcreated]  DEFAULT (getdate()) FOR [dcreated]
GO
ALTER TABLE [dbo].[PassWord] ADD  CONSTRAINT [DF_PassWord_password]  DEFAULT ('3') FOR [password]
GO
ALTER TABLE [dbo].[PassWord] ADD  CONSTRAINT [DF_PassWord_isactive]  DEFAULT ((0)) FOR [isactive]
GO
ALTER TABLE [dbo].[PassWord] ADD  CONSTRAINT [DF_PassWord_interid]  DEFAULT ((5840127)) FOR [interid]
GO
ALTER TABLE [dbo].[PassWord] ADD  CONSTRAINT [DF_PassWord_usersynctype]  DEFAULT ('所有纪录') FOR [usersynctype]
GO
ALTER TABLE [dbo].[PassWord] ADD  CONSTRAINT [DF_PassWord_rights]  DEFAULT ('333413320000000030            ') FOR [rights]
GO
ALTER TABLE [dbo].[pi] ADD  CONSTRAINT [DF_pi_requid]  DEFAULT ((0)) FOR [requid]
GO
ALTER TABLE [dbo].[pi] ADD  CONSTRAINT [DF_pi_chgdate]  DEFAULT (getdate()) FOR [chgdate]
GO
ALTER TABLE [dbo].[piapprove] ADD  CONSTRAINT [DF_piapprove_chkid]  DEFAULT ((0)) FOR [chkid]
GO
ALTER TABLE [dbo].[pichange] ADD  CONSTRAINT [DF_pichange_cancle]  DEFAULT ((0)) FOR [cancle]
GO
ALTER TABLE [dbo].[pichangemain] ADD  CONSTRAINT [DF_pichangemain_requid]  DEFAULT ((0)) FOR [requid]
GO
ALTER TABLE [dbo].[pidetail] ADD  CONSTRAINT [DF_pidetail_chgdate]  DEFAULT (getdate()) FOR [chgdate]
GO
ALTER TABLE [dbo].[practicereport] ADD  CONSTRAINT [DF_practicereport_keywordid]  DEFAULT ((1)) FOR [keywordid]
GO
ALTER TABLE [dbo].[remotion] ADD  CONSTRAINT [DF_remotion_creatdate]  DEFAULT (getdate()) FOR [creatdate]
GO
ALTER TABLE [dbo].[rtxmessage] ADD  CONSTRAINT [DF_rtxmessage_title]  DEFAULT ('''') FOR [title]
GO
ALTER TABLE [dbo].[rtxmessage] ADD  CONSTRAINT [DF_rtxmessage_toman]  DEFAULT ('') FOR [toman]
GO
ALTER TABLE [dbo].[rtxmessage] ADD  CONSTRAINT [DF_rtxmessage_creatdate]  DEFAULT (getdate()) FOR [creatdate]
GO
ALTER TABLE [dbo].[rtxmessage] ADD  CONSTRAINT [DF_rtxmessage_sysid]  DEFAULT ((0)) FOR [sysid]
GO
ALTER TABLE [dbo].[shangshigongsi] ADD  CONSTRAINT [DF_shangshigongsi_id]  DEFAULT ((1)) FOR [id]
GO
ALTER TABLE [dbo].[suppliedmaterials] ADD  CONSTRAINT [DF_suppliedmaterials_okpcs]  DEFAULT ((0)) FOR [okpcs]
GO
ALTER TABLE [dbo].[suppliedmaterials] ADD  CONSTRAINT [DF_suppliedmaterials_boxpcs]  DEFAULT ((0)) FOR [boxpcs]
GO
ALTER TABLE [dbo].[supplycapacity] ADD  CONSTRAINT [DF_supplycapacity_quan]  DEFAULT ((0)) FOR [quan]
GO
ALTER TABLE [dbo].[supplycapacity] ADD  CONSTRAINT [DF_supplycapacity_DayQuan]  DEFAULT ((0)) FOR [DayQuan]
GO
ALTER TABLE [dbo].[supplycapacity] ADD  CONSTRAINT [DF_supplycapacity_WeekQuan]  DEFAULT ((0)) FOR [WeekQuan]
GO
ALTER TABLE [dbo].[supplycapacity] ADD  CONSTRAINT [DF_supplycapacity_Rand]  DEFAULT ((0)) FOR [Rand]
GO
ALTER TABLE [dbo].[supplycapacity] ADD  CONSTRAINT [DF_supplycapacity_randtime]  DEFAULT ((0)) FOR [randtime]
GO
ALTER TABLE [dbo].[systeminfo] ADD  CONSTRAINT [DF_systeminfo_addr]  DEFAULT ('') FOR [addr]
GO
ALTER TABLE [dbo].[systeminfo] ADD  CONSTRAINT [DF_systeminfo_contact]  DEFAULT ('') FOR [contact]
GO
ALTER TABLE [dbo].[systeminfo] ADD  CONSTRAINT [DF_systeminfo_phone]  DEFAULT ('') FOR [phone]
GO
ALTER TABLE [dbo].[systeminfo] ADD  CONSTRAINT [DF_systeminfo_email]  DEFAULT ('') FOR [email]
GO
ALTER TABLE [dbo].[systeminfo] ADD  CONSTRAINT [DF_systeminfo_bp]  DEFAULT ('') FOR [bp]
GO
ALTER TABLE [dbo].[systeminfo] ADD  CONSTRAINT [DF_systeminfo_stop]  DEFAULT ((0)) FOR [start]
GO
ALTER TABLE [dbo].[tao_sale_order_bop] ADD  CONSTRAINT [DF_tao_sale_order_bop_creatdate]  DEFAULT (getdate()) FOR [creatdate]
GO
ALTER TABLE [dbo].[tao_sale_order_bop] ADD  CONSTRAINT [DF_tao_sale_order_bop_id]  DEFAULT ((0)) FOR [id]
GO
ALTER TABLE [dbo].[testmach] ADD  CONSTRAINT [DF_testmach_intest]  DEFAULT ((0)) FOR [intest]
GO
ALTER TABLE [dbo].[testplan] ADD  CONSTRAINT [DF_testplan_worktime]  DEFAULT ((0)) FOR [worktime]
GO
ALTER TABLE [dbo].[testplan] ADD  CONSTRAINT [DF_testplan_outworktime]  DEFAULT ((0)) FOR [outworktime]
GO
ALTER TABLE [dbo].[testplan] ADD  CONSTRAINT [DF_testplan_pcs]  DEFAULT ((0)) FOR [pcs]
GO
ALTER TABLE [dbo].[testplan] ADD  CONSTRAINT [DF_testplan_etime]  DEFAULT ((0)) FOR [etime]
GO
ALTER TABLE [dbo].[testplan] ADD  CONSTRAINT [DF_testplan_htime]  DEFAULT ((0)) FOR [htime]
GO
ALTER TABLE [dbo].[testrequ] ADD  CONSTRAINT [DF_testrequ_chkid]  DEFAULT ((0)) FOR [chkid]
GO
ALTER TABLE [dbo].[testrequ] ADD  CONSTRAINT [DF_testrequ_appid]  DEFAULT ((0)) FOR [appid]
GO
ALTER TABLE [dbo].[testrequ] ADD  CONSTRAINT [DF_testrequ_requid]  DEFAULT ((0)) FOR [requid]
GO
ALTER TABLE [dbo].[testrequ] ADD  CONSTRAINT [DF_testrequ_endid]  DEFAULT ((0)) FOR [endid]
GO
ALTER TABLE [dbo].[testrequ] ADD  CONSTRAINT [DF_testrequ_planid]  DEFAULT ((0)) FOR [planid]
GO
ALTER TABLE [dbo].[testrequdetail] ADD  CONSTRAINT [DF_testrequdetail_testpara]  DEFAULT ((0)) FOR [testpara]
GO
ALTER TABLE [dbo].[testrequdetail] ADD  CONSTRAINT [DF_testrequdetail_dismounting]  DEFAULT ((0)) FOR [dismounting]
GO
ALTER TABLE [dbo].[testrequdetail] ADD  CONSTRAINT [DF_testrequdetail_testtime]  DEFAULT ((0)) FOR [testtime]
GO
ALTER TABLE [dbo].[testrequdetail] ADD  CONSTRAINT [DF_testrequdetail_exportfile]  DEFAULT ((0)) FOR [exportfile]
GO
ALTER TABLE [dbo].[testrequdetail] ADD  CONSTRAINT [DF_testrequdetail_ok]  DEFAULT ((0)) FOR [ok]
GO
ALTER TABLE [dbo].[testrequdetail] ADD  CONSTRAINT [DF_testrequdetail_beforetemperature]  DEFAULT ((0)) FOR [beforetemperature]
GO
ALTER TABLE [dbo].[testrequdetail] ADD  CONSTRAINT [DF_testrequdetail_aftetemperature]  DEFAULT ((0)) FOR [aftetemperature]
GO
ALTER TABLE [dbo].[testrequdetail] ADD  CONSTRAINT [DF_testrequdetail_beforehumidity]  DEFAULT ((0)) FOR [beforehumidity]
GO
ALTER TABLE [dbo].[testrequdetail] ADD  CONSTRAINT [DF_testrequdetail_afterhumidity]  DEFAULT ((0)) FOR [afterhumidity]
GO
ALTER TABLE [dbo].[testrequdetail] ADD  CONSTRAINT [DF_testrequdetail_planid]  DEFAULT ((0)) FOR [planid]
GO
ALTER TABLE [dbo].[testrequdetail] ADD  CONSTRAINT [DF_testrequdetail_submitchkid]  DEFAULT ((0)) FOR [submitchkid]
GO
ALTER TABLE [dbo].[testrequdetail] ADD  CONSTRAINT [DF_testrequdetail_machman]  DEFAULT ('') FOR [machman]
GO
ALTER TABLE [dbo].[testrequdetail] ADD  CONSTRAINT [DF_testrequdetail_intest]  DEFAULT ((0)) FOR [intest]
GO
ALTER TABLE [dbo].[workdaily] ADD  CONSTRAINT [DF_workdaily_text4]  DEFAULT ((0)) FOR [text4]
GO
ALTER TABLE [dbo].[workdaily] ADD  CONSTRAINT [DF_workdaily_text5]  DEFAULT ((0)) FOR [text5]
GO
ALTER TABLE [dbo].[workdaily] ADD  CONSTRAINT [DF_workdaily_text6]  DEFAULT ((0)) FOR [text6]
GO
ALTER TABLE [dbo].[workdaily] ADD  CONSTRAINT [DF_workdaily_text7]  DEFAULT ((0)) FOR [text7]
GO
ALTER TABLE [dbo].[workdaily] ADD  CONSTRAINT [DF_workdaily_text8]  DEFAULT ((0)) FOR [text8]
GO
ALTER TABLE [dbo].[workdaily] ADD  CONSTRAINT [DF_workdaily_text9]  DEFAULT ((0)) FOR [text9]
GO
ALTER TABLE [dbo].[workdaily] ADD  CONSTRAINT [DF_workdaily_text10]  DEFAULT ((0)) FOR [text10]
GO
ALTER TABLE [dbo].[workdaily] ADD  CONSTRAINT [DF_workdaily_chkid]  DEFAULT ((0)) FOR [chkid]
GO
ALTER TABLE [dbo].[workdaily] ADD  CONSTRAINT [DF_workdaily_diagnosis]  DEFAULT ((0)) FOR [diagnosis]
GO
ALTER TABLE [dbo].[workdaily] ADD  CONSTRAINT [DF_workdaily_billid]  DEFAULT ((0)) FOR [billid]
GO
ALTER TABLE [dbo].[auth_group_permissions]  WITH CHECK ADD  CONSTRAINT [auth_group_permissions_group_id_b120cbf9_fk_auth_group_id] FOREIGN KEY([group_id])
REFERENCES [dbo].[auth_group] ([id])
GO
ALTER TABLE [dbo].[auth_group_permissions] CHECK CONSTRAINT [auth_group_permissions_group_id_b120cbf9_fk_auth_group_id]
GO
ALTER TABLE [dbo].[auth_group_permissions]  WITH CHECK ADD  CONSTRAINT [auth_group_permissions_permission_id_84c5c92e_fk_auth_permission_id] FOREIGN KEY([permission_id])
REFERENCES [dbo].[auth_permission] ([id])
GO
ALTER TABLE [dbo].[auth_group_permissions] CHECK CONSTRAINT [auth_group_permissions_permission_id_84c5c92e_fk_auth_permission_id]
GO
ALTER TABLE [dbo].[auth_permission]  WITH CHECK ADD  CONSTRAINT [auth_permission_content_type_id_2f476e4b_fk_django_content_type_id] FOREIGN KEY([content_type_id])
REFERENCES [dbo].[django_content_type] ([id])
GO
ALTER TABLE [dbo].[auth_permission] CHECK CONSTRAINT [auth_permission_content_type_id_2f476e4b_fk_django_content_type_id]
GO
ALTER TABLE [dbo].[auth_user_groups]  WITH CHECK ADD  CONSTRAINT [auth_user_groups_group_id_97559544_fk_auth_group_id] FOREIGN KEY([group_id])
REFERENCES [dbo].[auth_group] ([id])
GO
ALTER TABLE [dbo].[auth_user_groups] CHECK CONSTRAINT [auth_user_groups_group_id_97559544_fk_auth_group_id]
GO
ALTER TABLE [dbo].[auth_user_groups]  WITH CHECK ADD  CONSTRAINT [auth_user_groups_user_id_6a12ed8b_fk_auth_user_id] FOREIGN KEY([user_id])
REFERENCES [dbo].[auth_user] ([id])
GO
ALTER TABLE [dbo].[auth_user_groups] CHECK CONSTRAINT [auth_user_groups_user_id_6a12ed8b_fk_auth_user_id]
GO
ALTER TABLE [dbo].[auth_user_user_permissions]  WITH CHECK ADD  CONSTRAINT [auth_user_user_permissions_permission_id_1fbb5f2c_fk_auth_permission_id] FOREIGN KEY([permission_id])
REFERENCES [dbo].[auth_permission] ([id])
GO
ALTER TABLE [dbo].[auth_user_user_permissions] CHECK CONSTRAINT [auth_user_user_permissions_permission_id_1fbb5f2c_fk_auth_permission_id]
GO
ALTER TABLE [dbo].[auth_user_user_permissions]  WITH CHECK ADD  CONSTRAINT [auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id] FOREIGN KEY([user_id])
REFERENCES [dbo].[auth_user] ([id])
GO
ALTER TABLE [dbo].[auth_user_user_permissions] CHECK CONSTRAINT [auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id]
GO
ALTER TABLE [dbo].[django_admin_log]  WITH CHECK ADD  CONSTRAINT [django_admin_log_content_type_id_c4bce8eb_fk_django_content_type_id] FOREIGN KEY([content_type_id])
REFERENCES [dbo].[django_content_type] ([id])
GO
ALTER TABLE [dbo].[django_admin_log] CHECK CONSTRAINT [django_admin_log_content_type_id_c4bce8eb_fk_django_content_type_id]
GO
ALTER TABLE [dbo].[django_admin_log]  WITH CHECK ADD  CONSTRAINT [django_admin_log_user_id_c564eba6_fk_auth_user_id] FOREIGN KEY([user_id])
REFERENCES [dbo].[auth_user] ([id])
GO
ALTER TABLE [dbo].[django_admin_log] CHECK CONSTRAINT [django_admin_log_user_id_c564eba6_fk_auth_user_id]
GO
ALTER TABLE [dbo].[xadmin_bookmark]  WITH CHECK ADD  CONSTRAINT [xadmin_bookmark_content_type_id_60941679_fk_django_content_type_id] FOREIGN KEY([content_type_id])
REFERENCES [dbo].[django_content_type] ([id])
GO
ALTER TABLE [dbo].[xadmin_bookmark] CHECK CONSTRAINT [xadmin_bookmark_content_type_id_60941679_fk_django_content_type_id]
GO
ALTER TABLE [dbo].[xadmin_bookmark]  WITH CHECK ADD  CONSTRAINT [xadmin_bookmark_user_id_42d307fc_fk_auth_user_id] FOREIGN KEY([user_id])
REFERENCES [dbo].[auth_user] ([id])
GO
ALTER TABLE [dbo].[xadmin_bookmark] CHECK CONSTRAINT [xadmin_bookmark_user_id_42d307fc_fk_auth_user_id]
GO
ALTER TABLE [dbo].[xadmin_log]  WITH CHECK ADD  CONSTRAINT [xadmin_log_content_type_id_2a6cb852_fk_django_content_type_id] FOREIGN KEY([content_type_id])
REFERENCES [dbo].[django_content_type] ([id])
GO
ALTER TABLE [dbo].[xadmin_log] CHECK CONSTRAINT [xadmin_log_content_type_id_2a6cb852_fk_django_content_type_id]
GO
ALTER TABLE [dbo].[xadmin_log]  WITH CHECK ADD  CONSTRAINT [xadmin_log_user_id_bb16a176_fk_auth_user_id] FOREIGN KEY([user_id])
REFERENCES [dbo].[auth_user] ([id])
GO
ALTER TABLE [dbo].[xadmin_log] CHECK CONSTRAINT [xadmin_log_user_id_bb16a176_fk_auth_user_id]
GO
ALTER TABLE [dbo].[xadmin_usersettings]  WITH CHECK ADD  CONSTRAINT [xadmin_usersettings_user_id_edeabe4a_fk_auth_user_id] FOREIGN KEY([user_id])
REFERENCES [dbo].[auth_user] ([id])
GO
ALTER TABLE [dbo].[xadmin_usersettings] CHECK CONSTRAINT [xadmin_usersettings_user_id_edeabe4a_fk_auth_user_id]
GO
ALTER TABLE [dbo].[xadmin_userwidget]  WITH CHECK ADD  CONSTRAINT [xadmin_userwidget_user_id_c159233a_fk_auth_user_id] FOREIGN KEY([user_id])
REFERENCES [dbo].[auth_user] ([id])
GO
ALTER TABLE [dbo].[xadmin_userwidget] CHECK CONSTRAINT [xadmin_userwidget_user_id_c159233a_fk_auth_user_id]
GO
ALTER TABLE [dbo].[django_admin_log]  WITH CHECK ADD  CONSTRAINT [django_admin_log_action_flag_a8637d59_check] CHECK  (([action_flag]>=(0)))
GO
ALTER TABLE [dbo].[django_admin_log] CHECK CONSTRAINT [django_admin_log_action_flag_a8637d59_check]
GO
/****** Object:  StoredProcedure [dbo].[everylog]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE  [dbo].[everylog]
  @cUserName char(40),@CfileName char(30),@Cid char(50),@CEditMode char(10),@Cmac char(20)
 as 
--declare @i datetime  
--set   @i= getdate() 
Insert Into everyday (username,datetime,filename,id,editmode,mac) VALUES (@cUserName,getdate(),@CfileName,@Cid,@CEditMode,@Cmac)

--UPDATE EveryDay
--  SET id = id + 1,
--      @nRetval = id + 1
--WHERE TableName = @cName
GO
/****** Object:  StoredProcedure [dbo].[Performance_Trace_StopAll]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  proc [dbo].[Performance_Trace_StopAll] 

 

AS 

    declare traceCursor cursor for select id from sys.traces where id <> 1 

    open traceCursor 

    declare @curid int 

    fetch next from traceCursor into @curid 

    while(@@fetch_status=0) 

      begin          

 

          exec  sp_trace_setstatus @curid,0 

          exec  sp_trace_setstatus @curid,2 

          fetch next from traceCursor into @curid 

      end 

    close traceCursor 

    deallocate traceCursor 
GO
/****** Object:  StoredProcedure [dbo].[rwf_insert_]    Script Date: 2021/10/21 17:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[rwf_insert_] @aBig char(4), @a1 int, @a2 int, @a3 char(30), @a4 char(20), @a5 int, @a6 int, @a7 int, @a8 int, @a9 int, @a10 bit, @a11 bit, @a12 bit, @a13 bit, @a14 char(20), @a15 int, @a16 int, @a17 char(30), @a18 char(20), @a19 int, @a20 int, @a21 int, @a22 int, @a23 int, @a24 bit, @a25 bit, @a26 bit, @a27 bit, @a28 char(20), @a29 int, @a30 int, @a31 char(30), @a32 char(20), @a33 int, @a34 int, @a35 int, @a36 int, @a37 int, @a38 bit, @a39 bit, @a40 bit, @a41 bit, @a42 char(20), @a43 int, @a44 int, @a45 char(30), @a46 char(20), @a47 int, @a48 int, @a49 int, @a50 int, @a51 int, @a52 bit, @a53 bit, @a54 bit, @a55 bit, @a56 char(20), @a57 int, @a58 int, @a59 char(30), @a60 char(20), @a61 int, @a62 int, @a63 int, @a64 int, @a65 int, @a66 bit, @a67 bit, @a68 bit, @a69 bit, @a70 char(20), @a71 int, @a72 int, @a73 char(30), @a74 char(20), @a75 int, @a76 int, @a77 int, @a78 int, @a79 int, @a80 bit, @a81 bit, @a82 bit, @a83 bit, @a84 char(20), @a85 int, @a86 int, @a87 char(30), @a88 char(20), @a89 int, @a90 int, @a91 int, @a92 int, @a93 int, @a94 bit, @a95 bit, @a96 bit, @a97 bit, @a98 char(20), @a99 int, @a100 int, @a101 char(30), @a102 char(20), @a103 int, @a104 int, @a105 int, @a106 int, @a107 int, @a108 bit, @a109 bit, @a110 bit, @a111 bit, @a112 char(20), @a113 int, @a114 int, @a115 char(30), @a116 char(20), @a117 int, @a118 int, @a119 int, @a120 int, @a121 int, @a122 bit, @a123 bit, @a124 bit, @a125 bit, @a126 char(20), @a127 int, @a128 int, @a129 char(30), @a130 char(20), @a131 int, @a132 int, @a133 int, @a134 int, @a135 int, @a136 bit, @a137 bit, @a138 bit, @a139 bit, @a140 char(20), @a141 int, @a142 int, @a143 char(30), @a144 char(20), @a145 int, @a146 int, @a147 int, @a148 int, @a149 int, @a150 bit, @a151 bit, @a152 bit, @a153 bit, @a154 char(20), @a155 int, @a156 int, @a157 char(30), @a158 char(20), @a159 int, @a160 int, @a161 int, @a162 int, @a163 int, @a164 bit, @a165 bit, @a166 bit, @a167 bit, @a168 char(20), @a169 int, @a170 int, @a171 char(30), @a172 char(20), @a173 int, @a174 int, @a175 int, @a176 int, @a177 int, @a178 bit, @a179 bit, @a180 bit, @a181 bit, @a182 char(20), @a183 int, @a184 int, @a185 char(30), @a186 char(20), @a187 int, @a188 int, @a189 int, @a190 int, @a191 int, @a192 bit, @a193 bit, @a194 bit, @a195 bit, @a196 char(20), @a197 int, @a198 int, @a199 char(30), @a200 char(20), @a201 int, @a202 int, @a203 int, @a204 int, @a205 int, @a206 bit, @a207 bit, @a208 bit, @a209 bit, @a210 char(20), @a211 int, @a212 int, @a213 char(30), @a214 char(20), @a215 int, @a216 int, @a217 int, @a218 int, @a219 int, @a220 bit, @a221 bit, @a222 bit, @a223 bit, @a224 char(20), @a225 int, @a226 int, @a227 char(30), @a228 char(20), @a229 int, @a230 int, @a231 int, @a232 int, @a233 int, @a234 bit, @a235 bit, @a236 bit, @a237 bit, @a238 char(20), @a239 int, @a240 int, @a241 char(30), @a242 char(20), @a243 int, @a244 int, @a245 int, @a246 int, @a247 int, @a248 bit, @a249 bit, @a250 bit, @a251 bit, @a252 char(20) AS 
INSERT INTO lhb (frootid,fchildid,fcode,fname,flayer,fqty,fchildqty,ffirstnode,flastnode,fvisible,fnode,fopen,fcheck,fpicid) 
VALUES (@a1, @a2, @a3, @a4, @a5, @a6, @a7, @a8, @a9, @a10, @a11, @a12, @a13, @a14)
INSERT INTO lhb (frootid,fchildid,fcode,fname,flayer,fqty,fchildqty,ffirstnode,flastnode,fvisible,fnode,fopen,fcheck,fpicid) 
VALUES (@a15, @a16, @a17, @a18, @a19, @a20, @a21, @a22, @a23, @a24, @a25, @a26, @a27, @a28)
INSERT INTO lhb (frootid,fchildid,fcode,fname,flayer,fqty,fchildqty,ffirstnode,flastnode,fvisible,fnode,fopen,fcheck,fpicid) 
VALUES (@a29, @a30, @a31, @a32, @a33, @a34, @a35, @a36, @a37, @a38, @a39, @a40, @a41, @a42)
INSERT INTO lhb (frootid,fchildid,fcode,fname,flayer,fqty,fchildqty,ffirstnode,flastnode,fvisible,fnode,fopen,fcheck,fpicid) 
VALUES (@a43, @a44, @a45, @a46, @a47, @a48, @a49, @a50, @a51, @a52, @a53, @a54, @a55, @a56)
INSERT INTO lhb (frootid,fchildid,fcode,fname,flayer,fqty,fchildqty,ffirstnode,flastnode,fvisible,fnode,fopen,fcheck,fpicid) 
VALUES (@a57, @a58, @a59, @a60, @a61, @a62, @a63, @a64, @a65, @a66, @a67, @a68, @a69, @a70)
INSERT INTO lhb (frootid,fchildid,fcode,fname,flayer,fqty,fchildqty,ffirstnode,flastnode,fvisible,fnode,fopen,fcheck,fpicid) 
VALUES (@a71, @a72, @a73, @a74, @a75, @a76, @a77, @a78, @a79, @a80, @a81, @a82, @a83, @a84)
IF @aBig = 'TRUE'
BEGIN
INSERT INTO lhb (frootid,fchildid,fcode,fname,flayer,fqty,fchildqty,ffirstnode,flastnode,fvisible,fnode,fopen,fcheck,fpicid) 
VALUES (@a85, @a86, @a87, @a88, @a89, @a90, @a91, @a92, @a93, @a94, @a95, @a96, @a97, @a98)
INSERT INTO lhb (frootid,fchildid,fcode,fname,flayer,fqty,fchildqty,ffirstnode,flastnode,fvisible,fnode,fopen,fcheck,fpicid) 
VALUES (@a99, @a100, @a101, @a102, @a103, @a104, @a105, @a106, @a107, @a108, @a109, @a110, @a111, @a112)
INSERT INTO lhb (frootid,fchildid,fcode,fname,flayer,fqty,fchildqty,ffirstnode,flastnode,fvisible,fnode,fopen,fcheck,fpicid) 
VALUES (@a113, @a114, @a115, @a116, @a117, @a118, @a119, @a120, @a121, @a122, @a123, @a124, @a125, @a126)
INSERT INTO lhb (frootid,fchildid,fcode,fname,flayer,fqty,fchildqty,ffirstnode,flastnode,fvisible,fnode,fopen,fcheck,fpicid) 
VALUES (@a127, @a128, @a129, @a130, @a131, @a132, @a133, @a134, @a135, @a136, @a137, @a138, @a139, @a140)
INSERT INTO lhb (frootid,fchildid,fcode,fname,flayer,fqty,fchildqty,ffirstnode,flastnode,fvisible,fnode,fopen,fcheck,fpicid) 
VALUES (@a141, @a142, @a143, @a144, @a145, @a146, @a147, @a148, @a149, @a150, @a151, @a152, @a153, @a154)
INSERT INTO lhb (frootid,fchildid,fcode,fname,flayer,fqty,fchildqty,ffirstnode,flastnode,fvisible,fnode,fopen,fcheck,fpicid) 
VALUES (@a155, @a156, @a157, @a158, @a159, @a160, @a161, @a162, @a163, @a164, @a165, @a166, @a167, @a168)
INSERT INTO lhb (frootid,fchildid,fcode,fname,flayer,fqty,fchildqty,ffirstnode,flastnode,fvisible,fnode,fopen,fcheck,fpicid) 
VALUES (@a169, @a170, @a171, @a172, @a173, @a174, @a175, @a176, @a177, @a178, @a179, @a180, @a181, @a182)
INSERT INTO lhb (frootid,fchildid,fcode,fname,flayer,fqty,fchildqty,ffirstnode,flastnode,fvisible,fnode,fopen,fcheck,fpicid) 
VALUES (@a183, @a184, @a185, @a186, @a187, @a188, @a189, @a190, @a191, @a192, @a193, @a194, @a195, @a196)
INSERT INTO lhb (frootid,fchildid,fcode,fname,flayer,fqty,fchildqty,ffirstnode,flastnode,fvisible,fnode,fopen,fcheck,fpicid) 
VALUES (@a197, @a198, @a199, @a200, @a201, @a202, @a203, @a204, @a205, @a206, @a207, @a208, @a209, @a210)
INSERT INTO lhb (frootid,fchildid,fcode,fname,flayer,fqty,fchildqty,ffirstnode,flastnode,fvisible,fnode,fopen,fcheck,fpicid) 
VALUES (@a211, @a212, @a213, @a214, @a215, @a216, @a217, @a218, @a219, @a220, @a221, @a222, @a223, @a224)
INSERT INTO lhb (frootid,fchildid,fcode,fname,flayer,fqty,fchildqty,ffirstnode,flastnode,fvisible,fnode,fopen,fcheck,fpicid) 
VALUES (@a225, @a226, @a227, @a228, @a229, @a230, @a231, @a232, @a233, @a234, @a235, @a236, @a237, @a238)
INSERT INTO lhb (frootid,fchildid,fcode,fname,flayer,fqty,fchildqty,ffirstnode,flastnode,fvisible,fnode,fopen,fcheck,fpicid) 
VALUES (@a239, @a240, @a241, @a242, @a243, @a244, @a245, @a246, @a247, @a248, @a249, @a250, @a251, @a252)
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'addendancesource'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AdjustTable'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'approve'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'approveaction'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AskLevel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AttdanceBalance'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'attendancereal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'班次' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'attendancerecord', @level2type=N'COLUMN',@level2name=N'frequency'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'attendancerecord'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AuditLog'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ddddd' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'backfire', @level2type=N'COLUMN',@level2name=N'interid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'gggg' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'backfire', @level2type=N'COLUMN',@level2name=N'num'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'backfire', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'backfire'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'bankname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BankRecord'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'billpic'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'附件ＩＤ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'daily', @level2type=N'COLUMN',@level2name=N'FileID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MakePlanDetail1', @level2type=N'COLUMN',@level2name=N'InterID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MakePlanDetail1', @level2type=N'COLUMN',@level2name=N'Note'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'实习开始时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'practicereport', @level2type=N'COLUMN',@level2name=N'timefrom'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'实习截止时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'practicereport', @level2type=N'COLUMN',@level2name=N'timeto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'实习人员' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'practicereport', @level2type=N'COLUMN',@level2name=N'trainee'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'实习部门' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'practicereport', @level2type=N'COLUMN',@level2name=N'dept'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'实习内容' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'practicereport', @level2type=N'COLUMN',@level2name=N'contents'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'备注' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'practicereport', @level2type=N'COLUMN',@level2name=N'note'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'编号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'practicereport', @level2type=N'COLUMN',@level2name=N'keywordid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SalaryTable'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'salehistory'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'selfreport'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "getsmm"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 146
               Right = 182
            End
            DisplayFlags = 280
            TopColumn = 3
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'testview'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'testview'
GO
USE [master]
GO
ALTER DATABASE [trade] SET  READ_WRITE 
GO
