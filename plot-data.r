pdf("results.pdf", width=5, height=4, pointsize=11)
xx = read.csv("/Users/tdunning/Apache/t-digest-benchmark/results.csv")
plot(Mean ~ Param..compression, xx[xx$Param..method == "array",], type='b',
    ylim=c(0,800), xlab="Compression Factor", ylab="Time (ns)")
lines(Mean ~ Param..compression, xx[xx$Param..method == "tree",], type='b')
dev.off()