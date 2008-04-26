#!/usr/bin/perl
use strict;
use File::Temp qw(tempfile);

my $in = 0;
my $lang = undef;
my $script = '';

while ( my $line = <> ) {
  chomp $line;
  next unless $line =~ m#^%#;
  if ( !$in && $line =~ m#^%\s*<execute\s+lang="([^"]+?)"\s*># ) {
    $in = 1;
    $lang = $1;
  }
  elsif ( $in && $line =~ m#^%\s*</execute\s*># ) {
    $in = 0;
    run_it( $lang, $script );
    $script = '';
    $lang = undef;
  }
  elsif ( $in ) {
    $line =~ s#^%\s*##;
    $script .= cleanup( $lang, $line ) ."\n";
  }
}

sub cleanup {
  my ( $lang, $line ) = @_;
  if ( $lang eq 'R' ) {
    $line .= ';' if $line =~ m#\S# && $line !~ m#[{};]\s*$#;
  }
  return $line;
}

sub run_it {
  my ( $lang, $script ) = @_;

  my ($fh, $filename) = tempfile( DIR => '/tmp', UNLINK => 0 );
  close( $fh );
  open( F, ">$filename" );
  print F $script;
  close( F );

warn $filename;
#warn "*****\n$script\n*****";

  if ( $lang eq 'R' ) {
    system(qq(cat $filename | R --vanilla --no-save));
  }
  elsif ( $lang eq 'bash' ) {
    system(qq(cat $filename | bash));
  }
  elsif ( $lang eq 'perl' ) {
    die("no perl support yet");
  }
}
