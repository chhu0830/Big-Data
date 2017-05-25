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
    WeatherDelay:chararray,
    NASDelay:chararray,
    SecurityDelay:chararray,
    LateAircraftDelay:chararray
);

csv = FILTER csv BY $0 != 'Year';
group_all = GROUP csv ALL;
ans1 = FOREACH group_all GENERATE group, AVG(csv.ArrDelay), AVG(csv.DepDelay);
group_by_month = GROUP csv BY Month;
ans2 = FOREACH group_by_month GENERATE group, MAX(csv.ArrDelay), MAX(csv.DepDelay);
STORE ans1 INTO 'p1-1';
STORE ans2 INTO 'p1-2';
DUMP ans2;
