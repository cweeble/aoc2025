#!/usr/bin/perl
use strict;
open (IN, 'input_data') || warn "no input file!";
local $|=1;
my $answer;
my @coordinates;
my %boundary;
my ($xMax, $yMax) = (0,0);
while (<IN>) {
    chomp;
    my ($x, $y) = split(/,/, $_);
    push (@coordinates, [ $x, $y ]);
    $boundary{"$x:$y"}='R';
    $xMax = $x if $x > $xMax;
    $yMax = $y if $y > $yMax;
}
for my $xy (0 .. $#coordinates) {
    my ($x, $y) = ($coordinates[$xy]->[0], $coordinates[$xy]->[1]);
    my ($x1, $y1) = ($coordinates[$xy-1]->[0], $coordinates[$xy-1]->[1]);
    my ($from, $to) = $x1==$x ? 
        sort {$a <=> $b} ($y, $y1) :
        sort {$a <=> $b} ($x, $x1);
    for my $i ($from .. $to) {
        my $key = $x1==$x ? "$x:$i" : "$i:$y";
        $boundary{$key}='G' unless $boundary{$key} eq 'R';
    }
}
my $lineCount = 1;
my $prevLine = '';
for my $y (0..$yMax) {
    my $line;
    my $count = 0;
    for my $x (0..$xMax) {
        my $key = "$x:$y";
        if (exists $boundary{$key}) {
            if ($count == 1) { $line .= '.'; }
            elsif ($count == 2) { $line .= '..'; }
            elsif ($count > 2) { $line .= "${count}."; }
            $count = 0;
            $line .= $boundary{$key};
        } else {
            $count++;
        }
    }
    if ($count == 1) { $line .= '.'; }
    elsif ($count == 2) { $line .= '..'; }
    elsif ($count > 2) { $line .= "${count}."; }
    if ($y == $yMax) {
        $line .= 'F';
    }
    $line =~ s/(GGG+)/length($1)G/e;
    if ($line eq $prevLine) {
        $lineCount++;
    } else {
        if ($prevLine) {
            print $prevLine;
            print " (x${lineCount})" if $lineCount > 1;
            print "\n";
        }
        $prevLine = $line;
        $lineCount = 1;
    }
}
chop $prevLine;
print "$prevLine\n";
die;
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