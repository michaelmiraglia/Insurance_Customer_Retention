PRAGMA foreign_keys = ON;

-- ALLOW FOR RESET SO SCRIPT CAN BE RERAN FROM THE TOP

DROP TABLE IF EXISTS beneficiaries;
DROP TABLE IF EXISTS incident_reports;
DROP TABLE IF EXISTS claims;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS personal_liability_coverage;
DROP TABLE IF EXISTS underwriting;
DROP TABLE IF EXISTS policies;
DROP TABLE IF EXISTS properties;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS agents;

-- NEXT, CREATE THE TABLES!

CREATE TABLE agents (
agent_id INTEGER PRIMARY KEY,
first_name TEXT NOT NULL,
last_name TEXT NOT NULL,
email TEXT NOT NULL UNIQUE,
phone TEXT,
office_state TEXT NOT NULL CHECK (length(office_state) = 2)
);

CREATE TABLE customers (
customer_id INTEGER PRIMARY KEY,
first_name TEXT NOT NULL,
last_name TEXT NOT NULL,
date_of_birth TEXT NOT NULL,
email TEXT NOT NULL UNIQUE,
phone TEXT NOT NULL UNIQUE,
street_address TEXT,
city TEXT,
state TEXT CHECK (state IS NULL OR length(state) = 2),
zip_code TEXT,
created_date TEXT NOT NULL
);

CREATE TABLE properties (
property_id INTEGER PRIMARY KEY,
street_address TEXT NOT NULL,
city TEXT NOT NULL,
state TEXT NOT NULL CHECK (length(state) = 2),
zip_code TEXT NOT NULL,
property_type TEXT NOT NULL
CHECK (property_type IN ('Single Family','Condo','Townhome','Multi-Family')),
year_built INTEGER NOT NULL CHECK (year_built BETWEEN 1900 AND 2030),
square_footage INTEGER NOT NULL CHECK (square_footage > 0),
property_value REAL NOT NULL CHECK (property_value > 0)
);

CREATE TABLE policies (
policy_id INTEGER PRIMARY KEY,
policy_number TEXT NOT NULL UNIQUE,
customer_id INTEGER NOT NULL,
agent_id INTEGER NOT NULL,
property_id INTEGER NOT NULL UNIQUE,
start_date TEXT NOT NULL,
end_date TEXT NOT NULL,
policy_status TEXT NOT NULL CHECK (policy_status IN ('Active','Inactive')),
coverage_amount REAL NOT NULL CHECK (coverage_amount > 0),
premium_amount REAL NOT NULL CHECK (premium_amount > 0),
FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
FOREIGN KEY (agent_id) REFERENCES agents(agent_id),
FOREIGN KEY (property_id) REFERENCES properties(property_id),
CHECK (end_date > start_date)
);

CREATE TABLE underwriting (
underwriting_id INTEGER PRIMARY KEY,
policy_id INTEGER NOT NULL UNIQUE,
risk_assessment_score INTEGER NOT NULL CHECK (risk_assessment_score BETWEEN 0 AND 100),
approval_date TEXT NOT NULL,
underwriting_status TEXT NOT NULL
CHECK (underwriting_status IN ('Approved','Conditional','Review')),
FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);

CREATE TABLE personal_liability_coverage (
coverage_id INTEGER PRIMARY KEY,
policy_id INTEGER NOT NULL UNIQUE,
coverage_type TEXT NOT NULL
CHECK (coverage_type IN ('General Liability','Umbrella','Home Liability')),
coverage_limit REAL NOT NULL CHECK (coverage_limit > 0),
deductible REAL NOT NULL CHECK (deductible >= 0),
FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);

CREATE TABLE payments (
payment_id INTEGER PRIMARY KEY,
policy_id INTEGER NOT NULL,
payment_date TEXT NOT NULL,
amount REAL NOT NULL CHECK (amount > 0),
payment_method TEXT NOT NULL
CHECK (payment_method IN ('ACH','Credit Card','Debit Card','Check')),
payment_status TEXT NOT NULL
CHECK (payment_status IN ('Paid','Late','Failed')),
FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);

