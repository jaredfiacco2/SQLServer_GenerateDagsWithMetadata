alter procedure Filter_EdgesAndNodes_OneNodeStartingPoint (@id nvarchar(255)) as

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
	--#NewNodes
	BEGIN TRY  
		DROP TABLE #NewNodes;
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
CREATE TABLE #NewNodes	([node] NVARCHAR(255));
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
		[to]	= @id or
		[from]	= @id
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

	insert into #NewNodes
	select * from #Nodes
---------------------------------------------------------
--Find all distinct nodes in your list of edges----------
---------------------------------------------------------
	select * from #Edges
	select * from #Nodes
	select * from #NewEdges
	select * from #NewNodes
-----------------------------------------------------------
----Use Cursor to step through a running list of Nodes-----
-----------------------------------------------------------
	DECLARE @NodeRunner INT = 0;
	WHILE (select count(*) from #NewNodes) > 0 and @NodeRunner < 100
	BEGIN
		--Add Edges
		truncate table #NewEdges
		insert into #NewEdges
		select
			distinct
			v.[from],
			v.[to]
		from
			vEdges v
		left join
			#NewNodes n on n.[node] = v.[from] or n.[node] = v.[to]
		left join
			#Edges e on e.[from] = v.[from] and e.[to] = v.[to]
		where 
			n.[node] is not null and
			e.[from] is null

		insert into #Edges
		select * from #NewEdges

		--Add Nodes
		truncate table #NewNodes
		insert into #NewNodes
		select
			distinct
			[to] as [node]
		from(	
				select [to] from #NewEdges
				union
				select [from] from #NewEdges
			) new
		left join #Nodes cur
			on cur.[node] = new.[to]
		where cur.[node] is null

		insert into #Nodes
		select * from #NewNodes 
		
		SET @NodeRunner = @NodeRunner + 1
	END



--check work
truncate table FilteredEdges_D
insert into FilteredEdges_D
select * from #Edges
truncate table FilteredNodes_D
insert into FilteredNodes_D
select * from #Nodes