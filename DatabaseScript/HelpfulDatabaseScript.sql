USE [master]
GO
/****** Object:  Database [FeedbackScript]    Script Date: 09/13/2012 14:23:22 ******/
CREATE DATABASE [FeedbackScript] ON  PRIMARY 
( NAME = N'FeedbackScript', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\FeedbackScript.mdf' , SIZE = 109760KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'FeedbackScript_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\FeedbackScript_log.LDF' , SIZE = 104000KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [FeedbackScript] SET COMPATIBILITY_LEVEL = 90
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [FeedbackScript].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [FeedbackScript] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [FeedbackScript] SET ANSI_NULLS OFF
GO
ALTER DATABASE [FeedbackScript] SET ANSI_PADDING OFF
GO
ALTER DATABASE [FeedbackScript] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [FeedbackScript] SET ARITHABORT OFF
GO
ALTER DATABASE [FeedbackScript] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [FeedbackScript] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [FeedbackScript] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [FeedbackScript] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [FeedbackScript] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [FeedbackScript] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [FeedbackScript] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [FeedbackScript] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [FeedbackScript] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [FeedbackScript] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [FeedbackScript] SET  DISABLE_BROKER
GO
ALTER DATABASE [FeedbackScript] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [FeedbackScript] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [FeedbackScript] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [FeedbackScript] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [FeedbackScript] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [FeedbackScript] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [FeedbackScript] SET  READ_WRITE
GO
ALTER DATABASE [FeedbackScript] SET RECOVERY SIMPLE
GO
ALTER DATABASE [FeedbackScript] SET  MULTI_USER
GO
ALTER DATABASE [FeedbackScript] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [FeedbackScript] SET DB_CHAINING OFF
GO
USE [FeedbackScript]
GO
/****** Object:  User [FeedbackUser]    Script Date: 09/13/2012 14:23:22 ******/
CREATE USER [FeedbackUser] FOR LOGIN [FeedbackUser] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [FeedbackAdmin]    Script Date: 09/13/2012 14:23:22 ******/
CREATE USER [FeedbackAdmin] FOR LOGIN [FeedbackAdmin] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[Agency]    Script Date: 09/13/2012 14:23:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Agency](
	[AgencyCode] [varchar](20) NULL,
	[AgencyName] [varchar](100) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[parseDomain]    Script Date: 09/13/2012 14:23:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[parseDomain]  (@URL varchar(1024))
RETURNS varchar(1000)
AS
BEGIN
IF CHARINDEX('http://',@URL) > 0 OR CHARINDEX('https://',@URL) > 0
-- Ghetto-tastic
SELECT @URL = REPLACE(@URL,'https://','')
SELECT @URL = REPLACE(@URL,'http://','')
SELECT @URL = REPLACE(@URL,'www','')
-- Remove everything after "/" if one exists
IF CHARINDEX('/',@URL) > 0 (SELECT @URL = LEFT(@URL,CHARINDEX('/',@URL)-1))

-- Optional: Remove subdomains but differentiate between www.google.com and www.google.com.au
IF (LEN(@URL)-LEN(REPLACE(@URL,'.','')))/LEN('.') < 3 -- if there are less than 3 periods
SELECT @URL = PARSENAME(@URL,2) + '.' + PARSENAME(@URL,1)
ELSE -- It's likely a google.co.uk, or google.com.au
SELECT @URL = PARSENAME(@URL,3) + '.' + PARSENAME(@URL,2) + '.' + PARSENAME(@URL,1)
RETURN @URL
END
GO
/****** Object:  Table [dbo].[AgencyPattern]    Script Date: 09/13/2012 14:23:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AgencyPattern](
	[AgencyName] [varchar](100) NOT NULL,
	[URLAgencyName] [varchar](100) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[GetQuarterly]    Script Date: 09/13/2012 14:23:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
		delete from responses where dbo.parseDomain(URL) is null

		select * from responses

		Select dbo.getAgency(URL) Agency, count(*) AS VolumeOfFeedback,
		round(Cast(sum(cast(Positive as int)) as Float)/Cast(count(*) as Float)*100,2) AS Positive
		from responses
		group by dbo.getAgency(URL)
order by dbo.getAgency(URL)
	
		select * from responses where URL like '%welcome.html%' and Positive = 1
		select count(*) from responses where URL like 'http://www.dol.gov/dol%' and Positive = 0

*/
CREATE FUNCTION [dbo].[GetQuarterly] (@utcdate datetime)
RETURNS varchar(100)
AS
BEGIN
	declare @qtr varchar(100)
	set @qtr = cast(year(@utcdate) as varchar(25)) + '-' + cast(DatePart(quarter,@utcdate) as varchar(25)) 
	return @qtr
END
GO
/****** Object:  Table [dbo].[Responses]    Script Date: 09/13/2012 14:23:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Responses](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Url] [nvarchar](1024) NOT NULL,
	[Agency] [varchar](100) NULL,
	[UtcDate] [datetime] NOT NULL,
	[Positive] [bit] NULL,
 CONSTRAINT [PK_Responses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Audit_Logs]    Script Date: 09/13/2012 14:23:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Audit_Logs](
	[Log_ID] [int] IDENTITY(1,1) NOT NULL,
	[Log_Datetime] [datetime] NULL,
	[User_identity] [varchar](256) NULL,
	[User_Action] [varchar](256) NULL,
	[User_Parameters] [varchar](5000) NULL,
	[Event_Result] [bit] NULL,
 CONSTRAINT [PK_Audit_Log] PRIMARY KEY CLUSTERED 
(
	[Log_ID] ASC
)WITH (PAD_INDEX  = ON, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Comments]    Script Date: 09/13/2012 14:23:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Comments](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Url] [nvarchar](1024) NOT NULL,
	[Agency] [varchar](100) NULL,
	[UtcDate] [datetime] NOT NULL,
	[Positive] [bit] NULL,
	[Comment] [nvarchar](1024) NULL,
 CONSTRAINT [PK_Comments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[getAgencyCode]    Script Date: 09/13/2012 14:23:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

		delete from responses where dbo.parseDomain(URL) is null
select * from responses

		Select * from 
		(
			select 'DOL.Gov' Agency, count(*) AS VolumeOfFeedback,
			round(Cast(sum(cast(Positive as int)) as Float)/Cast(count(*) as Float)*100,2) AS Positive
			from responses
			union ALL
			Select upper(dbo.getCorrectAgencyName(dbo.getAgencyCode(URL))) Agency, count(*) AS VolumeOfFeedback,
			round(Cast(sum(cast(Positive as int)) as Float)/Cast(count(*) as Float)*100,2) AS Positive
			from responses
			group by dbo.getCorrectAgencyName(dbo.getAgencyCode(URL))
		)z
		order by z.Agency

	
		select * from responses where URL like '%welcome.html%' and Positive = 1
		select count(*) from responses where URL like 'http://www.dol.gov/dol%' and Positive = 0
http://www.dol.gov/	
http://www.dol.gov	HTTP:
http://www.dol.gov/INDEX.HTM	INDEX.HTM
*/
CREATE FUNCTION [dbo].[getAgencyCode](@URL nvarchar(1024))
RETURNS varchar(100)
AS
BEGIN
	declare @Agency varchar(100)
	if (@URL like '%www.dol.gov%')
	begin
		set @Agency = replace(replace(replace(@URL,'http://www.dol.gov/',''),'https://www.dol.gov/',''),'http://www.dol.gov','')
		if (@Agency like '%/%')
			set @Agency = upper(left(@Agency,charindex('/',@Agency)-1))
		else if (@Agency like '%.%' or @Agency = '')
			set @Agency = 'DOL.Gov'
	end
	else
		select @Agency = upper(replace(replace(replace(replace(dbo.parseDomain(@URL),'www',''),'dol',''),'gov',''),'.',''))
	return @Agency
END


--select datalength(replace(replace(replace('http://www.dol.gov','http://www.dol.gov/',''),'https://www.dol.gov/',''),'http://www.dol.gov',''))
GO
/****** Object:  UserDefinedFunction [dbo].[getAgency]    Script Date: 09/13/2012 14:23:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
		delete from responses where dbo.parseDomain(URL) is null

		select * from responses

		Select dbo.getAgency(URL) Agency, count(*) AS VolumeOfFeedback,
		round(Cast(sum(cast(Positive as int)) as Float)/Cast(count(*) as Float)*100,2) AS Positive
		from responses
		group by dbo.getAgency(URL)
order by dbo.getAgency(URL)
	
		select * from responses where URL like '%welcome.html%' and Positive = 1
		select count(*) from responses where URL like 'http://www.dol.gov/dol%' and Positive = 0

*/
CREATE FUNCTION [dbo].[getAgency](@URL nvarchar(1024))
RETURNS varchar(100)
AS
BEGIN
	declare @Agency varchar(100)
	if (@URL like '%www.dol.gov%')
	begin
		set @Agency = replace(replace(@URL,'http://www.dol.gov/',''),'https://www.dol.gov/','')
		if (@Agency like '%/%')
			set @Agency = left(@Agency,charindex('/',@Agency)-1)
		else
			set @Agency = 'DOL.GOV'

	end
	else
		select @Agency = replace(replace(replace(replace(dbo.parseDomain(@URL),'wwww',''),'dol',''),'gov',''),'.','')
	return @Agency
END
GO
/****** Object:  UserDefinedFunction [dbo].[getCorrectAgencyName]    Script Date: 09/13/2012 14:23:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getCorrectAgencyName](@AgencyCode varchar(100))
RETURNS varchar(100)
AS
BEGIN
	declare @CorrectAgencyCode  varchar(100)
	set @CorrectAgencyCode = ''
	select @CorrectAgencyCode  = AgencyName from AgencyPattern where URLAgencyName = @AgencyCode
	if (@CorrectAgencyCode = '')
		set @CorrectAgencyCode = @AgencyCode
	return @CorrectAgencyCode	
END
GO
/****** Object:  UserDefinedFunction [dbo].[getURLAgencyName]    Script Date: 09/13/2012 14:23:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[getURLAgencyName](@AgencyCode varchar(100))
RETURNS varchar(100)
AS
BEGIN
	declare @CorrectAgencyCode  varchar(100)
	set @CorrectAgencyCode = ''
	select @CorrectAgencyCode  =  URLAgencyName  from AgencyPattern where AgencyName= @AgencyCode
	if (@CorrectAgencyCode = '')
		set @CorrectAgencyCode = @AgencyCode
	return @CorrectAgencyCode	
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteIfRecordsMoreThanOneYearOld]    Script Date: 09/13/2012 14:23:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ravi Ramu
-- Create date: 07/08/2011
-- Description:	Deleting feedback records those more than 1 year older
-- =============================================
CREATE PROCEDURE [dbo].[DeleteIfRecordsMoreThanOneYearOld]
AS
BEGIN
	Delete FROM Responses WHERE DATEADD(year, 1, UtcDate) < getdate()
	Delete FROM Comments WHERE DATEADD(year, 1, UtcDate) < getdate()
END
GO
/****** Object:  StoredProcedure [dbo].[spGetTopPages]    Script Date: 09/13/2012 14:23:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ravi Ramu
-- Create date: <06-17-2011>
-- Description:	<Top Pages>
--exec spGetTopPages '06-07-2011','07-08-2011 23:59:59'
--select getdate()
--select * from responses
--select min(utcdate) from responses
-- =============================================
CREATE PROCEDURE [dbo].[spGetTopPages]
	@FromDate as datetime, @ToDate as datetime
AS
BEGIN
	set @ToDate = @ToDate + ' 23:59:59'
	SET NOCOUNT ON;
	select 'AllAgency' as Agency, URL,VolumeOfFeedback,Positive,Negative, cast(Mean as int) as Mean
	from 
	(
		--Select URL, count(*) AS VolumeOfFeedback,(select count(*) from responses)/(select count(distinct URL) from responses) AS Mean   --, round(Cast(sum(cast(Positive as int)) as Float)/Cast(count(*) as Float)*100,2) AS Postive, round(Cast(Cast(count(*) as Float) - sum(cast(Positive as int)) as Float)/Cast(count(*) as Float)*100,2) AS Negative
		Select URL, count(*) AS VolumeOfFeedback,
		round(cast((select count(*) from responses where UtcDate >= @FromDate and UtcDate <= @ToDate) as float)/cast((select count(distinct URL) from responses where UtcDate >= @FromDate and UtcDate <= @ToDate) as float),0) Mean  --, round(Cast(sum(cast(Positive as int)) as Float)/Cast(count(*) as Float)*100,2) AS Postive, round(Cast(Cast(count(*) as Float) - sum(cast(Positive as int)) as Float)/Cast(count(*) as Float)*100,2) AS Negative
		,round(Cast(sum(cast(Positive as int)) as Float)/Cast(count(*) as Float)*100,2) AS Positive, 
		round(Cast(Cast(count(*) as Float) - sum(cast(Positive as int)) as Float)/Cast(count(*) as Float)*100,2) AS Negative
		from responses  _backup1
		where UtcDate >= @FromDate and UtcDate <= @ToDate
		group by URL
	) z
END
GO
/****** Object:  StoredProcedure [dbo].[spGetComments]    Script Date: 09/13/2012 14:23:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ravi Ramu
-- Create date: <06-23-2011>
-- Description:	<Summary Page>
--exec [spGetComments] 'http://www.dol.gov/','05-22-2011','07-07-2011'

-- =============================================
CREATE PROCEDURE [dbo].[spGetComments]
	@URL as nvarchar(1024), @FromDate as datetime, @ToDate as datetime
AS
BEGIN
		set @ToDate = @ToDate + ' 23:59:59'
		select  Convert(varchar,utcdate,101) utcDate,
				PostiveComments = case when positive = 1 and comment <> '' then comment end,
				NegativeComments = case when positive = 0 and comment <> '' then comment end
		from comments where URL = @URL and UtcDate >= @FromDate and UtcDate <= @ToDate
		order by utcdate desc
END
GO
/****** Object:  View [dbo].[AgencyList]    Script Date: 09/13/2012 14:23:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AgencyList]
AS
SELECT distinct upper(dbo.getCorrectAgencyName(dbo.getAgencyCode(URL))) Agency
FROM FeedbackScript.dbo.responses
GO
/****** Object:  StoredProcedure [dbo].[spGetAgencyList]    Script Date: 09/13/2012 14:23:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ravi Ramu
-- Create date: <06-24-2011>
-- Description:	<Summary Page>

--exec spGetAgencyList '06/06/2011', '07/07/2011'
-- =============================================
CREATE   PROCEDURE [dbo].[spGetAgencyList] @FromDate as datetime, @ToDate as datetime
AS
BEGIN
set @ToDate = @ToDate + ' 23:59:59'
select distinct Agency from 
(
	select 'DOL.GOV' Agency
	union all
	select distinct upper(dbo.GetCorrectAgencyName(Agency)) from responses where UtcDate >= @FromDate and UtcDate <= @ToDate
)z
where z.Agency <> ''
order by z.Agency

END
GO
/****** Object:  StoredProcedure [dbo].[spSummaryPages]    Script Date: 09/13/2012 14:23:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ravi Ramu
-- Create date: <06-23-2011>
-- Description:	<Summary Page>
--exec [spSummaryPages]'06-06-2013','07-07-2013'
--Select url,dbo.getAgencyCode(URL) from responses 
-- =============================================
CREATE PROCEDURE [dbo].[spSummaryPages]
	@FromDate as datetime, @ToDate as datetime
AS
BEGIN
		set @ToDate = @ToDate + ' 23:59:59'
		Select * from 
		(
			select 'DOL.Gov' Agency, count(*) AS VolumeOfFeedback,
			round(Cast(sum(cast(Positive as int)) as Float)/Cast(count(*) as Float)*100,2) AS Positive
			from responses where (UtcDate >= @FromDate and UtcDate <= @ToDate) having count(*) > 0
			union ALL
			Select upper(dbo.GetCorrectAgencyName(Agency)), count(*) AS VolumeOfFeedback,
			round(Cast(sum(cast(Positive as int)) as Float)/Cast(count(*) as Float)*100,2) AS Positive
			from responses where UtcDate >= @FromDate and UtcDate <= @ToDate
			group by Agency
		)z
		where z.Agency <> ''
		order by z.Agency
END

select * from responses

where agency = 'dol'
GO
/****** Object:  StoredProcedure [dbo].[spGetTrendResults]    Script Date: 09/13/2012 14:23:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ravi Ramu, Aarron Jones
-- Create date: <06-30-2011>
--Modified Date 11-21-2011

CREATE  PROCEDURE [dbo].[spGetTrendResults]
	@FromDate as datetime, @ToDate as datetime, @URLContains as varchar(1024) ,@SelectedAgency varchar(100), @UnitType char(1), @CustomOrder char
AS
BEGIN
	set @ToDate = @ToDate + ' 23:59:59'
	/*
	These 2 fields:
	CAST( COUNT((CASE WHEN 1=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS PositiveNoOfComments,
	CAST( COUNT((CASE WHEN 0=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS NegativeNoOfComments
	--Calculate counts using conditional counting, much faster than creating function to count each item then return.
	*/
	--Daily
	IF (@UnitType = 'D')
	BEGIN	
		IF (@SelectedAgency = 'DOL.Gov')
		BEGIN
			SELECT Convert(varchar,utcdate,101) Unit,
				count(*) AS VolumeOfFeedback,
				CAST( COUNT((CASE WHEN 1=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS PositiveNoOfComments,
				CAST( COUNT((CASE WHEN 0=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS NegativeNoOfComments
				FROM responses WHERE UtcDate >= @FromDate and UtcDate <= @ToDate and url like '%'+ @UrlContains + '%' 
				GROUP BY Convert(varchar,utcdate,101) ORDER BY Unit
		END
		else
		BEGIN
			SELECT Convert(varchar,utcdate,101) Unit,
				count(*) AS VolumeOfFeedback,
				CAST( COUNT((CASE WHEN 1=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS PositiveNoOfComments,
				CAST( COUNT((CASE WHEN 0=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS NegativeNoOfComments					
				FROM responses WHERE UtcDate >= @FromDate and UtcDate <= @ToDate and url like '%'+ @UrlContains + '%'  and Agency =  dbo.GetURLAgencyName(@SelectedAgency)
				GROUP BY Convert(varchar,utcdate,101) ORDER BY Unit	
		END
	END

	--Weekly
	IF (@UnitType = 'W')
	BEGIN
		IF (@SelectedAgency = 'DOL.Gov')
		BEGIN
			SELECT cast(year(utcdate) as varchar(10)) + '-' + cast(DatePart(wk,utcdate) as varchar(10)) Unit, 
				count(*) AS VolumeOfFeedback,
				CAST( COUNT((CASE WHEN 1=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS PositiveNoOfComments,
				CAST( COUNT((CASE WHEN 0=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS NegativeNoOfComments					
				FROM responses WHERE UtcDate >= @FromDate and UtcDate <= @ToDate and url like '%'+ @UrlContains + '%'
				GROUP BY year(utcdate),DatePart(wk,utcdate) ORDER BY year(utcdate) ,DatePart(wk,utcdate)
		END
		else
		BEGIN
			SELECT cast(year(utcdate) as varchar(10)) + '-' + cast(DatePart(wk,utcdate) as varchar(10)) Unit, 
				count(*) AS VolumeOfFeedback,
				CAST( COUNT((CASE WHEN 1=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS PositiveNoOfComments,
				CAST( COUNT((CASE WHEN 0=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS NegativeNoOfComments					
				FROM responses WHERE UtcDate >= @FromDate and UtcDate <= @ToDate and url like '%'+ @UrlContains + '%'  and Agency =  dbo.GetURLAgencyName(@SelectedAgency)
				GROUP BY year(utcdate),DatePart(wk,utcdate) ORDER BY year(utcdate) ,DatePart(wk,utcdate) 
		END
	END

	--Monthly
	IF (@UnitType = 'M')
	BEGIN	
		IF (@SelectedAgency = 'DOL.Gov')
		BEGIN
			IF (@CustomOrder = 'A')
			BEGIN
				SELECT SUBSTRING(CONVERT(varchar, utcdate, 100), 1, 3) + '-' +  SUBSTRING(CONVERT(varchar, utcdate, 100), 8, 4) Unit ,
				count(*) AS VolumeOfFeedback,
				CAST( COUNT((CASE WHEN 1=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS PositiveNoOfComments,
				CAST( COUNT((CASE WHEN 0=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS NegativeNoOfComments					
				FROM responses WHERE UtcDate >= @FromDate and UtcDate <= @ToDate and url like '%'+ @UrlContains + '%'
				GROUP BY SUBSTRING(CONVERT(varchar, utcdate, 100), 1, 3),SUBSTRING(CONVERT(varchar, utcdate, 100), 8, 4) ORDER BY MIN(utcdate)
			END
			else
			BEGIN
				SELECT SUBSTRING(CONVERT(varchar, utcdate, 100), 1, 3) + '-' +  SUBSTRING(CONVERT(varchar, utcdate, 100), 8, 4) Unit ,
				count(*) AS VolumeOfFeedback,
				CAST( COUNT((CASE WHEN 1=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS PositiveNoOfComments,
				CAST( COUNT((CASE WHEN 0=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS NegativeNoOfComments					
				FROM responses WHERE UtcDate >= @FromDate and UtcDate <= @ToDate and url like '%'+ @UrlContains + '%'
				GROUP BY SUBSTRING(CONVERT(varchar, utcdate, 100), 1, 3),SUBSTRING(CONVERT(varchar, utcdate, 100), 8, 4) ORDER BY MIN(utcdate) desc
			END
		END
		Else
		BEGIN
		IF (@CustomOrder = 'A')
			BEGIN
				SELECT SUBSTRING(CONVERT(varchar, utcdate, 100), 1, 3) + '-' +  SUBSTRING(CONVERT(varchar, utcdate, 100), 8, 4) Unit ,
				count(*) AS VolumeOfFeedback,
				CAST( COUNT((CASE WHEN 1=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS PositiveNoOfComments,
				CAST( COUNT((CASE WHEN 0=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS NegativeNoOfComments					
				FROM responses WHERE UtcDate >= @FromDate and UtcDate <= @ToDate and url like '%'+ @UrlContains + '%' and Agency =  dbo.GetURLAgencyName(@SelectedAgency)
				GROUP BY SUBSTRING(CONVERT(varchar, utcdate, 100), 1, 3),SUBSTRING(CONVERT(varchar, utcdate, 100), 8, 4) ORDER BY MIN(utcdate)
			END
			else
			BEGIN
				SELECT SUBSTRING(CONVERT(varchar, utcdate, 100), 1, 3) + '-' +  SUBSTRING(CONVERT(varchar, utcdate, 100), 8, 4) Unit ,
				count(*) AS VolumeOfFeedback,
				CAST( COUNT((CASE WHEN 1=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS PositiveNoOfComments,
				CAST( COUNT((CASE WHEN 0=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS NegativeNoOfComments					
				FROM responses WHERE UtcDate >= @FromDate and UtcDate <= @ToDate and url like '%'+ @UrlContains + '%' and Agency =  dbo.GetURLAgencyName(@SelectedAgency)
				GROUP BY SUBSTRING(CONVERT(varchar, utcdate, 100), 1, 3),SUBSTRING(CONVERT(varchar, utcdate, 100), 8, 4) ORDER BY MIN(utcdate) desc

			END
		END
			
	END
	--Quarterly
	IF (@UnitType = 'Q')
	BEGIN
		IF (@SelectedAgency = 'DOL.Gov')
		BEGIN
			SELECT cast(year(utcdate)as char(4)) + '-' + cast(DatePart(quarter,utcdate) as char(4)) Unit,
				count(*) AS VolumeOfFeedback,
				CAST( COUNT((CASE WHEN 1=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS PositiveNoOfComments,
				CAST( COUNT((CASE WHEN 0=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS NegativeNoOfComments					
				FROM responses WHERE UtcDate >= @FromDate and UtcDate <= @ToDate and url like '%'+ @UrlContains + '%'
				GROUP BY year(utcdate),DatePart(quarter,utcdate) ORDER BY year(utcdate),DatePart(quarter,utcdate)
		END
		else
		BEGIN
			SELECT cast(year(utcdate)as char(4)) + '-' + cast(DatePart(quarter,utcdate) as char(4)) Unit,
				count(*) AS VolumeOfFeedback,
				CAST( COUNT((CASE WHEN 1=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS PositiveNoOfComments,
				CAST( COUNT((CASE WHEN 0=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS NegativeNoOfComments					
				FROM responses WHERE UtcDate >= @FromDate and UtcDate <= @ToDate and url like '%'+ @UrlContains + '%' and Agency =  dbo.GetURLAgencyName(@SelectedAgency)
				GROUP BY year(utcdate),DatePart(quarter,utcdate) ORDER BY year(utcdate),DatePart(quarter,utcdate)
		END
	END

	--Yearly
	IF (@UnitType = 'Y')
	BEGIN
		IF (@SelectedAgency = 'DOL.Gov')
		BEGIN
			SELECT cast(year(utcdate) as varchar(6)) Unit,
				count(*) AS VolumeOfFeedback,
				CAST( COUNT((CASE WHEN 1=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS PositiveNoOfComments,
				CAST( COUNT((CASE WHEN 0=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS NegativeNoOfComments					
				FROM responses WHERE UtcDate >= @FromDate and UtcDate <= @ToDate and url like '%'+ @UrlContains + '%' 
				GROUP BY year(utcdate) ORDER BY year(utcdate)
		END
		else
		BEGIN
			SELECT cast(year(utcdate) as varchar(6)) Unit,
				count(*) AS VolumeOfFeedback,
				CAST( COUNT((CASE WHEN 1=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS PositiveNoOfComments,
				CAST( COUNT((CASE WHEN 0=Positive THEN 1 ELSE NULL END)) AS VARCHAR(100)) AS NegativeNoOfComments					
				FROM responses WHERE UtcDate >= @FromDate and UtcDate <= @ToDate and url like '%'+ @UrlContains + '%' and Agency =  dbo.GetURLAgencyName(@SelectedAgency)
				GROUP BY year(utcdate) ORDER BY year(utcdate)
		END
	END
END
GO
/****** Object:  UserDefinedFunction [dbo].[getCommentsCountforTrend]    Script Date: 09/13/2012 14:23:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from comments where url = 'http://www.dol.gov/EBSA/folder1/folder1/filename.htm'
select dbo.getCommentsCount('http://www.dol.gov/EBSA/folder5/folder1/filename.htm','01/01/1998','01/01/2012','gov','ebsa',0)

select z.fcount from
			(
				select count(*) fcount from comments where url like '%gov%' and upper(dbo.getCorrectAgencyName(dbo.getAgencyCode(URL))) = 'compliance' and Positive = 1  
				 and cast(year(utcdate) as varchar(25)) + '-' + cast(DatePart(quarter,utcdate) as varchar(25)) = '2010-2'
			)z

select z.fcount from
			(
				select count(*) fcount from comments where url like '%gov%' and upper(dbo.getCorrectAgencyName(dbo.getAgencyCode(URL))) = 'compliance' and Positive = 0  
				 and cast(year(utcdate) as varchar(25)) + '-' + cast(DatePart(quarter,utcdate) as varchar(25)) = '2010-2'
			)z

*/

CREATE FUNCTION [dbo].[getCommentsCountforTrend](@Unit as varchar(100), @URLContains as varchar(1024) ,@SelectedAgency varchar(100), @CommentsType as int, @UnitType as char(1))
RETURNS varchar(100)
AS
BEGIN
	declare @NoOfPositiveComments int
--Month
if (@UnitType = 'M')
begin
		if (@SelectedAgency = 'DOL.GOV')
		begin
			select @NoOfPositiveComments  = z.fcount from
			(
				select count(*) fcount from comments where url like '%' + @URLContains + '%' and Positive = @CommentsType  and CONVERT(CHAR(3), utcdate, 100) + '-' + CONVERT(CHAR(4), utcdate, 120) = @Unit
			)z 
		end
		else
		begin
			select @NoOfPositiveComments = z.fcount from
			(
				select count(*) fcount from comments where url like '%' + @URLContains + '%' and Agency = dbo.GetURLAgencyName(@SelectedAgency) and Positive = @CommentsType  
				 and CONVERT(CHAR(3), utcdate, 100) + '-' + CONVERT(CHAR(4), utcdate, 120) = @Unit 
			)z
		end
end
--Daily
if (@UnitType = 'D')
begin
		if (@SelectedAgency = 'DOL.GOV')
		begin
			select @NoOfPositiveComments  = z.fcount from
			(
				select count(*) fcount from comments where url like '%' + @URLContains + '%' and Positive = @CommentsType  and Convert(varchar,utcdate,101)= @Unit
			)z 
		end
		else
		begin
			select @NoOfPositiveComments = z.fcount from
			(
				select count(*) fcount from comments where url like '%' + @URLContains + '%' and Agency = dbo.GetURLAgencyName(@SelectedAgency) and Positive = @CommentsType  
				 and Convert(varchar,utcdate,101) = @Unit
			)z
		end
end
--Yearly
if (@UnitType = 'Y')
begin
		if (@SelectedAgency = 'DOL.GOV')
		begin
			select @NoOfPositiveComments  = z.fcount from
			(
				select count(*) fcount from comments where url like '%' + @URLContains + '%' and Positive = @CommentsType  and year(utcdate) = @Unit
			)z 
		end
		else
		begin
			select @NoOfPositiveComments = z.fcount from
			(
				select count(*) fcount from comments where url like '%' + @URLContains + '%' and Agency = dbo.GetURLAgencyName(@SelectedAgency) and Positive = @CommentsType  
				 and year(utcdate) = @Unit
			)z
		end
end
--Quarter
if (@UnitType = 'Q')
begin
		if (@SelectedAgency = 'DOL.GOV')
		begin
			select @NoOfPositiveComments  = z.fcount from
			(
				select count(*) fcount from comments where url like '%' + @URLContains + '%' and Positive = @CommentsType  and cast(year(utcdate) as varchar(25)) + '-' + cast(DatePart(quarter,utcdate) as varchar(25)) = @Unit
			)z 
		end
		else
		begin
			select @NoOfPositiveComments = z.fcount from
			(
				select count(*) fcount from comments where url like '%' + @URLContains + '%' and Agency = dbo.GetURLAgencyName(@SelectedAgency) and Positive = @CommentsType  
				 and cast(year(utcdate) as varchar(25)) + '-' + cast(DatePart(quarter,utcdate) as varchar(25)) = @Unit
			)z
		end
end
--Weekly
if (@UnitType = 'W')
begin
		if (@SelectedAgency = 'DOL.GOV')
		begin
			select @NoOfPositiveComments  = z.fcount from
			(
				select count(*) fcount from comments where url like '%' + @URLContains + '%' and Positive = @CommentsType  and cast(year(utcdate) as varchar(25)) + '-' + cast(DatePart(wk,utcdate) as varchar(25)) = @Unit
			)z 
		end
		else
		begin
			select @NoOfPositiveComments = z.fcount from
			(
				select count(*) fcount from comments where url like '%' + @URLContains + '%' and Agency = dbo.GetURLAgencyName(@SelectedAgency) and Positive = @CommentsType  
				 and cast(year(utcdate) as varchar(25)) + '-' + cast(DatePart(wk,utcdate) as varchar(25)) = @Unit
			)z
		end
end


				
return @NoOfPositiveComments 
--return @Unit
END

/*
Alter FUNCTION [dbo].[getCommentsCount](@URL as nvarchar(1024), @FromDate as datetime, @ToDate as datetime, @URLContains as varchar(1024) ,@SelectedAgency varchar(100), @CommentsType as int)
RETURNS int
AS
BEGIN
	declare @NoOfPositiveComments int
	
	select @NoOfPositiveComments = count(*) from comments where UtcDate >= @FromDate and UtcDate <= @ToDate and url like '%' + @URLContains + '%' and Agency = @SelectedAgency and Positive = @CommentsType  and URL = @URL

	return @NoOfPositiveComments 
END


*/
GO
/****** Object:  UserDefinedFunction [dbo].[getCommentsCountforTrend-bak]    Script Date: 09/13/2012 14:23:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from comments where url = 'http://www.dol.gov/EBSA/folder1/folder1/filename.htm'
select dbo.getCommentsCount('http://www.dol.gov/EBSA/folder5/folder1/filename.htm','01/01/1998','01/01/2012','gov','ebsa',0)

select z.fcount from
			(
				select count(*) fcount from comments where url like '%gov%' and upper(dbo.getCorrectAgencyName(dbo.getAgencyCode(URL))) = 'compliance' and Positive = 1 and Comment <> '' 
				 and cast(year(utcdate) as varchar(25)) + '-' + cast(DatePart(quarter,utcdate) as varchar(25)) = '2010-2'
			)z

select z.fcount from
			(
				select count(*) fcount from comments where url like '%gov%' and upper(dbo.getCorrectAgencyName(dbo.getAgencyCode(URL))) = 'compliance' and Positive = 0 and Comment <> '' 
				 and cast(year(utcdate) as varchar(25)) + '-' + cast(DatePart(quarter,utcdate) as varchar(25)) = '2010-2'
			)z

*/

create FUNCTION [dbo].[getCommentsCountforTrend-bak](@Unit as varchar(100), @URLContains as varchar(1024) ,@SelectedAgency varchar(100), @CommentsType as int, @UnitType as char(1))
RETURNS varchar(100)
AS
BEGIN
	declare @NoOfPositiveComments int

if (@UnitType = 'M')
begin
		if (@SelectedAgency = 'DOL.GOV')
		begin
			select @NoOfPositiveComments  = z.fcount from
			(
				select count(*) fcount from comments where url like '%' + @URLContains + '%' and Positive = @CommentsType and Comment <> '' and CONVERT(CHAR(4), utcdate, 100) + CONVERT(CHAR(4), utcdate, 120) = @Unit
			)z 
		end
		else
		begin
			select @NoOfPositiveComments = z.fcount from
			(
				select count(*) fcount from comments where url like '%' + @URLContains + '%' and Agency = dbo.GetURLAgencyName(@SelectedAgency) and Positive = @CommentsType and Comment <> '' 
				 and CONVERT(CHAR(4), utcdate, 100) + CONVERT(CHAR(4), utcdate, 120) = @Unit 
			)z
		end
end
if (@UnitType = 'D')
begin
		if (@SelectedAgency = 'DOL.GOV')
		begin
			select @NoOfPositiveComments  = z.fcount from
			(
				select count(*) fcount from comments where url like '%' + @URLContains + '%' and Positive = @CommentsType and Comment <> '' and Convert(varchar,utcdate,101)= @Unit
			)z 
		end
		else
		begin
			select @NoOfPositiveComments = z.fcount from
			(
				select count(*) fcount from comments where url like '%' + @URLContains + '%' and Agency = dbo.GetURLAgencyName(@SelectedAgency) and Positive = @CommentsType and Comment <> '' 
				 and Convert(varchar,utcdate,101) = @Unit
			)z
		end
end
if (@UnitType = 'Y')
begin
		if (@SelectedAgency = 'DOL.GOV')
		begin
			select @NoOfPositiveComments  = z.fcount from
			(
				select count(*) fcount from comments where url like '%' + @URLContains + '%' and Positive = @CommentsType and Comment <> '' and year(utcdate) = @Unit
			)z 
		end
		else
		begin
			select @NoOfPositiveComments = z.fcount from
			(
				select count(*) fcount from comments where url like '%' + @URLContains + '%' and Agency = dbo.GetURLAgencyName(@SelectedAgency) and Positive = @CommentsType and Comment <> '' 
				 and year(utcdate) = @Unit
			)z
		end
end
if (@UnitType = 'Q')
begin
		if (@SelectedAgency = 'DOL.GOV')
		begin
			select @NoOfPositiveComments  = z.fcount from
			(
				select count(*) fcount from comments where url like '%' + @URLContains + '%' and Positive = @CommentsType and Comment <> '' and cast(year(utcdate) as varchar(25)) + '-' + cast(DatePart(quarter,utcdate) as varchar(25)) = @Unit
			)z 
		end
		else
		begin
			select @NoOfPositiveComments = z.fcount from
			(
				select count(*) fcount from comments where url like '%' + @URLContains + '%' and Agency = dbo.GetURLAgencyName(@SelectedAgency) and Positive = @CommentsType and Comment <> '' 
				 and cast(year(utcdate) as varchar(25)) + '-' + cast(DatePart(quarter,utcdate) as varchar(25)) = @Unit
			)z
		end
end
if (@UnitType = 'W')
begin
		if (@SelectedAgency = 'DOL.GOV')
		begin
			select @NoOfPositiveComments  = z.fcount from
			(
				select count(*) fcount from comments where url like '%' + @URLContains + '%' and Positive = @CommentsType and Comment <> '' and cast(year(utcdate) as varchar(25)) + '-' + cast(DatePart(wk,utcdate) as varchar(25)) = @Unit
			)z 
		end
		else
		begin
			select @NoOfPositiveComments = z.fcount from
			(
				select count(*) fcount from comments where url like '%' + @URLContains + '%' and Agency = dbo.GetURLAgencyName(@SelectedAgency) and Positive = @CommentsType and Comment <> '' 
				 and cast(year(utcdate) as varchar(25)) + '-' + cast(DatePart(wk,utcdate) as varchar(25)) = @Unit
			)z
		end
end


				
return @NoOfPositiveComments 
--return @Unit
END

/*
Alter FUNCTION [dbo].[getCommentsCount](@URL as nvarchar(1024), @FromDate as datetime, @ToDate as datetime, @URLContains as varchar(1024) ,@SelectedAgency varchar(100), @CommentsType as int)
RETURNS int
AS
BEGIN
	declare @NoOfPositiveComments int
	
	select @NoOfPositiveComments = count(*) from comments where UtcDate >= @FromDate and UtcDate <= @ToDate and url like '%' + @URLContains + '%' and Agency = @SelectedAgency and Positive = @CommentsType and Comment <> '' and URL = @URL

	return @NoOfPositiveComments 
END


*/
GO
/****** Object:  UserDefinedFunction [dbo].[getCommentsCount]    Script Date: 09/13/2012 14:23:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from responses where url = 'http://www.dol.gov/EBSA/folder1/folder1/filename.htm'
select dbo.getCommentsCount('http://www.dol.gov/EBSA/folder5/folder1/filename.htm','01/01/1998','01/01/2012','gov','ebsa',0)
*/

CREATE FUNCTION [dbo].[getCommentsCount](@URL as nvarchar(1024), @FromDate as datetime, @ToDate as datetime, @URLContains as varchar(1024) ,@SelectedAgency varchar(100), @Type as int)
RETURNS varchar(100)
AS
BEGIN
set @ToDate = @ToDate + ' 23:59:59' 
declare @NoOfPositiveComments int

set @FromDate = CONVERT(VARCHAR(8), @FromDate, 1) 
set @ToDate =  CONVERT(VARCHAR(8), @ToDate, 1) 

if (@SelectedAgency = 'DOL.GOV')
begin
	select @NoOfPositiveComments  =  
		count(*) from comments where url like '%' + @URLContains + '%' and Positive = @Type and Comment <> '' and URL = @URL and UtcDate >=  @FromDate and UtcDate <=  @ToDate
end
else
begin
	select @NoOfPositiveComments = 
		count(*) from comments where url like '%' + @URLContains + '%' and Agency = dbo.GetURLAgencyNAme(@SelectedAgency) and Positive = @Type and Comment <> '' and URL = @URL and UtcDate >= @FromDate and UtcDate <= @ToDate
end
		
return @NoOfPositiveComments 
END

/*
Alter FUNCTION [dbo].[getCommentsCount](@URL as nvarchar(1024), @FromDate as datetime, @ToDate as datetime, @URLContains as varchar(1024) ,@SelectedAgency varchar(100), @Type as int)
RETURNS int
AS
BEGIN
	declare @NoOfPositiveComments int
	
	select @NoOfPositiveComments = count(*) from responses where UtcDate >= @FromDate and UtcDate <= @ToDate and url like '%' + @URLContains + '%' and Agency = @SelectedAgency and Positive = @Type and Comment <> '' and URL = @URL

	return @NoOfPositiveComments 
END


*/
GO
/****** Object:  StoredProcedure [dbo].[spGetSearchPages]    Script Date: 09/13/2012 14:23:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ravi Ramu
-- Create date: <06-24-2011>
-- Description:	<Summary Page>
--select dbo.getCommentsCount('http://www.dol.gov/EBSA/folder1/folder1/filename.htm',Jun 29 2011 12:00AM,May 22 1998 12:00AM,gov,EBSA,1)
--exec [spGetSearchPages]'01/01/1998','01/01/2012','folder','DOL.GOV'
--exec [spGetSearchPages]'06/06/2011','07/07/2011','','DOL.GOV'
--select *  from responses where url like '%ebsa%' 
--exec [spGetSearchPages] '01-01-1998','01-01-2012','','DOL.GOV'
--select dbo.getCommentsCount('http://www.dol.gov/EBSA/folder1/folder1/filename.htm','05-22-1998','06-29-2011','gov','EBSA',1)
-- =============================================
CREATE PROCEDURE [dbo].[spGetSearchPages]
	@FromDate as datetime, @ToDate as datetime, @URLContains as varchar(1024) ,@SelectedAgency varchar(100)
AS
BEGIN
		set @ToDate = @ToDate + ' 23:59:59' 
		if (@SelectedAgency = 'DOL.GOV')
		begin
			select URL, Agency = CASE when Agency = '' or Agency is null then 'DOL.GOV' else upper(dbo.GetCorrectAgencyName(Agency)) end
				,count(*) AS VolumeOfFeedback,round(Cast(sum(cast(Positive as int)) as Float)/Cast(count(*) as Float)*100,2) AS Positive,
				dbo.getCommentsCount(URL,@FromDate,@ToDate,@URLContains,@SelectedAgency,1) PositiveNoOfComments,
				dbo.getCommentsCount(URL,@FromDate,@ToDate,@URLContains,@SelectedAgency,0) NegativeNoOfComments 
			from responses where UtcDate >= @FromDate and UtcDate <= @ToDate and url like '%' + @URLContains + '%'
			group by URL,Agency
			having count(*) > 0
		end 
		else
		begin
			Select URL,upper(dbo.GetCorrectAgencyName(Agency)) Agency,VolumeOfFeedback,Positive,dbo.getCommentsCount(z.URL,@FromDate,@ToDate,@URLContains,@SelectedAgency,1) PositiveNoOfComments,
			dbo.getCommentsCount(z.URL,@FromDate,@ToDate,@URLContains,@SelectedAgency,0) NegativeNoOfComments from 
			(
				Select URL, Agency,count(*) AS VolumeOfFeedback
				,round(Cast(sum(cast(Positive as int)) as Float)/Cast(count(*) as Float)*100,2) AS Positive
				from responses where UtcDate >= @FromDate and UtcDate <= @ToDate and url like '%' + @URLContains + '%' and Agency =  dbo.GetURLAgencyName(@SelectedAgency)
				group by URL,Agency
			)z
		End
END
GO
/****** Object:  Default [DF_Responses_UtcDate]    Script Date: 09/13/2012 14:23:23 ******/
ALTER TABLE [dbo].[Responses] ADD  CONSTRAINT [DF_Responses_UtcDate]  DEFAULT (getdate()) FOR [UtcDate]
GO
/****** Object:  Default [DF_Comments_UtcDate]    Script Date: 09/13/2012 14:23:23 ******/
ALTER TABLE [dbo].[Comments] ADD  CONSTRAINT [DF_Comments_UtcDate]  DEFAULT (getutcdate()) FOR [UtcDate]
GO
