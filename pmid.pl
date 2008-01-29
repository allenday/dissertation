#!/usr/bin/perl
use strict;
#unlink(q(pmid.bib));
my %in = ();
open(B,'pmid.bib');
while ( my $line = <B> ) {
  my ( $id ) = $line =~ m#PMID_(\d+)#;
  next unless $id;
  $in{ $id } = 1;
}
close(B);
opendir(P,'references');
while ( my $dirent = readdir(P) ) {
  next unless $dirent =~ m#^PMID(\d+)#;
  my $pmid = $1;
  next if $in{ $pmid };
  system(qq(/usr/bin/perl ./pmid2bib.pl $pmid >> pmid.bib;));
}
close(P);
