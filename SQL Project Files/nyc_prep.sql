/* -------------------------------
file: sept 17, 2023 project 1 by Anthony Ayala

desc: Assignment 1 - Single Entity Queries

  -------------------------------- */

/*
Task 1, Create a Project 1 Schema
*/

# create a schema 
DROP SCHEMA IF EXISTS project_1;
CREATE SCHEMA project_1;
# use the schema
USE project_1;

/*
Task 1, Create Employee Table
*/
Drop table if exists employee;
CREATE TABLE employee (
    employee_id INT NOT NULL AUTO_INCREMENT,
    employee_name VARCHAR(64),
    employee_title VARCHAR(64),
    employee_dept VARCHAR(64),
    full_or_part_time CHAR(1),
    salary_or_hourly VARCHAR(10),
    typical_hours DECIMAL(5 , 2 ),
    annual_salary DECIMAL(10 , 2 ),
    hourly_rate DECIMAL(5 , 2 ),
    PRIMARY KEY (employee_id)
);

/*
Task 1, Insert Into Employee
*/
INSERT INTO employee (employee_name, employee_title, employee_dept, full_or_part_time, salary_or_hourly, typical_hours, annual_salary, hourly_rate) VALUES ('Aaron, Jeffery M', 'SERGEANT', 'POLICE', 'F', 'Salary', NULL, 114440.00, NULL);
INSERT INTO employee (employee_name, employee_title, employee_dept, full_or_part_time, salary_or_hourly, typical_hours, annual_salary, hourly_rate) VALUES ('Aaron, Kari', 'POLICE OFFICER (ASSIGNED AS DETECTIVE)', 'POLICE', 'F', 'Salary', NULL, 94122.00, NULL);
INSERT INTO employee (employee_name, employee_title, employee_dept, full_or_part_time, salary_or_hourly, typical_hours, annual_salary, hourly_rate) VALUES ('Aaron, Kimberli R', 'CHIEF CONTRACT EXPEDITER', 'DAIS', 'F', 'Salary', NULL, 118608.00, NULL);
INSERT INTO employee (employee_name, employee_title, employee_dept, full_or_part_time, salary_or_hourly, typical_hours, annual_salary, hourly_rate) VALUES ('Abad Jr, Vicente M, ', 'CIVIL ENGINEER IV', 'WATER MGMNT', 'F', 'Salary', NULL, 117072.00, NULL);
INSERT INTO employee (employee_name, employee_title, employee_dept, full_or_part_time, salary_or_hourly, typical_hours, annual_salary, hourly_rate) VALUES ('Abarca, Emmanuel', 'CONCRETE LABORER', 'TRANSPORTATION', 'F', 'Hourly', 40, NULL, 44.4);
INSERT INTO employee (employee_name, employee_title, employee_dept, full_or_part_time, salary_or_hourly, typical_hours, annual_salary, hourly_rate) VALUES ('Abarca, Frances J', 'POLICE OFFICER', 'POLICE', 'F', 'Salary', NULL, 68616.00, NULL);
INSERT INTO employee (employee_name, employee_title, employee_dept, full_or_part_time, salary_or_hourly, typical_hours, annual_salary, hourly_rate) VALUES ('Abascal, Reece E', 'TRAFFIC CONTROL AIDE-HOURLY', 'OEMC', 'P', 'Hourly', 20, NULL, 19.86);
INSERT INTO employee (employee_name, employee_title, employee_dept, full_or_part_time, salary_or_hourly, typical_hours, annual_salary, hourly_rate) VALUES ('Abbatacola, Robert J', 'ELETRIC MECHANIC', 'AVIATION', 'F', 'Hourly', 40, NULL, 50);

/*
Who is a salaried employee that makes less than 100k?
*/
SELECT 
    *
FROM
    employee
WHERE
    annual_salary < 100000.00;

/*
Of the Hourly Employees, multiply their typical hours by 50 weeks and hourly rate to create a new column ‘estimated_annual_salary’ order employees by this column from the largest to smallest.
*/
Alter Table employee ADD
	estimated_annual_salary DECIMAL (10,2);

UPDATE employee 
SET 
    estimated_annual_salary = 88800.00
WHERE
    employee_id = 5;
	
UPDATE employee 
SET 
    estimated_annual_salary = 19860.00
WHERE
    employee_id = 7;
    
UPDATE employee 
SET 
    estimated_annual_salary = 100000.00
