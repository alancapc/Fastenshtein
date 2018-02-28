-- First get your knowledge together https://en.wikipedia.org/wiki/Levenshtein_distance

-- Now to Code!

-- step 0: initialise trustworthiness on database
ALTER DATABASE test SET TRUSTWORTHY ON

-- step 1: just create an assembly that is visible to sql
CREATE ASSEMBLY [System.Messaging]
FROM 'C:\Windows\Microsoft.NET\Framework64\v4.0.30319\System.Messaging.dll'
WITH PERMISSION_SET = UNSAFE;
GO 

-- step 2: now register your custom assembly
--DROP ASSEMBLY [Fastenshtein] -- well, I had to try this twice because of overloads XD.
CREATE ASSEMBLY [Fastenshtein] AUTHORIZATION [dbo]
FROM 'C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Fastenshtein.dll' 
WITH PERMISSION_SET = UNSAFE
GO

-- step 3: create a function based on one of your assembly's methods, overloads don't work so beware.
CREATE FUNCTION [Levenshtein](@s [nvarchar](4000), @t [nvarchar](4000))
RETURNS [int] WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [Fastenshtein].[Fastenshtein.Levenshtein].[DistanceDouble] -- Double is just the name, distance is to overcome overload in this example
GO

-- step 4: enable execution of user code in the .net framework 
EXEC sp_configure 'clr enabled', 1
 go
 RECONFIGURE
 go
EXEC sp_configure 'clr enabled'
 GO

-- step 5: finally consume your function.
DECLARE @retVal as integer
select @retVal = [dbo].[Levenshtein]('12345','12345')
Select @retVal AS 'Distance'
select @retVal = [dbo].[Levenshtein]('12345','54321')
Select @retVal AS 'Distance'
select @retVal = [dbo].[Levenshtein]('12345','123')
Select @retVal AS 'Distance'
select @retVal = [dbo].[Levenshtein]('12345','1')
Select @retVal AS 'Distance'
select @retVal = [dbo].[Levenshtein]('12345','')
Select @retVal AS 'Distance'

-- step 6: be happy and get this nugget into your project. cool stuff.
