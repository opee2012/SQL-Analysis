
SELECT countries.name, COUNT(ip4.country) 
FROM countries 
LEFT JOIN ip4 
ON countries.id = ip4.country 
GROUP BY countries.name 
ORDER BY COUNT(ip4.country) DESC 
LIMIT 10;

SELECT cityByCountry.name, COUNT(ip4.city)
FROM cityByCountry
LEFT JOIN countries
ON cityByCountry.country = countries.id
LEFT JOIN ip4
ON cityByCountry.city = ip4.city
WHERE cityByCountry.country = 226
GROUP BY cityByCountry.name
ORDER BY COUNT(ip4.city) DESC
LIMIT 10;


SELECT cityByCountry.name, COUNT(ip4.city)
FROM cityByCountry
LEFT JOIN countries
ON cityByCountry.country = countries.id
LEFT JOIN ip4
ON cityByCountry.city = ip4.city
WHERE cityByCountry.country = 226
GROUP BY cityByCountry.name
HAVING COUNT(ip4.city) BETWEEN 4000 AND 5000
ORDER BY COUNT(ip4.city)
LIMIT 10;

SELECT state_city_count.state, AVG(numIP)
FROM (SELECT cityByCountry.state, COUNT(ip4.ip) AS numIP
    FROM cityByCountry
    LEFT JOIN ip4 ON cityByCountry.city = ip4.city
    JOIN countries ON cityByCountry.country = countries.id
    AND countries.name = 'UNITED STATES'
    AND cityByCountry.state <> ''
    GROUP BY cityByCountry.state, cityByCountry.name
    ORDER BY cityByCountry.state) as state_city_count
GROUP BY state
ORDER BY state;




SELECT state, avgNumIP
FROM (SELECT state_city_count.state, AVG(numIP) as avgNumIP
    FROM (SELECT cityByCountry.state, COUNT(ip4.ip) AS numIP
        FROM cityByCountry
        LEFT JOIN ip4 ON cityByCountry.city = ip4.city
        JOIN countries ON cityByCountry.country = countries.id
        AND countries.name = 'UNITED STATES'
        AND cityByCountry.state <> ''
        GROUP BY cityByCountry.state, cityByCountry.name
        ORDER BY cityByCountry.state) as state_city_count
    GROUP BY state
    ORDER BY state) as State_Avg
WHERE (SELECT AVG(avgNumIP) FROM (SELECT AVG(numIP) as avgNumIP
    FROM (SELECT cityByCountry.state, COUNT(ip4.ip) AS numIP
        FROM cityByCountry
        LEFT JOIN ip4 ON cityByCountry.city = ip4.city
        JOIN countries ON cityByCountry.country = countries.id
        AND countries.name = 'UNITED STATES'
        AND cityByCountry.state <> ''
        GROUP BY cityByCountry.state, cityByCountry.name
        ORDER BY cityByCountry.state) as state_city_count
    GROUP BY state
    ORDER BY state) as State_Avg) < State_Avg.avgNumIP;
