source('/home/allenday/cvsroot/celsius/dump/lib/R/Celsius/IO/exe.R');
conn.exe = Celsius.exe('/home/allenday/cvsroot/celsius/dump/data2/HG-U133_Plus_2.rma_trim2');
cart = read.csv('./cart.xls',sep="\t");#http://genome.ucla.edu/u/~allenday/tmp/GeneCorrOutput/Corr_20080416_150528.xls',sep="\t");
cart.region = read.table('./cart.region.txt',header=TRUE);
cart.gene = read.table('./cart.gene.txt');
cart.colcount   = dim(cart.gene)[1];
samplerep = 1;
cart.samplesize = cart.colcount;
cart.sample = sample((1:cart.colcount)+2, cart.samplesize);
for ( j in 1:cart.colcount ){
  freq.bins = rep(NA,60*100);
  dim(freq.bins) = c(60,100);
  chi.bins = rep(NA,60);

  print(j);
  p1 = read.table(paste('./region/',cart.region[j,4],'.dat',sep=''));
  p1.rowcount = dim(p1)[1];

  k = seq(-1,1,by=0.02);
  p = seq(-3,3,by=0.1);

  d.pos = (p1[,2] - ((cart.region[j,3]+cart.region[j,2])/2))/1000000;

  #XXX need to do leave one out from
  d.sig = as.numeric(as.vector(t(cart[match(as.vector(p1[,4]),as.vector(cart[,2])),((1:cart.colcount)+2)[! as.vector(t(cart[1,(1:cart.colcount)+2])) == cart.region[j,4]]])));
  d.sig = matrix(d.sig,nrow=p1.rowcount,byrow=TRUE);
  d.sig.summary = apply(d.sig,1,mean);
  d = cbind( d.pos, d.sig.summary );

  #foreach region partition
  for ( pp in 1:(length(p)-1) ) {
    chi.pos = d.pos >= p[pp] & d.pos < p[pp+1];
    if ( sum( chi.pos ) > 0 ) {
      chi.x = hist( d.sig.summary[ chi.pos ], breaks=k, plot=FALSE )$counts;
      chi.d = get(conn.exe, p1[ chi.pos , 4 ]);
      chi.p = hist(chi.d, breaks=k, plot=FALSE)$counts;

      zzz = cbind( d.sig.summary[chi.pos], apply(matrix(p1[chi.pos,4],nrow=1), 2, function(x){mean(as.vector(get(conn.exe,x)))}), apply(matrix(p1[chi.pos,4],nrow=1), 2, function(x){sd(as.vector(get(conn.exe,x)))}) )
      chi.bins[pp] = max((zzz[,1] - zzz[,2]) / zzz[,3])
      print(paste('  ',pp,' ok',sep=''));
    }

    #foreach correlation partition
    for ( kk in 1:(length(k)-1) ) {
      ss = sum( d[,1] >= p[pp] & d[,1] < p[pp+1] & d[,2] >= k[kk] & d[,2] < k[kk+1])
      if ( ss > 0 ) {
        freq.bins[pp,kk] = ss;
      }
    }
  }
  image(freq.bins[,25:100],axes=F,col=gray(1:10/10),main=paste(cart.gene[j,1],' ',cart.gene[j,2],' rep=',samplerep,' size=',cart.samplesize,sep=''));
  axis(1, at=seq(0,1,by=1/6),labels=seq(-3,3,by=1));
  axis(2, at=seq(0,1,by=1/6), labels=seq(-0.50,1.00,by=0.25));
  axis(4, at=seq(0,1,by=1/30), labels=seq(-10,20,by=1));
  #chi.points = cbind(0:59/59, (chi.bins)/25);
  chi.points = cbind(0:59/59, 1/3 + (chi.bins)/30);
  #chi.points = cbind(0:59/59, -log10(chi.bins)/15);
  lines( chi.points[!is.na(chi.bins),], col='red' );
}

for ( j in 1:cart.colcount ){
print(j);
p1 = read.table(paste('./region/',cart.region[j,4],'.dat',sep=''),header=TRUE);
if ( sum(p1[,1]!=0) == 0 ) {
  next;
}
p1.rowcount = dim(p1)[1];
d.pos = (p1[,2] - ((cart.region[j,3]+cart.region[j,2])/2))/1000000;
d.sig = as.numeric(as.vector(t(cart[match(as.vector(p1[,4]),as.vector(cart[,2])),((1:cart.colcount)+2)[! as.vector(t(cart[1,(1:cart.colcount)+2])) == cart.region[j,4]]])));
d.sig = matrix(d.sig,nrow=p1.rowcount,byrow=TRUE);
d.sig.summary = apply(d.sig,1,mean);
d = cbind( d.pos, d.sig.summary, apply(matrix(p1[,4],nrow=1), 2, function(x){mean(as.vector(get(conn.exe,x)))}), apply(matrix(p1[,4],nrow=1), 2, function(x){sd(as.vector(get(conn.exe,x)))}), as.vector(cart[match(as.vector(p1[,4]),as.vector(cart[,2])),1]) );
postscript(paste('ps/',as.vector(t(cart.gene[j,2])),'.ps',sep=''),width=20,height=10);
plot( d[,1] , d[,2] , pch=1, xlim=c(-3,3), xlab='genomic offset, megabases', ylab='correlation coefficient', main=paste(as.vector(t(cart.gene[j,]))) );
points( d[ d[,5] == d[ d[,1]==0, 5 ], 1:2  ], pch=16 );
#points( d[d[,1]==0,1], d[d[,1]==0,2], pch=16, col='red' );
dev.off();
#plot( d[,1] , (d[,2]-d[,3])/d[,4] , xlim=c(-3,3), pch=16 )
}
