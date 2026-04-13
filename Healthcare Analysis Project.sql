create database healthcare;
use healthcare;
select * from visit_table;
select * from treatment_table;
select * from doctor_table;
select * from lab_test_table;
select * from patient_table;

USE healthcare;

-- Add Primary Keys (Required)
ALTER TABLE patient_table
ADD PRIMARY KEY (`Patient ID`);

ALTER TABLE doctor_table
ADD PRIMARY KEY (`Doctor ID`);

ALTER TABLE visit_table
ADD PRIMARY KEY (`Visit ID`);

ALTER TABLE lab_test_table
ADD PRIMARY KEY (`Lab Result ID`);

ALTER TABLE treatment_table
ADD PRIMARY KEY (`Treatment ID`);


-- visit → patient
ALTER TABLE visit_table
ADD CONSTRAINT fk_visit_patient
FOREIGN KEY (`Patient ID`)
REFERENCES patient_table(`Patient ID`)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- visit → doctor
ALTER TABLE visit_table
ADD CONSTRAINT fk_visit_doctor
FOREIGN KEY (`Doctor ID`)
REFERENCES doctor_table(`Doctor ID`)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- lab_test → visit
ALTER TABLE lab_test_table
ADD CONSTRAINT fk_labtest_visit
FOREIGN KEY (`Visit ID`)
REFERENCES visit_table(`Visit ID`)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- treatment → visit
ALTER TABLE treatment_table
ADD CONSTRAINT fk_treatment_visit
FOREIGN KEY (`Visit ID`)
REFERENCES visit_table(`Visit ID`)
ON DELETE CASCADE
ON UPDATE CASCADE;


-- 1. Total Patients
SELECT COUNT(*) AS total_patients
FROM patient_table;

-- 2. Total Doctors
select count(*) as total_doctors 
from doctor_table;

-- 3. Total Visits
select count(*) as total_visits
from visit_table;

-- 4. Average Age Of Patients
SELECT ROUND(AVG(age), 0) AS avg_patient_age
FROM patient_table;

-- 5. Top 5 Diagnosed Conditions
SELECT 
    diagnosis,
    COUNT(*) AS diagnosis_count
FROM visit_table
GROUP BY diagnosis
ORDER BY diagnosis_count DESC
LIMIT 5;

-- 6. Follow Up Rate
SELECT 
    ROUND(
        SUM(CASE WHEN `Follow Up Required` = 'Yes' THEN 1 ELSE 0 END) 
        * 100.0 / COUNT(*), 
    2) AS follow_up_rate_percentage
FROM visit_table;


-- 7. Average Treatment Cost Per Visit
SELECT 
    ROUND(AVG(visit_cost), 2) AS avg_treatment_cost_per_visit
FROM (
    SELECT 
        `Visit ID`,
        SUM(`Cost`) AS visit_cost
    FROM treatment_table
    GROUP BY `Visit ID`
) t;


-- 8. Total Lab Tests Conduted
SELECT COUNT(*) AS total_lab_tests
FROM lab_test_table;

-- 9. Percentage Of Abnormal Results
SELECT 
ROUND(
    SUM(CASE WHEN `Test Result` = 'Abnormal' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
2) AS abnormal_lab_result_percentage
FROM lab_test_table;


-- 10. Doctor Workload (Avg. Patients Per Doctor)
SELECT 
ROUND(
    COUNT(DISTINCT `Patient ID`) / COUNT(DISTINCT `Doctor ID`),
2) AS avg_patients_per_doctor
FROM visit_table;


-- 11. Total Revenue
SELECT 
round(SUM(`Cost`), 2) AS total_revenue
FROM treatment_table;