CREATE TABLE claims (
claim_id INTEGER PRIMARY KEY,
policy_id INTEGER NOT NULL,
claim_date TEXT NOT NULL,
claim_amount REAL NOT NULL CHECK (claim_amount >= 0),
claim_status TEXT NOT NULL CHECK (claim_status IN ('Open','Pending','Closed')),
settlement_amount REAL CHECK (settlement_amount IS NULL OR settlement_amount >= 0),
FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);

CREATE TABLE incident_reports (
incident_id INTEGER PRIMARY KEY,
claim_id INTEGER NOT NULL,
incident_date TEXT NOT NULL,
incident_type TEXT NOT NULL
CHECK (incident_type IN ('Water Damage','Fire','Theft','Liability','Weather','Other')),
description TEXT NOT NULL,
FOREIGN KEY (claim_id) REFERENCES claims(claim_id)
);

CREATE TABLE beneficiaries (
beneficiary_id INTEGER PRIMARY KEY,
policy_id INTEGER NOT NULL,
beneficiary_name TEXT NOT NULL,
relation_to_customer TEXT NOT NULL
CHECK (relation_to_customer IN ('Spouse','Child','Parent','Sibling','Other')),
contact_information TEXT,
FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);

-- INSERT THE DATA INTO THE TABLES

INSERT INTO agents VALUES
(1,'Avery','Stone','avery.stone@example.com','555-100-0001','TX'),
(2,'Jordan','Lee','jordan.lee@example.com','555-100-0002','NJ'),
(3,'Taylor','Brooks','taylor.brooks@example.com','555-100-0003','CT');

INSERT INTO customers VALUES
(1,'Ava','Morgan','1980-04-12','ava.morgan@example.com','555-200-0001','101 Oak St','Dallas','TX','75201','2023-01-10'),
(2,'Liam','Carter','1975-09-21','liam.carter@example.com','555-200-0002','22 Hill Rd','Plano','TX','75024','2022-06-15'),
(3,'Sophia','Reed','1988-02-08','sophia.reed@example.com','555-200-0003','9 River Dr','Jersey City','NJ','07302','2023-03-20'),
(4,'Noah','Bennett','1994-07-19','noah.bennett@example.com','555-200-0004','88 Walnut Ave','Irving','TX','75039','2024-01-05'),
(5,'Emma','Collins','1968-11-30','emma.collins@example.com','555-200-0005','17 Park Pl','Newark','NJ','07102','2021-08-11'),
(6,'Mason','Brooks','1985-05-16','mason.brooks@example.com','555-200-0006','45 Harbor Rd','Stamford','CT','06901','2022-10-02'),
(7,'Olivia','Hayes','1998-12-03','olivia.hayes@example.com','555-200-0007','77 Cedar Ln','Dallas','TX','75204','2025-02-14'),
(8,'Ethan','Price','1979-01-27','ethan.price@example.com','555-200-0008','31 Maple St','White Plains','NY','10601','2023-07-09');

INSERT INTO properties VALUES
(101,'1201 Lakeview Dr','Dallas','TX','75214','Single Family',2005,2800,750000),
(102,'455 Congress Ave','Austin','TX','78701','Condo',2018,1300,425000),
(103,'800 Legacy Dr','Plano','TX','75024','Single Family',2010,3200,900000),
(104,'150 Hudson St','Jersey City','NJ','07302','Condo',2016,1500,650000),
(105,'600 Las Colinas Blvd','Irving','TX','75039','Townhome',2012,1800,350000),
(106,'90 Forest Hill Pkwy','Newark','NJ','07104','Single Family',1998,2400,550000),
(107,'12 Soundview Ave','Stamford','CT','06902','Single Family',2019,3900,1200000),
(108,'2100 McKinney Ave','Dallas','TX','75201','Condo',2020,1100,300000),
(109,'70 Ridgeway Rd','White Plains','NY','10605','Single Family',2008,3000,800000),
(110,'100 Washington St','Hoboken','NJ','07030','Condo',2017,1400,700000);

