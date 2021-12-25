-------------------- Exploratory Data Analysis since the first case to 2021/11/09 ----------------------

select  *from dbo.['owid-covid-data$']

--Countries with highest new cases and new deaths in 2021/11/09
select location, max(new_cases) as highestcases, max(new_deaths) as highestdeaths
from dbo.['owid-covid-data$']
	where continent is not null
	group by location
	order by 2 desc

-- Present global condition: new cases and new deaths
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths
from dbo.['owid-covid-data$']
	where location = 'World'

-- Country wise confirmed cases of covid 19, 2021/11/09
select location, max(total_cases) as confirmed_cases, 
				max(cast(total_deaths as int)) as deaths		
from dbo.['owid-covid-data$']
	where continent is not null
	group by location
	order by 1

-- Top 5 countries with highest infection rate compared to Population
select top 5 location,population, 
				max(total_cases) as total_cases_count,
				max(total_cases/population)*100 as infection_rate
from dbo.['owid-covid-data$']
	where continent is not null
	group by location, population
	order by infection_rate desc

-- Total cases and deaths of the continents 
select continent, 
	max(total_cases) as totalcases, 
	max(cast(total_deaths as int)) as totaldeaths
from dbo.['owid-covid-data$']
	where continent is not null
	group by continent
	order by 2

--  countries with  full vaccination rate compared to population
select location ,
		population
		people_fully_vaccinated ,
		max(cast(people_fully_vaccinated as int)/population)*100 as full_vaccination_rate
from dbo.['owid-covid-data$']
where continent is not null
group by location, population
order by 1 

-- COVID-19 globe spread 
select		date
			,new_cases
			,new_deaths
from dbo.['owid-covid-data$']
	where location = 'World'
	order by date

------------------------------------- Create VIEWS for later visualizations -------------------------------
-- Top 5 highest infection rate 
create view top5highestinfectionrate as
select top 5 location,population, 
				max(total_cases) as total_cases_count,
				max(total_cases/population)*100 as infection_rate
from dbo.['owid-covid-data$']
	where continent is not null
	group by location, population
	order by infection_rate desc

-- Globe spread 
create view globespread as 
select		date
			,new_cases
			,new_deaths
from dbo.['owid-covid-data$']
	where location = 'World'
	--order by date

-- full vaccination rate
create view fullvaccinationrate as 
select location ,
		population
		people_fully_vaccinated ,
		max(cast(people_fully_vaccinated as int)/population)*100 as full_vaccination_rate
from dbo.['owid-covid-data$']
	where continent is not null
	group by location, population
--order by 1 