-- Retrieve all patients from Lagos

SELECT * FROM [dbo].[Patients (2)]
WHERE City = 'Lagos'
-- Find all patients with a length of stay greater than 5 days

SELECT * FROM [dbo].[Patients (2)]
WHERE Length_of_Stay > 5;
 
-- Find patients whose age is between 30 and 50 year.

SELECT * FROM [dbo].[Patients (2)]
WHERE Age BETWEEN 30 AND 50;

-- Retrieve all female patients from lagos who were admitted through Emergency admission.

SELECT * FROM [dbo].[Patients (2)]
WHERE Gender = 'Female'
AND City = 'Lagos'
AND Admission_Type = 'Emergency';

-- Retrive all patients who have Diabetes or hypertension.

SELECT * FROM [dbo].[Patients (2)]
WHERE Condition = 'Diabetes'OR  Condition = 'Hypertension'

-- Find the 3 patients with the longest hospital stays, from longest to shortest.

SELECT TOP 3 * FROM [dbo].[Patients (2)]
ORDER BY Length_of_Stay DESC;

-- List all unique cities represented from datasets.

SELECT DISTINCT City
FROM [dbo].[Patients (2)]

-- Count the total number of patients.
        
SELECT COUNT (*) AS Total_Patients
FROM [dbo].[Patients (2)]

-- Calculate the average patients age.

SELECT AVG (Age) AS Avg_Patients
FROM [dbo].[Patients (2)]

 -- Count the number of patients for each medication condition

 SELECT Condition, COUNT (*) AS Number_of_Patients
 FROM [dbo].[Patients (2)]
 GROUP BY Condition;

 -- Display each patient's full name in uppercase

 SELECT UPPER (Patient_Name) AS Uppercase_Name 
 FROM [dbo].[Patients (2)]

 -- Display each patient's full name in Lowercase

 SELECT LOWER (Patient_Name) AS Lower_Name
 FROM [dbo].[Patients (2)]

 -- Create a new column that combines the patient ID and patient name into one value
SELECT CONCAT(Patient_ID, '  ' + Patient_Name) AS Patient_Info
FROM [dbo].[Patients (2)]

-- Find all patients who were admitted after January 15, 2026.

 SELECT * FROM [dbo].[Patients (2)]
 WHERE Admission_Date > '2026-01-15';

 -- Display the year and month in which each patient was admitted.
 SELECT 
    Patient_Name,
    YEAR (Admission_Date) AS Admission_Year,
    MONTH (Admission_Date) AS Admission_Month
    FROM [dbo].[Patients (2)];

SELECT * FROM [dbo].[Doctors (2)]

-- Calculate the average length of stay for each admission type.

SELECT Admission_Type, AVG(Length_of_Stay) AS Avg_Stay
FROM [dbo].[Patients (2)]
GROUP BY Admission_Type;

-- Find the admission types with an average length of stay greater than 4 days

SELECT
    Admission_Type, 
    AVG(Length_of_Stay) AS Avg_Stay
FROM [dbo].[Patients (2)]
GROUP BY Admission_Type
HAVING AVG(Length_of_Stay) > 4;

-- classify patients are young (under 40), middle_aged (40-59), or senior (60 and above).
SELECT 
    Patient_Name,
    Age,
    CASE    
        WHEN Age < 40 THEN 'Young'
        WHEN Age BETWEEN 40 AND 59 THEN 'Middle_Age'
            ELSE 'Senior'
           END AS Age_Group
           FROM [dbo].[Patients (2)]

-- count the number of patients in each age group.

SELECT 
    CASE    
        WHEN Age < 40 THEN 'Young'
        WHEN Age BETWEEN 40 AND 59 THEN 'Middle_Age'
            ELSE 'Senior'
           END AS Age_Group,
           COUNT(*) AS Number_of_Patients
           FROM [dbo].[Patients (2)]
GROUP BY 
 CASE    
        WHEN Age < 40 THEN 'Young'
        WHEN Age BETWEEN 40 AND 59 THEN 'Middle_Age'
            ELSE 'Senior'
           END

-- classigy patients as Short Stay (3 days or less) or Long Stay (more than 3 days).
SELECT 
      Patient_Name
      Length_of_Stay,
       CASE
           WHEN Length_of_Stay <= 3 THEN 'Short Stay'
             ELSE 'Long Stay'
         END AS Stay_Type
FROM [dbo].[Patients (2)]

-- Find the medical conditions with more than 1 patient

SELECT
    Condition,
    COUNT(*) AS Patient_Count
FROM [dbo].[Patients (2)]
GROUP BY Condition
HAVING COUNT(*) > 1;

-- Import the Doctors table and verify it was loaded correctly 

SELECT * FROM [dbo].[Doctors (2)]
SELECT COUNT(*) AS Total_Doctors FROM [dbo].[Doctors (2)]    

-- Join the Patients and Doctors table to display each patient's name and their doctor's specialization.
SELECT
    p.Patient_Name,
    d.Doctor_Name,
    d.Specialization
    FROM [dbo].[Patients (2)] P
    INNER JOIN [dbo].[Doctors (2)] d ON P.Doctor_ID = d.Doctor_ID

-- Find  all patients treated by doctors specializing in internal medicine.

SELECT
    p.Patient_Name,
    d.Doctor_Name,
    d.Specialization
    FROM [dbo].[Patients (2)] P
    JOIN [dbo].[Doctors (2)] d ON P.Doctor_ID = d.Doctor_ID
    WHERE d.Specialization = 'Internal Medicine';

-- Calculate the average length of stay for patients treated by each doctor.

SELECT 
    d.Doctor_Name,
    AVG(p.Length_of_stay) AS Avg_Length_Of_Stay
FROM [dbo].[Patients (2)] p
JOIN [dbo].[Doctors (2)] d ON p.Doctor_ID = d.Doctor_ID
GROUP BY d.Doctor_Name;



-- Identify the doctor who has treated the hoghest number of patients.

SELECT TOP 1
    d.Doctor_Name,
    COUNT(p.Patient_ID) AS Number_Of_Patients
FROM [dbo].[Doctors (2)] d
JOIN [dbo].[Patients (2)] p ON d.Doctor_ID = p.Doctor_ID
GROUP BY d.Doctor_Name
ORDER BY Number_Of_Patients DESC;

-- Identify patients with above-average hospital stays and rank them within their respective medical conditions.

SELECT
    Patient_Name,
    Condition,
    Length_of_Stay,
    ROW_NUMBER() OVER (
        PARTITION BY Condition
        ORDER BY Length_of_Stay DESC
    ) AS Stay_Rank
FROM [dbo].[Patients (2)]
WHERE Length_of_Stay >
(
    SELECT AVG(Length_of_Stay)
    FROM [dbo].[Patients (2)]
)
ORDER BY Condition, Stay_Rank;
