USE [master]
GO

/****** Object:  Database [FoldingCoin]    Script Date: 1/4/2018 3:56:54 PM ******/
CREATE DATABASE [FoldingCoin] CONTAINMENT = NONE ON PRIMARY (
	NAME = N'FoldingCoin'
	,FILENAME = N'F:\Databases\FoldingCoin.mdf'
	,SIZE = 4096 KB
	,MAXSIZE = UNLIMITED
	,FILEGROWTH = 1024 KB
	) LOG ON (
	NAME = N'FoldingCoin_log'
	,FILENAME = N'F:\Databases\FoldingCoin_log.ldf'
	,SIZE = 1024 KB
	,MAXSIZE = 2048 GB
	,FILEGROWTH = 10 %
	)
GO

ALTER DATABASE [FoldingCoin]

SET COMPATIBILITY_LEVEL = 110
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
BEGIN
	EXEC [FoldingCoin].[dbo].[sp_fulltext_database] @action = 'enable'
END
GO

ALTER DATABASE [FoldingCoin]

SET ANSI_NULL_DEFAULT OFF
GO

ALTER DATABASE [FoldingCoin]

SET ANSI_NULLS OFF
GO

ALTER DATABASE [FoldingCoin]

SET ANSI_PADDING OFF
GO

ALTER DATABASE [FoldingCoin]

SET ANSI_WARNINGS OFF
GO

ALTER DATABASE [FoldingCoin]

SET ARITHABORT OFF
GO

ALTER DATABASE [FoldingCoin]

SET AUTO_CLOSE OFF
GO

ALTER DATABASE [FoldingCoin]

SET AUTO_CREATE_STATISTICS ON
GO

ALTER DATABASE [FoldingCoin]

SET AUTO_SHRINK OFF
GO

ALTER DATABASE [FoldingCoin]

SET AUTO_UPDATE_STATISTICS ON
GO

ALTER DATABASE [FoldingCoin]

SET CURSOR_CLOSE_ON_COMMIT OFF
GO

ALTER DATABASE [FoldingCoin]

SET CURSOR_DEFAULT GLOBAL
GO

ALTER DATABASE [FoldingCoin]

SET CONCAT_NULL_YIELDS_NULL OFF
GO

ALTER DATABASE [FoldingCoin]

SET NUMERIC_ROUNDABORT OFF
GO

ALTER DATABASE [FoldingCoin]

SET QUOTED_IDENTIFIER OFF
GO

ALTER DATABASE [FoldingCoin]

SET RECURSIVE_TRIGGERS OFF
GO

ALTER DATABASE [FoldingCoin]

SET DISABLE_BROKER
GO

ALTER DATABASE [FoldingCoin]

SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO

ALTER DATABASE [FoldingCoin]

SET DATE_CORRELATION_OPTIMIZATION OFF
GO

ALTER DATABASE [FoldingCoin]

SET TRUSTWORTHY OFF
GO

ALTER DATABASE [FoldingCoin]

SET ALLOW_SNAPSHOT_ISOLATION OFF
GO

ALTER DATABASE [FoldingCoin]

SET PARAMETERIZATION SIMPLE
GO

ALTER DATABASE [FoldingCoin]

SET READ_COMMITTED_SNAPSHOT OFF
GO

ALTER DATABASE [FoldingCoin]

SET HONOR_BROKER_PRIORITY OFF
GO

ALTER DATABASE [FoldingCoin]

SET RECOVERY FULL
GO

ALTER DATABASE [FoldingCoin]

SET MULTI_USER
GO

ALTER DATABASE [FoldingCoin]

SET PAGE_VERIFY CHECKSUM
GO

ALTER DATABASE [FoldingCoin]

SET DB_CHAINING OFF
GO

ALTER DATABASE [FoldingCoin]

SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF)
GO

ALTER DATABASE [FoldingCoin]

SET TARGET_RECOVERY_TIME = 0 SECONDS
GO

EXEC sys.sp_db_vardecimal_storage_format N'FoldingCoin'
	,N'ON'
