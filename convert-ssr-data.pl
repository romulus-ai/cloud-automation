#!/usr/bin/perl

use strict;
use warnings;
use DateTime qw( );
use Encode qw(decode encode);
use File::Basename;

my $file = "$ARGV[0]";
`/Applications/LibreOffice.app/Contents/MacOS/soffice --headless --convert-to csv --infilter=CSV:59,1,76 $file`;

my ($convertedfile,$dir,$ext) = fileparse($file, qr/\.[^.]*/);
open my $info, "$convertedfile.csv" or die "Could not open $convertedfile.csv: $!";

my $dt;

while( my $line = <$info>)  {
  if ($. > 16) {
    if ($line =~ /(\d{1,2})\.(\d{1,2})\.(\d{2,4})/) {
      my $d = $1;
      my $m = $2;
      my $y = $3;
      #print "$y-$m-$d\n";
      $dt = DateTime->new(
         year      => $y,
         month     => $m,
         day       => $d,
         time_zone => 'local',
      );
      # print "$dt\n"
    }
    elsif ( not ($line =~ /^Name;Liegest/) && not ($line =~ /^auf&ab/) ) {
      if ( not ($line =~ /^;+/)) {
        chomp($line);
        #print "#### line: $line ####\n";
        my @buffer = split(/;/,$line);
        my $name = $buffer[0];
        my $trainresults = join (';', @buffer[1..$#buffer]);
        #print "#### buffer1: $name ####\n";
        #print "#### buffer2:$trainresults####\n";
        if (not (defined $trainresults) or (length $trainresults < 1) ) {
          $trainresults = "0;0;0;0;0;0;0;0;0;0;;0;0;0;0;0;0;0;0;0;0;;0;0;0;0;0;0;0;0;0;0";
        }
        my @resultboxes = split(/;/,$trainresults);
        my $counter = 0;
        my $setcounter = 1;
        my @set1;
        my @set2;
        my @set3;
        foreach my $box (@resultboxes) {
          $counter++;
          #print "COUNTER: $counter";
          #print "SETCOUNTER: $setcounter";
          if ( $counter <= 10) {
            if (not (defined $box) or (length $box < 1) ) {
              $box = "0";
            } elsif (index($box, "+") != -1) {
              my @values = split(/\+/,$box);
              $box = 0;
              foreach my $value (@values) {
                $box += $value;
              }
            }
            if ($setcounter == 1) {
              push @set1, $box;
            } elsif ($setcounter == 2) {
              push @set2, $box;
            } elsif ($setcounter == 3) {
              push @set3, $box;
            }
          } elsif ($counter == 11) {
            $counter = 0;
            $setcounter++;
          } else {
            print "something went wrong: counter: $counter, line: $trainresults"
          }
        }

        if ($#set1 < 9) {
          my $limit = 9-($#set1);
          for (1..$limit) {
            push @set1, "0";
          }
        }
        if ($#set2 < 9) {
          my $limit = 9-($#set2);
          for (1..$limit) {
            push @set2, "0";
          }
        }
        if ($#set3 < 9) {
          my $limit = 9-($#set3);
          for (1..$limit) {
            push @set3, "0";
          }
        }

        #print "#### set1: $set1 ####\n";
        #print "#### set2: $set2 ####\n";
        # if (not (defined $set1) or (length $set1 < 1) ){
        #   $set1 = "0;0;0;0;0;0;0;0;0;0"
        # }
        # if (not (defined $set2) or (length $set2 < 1) ) {
        #   $set2 = "0;0;0;0;0;0;0;0;0;0"
        # }
        # if (not (defined $set3) or (length $set3 < 1) ) {
        #   $set3 = "0;0;0;0;0;0;0;0;0;0"
        # }
        my $set1str = join (';', @set1);
        my $set2str = join (';', @set2);
        my $set3str = join (';', @set3);
        print "$dt;$name;1;$set1str\n";
        print "$dt;$name;2;$set2str\n";
        print "$dt;$name;3;$set3str\n";
      }
    }
  }
#    last if $. == 2;
}

close $info;