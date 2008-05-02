# DEFINE center
# DEFINE directory
# DEFINE gene
# DEFINE prefix

source('/home/allenday/cvsroot/celsius/dump/lib/R/Celsius/IO/exe.R');
conn.exe = Celsius.exe('/home/allenday/cvsroot/celsius/dump/data2/HG-U133_Plus_2.rma_trim2');
platform.names = scan('/home/allenday/cvsroot/celsius/dump/data2/HG-U133_Plus_2.rma_trim2.exe.col', what='character');
platform.summary = read.table('/home/allenday/cvsroot/celsius/dump/data2/HG-U133_Plus_2.rma_trim2.exe.summary');

cart.gene = read.table(paste('./cart/',directory,'/',prefix,'.gene.txt',sep=''));
cart.region = read.table(paste('./cart/',directory,'/',prefix,'.region.txt',sep=''),header=TRUE);

cart.colcount   = dim(cart.gene)[1];
j = ((1:cart.colcount)[ cart.region[,4] == cart.gene[cart.gene[,1]==gene,2] ])[1];

cart = read.csv(paste('./cart/',directory,'/cart.xls',sep=''),sep="\t");

platform.mean = platform.summary[,5]/10000;
platform.sd = platform.summary[,7]/10000;
samplerep = 1;
cart.samplesize = cart.colcount;
cart.sample = sample((1:cart.colcount)+2, cart.samplesize);

cart.mean = mean(as.numeric(t(cart[2:(dim(cart)[1]),3:(dim(cart)[2])])))
cart.sd   = sd(  as.numeric(t(cart[2:(dim(cart)[1]),3:(dim(cart)[2])])))

  this.probeset = as.vector(cart.region[j,4]);
  this.symbol   = as.vector(cart.gene[cart.gene[,2]==this.probeset,1])
  #plot each gene symbol only once
    print(paste(j,this.probeset,this.symbol,sep='*'))
    p1 = read.table(paste('./cart/',directory,'/region/',this.probeset,'.dat',sep=''),header=TRUE);
    if ( sum(p1[,1]!=0) == 0 ) { next }
    p1.rowcount = dim(p1)[1];

    d.pos = p1[,2]/1000000;
    if ( center ) {
      d.pos = (p1[,2] - ((cart.region[j,3]+cart.region[j,2])/2))/1000000;
    }

    #do not compare to probesets from the same gene symbol.
    d.sig = as.numeric(as.vector(t(cart[match(as.vector(p1[,4]),as.vector(cart[,2])),
#      ((1:cart.colcount)+2)[! as.vector(t(cart[1,(1:cart.colcount)+2])) == this.probeset] ### same probeset
      ((1:cart.colcount)+2)[! cart[ match( as.vector(t(cart[1,(1:cart.colcount)+2])), cart[1:54676,2] ), 1 ] == this.symbol] ### same gene symbol
    ])));

    d.sig = matrix(d.sig,nrow=p1.rowcount,byrow=TRUE);
    d.sig.summary = apply(d.sig,1,mean);
    d = cbind(
      d.pos,
      as.vector(cart[match(as.vector(p1[,4]),as.vector(cart[,2])),1]),
      d.sig.summary,
      (d.sig.summary - cart.mean) / cart.sd,
      (d.sig.summary - platform.mean[ match(p1[,4], platform.names) ] ) / platform.sd[ match(p1[,4], platform.names) ]
    );

    ycol=3;
    ylab='r';
    ymin=min(as.numeric(d[,ycol]));
    ymax=max(as.numeric(d[,ycol]));

    xmin=-3;
    xmax= 3;
    if ( !center ) {
      xmin=min(d.pos);
      xmax=max(d.pos);
    }

    plot(d[ !match(d[,2], cart.gene[,1], nomatch=FALSE) & d[,2]!='---', 1 ],d[ !match(d[,2], cart.gene[,1], nomatch=FALSE) & d[,2]!='---', ycol ],pch=1,xlim=c(xmin,xmax),ylim=c(ymin,ymax),xlab='genomic offset, megabases', ylab=ylab, main=paste(as.vector(t(cart.gene[cart.gene[,2]==this.probeset,]))));
    points(d[ match(d[,2], cart.gene[,1], nomatch=FALSE) & d[,2] != '---' & d[,2] != this.symbol, 1 ],d[ match(d[,2], cart.gene[,1], nomatch=FALSE) & d[,2] != '---' & d[,2] != this.symbol, ycol ],pch=2);
    points(d[ d[,2] == '---', 1 ],d[ d[,2] == '---', ycol ],pch=4);
    points(d[ d[,2] == this.symbol | d[,2] == this.probeset | d[,1]==0, 1 ],d[ d[,2] == this.symbol | d[,2] == this.probeset | d[,1]==0, ycol ],pch=16);

#    ycol=5;
#    ylab='s.d. of r';
#    ymin=min(as.numeric(d[,ycol]));
#    ymax=max(as.numeric(d[,ycol]));
#
#    plot(d[ !match(d[,2], cart.gene[,1], nomatch=FALSE) & d[,2]!='---', 1 ],d[ !match(d[,2], cart.gene[,1], nomatch=FALSE) & d[,2]!='---', ycol ],pch=1,xlim=c(-3,3),ylim=c(ymin,ymax),xlab='genomic offset, megabases', ylab=ylab, main=paste(as.vector(t(cart.gene[cart.gene[,2]==this.probeset,]))));
#    points(d[ match(d[,2], cart.gene[,1], nomatch=FALSE) & d[,2] != '---' & d[,2] != this.symbol, 1 ],d[ match(d[,2], cart.gene[,1], nomatch=FALSE) & d[,2] != '---' & d[,2] != this.symbol, ycol ],pch=2);
#    points(d[ d[,2] == '---', 1 ],d[ d[,2] == '---', ycol ],pch=4);
#    points(d[ d[,2] == this.symbol | d[,2] == this.probeset | d[,1]==0, 1 ],d[ d[,2] == this.symbol | d[,2] == this.probeset | d[,1]==0, ycol ],pch=16);

