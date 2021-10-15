--IMPORTING DATA
--Uniting all monthly tables in one Year table

INSERT INTO [Portfolio Project 1]..Year
SELECT * 
FROM [Portfolio Project 1]..[2020_October]

INSERT INTO [Portfolio Project 1]..Year
SELECT * 
FROM [Portfolio Project 1]..[2020_November]

ALTER TABLE Year
ALTER COLUMN start_station_id nvarchar(255)
GO

ALTER TABLE Year
ALTER COLUMN end_station_id nvarchar(255)
GO

INSERT INTO [Portfolio Project 1]..Year
SELECT * 
FROM [Portfolio Project 1]..[2020_December]

INSERT INTO [Portfolio Project 1]..Year
SELECT * 
FROM [Portfolio Project 1]..[2021_January]

INSERT INTO [Portfolio Project 1]..Year
SELECT * 
FROM [Portfolio Project 1]..[2021_February]

INSERT INTO [Portfolio Project 1]..Year
SELECT * 
FROM [Portfolio Project 1]..[2021_Mart]

INSERT INTO [Portfolio Project 1]..Year
SELECT * 
FROM [Portfolio Project 1]..[2021_April]

INSERT INTO [Portfolio Project 1]..Year
SELECT * 
FROM [Portfolio Project 1]..[2021_May]

INSERT INTO [Portfolio Project 1]..Year
SELECT * 
FROM [Portfolio Project 1]..[2021_June]

INSERT INTO [Portfolio Project 1]..Year
SELECT * 
FROM [Portfolio Project 1]..[2021_July]

INSERT INTO [Portfolio Project 1]..Year
SELECT * 
FROM [Portfolio Project 1]..[2021_August]

INSERT INTO [Portfolio Project 1]..Year
SELECT * 
FROM [Portfolio Project 1]..[2021_September]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

--DATA CLEANING
--Removing Duplicates

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER()OVER(
	PARTITION BY started_at,
				 ended_at,
				 start_station_name,
				 end_station_name
				 ORDER BY
					ride_id
					) row_num

FROM [Portfolio Project 1]..Year
)
DELETE
From RowNumCTE
Where row_num > 1

-- Detecting incosistencies in data
Select *
FROM [Portfolio Project 1]..Year
where started_at > ended_at --ride end time is earlier than start time (probably caused by system glith in specific bikes)
order by started_at
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------

--DATA EXPLORATION

--Looking at how many rides were made (casual vs member)

Select Distinct (member_casual), Count(member_casual) as number_of_rides
From [Portfolio Project 1]..Year
Group by member_casual
order by member_casual

--Looking at how many rides were made each month (members vs casual)
Select CONVERT(date, started_at) as Date, Count(DATENAME(M, started_at)) as number_of_rides_member, member_casual
From [Portfolio Project 1]..Year
Group by CONVERT(date, started_at)
		 ,member_casual
order by CONVERT(date, started_at)

--Looking at how many rides were made on weekdays and weekends (members vs casual)
Select DATENAME(DW, started_at) as Week_name, member_casual,Count(DATENAME(DW, started_at)) as number_of_rides
From [Portfolio Project 1]..Year
Group by DATENAME(DW, started_at),
		 member_casual
order by DATENAME(DW, started_at),
		 member_casual 

Select DATENAME(W, started_at) as Week_name, member_casual,Count(DATENAME(W, started_at)) as number_of_rides
From [Portfolio Project 1]..Year
Group by DATENAME(W, started_at),
		 member_casual
order by DATENAME(W, started_at),
		 member_casual 

--Looking at how many rides were made on different times of the day (members vs casual)


Select DATEPART(hour, started_at) as Hour, Count(DATEPART(hour, started_at)) as number_of_rides, member_casual, DATENAME(DW, started_at) as Week_name
From [Portfolio Project 1]..Year
Group by DATEPART(hour, started_at),
		 DATENAME(DW, started_at),
		 member_casual
order by DATEPART(hour, started_at),
		 member_casual

--Looking at how long costumers ride the bike (members vs casual)
Select DATEPART(MI, ended_at - started_at) as Minutes, Count(DATEPART(MI, ended_at - started_at)) as number_of_rides, member_casual
From [Portfolio Project 1]..Year
Group by DATEPART(MI, ended_at - started_at),
		 member_casual
order by DATEPART(MI, ended_at - started_at),
		 member_casual

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Looking at what type of bikes costumers use (members vs casual)

Select Distinct (rideable_type), Count(rideable_type) as number_of_rides, member_casual
From [Portfolio Project 1]..Year
Group by member_casual,
	     rideable_type
order by rideable_type


-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Looking at how many rides started/ended on each station

Select Distinct (start_station_name), Count(start_station_name) as number_of_rides_started, 
									  AVG(start_lat) as average_start_lat, AVG(start_lng) as average_start_lng, member_casual
From [Portfolio Project 1]..Year
where start_station_name is not NULL
Group by start_station_name,
		 member_casual
order by Count(start_station_name) desc

Select Distinct (end_station_name) ,Count(end_station_name) as number_of_rides_ended,
									  AVG(end_lat) as avarage_end_lat, AVG(end_lng) as average_end_lng
From [Portfolio Project 1]..Year
where end_station_name is not NULL and member_casual = 'casual'
Group by end_station_name
order by Count(end_station_name) desc


Select Distinct (end_station_name) ,Count(end_station_name) as number_of_rides_ended,
									  AVG(end_lat) as avarage_end_lat, AVG(end_lng) as average_end_lng
From [Portfolio Project 1]..Year
where end_station_name is not NULL and member_casual = 'member'
Group by end_station_name
order by Count(end_station_name) desc

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Looking at how many stations are there

Select Count(Distinct start_station_name) as number_of_stations_start
From [Portfolio Project 1]..Year

Select Count(Distinct end_station_name) as number_of_stations_end
From [Portfolio Project 1]..Year

Select *
From [Portfolio Project 1]..Year