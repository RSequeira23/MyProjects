Select * From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4 

--Select * From PortfolioProject..CovidVacinations
--order by 3,4 

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Likelihood of dying if you contract the covid in the country

Select Location, date, total_cases, total_deaths, Cast(total_deaths As float) / Cast(total_cases As float) * 100 As Death_Percentage
From PortfolioProject..CovidDeaths
WHERE total_cases IS NOT NULL
  AND total_deaths IS NOT NULL
  --AND Location like '%Portugal%'
Order by 1,2					

-- Looking at Total Cases vs Population
-- Shows percentage of population got the virus

Select Location, date, Population, total_cases, Cast(total_cases As Float) / Population * 100 As Percent_Population_Infected
From PortfolioProject..CovidDeaths
WHERE total_cases IS NOT NULL
  AND total_deaths IS NOT NULL
  --AND Location like '%Portugal%'
Order by 1,2

-- Looking at countries with highest infection rate compared to Population
Select Location, Population, Max(Cast (total_cases as int)) as Highest_Infection_Count, Max(Cast(total_cases As Float) / Population) * 100 As Percent_Population_Infected
From PortfolioProject..CovidDeaths
WHERE total_cases IS NOT NULL
  AND total_deaths IS NOT NULL
 --AND Location like '%Portugal%'
Group by Location, Population
Order by Percent_Population_Infected Desc

-- Looking at countries with highest death count
Select Location, Max(Cast (total_deaths as int)) as Total_Death_Count
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location
Order by Total_Death_Count Desc

-- Looking at continents with highest death count	per population
Select continent, Max(Cast (total_deaths as int)) as Total_Death_Count
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
Order by Total_Death_Count Desc

-- Global death percentage per day

Select date, SUM(new_cases) as Total_Cases, SUM(Cast(new_deaths as int)) as Total_Deaths, SUM(Cast(new_deaths as int)) / SUM(new_cases) * 100 As Death_Percentage
From PortfolioProject..CovidDeaths
Where continent is not null
  AND new_cases <> 0
  AND new_deaths <> 0
Group by date
Order by Death_Percentage DESC

-- Global death percentage 

Select  SUM(new_cases) as Total_Cases, SUM(Cast(new_deaths as int)) as Total_Deaths, SUM(Cast(new_deaths as int)) / SUM(new_cases) * 100 As Death_Percentage
From PortfolioProject..CovidDeaths
Where continent is not null
  AND new_cases <> 0
  AND new_deaths <> 0

-- Total amount of people that got vaccinated

Select dea.continent, dea.location, dea.date, dea.population, IsNull(vac.new_vaccinations,'No people where vaccinated'),
SUM(Cast (vac.new_vaccinations as float)) Over (Partition by dea.location Order by dea.date) as Total_People_vacinnated
From PortfolioProject..CovidDeaths As dea
Join PortfolioProject..CovidVacinations As vac
     on dea.location = vac.location
	 AND dea.date = vac.date
Where dea.continent is not null
order by 2,3

-- Create Temp Table

Drop Table if exists #PercentagePopVac
Create Table #PercentagePopVac

(continent nvarchar(255),
location nvarchar(255),
date nvarchar(255),
population numeric,
new_vaccinations numeric,
Total_People_vacinnated numeric)

Insert into #PercentagePopVac
Select dea.continent, dea.location, dea.date, dea.population, Cast(vac.new_vaccinations as int),
SUM(Cast (vac.new_vaccinations as float)) Over (Partition by dea.location Order by dea.date) as Total_People_vacinnated
From PortfolioProject..CovidDeaths As dea
Join PortfolioProject..CovidVacinations As vac
     on dea.location = vac.location
	 AND dea.date = vac.date
Where dea.continent is not null
order by 2,3

Select *, IsNull((Total_People_vacinnated/Population) * 100,0) as Vaccinated_percentage
From #PercentagePopVac
Where new_vaccinations is not null
AND Total_People_vacinnated is not null

