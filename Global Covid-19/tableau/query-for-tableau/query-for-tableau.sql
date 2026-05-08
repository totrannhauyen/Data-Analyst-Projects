--- Query 1
SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths, SUM(CAST(new_deaths AS INT)) * 100.0 / NULLIF(SUM(new_cases), 0) AS DeathPercentage
FROM [covid-deaths].[dbo].CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

--- Query 2
SELECT location, SUM(CAST(new_deaths as int)) AS TotalDeathCount
FROM [covid-deaths].[dbo].CovidDeaths
WHERE continent IS NOT NULL 
	and location not in ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC;


--- Query 3
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM [covid-deaths].[dbo].CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;

--- Query 4
SELECT location, population, date, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM [covid-deaths].[dbo].CovidDeaths
GROUP BY location, population, date
ORDER BY PercentPopulationInfected DESC;