USE [DataDocumentation]
GO

/****** Object:  Table [dbo].[Edges_D]    Script Date: 7/12/2021 8:04:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Edges_D](
	[referencing_id] [int] NOT NULL,
	[referencing_database] [nvarchar](128) NOT NULL,
	[referenced_id] [int] NULL,
	[referenced_database] [nvarchar](128) NULL
) ON [PRIMARY]
GO


