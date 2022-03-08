import org.apache.hadoop.conf.Configuration
import org.apache.hadoop.fs.{FileSystem, Path}
import org.apache.spark.ml.clustering._
import org.apache.spark.ml.feature._
import org.apache.spark.sql._
import org.apache.spark.sql.functions._

import java.io.FileInputStream
import java.util.Properties


object Main {
  def main(args : Array[String]) : Unit = {
    System.setProperty("hadoop.home.dir", "c:\\winutil\\")

    // Questions 1 et 2

    def getProp(propertyName: String): String = {
      val properties= new Properties()
      properties.load(new FileInputStream("config.properties"))
      val property= properties.getProperty(propertyName)
      property.toString
    }

    // Question 3

    val output_data = getProp("Output-data")
    val input_data = getProp("Input-data")
    val kmeans_level= getProp("Kmeans-level").toInt

    val spark=SparkSession.builder.master("local").appName("Kmeans-spark").getOrCreate
    val dt=spark.read.json(input_data)
    dt.show

    // Question 4

    val Kmeansdf = dt.selectExpr("latitude", "longitude")

    // Question 5

    val assembler = new VectorAssembler().setInputCols(Array("longitude", "latitude")).setOutputCol("features")

    val kmeans = new KMeans().setK(kmeans_level).setSeed(1L)

    val intermediaireDF = assembler.transform(Kmeansdf)

    val model = kmeans.fit(intermediaireDF)

    val fitted = model.transform(intermediaireDF)

    // Question 6

    fitted.show

    // Question 7

    fitted.createOrReplaceTempView("fitted2")

    fitted.groupBy(col(colName = "prediction")).avg("latitude", "longitude").show
    spark.sql(sqlText = "Select prediction, avg(latitude) as latitudemoy , avg(longitude) as longitudemoy from fitted2 group by prediction").show

    // Question 8
    // on utilise coalesce pour que la partition des données se fasse dans un fichier unique et mode(...) pour
    // éviter les erreurs de type "dossier déjà existant" quand on exécute le programme plusieurs fois

    fitted.drop(colName="features").coalesce(1).write.mode(SaveMode.Overwrite).json(output_data)

    // le nom du fichier JSON change à chaque exécution.Avec le système de fichiers Hadoop, on récupère tous les fichiers
    // du répertoire de sortie (output_data) dont le nom contient "part" suivi d'autres caractères. Le 1er d'entre eux dans
    // l'ordre lexicographique est notre fichier de données JSON dont on récupère le path puis le nom afin de
    // le renommer via la méthode rename en fitted.json, que l'on utilise ensuite dans Python

    val hadoopConfig = new Configuration()
    val hdfs = FileSystem.get(hadoopConfig)
    val file = hdfs.globStatus(new Path(output_data + "part*"))(0).getPath.getName
    hdfs.rename(new Path(output_data+file),new Path(output_data+"fitted.json"))

  }
}
