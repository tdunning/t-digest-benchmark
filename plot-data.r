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
    ylim=c(0,800), xlab="Compression Factor", ylab="Time (ns)", pch=21)
lines(Mean ~ Param..compression, xx[xx$Param..method == "tree",], type='b', pch=24)
legend(20, 750, pch=c(21,24), legend=c("ArrayDigest", "AVLTreeDigest"))
dev.off()
