USE [DataDocumentation]
GO

/****** Object:  StoredProcedure [dbo].[Refresh_Edges_SP]    Script Date: 7/12/2021 8:07:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE Procedure [dbo].[Refresh_Edges_SP] as
----------------------------------------------
--Traverse Databases--------------------------
--Get All Object Dependencies-----------------
----------------------------------------------
truncate table DataDocumentation.dbo.Edges_D
exec sp_MSforeachdb 
 	'use ?
	insert into DataDocumentation.dbo.Edges_D
	select 
		 d.referencing_id
		,''?''							referencing_database
		,d.referenced_id
		,case when d.referenced_database_name is null then ''?'' else d.referenced_database_name	end	referenced_database
	from 
		sys.sql_expression_dependencies d
	left join 
		master.dbo.sysdatabases dbs
			on dbs.name = ''?''
	where 
		d.referenced_id is not null	and
		''?'' not in (''master'', ''model'',''msdb'',''tempdb'')
	'

GO


