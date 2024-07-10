/*
Assignment 2 - Revisit Aggregration
By Anthony Ayala
Date: October 8, 2023
*/

-- Preparation Steps include the following Creating a Schema and Loading the Table 

drop schema if exists assignment_2;
create schema assignment_2;
use assignment_2;

-- Check the number of records to see if we loaded the data properly

select count(*) from assignment_2.flights; -- we have 23,449 records

-- Describe the table and check the fileds and their respective data types

select * from assignment_2.flights limit 5;

-- Result 0 Flights by Airline

SELECT 
    airline, COUNT(*) AS flight_count
FROM
    flights
GROUP BY airline
ORDER BY flight_count DESC;

/* 
Result 1 - WHAT ARE THE WORST AIRLINES BY AVERAGE ARR_DELAY (ARRIVAL DELAY)
Count the flights and average the arrival delay (using the column arr_delay:
the difference in minutes between scheduled andd actual arrival time. Early arrivals show negative numbers)
by airline, who is the worst?
*/

SELECT 
    airline,
    COUNT(*) AS flight_count,
    AVG(arr_delay) AS avg_arr_delay
FROM
    flights
GROUP BY airline
ORDER BY avg_arr_delay DESC;  

/*
Result 2 - DID THEY GET BETTER BETWEEN JANUARY AND MAY?
Average arrival delay and flight count by airline and month, use date_format function the %M format and
fl_date to create a month variable
*/

SELECT 
    DATE_FORMAT(fl_date, '%M') AS month_name,
    airline,
    COUNT(*) AS flight_count,
    AVG(arr_delay) AS avg_arr_delay
FROM
    flights
GROUP BY month_name , airline
ORDER BY avg_arr_delay DESC; 

/*
Result 3: CAN YOU CREATE A JANUARY AND MAY COLUMN?
Using similar logic to above, create a three variables january_mean_delay, may_mean_arr_delay, january_vs_may_change by airline
(where januart_vs_may_change = may_mean_arr_delay - january_mean_arr_delay)
*/

SELECT 
    airline,
    AVG(CASE WHEN DATE_FORMAT(fl_date, '%M') = 'january' THEN arr_delay ELSE 0 END) AS january_mean_arr_delay,
    AVG(CASE WHEN DATE_FORMAT(fl_date, '%M') = 'may' THEN arr_delay ELSE 0 END) AS may_mean_arr_delay,
    AVG(CASE WHEN DATE_FORMAT(fl_date, '%M') = 'may' THEN arr_delay ELSE 0 END) - AVG(CASE WHEN DATE_FORMAT(fl_date, '%M') = 'january' THEN arr_delay ELSE 0 END) AS january_vs_may_change
FROM
    flights
GROUP BY airline
ORDER BY january_vs_may_change;

/* 
Result 4: WHAT IS THE WORST DAY OF WEEK TO TRAVEL BASED ON AVERAGE DEP_DELAY
Summarize to get the average departure delay (dep_delay), average arrival delay and flight count by day of week
*/

SELECT 
    DATE_FORMAT(fl_date, '%W') AS day_of_week,
    AVG(dep_delay) AS avg_dep_delay,
    AVG(arr_delay) AS avg_arr_delay,
    COUNT(*) AS flight_count
FROM
    flights
GROUP BY day_of_week
ORDER BY avg_dep_delay DESC;

/* 
Result 5: IS IT BETTER TO FLY ON WEEKEND OR WEEK DAY?
Similar to result 4, create a "week day indicator" and compare the average departure delay vs arrival delay. 
Note with date_format with '%w Sunday is 0 and Saturday is 6'
*/

SELECT 
    CASE
        WHEN
            DATE_FORMAT(fl_date, '%w') = 0
                OR DATE_FORMAT(fl_date, '%w') = 6
        THEN
            'Weekend'
        ELSE 'Weekday'
    END AS week_day_indicator,
    AVG(dep_delay) AS avg_dep_delay,
    AVG(arr_delay) AS avg_arr_delay,
    COUNT(*) AS flight_count
FROM
    flights
GROUP BY week_day_indicator;

/*
Result 6: WHAT'S THE AVERAGE MIN, MAX DISTANCE FLFOWN BY AIRLINE
Using airline and distance to calculate the average, min, max distance flown by airline. Return 4 columns which are airline, mean_distance, max_distance, min_distance
Sort the result by mean_distance in ascending order
*/

SELECT 
    airline,
    AVG(distance) AS mean_distance,
    MIN(distance) AS min_distance,
    MAX(distance) AS max_distance
FROM
    flights
GROUP BY airline
ORDER BY mean_distance;

/*
Result 7: WHAT'S THE AVERAGE, MIN, MAX, AIR_TIME BY AIRLINE?
Using airline and air_time calculate the average, min, max by airline. Return 4 columns which are airline,
mean_time, max_time, min_time. Sort the result by mean_time in ascending order.
*/

SELECT 
    airline,
    AVG(air_time) AS mean_air_time,
    MIN(air_time) AS min_air_time,
    MAX(air_time) AS max_air_time
FROM
    flights
GROUP BY airline
ORDER BY mean_air_time; 

/*
Result 8: HOW MANY FLIGHTS ORIGINATE FROM FLORIDA AND WHAT'S THE AVERAGE DEPARTURE DELAY BY AIRLINE?
On your way back from Florida, what's the average departure delay? Using airline and origin_state_nm
to calculate the average departure by airline. Return 4 columns which are airline, origin_state_nm
(which should be florida), flight_count, avg_dep_delay. Sort the results by avg_dep_delay in ascending order
*/