WHERE
    employee_id = 8;

SELECT 
* 
FROM
	employee
ORDER BY 
	estimated_annual_salary DESC;
/* 
Say let's order all the employees based on salary
*/

UPDATE employee 
SET 
    estimated_annual_salary = 114440.00
WHERE
    employee_id = 1;
	
UPDATE employee 
SET 
    estimated_annual_salary = 94122.00
WHERE
    employee_id = 2;
    
UPDATE employee 
SET 
    estimated_annual_salary = 118608.00
WHERE
    employee_id = 3;

UPDATE employee 
SET 
    estimated_annual_salary = 117072.00
WHERE
    employee_id = 4;
    UPDATE employee 
SET 
    estimated_annual_salary = 68616.00
WHERE
    employee_id = 6;

SELECT 
    *
FROM
    employee
ORDER BY estimated_annual_salary DESC;

/*
Using the LIKE operator select anyone with a title that contains "OFF"
*/
SELECT
*
FROM
	employee
WHERE
	employee_title LIKE '%OFF%';
    
/*
Task 2 - Create NYC_APPLICATIONS TABLE
*/
SELECT 
*
FROM
	nyc_applications
LIMIT 10;

DESCRIBE nyc_applications;

/*
Task 2 - Use "Create Table As Select" To Create NYC_Application_Prep
*/

DROP TABLE IF EXISTS nyc_applications_prep;
CREATE TABLE nyc_applications_prep
AS
SELECT
`nyc_applications`.`objectid`,
    `nyc_applications`.`seating_interest_sidewalk`,
    `nyc_applications`.`restaurant_name`,
    `nyc_applications`.`bulding_number`,
    `nyc_applications`.`street`,
    `nyc_applications`.`borough`,
    `nyc_applications`.`zip`,
    `nyc_applications`.`business_address`,
cast( `nyc_applications`.`sidewalk_dimensions_length` as double) as sidewalk_dimensions_length,
cast(`nyc_applications`.`sidewalk_dimensions_width` as double) as sidewalk_dimensions_width,
cast(`nyc_applications`.`sidewalk_dimensions_area` as double) as sidewalk_dimensions_area,
cast(`nyc_applications`.`roadway_dimensions_length` as double) as roadway_dimensions_length,
cast( `nyc_applications`.`roadway_dimensions_width` as double) as roadway_dimensions_width,
cast( `nyc_applications`.`roadway_dimensions_area` as double) as roadway_dimensions_area,
  `nyc_applications`.`qualify_alcohol`,
  STR_TO_DATE(substr(time_of_submission,1,10), '%Y-%m-%d') as date_of_submission
from nyc_applications;

select * from nyc_applications_prep;

describe nyc_applications_prep;

/*
Result 0 - Top 5 Restaurants with the largest roadway seating areas that also serve alcohol
*/
DROP table if exists RES00;
create table RES00
SELECT
	restaurant_name,
    business_address,
    borough,
    roadway_dimensions_area
FROM
	nyc_applications_prep
WHERE seating_interest_sidewalk = 'roadway' and
	  qualify_alcohol = 'yes'
ORDER BY roadway_dimensions_area DESC
limit 5;

SELECT 
*
FROM
	RES00;
/*
Result 1 - Top 5 Sidewalk Seating Restaurants (by area) in Manhattan
*/
DROP table if exists RES01;
CREATE TABLE RES01 SELECT restaurant_name,
    business_address,
    borough,
    sidewalk_dimensions_area,
    qualify_alcohol FROM
    nyc_applications_prep
WHERE
    borough = 'Manhattan'
ORDER BY sidewalk_dimensions_area DESC
LIMIT 10;

SELECT 
    *
FROM
    RES01;

/*
Result 2 - Top 10 Brooklyn Restaurants that serve alcohol by sidewalk seating area
*/
DROP table if exists RES02;
create table RES02
SELECT
	restaurant_name,
    business_address,
    borough,
    sidewalk_dimensions_area,
    qualify_alcohol
FROM
	nyc_applications_prep
WHERE 
	borough = 'Brooklyn'
    AND qualify_alcohol = 'yes'
ORDER BY sidewalk_dimensions_area DESC
limit 10;

SELECT 
*
FROM
	RES02;
/*
Result 3 - Top 10 Restaurants by Sidewalk Seating Restaurants that serve alcohol and also contain the word pizza (case-insensitive)
*/
DROP table if exists RES03;
CREATE table RES03
SELECT
	restaurant_name,
    business_address,
    borough,
    sidewalk_dimensions_area,
    qualify_alcohol
