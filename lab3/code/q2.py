sc.textFile('lab3/data/*.csv')\
  .map(lambda x: x.split(','))\
  .filter(lambda x: x[0] != 'VendorID')\
  .filter(lambda x: float(x[3]) > 0)\
  .map(lambda x: (x[11], float(x[3])))\
  .groupByKey()\
  .mapValues(lambda x: sum(x) / len(x))\
  .collect()
