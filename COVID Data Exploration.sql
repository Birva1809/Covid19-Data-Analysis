--Select * 
--From CovidDeaths
--order by 3, 4

--Select * 
--From CovidVaccinations
--order by 3, 4

-- Select the data that we'll be using
Select location, date, total_cases, new_cases, total_deaths, population 
From CovidDeaths
order by 1, 2

-- Total Cases vs Total Deaths
Select location, date, total_cases, total_deaths, (total_deaths/ total_cases)* 100 as Death_Percent
From CovidDeaths
--order by 1, 2

-- Total Cases Vs Population
Select location, date, total_cases, population, (total_cases/ population)* 100 as Case_Percent
From CovidDeaths
Where location = 'India'
--order by 1, 2

--Max cases vs population ratio
Select location, population, max(total_cases) as Highest_Cases, max((total_cases/ population)* 100) as Case_Percent
From CovidDeaths
where continent is not null
GROUP BY location, population
order by Case_Percent desc

-- Total Deaths vs Population
Select location, date, total_deaths, population, (total_deaths/ population)* 100 as Death_Percent
From CovidDeaths
Where location = 'India'
--order by 1, 2

-- countries with max deaths
Select location, max(cast(total_deaths as int)) as TotalDeathCount
From CovidDeaths
where continent is not null
Group by location
order by TotalDeathCount desc

--Max deaths vs population ratio
Select location, population, max(cast(total_deaths as int)) as Highest_Deaths, max((total_deaths/ population)* 100) as Death_Percent
From CovidDeaths
where continent is not null
GROUP BY location, population
order by Death_Percent desc

-- Max deaths according to continent
Select location, max(cast(total_deaths as int)) as TotalDeathCount
From CovidDeaths
where continent is null 
Group by location
order by TotalDeathCount desc

--Global
Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases)) *100 as DeathPercentage
From CovidDeaths
where continent is not null
Group by date
order by 1, 2

-- total sum
Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases)) *100 as DeathPercentage
From CovidDeaths
where continent is not null
--Group by date
order by 1, 2



-- Total Population vs Vaccinations (CTE)

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location, cd.date) as RollingPeopleVaccinated
From CovidDeaths as cd
Join CovidVaccinations as cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null
--order by 2,3
)

Select *, (RollingPeopleVaccinated/ Population) *100
From PopvsVac



-- Creating Views
-- 1st View PercentPopulationVaccinated 
Create View PercentPopulationVaccinated as
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location, cd.date) as RollingPeopleVaccinated
From CovidDeaths as cd
Join CovidVaccinations as cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null
--order by 2,3

--2nd View Max cases vs population ratio
Create View CasesvsPop as
Select location, population, max(total_cases) as Highest_Cases, max((total_cases/ population)* 100) as Case_Percent
From CovidDeaths
where continent is not null
GROUP BY location, population
--order by Case_Percent desc

-- 3rd View Max deaths according to continent
Create View MaxDeathsCont as
Select location, max(cast(total_deaths as int)) as TotalDeathCount
From CovidDeaths
where continent is null 
Group by location
--order by TotalDeathCount desc

--4th View Max cases vs population ratio
Create View DeathsvsPop as
Select location, population, max(cast(total_deaths as int)) as Highest_Deaths, max((total_deaths/ population)* 100) as Death_Percent
From CovidDeaths
where continent is not null
GROUP BY location, population
--order by Death_Percent desc

-- 5th view total sum
Create View worldstats as
Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases)) *100 as DeathPercentage
From CovidDeaths
where continent is not null

