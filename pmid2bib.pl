#!/usr/bin/perl
use strict;
use Bio::Biblio;
use XML::Twig;
use Template;

die "Usage: $0 <pmid>" unless scalar(@ARGV);

foreach my $arg (@ARGV) {
  my $pmid = $arg;
  $pmid =~ s!^.*?(\d+)!$1!;
  exit unless $pmid;
  my $biblio = Bio::Biblio->new(-access => 'eutils');
  my $twig = XML::Twig->new();
  
  $biblio->find("${pmid}[PMID]");
  my $xml = $biblio->get_next();
  my $dom = $twig->parse($xml);
  my(@lastnames) = $twig->get_xpath('//Author/LastName');
  my(@initials)  = $twig->get_xpath('//Author/Initials');
  my($title)     = $twig->get_xpath('//ArticleTitle');
  my($journal)   = $twig->get_xpath('//MedlineTA');
  my($year)      = $twig->get_xpath('//JournalIssue/PubDate/Year');
  my($volume)    = $twig->get_xpath('//JournalIssue/Volume');
  my($number)    = $twig->get_xpath('//JournalIssue/Issue');
  my($pages)     = $twig->get_xpath('//Pagination/MedlinePgn');
  
  my @authors = ();
  while(my $l = shift @lastnames , my $i = shift @initials){
    push @authors, $l->text().', '.$i->text;
  }
  
  $title   = $title   ? $title->text()   : '';
  $year    = $year    ? $year->text()    : '';
  $journal = $journal ? $journal->text() : '';
  $volume  = $volume  ? $volume->text()  : '';
  $number  = $number  ? $number->text()  : '';
  $pages   = $pages   ? $pages->text()   : '';
  
  print(sprintf(
'
@article{PMID_%d,
  author  = "%s",
  title   = "{%s}",
  year    = "%d",
  journal = "%s",
  volume  = "%s",
  number  = "%s",
  pages   = "%s"
}  
',
    $pmid,
    join(' and ',@authors),
    $title,
    $year,
    $journal,
    $volume,
    $number,
    $pages,
  ));

  print STDERR (sprintf(
'
@article{PMID_%d,
  author  = "%s",
  title   = "{%s}",
  year    = "%d",
  journal = "%s",
  volume  = "%s",
  number  = "%s",
  pages   = "%s"
}  
',
    $pmid,
    join(' and ',@authors),
    $title,
    $year,
    $journal,
    $volume,
    $number,
    $pages,
  ));



}
