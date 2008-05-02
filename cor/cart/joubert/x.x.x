
45.212998 --- 0.21665
47.027623 C11orf49 0.22105
47.653259 AGBL2 0.31315
60.231745 MS4A8B 0.24315
61.034843 --- 0.23145
61.945193 SCGB1A1 0.2355



 ycol=3;
 ylab='r';
 ymin=min(as.numeric(d[,ycol]));
 ymax=max(as.numeric(d[,ycol]));
 
 plot(
   d[ !match(d[,2], cart.gene[,1], nomatch=FALSE) & d[,2]!='---', 1 ] ,
   d[ !match(d[,2], cart.gene[,1], nomatch=FALSE) & d[,2]!='---', ycol ] ,
   d[ match(d[,2], cart.gene[,1], nomatch=FALSE) & d[,2] != '---' & d[,2] != this.symbol, 1 ],
   d[ match(d[,2], cart.gene[,1], nomatch=FALSE) & d[,2] != '---' & d[,2] != this.symbol, ycol ],
   pch=2
   pch=1,
   xlim=c(-11,11),
   ylim=c(ymin,ymax),
   xlab='genomic offset, megabases', ylab=ylab, main=paste(as.vector(t(cart.gene[cart.gene[,2]==this.probeset,])))
 );

 abline(v=(45465651/1000000),col='red')
 abline(v=(45666307/1000000),col='red')
 abline(v=(55890635/1000000),col='orange')
 abline(v=(56091023/1000000),col='orange')
 abline(v=(59656135/1000000),col='blue')
   
 abline(v=(59856421/1000000),col='blue')
  
 abline(v=(46023436/1000000),col='cyan')
 abline(v=(46223802/1000000),col='cyan')

