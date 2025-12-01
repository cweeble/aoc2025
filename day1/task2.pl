#!/usr/bin/perl
use strict;
open (IN, 'input_data') or die "Cannot open input_data: $!";
my $position = 50;
my %visited;
$visited{$position}++;
my ($oldZero, $zeros) = (0, 0);
my $old_position;
while (my $line = <IN>) {
    chomp $line;
    $old_position = $position;
    $oldZero = $zeros;
    my ($direction, $steps) = $line =~ /([LR])(\d+)/;
    my $movement = ($direction eq 'L') ? -$steps : $steps;
    $position += $movement;
    printf ("%s, New psuedo Position: %d (from %d)", $line, $position, $old_position);
    my $passes;
    if (($position >=100) or ($position <=0) ) {
        $passes = abs(int($position/100));
        $passes++ if ($position<=0 and $old_position); # 0 to -99 counts as passing zero once

        $position+=100 if ($position<0);

        printf(" (moved past or to zero %d times)", $passes);
    }
    $zeros += $passes;
    $position = $position % 100;
    printf(", after correction: %d, zeros=%d $/", $position, $zeros);
}
print "Zero encountered: " . $zeros . " times" . $/;

__DATA__
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82