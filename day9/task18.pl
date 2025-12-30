#!/usr/bin/perl
use strict;
open (IN, 'input_data') || warn "no input file!";
local $|=1;
my $answer;
my @coordinates;
my %boundary;
my ($xMax, $yMax) = (0,0);
my @lines;
my %index;
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
    printf("Processing line %d of %d$/", $y, $yMax) if ($y % 1000 == 0);
    my $line;
    my $count = 0;
    for my $x (0..$xMax+2) {
        my $key = "$x:$y";
        if (exists $boundary{$key}) {
            $line .= "${count}." if ($count);
            $count = 0;
            $line .= $boundary{$key};
        } else {
            $count++;
        }
    }
    $line .= "${count}." if ($count);
    if ($y == $yMax) {
        $line .= 'F';
    }
    if (($line =~ /G/) && ($line !~ /R/)) {
        while ($line =~ /G(\d+)\.G/g) {
            my $num = $1;
            my $replacement = $num > 2 ? $num . 'g' : 'g' x $num;
            $line =~ s/G${num}\.G/G${replacement}G/;
        }
    } 
    elsif (($line =~ /\.G/) || ($line =~ /G\./)) {
        my @threeThirds = ($line =~ /(.*)(RG+R)(.*)/);
        while ($threeThirds[0] =~ /\.G(\d+)\.G/g) {
            my $num = $1;
            my $replacement = $num > 2 ? $num . 'g' : 'g' x $num;
            $threeThirds[0] =~ s/\.G${num}/.${replacement}G/;
        }
        if ($threeThirds[2] =~ /G/) {
            my @split = split(/G/, $threeThirds[2]);
            my $i = $#split;
            while ($i >= 1) {
                $split[$i-1] =~ s/\./g/g;
                $i-=2;
            }
            $threeThirds[2] = join('G', @split);
        }
        $line = join('', @threeThirds);
    }
    $line =~ s/(GGG+)/length($1) . 'G'/e;
    if ($line eq $prevLine) {
        $lineCount++;
        $index{$y} = $#lines+1;
    } else {
        if ($prevLine) {
            $prevLine .= " (x${lineCount})" if $lineCount > 1;
            $prevLine .= sprintf("(#%d-#%d)", $y - $lineCount, $y);
            push (@lines, $prevLine);
        }
        $prevLine = $line;
        $lineCount = 1;
        $index{$y} = $#lines+1;
    }
}
chop $prevLine;
$prevLine .= "(#${yMax})";
push(@lines, $prevLine);
$index{$yMax} = $#lines;

# Calculate max area
my $max = 0;
for my $start (0..$#coordinates) {
    COORDINATE:
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
        printf(
            "%s to %s has area %d$/",
            $x1<$x2 ? join(':', @{$coordinates[$start]}) : join(':', @{$coordinates[$end]}),
            $x1<$x2 ? join(':', @{$coordinates[$end]}) : join(':', @{$coordinates[$start]}),
            $area
        );
        if ($max < $area) {
            # verify there are no dots in the area.
            print "new maximum found, checking for dots$/";
            my ($firstLine, $lastLine) = ($y1 < $y2) ?
                ($index{$y1}, $index{$y2})
            :   ($index{$y2}, $index{$y1})
            ;
            for my $lineNum ($firstLine .. $lastLine) {
                my $encoded = $lines[$lineNum];
                my $encoded2 = $encoded;
                $encoded2 =~ s/\(.*//;
                my $line = '';
                while ($encoded2 =~ /\G(\d*)(\D)/g) {
                    my $num = $1 ? $1 : 1;
                    my $char = $2;
                    $line .= $char x $num;
                }
                my $from = $x1 < $x2 ? $x1 : $x2;
                $line = substr($line, $from, $diff_x);
                if ($line =~ /\./) {
                    printf(
                        "line %d (%s) has a dot in position %d$/",
                        $lineNum,
                        $encoded,
                        index($line, '.') + $from
                    );
                    next COORDINATE;
                }
            }
            print "no dots found, updating max to ${area}$/";
            $max = $area;
        }
    }
}

$answer = $max;
printf ("$/answer = %s $/", $answer);
warn $answer;
__DATA__
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3