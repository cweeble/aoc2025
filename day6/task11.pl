#!/usr/bin/perl
use strict;
open (IN, 'input_data') || warn "no input file!";
my $answer;
my @rows;
while (<IN>) {
    chomp;
    s/^\s*//;
    push @rows, [ split /\s+/, $_ ];
}
my @operators = @{ pop @rows };

my @totals = map {
    $_ eq '+' ? 0 :
    $_ eq '*' ? 1 :
    die "Unknown operator $_"
} @operators;

for my $row_ref (@rows) {
    my @values = @{ $row_ref };
    for my $i (0 .. $#totals) {
        if ($operators[$i] eq '+') {
            $totals[$i] += $values[$i];
        }
        elsif ($operators[$i] eq '*') {
            $totals[$i] *= $values[$i];
        }
    }
}

map { $answer += $_ } @totals;

printf ("%s $/", $answer);
__DATA__
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  