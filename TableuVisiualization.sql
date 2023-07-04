
--Table 1
Select  SUM(new_cases) as Total_Cases, SUM(Cast(new_deaths as int)) as Total_Deaths, SUM(Cast(new_deaths as int)) / SUM(new_cases) * 100 As Death_Percentage
From PortfolioProject..CovidDeaths
Where continent is not null
  AND new_cases <> 0
  AND new_deaths <> 0
Order by 1,2

--Table 2
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Lower middle income', 'Low income')
Group by location
order by TotalDeathCount desc

--Table 3
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

--Table 4
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc