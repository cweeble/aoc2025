#!/usr/bin/perl
use strict;
open (IN, 'input_data') || warn "no input file!";
my $answer;
my @rows;
while (<IN>) {
    chomp;
    push @rows, $_;
}
my $operators = pop @rows;
my @operators;

while ($operators =~ /([+*])/g) {
    push @operators, $1;
}

my @numbers;
for (@rows) {
    my @cols = split(//, $_);
    for my $i (0 .. $#cols) {
        $numbers[$i] .= $cols[$i] if ($cols[$i] ne ' ');
    }
}

@numbers = reverse(@numbers);
@operators = reverse(@operators);

my @totals = map {
    $_ eq '+' ? 0 :
    $_ eq '*' ? 1 :
    die "Unknown operator $_"
} @operators;

my $i = -1;
for my $num (undef, @numbers) {
    if (!defined $num) {
        $i++;
        next;
    }
    if ($operators[$i] eq '+') {
        $totals[$i] += $num;
    } else {
        $totals[$i] *= $num;
    }
}

map { $answer += $_ } @totals;

printf ("%s $/", $answer);
__DATA__
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  