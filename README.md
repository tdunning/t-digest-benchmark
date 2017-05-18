t-digest-benchmark
==================

A simple JMH benchmark for various versions of t-digest

How to Run
==========

Compile the code

    mvn clean package

and run the benchmarks

    java -jar target/microbenchmarks.jar com.tdunning.Benchmark.add -rff results.csv
    java -cp target/microbenchmarks.jar com.tdunning.MergeBench 

Then run the visualization

    Rscript plot-data.r

Look at results.pdf for the results.
