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
    CarrierDelay:int,
    WeatherDelay:int,
    NASDelay:int,
    SecurityDelay:int,
    LateAircraftDelay:int
);

csv = FILTER csv BY $0 != 'Year';
g = GROUP csv BY Origin;
delay = FOREACH g {
          carrier = FILTER csv BY CarrierDelay > 0;
          weather = FILTER csv BY WeatherDelay > 0;
          nas = FILTER csv BY NASDelay > 0;
          security = FILTER csv BY SecurityDelay > 0;
          aircraft = FILTER csv BY LateAircraftDelay > 0;
          GENERATE group, AVG(csv.DepDelay) AS delay, COUNT(carrier), COUNT(weather), COUNT(nas), COUNT(security), COUNT(aircraft);
        };
delay = ORDER delay BY delay;
DUMP delay;

g = GROUP csv BY Dest;
delay = FOREACH g {
          carrier = FILTER csv BY CarrierDelay > 0;
          weather = FILTER csv BY WeatherDelay > 0;
          nas = FILTER csv BY NASDelay > 0;
          security = FILTER csv BY SecurityDelay > 0;
          aircraft = FILTER csv BY LateAircraftDelay > 0;
          GENERATE group, AVG(csv.ArrDelay) AS delay, COUNT(carrier), COUNT(weather), COUNT(nas), COUNT(security), COUNT(aircraft);
        };
delay = ORDER delay BY delay;
DUMP delay;
/*
delay = FOREACH g GENERATE group, AVG(csv.ArrDelay) AS delay, COUNT(csv), SUM(csv.ArrDelay),
        SUM(csv.CarrierDelay), SUM(csv.WeatherDelay), SUM(csv.NASDelay),
        SUM(csv.SecurityDelay), SUM(csv.LateAircraftDelay);
*/
