--Select *
--From CovidDeaths
--order by 3,4 

--Select *
--From CovidVaccinations
--order by 3,4 

Select Location, date, total_cases, new_cases, total_deaths, population 
From PortfolioProject..CovidDeaths
order by 1,2

-- Looking at Total cases versus total deaths
-- shows likelihood of dying in nigeria
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
From PortfolioProject..CovidDeaths
where location like '%nigeria%'
order by 1,2

-- Looking at total cases vs population
-- shows what percentage of population that contacted covid

Select Location, date, total_cases, population, (total_cases/population)*100 as percentofpopulationinfected
From PortfolioProject..CovidDeaths
where location like '%nigeria%'
order by 1,2

-- Looking at countries with infection ate compared to population

Select Location, max(total_cases) as highestinfectioncount, population, max(total_cases/population)*100 as percentofpopulationinfected
From PortfolioProject..CovidDeaths
group by location,population
order by percentofpopulationinfected desc


-- Showing countries with highest deaths

Select Location, max(cast (total_deaths as int)) as highestdeaths 
From PortfolioProject..CovidDeaths
where continent is not null
group by location
order by highestdeaths desc


#-- Showing continent with highest deaths
Select continent, max(cast (total_deaths as int)) as highestdeaths 
From PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by highestdeaths desc

Select location, max(cast (total_deaths as int)) as highestdeaths 
From PortfolioProject..CovidDeaths
where continent is null
group by location
order by highestdeaths desc

-- GLobal Numbers
Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as Deathpercentage
From PortfolioProject..CovidDeaths
where continent is not null
Group by date
order by 1,2

--Looking at total populaton vs vaccination

SElect dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as cumulative_vaccinations,
(cumulative_vaccinations/population)*100
From PortfolioProject..CovidDeaths  Dea
Join PortfolioProject..CovidVaccinations  Vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


--USE CTE(common table expressionn)

With PopvsVac (Continent, Location, Date, Population,New_Vaccinations, cumulative_vaccinations)
as
(
SElect dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as cumulative_vaccinations
From PortfolioProject..CovidDeaths  Dea
Join PortfolioProject..CovidVaccinations  Vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (cumulative_vaccinations/Population)*100
From PopvsVac


-- Temp Table
Drop Table if exists PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
cumulative_vaccinations numeric
)

Insert into PercentPopulationVaccinated
SElect dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as cumulative_vaccinations
From PortfolioProject..CovidDeaths  Dea
Join PortfolioProject..CovidVaccinations  Vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (cumulative_vaccinations/Population)*100
From PercentPopulationVaccinated


-- Creating view to store data for later visualizations

Create view PercentPopulationVaccinateds as
SElect dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as cumulative_vaccinations
From PortfolioProject..CovidDeaths  Dea
Join PortfolioProject..CovidVaccinations  Vac
	ON dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinateds