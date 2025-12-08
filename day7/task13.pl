#!/usr/bin/perl -I ./
use strict;
use Tachyon;
open (IN, 'input_data') || warn "no input file!";
my $answer;
my @tachyons;
my @map;
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
            push @tachyons, $tachyon;
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
        next if ($tachyon->{stops});
        $iterate = 1;
        $tachyon->moveSouth();
        printf("Tachyon# %i is at [%s], #splits %s, spawning %s, stopped@ %s $/",
            $tach_number,
            join(':', $tachyon->{x}, $tachyon->{y}),
            $tachyon->{num_splits},
            $tachyon->{spawn_child} ? 'yes' : 'no',
            $tachyon->{stops} || 'no'
        );
        if ($tachyon->{spawn_child}) {
            my ($x, $y) = split(':', $tachyon->{spawn_child});
            my $child_tachyon = Tachyon->new($x, $y, \@map, $tachyon->{max_x}, $tachyon->{max_y});
            push @tachyons, $child_tachyon;
            $messages[$y] .= sprintf("%i>%i;", $tach_number, $#tachyons);
            $tachyon->stop_spawning();
        }
    }
}

my $tach_number = -1;
for my $tachyon (@tachyons) {
    $tach_number++;
    $messages[$tachyon->{stops}] .= sprintf("%i!;", $tach_number)
        if defined $tachyon->{stops};
    $answer += $tachyon->{num_splits};
}

for my $y (0 .. $tachyons[0]->{max_y}) {
    printf("%4i ", $y);
    for my $x (0 .. $tachyons[0]->{max_x}) {
        print $map[$x][$y];
        my $loc = $map[$x][$y];
        my $north = $map[$x][$y-1] unless ($y==0);
        if (($loc eq '%') && (defined $north) && ($north eq '|')) {
            $main::alternate_total++;
        }
    }
    print " $messages[$y]" if (defined $messages[$y]);
    print "\n";
}
print $main::alternate_total . " alternate splits $/\n";
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
