USE [DataDocumentation]
GO

/****** Object:  View [dbo].[vEdges]    Script Date: 7/10/2021 3:11:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[vEdges] as
--Edges
select 
	 distinct
	 o_from.database_name + '.' + o_from.schema_name + '.' + o_from.object_name as [from]
	,o_to.database_name   + '.' + o_to.schema_name   + '.' + o_to.object_name	as [to]
	,o_from.database_name	from_database
	,o_from.database_id		from_database_id
	,o_from.schema_name		from_schema
	,o_from.schema_id		from_schema_id
	,o_from.object_name		from_object
	,o_from.object_id		from_object_id
	,o_to.database_name		to_database
	,o_to.database_id		to_database_id
	,o_to.schema_name		to_schema
	,o_to.schema_id			to_schema_id
	,o_to.object_name		to_object
	,o_to.object_id			to_object_id	
	,count(*)				[weight]
from
	[dbo].[Edges] d
left join 
	dbo.Nodes o_from on
	o_from.database_name = d.referencing_database and 
	o_from.object_id		= d.referencing_id
left join 
	dbo.Nodes o_to on
	o_to.database_name  = d.referenced_database and 
	o_to.object_id		= d.referenced_id
where 
	o_from.database_name   + '.' + o_from.schema_name   + '.' + o_from.object_name is not null and
	o_to.database_name	   + '.' + o_to.schema_name     + '.' + o_to.object_name   is not null
group by 
	 o_from.database_name + '.' + o_from.schema_name + '.' + o_from.object_name
	,o_to.database_name   + '.' + o_to.schema_name   + '.' + o_to.object_name	
	,o_from.database_name	
	,o_from.database_id		
	,o_from.schema_name		
	,o_from.schema_id		
	,o_from.object_name		
	,o_from.object_id		
	,o_to.database_name		
	,o_to.database_id		
	,o_to.schema_name		
	,o_to.schema_id			
	,o_to.object_name		
	,o_to.object_id			


GO


