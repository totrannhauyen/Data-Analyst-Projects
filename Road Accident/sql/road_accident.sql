--- Data
SELECT *
FROM road_accident


--- CY Casualties
SELECT SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022'

--- CY Accidents
SELECT COUNT(DISTINCT(accident_index)) AS CY_Accidents
FROM road_accident
WHERE YEAR(accident_date) = '2022'

--- CY Fatal Casualties
SELECT SUM(number_of_casualties) AS CY_Fatal_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022' AND accident_severity = 'Fatal'

SELECT CAST(SUM(number_of_casualties) AS decimal(10,2)) * 100/ 
	(SELECT CAST(SUM(number_of_casualties) AS decimal(10,2)) FROM road_accident WHERE YEAR(accident_date) = '2022' )
FROM road_accident
WHERE YEAR(accident_date) = '2022' AND accident_severity  = 'Fatal'

--- CY Serious Casualties
SELECT SUM(number_of_casualties) AS CY_Serious_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022' AND accident_severity = 'Serious'

SELECT CAST(SUM(number_of_casualties) AS decimal(10,2)) * 100/ 
	(SELECT CAST(SUM(number_of_casualties) AS decimal(10,2)) FROM road_accident WHERE YEAR(accident_date) = '2022' )
FROM road_accident
WHERE YEAR(accident_date) = '2022' AND accident_severity  = 'Serious'

--- CY Slight Casualties
SELECT SUM(number_of_casualties) AS CY_Slight_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022' AND accident_severity = 'Slight'

SELECT CAST(SUM(number_of_casualties) AS decimal(10,2)) * 100/ 
	(SELECT CAST(SUM(number_of_casualties) AS decimal(10,2)) FROM road_accident WHERE YEAR(accident_date) = '2022' )
FROM road_accident
WHERE YEAR(accident_date) = '2022' AND accident_severity  = 'Slight'

--- Casualties by Vehicle Type
SELECT 
	CASE
		WHEN vehicle_type IN('Agricultural vehicle') THEN 'Agricultural'
		WHEN vehicle_type IN('Car', 'Taxi/Private hire car') THEN 'Cars'
		WHEN vehicle_type IN('Motorcycle over 125cc and up to 500cc', 'Motorcycle 125cc and under','Motorcycle 50cc and under','Motorcycle over 500cc','Pedal cycle') THEN 'Bikes'
		WHEN vehicle_type IN('Goods over 3.5t. and under 7.5t', 'Goods 7.5 tonnes mgw and over',  'Van / Goods 3.5 tonnes mgw or under') THEN 'Vans'
		WHEN vehicle_type IN('Minibus (8 - 16 passenger seats)', 'Bus or coach (17 or more pass seats)') THEN 'Buses'
		ELSE 'Others'
	END AS Vehicle_group,
	SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY
	CASE
		WHEN vehicle_type IN('Agricultural vehicle') THEN 'Agricultural'
		WHEN vehicle_type IN('Car', 'Taxi/Private hire car') THEN 'Cars'
		WHEN vehicle_type IN('Motorcycle over 125cc and up to 500cc', 'Motorcycle 125cc and under','Motorcycle 50cc and under','Motorcycle over 500cc','Pedal cycle') THEN 'Bikes'
		WHEN vehicle_type IN('Goods over 3.5t. and under 7.5t', 'Goods 7.5 tonnes mgw and over',  'Van / Goods 3.5 tonnes mgw or under') THEN 'Vans'
		WHEN vehicle_type IN('Minibus (8 - 16 passenger seats)', 'Bus or coach (17 or more pass seats)') THEN 'Buses'
		ELSE 'Others'
	END
ORDER BY CY_Casualties ASC

--- CY Casualties Monthly
SELECT DATENAME(MONTH,accident_date) AS Month_Name, SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2021'
GROUP BY DATENAME(MONTH,accident_date)

SELECT DATENAME(MONTH,accident_date) AS Month_Name, SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY DATENAME(MONTH,accident_date)

--- Casualties by Road Type
SELECT road_type, SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY road_type
ORDER BY CY_Casualties ASC

--- Casualties by Location 
SELECT urban_or_rural_area,
	SUM(number_of_casualties) AS CY_Casualties, 
	CAST(SUM(number_of_casualties) AS decimal(10,2)) * 100 / (SELECT SUM(number_of_casualties) FROM road_accident WHERE YEAR(accident_date) = '2022') AS CY_Casualties_PCT
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY urban_or_rural_area
ORDER BY CY_Casualties_PCT ASC

--- Casualties by Light Conditions
SELECT
	CASE
		WHEN light_conditions = 'Daylight' THEN 'Day'
		ELSE 'Dark'
	END AS Light_Conditions,
	SUM(number_of_casualties) AS CY_Casualties,
	CAST(SUM(number_of_casualties) AS decimal(10,2)) * 100 / (SELECT SUM(number_of_casualties) FROM road_accident WHERE YEAR(accident_date) = '2022') AS CY_Casualties_PCT
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY CASE
			WHEN light_conditions = 'Daylight' THEN 'Day'
			ELSE 'Dark'
		END
ORDER BY CY_Casualties_PCT ASC

--- Casualties by Local Authority
SELECT TOP 10 local_authority, SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
GROUP BY local_authority
ORDER BY CY_Casualties DESC

--- Casualties by Weather Conditions
SELECT
	CASE
		WHEN weather_conditions IN('Raining no high winds', 'Raining + high winds') THEN 'Rain'
		WHEN weather_conditions IN('Fine + high winds', 'Fine no high winds') THEN 'Fine'
		WHEN weather_conditions IN('Snowing + high winds', 'Snowing no high winds', 'Fog or mist') THEN 'Snow/ Fog'
		ELSE 'Others'
	END AS Weather_Conditions,
	SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY CASE
		WHEN weather_conditions IN('Raining no high winds', 'Raining + high winds') THEN 'Rain'
		WHEN weather_conditions IN('Fine + high winds', 'Fine no high winds') THEN 'Fine'
		WHEN weather_conditions IN('Snowing + high winds', 'Snowing no high winds', 'Fog or mist') THEN 'Snow/ Fog'
		ELSE 'Others'
	END
ORDER BY CY_Casualties DESC


--- Casualties by Road Surface
SELECT
	CASE
		WHEN road_surface_conditions IN('Wet or damp', 'Flood over 3cm. deep') THEN 'Wet'
		WHEN road_surface_conditions IN('Snow', 'Frost or ice') THEN 'Snow/ Ice'
		WHEN road_surface_conditions IN('Dry') THEN 'Dry'
	END AS Road_Surface,
	SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY CASE
		WHEN road_surface_conditions IN('Wet or damp', 'Flood over 3cm. deep') THEN 'Wet'
		WHEN road_surface_conditions IN('Snow', 'Frost or ice') THEN 'Snow/ Ice'
		WHEN road_surface_conditions IN('Dry') THEN 'Dry'
	END
ORDER BY CY_Casualties DESC