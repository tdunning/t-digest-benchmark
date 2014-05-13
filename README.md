t-digest-benchmark
==================

A simple JMH benchmark for various versions of t-digest

How to Run
==========

Compile the code

    mvn clean package

and run the benchmarks

    java -cp target/microbenchmarks.jar:target/target/t-digest-benchmark-1.0-SNAPSHOT.jar com.tdunning.Benchmark

Then run the visualization

    Rscript plot-data.r

Look at results.pdf for the results.
