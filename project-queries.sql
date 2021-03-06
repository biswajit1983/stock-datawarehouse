/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Date_Id]
      ,[Day]
      ,[Week]
      ,[Month]
      ,[Quarter]
      ,[Year]
  FROM [Stocks].[dbo].[DimDate];


  select distinct DATEPART(DAY,a.Date) as Day,DATEPART(WK,a.Date) as Week,DATEPART(MM,a.Date) as Month,DATEPART(QQ,a.Date) as Quarter,
  DATEPART(year,a.Date) as Year
  from RawData_Stocks a 
  inner join RawData_StockTwits b on a.symbol_code = b.company_code and a.Date = b.date
  order by Year,Quarter,Month,Week,Day;

  select count(*) from ss_fact_table;
  select a.Date from RawData_Stocks a where a.symbol_code='AAPL' and date >= '2017-01-01' and date <= '2018-11-15'

  select * from RawData_StockTwits a where company_code = 'AAPL';


  USE [Stocks]
GO

/****** Object:  Table [dbo].[RawData_Stocks]    Script Date: 16-11-2018 07:27:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
DROP TABLE [dbo].[RawData_Stocks]
CREATE TABLE [dbo].[RawData_Stocks](
	[Open] numeric(18,2) NULL,
	[High] numeric(18,2) NULL,
	[Low] numeric(18,2) NULL,
	[Close] numeric(18,2) NULL,
	[Volume] [bigint] NULL,
	[Date] [datetime] NULL,
	[symbol_code] [varchar](255) NULL
) ON [PRIMARY]
GO

DROP TABLE [dbo].[DimLocation];
CREATE TABLE [dbo].[DimLocation](
	Location_id int identity(1,1) PRIMARY KEY,
	city varchar(50) null,
	state varchar(50) null,
)

TRUNCATE table [dbo].[DimLocation]
INSERT INTO	[dbo].[DimLocation](city,state)
select distinct city,location from RawData_StockCompany; 

select distinct city,location from RawData_StockCompany;

USE [Stocks]
GO

/****** Object:  Table [dbo].[ss_fact_table]    Script Date: 16-11-2018 11:21:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
DROP TABLE [dbo].[ss_fact_table]
CREATE TABLE [dbo].[ss_fact_table](
	[Date_id] [int] NULL,
	[Company_id] [int] NOT NULL,
	[Location_id] [int] NOT NULL,
	[Open] [real] NULL,
	[Close] [real] NULL,
	[High] [real] NULL,
	[Low] [int] NULL,
	[Volume] [bigint] NULL,
	[Sentiments_Score] [numeric](18, 2) NULL
) ON [PRIMARY]
GO




TRUNCATE table [dbo].[ss_fact_table]
INSERT INTO [dbo].[ss_fact_table]
           ([date_id]
           ,[Company_id]
		   ,[Location_id]	
           ,[Open]
           ,[Close]
           ,[High]
           ,[Low]
           ,[Volume]
           ,[Sentiments_Score]
)
	 SELECT Distinct
d.Date_Id
,sc.Company_id,Location_id
,q.[Open],q.[Close],q.[High],q.[Low],q.[Volume],t.[affinSentiment]
from [dbo].[DimStockCompany] sc
INNER JOIN RawData_StockCompany rc on rc.stock_symbol=sc.stock_symbol
INNER JOIN DimLocation dl on dl.city=rc.city and dl.state = rc.location
INNER JOIN [RawData_Stocks] q ON q.symbol_code=sc.stock_symbol 
INNER JOIN [DimDate] d on DATEFROMPARTS(d.Year, d.Month,d.Day) = q.Date
LEFT JOIN [RawData_StockTwits] t ON t.company_code=q.symbol_code AND t.date=q.Date
--where location_id = '47' and Date_id = 83;

select * from DimLocation order by state;
select * from ss_fact_table where location_id = '47' and Date_id = 83;
select * from dimDate where year='2018' and month='3' and day='5';
select * from DimStockCompany where stock_symbol = 'AAPL'


SELECT --Distinct
--d.Date_Id
--,sc.Company_id,Location_id
--,q.[Open],q.[Close],q.[High],q.[Low],q.[Volume],t.[affinSentiment]
*
from [dbo].[DimStockCompany] sc
INNER JOIN RawData_StockCompany rc on rc.stock_symbol=sc.stock_symbol
INNER JOIN DimLocation dl on dl.city=rc.city and dl.state = rc.location
INNER JOIN [RawData_Stocks] q ON q.symbol_code=sc.stock_symbol 
INNER JOIN [DimDate] d on DATEFROMPARTS(d.Year, d.Month,d.Day) = q.Date
LEFT JOIN [RawData_StockTwits] t ON t.company_code=q.symbol_code AND t.date=q.Date
where --location_id = '47' and Date_id = 83;
sc.stock_symbol = 'AAPL' and q.Date = '2018-03-05';


IF OBJECT_ID('[Stocks].[dbo].[RawData_StockTwits]') IS NOT NULL
  TRUNCATE TABLE [Stocks].[dbo].[RawData_StockTwits];


  USE [Stocks]
GO

/****** Object:  Table [dbo].[ss_fact_table]    Script Date: 16-11-2018 11:00:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
DROP TABLE [dbo].[ss_fact_table]
CREATE TABLE [dbo].[ss_fact_table](
	[Date_id] [int] NULL,
	[Company_id] [int] NOT NULL,
	[Open] [real] NULL,
	[Close] [real] NULL,
	[High] [real] NULL,
	[Low] [int] NULL,
	[Volume] [bigint] NULL,
	[Sentiments_Score] [numeric](18, 2) NULL
) ON [PRIMARY]
GO

select * from fact_table;

USE [Stocks]
GO

/****** Object:  Table [dbo].[fact_table]    Script Date: 17-11-2018 01:44:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE [dbo].[q_fact_table]
CREATE TABLE [dbo].[q_fact_table](
	[quarter_id] [int] NULL,
	[Company_id] [int] NOT NULL,
	[Location_id] [int] NOT NULL,
	[revenue] [int] NULL,
	[Open] [int] NULL,
	[Close] [int] NULL,
	[High] [int] NULL,
	[Low] [int] NULL,
	[Volume] [bigint] NULL,
) ON [PRIMARY]
GO


USE [Stocks]
GO
TRUNCATE TABLE [dbo].[q_fact_table];
INSERT INTO [dbo].[q_fact_table]
           ([quarter_id]
           ,[Company_id]
		   ,[Location_id]
           ,[revenue]
           ,[Open]
           ,[Close]
           ,[High]
           ,[Low]
           ,[Volume])
SELECT
d.quarter_id
,sc.Company_id,
Location_id,
r.revenue
,q.Opening
,q.Closing
,q.High
,q.Low
,q.volume
from [dbo].[DimStockCompany] sc
INNER JOIN DimLocation dl on dl.city=sc.city and dl.state = sc.location
INNER JOIN (
	
SELECT 
    Opening,
    MAX(High) AS High,
    MIN(Low) AS Low,
    Closing,
    qt,year,
	symbol_code,
	sum(volume) as volume
FROM 
(
    SELECT distinct FIRST_VALUE([Open]) OVER (PARTITION BY DATEPART(QUARTER, Date),DATEPART(YEAR, Date) ORDER BY DATE) AS Opening,
           FIRST_VALUE([Close]) OVER (PARTITION BY DATEPART(QUARTER, Date),DATEPART(YEAR, Date) ORDER BY DATE DESC) AS Closing,
           DATEPART(QUARTER, Date) qt,DATEPART(YEAR, Date) AS year
           ,*
    FROM [RawData_Stocks] 
) AS qt_Temp
GROUP BY symbol_code,year, qt, Opening, Closing
) as q ON q.symbol_code=sc.stock_symbol
INNER JOIN [DimQuarter] d on REPLACE(d.quarter,'Q','') = q.qt and d.year = q.year
INNER JOIN [RawData_Revenue] r on r.quarter=d.quarter and r.year=d.year and r.company_code = sc.stock_symbol
GO

SELECT
d.quarter_id
,sc.Company_id,
Location_id,
r.revenue
,q.Opening
,q.Closing
,q.High
,q.Low
,q.volume
from [dbo].[DimStockCompany] sc
INNER JOIN DimLocation dl on dl.city=sc.city and dl.state = sc.location
INNER JOIN (
	
SELECT 
    Opening,
    MAX(High) AS High,
    MIN(Low) AS Low,
    Closing,
    qt,year,
	symbol_code,
	sum(volume) as volume
FROM 
(
    SELECT distinct FIRST_VALUE([Open]) OVER (PARTITION BY DATEPART(QUARTER, Date),DATEPART(YEAR, Date) ORDER BY DATE) AS Opening,
           FIRST_VALUE([Close]) OVER (PARTITION BY DATEPART(QUARTER, Date),DATEPART(YEAR, Date) ORDER BY DATE DESC) AS Closing,
           DATEPART(QUARTER, Date) qt,DATEPART(YEAR, Date) AS year
           ,*
    FROM [RawData_Stocks] 
) AS qt_Temp
GROUP BY symbol_code,year, qt, Opening, Closing
) as q ON q.symbol_code=sc.stock_symbol
INNER JOIN [DimQuarter] d on REPLACE(d.quarter,'Q','') = q.qt and d.year = q.year
INNER JOIN [RawData_Revenue] r on r.quarter=d.quarter and r.year=d.year and r.company_code = sc.stock_symbol
where sc.stock_symbol = 'AMZN'

select * from [RawData_Revenue]

SELECT 
    Opening,
    MAX(High) AS High,
    MIN(Low) AS Low,
    Closing,
    qt,year,
	symbol_code,
	sum(volume) as volume
FROM 
(
    SELECT distinct FIRST_VALUE([Open]) OVER (PARTITION BY DATEPART(QUARTER, Date),DATEPART(YEAR, Date) ORDER BY DATE) AS Opening,
           FIRST_VALUE([Close]) OVER (PARTITION BY DATEPART(QUARTER, Date),DATEPART(YEAR, Date) ORDER BY DATE DESC) AS Closing,
           DATEPART(QUARTER, Date) qt,DATEPART(YEAR, Date) AS year
           ,*
    FROM [RawData_Stocks] where symbol_code='AMZN' and DATEPART(YEAR, Date) = '2018' and DATEPART(QUARTER, Date) = 1
) AS qt_Temp

GROUP BY symbol_code,year, qt, Opening, Closing

select * from q_fact_table where Company_id=27; 
select * from DimStockCompany where stock_symbol='AMZN'
select * from DimLocation where Location_id=205;
select * from DimQuarter where quarter_id = 13