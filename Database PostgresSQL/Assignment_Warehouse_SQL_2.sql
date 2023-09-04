SELECT *FROM air_pollution;
SELECT *FROM co2_emission;
SELECT *FROM country;
SELECT *FROM energy_use_per_capita;
SELECT *FROM share_of_population_with_access_to_electricity;
SELECT *FROM world_risk_index;

--Roll up--
Select case when country_name is null
			then 'Total' else country_name end,
		total_lack_of_adaptive_capacities
		from(select country_name, sum(lack_of_adaptive_capacities) as total_lack_of_adaptive_capacities
		from world_risk_index
		group by rollup (country_name)
		order by country_name
		) as x;
		
--Slicing--
SELECT country.country_name, ROUND(avg(air_pollution.nitrogen_oxide),4) as average_nitrogen_oxide
FROM country
INNER JOIN air_pollution ON country.country_name = air_pollution.country_name
where country.region like 'Asia'
group by country.country_name
order by average_nitrogen_oxide desc;
	 
--Dicing--
SELECT country_name, average_energy_use, average_percent_of_population
FROM (
SELECT country.country_name,
ROUND(avg(energy_use_per_capita.energy_consumption_per_capita),4)
as average_energy_use, 
ROUND(avg(share_of_population_with_access_to_electricity.access_to_electricity_percent_of_population),4)
as average_percent_of_population
FROM country
INNER JOIN energy_use_per_capita ON country.country_name = energy_use_per_capita.country_name
INNER JOIN share_of_population_with_access_to_electricity
ON country.country_name = share_of_population_with_access_to_electricity.country_name
where country.region LIKE 'Africa'
group by (country.region, country.country_name)
) subquery
where average_percent_of_population <= 50
order by country_name;

	 
--2D--	 
SELECT country.region, country.country_name, SUM(co2_emission.annual_co2_emissions) AS annual_co2_emissions
FROM country
INNER JOIN co2_emission ON country.country_name = co2_emission.country_name
GROUP BY (country.region, country.country_name)
ORDER BY country.region, country.country_name;
	 

