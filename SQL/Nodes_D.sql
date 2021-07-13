USE [DataDocumentation]
GO

/****** Object:  Table [dbo].[Nodes_D]    Script Date: 7/12/2021 8:04:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Nodes_D](
	[database_id] [smallint] NULL,
	[database_name] [nvarchar](38) NOT NULL,
	[schema_id] [int] NOT NULL,
	[schema_name] [sysname] NULL,
	[object_id] [int] NOT NULL,
	[object_name] [sysname] NOT NULL,
	[object_type] [char](2) NULL,
	[object_type_desc] [nvarchar](60) NULL,
	[object_create_date] [datetime] NOT NULL,
	[object_modify_date] [datetime] NOT NULL
) ON [PRIMARY]
GO


