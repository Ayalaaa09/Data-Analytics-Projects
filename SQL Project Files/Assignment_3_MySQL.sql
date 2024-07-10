/*
Assignment 3 - SQL Excel Integration
We will set up the connectivity between MySQL databases and Excel and we will do this with the help of ODBC Connectivity
The data we are working with is sampled from a major financial institution wheir their data science teams are tasked with 
developing and comparing several machine learning models to predict "loan status". 
Specifically which loans are like to default.
*/

-- Use assignment_3 schema
use assignment_3;

-- Preview the data to make sure everything is working and how many records and fields we will be working with

# How many records?
SELECT 
    COUNT(*)
FROM
    loan; -- 16,283 records for loan table
    
SELECT 
    COUNT(*)
FROM
    test_data; -- 50 records for test_data table

# Describe the loan table    
Describe loan;


# RESULT 0 - TOP 5 PURPOSES OF VERIFIED LOAN
SELECT 
    purpose, COUNT(ID)
FROM
    assignment_3.loan
WHERE
    verification_status = 'verified'
GROUP BY purpose
ORDER BY COUNT(id) DESC
LIMIT 5;


# RESULT 1 - TOP 5 DEFAULT RATES BY PURPOSE
SELECT 
    purpose, (SUM(bad_loan) / COUNT(bad_loan)) AS default_rate
FROM
    assignment_3.loan
WHERE
    verification_status = 'verified'
GROUP BY purpose
ORDER BY default_rate DESC
LIMIT 5;              -- Numbers are slightly higher

# RESULT 2 - TOP DEFAULT RATES BY STATE

SELECT 
    addr_state,
    (SUM(bad_loan) / COUNT(bad_loan)) AS default_rate
FROM
    assignment_3.loan
WHERE
    verification_status = 'verified'
GROUP BY addr_state
HAVING count(addr_state) > 1000
ORDER BY default_rate DESC
LIMIT 5;

# RESULT 3 - AVERAGE INCOME AND LOAN AMOUNT BY PURPOSE

SELECT 
    purpose,
    AVG(annual_inc) AS avg_income,
    AVG(loan_amnt) AS avg_loan_amnt,
    (SUM(bad_loan) / COUNT(bad_loan)) AS default_rate
FROM
    assignment_3.loan
WHERE
	verification_status = 'verified'
GROUP BY purpose
ORDER BY avg_loan_amnt DESC
LIMIT 5;


# RESULT 4 - CONFUSION MATRIX
select 
sum(case when t.bad_loan = 0 and t.pred = 0 then 1 else 0 end) as 'true_negative',
sum(case when t.bad_loan = 1 and t.pred = 0 then 1 else 0 end) as 'false_negative',
sum(case when t.bad_loan = 0 and t.pred = 1 then 1 else 0 end) as 'false_positive',
sum(case when t.bad_loan = 1 and t.pred = 1 then 1 else 0 end) as 'true_positive'
from assignment_3.test_data t;

select 
	sum(case when t.bad_loan = 0 then 1 else 0 end) as true_zero,
    sum(case when t.bad_loan = 1 then 1 else 0 end) as true_one,
    sum(case when t.pred = 0 then 1 else 0 end) as predicted_zero,
    sum(case when t.pred = 1 then 1 else 0 end) as predicted_one
    from assignment_3.test_data t;

# You can just select the data
SELECT 
    *
FROM
    assignment_3.test_data;


# Set up the table
drop table if exists pivot_table;
create table pivot_table (
	true_zero INT NOT NUll,
    true_one INT NOT NULL,
    predicted_zero INT NOT NULL,
    predicted_one INT NOT NULL
    )
;

Insert into pivot_table (true_zero, true_one, predicted_zero, predicted_one)
SELECT 
sum(case when l.bad_loan = 0 and t.bad_loan = 0 then 1 else 0 end) as 'true negative',
sum(case when l.bad_loan = 1 and t.bad_loan = 0 then 1 else 0 end) as 'false negative',
sum(case when l.bad_loan = 0 and t.bad_loan = 1 then 1 else 0 end) as 'false positive',
sum(case when l.bad_loan = 1 and t.bad_loan = 1 then 1 else 0 end) as 'true positive'
from loan l
Inner JOIN test_data t ON l.id = t.id;

