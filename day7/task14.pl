#!/usr/bin/perl -I ./
use strict;
use Tachyon;
use Storable qw(dclone);
open (IN, 'input_data') || warn "no input file!";
my $monitor = ' ' .join(' ', sort { $a <=> $b } (@ARGV)) . ' ';
my $answer;
my @tachyons;
my @map;
my @map_swapped;
our @locations;
my @history;
my @messages;
my $y = 0;
while (<IN>) {
    chomp;
    my @cols = split(//, $_);
    for my $x (0 .. $#cols) {
        my $char = $cols[$x];
        $map[$x][$y] = $char;
        $map_swapped[$y][$x] = $char;
        if ($char eq 'S') {
            my $tachyon = Tachyon->new($x, $y, \@map, $#cols, undef);
            if ($monitor =~ /^0 /) { $tachyon->enable_monitor(); }
            push @tachyons, $tachyon;
            my @array = (0);
            $locations[$x][$y] = \@array;
            $map_swapped[$y][$x] = '1';
        }
    }
    $y++;
}
$tachyons[0]->set_max_y($y-1);
my ($max_x, $max_y) = ($tachyons[0]->{max_x}, $tachyons[0]->{max_y});
@tachyons = undef;

for (my $y=0; $y <= ${max_y}; $y++) {
    for my $x (0 .. ${max_x}) {
        next unless $y;
        my $prev = $map_swapped[$y-1][$x];
        my $char = $map_swapped[$y][$x];
        $map_swapped[$y][$x] = $prev if (($char ne '^') and ($prev ne '^'));
    }
warn "row: ${y} ";
warn $map_swapped[$y][$_] for (0 .. ${max_x});
    next unless $y;
    for my $x (0 .. ${max_x}) {
        my $char = $map_swapped[$y][$x];
        next unless ($char eq '^');
        my $prev = $map_swapped[$y-1][$x];
        next unless( $prev > 0);
        $map_swapped[$y][$x-1]+= $prev if ($x>0);
        $map_swapped[$y][$x+1]+= $prev if ($x < ${max_x});
    }
    print "row: ${y} ";
    print $map_swapped[$y][$_] for (0 .. ${max_x});
    print $/;
}

for my $x (0 .. ${max_x}) {
    $answer += $map_swapped[$max_y][$x] =~ /^[0-9]+$/ ? $map_swapped[$max_y][$x] : 0;
}

printf ("%s $/", $answer);

__DATA__
.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............
