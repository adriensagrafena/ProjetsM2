import org.apache.spark.{SparkConf, SparkContext}

object Main {
    def main(args:Array[String]) : Unit={
      System.setProperty("hadoop.home.dir", "c:\\winutil\\")
      println("hello world")

      //  Il s'agit de compter le nombre d'occurrences de chaque mot, il faut un sparkcontext pour travailler
      // on doit également afficher le temps d'exécution
      // en ouvrant spark-shell, on doit pouvoir exécuter l'appli et obtenir le print du compte de mots
      // et le temps d'exécution.

      val t= System.nanoTime()     // spark.time() sc.spark.time ou création un nouveau spark context??

      val conf = new SparkConf().setAppName("wordcount").setMaster("local")
      val sc=new SparkContext(conf)
      val f=sc.textFile("data/sample.txt")
      val df=f.flatMap(l=>l.split(" ")).countByValue()


      val temps=System.nanoTime()-t
      println("Bonjour Moez! voici notre petit programme! A demain!")

      println("occurrences de chaque mot:" +df)

      println("temps d'execution en ms:" + temps/1000000)

      }


}
