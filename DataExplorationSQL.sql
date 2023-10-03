--select * from [portfolio project]..CovidVaccinations
   --order by 3,4

select * from [portfolio project]..CovidDeaths
where continent is not null 
order by 3,4

Select location,date,total_cases, new_cases, total_deaths, population
from [portfolio project]..CovidDeaths
order by 1,2

--total cases vs total deaths
Select location,date,total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathsPercentage
from [portfolio project]..CovidDeaths
where location like '%states%'
order by 1,2

--total cases vs popoulation 
Select location,date,population, total_cases, (total_cases/population)*100 as populationPercentage
from [portfolio project]..CovidDeaths
where location like '%states%'
order by 1,2

-- Highest infection rate per population 
Select location,population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
from [portfolio project]..CovidDeaths
--where location like '%states%'
group by location,population
order by PercentPopulationInfected desc

-- countries with highest death counts 
Select location, max(cast(total_deaths as int) )as  TotalDeathCount
from [portfolio project]..CovidDeaths
--where location like '%states%'
group by location
order by TotalDeathCount desc

---- countries with highest death counts  by continent
Select location, max(cast(total_deaths as int) )as  TotalDeathCount
from [portfolio project]..CovidDeaths
where continent is null 
--where location like '%states%'
group by location
order by TotalDeathCount desc

-- Global Numbers per day 
Select date, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths,  SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathsPercentage
from [portfolio project]..CovidDeaths
where continent is not null
Group by date
order by 1,2
-- Global Numbers 
Select  SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths,  SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathsPercentage
from [portfolio project]..CovidDeaths
where continent is not null
order by 1,2

-- Total Population vs Vaccination 
Select Deat.continent, Deat.location, Deat.date, Deat.population, Vac.new_vaccinations,
SUM(Cast(Vac.new_vaccinations as int)) over (partition by deat.location order by deat.location, deat.date) 
as RollingPeopleVaccinated
from [portfolio project]..CovidDeaths Deat
join [portfolio project]..CovidVaccinations Vac
 on deat.date = Vac.date
 and Deat.location = Vac.location
 where Deat.continent is not null
 order by 2,3

  --Use of CTE to use the data of resulted coulmn such as RollingPeopleVaccinated
with PopVsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
  as 
(
Select Deat.continent, Deat.location, Deat.date, Deat.population, Vac.new_vaccinations,
SUM(Cast(Vac.new_vaccinations as int)) over (partition by deat.location order by deat.location, deat.date) 
as RollingPeopleVaccinated
from [portfolio project]..CovidDeaths Deat
join [portfolio project]..CovidVaccinations Vac
 on deat.date = Vac.date
 and Deat.location = Vac.location
 where Deat.continent is not null
 
 )

 select *, (RollingPeopleVaccinated/population)*100 as PercentPopulationVaccinated
 from PopVsVac

 --BY TEMP TABLE
 DROP TABLE If exists #PercentPopulationVaccinated

 CREATE TABLE #PercentPopulationVaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_Vaccinations numeric,
 RollingPeopleVaccinated numeric
 )
 INSERT INTO #PercentPopulationVaccinated
 Select Deat.continent, Deat.location, Deat.date, Deat.population, Vac.new_vaccinations,
SUM(Cast(Vac.new_vaccinations as int)) over (partition by deat.location order by deat.location, deat.date) 
as RollingPeopleVaccinated
from [portfolio project]..CovidDeaths Deat
join [portfolio project]..CovidVaccinations Vac
 on deat.date = Vac.date
 and Deat.location = Vac.location
 where Deat.continent is not null

 select *, (RollingPeopleVaccinated/population)*100 as PercentPopulationVaccinated
 from #PercentPopulationVaccinated

 -- Creating View for later visulaization 
 Create View PercentPopulationVaccinated 
 as 
 Select Deat.continent, Deat.location, Deat.date, Deat.population, Vac.new_vaccinations,
SUM(Cast(Vac.new_vaccinations as int)) over (partition by deat.location order by deat.location, deat.date) 
as RollingPeopleVaccinated
from [portfolio project]..CovidDeaths Deat
join [portfolio project]..CovidVaccinations Vac
 on deat.date = Vac.date
 and Deat.location = Vac.location
 where Deat.continent is not null
