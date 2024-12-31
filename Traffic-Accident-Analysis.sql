 /* 1. Summarize the data to find key insights for high-traffic areas with severe accidents.*/

 SELECT 
    a.traffic_volume,
    b.Weather,
    b.Accident_Severity,
    COUNT(b.Accident) AS total_severe_accidents
FROM 
    Metro_Interstate_Traffic_Volume a
JOIN 
    dataset_traffic_accident_prediction1 b
ON 
    a.ID = b.ID
WHERE 
    b.Accident_Severity = 'High'
GROUP BY 
    a.traffic_volume, b.Weather, b.Accident_Severity
HAVING 
    COUNT(b.Accident) > 0
ORDER BY 
    total_severe_accidents DESC;

 /* 2. Query filters data to focus only on severe accidents (Accident_Severity = 'High').*/

 SELECT 
    a.traffic_volume,
    b.Weather,
    b.Time_of_Day,
    b.Traffic_Density,
    b.Accident_Severity
FROM 
    Metro_Interstate_Traffic_Volume a
JOIN 
    dataset_traffic_accident_prediction1 b
ON 
    a.ID = b.ID
WHERE 
    b.Accident_Severity in ('High')
ORDER BY 
    a.traffic_volume DESC;

 /* 3. checks if high traffic volume corresponds to higher traffic density and accident severity.*/

 SELECT 
    a.traffic_volume,
    b.Traffic_Density,
    b.Accident_Severity,
    COUNT(b.Accident) AS total_accidents
FROM 
    Metro_Interstate_Traffic_Volume a
JOIN 
    dataset_traffic_accident_prediction1 b
ON 
    a.ID = b.ID
GROUP BY 
    a.traffic_volume, b.Traffic_Density, b.Accident_Severity
ORDER BY 
    a.traffic_volume DESC, b.Traffic_Density DESC;

 /* 4. insights into how traffic and weather patterns vary by season */

WITH Seasonal_Traffic AS (
    SELECT 
        t.ID,
        t.DateTime,
        CASE
            WHEN MONTH(t.DateTime) IN (12, 1, 2) THEN 'Winter'
            WHEN MONTH(t.DateTime) IN (3, 4, 5) THEN 'Spring'
            WHEN MONTH(t.DateTime) IN (6, 7, 8) THEN 'Summer'
            WHEN MONTH(t.DateTime) IN (9, 10, 11) THEN 'Fall'
        END AS Season,
        mt.traffic_volume,
        mt.clouds_all,
        mt.rain_1h,
        mt.snow_1h
    FROM traffic t
    JOIN Metro_Interstate_Traffic_Volume mt
    ON t.ID = mt.ID
)
SELECT 
    Season,
    AVG(traffic_volume) AS Avg_Traffic_Volume,
    AVG(clouds_all) AS Avg_Cloud_Coverage,
    AVG(rain_1h) AS Avg_Rainfall,
    AVG(snow_1h) AS Avg_Snowfall,
    COUNT(*) AS Total_Records
FROM Seasonal_Traffic
GROUP BY Season;


/* 5. Identify high-risk conditions and propose measures such as lighting improvements or speed limit enforcement.*/

WITH AccidentAnalysis AS (SELECT 
 Road_Light_Condition, Road_Type, Speed_Limit,
Driver_Experience,COUNT(Accident) AS Total_Accidents,
SUM(CASE WHEN Accident = 1 THEN 1 ELSE 0 END) AS High_Risk_Accidents,
ROUND((CAST(SUM(CASE WHEN Accident = 1 THEN 1 ELSE 0 END) AS FLOAT) /
NULLIF(COUNT(Accident), 0)) * 100, 2) AS High_Risk_Percentage
FROM dataset_traffic_accident_prediction1
GROUP BY Road_Light_Condition,
Road_Type,Speed_Limit,
Driver_Experience)
SELECT Road_Light_Condition,Road_Type,
Speed_Limit, Driver_Experience,
Total_Accidents, High_Risk_Accidents,
High_Risk_Percentage
FROM AccidentAnalysis
WHERE  High_Risk_Percentage > 50 
ORDER BY  High_Risk_Percentage DESC;

/* 6.calculate the percentage of severe accidents under each weather condition.*/

SELECT 
    Weather,
    ROUND((
        SELECT 
            COUNT(*)
        FROM 
            dataset_traffic_accident_prediction1
        WHERE 
            Accident_Severity = 'High' AND Weather = a.Weather
    ) * 100.0 / COUNT(*), 2) AS severe_accident_percentage
FROM 
    dataset_traffic_accident_prediction1 a
GROUP BY 
    Weather
ORDER BY 
    severe_accident_percentage DESC;

/* 7. find accidents that occurred during peak traffic hours (traffic_volume > 90th percentile).*/

SELECT 
    Weather,
    Time_of_Day,
    COUNT(*) AS total_accidents
FROM 
    dataset_traffic_accident_prediction1
WHERE 
    ID IN (
        SELECT ID
        FROM (
            SELECT 
                ID,
                traffic_volume,
                NTILE(10) OVER (ORDER BY traffic_volume DESC) AS volume_percentile
            FROM 
                Metro_Interstate_Traffic_Volume
        ) traffic_data
        WHERE volume_percentile = 1 -- Top 10%
    )
GROUP BY 
    Weather, Time_of_Day
ORDER BY 
    total_accidents DESC;

/* 8.Compare Traffic Volume on Holidays vs non-holidays*/

SELECT 
    holiday_status,
    AVG(traffic_volume) AS avg_traffic_volume
FROM (
    SELECT 
        ID,
        CASE 
            WHEN holiday = 'Yes' THEN 'Holiday'
            ELSE 'Non-Holiday'
        END AS holiday_status,
        traffic_volume
    FROM 
        Metro_Interstate_Traffic_Volume
) holiday_data
GROUP BY 
    holiday_status
ORDER BY 
    avg_traffic_volume DESC;

/* 9.Impact of Cloud Cover on Traffic Volume and Accidents*/

SELECT 
    a.Weather,
    AVG(b.traffic_volume) AS avg_traffic_volume,
    COUNT(a.Accident) AS total_accidents
FROM 
    dataset_traffic_accident_prediction1 a
JOIN 
    Metro_Interstate_Traffic_Volume b
ON 
    a.ID = b.ID
WHERE 
    b.ID IN (
        SELECT ID
        FROM Metro_Interstate_Traffic_Volume
        WHERE clouds_all > 75
    )
GROUP BY 
    a.Weather
ORDER BY 
    total_accidents DESC;