INSERT INTO policies VALUES
(1001,'POL-1001',1,1,101,'2026-01-01','2026-12-31','Active',1000000,2400),
(1002,'POL-1002',1,1,102,'2026-02-01','2027-01-31','Active',500000,1600),
(1003,'POL-1003',2,1,103,'2026-01-15','2027-01-14','Active',1200000,2800),
(1004,'POL-1004',3,2,104,'2026-03-01','2027-02-28','Active',800000,2100),
(1005,'POL-1005',4,1,105,'2026-04-01','2027-03-31','Active',450000,1400),
(1006,'POL-1006',5,2,106,'2026-01-01','2026-12-31','Active',700000,1900),
(1007,'POL-1007',6,3,107,'2026-02-15','2027-02-14','Active',1500000,3500),
(1008,'POL-1008',7,1,108,'2026-05-01','2027-04-30','Active',350000,1200),
(1009,'POL-1009',8,3,109,'2026-01-20','2027-01-19','Active',1000000,2600),
(1010,'POL-1010',3,2,110,'2026-06-01','2027-05-31','Active',850000,2300);

INSERT INTO underwriting VALUES
(2001,1001,25,'2025-12-10','Approved'),
(2002,1002,35,'2026-01-10','Approved'),
(2003,1003,75,'2025-12-20','Review'),
(2004,1004,45,'2026-02-15','Approved'),
(2005,1005,60,'2026-03-15','Conditional'),
(2006,1006,82,'2025-12-12','Review'),
(2007,1007,30,'2026-01-20','Approved'),
(2008,1008,55,'2026-04-10','Conditional'),
(2009,1009,70,'2025-12-22','Review'),
(2010,1010,40,'2026-05-12','Approved');

INSERT INTO personal_liability_coverage VALUES
(3001,1001,'Home Liability',1000000,1000),
(3002,1002,'Home Liability',500000,1000),
(3003,1003,'Home Liability',300000,2500),
(3004,1004,'Home Liability',750000,1500),
(3005,1005,'General Liability',300000,1500),
(3006,1006,'Home Liability',250000,2500),
(3007,1007,'Umbrella',1000000,2000),
(3008,1008,'General Liability',300000,1000),
(3009,1009,'Home Liability',500000,2000),
(3010,1010,'Home Liability',750000,1500);

INSERT INTO payments VALUES
(4001,1001,'2026-01-05',1200,'ACH','Paid'),
(4002,1001,'2026-07-05',1200,'ACH','Paid'),
(4003,1002,'2026-02-05',800,'Credit Card','Paid'),
(4004,1002,'2026-08-05',800,'Credit Card','Paid'),
(4005,1003,'2026-01-20',1400,'ACH','Late'),
(4006,1003,'2026-07-20',1400,'ACH','Failed'),
(4007,1004,'2026-03-05',1050,'Credit Card','Paid'),
(4008,1004,'2026-09-05',1050,'Credit Card','Paid'),
(4009,1005,'2026-04-05',700,'Debit Card','Paid'),
(4010,1005,'2026-10-05',700,'Debit Card','Late'),
(4011,1006,'2026-01-05',950,'ACH','Failed'),
(4012,1006,'2026-07-05',950,'Check','Late'),
(4013,1007,'2026-02-20',1750,'ACH','Paid'),
(4014,1007,'2026-08-20',1750,'ACH','Paid'),
(4015,1008,'2026-05-05',600,'Credit Card','Paid'),
(4016,1008,'2026-11-05',600,'Credit Card','Paid'),
(4017,1009,'2026-01-25',1300,'ACH','Paid'),
(4018,1009,'2026-07-25',1300,'ACH','Late'),
(4019,1010,'2026-06-05',1150,'Debit Card','Paid'),
(4020,1010,'2026-11-05',1150,'Debit Card','Paid');

