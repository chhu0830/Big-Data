import re
sc.textFile('lab3/data/IhaveaDream.txt')\
  .flatMap(lambda line: re.findall('\w+', line))\
  .map(lambda word: (word.lower(), 1))\
  .reduceByKey(lambda a, b: a + b)\
  .sortBy(lambda x: x[1], ascending=False)\
  .take(20)
