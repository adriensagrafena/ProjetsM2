import org.apache.spark.{SparkConf, SparkContext}

import scala.math._
object Main {

  def main(args: Array[String]): Unit = {
    System.setProperty("hadoop.home.dir", "c:\\winutil\\")

    val conf: SparkConf = new SparkConf().setAppName("pi_spark").setMaster("local")

    val sc = new SparkContext(conf)

    def is_point_inside_the_circle(): Int = {
      val x = random()
      val y = random()
      if (x * x + y * y < 1) 1 else 0
    }

    def pi_estimator_spark(n: Int): Unit = {
      val t = System.nanoTime()
      val approx = sc.parallelize(Range(0, n)).map(_ => is_point_inside_the_circle()).mean() * 4

      val temps: Long = System.nanoTime() - t
      println("temps d'execution en ms:" + temps / 1000000)

      println("la valeur approchée de Pi est :" + approx)
      println("l'écart entre Pi et sa valeur approchée est :" + math.abs(math.Pi - approx))
    }

    pi_estimator_spark(1000000)
  }
}