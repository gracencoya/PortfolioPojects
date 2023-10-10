SELECT * FROM CovidDeaths$ 
where continent is not null
ORDER BY 3,4

--SELECT * FROM CovidVaccinations$ ORDER BY 3,4

-- SELECT DATA THAT WILL BE USING


SELECT location, date , total_cases, new_cases, total_deaths, population
FROM CovidDeaths$ ORDER BY  1,2


--Total Cases vs Total Deaths

SELECT location, date , total_cases, new_cases, total_deaths, (total_deaths/total_cases) * 100 As DeathPercentage
FROM CovidDeaths$ Where location like '%South Africa%'
ORDER BY  1,2


-- TOTAL CASE VS POPULATION 


SELECT location, date , total_cases, population,  (total_cases/population) * 100 As PercentagePopulationInfected 
FROM CovidDeaths$
--Where location like '%South Africa%'
ORDER BY  1,2

-- Countries with highest case vs population
SELECT location,  population, max(total_cases) as HighestInfectionCount, Max((total_cases/population)) * 100 As PercentagePopulationInfected 
FROM CovidDeaths$
--Where location like '%South Africa%'
GROUP BY location,population
ORDER BY  PercentagePopulationInfected desc


-- Countries with highest death count per population 
SELECT location, max(cast(total_deaths as int )) as TotalDeathCount FROM CovidDeaths$
--Where location like '%South Africa%'
where continent is  null
GROUP BY location
ORDER BY  TotalDeathCount desc


--Break things down by continent
SELECT continent, max(cast(total_deaths as int )) as TotalDeathCount FROM CovidDeaths$
--Where location like '%South Africa%'
where continent is not null
GROUP BY continent
ORDER BY  TotalDeathCount desc 



--Global Numbers 
SELECT  sum(new_cases) as Total_Cases,sum(cast(new_deaths as int))  as Total_deaths, sum(cast(new_deaths as int)) / Sum(new_cases) 
As DeathPercentage
FROM CovidDeaths$ 
--Where location like '%South Africa%'
where continent is not null
--group by date 
ORDER BY  1,2


-- Total population vs Vaccinations

with PopvsVac (continet , location, date , population,new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent , dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(Convert(int , vac.new_vaccinations)) over (Partition by dea.location 
order by dea.location ,dea.date) as RollingPeopleVaccinated


from CovidDeaths$ dea Join 
 CovidVaccinations$ vac on dea.location = vac.location and dea.date = vac.date
 where dea.continent is not null
-- order by 2,3
 )

 Select * ,( RollingPeopleVaccinated / population)*100  As PercentageVacc
 from PopvsVac


 --Temp Table 
 Drop table if exists #PercentPopulationVaccinated 
 create table #PercentPopulationVaccinated 
 ( 
	contitent nvarchar(255), 
	location nvarchar(255),
	date datetime,
	population numeric,
	new_vaccinations numeric ,
	RollingPeopleVaccinated numeric
	)

 insert into #PercentPopulationVaccinated 
Select dea.continent , dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(Convert(int , vac.new_vaccinations)) over (Partition by dea.location 
order by dea.location ,dea.date) as RollingPeopleVaccinated

from CovidDeaths$ dea Join 
 CovidVaccinations$ vac on dea.location = vac.location and dea.date = vac.date
 --where dea.continent is not null
-- order by 2,3

SElect * ,( RollingPeopleVaccinated / population)*100  As PercentageVacc
 from #PercentPopulationVaccinated 



 --Creating View to store data for later visualizationa 


 Create View PercentPopulationVaccinated as 

Select dea.continent , dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(Convert(int , vac.new_vaccinations)) over (Partition by dea.location 
order by dea.location ,dea.date) as RollingPeopleVaccinated

from CovidDeaths$ dea Join 
 CovidVaccinations$ vac on dea.location = vac.location and dea.date = vac.date
 where dea.continent is not null
--order by 2,3