SELECT 
    airline,
    origin_state_nm,
    COUNT(*) AS flight_count,
    AVG(dep_delay) AS avg_dep_delay
FROM
    flights
WHERE
    origin_state_nm = 'Florida'
GROUP BY airline , origin_state_nm
ORDER BY avg_dep_delay;

/* 
Result 9: TOP 5 LONGEST FLIGHTS BY MAX FLIGHT TIME
Return 4 columns: origin_city_name, dest_city_name, max_airtime, max_airtime_hrs (i.e. 
divide mean_airtime by 60 to get an approximate hour)
Sort the result by avg_dep_delay in ascending order
*/

SELECT 
    origin_city_name,
    dest_city_name,
    count(*) as flight_count,
    (MAX(air_time) / 60) AS max_air_time_hrs
FROM
    flights
GROUP BY origin_city_name , dest_city_name
ORDER BY max_air_time_hrs DESC
LIMIT 5;

/*
Result 10: TOP 5 WORST ORIGIN TO DESTINATION
Return 5 columns: origin_city_name, dest_city_name, mean_air_time, mean_air_time_hrs (i.e. divide mean max_air_time
by 60 to get an approximate hour), flight counts. Having the average arrival delay > 15 minutes and more than 10 flights, 
order by mean_air_time descending and get the top 5 using limit
*/

SELECT 
    origin_city_name,
    dest_city_name,
    AVG(air_time) AS mean_air_time,
    (AVG(air_time) / 60) AS mean_air_time_hrs,
    COUNT(*) AS flight_counts
FROM
    flights
GROUP BY origin_city_name , dest_city_name
HAVING AVG(arr_delay) > 15 AND flight_counts > 10
ORDER BY mean_air_time DESC
LIMIT 5;

/*
Result 11: BEST FLIGHTS FOR EARLY ARRIVALS
Return 5 columns: origin_city_name, dest_city_name, mean_arr_delay, flight_counts. Having average
arrival delay is <= 10 minutes (i.e. early arrivals) and having more than 20 flights. Order by the mean_arr_delay 
ascending and get the top 5 using limit
*/

SELECT 
    origin_city_name,
    dest_city_name,
    AVG(arr_delay) AS mean_arr_delay,
    COUNT(*) AS flight_counts
FROM
    flights
GROUP BY origin_city_name , dest_city_name
HAVING mean_arr_delay <= 10
    AND flight_counts > 20
ORDER BY mean_arr_delay
LIMIT 5;

/*
Result 12: WHAT FLIGHTS ARE LIKELY TO GET A WEATHER DELAY
Return the same columns as result 11, but select flights which weather delay > 0,
avg_arr_delay > 15 minutes, and flight counts > 2
*/

SELECT 
    origin_city_name,
    dest_city_name,
    AVG(arr_delay) AS mean_arr_delay,
    COUNT(*) AS flight_counts
FROM
    flights
WHERE
    weather_delay > 0
GROUP BY origin_city_name , dest_city_name
HAVING mean_arr_delay > 15
    AND flight_counts > 2;

/* 
Result 13: WHAT ARE THE TOP 10 QUICKEST AIRLINES BY AVG_AIR_TIME_HRS WITH AT LEAST 2 DELAYS (ARRIVAL AND DEPARTURE DELAYS)
At least an AGGREGATE Function, one WHERE clause, one HAVING clause
*/
SELECT 
    airline,
    AVG(air_time) / 60 AS avg_air_time_hrs,
    AVG(distance) AS avg_distance,
    COUNT(*) AS flight_count
FROM
    flights
WHERE
    arr_delay > 0 
		AND dep_delay > 0
        OR carrier_delay > 0
        OR weather_delay > 0
        OR nas_delay > 0
        OR security_delay > 0
        OR late_aircraft_delay > 0
GROUP BY airline
HAVING flight_count > 1
ORDER BY avg_air_time_hrs
LIMIT 10;

/*
Result 14: WHICH AIRLINES HAVE THE MOST FLIGHTS IN JANUARY VS MAY?
Include at least one CASE WHEN
*/

SELECT 
    SUM(CASE
        WHEN DATE_FORMAT(fl_date, '%M') = 'january' THEN 1
        ELSE 0
    END) AS january,
    SUM(CASE
        WHEN DATE_FORMAT(fl_date, '%M') = 'may' THEN 1
        ELSE 0
    END) AS may,
    airline,
    COUNT(*) AS flight_count
FROM
    flights
GROUP BY airline
ORDER BY january desc, may desc 
LIMIT 10;

/*
Result 15: WHAT'S THE PERCENTAGE OF AIRTIME BY DESTINATION CITY NAME
Perform a cross join
*/

/*
Table One:
Select dest_city_name, sum(air_time) as total_city_airtime
From flights
group by airline;

Table Two:
select sum(air_time) as total_airtime
from flights;
*/
SELECT 
    Z.dest_city_name,
    SUM(Z.air_time) AS total_city_airtime,
    T.total_airtime,
    SUM(Z.air_time) / T.total_airtime AS pct_total
FROM
    flights Z
        CROSS JOIN
    (SELECT 
        SUM(air_time) AS total_airtime
    FROM
        flights) T
GROUP BY dest_city_name , T.total_airtime
ORDER BY pct_total DESC
LIMIT 10;
