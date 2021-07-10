USE [DataDocumentation]
GO

/****** Object:  StoredProcedure [dbo].[Refresh_Nodes]    Script Date: 7/10/2021 3:09:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[Refresh_Nodes] as
----------------------------------------------
--Traverse Databases--------------------------
--Get All Objects User-Made Objects-----------
----------------------------------------------
truncate table DataDocumentation.dbo.Nodes
exec sp_MSforeachdb 
 	'use ?
	insert into DataDocumentation.dbo.Nodes
    Select 
		 distinct
		 d.dbid			database_id
		,''?''			database_name
		,o.schema_id
		,s.name			schema_name
		,o.object_id 
		,o.name			object_name
		,o.type			object_type
		,o.type_desc	object_type_desc
		,o.create_date	object_create_date
		,o.modify_date	object_modify_date
	from 
		sys.objects o
	left join 
		sys.schemas s on o.schema_id = s.schema_id
	left join 
		master.dbo.sysdatabases d
			on d.name = ''?''
	where 
		type in (''U'', ''V'', ''P'') and
		''?'' not in (''master'', ''model'',''msdb'',''tempdb'')'
GO


