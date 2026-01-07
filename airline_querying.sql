--Creating the table for the airline data
CREATE OR REPLACE TABLE airline (
    Year INT,
    Month INT,
    DayOfMonth INT,
    DayOfWeek INT,
    DepTime FLOAT,
    CRSDepTime INT,
    ArrTime FLOAT,
    CRSArrTime INT,
    UniqueCarrier STRING,
    FlightNum STRING,
    TailNum STRING,
    ActualElapsedTime FLOAT,
    CRSElapsedTime FLOAT,
    AirTime FLOAT,
    ArrDelay FLOAT,
    DepDelay FLOAT,
    Origin STRING,
    Dest STRING,
    Distance INT,
    TaxiIn FLOAT,
    TaxiOut FLOAT,
    Cancelled INT,
    CancellationCode STRING,
    Diverted INT,
    CarrierDelay FLOAT,
    WeatherDelay FLOAT,
    NASDelay FLOAT,
    SecurityDelay FLOAT,
    LateAircraftDelay FLOAT
);

--Creating the stage to ingest data locally to the warehouse in Snowflake
CREATE OR REPLACE STAGE AIRLINE_STAGE;

SHOW DATABASES;

USE DATABASE AIRLINE;

SHOW SCHEMAS;

USE SCHEMA PUBLIC;

SHOW TABLES;

DESCRIBE TABLE AIRLINE.PUBLIC.AIRLINE;

--Checking the overview of the table
SELECT * 
FROM AIRLINE.PUBLIC.AIRLINE 
LIMIT 20;

--Counting the total rows in the table
SELECT COUNT(*) AS TOTAL_ROWS
FROM AIRLINE;

--Checking null values for every column in the airline table
SELECT  COUNT_IF(YEAR IS NULL) AS null_year,
        COUNT_IF(MONTH IS NULL) AS null_month,
        COUNT_IF(DAYOFMONTH IS NULL) AS null_dayofmonth,
        COUNT_IF(DAYOFWEEK IS NULL) AS null_dayofweek,
        COUNT_IF(DEPTIME IS NULL) AS null_deptime,
        COUNT_IF(CRSDEPTIME IS NULL) AS null_crsdeptime,
        COUNT_IF(ARRTIME IS NULL) AS null_arrtime,
        COUNT_IF(CRSARRTIME IS NULL) AS null_crsarrtime,
        COUNT_IF(UNIQUECARRIER IS NULL) AS null_uniquecarrier,
        COUNT_IF(FLIGHTNUM IS NULL) AS null_flightnum,
        COUNT_IF(TAILNUM IS NULL) AS null_tailnum,
        COUNT_IF(ACTUALELAPSEDTIME IS NULL) AS null_actualelapsedtime,
        COUNT_IF(CRSELAPSEDTIME IS NULL) AS null_crselapsedtime,
        COUNT_IF(AIRTIME IS NULL) AS null_airtime,
        COUNT_IF(ARRDELAY IS NULL) AS null_arrdelay,
        COUNT_IF(DEPDELAY IS NULL) AS null_depdelay,
        COUNT_IF(ORIGIN IS NULL) AS null_origin,
        COUNT_IF(DEST IS NULL) AS null_dest,
        COUNT_IF(DISTANCE IS NULL) AS null_distance,
        COUNT_IF(TAXIIN IS NULL) AS null_taxiin,
        COUNT_IF(TAXIOUT IS NULL) AS null_taxiout,
        COUNT_IF(CANCELLED IS NULL) AS null_cancelled,
        COUNT_IF(CANCELLATIONCODE IS NULL) AS null_cancellationcode,
        COUNT_IF(DIVERTED IS NULL) AS null_diverted,
        COUNT_IF(CARRIERDELAY IS NULL) AS null_carrierdelay,
        COUNT_IF(WEATHERDELAY IS NULL) AS null_weatherdelay,
        COUNT_IF(NASDELAY IS NULL) AS null_nasdelay,
        COUNT_IF(SECURITYDELAY IS NULL) AS null_securitydelay,
        COUNT_IF(LATEAIRCRAFTDELAY IS NULL) AS null_lateaircraftdelay,
FROM AIRLINE;

-- Dropping null values from the necesseray columns only and creating a new table as clean
CREATE OR REPLACE TABLE AIRLINE_CLEAN AS
SELECT *
FROM AIRLINE
WHERE YEAR IS NOT NULL
AND MONTH IS NOT NULL
AND DAYOFWEEK IS NOT NULL
AND CRSDEPTIME IS NOT NULL
AND CRSARRTIME IS NOT NULL
AND UNIQUECARRIER IS NOT NULL
AND FLIGHTNUM IS NOT NULL
AND CRSELAPSEDTIME IS NOT NULL
AND ARRDELAY IS NOT NULL
AND DEPDELAY IS NOT NULL
AND ORIGIN IS NOT NULL
AND DEST IS NOT NULL
AND DISTANCE IS NOT NULL;

