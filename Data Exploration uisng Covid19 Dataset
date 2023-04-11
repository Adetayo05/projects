/****** Script for Data Exploaration using Covid19 data  ******/
SELECT *
  FROM [PortfolioProject].[dbo].[CovidDeaths]
  order by 3,4

  SELECT *
  FROM [PortfolioProject].[dbo].[CovidVaccinations]
  order by 3,4

-- Select data we are going to be using
Select Location,Date,total_cases,new_cases,total_deaths,population
FROM [PortfolioProject].[dbo].[CovidDeaths]
  order by 1,2

-- Looking at total cases vs total deaths
-- shows likelihood of dying if you contract covid in your country
Select Location,Date,cast(total_cases as int),cast(total_deaths as int),
((cast(total_deaths as float)/cast(total_cases as float))*100) as DeathPercentage
FROM [PortfolioProject].[dbo].[CovidDeaths]
where Location like '%states%'
  order by 1,2

-- Looking at total cases vs population
-- Shows what percentage of population got Covid
Select Location,Date,population,cast(total_cases as int),
((cast(total_cases as float)/cast(population as float))*100) as PercentPopulationInfected
FROM [PortfolioProject].[dbo].[CovidDeaths]
where Location like '%Nigeria%'
 order by 4 desc

-- Loooking at countries with highest Infection Rate compared to Population
Select Location,population,max(cast(total_cases as int)) as HighestInfectionCount,
max((cast(total_cases as float)/cast(population as float))*100) as PercentPopulationInfected
FROM [PortfolioProject].[dbo].[CovidDeaths]
--where Location like '%Nigeria%'
Group by Location,population
 order by 4 desc

-- Showing Countries with Highest Death counts per Population
Select Location,max(cast(total_deaths as int)) as TotalDeathCount
FROM [PortfolioProject].[dbo].[CovidDeaths]
--where Location like '%Nigeria%'
where continent is not null
Group by Location
 order by 2 desc

-- Showing Death counts by Continents
Select continent,max(cast(total_deaths as int)) as TotalDeathCount
FROM [PortfolioProject].[dbo].[CovidDeaths]
where continent is not null
Group by continent 
 order by 2 desc

-- Showing Death counts by Income class Level
Select location,max(cast(total_deaths as int)) as TotalDeathCount
FROM [PortfolioProject].[dbo].[CovidDeaths]
where location in('High income','Upper middle income','Low income','Lower middle income')
Group by location 
 order by 2 desc

--  Showing continents with the highest death count per population
Select continent,max(cast(total_deaths as int)) as TotalDeathCount
FROM [PortfolioProject].[dbo].[CovidDeaths]
where continent is not null
Group by continent 
 order by 2 desc

-- Global cases and deaths per day
set ARITHABORT OFF;-- I SET the ARITHABORT Off to avoid the division by zero error
SET ANSI_WARNINGS off; -- To disable the warning display

Select Date ,sum(cast(new_cases as int)) as CaseCounts,sum(cast(new_deaths as int)) as DeathCounts,
sum(cast(new_deaths as float))/sum(cast(new_cases as float))*100 as DeathPercent_Perday
FROM [PortfolioProject].[dbo].[CovidDeaths]
where continent is not null
group by date
 order by 1

-- Showing total cases and total death across the Globe
Select sum(cast(new_cases as int)) as CaseCounts,sum(cast(new_deaths as int)) as DeathCounts,
sum(cast(new_deaths as float))/sum(cast(new_cases as float))*100 as DeathPercent_Perday
FROM [PortfolioProject].[dbo].[CovidDeaths]
where continent is not null
 order by 1

 
 -- Looking at Total Pop. vs Total_Vaccinated per day
 WITH PopvsVac (continent,location,date,population,new_vaccinations,Total_Vaccinated)
 as
(select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.date) as Total_Vaccinated
from PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select*,Total_Vaccinated/population*100 as PopvsVac_Percent
from PopvsVac
order by 1

-- Looking at Total Pop. vs Total_Vaccinated (In Summary):
-- USING CTE
 WITH PopvsVac (continent,location,date,population,new_vaccinations,Total_Vaccinated)
 as
(select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.date) as Total_Vaccinated
from PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select continent,location,population,max(total_vaccinated) as Total_Vaccinated,max(total_vaccinated)/population *100 as PopvsVac_Percent
from PopvsVac
group by continent,location,population
order by 1

--UISNG TEMP TABLE
Drop Table if Exists #PopvsVacPercent
Create Table #PopvsVacPercent(
Continent nvarchar(255),Location nvarchar(255),Date datetime,
Population numeric,New_Vaccinations numeric,Total_Vaccinated numeric)

Insert into #PopvsVacPercent
select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.date) as Total_Vaccinated
from PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

Select Continent, Location,Population,Sum(New_Vaccinations) AS Total_Vaccinated,Sum(New_Vaccinations)/Population*100 as PopvsVacPercent
from #PopvsVacPercent
group by Continent, Location,Population

Select Continent, Location,Population,Max(Total_Vaccinated) as Total_Vaccinated,Max(Total_Vaccinated)/Population*100 as PopvsVacPercent
from #PopvsVacPercent
group by Continent, Location,Population

--Creating views to store data later for visualization
Create view PercentPopVacinnated as
select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.date) as Total_Vaccinated
from PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select * from PercentPopVacinnated
