#!/usr/bin/perl -I ./
use strict;
use Tachyon;
open (IN, 'input_data') || warn "no input file!";
my $monitor = ' ' .join(' ', sort { $a <=> $b } (@ARGV)) . ' ';
my $answer;
my @tachyons;
my @map;
my @locations;
my @messages;
my $y = 0;
while (<IN>) {
    chomp;
    my @cols = split(//, $_);
    for my $x (0 .. $#cols) {
        my $char = $cols[$x];
        $map[$x][$y] = $char;
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
        next if ($tachyon->{stops});
        $iterate = 1;
        $tachyon->moveSouth();
        my $visited = $tachyon->log_position(\@locations);
        printf("Tachyon# %i is at [%s], #splits %s, spawning %s, stopped@ %s visited %s$/",
            $tach_number,
            join(':', $tachyon->{x}, $tachyon->{y}),
            $tachyon->{num_splits},
            $tachyon->{spawn_child} ? 'yes' : 'no',
            $tachyon->{stops} || 'no',
            $visited ? 'yes' : 'no'
        ) if ($tachyon->{monitor});
        $visited && !$tachyon->{stops} && die $tach_number . " continues" . join(' ', @{$tachyon->{history}}) . $/;
        if ($tachyon->{spawn_child}) {
            my ($x, $y) = split(':', $tachyon->{spawn_child});
            my $child_tachyon = Tachyon->new($x, $y, \@map, $tachyon->{max_x}, $tachyon->{max_y});
            push @tachyons, $child_tachyon;
            $messages[$y] .= sprintf("%i>%i;", $tach_number, $#tachyons);
            $tachyon->stop_spawning();
        }
        my @array;
        if (ref $locations[$tachyon->{x}][$tachyon->{y}]) {
            @array = @{$locations[$tachyon->{x}][$tachyon->{y}]};
        }
        push (@array, $tach_number);
        $locations[$tachyon->{x}][$tachyon->{y}] = \@array;
    }
}

my $tach_number = -1;
for my $tachyon (@tachyons) {
    $tach_number++;
    $messages[$tachyon->{stops}] .= sprintf("%i!;", $tach_number)
        if defined $tachyon->{stops};
    $answer += $tachyon->{num_splits};
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
