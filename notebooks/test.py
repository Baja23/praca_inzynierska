from pyspark.sql import SparkSession

# Inicjalizacja Sparka (to może zająć 2-3 sekundy, bo wstaje JVM)
spark = SparkSession.builder \
    .appName("TestInzynierki") \
    .master("local[*]") \
    .getOrCreate()

# Prosty test
data = [("Hola", 1), ("Mundo", 2)]
df = spark.createDataFrame(data, ["Słowo", "ID"])

print("Wersja Sparka:", spark.version)
df.show()