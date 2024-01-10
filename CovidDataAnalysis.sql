--Covid Deaths Dataset
Select *
From Covid_db..CovidDeaths
Where continent is not null 
order by 3,4

--Covid Vaccinations Dataset
Select *
From Covid_db..CovidVaccinations
Where continent is not null 
order by 3,4

-- Select Data that we are going to be starting with

Select Location, CONVERT(DATE, CONVERT(DATE, date, 105), 101) AS Date, total_cases, new_cases, total_deaths, population
From Covid_db..CovidDeaths
Where continent is not null AND TRIM(continent) != ''
order by 1,2



--Total Cases vs Total Deaths
select 
	CONVERT(DATE, CONVERT(DATE, date, 105), 101) AS Date,
	location,
	SUM(CAST(total_cases AS FLOAT)) AS total_cases,
	SUM(CAST(total_deaths AS FLOAT)) AS total_deaths,
	CASE
		WHEN SUM(CAST(total_cases as float)) = 0 then null
		ELSE SUM(CAST(total_deaths as float))/ SUM(CAST(total_cases as float))*100 
	END as death_rate
from 
	Covid_db..CovidDeaths
Where 
	continent IS NOT NULL AND TRIM(continent) != ''
group by 
	location, date
order by 
	1,2;


--Total Cases vs Total Deaths in India
select 
	CONVERT(DATE, CONVERT(DATE, date, 105), 101) AS Date,
	location,
	SUM(CAST(total_cases AS FLOAT)) AS total_cases,
	SUM(CAST(total_deaths AS FLOAT)) AS total_deaths,
	CASE
		WHEN SUM(CAST(total_cases as float)) = 0 then null
		ELSE SUM(CAST(total_deaths as float))/ SUM(CAST(total_cases as float))*100 
	END as death_rate
from 
	Covid_db..CovidDeaths
Where location like 'India'
	and continent IS NOT NULL and TRIM(continent) != ''
group by 
	CONVERT(DATE, CONVERT(DATE, date, 105), 101),location
order by 1;



-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

SELECT
    date,
    location,
    total_cases,
    total_deaths,
    CASE
        WHEN TRY_CAST(total_cases AS FLOAT) = 0 OR TRY_CAST(population AS FLOAT) = 0 THEN NULL
        ELSE TRY_CAST(total_cases AS FLOAT) / NULLIF(TRY_CAST(population AS FLOAT), 0) * 100
    END AS PercentPopulationInfected
FROM
    Covid_db..CovidDeaths
WHERE
    continent IS NOT NULL 
    AND TRY_CAST(population AS FLOAT) IS NOT NULL
    AND TRY_CAST(population AS FLOAT) > 0
ORDER BY
    1, 2;

--option 2
select 
	CONVERT(DATE, CONVERT(DATE, date, 105), 101) AS formatted_date,
	location,
	SUM(CAST(total_cases AS FLOAT)) AS total_cases,
	SUM(CAST(total_deaths AS FLOAT)) AS total_deaths,
	CASE
		WHEN SUM(CAST(population as float)) = 0 then null
		ELSE SUM(CAST(total_cases as float))/ SUM(CAST(population as float))*100 
	END as PopulationInfected_Rate
from 
	Covid_db..CovidDeaths
Where continent IS NOT NULL and TRIM(continent) != ''
group by 
	CONVERT(DATE, CONVERT(DATE, date, 105), 101),location
order by 1;


-- Countries with Highest Infection Rate compared to Population
SELECT 
    location, 
    population, 
    MAX(CAST(total_cases AS FLOAT)) AS HighestInfectionCount,
    CASE 
        WHEN MAX(CAST(population AS FLOAT)) = 0 THEN NULL
        ELSE MAX(CAST(total_cases AS FLOAT)) / MAX(CAST(population AS FLOAT)) * 100 
    END AS PercentPopulationInfected
FROM 
    Covid_db..CovidDeaths
GROUP BY 
    location, population
ORDER BY 
    PercentPopulationInfected desc;

-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From Covid_db..CovidDeaths
Where continent IS NOT NULL AND TRIM(continent) != ''
Group by Location
order by TotalDeathCount desc;

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

