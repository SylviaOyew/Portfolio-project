

Select *
from [Portfolio project]..covidDeaths
Where continent is not null  and continent <> ''
order by 3,4


----Select *
----from [Portfolio project]..covidvaccines
----order by 3,4

Select Location, date,new_cases, total_deaths, population
From [Portfolio project]..covidDeaths
Where continent is not null  and continent <> ''
order by 1,2



--LOooking at Total Cases Vs Total Death
-- this shows the likelihood of Death in the various Country if they come into contact with the Covid19 virus

Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from [Portfolio project]..covidDeaths
Where continent is not null  and continent <> ''
order by 1,2

--Loooking at the Total cases vs Population
-- This shows the percentage of the population of the various countries that got covid19

Select location, date, total_cases,population, 
(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS Populationpercentage
from [Portfolio project]..covidDeaths
Where continent is not null
order by 1,2 

--Loocking at the countries with Highest Infection Rate

Select location,
population,
Max(total_cases) as HighestIfectionCount,
Max(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS PopulationPercetangeInfected
from [Portfolio project]..covidDeaths
Where continent is not null
Group by location, population
order by PopulationPercetangeInfected Desc


--Countries with the Highest Death Rate


Select location,
MAX(Cast(total_deaths AS int)) as TotalDeathCount 
from [Portfolio project]..covidDeaths
Where continent is not null  and continent <> ''
Group by location
order by TotalDeathCount Desc


--VIEWING BY CONTINENT

Select continent,
MAX(Cast(total_deaths AS int)) as TotalDeathCount 
from [Portfolio project]..covidDeaths
Where continent is not null  and continent <> ''
Group by continent
order by TotalDeathCount Desc

--GLOABL NUMBERS 

Select date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from [Portfolio project]..covidDeaths
Where continent is not null  and continent <> ''
order by 1,2





Select date, Sum(Convert(float, total_cases)) as Sum_of_New_cases,
Sum(Cast(new_deaths as int)) as Sum_of_New_Death
from [Portfolio project]..covidDeaths
Where continent is not null  and continent <> ''
Group by date
order by 1,2


Select date, Sum(Convert(float, total_cases)) as Sum_of_New_cases,
Sum(Cast(new_deaths as int)) as Sum_of_New_Death, Sum(Cast(new_deaths as int))/Sum(NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
from [Portfolio project]..covidDeaths
Where continent is not null  and continent <> ''
Group by date
order by 1,2

Select
Sum(Convert(float, total_cases)) as Sum_of_New_cases,
Sum(Cast(new_deaths as int)) as Sum_of_New_Death, Sum(Cast(new_deaths as int))/Sum(NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
from [Portfolio project]..covidDeaths
Where continent is not null and continent <> ''
--Group by date
order by 1,2


--Loooking total Population Vs Vaccinations

Select *
from [Portfolio project]..covidvaccines vac
Join [Portfolio project]..covidDeaths dea
     on vac.location =dea.location
	 and vac.date = dea.date

----CTE

With PopulationvsVac (continent, location, date, population, new_vaccinations,
RollingVaccination) as 

(
Select
 dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 Sum(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,
 dea.date) as RollingVaccination
from [Portfolio project]..covidvaccines vac
Join [Portfolio project]..covidDeaths dea
     on vac.location =dea.location
	 and vac.date = dea.date
Where dea.continent is not null and dea.continent <> ''
--order by 2,3
)

Select *, (RollingVaccination/population)*100
From  PopulationvsVac

Create View RollingVaccination as 
Select
 dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 Sum(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,
 dea.date) as RollingVaccination
from [Portfolio project]..covidvaccines vac
Join [Portfolio project]..covidDeaths dea
     on vac.location =dea.location
	 and vac.date = dea.date
Where dea.continent is not null and dea.continent <> ''