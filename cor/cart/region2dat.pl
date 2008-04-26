#!/usr/bin/perl
use strict;
use LWP::Simple qw(get);

while ( my $line = <> ) {
  chomp $line;
  next unless $line =~ m/^chr/;
warn $line;
  my ( $chr, $min, $max, $probeset ) = split /\t/, $line;
  my $res = get( "http://genome.ucsc.edu/cgi-bin/hgTables?clade=vertebrate&org=Human&db=hg18&hgta_group=regulation&hgta_track=affyU133Plus2&hgta_table=affyU133Plus2&hgta_regionType=range&position=$chr:$min-$max&hgta_outputType=primaryTable&boolshad.sendToGalaxy=1&hgta_outFileName=&hgta_compressType=none&hgta_doTopSubmit=get+outputls" );
  open( R, ">region/$probeset.dat");
  foreach my $rr ( split /\n/, $res ) {
    my @F = split /\t/, $rr;
    next unless $F[14] =~ m/chr/;
    my $midpoint=int($F[16]+(($F[17]-$F[16])/2));
    print R "$F[14]\t$midpoint\t$midpoint\t$F[10]\n";
  }
  close( R );
}
