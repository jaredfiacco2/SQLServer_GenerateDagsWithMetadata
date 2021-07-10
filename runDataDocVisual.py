import time, json, requests, pandas as pd, sqlalchemy as sal, pyodbc
from sqlalchemy import create_engine
import webbrowser
#For Network Graph Visualization
from jaal import Jaal
from jaal.datasets import load_got


## SQL ALCHEMY - Set up Database Connection
SERVER = 'JERDSURF\JAREDSLILSERVER'
DATABASE = 'DataDocumentation'
DRIVER = 'SQL Server Native Client 11.0'
USERNAME = 'DataDocumentation'
PASSWORD = 'DocumentThisData!'
DATABASE_CONNECTION = f'mssql://{USERNAME}:{PASSWORD}@{SERVER}/{DATABASE}?driver={DRIVER}'

engine = create_engine(DATABASE_CONNECTION)
connection = engine.connect()

##Refresh  
#results = connection.execute('[dbo].[Refresh_Edges]')
#results = connection.execute('[dbo].[Refresh_Nodes]')

#Load Data and Load Visual
edge_df = pd.read_sql_query(''' select * from [DataDocumentation].[dbo].[vEdges]  ''', connection)
node_df = pd.read_sql_query(''' select * from [DataDocumentation].[dbo].[vNodes]  ''', connection)

#Open Jaal Website in Default Browser 
webbrowser.open('http://127.0.0.1:8050/')

#Run Jaal with the edge/node data
Jaal(edge_df, node_df).plot()