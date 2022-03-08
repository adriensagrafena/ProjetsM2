import org.apache.spark.sql
import org.apache.spark.sql.functions._

object Main {
  def main (args: Array[String]): Unit = {
    System.setProperty("hadoop.home.dir", "c:\\winutil\\")
    print("question 1: on prépare une session spark comme si on était sur le shell")

    val spark = sql.SparkSession.builder.master("local").appName("Spark CSV Reader").getOrCreate

    println("question 2")

    val df= spark.read.option("header",value=true).csv("data/walmart_stock.csv")
    println("Un aperçu du dataframe")
    df.show


    println("question 3 et 4 ")
    df.printSchema()

    // Format de colonnes : str ; la conversion automatique pour calculer HV ratio dans question 5

    print("question 5:on ajoute la colonne HV_Ratio ")

    val df2=df.withColumn("HV_Ratio",col("High")/col("Volume"))
    df2.show

    print("on convertit les colonnes str en type int en prévision des autres questions")

    val df3=df2.selectExpr("cast(Volume as int) as Volume", "cast(High as int) as High", "cast(Close as int) as Close",
      "Date as Date", "Low as Low","Open as Open")

     df3.createOrReplaceTempView("df4")

   // df3.printSchema
    // df3.show()

    println("question 6")

    df3.select(col("Date"), col("High")).orderBy(desc("High")).show

    spark.sql("select Date,High from df4 order by High desc").show

    println("question 7")

    df3.select(mean("Close")).show
    spark.sql("select mean(Close) as moyenne from df4").show

    println("question 8:")

    df3.select(min("Volume"),max("Volume")).show
    spark.sql("select max(Volume),min(Volume) from df4").show

    println("question 9: nombre de jours avec Close<60")

    df3.filter(col("Close")<60).select(count(col("Date"))).show
    // ou count tout court
    spark.sql("select count(Date) as nombredejours from df4 where Close<60 ").show

    println("question 10: le pourcentage vaut: "+100.floatValue()*df3.filter(col("High")>80).count()/df3.count())

    spark.sql("select round((select count(*) from df4 where High>80)/count(*)*100,2) as percentage from df4 ").show

    println("question 11: le max de la colonne High par an ")

    // on peut aussi utiliser withColumn df3.withColumn("year",year(col("Date"))).groupBy(col("year")).max("High").show

    df3.groupBy(year(col("Date")) alias "annee").max("High").show
    spark.sql("select year(Date) as annee,max(High) as maximum from df4 group by annee").show

    println("question 12: moyenne de la colonne Close par mois ")

    df3.groupBy(month(col("Date")) alias "mois").avg("Close").show
    spark.sql("select month(Date) as mois,avg(High) as moyenne from df4 group by mois").show

    // ou bien: df3.withColumn("month",month(col("Date"))).groupBy("month").avg("Close").show

    println("question 13: sauvegarde du résultat de la question 12 au format parquet")

    val d=df3.groupBy(month(col("Date")) alias "mois").agg(avg("Close") alias "moyenne").toDF()

    d.write.parquet("question13.parquet")

  }


}
