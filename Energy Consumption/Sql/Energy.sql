CREATE TABLE energy_consumption_changed (
    Date VARCHAR(10),
    Day VARCHAR(2),
    Month VARCHAR(3),
    Year VARCHAR(4),
    Building VARCHAR(10),
    Type_Year VARCHAR(20),
    Amount INT
);

-- Insert the transformed data into the new table
INSERT INTO energy_consumption_changed (Date, Day, Month, Year, Building, Type_Year, Amount)
WITH SplitDate AS (
    SELECT 
        Date,
        LEFT(Date, LOCATE('-', Date) - 1) AS Day,
        SUBSTRING(Date, LOCATE('-', Date) + 1, 3) AS Month,
        CONCAT('20', RIGHT(Date, 2)) AS Year,
        Building,
        `Water Consumption`,
        `Electricity Consumption`,
        `Gas Consumption`
    FROM energy_consumption
)
SELECT 
    Date,
    Day,
    Month,
    Year,
    Building,
    CONCAT(ConsumptionType, '-', Year) AS Type_Year,
    Amount
FROM (
    SELECT 
        Date,
        Day,
        Month,
        Year,
        Building,
        'Water' AS ConsumptionType,
        `Water Consumption` AS Amount
    FROM SplitDate
    UNION ALL
    SELECT 
        Date,
        Day,
        Month,
        Year,
        Building,
        'Electricity' AS ConsumptionType,
        `Electricity Consumption` AS Amount
    FROM SplitDate
    UNION ALL
    SELECT 
        Date,
        Day,
        Month,
        Year,
        Building,
        'Gas' AS ConsumptionType,
        `Gas Consumption` AS Amount
    FROM SplitDate
) AS UnpivotedData;

select * from energy_consumption_changed;
-- -------------------------------------------------------------------------------------------
CREATE TABLE ratesnew (
    Type_Year VARCHAR(50),
    Year INT,
    Energy_Type VARCHAR(50),
    Price_Per_Unit DECIMAL(10,2)
);

INSERT INTO ratesnew (Type_Year, Year, Energy_Type, Price_Per_Unit)
SELECT 
    CONCAT(`Energy Type`, '-', Year) AS Type_Year,
    Year,
	`Energy Type`,
    CAST(REPLACE(TRIM(`Price Per Unit`), '$', '') AS DECIMAL(10,2)) AS `Price_Per_Unit`
FROM rates;
-- -------------------------------------------------------------------------------------------



