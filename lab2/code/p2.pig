csv = LOAD 'data/*.csv' USING PigStorage(',') AS (
    Year:chararray,
    Month:chararray,
    DayofMonth:chararray,
    DayOfWeek:chararray,
    DepTime:chararray,
    CRSDepTime:chararray,
    ArrTime:chararray,
    CRSArrTime:chararray,
    UniqueCarrier:chararray,
    FlightNum:chararray,
    TailNum:chararray,
    ActualElapsedTime:chararray,
    CRSElapsedTime:chararray,
    AirTime:chararray,
    ArrDelay:int,
    DepDelay:int,
    Origin:chararray,
    Dest:chararray,
    Distance:chararray,
    TaxiIn:chararray,
    TaxiOut:chararray,
    Cancelled:chararray,
    CancellationCode:chararray,
    Diverted:chararray,
    CarrierDelay:chararray,
    WeatherDelay:int,
    NASDelay:chararray,
    SecurityDelay:chararray,
    LateAircraftDelay:chararray
);

csv = FILTER csv BY $0 != 'Year';
csv = FILTER csv BY WeatherDelay != 0;
g = GROUP csv ALL;
ans = FOREACH g GENERATE COUNT(csv), AVG(csv.WeatherDelay), AVG(csv.ArrDelay), AVG(csv.DepDelay);
STORE ans INTO 'p2';
