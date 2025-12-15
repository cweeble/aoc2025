#!/usr/bin/perl -I ./
use strict;
use Tachyon;
use Storable qw(dclone);
open (IN, 'input_data') || warn "no input file!";
my $monitor = ' ' .join(' ', sort { $a <=> $b } (@ARGV)) . ' ';
my $answer;
my @tachyons;
my @map;
my @map_copy;
our @locations;
my @history;
my @messages;
my $y = 0;
while (<DATA>) {
    chomp;
    my @cols = split(//, $_);
    for my $x (0 .. $#cols) {
        my $char = $cols[$x];
        $map[$x][$y] = $char;
        $map_copy[$x][$y] = $char;
        if ($char eq 'S') {
            my $tachyon = Tachyon->new($x, $y, \@map, $#cols, undef);
            if ($monitor =~ /^0 /) { $tachyon->enable_monitor(); }
            push @tachyons, $tachyon;
            my @array = (0);
            $locations[$x][$y] = \@array;
        }
    }
    $y++;
}
$tachyons[0]->set_max_y($y-1);
my $iterate = 1;
while ($iterate) {
    $iterate = 0;
    my $tach_number = -1;
    for my $tachyon (@tachyons) {
        $tach_number++;
        if ($monitor =~ s/ $tach_number / /) {
            $tachyons[$tach_number]->enable_monitor();
        }
        if ($monitor =~ /all/i) {
            $tachyons[$tach_number]->enable_monitor();
        }
        next if ($tachyon->{y} >= $tachyon->{max_y});
        $iterate = 1;
        $tachyon->moveSouth();
        my $visited = $tachyon->log_position(\@locations);
        push @{$history[$tachyon->{x}][$tachyon->{y}]}, $tach_number;
        printf("Tachyon# %i is at [%s], #splits %s, spawning %s, stopped@ %s visited %s$/",
            $tach_number,
            join(':', $tachyon->{x}, $tachyon->{y}),
            $tachyon->{num_splits},
            $tachyon->{spawn_child} ? 'yes' : 'no',
            $tachyon->{stops} || 'no',
            $visited ? 'yes' : 'no'
        ) if ($tachyon->{monitor});
        if ($tachyon->{spawn_child}) {
            my $map_tachyon_ref = dclone(\@map_copy);
            my ($x, $y) = split(':', $tachyon->{spawn_child});
            my $child_tachyon = Tachyon->new($x, $y, $map_tachyon_ref, $tachyon->{max_x}, $tachyon->{max_y});
            unshift @{$child_tachyon->{history}}, join(':', "F{$tach_number}", $x-1, $y);
            push @tachyons, $child_tachyon;
            $messages[$y] .= sprintf("%i>%i;", $tach_number, $#tachyons);
            $tachyon->stop_spawning();
            warn scalar @tachyons;
        }
        my @array;
        if (ref $locations[$tachyon->{x}][$tachyon->{y}]) {
            @array = @{$locations[$tachyon->{x}][$tachyon->{y}]};
        }
        push (@array, $tach_number);
        $locations[$tachyon->{x}][$tachyon->{y}] = \@array;
    }
}

$answer = scalar @tachyons;

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
