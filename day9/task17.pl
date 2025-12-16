#!/usr/bin/perl
use strict;
open (IN, 'input_data') || warn "no input file!";
my $answer;
my @coordinates;
while (<IN>) {
    chomp;
    my ($x, $y) = split(/,/, $_);
    push (@coordinates, [ $x, $y ]);
}
my $max = 0;
for my $start (0..$#coordinates) {
    for my $end ($start+1..$#coordinates) {
        my ($x1, $y1) = ($coordinates[$start]->[0], $coordinates[$start]->[1]);
        my ($x2, $y2) = ($coordinates[$end]->[0], $coordinates[$end]->[1]);
        my $diff_x = $x2 - $x1;
        my $diff_y = $y2 - $y1;
        $diff_x *= -1 if $diff_x < 0;
        $diff_y *= -1 if $diff_y < 0;
        $diff_x++;
        $diff_y++;
        my $area = $diff_x * $diff_y;
        $max = $area if $area > $max;
    }
}

$answer = $max;
printf ("%s $/", $answer);
__DATA__
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3