CREATE SCHEMA [FoldingCoin]
GO

/****** Object:  Table [FoldingCoin].[Downloads]    Script Date: 7/28/2017 8:34:39 AM ******/
CREATE TABLE [FoldingCoin].[Downloads](
	[DownloadId] [int] IDENTITY(1,1) NOT NULL,
	[StatusId] [int] NOT NULL,
	[FileId] [int] NOT NULL,
	[DownloadDateTime] [datetime] NOT NULL,
	[ErrorMessage] [nvarchar](500) NOT NULL
 CONSTRAINT [PK_Downloads] PRIMARY KEY CLUSTERED 
(
	[DownloadId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [FoldingCoin].[FAHData]    Script Date: 7/28/2017 8:34:39 AM ******/
CREATE TABLE [FoldingCoin].[FAHData](
	[FAHDataId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[TotalPoints] [nvarchar](50) NOT NULL,
	[WorkUnit] [nvarchar](50) NOT NULL,
	[TeamNumber] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_FAHData] PRIMARY KEY CLUSTERED 
(
	[FAHDataId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [FoldingCoin].[FAHDataRuns]    Script Date: 7/28/2017 8:34:39 AM ******/
CREATE TABLE [FoldingCoin].[FAHDataRuns](
	[FAHDataId] [int] NOT NULL,
	[DownloadId] [int] NOT NULL,
	[VersionId] [int] NULL,
	[RunDataId] [int] NOT NULL
) ON [PRIMARY]

GO

/****** Object:  Table [FoldingCoin].[Files]    Script Date: 7/28/2017 8:34:39 AM ******/
CREATE TABLE [FoldingCoin].[Files](
	[FileId] [int] IDENTITY(1,1) NOT NULL,
	[FileName] [nvarchar](50) NOT NULL,
	[FileExtension] [nvarchar](5) NOT NULL,
	[FileData] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Files] PRIMARY KEY CLUSTERED 
(
	[FileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [FoldingCoin].[Rejections]    Script Date: 7/28/2017 8:34:39 AM ******/
CREATE TABLE [FoldingCoin].[Rejections](
	[RejectionId] [int] IDENTITY(1,1) NOT NULL,
	[FAHDataId] [int] NOT NULL,
	[VersionId] [int] NULL,
	[LineNumber] [int] NOT NULL,
	[Reason] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK_Rejections] PRIMARY KEY CLUSTERED 
(
	[RejectionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [FoldingCoin].[RunData]    Script Date: 7/28/2017 8:34:39 AM ******/
CREATE TABLE [FoldingCoin].[RunData](
	[RunDataId] [int] IDENTITY(1,1) NOT NULL,
	[VersionId] [int] NOT NULL,
	[RunDate] [date] NOT NULL,
	[LastRunTime] [time](7) NOT NULL,
	[NumberOfRuns] [int] NOT NULL,
 CONSTRAINT [PK_RunData] PRIMARY KEY CLUSTERED 
(
	[RunDataId] ASC,
	[VersionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [FoldingCoin].[Statuses]    Script Date: 7/28/2017 8:34:39 AM ******/
CREATE TABLE [FoldingCoin].[Statuses](
	[StatusId] [int] IDENTITY(1,1) NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[StatusDescription] [nvarchar](100) NULL,
 CONSTRAINT [PK_Statuses] PRIMARY KEY CLUSTERED 
(
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [FoldingCoin].[TeamMembers]    Script Date: 7/28/2017 8:34:39 AM ******/
CREATE TABLE [FoldingCoin].[TeamMembers](
	[TeamId] [int] NOT NULL,
	[UserId] [int] NOT NULL
) ON [PRIMARY]

GO

/****** Object:  Table [FoldingCoin].[Teams]    Script Date: 7/28/2017 8:34:39 AM ******/
CREATE TABLE [FoldingCoin].[Teams](
	[TeamId] [int] IDENTITY(1,1) NOT NULL,
	[TeamNumber] [nvarchar](50) NOT NULL,
	[TeamName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Teams] PRIMARY KEY CLUSTERED 
(
	[TeamId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [FoldingCoin].[Users]    Script Date: 7/28/2017 8:34:39 AM ******/
CREATE TABLE [FoldingCoin].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[FriendlyName] [nvarchar](50) NOT NULL,
	[BitcoinAddress] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Users] UNIQUE NONCLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [FoldingCoin].[UserStats]    Script Date: 7/28/2017 8:34:39 AM ******/
CREATE TABLE [FoldingCoin].[UserStats](
	[UserStatId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[StartDateTime] [datetime] NOT NULL,
	[EndDateTime] [datetime] NOT NULL,
	[Points] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_UserStats] PRIMARY KEY CLUSTERED 
(
	[UserStatId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [FoldingCoin].[Versions]    Script Date: 7/28/2017 8:34:39 AM ******/
CREATE TABLE [FoldingCoin].[Versions](
	[VersionId] [int] IDENTITY(1,1) NOT NULL,
	[VersionNumber] [nvarchar](50) NOT NULL,
	[LastRun] [datetime] NOT NULL,
 CONSTRAINT [PK_Versions] PRIMARY KEY CLUSTERED 
(
	[VersionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [FoldingCoin].[Downloads]  WITH CHECK ADD  CONSTRAINT [FK_Downloads_Files] FOREIGN KEY([FileId])
REFERENCES [FoldingCoin].[Files] ([FileId])
GO
ALTER TABLE [FoldingCoin].[Downloads] CHECK CONSTRAINT [FK_Downloads_Files]
GO
ALTER TABLE [FoldingCoin].[Downloads]  WITH CHECK ADD  CONSTRAINT [FK_Downloads_Statuses] FOREIGN KEY([StatusId])
REFERENCES [FoldingCoin].[Statuses] ([StatusId])
GO
ALTER TABLE [FoldingCoin].[Downloads] CHECK CONSTRAINT [FK_Downloads_Statuses]
GO
ALTER TABLE [FoldingCoin].[FAHData]  WITH CHECK ADD  CONSTRAINT [FK_FAHData_Users] FOREIGN KEY([UserName])
REFERENCES [FoldingCoin].[Users] ([UserName])
GO
ALTER TABLE [FoldingCoin].[FAHData] CHECK CONSTRAINT [FK_FAHData_Users]
GO
ALTER TABLE [FoldingCoin].[FAHDataRuns]  WITH CHECK ADD  CONSTRAINT [FK_FAHDataRuns_Downloads] FOREIGN KEY([DownloadId])
REFERENCES [FoldingCoin].[Downloads] ([DownloadId])
GO
ALTER TABLE [FoldingCoin].[FAHDataRuns] CHECK CONSTRAINT [FK_FAHDataRuns_Downloads]
GO
ALTER TABLE [FoldingCoin].[FAHDataRuns]  WITH CHECK ADD  CONSTRAINT [FK_FAHDataRuns_FAHData] FOREIGN KEY([FAHDataId])
REFERENCES [FoldingCoin].[FAHData] ([FAHDataId])
GO
ALTER TABLE [FoldingCoin].[FAHDataRuns] CHECK CONSTRAINT [FK_FAHDataRuns_FAHData]
GO
ALTER TABLE [FoldingCoin].[Rejections]  WITH CHECK ADD  CONSTRAINT [FK_Rejections_FAHDataRuns] FOREIGN KEY([FAHDataId], [VersionId])
REFERENCES [FoldingCoin].[FAHDataRuns] ([FAHDataId], [VersionId])
GO
ALTER TABLE [FoldingCoin].[Rejections] CHECK CONSTRAINT [FK_Rejections_FAHDataRuns]
GO
ALTER TABLE [FoldingCoin].[RunData]  WITH CHECK ADD  CONSTRAINT [FK_RunData_FAHDataRuns] FOREIGN KEY([RunDataId], [VersionId])
REFERENCES [FoldingCoin].[FAHDataRuns] ([FAHDataId], [VersionId])
GO
ALTER TABLE [FoldingCoin].[RunData] CHECK CONSTRAINT [FK_RunData_FAHDataRuns]
GO
ALTER TABLE [FoldingCoin].[RunData]  WITH CHECK ADD  CONSTRAINT [FK_RunData_Versions] FOREIGN KEY([VersionId])
REFERENCES [FoldingCoin].[Versions] ([VersionId])
GO
ALTER TABLE [FoldingCoin].[RunData] CHECK CONSTRAINT [FK_RunData_Versions]
GO
ALTER TABLE [FoldingCoin].[TeamMembers]  WITH CHECK ADD  CONSTRAINT [FK_TeamMembers_Teams] FOREIGN KEY([TeamId])
REFERENCES [FoldingCoin].[Teams] ([TeamId])
GO
ALTER TABLE [FoldingCoin].[TeamMembers] CHECK CONSTRAINT [FK_TeamMembers_Teams]
GO
ALTER TABLE [FoldingCoin].[TeamMembers]  WITH CHECK ADD  CONSTRAINT [FK_TeamMembers_Users] FOREIGN KEY([UserId])
REFERENCES [FoldingCoin].[Users] ([UserId])
GO
ALTER TABLE [FoldingCoin].[TeamMembers] CHECK CONSTRAINT [FK_TeamMembers_Users]
GO
ALTER TABLE [FoldingCoin].[UserStats]  WITH CHECK ADD  CONSTRAINT [FK_UserStats_Users] FOREIGN KEY([UserId])
REFERENCES [FoldingCoin].[Users] ([UserId])
GO
ALTER TABLE [FoldingCoin].[UserStats] CHECK CONSTRAINT [FK_UserStats_Users]
GO