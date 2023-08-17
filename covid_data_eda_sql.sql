 
use portfolioproject;
CREATE TABLE `covid_death` (
  `iso_code` varchar(50) ,
  `continent` varchar(45) ,
  `location` varchar(45) ,
  `date` DATE,
  `total_cases` int ,
  `population` int ,
  `new_cases` int ,
  `new_cases_smoothed` int ,
  `total_deaths` int ,
  `new_deaths` int ,
  `new_deaths_smoothed` int ,
  `total_cases_per_million` int,
  `new_cases_per_million` int ,
  `new_cases_smoothed_per_million` int ,
  `total_deaths_per_million` int ,
  `new_deaths_per_million` int ,
  `new_deaths_smoothed_per_million` int ,
  `reproduction_rate` int ,
  `icu_patients` int ,
  `icu_patients_per_million` int ,
  `hosp_patients` int ,
  `hosp_patients_per_million` int ,
  `weekly_icu_admissions` int ,
  `weekly_icu_admissions_per_million` int ,
  `weekly_hosp_admissions` int ,
  `weekly_hosp_admissions_per_million` int,
  `new_tests` int ,
  `total_tests_per_thousand` int ,
  `new_tests_per_thousand` int ,
  `new_tests_smoothed` int ,
  `new_tests_smoothed_per_thousand` int ,
  `positive_rate` int ,
  `tests_per_case` int ,
  `tests_units` int ,
  `total_vaccinations` int ,
  `people_vaccinated` int ,
  `people_fully_vaccinated` int ,
  `new_vaccinations_smoothed` int ,
  `total_vaccinations_per_hundred` int ,
  `people_vaccinated_per_hundred` int ,
  `people_fully_vaccinated_per_hundred` int ,
  `new_vaccinations_smoothed_per_million` int ,
  `stringency_index` int ,
  `population_density` int ,
  `median_age` int ,
  `aged_65_older` int ,
  `aged_70_older` int ,
  `gdp_per_capita` int ,
  `extreme_poverty` int, 
  `cardiovasc_death_rate` int ,
  `diabetes_prevalence` int ,
  `female_smokers` int ,
  `male_smokers` int ,
  `handwashing_facilities` int ,
  `hospital_beds_per_thousand` int ,
  `life_expectancy` int ,
  `human_development_index` int 
) 

/*
covid_vaccinationselect * 
from covid_vaccination

LOAD DATA INFILE 'CovidVaccinations.csv'  INTO TABLE covid_vaccination
FIELDS TERMINATED BY ','
IGNORE 1 LINES;
*/

-- Here i Start the project on covid19 Data
select *
from portfolioproject.covid_death
where continent is not null
order by 3,4
/*
select *
from portfolioproject.covid_vaccination
order by 3,4
*/

-- Lets select the data i'm to be using
select location,date,total_cases,new_cases,total_deaths,population
from portfolioproject.covid_death
where continent is not null
order by 1,2

-- looking at total_cases vs total deaths

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as deathpercent
from portfolioproject.covid_death
where continent is not null
order by 1,2

-- looking at total_cases vs total deaths in pakistan

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as deathpercent
from portfolioproject.covid_death
where location like '%Pakistan%' and continent is not null

order by 1,2

-- Now i am looking at the total casses vs population

select location,date,total_cases, population,(total_cases/population)*100 as casesperpopu
from portfolioproject.covid_death
where location like '%Pakistan%'
order by 1,2

-- in pakistan case per population is much lower 

-- check in USA  
select location,date,total_cases, population,(total_cases/population)*100 as casesperpopu
from portfolioproject.covid_death
where location like '%states%'
order by 1,2
-- while in usa the ratio of covid at peak 9% as per population



-- CHeck for the China

select location,date,total_cases, population,(total_cases/population)*100 as casesperpopu
from portfolioproject.covid_death
where location like '%china%'
order by 1,2

-- so where the disease start the covid case per population is too low as compare to other countries


-- while in usa the ratio of covid at peak 9% as per population

-- looking at countries with highest infection rate compared to population

select location, population,MAX(total_cases) as highinfectionrate,MAX((total_cases/population))*100 as infectedperpopulation
from portfolioproject.covid_death
-- where location like '%Pakistan%'
where continent is not null
group by location,population
order by infectedperpopulation desc

-- Let's Break The Things Down by continent

select continent,MAX(total_deaths ) as TotalDeathCount 
from portfolioproject.covid_death

where continent is null
group by continent
order by TotalDeathCount  desc
-- SHOW COLUMNS FROM covid_death;


-- showing the countries with hisghest death count per population

select location,MAX(total_deaths) as TotalDeathCount 
from portfolioproject.covid_death
-- where location like '%Pakistan%'
where continent is not null
group by location
order by TotalDeathCount  desc

-- Breaking Global number

select date , sum(new_cases)
from portfolioproject.covid_death
where continent is not null
group by date
order by 1,2


-- another with new_deaths

select date , sum(new_cases),sum(new_deaths),sum(new_deaths)/sum(new_cases)*100 as deathrateperday
from portfolioproject.covid_death
where continent is not null
group by date
order by 1,2 

select  sum(new_cases) as total_cases,sum(new_deaths) as total_death,sum(new_deaths)/sum(new_cases)*100 as deathrateperday
from portfolioproject.covid_death
where continent is not null
-- group by date
order by 1,2 


-- now move to the other table of covid
select * 
from portfolioproject.covid_vaccination

-- Let's join the both table 
select *
from portfolioproject.covid_death dea
join portfolioproject.covid_vaccination vac
on dea.location = vac.location
and dea.date = vac.date

-- looking at the total population vs vaccination

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from portfolioproject.covid_death dea
join portfolioproject.covid_vaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location)
from portfolioproject.covid_death dea
join portfolioproject.covid_vaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3



select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/population)*100
from portfolioproject.covid_death dea
join portfolioproject.covid_vaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


--  use cte

with PopvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as 
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from portfolioproject.covid_death dea
join portfolioproject.covid_vaccination vac
on dea.location = vac.location
and dea.date = vac.date
-- where dea.continent is not null
-- order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac

-- Temp table 

Drop table if exists PercentPopulationVaccinated
create table PercentPopulationVaccinated
(
continent varchar(50),
location varchar(50),
Date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/population)*100
from portfolioproject.covid_death dea
join portfolioproject.covid_vaccination vac
on dea.location = vac.location
and dea.date = vac.date
-- where dea.continent is not null
-- order by 2,3
select *, (RollingPeopleVaccinated/population)*100
from PercentPopulationVaccinated

-- creating a view to store data for later visulization

create view PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/population)*100
from portfolioproject.covid_death dea
join portfolioproject.covid_vaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
-- order by 2,3






