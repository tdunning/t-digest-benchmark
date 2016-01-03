/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.tdunning;

import com.tdunning.math.stats.ArrayDigest;
import com.tdunning.math.stats.TDigest;
import org.openjdk.jmh.annotations.BenchmarkMode;
import org.openjdk.jmh.annotations.Fork;
import org.openjdk.jmh.annotations.GenerateMicroBenchmark;
import org.openjdk.jmh.annotations.Measurement;
import org.openjdk.jmh.annotations.Mode;
import org.openjdk.jmh.annotations.OutputTimeUnit;
import org.openjdk.jmh.annotations.Param;
import org.openjdk.jmh.annotations.Scope;
import org.openjdk.jmh.annotations.Setup;
import org.openjdk.jmh.annotations.State;
import org.openjdk.jmh.annotations.Threads;
import org.openjdk.jmh.annotations.Warmup;
import org.openjdk.jmh.output.results.ResultFormatType;
import org.openjdk.jmh.profile.ProfilerType;
import org.openjdk.jmh.runner.Runner;
import org.openjdk.jmh.runner.RunnerException;
import org.openjdk.jmh.runner.options.Options;
import org.openjdk.jmh.runner.options.OptionsBuilder;

import java.util.Random;
import java.util.concurrent.TimeUnit;

@BenchmarkMode(Mode.AverageTime)
@OutputTimeUnit(TimeUnit.NANOSECONDS)
@Warmup(iterations = 4, time = 3, timeUnit = TimeUnit.SECONDS)
@Measurement(iterations = 8, time = 2, timeUnit = TimeUnit.SECONDS)
@Fork(1)
@Threads(1)
@State(Scope.Thread)
public class ArrayBench {
    private Random gen = new Random();
    private double[] data;

    @Param({"20", "50", "100", "200", "500"})
    public int compression;

    @Param({"8", "16", "24", "32", "48", "64"})
    public int pageSize;

    private TDigest td;

    @Setup
    public void setup() {
        data = new double[10000000];
        for (int i = 0; i < data.length; i++) {
            data[i] = gen.nextDouble();
        }
        td = new ArrayDigest(pageSize, compression);

        // First values are very cheap to add, we are more interested in the steady state,
        // when the summary is full. Summaries are expected to contain about 5*compression
        // centroids, hence the 5 factor
        for (int i = 0; i < 5 * compression; ++i) {
            td.add(gen.nextDouble());
        }
    }

    @State(Scope.Thread)
    public static class ThreadState {
        int index = 0;
    }

    @GenerateMicroBenchmark
    public void add(ThreadState state) {
        if (state.index >= data.length) {
            state.index = 0;
        }
        td.add(data[state.index++]);
    }

    public static void main(String[] args) throws RunnerException {
        Options opt = new OptionsBuilder()
                .include(".*" + Benchmark.class.getSimpleName() + ".*")
                .resultFormat(ResultFormatType.CSV)
                .result("results-array-tuning.csv")
                .addProfiler(ProfilerType.HS_GC)
                .addProfiler(ProfilerType.STACK)
                .build();

        new Runner(opt).run();
    }
}
