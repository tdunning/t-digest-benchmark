# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

pdf("results.pdf", width=5, height=4, pointsize=11)
xx = read.csv("results.csv")
plot(Mean ~ Param..compression, xx[xx$Param..method == "array",], type='b',
    ylim=c(0,900), xlab="Compression Factor", ylab="Time (ns)", pch=21)
lines(Mean ~ Param..compression, xx[xx$Param..method == "tree",], type='b', pch=24)
lines(Mean ~ Param..compression, xx[xx$Param..method == "merge",], type='b', pch=24)
legend(20, 750, pch=c(21,24), legend=c("ArrayDigest", "AVLTreeDigest", "MergingDigest"))
dev.off()

pdf("results-array-tuning.pdf", width=5, height=4, pointsize=11)
yy = read.delim("results-array-tuning.csv")
plot(x=c(),y=c(), xlim=c(0,72), ylim=c(0,1000), ylab="Time (ns)", xlab="Pagesize", xaxt='n')

axis(side=1, at=as.integer(names(table(yy$pageSize))))
i = 1
for (compression in c(20,50,100,200,500)) {
    lines(Mean ~ pageSize, yy[yy$compression == compression,], type='b', pch = 20+i)
    i = i+1
}
legend(40,1000, pch=c(21:25), legend=paste("compression =", c(20,50,100,200,500)))
dev.off()

pdf("results-merge-tuning.pdf", width=5, height=5, pointsize=11)
data = read.csv("merge-results.csv")

plot(c(), ylim=c(30,6000), xlim=c(1,100), log='xy', ylab="Time (ns)", xlab="Expansion factor",
     main="Per sample time as affected by input buffer expansion")
char = 21
compressions = row.names(table(data$Param..compression))
for (compression in compressions) {
    lines(Mean ~ Param..factor, data[data$Param..compression == compression,], type='b', pch=char)
    char = char + 1
}

legend(x=30, y=5400, legend=compressions, pch=20 + (1:length(compressions)), title="Compression")
dev.off()

pdf("results-array-tuning.pdf", width=5, height=4, pointsize=11)
yy = read.delim("results-array-tuning.csv")
plot(x=c(),y=c(), xlim=c(0,72), ylim=c(0,1000), ylab="Time (ns)", xlab="Pagesize", xaxt='n')

axis(side=1, at=as.integer(names(table(yy$pageSize))))
i = 1
for (compression in c(20,50,100,200,500)) {
    lines(Mean ~ pageSize, yy[yy$compression == compression,], type='b', pch = 20+i)
    i = i+1
}
legend(40,1000, pch=c(21:25), legend=paste("compression =", c(20,50,100,200,500)))
dev.off()
