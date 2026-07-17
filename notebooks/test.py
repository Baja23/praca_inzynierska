from pyspark.sql import SparkSession

# Inicjalizacja Sparka
spark = SparkSession.builder \
    .appName("TestInzynierki") \
    .master("local[*]") \
    .getOrCreate()

# Prosty test
data = [("Hola", 1), ("Mundo", 2)]
df = spark.createDataFrame(data, ["Słowo", "ID"])

print("Wersja Sparka:", spark.version)
df.show()