select *
from portfolio..coviddeaths
order by 3,4;

--select *
--from portfolio..covidvaccinations
--order by 3,4;

select Location , date, total_cases, new_cases, total_deaths, population 
From portfolio..coviddeaths
order by 1,2

-- Total cases vs Total deaths in India

select Location , date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as Deathpercentage
From portfolio..coviddeaths
where location = 'India'
order by 1,2

-- Looking the total cases with the population

select location , date, total_cases , population , (total_deaths/population) * 100 as PercentagePopulation
from portfolio..coviddeaths
--where location = 'India'
order by 1,2

-- Looking at countries with highest infection compared to the population in descending order

select location , population , max(total_cases) as HighestInfection, max((total_cases/population)*100) as Percentpopulation
from portfolio..coviddeaths
group by location,population
order by Percentpopulation desc

-- countries with highest death count per population
select location, max(cast(total_deaths as int)) as Totaldeathcount
from portfolio..coviddeaths
where continent is not null
group by location
order by Totaldeathcount desc

--Grouping by continent

select continent, max(cast(total_deaths as int)) as Totaldeathcount
from portfolio..coviddeaths
where continent is not null
group by continent
order by Totaldeathcount desc

-- showing continent with highest deathest count

select continent, max((total_deaths/population)* 100) as DeathPercentage
from portfolio..coviddeaths
group by continent
order by DeathPercentage

-- global numbers
select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as Deathpercentage
From portfolio..coviddeaths
where continent is not null
group by date
order by 1,2

-- Joining 2 tables

select *
from portfolio..coviddeaths dea
join portfolio..covidvaccinations vac
on dea.location = vac.location and dea.date = vac.date

--looking at total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from portfolio..coviddeaths dea
join portfolio..covidvaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
,
from portfolio..coviddeaths dea
join portfolio..covidvaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- Using CTE

With PopvsVac(continent, locations, date,  population ,new_vaccinations , PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from portfolio..coviddeaths dea
join portfolio..covidvaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (PeopleVaccinated/population)*100 as PercentageVaccinated
from PopvsVac






-- 