SELECT *
FROM AIRLINE_CLEAN
LIMIT 20;

SELECT COUNT(*)
FROM AIRLINE_CLEAN;

----Checking null values again for every column in the clean table
SELECT  COUNT_IF(YEAR IS NULL) AS null_year,
        COUNT_IF(MONTH IS NULL) AS null_month,
        COUNT_IF(DAYOFMONTH IS NULL) AS null_dayofmonth,
        COUNT_IF(DAYOFWEEK IS NULL) AS null_dayofweek,
        COUNT_IF(DEPTIME IS NULL) AS null_deptime,
        COUNT_IF(CRSDEPTIME IS NULL) AS null_crsdeptime,
        COUNT_IF(ARRTIME IS NULL) AS null_arrtime,
        COUNT_IF(CRSARRTIME IS NULL) AS null_crsarrtime,
        COUNT_IF(UNIQUECARRIER IS NULL) AS null_uniquecarrier,
        COUNT_IF(FLIGHTNUM IS NULL) AS null_flightnum,
        COUNT_IF(TAILNUM IS NULL) AS null_tailnum,
        COUNT_IF(ACTUALELAPSEDTIME IS NULL) AS null_actualelapsedtime,
        COUNT_IF(CRSELAPSEDTIME IS NULL) AS null_crselapsedtime,
        COUNT_IF(AIRTIME IS NULL) AS null_airtime,
        COUNT_IF(ARRDELAY IS NULL) AS null_arrdelay,
        COUNT_IF(DEPDELAY IS NULL) AS null_depdelay,
        COUNT_IF(ORIGIN IS NULL) AS null_origin,
        COUNT_IF(DEST IS NULL) AS null_dest,
        COUNT_IF(DISTANCE IS NULL) AS null_distance,
        COUNT_IF(TAXIIN IS NULL) AS null_taxiin,
        COUNT_IF(TAXIOUT IS NULL) AS null_taxiout,
        COUNT_IF(CANCELLED IS NULL) AS null_cancelled,
        COUNT_IF(CANCELLATIONCODE IS NULL) AS null_cancellationcode,
        COUNT_IF(DIVERTED IS NULL) AS null_diverted,
        COUNT_IF(CARRIERDELAY IS NULL) AS null_carrierdelay,
        COUNT_IF(WEATHERDELAY IS NULL) AS null_weatherdelay,
        COUNT_IF(NASDELAY IS NULL) AS null_nasdelay,
        COUNT_IF(SECURITYDELAY IS NULL) AS null_securitydelay,
        COUNT_IF(LATEAIRCRAFTDELAY IS NULL) AS null_lateaircraftdelay,
FROM AIRLINE_CLEAN;

--Showing unique flight numbers
SELECT COUNT(DISTINCT FLIGHTNUM) AS UNIQUE_FLIGHTS
FROM AIRLINE_CLEAN;

--Showing unique origins
SELECT DISTINCT ORIGIN
FROM AIRLINE_CLEAN;

--Showing unique carriers
SELECT DISTINCT UNIQUECARRIER
FROM AIRLINE_CLEAN;

SELECT CANCELLED
FROM AIRLINE_CLEAN
WHERE CANCELLED = 1;

-- Creating a final table with clean data and only necessary columns and another column for the target
CREATE OR REPLACE TABLE AIRLINE_FINAL AS
SELECT YEAR,
        MONTH,
        DAYOFWEEK,
        CRSDEPTIME,
        CRSARRTIME,
        UNIQUECARRIER,
        CRSELAPSEDTIME,
        ARRDELAY,
        DISTANCE,
        DEPDELAY,
        ORIGIN,
        DEST,                
        CASE 
            WHEN ARRDELAY <= 0 THEN 1
            ELSE 0 
        END AS ON_TIME
FROM AIRLINE_CLEAN;

--Counting rows for the final table
SELECT COUNT(*)
FROM AIRLINE_FINAL;

SHOW TABLES;

SELECT * 
FROM AIRLINE_FINAL
LIMIT 20;

SELECT *
FROM AIRLINE_FINAL
WHERE YEAR = 1993
LIMIT 20;

SELECT *
FROM AIRLINE_FINAL
WHERE YEAR = 2003
LIMIT 20;

--Showing unique origins
SELECT DISTINCT ORIGIN
FROM AIRLINE_FINAL;

--Showing unique destinations
SELECT DISTINCT DEST 
FROM AIRLINE_FINAL;

--Checking the average rate on time for flights in 1993 and 2003
SELECT YEAR, AVG(ON_TIME) AS RATE_OF_ON_TIME
FROM AIRLINE_FINAL
GROUP BY YEAR;

--Checking the average arrival delay for flights in 1993 and 2003
SELECT YEAR, AVG(ARRDELAY) AS AVG_ARRDELAY
FROM AIRLINE_FINAL
GROUP BY YEAR;

