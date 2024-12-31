# Traffic-Accident-Analysis-SQL

This repository showcases SQL queries and scenarios for analyzing traffic, weather, and accident data. 
The project integrates three datasets to provide insights into traffic volume trends, accident severity, and the impact of weather on road safety.

# Project Overview
This project includes six distinct scenarios that demonstrate the use of SQL for advanced data analysis:

1. Traffic Volume Trends

Analyze daily traffic volume across different junctions and weather conditions.
Identify high-traffic periods for better traffic management.

2. Accident Severity Prediction

Correlate traffic volume with accident severity.
Explore factors like weather and time of day that impact accidents.

3. Weather Impact on Traffic and Accidents

Evaluate the influence of adverse weather (rain, snow, cloud cover) on traffic and accident severity.
Identify weather patterns associated with severe accidents.

4. Traffic Density and Accident Severity

Analyze how traffic density correlates with accident severity.
Investigate junctions with high traffic density and frequent accidents.

5. Junction Analysis for Traffic Management

Pinpoint accident-prone junctions.
Suggest traffic management strategies for high-risk areas.

6. Temporal Analysis of Traffic and Accidents

Study traffic patterns and accident trends by time of day.
Identify peak hours for accidents under varying weather conditions.

# Datasets Used
Traffic Data (traffic)

Columns: DateTime, Junction, Vehicles, ID
Metro Interstate Traffic Volume (Metro_Interstate_Traffic_Volume)

Columns: traffic_volume, holiday, temp, rain_1h, snow_1h, clouds_all, weather_main, Weather, date_time, ID
Traffic Accident Prediction Data (dataset_traffic_accident_prediction1)

Columns: Weather, Road_Type, Time_of_Day, Traffic_Density, Speed_Limit, Number_of_Vehicles, Driver_Alcohol, Accident_Severity, Road_Condition, Vehicle_Type, Driver_Age, Driver_Experience, Road_Light_Condition, Accident, ID