SELECT 
    Continent,
    SUM(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM 
    Covid_db..CovidDeaths
WHERE 
    Continent IS NOT NULL and TRIM(continent)!= ' '  
GROUP BY 
    Continent
ORDER BY 
    TotalDeathCount DESC;



--Global Numbers
select CONVERT(DATE, CONVERT(DATE, date, 105), 101) AS Date, sum(cast(new_cases as float)) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, 
CASE
     WHEN SUM(CAST(new_cases AS FLOAT)) = 0 THEN 0  -- Handles division by zero
     ELSE (SUM(CAST(new_deaths AS INT)) / SUM(CAST(new_cases AS FLOAT))) * 100
END AS Death_Percentage
from Covid_db..CovidDeaths
where continent is not null and trim(continent)!= ' '
group by CONVERT(DATE, CONVERT(DATE, date, 105), 101) 
order by 1,2;

-- Getting only the final numbers
select --CONVERT(DATE, CONVERT(DATE, date, 105), 101) AS Date, 
sum(cast(new_cases as float)) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, 
CASE
     WHEN SUM(CAST(new_cases AS FLOAT)) = 0 THEN 0  -- Handles division by zero
     ELSE (SUM(CAST(new_deaths AS INT)) / SUM(CAST(new_cases AS FLOAT))) * 100
END AS Death_Percentage
from Covid_db..CovidDeaths
where continent is not null and trim(continent)!= ' '
--group by CONVERT(DATE, CONVERT(DATE, date, 105), 101) 
order by 1,2;



--Covid Vaccination dataset
Select *
From Covid_db..CovidVaccinations
Where continent is not null 
order by 3,4;

--Total Population vs Vaccinations
select A.continent, 
A.location,
CONVERT(DATE, A.[date],105) as Date, 
A.population, 
B.new_vaccinations ,
SUM(CONVERT(int,B.new_vaccinations)) OVER (Partition by A.Location Order by A.location, CONVERT(DATE, A.[date], 105)) as RollingPeopleVaccinated
from Covid_db..CovidDeaths A
join Covid_db..CovidVaccinations B
on A.location = B.location
and A.[date] = B.date
where A.continent is not null and trim(A.continent)!=' '
order by 2,3;

--Using CTE to perform Calculation on Partition By for finding Total Population vs Vaccinations

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) AS (
    SELECT 
        dea.continent, 
        dea.location, 
        CONVERT(DATE, dea.[date], 105) AS Date, -- Assuming 'date' column holds date as VARCHAR in 'DD-MM-YYYY' format
        dea.population, 
        vac.new_vaccinations,
        SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, CONVERT(DATE, dea.[date], 105)) AS RollingPeopleVaccinated
    FROM 
        Covid_db..CovidDeaths dea
    JOIN 
        Covid_db..CovidVaccinations vac ON dea.location = vac.location AND dea.[date] = vac.date -- Assuming 'date' column holds date as VARCHAR in 'DD-MM-YYYY' format
    WHERE 
        dea.continent IS NOT NULL  
        AND TRIM(dea.continent) != ''
)
SELECT 
    *,
    CASE 
        WHEN Population != 0 THEN (RollingPeopleVaccinated * 100.0) / NULLIF(Population, 0)
        ELSE 0 
    END AS VaccinationPercentage
FROM 
    PopvsVac
ORDER BY Continent, Date; -- Ordering by the converted Date column

-- Using Temp Table to perform Calculation on Partition By in previous query
DROP Table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
select 
A.continent, 
A.location,
CONVERT(DATE, A.[date],105) as Date, 
TRY_CONVERT(NUMERIC, A.population) AS Population, -- Try converting to NUMERIC
TRY_CONVERT(NUMERIC, B.new_vaccinations) AS new_vaccinations, -- Try converting to NUMERIC
SUM(CONVERT(int,B.new_vaccinations)) OVER (Partition by A.Location Order by A.location, CONVERT(DATE, A.[date], 105)) as RollingPeopleVaccinated
from Covid_db..CovidDeaths A
join Covid_db..CovidVaccinations B
on A.location = B.location
and A.[date] = B.date
--where A.continent is not null and trim(A.continent)!=' '
--order by 2,3

SELECT 
    *,
    CASE 
        WHEN Population != 0 THEN (RollingPeopleVaccinated * 100.0) / NULLIF(Population, 0)
        ELSE 0 
    END AS VaccinationPercentage
FROM 
    #PercentPopulationVaccinated
--ORDER BY Continent, Date;


--Creating View to store data for later visualizations
--View 1

Create view PercentPopulationVaccinated as
select 
A.continent, 
A.location,
CONVERT(DATE, A.[date],105) as Date, 
TRY_CONVERT(NUMERIC, A.population) AS Population, -- Try converting to NUMERIC
TRY_CONVERT(NUMERIC, B.new_vaccinations) AS new_vaccinations, -- Try converting to NUMERIC
SUM(CONVERT(int,B.new_vaccinations)) OVER (Partition by A.Location Order by A.location, CONVERT(DATE, A.[date], 105)) as RollingPeopleVaccinated
from Covid_db..CovidDeaths A
join Covid_db..CovidVaccinations B
on A.location = B.location
and A.[date] = B.date
where A.continent is not null and trim(A.continent)!=' ';

select * from PercentPopulationVaccinated;

--View 2
Create view Death_Percentage as
select --CONVERT(DATE, CONVERT(DATE, date, 105), 101) AS Date, 
sum(cast(new_cases as float)) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, 
CASE
     WHEN SUM(CAST(new_cases AS FLOAT)) = 0 THEN 0  -- Handles division by zero
     ELSE (SUM(CAST(new_deaths AS INT)) / SUM(CAST(new_cases AS FLOAT))) * 100
END AS Death_Percentage
from Covid_db..CovidDeaths
where continent is not null and trim(continent)!= ' '
--group by CONVERT(DATE, CONVERT(DATE, date, 105), 101) 
--order by 1,2;

select * from Death_Percentage;

--View 3
Create view ContinentwiseCovidDeathSummary as
SELECT 
    Continent,
    SUM(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM 
    Covid_db..CovidDeaths
WHERE 
    Continent IS NOT NULL and TRIM(continent)!= ' '  
GROUP BY 
    Continent
--ORDER BY 
--    TotalDeathCount DESC;

select * from ContinentwiseCovidDeathSummary;