select * from pivot_table;

# Extract the results
select 
sum(case when l.bad_loan = 0 then 1 else 0 end) as 'true negative',
sum(case when l.bad_loan = 1 then 1 else 0 end) as 'true',
sum(case when t.bad_loan = 0 then 1 else 0 end) as 'predicted_zero',
sum(case when t.bad_loan = 1 then 1 else 0 end) as 'predicted_one'
from loan l 
INNER JOIN test_data t on l.id = t.id;


# RESULT 5 - 

SELECT 
    l.purpose,
    l.delinq_2yrs,
    l.int_rate,
    SUM(l.bad_loan) as total_bad_loan,
    t.total_loans,
    (SUM(l.bad_loan) / t.total_loans) AS pct_of_bad_loans
FROM
    assignment_3.loan l
        CROSS JOIN
    (SELECT 
        COUNT(1) AS total_loans
    FROM
        assignment_3.test_data) t
GROUP BY l.purpose , l.delinq_2yrs , l.int_rate, t.total_loans
ORDER BY pct_of_bad_loans DESC
LIMIT 5;

SELECT
    l.purpose,
    l.delinq_2yrs,
    l.int_rate,
    SUM(l.bad_loan) as total_bad_loan,
    t.total_loans,
    (SUM(l.bad_loan) / t.total_loans) as pct_of_bad_loans
FROM assignment_3.loan l
CROSS JOIN (SELECT COUNT(id) as total_loans FROM assignment_3.test_data) t
GROUP BY l.purpose, l.delinq_2yrs, l.int_rate, t.total_loans
ORDER BY pct_of_bad_loans DESC
LIMIT 5;

# Let's do analysis on average duration by state (maybe look at loan amount and interest rate)
SELECT
    l.purpose,
    l.loan_amnt,
    l.int_rate,
    count(l.addr_state) as total_addr_state,
    t.all_states,
    (Count(l.addr_state) / t.all_states) as pct_of_states
FROM assignment_3.loan l
CROSS JOIN (SELECT COUNT(id) as all_states FROM assignment_3.test_data) t
GROUP BY l.purpose, l.loan_amnt, l.int_rate, t.all_states
ORDER BY pct_of_states DESC
LIMIT 5;

# You're doing cross joins wrong
select
l.purpose, l.addr_state, avg(l.loan_amnt) as avg_loan_amnt, l.int_rate, l.term_length
from assignment_3.loan l
group by l.purpose, l.addr_state, l.int_rate, l.term_length
order by avg_loan_amnt desc
limit 10;

# What are the top 10 states with the term_length and interest rates greater than the average (looking at verified loans only)
SELECT 
    l.addr_state,
    l.int_rate,
    l.term_length,
    COUNT(l.id) AS total_loans
FROM
    assignment_3.loan l
WHERE
    l.verification_status = 'verified' AND
    l.int_rate > 14 AND
    l.term_length > 43
GROUP BY l.addr_state , l.int_rate , l.term_length
ORDER BY total_loans DESC
LIMIT 10;

# Average Interest Rate and Average Term Length

SELECT 
    AVG(l.int_rate) AS avg_int_rate,
    AVG(l.term_length) AS avg_term_length
FROM
    assignment_3.loan l
WHERE
    l.verification_status = 'verified';
    
    
# Final code
SELECT 
    l.addr_state,
    l.purpose,
    l.int_rate,
    l.term_length,
    COUNT(l.id) AS total_loans
FROM
    assignment_3.loan l
WHERE
	l.int_rate > (SELECT 
	AVG(l.int_rate) AS avg_int_rate
	FROM assignment_3.loan l)
AND 
	l.term_length > ( SELECT
	AVG(l.term_length) as avg_term_length
	FROM assignment_3.loan l)
AND
	verification_status = 'verified'
GROUP BY l.addr_state , l.purpose, l.int_rate , l.term_length
ORDER BY total_loans DESC
LIMIT 10;