#!/bin/sh

for i in $(seq -f "%02g" 1 12); do
    wget https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2015-$i.csv
done
