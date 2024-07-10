# Assignment_5 Queries

use assignment_5;

-- 1. Is credit score predictive of fraud or not?
    
# Let's do the average
SELECT 
    AVG(credit_score) AS avg_credit_score, prediction
FROM
    customer_prep
GROUP BY prediction;

-- 2. Top five predictors and their relationship with fraud
Select 
	balance_inqury_count,
    balance_current_amt,
    customer_tenure,
    email_age,
    credit_score,
    EVENT_LABEL,
    prediction
FROM
	assignment_5.customer_prep;
    
-- Question 3: Score Distribution
SELECT 
    countryName, prediction
FROM
    assignment_5.customer_prep;
    
-- Question 4: At a predicted probability of fraud of 0.5 and above,
-- what is the accuracy, precision and recall?

SELECT 
    event_label, prediction
FROM
    assignment_5.customer_prep
WHERE
    probability_fraud >= 0.5;
    
-- Question 5: Accuracy of the model better than default accuracy?
SELECT 
    event_label, prediction
FROM
    assignment_5.customer_prep;