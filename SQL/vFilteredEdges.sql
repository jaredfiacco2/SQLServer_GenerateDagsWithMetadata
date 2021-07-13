USE [DataDocumentation]
GO

/****** Object:  View [dbo].[vFilteredEdges]    Script Date: 7/12/2021 8:05:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[vFilteredEdges] as
--Edges
select 
	e.*
from
	[dbo].[vEdges] e
left join 
	dbo.FilteredEdges_D f on
	e.[from]  = f.[from] and 
	e.[to]    = f.[to]
where
	f.[from] is not null

	


GO