FROM
	nyc_applications_prep
WHERE 
	restaurant_name LIKE '%pizza%'
    AND qualify_alcohol = 'yes'
ORDER BY sidewalk_dimensions_area DESC
limit 10;

SELECT 
*
FROM
	RES03;
/*
Result 4 - Bottom 10 Brooklyn Restaurants that serve alcohol order by sidewalk seating area above 0 
*/
DROP table if exists RES04;
CREATE table RES04
SELECT
	restaurant_name,
    business_address,
    borough,
    sidewalk_dimensions_area,
    qualify_alcohol
FROM
	nyc_applications_prep
WHERE 
	sidewalk_dimensions_area > 0
    AND borough = 'Brooklyn'
    AND qualify_alcohol = 'yes'
ORDER BY sidewalk_dimensions_area ASC
limit 10;

SELECT 
*
FROM
	RES04;
/*
Result 5 - Bottom 10 Sidewalk Seating Restaurants (by sidewalk area above 0) in Queens
*/
DROP table if exists RES05;
CREATE table RES05
SELECT
	restaurant_name,
    business_address,
    borough,
    sidewalk_dimensions_area,
    qualify_alcohol
FROM
	nyc_applications_prep
WHERE 
	sidewalk_dimensions_area > 0 AND
    borough = 'Queens'
ORDER BY sidewalk_dimensions_area ASC
limit 10;

SELECT 
*
FROM
	RES05;
/*
Result 6 - Top 10 Restaurants by Sidewalk Seating Restaurants in Manhattan that serve alcohol and also start with the word "Thai" (case-insensitive)
*/
DROP table if exists RES06;
CREATE table RES06
SELECT
	restaurant_name,
    business_address,
    borough,
    sidewalk_dimensions_area,
    qualify_alcohol
FROM
	nyc_applications_prep
WHERE 
	borough = 'Manhattan'
	AND restaurant_name LIKE 'Thai%'
    AND qualify_alcohol = 'yes'
ORDER BY sidewalk_dimensions_area DESC
limit 10;

SELECT 
*
FROM
	RES06;
    
/*
Result 7 - Top 5 Restaurants by Total Outside Area (sidewalk dimensions area + roadway dimensions area = total outside area)
*/
DROP table if exists RES07;
CREATE TABLE RES07 SELECT restaurant_name,
    business_address,
    borough,
    sidewalk_dimensions_area,
    roadway_dimensions_area,
    (sidewalk_dimensions_area + roadway_dimensions_area) AS total_outside_area,
    qualify_alcohol FROM
    nyc_applications_prep
ORDER BY total_outside_area DESC
LIMIT 5;

SELECT 
    *
FROM
    RES07;

/*
Result 8 - Who are the Restaurants in Brooklyn that report “both” in seating interest sidewalk, but either sidewalk seating area or largest roadway seating area is zero 
*/
DROP table if exists RES08;
CREATE TABLE RES08 SELECT restaurant_name,
    business_address,
    borough,
    seating_interest_sidewalk,
    sidewalk_dimensions_area,
    roadway_dimensions_area FROM
    nyc_applications_prep
WHERE
    borough = 'Brooklyn'
        AND seating_interest_sidewalk LIKE 'Both'
        AND sidewalk_dimensions_area = 0
ORDER BY sidewalk_dimensions_area ASC;

SELECT 
    *
FROM
    RES08;

/*
We are breaking up the results in two tables, one for sidewalk seating area = 0 and the other for roadway seating area = 0
*/
DROP table if exists RES08_2;
CREATE TABLE RES08_2 SELECT restaurant_name,
    business_address,
    borough,
    seating_interest_sidewalk,
    sidewalk_dimensions_area,
    roadway_dimensions_area FROM
    nyc_applications_prep
WHERE
    borough = 'Brooklyn'
        AND seating_interest_sidewalk = 'Both'
        AND roadway_dimensions_area = 0
ORDER BY sidewalk_dimensions_area ASC;

SELECT 
    *
FROM
    RES08_2;

/*
Let's perform a full join, use union all
*/ 
drop table if exists RES08_final;
CREATE TABLE RES08_final SELECT * FROM
    RES08 
UNION ALL SELECT 
    *
FROM
    RES08_2;

SELECT
*
FROM
    RES08_final;