#!/usr/bin/perl
use strict;
open (IN, 'input_data') or die "Cannot open input_data: $!";
my $position = 50;
my %visited;
$visited{$position}++;
while (my $line = <IN>) {
    chomp $line;
    my ($direction, $steps) = $line =~ /([LR])(\d+)/;
    my $movement = ($direction eq 'L') ? -$steps : $steps;
    $position += $movement;
    printf ("Line: %s, New Position: %d", $line, $position);
    if ($position < 0) {
        $position += 100;
    } elsif ($position > 99) {
        $position -= 100;
    }
    $position %= 100;
    $visited{$position}++;
    printf(", after correction: %d, visited: %d %s $/", $position, $visited{$position}, $position ? '' : '**ZERO**');
}
print "Zero encountered: " . $visited{0} . " times" . $/;

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