INSERT INTO claims VALUES
(5001,1001,'2025-03-10',15000,'Closed',12000),
(5002,1001,'2026-04-01',8000,'Closed',6000),
(5003,1003,'2026-01-15',25000,'Closed',20000),
(5004,1003,'2026-06-20',12000,'Open',NULL),
(5005,1004,'2025-11-22',5000,'Closed',4000),
(5006,1006,'2026-02-10',35000,'Closed',30000),
(5007,1006,'2026-07-04',18000,'Pending',NULL),
(5008,1007,'2026-05-12',10000,'Closed',8000),
(5009,1009,'2025-12-08',22000,'Closed',19000),
(5010,1010,'2026-08-11',7000,'Closed',5000);

INSERT INTO incident_reports VALUES
(6001,5001,'2025-03-10','Water Damage','Pipe leak damaged first floor flooring.'),
(6002,5002,'2026-04-01','Weather','Hail damaged part of the roof.'),
(6003,5003,'2026-01-15','Fire','Kitchen fire caused smoke and cabinet damage.'),
(6004,5003,'2026-01-15','Other','Smoke remediation was required after the fire.'),
(6005,5004,'2026-06-20','Liability','Guest reported an injury on the property.'),
(6006,5005,'2025-11-22','Theft','Electronics were reported stolen.'),
(6007,5006,'2026-02-10','Water Damage','Basement flooding caused structural damage.'),
(6008,5006,'2026-02-10','Other','Mold remediation followed the water event.'),
(6009,5007,'2026-07-04','Weather','Wind damaged exterior siding.'),
(6010,5007,'2026-07-04','Other','Debris damaged a detached structure.'),
(6011,5008,'2026-05-12','Liability','Visitor injury reported near front steps.'),
(6012,5009,'2025-12-08','Weather','Ice damaged gutters and exterior fixtures.'),
(6013,5010,'2026-08-11','Theft','Bicycle and equipment were reported stolen.');

INSERT INTO beneficiaries VALUES
(7001,1001,'Jamie Morgan','Spouse','jamie.morgan@example.com'),
(7002,1003,'Grace Carter','Spouse','grace.carter@example.com'),
(7003,1004,'Mia Reed','Sibling','mia.reed@example.com'),
(7004,1006,'Daniel Collins','Child','daniel.collins@example.com'),
(7005,1007,'Avery Brooks','Spouse','avery.brooks@example.com'),
(7006,1009,'Sarah Price','Spouse','sarah.price@example.com');

-- Now check the data quality!

-- Check for the following:


-- Duplicate customer emails (should be at 0)
SELECT email, COUNT(*) AS duplicate_count
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;

-- Missing required customer fields (should be at 0)
SELECT COUNT(*) AS missing_fields
FROM customers
WHERE first_name IS NULL
OR last_name IS NULL
OR date_of_birth IS NULL
OR email IS NULL
OR phone IS NULL;

-- Number of orphan policies (should be at 0)
SELECT COUNT(*) AS orphan_policies
FROM policies
LEFT JOIN customers ON policies.customer_id = customers.customer_id
LEFT JOIN agents ON policies.agent_id = agents.agent_id
LEFT JOIN properties ON policies.property_id = properties.property_id
WHERE customers.customer_id IS NULL
OR agents.agent_id IS NULL
OR properties.property_id IS NULL
;

-- Invalid payments (should be at 0)
SELECT COUNT(*) AS invalid_payments
FROM payments
WHERE amount <= 0
OR payment_status NOT IN ('Paid', 'Late', 'Failed')
;

-- Closed claims without settlement amounts (should be at 0)

SELECT COUNT(*) AS closed_claims_no_settlement
FROM claims
WHERE claim_status = 'Closed'
AND settlement_amount IS NULL;

-- Now for business analysis:

-- Analysis 1: Find High-value and claim active customers

SELECT customers.customer_id,
customers.first_name,
customers.last_name,
COUNT(DISTINCT policies.policy_id) AS active_policies,
MAX(properties.property_value) AS max_property_value,
COUNT(DISTINCT claims.claim_id) AS claim_count
FROM customers
JOIN policies ON customers.customer_id = policies.customer_id
JOIN properties ON policies.property_id = properties.property_id
LEFT JOIN claims ON policies.policy_id = claims.policy_id
WHERE policies.policy_status = 'Active'
AND customers.date_of_birth <= '1991-01-01'
AND properties.property_value > 500000
GROUP BY customers.customer_id, customers.first_name, customers.last_name, customers.date_of_birth
HAVING COUNT(DISTINCT claims.claim_id) >= 1
ORDER BY max_property_value DESC
;

