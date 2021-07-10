USE [DataDocumentation]
GO

/****** Object:  Table [dbo].[Edges]    Script Date: 7/10/2021 3:12:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Edges](
	[referencing_id] [int] NOT NULL,
	[referencing_database] [nvarchar](128) NOT NULL,
	[referenced_id] [int] NULL,
	[referenced_database] [nvarchar](128) NULL
) ON [PRIMARY]
GO


