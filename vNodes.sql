USE [DataDocumentation]
GO

/****** Object:  View [dbo].[vNodes]    Script Date: 7/10/2021 3:11:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[vNodes] as
--Nodes
select 
	 distinct
	 [database_name] + '.' + [schema_name] + '.' + [object_name]	as [id]
	,[database_name]		as [database]
	,[database_id]			as [database_id]
	,[schema_name]			as [schema]
	,[schema_id]			as [schema_id]
	,[object_name]			as [object]
	,[object_id]			as [object_id]
	,[object_type]			as [type]
	,[object_type_desc] 	as [type_desc]
	,object_create_date		as [create_date]
	,object_modify_date		as [modify_date]
from
	dbo.Nodes
GO