-- Analysis 2: Customer portfolio activity & engagement

SELECT customers.customer_id,
customers.first_name,
customers.last_name,
COUNT(policies.policy_id) AS active_policy_count,
SUM(policies.premium_amount) AS total_premium,
CASE
    WHEN COUNT(policies.policy_id) >= 2
    THEN 'High Engagement'
    ELSE 'Standard'
    END AS engagement_segment
FROM customers
JOIN policies ON customers.customer_id = policies.customer_id
WHERE policies.policy_status = 'Active'
GROUP BY customers.customer_id, customers.first_name, customers.last_name
ORDER BY active_policy_count DESC, total_premium DESC
;

-- Analysis 3: Is coverage adequate

SELECT policies.policy_number,
customers.first_name,
customers.last_name,
personal_liability_coverage.coverage_limit,
COUNT(incident_reports.incident_id) AS incident_count,
CASE
    WHEN COUNT(incident_reports.incident_id) >= 2
    AND personal_liability_coverage.coverage_limit < 500000
    THEN 'Review Coverage'
    ELSE 'Coverage Appears Adequate'
    END AS coverage_recommendation
FROM policies
JOIN customers ON policies.customer_id = customers.customer_id
JOIN personal_liability_coverage ON policies.policy_id = personal_liability_coverage.policy_id
JOIN claims ON policies.policy_id = claims.policy_id
JOIN incident_reports ON claims.claim_id = incident_reports.claim_id
GROUP BY policies.policy_id, policies.policy_number, customers.first_name, customers.last_name, personal_liability_coverage.coverage_limit
ORDER BY incident_count DESC, personal_liability_coverage.coverage_limit ASC
;

-- Analysis 4: Patment behavior, underwriting risk

SELECT policies.policy_number,
customers.first_name,
customers.last_name,
underwriting.risk_assessment_score,
SUM(
CASE
    WHEN payments.payment_status = 'Paid' THEN 1
    ELSE 0
    END
    ) AS paid_payments,
SUM(
CASE
    WHEN payments.payment_status = 'Late' THEN 1
    ELSE 0
    END
    ) AS late_payments,
SUM(
CASE
    WHEN payments.payment_status = 'Failed' THEN 1
    ELSE 0
    END
    ) AS failed_payments,
CASE
    WHEN underwriting.risk_assessment_score >= 70
    AND SUM(
    CASE
    WHEN payments.payment_status = 'Failed' THEN 1
    ELSE 0
    END
    ) >= 1
    THEN 'High Risk'

WHEN SUM(
    CASE
    WHEN payments.payment_status = 'Failed' THEN 1
    ELSE 0
    END
    ) >= 1
    THEN 'Payment Concern'
WHEN SUM(
    CASE
    WHEN payments.payment_status = 'Late' THEN 1
    ELSE 0
    END
    ) >= 2
    THEN 'Payment Concern'

WHEN underwriting.risk_assessment_score <= 40
AND SUM(
    CASE
    WHEN payments.payment_status = 'Late' THEN 1
    ELSE 0
    END
    ) = 0
    AND SUM(
    CASE
WHEN payments.payment_status = 'Failed' THEN 1
ELSE 0
END
) = 0
THEN 'Retention Candidate'
ELSE 'Monitor'
END AS action_segment
FROM policies
JOIN customers ON policies.customer_id = customers.customer_id
JOIN underwriting ON policies.policy_id = underwriting.policy_id
JOIN payments ON policies.policy_id = payments.policy_id
WHERE policies.policy_status = 'Active'
GROUP BY policies.policy_id, policies.policy_number, customers.first_name, customers.last_name, underwriting.risk_assessment_score
ORDER BY underwriting.risk_assessment_score DESC;