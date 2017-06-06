#!/usr/bin/pyspark
from pyspark import SparkContext
from pyspark.mllib.regression import LabeledPoint, LinearRegressionWithSGD
from pyspark.mllib.tree import DecisionTree, DecisionTreeModel
# from pyspark.mllib.evaluation import RegressionMetrics

### Some Tools ###
def encode(text):
    ret = 0
    for i in text:
        ret = ret * 26 + (ord(i) - ord('A'))
    return ret

def parsePoint(values):
    values[16] = encode(values[16])
    values[17] = encode(values[17])
    return LabeledPoint(float(values[25]), [float(values[i]) for i in [1, 2, 3, 4, 5, 6, 7, 9, 11, 12, 13, 16, 17, 18]])

### Parsing Data ###
sc = SparkContext()
data = sc.textFile('lab2/data/200[3-7].csv')\
         .map(lambda x: x.split(','))\
         .filter(lambda x: x[0] != 'Year')\
         .filter(lambda x: x[21] != '1')\
         .filter(lambda x: x[25] != 'NA')\
         .map(lambda x: [i.replace('NA', '0') for i in x])
parsedData = data.map(parsePoint)

### Holdout validation ###
# trainingData, testData = parsedData.randomSplit([.8, .2])
trainingData = parsedData

### Training Model ###
# model = LinearRegressionWithSGD.train(trainingData, 100, 0.0000001)
model = DecisionTree.trainRegressor(trainingData, categoricalFeaturesInfo={}, impurity='variance', maxDepth=8, maxBins=256)
model.save(sc, 'DecisionTreeRegressionModel')

### RMSE and MAE ###
'''
predictions = model.predict(testData.map(lambda x: x.features))
labelsAndPredictions = testData.map(lambda lp: lp.label).zip(predictions)
MSE = labelsAndPredictions.map(lambda (v, p): (v - p) * (v - p)).sum() / float(testData.count())
MAE = labelsAndPredictions.map(lambda (v, p): abs(v - p)).sum() / float(testData.count())
print(str(MSE**0.5) + ' ' + str(MAE))
'''

### RMSE by RegressionMetrics ###
'''
prediObserRDDin = trainingData.map(lambda row: (float(model.predict(row.features)), row.label))
metrics = RegressionMetrics(prediObserRDDin)

print(metrics.rootMeanSquaredError)

model.save(sc, 'LinearRegressionWithSGD')
'''

