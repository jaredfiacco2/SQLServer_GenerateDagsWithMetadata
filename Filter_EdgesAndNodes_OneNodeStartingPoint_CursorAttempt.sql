--create procedure Filter_EdgesAndNodes_OneNodeStartingPoint as

--------------------------------------------------------------
--Remove any Temp tables from last run, start from scratch----
--------------------------------------------------------------
	--#Edges
	BEGIN TRY  
		DROP TABLE #Edges;
	END TRY  
	BEGIN CATCH
		SELECT
		ERROR_NUMBER() as ErrorNumber,
		ERROR_MESSAGE() as ErrorMessage;
	END CATCH;
	--#Nodes
	BEGIN TRY  
		DROP TABLE #Nodes;
	END TRY  
	BEGIN CATCH
		SELECT
		ERROR_NUMBER() as ErrorNumber,
		ERROR_MESSAGE() as ErrorMessage;
	END CATCH
	--#NewEdges
	BEGIN TRY  
		DROP TABLE #NewEdges;
	END TRY  
	BEGIN CATCH
		SELECT
		ERROR_NUMBER() as ErrorNumber,
		ERROR_MESSAGE() as ErrorMessage;
	END CATCH;
---------------------------------------------------------
--Find all distinct edges connected to/from your node----
---------------------------------------------------------
CREATE TABLE #Edges		([from] NVARCHAR(255), [to] NVARCHAR(255));
CREATE TABLE #Nodes		([node] NVARCHAR(255));
CREATE TABLE #NewEdges	([from] NVARCHAR(255), [to] NVARCHAR(255));
---------------------------------------------------------
--Find all distinct edges connected to/from your node----
---------------------------------------------------------
	insert into #Edges
	select
		[from],
		[to]
	from
		vEdges
	where 
		[to]	like 'DWDiagnostics.dbo.pdw_health_components_data' or
		[from]	like 'DWDiagnostics.dbo.pdw_health_components_data'
---------------------------------------------------------
--Find all distinct nodes in your list of edges----------
---------------------------------------------------------
	insert into #Nodes
	select
		[to] as [node]
	from(	
		select [to] from #Edges
		union
		select [from] from #Edges
	)n
---------------------------------------------------------
--Find all distinct nodes in your list of edges----------
---------------------------------------------------------
	select * from #Edges
	select * from #Nodes
	select * from #NewEdges
---------------------------------------------------------
--Use Cursor to step through a running list of Nodes-----
---------------------------------------------------------
	-- Declare Cursor Variables
	DECLARE @CursorID NVARCHAR(255);
	DECLARE @RunningTotal NVARCHAR(255);

	DECLARE CUR CURSOR --FAST_FORWARD 
		FOR
		SELECT	[node] RunningTotal
		FROM	#Nodes
		ORDER BY [node];

	OPEN CUR
	FETCH NEXT FROM CUR INTO @CursorID

	WHILE @@FETCH_STATUS = 0
	BEGIN
		truncate table #NewEdges
		--for notes
		select @CursorID
		insert into #NewEdges
		select
			v.[to],
			v.[from]
		from
			vEdges v
		left join
		#Edges e on e.[from] = v.[from] and e.[to] = v.[to]
		where 
		   (v.[to]		= @CursorID or
			v.[from]	= @CursorID		) and
			e.[from] is null

		insert into #Edges
		select * from #NewEdges

		--Add Nodes
		insert into #Nodes
		select
			[to] as [node]
		from(	
				select [to] from #NewEdges
				union
				select [from] from #NewEdges
			) new
		left join #Nodes cur
			on cur.[node] = new.[to]
		where cur.[node] is null

		FETCH NEXT FROM CUR INTO @CursorID
	END

CLOSE CUR
DEALLOCATE CUR

--check work
select * from #Nodes
select * from #Edges



--with rec ([to], [from]) as (
--    select t.[to], t.[from] 
--    from vEdges t 
--    union all
--    select rec.[to], t.[from]
--    from rec
--    join vEdges t 
--        on rec.[from] = t.[to]
--    union all
--    select rec.[to], t.[from]
--    from rec
--    join vEdges t 
--        on rec.[to] = t.[from]
--) 
--select top 100
--	* 
--from 
--	rec 
--where 
--	[to] like '%DWDiagnostics.dbo.Data%' or
--	[from] like '%DWDiagnostics.dbo.pdw_health_components_data%'
