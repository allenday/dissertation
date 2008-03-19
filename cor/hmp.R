z = read.table('hmp.txt',header=TRUE)
postscript('hmp.ps');
barplot(t(z[,2:3])+1, names.arg=z[,1],beside=TRUE,col=c('light grey','black'), xlab='probesets/ortholog',ylab='frequency')
legend(30,6000,colnames(z[2:3]),fill=c('light grey','black'))
dev.off();
