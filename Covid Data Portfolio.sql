SELECT * 
FROM [Portfolio Project]..['Covid Deaths$']
Where continent is not null
order by 3, 4

SELECT *
FROM [Portfolio Project]..['Covid Vaccinations$']
ORDER BY 3, 4

-- Select Data that we are going to be using
Select location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Project]..['Covid Deaths$']
ORDER BY 1, 2

--Looking for Total Cases vs Total Deaths
--Shows what percentage of population got Covid
Select location, date,  Population,total_cases, (total_cases/Population)*100 as CatchPercentage
FROM [Portfolio Project]..['Covid Deaths$']
Where location = 'United States'
ORDER BY 1, 2



--Looking at Countries with highest infection Rate compared to Population

Select location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as MaxPercentage
From [Portfolio Project]..['Covid Deaths$']
Group by Location, population
order by 4 desc

----Showing Countries with Highest Death Count
SELECT location, MAX(cast(total_deaths as int)) as HighestDeaths
From [Portfolio Project]..['Covid Deaths$']
where continent is not null
Group by Location
order by HighestDeaths desc

--Showing continents with highest Death Count
--NA, SA, Asia highest 
SELECT continent, max(cast(total_deaths as int)) as ContinentDeaths
From [Portfolio Project]..['Covid Deaths$']
where continent is not null
group by continent
order by ContinentDeaths desc

--Global Numbers by Date
Select date, sum(new_cases), sum(cast(new_deaths as int)), (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercent
from [Portfolio Project]..['Covid Deaths$']
where continent is not null
group by date
order by 1,2

--Looking at Total Population vs. Vaccinations
--This ended up with VacPercent higher than 100 because people get more than 1 shot
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, vac.total_vaccinations, 
	(try_cast(vac.total_vaccinations as int)/dea.population)*100 as VacPercent
From [Portfolio Project]..['Covid Deaths$'] dea
Join [Portfolio Project]..['Covid Vaccinations$'] vac
	On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
		and dea.location = 'United States'
group by dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, vac.total_vaccinations
--not sure why I had to do this? ^
order by 2,3

--Trying again with different variable 
--People with at least 1 shot is 73.15%
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, vac.total_vaccinations, vac.people_vaccinated,
	(try_cast(vac.people_vaccinated as int)/dea.population)*100 as VacPercent
From [Portfolio Project]..['Covid Deaths$'] dea
Join [Portfolio Project]..['Covid Vaccinations$'] vac
	On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
		and dea.location = 'United States'
group by dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, vac.total_vaccinations, vac.people_vaccinated
--not sure why I had to do this? ^
order by 2,3
	
--looking at Population Density 
--no apparent correlation between population density and case percentage
select dea.continent, dea.location, dea.date, dea.population, vac.population_density, dea.total_cases, (dea.total_cases/dea.population)*100 as CasePercent
From [Portfolio Project]..['Covid Deaths$'] dea
Join [Portfolio Project]..['Covid Vaccinations$'] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
and dea.date = '2022-01-02 00:00:00.000'
order by 7 desc


--See Below for Tableau Dashboard of Visualized Data
https://public.tableau.com/app/profile/kirk.anthony.hum/viz/CovidDashboard_16516377849290/Dashboard1?publish=yes
