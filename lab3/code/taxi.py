import re, string
from pyspark import SparkContext

sc =SparkContext()

data = sc.textFile('yellow_tripdata_2015-*.csv')
header = data.first()
data = data.filter(lambda line:line != header)
data = data.map(lambda line:line.split(','))
data = data.filter(lambda line:float(line[3]) > 0)
data = data.map(lambda line:(line[11],float(line[3])))
data = data.groupByKey()



print(data)