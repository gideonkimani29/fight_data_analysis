-- ============================================================
-- US Domestic Flights 2008 — SQL Analysis Queries
-- Database: flights.db (SQLite)
-- Author: Daniel Gideon Kimani
-- Date: 2026-04-24
-- ============================================================

-- -------------------------------------------------------
-- 1. OVERVIEW: Flight volume by day of week
-- -------------------------------------------------------
SELECT
    CASE DayOfWeek
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
        WHEN 7 THEN 'Sunday'
    END AS Day,
    COUNT(*)            AS TotalFlights,
    ROUND(AVG(ArrDelay), 2) AS AvgArrDelay,
    ROUND(AVG(DepDelay), 2) AS AvgDepDelay
FROM flights
GROUP BY DayOfWeek
ORDER BY DayOfWeek;

-- -------------------------------------------------------
-- 2. CARRIER PERFORMANCE: On-time rate per airline
-- -------------------------------------------------------
SELECT
    f.UniqueCarrier,
    c.Description                             AS CarrierName,
    COUNT(*)                                  AS TotalFlights,
    SUM(CASE WHEN f.ArrDelay <= 0 THEN 1 ELSE 0 END) AS OnTimeOrEarly,
    ROUND(
        100.0 * SUM(CASE WHEN f.ArrDelay <= 0 THEN 1 ELSE 0 END) / COUNT(*), 2
    )                                          AS OnTimePct,
    ROUND(AVG(f.ArrDelay), 2)                 AS AvgArrDelay
FROM flights f
LEFT JOIN carriers c ON f.UniqueCarrier = c.Code
WHERE f.ArrDelay IS NOT NULL
GROUP BY f.UniqueCarrier, c.Description
ORDER BY OnTimePct DESC;

-- -------------------------------------------------------
-- 3. DELAY CAUSES: Breakdown by delay type
-- -------------------------------------------------------
SELECT
    UniqueCarrier,
    ROUND(AVG(CAST(CarrierDelay    AS FLOAT)), 2) AS AvgCarrierDelay,
    ROUND(AVG(CAST(WeatherDelay    AS FLOAT)), 2) AS AvgWeatherDelay,
    ROUND(AVG(CAST(NASDelay        AS FLOAT)), 2) AS AvgNASDelay,
    ROUND(AVG(CAST(SecurityDelay   AS FLOAT)), 2) AS AvgSecurityDelay,
    ROUND(AVG(CAST(LateAircraftDelay AS FLOAT)), 2) AS AvgLateAircraftDelay
FROM flights
WHERE CarrierDelay IS NOT NULL
GROUP BY UniqueCarrier
ORDER BY AvgCarrierDelay DESC;

-- -------------------------------------------------------
-- 4. ROUTE ANALYSIS: Busiest routes and avg delay
-- -------------------------------------------------------
SELECT
    Origin || ' → ' || Dest AS Route,
    COUNT(*)                 AS FlightCount,
    Distance,
    ROUND(AVG(ArrDelay), 2)  AS AvgArrDelay,
    ROUND(AVG(DepDelay), 2)  AS AvgDepDelay
FROM flights
WHERE ArrDelay IS NOT NULL
GROUP BY Origin, Dest, Distance
ORDER BY FlightCount DESC
LIMIT 20;

-- -------------------------------------------------------
-- 5. CANCELLATIONS: Rate by carrier and cancellation code
-- -------------------------------------------------------
SELECT
    f.UniqueCarrier,
    c.Description            AS CarrierName,
    COUNT(*)                 AS TotalFlights,
    SUM(CAST(f.Cancelled AS INTEGER)) AS Cancelled,
    ROUND(
        100.0 * SUM(CAST(f.Cancelled AS INTEGER)) / COUNT(*), 2
    )                        AS CancellationRate,
    f.CancellationCode,
    CASE f.CancellationCode
        WHEN 'A' THEN 'Carrier'
        WHEN 'B' THEN 'Weather'
        WHEN 'C' THEN 'NAS'
        WHEN 'D' THEN 'Security'
        ELSE 'N/A'
    END AS CancelReason
FROM flights f
LEFT JOIN carriers c ON f.UniqueCarrier = c.Code
GROUP BY f.UniqueCarrier, c.Description, f.CancellationCode
ORDER BY CancellationRate DESC;

-- -------------------------------------------------------
-- 6. AIRPORT HUBS: Busiest origins with delay profile
-- -------------------------------------------------------
SELECT
    f.Origin                 AS IATA,
    a.airport                AS AirportName,
    a.city                   AS City,
    a.state                  AS State,
    COUNT(*)                 AS Departures,
    ROUND(AVG(f.DepDelay), 2) AS AvgDepDelay,
    SUM(CAST(f.Cancelled AS INTEGER)) AS Cancellations
FROM flights f
LEFT JOIN airports a ON f.Origin = a.iata
GROUP BY f.Origin, a.airport, a.city, a.state
ORDER BY Departures DESC
LIMIT 20;

-- -------------------------------------------------------
-- 7. DISTANCE BUCKETS: Delay pattern by flight length
-- -------------------------------------------------------
SELECT
    CASE
        WHEN Distance < 500  THEN 'Short (<500 mi)'
        WHEN Distance < 1000 THEN 'Medium (500-999 mi)'
        WHEN Distance < 2000 THEN 'Long (1000-1999 mi)'
        ELSE                      'Very Long (2000+ mi)'
    END AS DistanceBucket,
    COUNT(*)                  AS Flights,
    ROUND(AVG(ArrDelay), 2)   AS AvgArrDelay,
    ROUND(AVG(ActualElapsedTime), 2) AS AvgFlightTime
FROM flights
WHERE ArrDelay IS NOT NULL
GROUP BY DistanceBucket
ORDER BY MIN(Distance);

-- -------------------------------------------------------
-- 8. WORST DELAY DAYS: Top 10 worst days
-- -------------------------------------------------------
SELECT
    Date,
    COUNT(*)                 AS TotalFlights,
    ROUND(AVG(ArrDelay), 2)  AS AvgArrDelay,
    MAX(ArrDelay)            AS MaxDelay,
    SUM(CAST(Cancelled AS INTEGER)) AS Cancellations
FROM flights
WHERE ArrDelay IS NOT NULL
GROUP BY Date
ORDER BY AvgArrDelay DESC
LIMIT 10;
