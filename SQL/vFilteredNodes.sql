USE [DataDocumentation]
GO

/****** Object:  View [dbo].[vFilteredNodes]    Script Date: 7/12/2021 8:05:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[vFilteredNodes] as
--Edges
select 
	e.*
from
	[dbo].[vNodes] e
left join 
	dbo.FilteredNodes_D f on
	e.[id]  = f.[id] 
where
	f.[id] is not null

	


GO


