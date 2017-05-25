#!/bin/sh

for i in `seq 1987 2008`; do 
    wget http://stat-computing.org/dataexpo/2009/$i.csv.bz2
    bzip2 -d $i.csv.bz2
done