GO

USE [FoldingCoin]
GO

/****** Object:  Schema [FoldingCoin]    Script Date: 1/4/2018 3:56:54 PM ******/
CREATE SCHEMA [FoldingCoin]
GO

/****** Object:  Table [FoldingCoin].[Downloads]    Script Date: 1/4/2018 3:56:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [FoldingCoin].[Downloads] (
	[DownloadId] [int] IDENTITY(1, 1) NOT NULL
	,[StatusId] [int] NOT NULL
	,[FileId] [int] NOT NULL
	,[DownloadDateTime] [datetime] NOT NULL
	,CONSTRAINT [PK_Downloads] PRIMARY KEY CLUSTERED ([DownloadId] ASC) WITH (
		PAD_INDEX = OFF
		,STATISTICS_NORECOMPUTE = OFF
		,IGNORE_DUP_KEY = OFF
		,ALLOW_ROW_LOCKS = ON
		,ALLOW_PAGE_LOCKS = ON
		) ON [PRIMARY]
	) ON [PRIMARY]
GO

/****** Object:  Table [FoldingCoin].[FAHData]    Script Date: 1/4/2018 3:56:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [FoldingCoin].[FAHData] (
	[FAHDataId] [int] IDENTITY(1, 1) NOT NULL
	,[UserName] [nvarchar](50) NOT NULL
	,[TotalPoints] [nvarchar](50) NOT NULL
	,[WorkUnit] [nvarchar](50) NOT NULL
	,[TeamNumber] [nvarchar](50) NOT NULL
	,CONSTRAINT [PK_FAHData] PRIMARY KEY CLUSTERED ([FAHDataId] ASC) WITH (
		PAD_INDEX = OFF
		,STATISTICS_NORECOMPUTE = OFF
		,IGNORE_DUP_KEY = OFF
		,ALLOW_ROW_LOCKS = ON
		,ALLOW_PAGE_LOCKS = ON
		) ON [PRIMARY]
	) ON [PRIMARY]
GO

/****** Object:  Table [FoldingCoin].[FAHDataRuns]    Script Date: 1/4/2018 3:56:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [FoldingCoin].[FAHDataRuns] (
	[FAHDataId] [int] NOT NULL
	,[DownloadId] [int] NOT NULL
	,[TeamMemberId] [int] NOT NULL
	,[VersionId] [int] NULL
	,[RunDataId] [int] NOT NULL
	) ON [PRIMARY]
GO

/****** Object:  Table [FoldingCoin].[Files]    Script Date: 1/4/2018 3:56:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [FoldingCoin].[Files] (
	[FileId] [int] IDENTITY(1, 1) NOT NULL
	,[FileName] [nvarchar](50) NOT NULL
	,[FileExtension] [nvarchar](5) NOT NULL
	,[FileData] [nvarchar](max) NOT NULL
	,CONSTRAINT [PK_Files] PRIMARY KEY CLUSTERED ([FileId] ASC) WITH (
		PAD_INDEX = OFF
		,STATISTICS_NORECOMPUTE = OFF
		,IGNORE_DUP_KEY = OFF
		,ALLOW_ROW_LOCKS = ON
		,ALLOW_PAGE_LOCKS = ON
		) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [FoldingCoin].[Rejections]    Script Date: 1/4/2018 3:56:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [FoldingCoin].[Rejections] (
	[RejectionId] [int] IDENTITY(1, 1) NOT NULL
	,[FAHDataId] [int] NOT NULL
	,[VersionId] [int] NULL
	,[LineNumber] [int] NOT NULL
	,[Reason] [nvarchar](500) NOT NULL
	,CONSTRAINT [PK_Rejections] PRIMARY KEY CLUSTERED ([RejectionId] ASC) WITH (
		PAD_INDEX = OFF
		,STATISTICS_NORECOMPUTE = OFF
		,IGNORE_DUP_KEY = OFF
		,ALLOW_ROW_LOCKS = ON
		,ALLOW_PAGE_LOCKS = ON
		) ON [PRIMARY]
	) ON [PRIMARY]
GO

/****** Object:  Table [FoldingCoin].[RunData]    Script Date: 1/4/2018 3:56:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [FoldingCoin].[RunData] (
	[RunDataId] [int] IDENTITY(1, 1) NOT NULL
	,[VersionId] [int] NOT NULL
	,[RunDate] [date] NOT NULL
	,[LastRunTime] [time](7) NOT NULL
	,[NumberOfRuns] [int] NOT NULL
	,CONSTRAINT [PK_RunData] PRIMARY KEY CLUSTERED (
		[RunDataId] ASC
		,[VersionId] ASC
		) WITH (
		PAD_INDEX = OFF
		,STATISTICS_NORECOMPUTE = OFF
		,IGNORE_DUP_KEY = OFF
		,ALLOW_ROW_LOCKS = ON
		,ALLOW_PAGE_LOCKS = ON
		) ON [PRIMARY]
	) ON [PRIMARY]
GO

/****** Object:  Table [FoldingCoin].[Statuses]    Script Date: 1/4/2018 3:56:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [FoldingCoin].[Statuses] (
	[StatusId] [int] IDENTITY(1, 1) NOT NULL
	,[Status] [nvarchar](50) NOT NULL
	,[StatusDescription] [nvarchar](100) NULL
	,CONSTRAINT [PK_Statuses] PRIMARY KEY CLUSTERED ([StatusId] ASC) WITH (
		PAD_INDEX = OFF
		,STATISTICS_NORECOMPUTE = OFF
		,IGNORE_DUP_KEY = OFF
		,ALLOW_ROW_LOCKS = ON
		,ALLOW_PAGE_LOCKS = ON
		) ON [PRIMARY]
	) ON [PRIMARY]
GO

/****** Object:  Table [FoldingCoin].[TeamMembers]    Script Date: 1/4/2018 3:56:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [FoldingCoin].[TeamMembers] (
	[TeamMemberId] [int] IDENTITY(1, 1) NOT NULL
	,[TeamId] [int] NOT NULL
	,[UserId] [int] NOT NULL
	,CONSTRAINT [PK_TeamMembers] PRIMARY KEY CLUSTERED ([TeamMemberId] ASC) WITH (
		PAD_INDEX = OFF
		,STATISTICS_NORECOMPUTE = OFF
		,IGNORE_DUP_KEY = OFF
		,ALLOW_ROW_LOCKS = ON
		,ALLOW_PAGE_LOCKS = ON
		) ON [PRIMARY]
	) ON [PRIMARY]
GO

/****** Object:  Table [FoldingCoin].[Teams]    Script Date: 1/4/2018 3:56:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [FoldingCoin].[Teams] (
	[TeamId] [int] IDENTITY(1, 1) NOT NULL
	,[TeamNumber] [nvarchar](50) NOT NULL
	,[TeamName] [nvarchar](50) NOT NULL
	,CONSTRAINT [PK_Teams] PRIMARY KEY CLUSTERED ([TeamId] ASC) WITH (
		PAD_INDEX = OFF
		,STATISTICS_NORECOMPUTE = OFF
		,IGNORE_DUP_KEY = OFF
		,ALLOW_ROW_LOCKS = ON
		,ALLOW_PAGE_LOCKS = ON
		) ON [PRIMARY]
	) ON [PRIMARY]
GO

/****** Object:  Table [FoldingCoin].[Users]    Script Date: 1/4/2018 3:56:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [FoldingCoin].[Users] (
	[UserId] [int] IDENTITY(1, 1) NOT NULL
	,[UserName] [nvarchar](50) NOT NULL
	,[FriendlyName] [nvarchar](50) NOT NULL
	,[BitcoinAddress] [nvarchar](50) NOT NULL
	,CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([UserId] ASC) WITH (
		PAD_INDEX = OFF
		,STATISTICS_NORECOMPUTE = OFF
		,IGNORE_DUP_KEY = OFF
		,ALLOW_ROW_LOCKS = ON
		,ALLOW_PAGE_LOCKS = ON
		) ON [PRIMARY]
	,CONSTRAINT [IX_Users] UNIQUE NONCLUSTERED ([UserName] ASC) WITH (
		PAD_INDEX = OFF
		,STATISTICS_NORECOMPUTE = OFF
		,IGNORE_DUP_KEY = OFF
		,ALLOW_ROW_LOCKS = ON
		,ALLOW_PAGE_LOCKS = ON
		) ON [PRIMARY]
	) ON [PRIMARY]
GO

/****** Object:  Table [FoldingCoin].[UserStats]    Script Date: 1/4/2018 3:56:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [FoldingCoin].[UserStats] (
	[UserStatId] [int] IDENTITY(1, 1) NOT NULL
	,[UserId] [int] NOT NULL
	,[StartDateTime] [datetime] NOT NULL
	,[EndDateTime] [datetime] NOT NULL
	,[Points] [nvarchar](50) NOT NULL
	,[FAHDataRunId] [int] NOT NULL
	,CONSTRAINT [PK_UserStats] PRIMARY KEY CLUSTERED ([UserStatId] ASC) WITH (
		PAD_INDEX = OFF
		,STATISTICS_NORECOMPUTE = OFF
		,IGNORE_DUP_KEY = OFF
		,ALLOW_ROW_LOCKS = ON
		,ALLOW_PAGE_LOCKS = ON
		) ON [PRIMARY]
	) ON [PRIMARY]
GO

/****** Object:  Table [FoldingCoin].[Versions]    Script Date: 1/4/2018 3:56:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [FoldingCoin].[Versions] (
	[VersionId] [int] IDENTITY(1, 1) NOT NULL
	,[VersionNumber] [nvarchar](50) NOT NULL
	,[LastRun] [datetime] NOT NULL
	,CONSTRAINT [PK_Versions] PRIMARY KEY CLUSTERED ([VersionId] ASC) WITH (
		PAD_INDEX = OFF
		,STATISTICS_NORECOMPUTE = OFF
		,IGNORE_DUP_KEY = OFF
		,ALLOW_ROW_LOCKS = ON
		,ALLOW_PAGE_LOCKS = ON
		) ON [PRIMARY]
	) ON [PRIMARY]
GO

/****** Object:  Index [IX_FAHDataRuns]    Script Date: 1/4/2018 3:56:54 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_FAHDataRuns] ON [FoldingCoin].[FAHDataRuns] (
	[FAHDataId] ASC
	,[VersionId] ASC
	)
	WITH (
			PAD_INDEX = OFF
			,STATISTICS_NORECOMPUTE = OFF
			,SORT_IN_TEMPDB = OFF
			,IGNORE_DUP_KEY = OFF
			,DROP_EXISTING = OFF
			,ONLINE = OFF
			,ALLOW_ROW_LOCKS = ON
			,ALLOW_PAGE_LOCKS = ON
			) ON [PRIMARY]
GO

ALTER TABLE [FoldingCoin].[Downloads]
	WITH CHECK ADD CONSTRAINT [FK_Downloads_Files] FOREIGN KEY ([FileId]) REFERENCES [FoldingCoin].[Files]([FileId])
GO

ALTER TABLE [FoldingCoin].[Downloads] CHECK CONSTRAINT [FK_Downloads_Files]
GO

ALTER TABLE [FoldingCoin].[Downloads]
	WITH CHECK ADD CONSTRAINT [FK_Downloads_Statuses] FOREIGN KEY ([StatusId]) REFERENCES [FoldingCoin].[Statuses]([StatusId])
GO

ALTER TABLE [FoldingCoin].[Downloads] CHECK CONSTRAINT [FK_Downloads_Statuses]
GO

ALTER TABLE [FoldingCoin].[FAHData]
	WITH CHECK ADD CONSTRAINT [FK_FAHData_Users] FOREIGN KEY ([UserName]) REFERENCES [FoldingCoin].[Users]([UserName])
GO

ALTER TABLE [FoldingCoin].[FAHData] CHECK CONSTRAINT [FK_FAHData_Users]
GO

ALTER TABLE [FoldingCoin].[FAHDataRuns]
	WITH CHECK ADD CONSTRAINT [FK_FAHDataRuns_Downloads] FOREIGN KEY ([DownloadId]) REFERENCES [FoldingCoin].[Downloads]([DownloadId])
GO

ALTER TABLE [FoldingCoin].[FAHDataRuns] CHECK CONSTRAINT [FK_FAHDataRuns_Downloads]
GO

ALTER TABLE [FoldingCoin].[FAHDataRuns]
	WITH CHECK ADD CONSTRAINT [FK_FAHDataRuns_FAHData] FOREIGN KEY ([FAHDataId]) REFERENCES [FoldingCoin].[FAHData]([FAHDataId])
GO

ALTER TABLE [FoldingCoin].[FAHDataRuns] CHECK CONSTRAINT [FK_FAHDataRuns_FAHData]
GO

ALTER TABLE [FoldingCoin].[FAHDataRuns]
	WITH CHECK ADD CONSTRAINT [FK_FAHDataRuns_TeamMembers] FOREIGN KEY ([TeamMemberId]) REFERENCES [FoldingCoin].[TeamMembers]([TeamMemberId])
GO

ALTER TABLE [FoldingCoin].[FAHDataRuns] CHECK CONSTRAINT [FK_FAHDataRuns_TeamMembers]
GO

ALTER TABLE [FoldingCoin].[Rejections]
	WITH CHECK ADD CONSTRAINT [FK_Rejections_FAHDataRuns] FOREIGN KEY (
			[FAHDataId]
			,[VersionId]
			) REFERENCES [FoldingCoin].[FAHDataRuns]([FAHDataId], [VersionId])
GO

ALTER TABLE [FoldingCoin].[Rejections] CHECK CONSTRAINT [FK_Rejections_FAHDataRuns]
GO

ALTER TABLE [FoldingCoin].[RunData]
	WITH CHECK ADD CONSTRAINT [FK_RunData_FAHDataRuns] FOREIGN KEY (
			[RunDataId]
			,[VersionId]
			) REFERENCES [FoldingCoin].[FAHDataRuns]([FAHDataId], [VersionId])
GO

ALTER TABLE [FoldingCoin].[RunData] CHECK CONSTRAINT [FK_RunData_FAHDataRuns]
GO

ALTER TABLE [FoldingCoin].[RunData]
	WITH CHECK ADD CONSTRAINT [FK_RunData_Versions] FOREIGN KEY ([VersionId]) REFERENCES [FoldingCoin].[Versions]([VersionId])
GO

ALTER TABLE [FoldingCoin].[RunData] CHECK CONSTRAINT [FK_RunData_Versions]
GO

ALTER TABLE [FoldingCoin].[TeamMembers]
	WITH CHECK ADD CONSTRAINT [FK_TeamMembers_Teams] FOREIGN KEY ([TeamMemberId]) REFERENCES [FoldingCoin].[Teams]([TeamId])
GO

ALTER TABLE [FoldingCoin].[TeamMembers] CHECK CONSTRAINT [FK_TeamMembers_Teams]
GO

ALTER TABLE [FoldingCoin].[TeamMembers]
	WITH CHECK ADD CONSTRAINT [FK_TeamMembers_Users] FOREIGN KEY ([TeamId]) REFERENCES [FoldingCoin].[Users]([UserId])
GO

ALTER TABLE [FoldingCoin].[TeamMembers] CHECK CONSTRAINT [FK_TeamMembers_Users]
GO

ALTER TABLE [FoldingCoin].[UserStats]
	WITH CHECK ADD CONSTRAINT [FK_UserStats_Users] FOREIGN KEY ([UserId]) REFERENCES [FoldingCoin].[Users]([UserId])
GO

ALTER TABLE [FoldingCoin].[UserStats] CHECK CONSTRAINT [FK_UserStats_Users]
GO

USE [master]
GO

ALTER DATABASE [FoldingCoin]

SET READ_WRITE
GO