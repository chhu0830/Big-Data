from pyspark import SparkContext
from pyspark.mllib.regression import LabeledPoint, LinearRegressionWithSGD, LinearRegressionModel
from pyspark.mllib.evaluation import RegressionMetrics
from pyspark.mllib.tree import DecisionTree, DecisionTreeModel

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
data = sc.textFile('lab2/data/2008.csv')\
         .map(lambda x: x.split(','))\
         .filter(lambda x: x[0] != 'Year')\
         .filter(lambda x: x[21] != '1')\
         .filter(lambda x: x[25] != 'NA')\
         .map(lambda x: [i.replace('NA', '0') for i in x])
parsedData = data.map(parsePoint)
testData = parsedData

### Reading Model ###
model = DecisionTreeModel.load(sc, 'DecisionTreeRegressionModel')

### Predicting and MSE, MAE ###
predictions = model.predict(testData.map(lambda x: x.features))
labelsAndPredictions = testData.map(lambda lp: lp.label).zip(predictions)
MSE = labelsAndPredictions.map(lambda (v, p): (v - p) * (v - p)).sum() / float(testData.count())
MAE = labelsAndPredictions.map(lambda (v, p): abs(v - p)).sum() / float(testData.count())
print(str(MSE**0.5) + ' ' + str(MAE))

'''
prediObserRDDin = parsedData.map(lambda row: (float(model.predict(row.features)), row.label))
metrics = RegressionMetrics(prediObserRDDin)

print(metrics.rootMeanSquaredError)
'''
