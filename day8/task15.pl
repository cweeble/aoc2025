#!/usr/bin/perl -I ./
use strict;
use JB;
my $max_number = 1000;
open (IN, 'input_data') || warn "no input file!";
my @junctions;
my %circuits;
my $answer;
while (<IN>) {
    chomp;
    my ($x, $y, $z) = split(/,/, $_);
    my $junction = JB->new(scalar @junctions, $x, $y, $z);
    push @junctions, $junction;
    my @array = ($junction);
}

my %distances;
my @distances;
my $max_id = $junctions[-1]->{id};
for my $jb (@junctions) {
    my @junctions_copy = @junctions;
    $#junctions_copy = $jb->{id}-1;
    for my $other_jb (@junctions_copy) {
        my $dist_id = join(':', sort { $a <=> $b} ($jb->{id}, $other_jb->{id}));
        my $distance = $jb->calculate_distance($other_jb);
        $distances{$distance} = $dist_id;
        if ($max_number > @distances) {
            push @distances, $distance;
        } else {
            if ($distance < $distances[$#distances]) {
                @distances = sort { $a<=>$b } (@distances, $distance);
                $#distances = $max_number - 1;
            }
        }
    }
}

for my $shortest_paths (@distances) {
    my $dist_id = $distances{$shortest_paths};
    my ($id1, $id2) = split(/:/, $dist_id);
    my $jb1 = $junctions[$id1];
    my $jb2 = $junctions[$id2];
    $jb1->add_to_circuit($jb2);
}

for my $shortest_paths (@distances) {
    my $dist_id = $distances{$shortest_paths};
    my ($id1, $id2) = split(/:/, $dist_id);
    my $jb1 = $junctions[$id1];
    $jb1->finalise_circuit();
}

for (my $i=0; $i<$#junctions; $i++) {
    next unless defined $junctions[$i];
    my @finalised = sort {$a <=> $b} @{ $junctions[$i]->{finalised_circuit} };
    my $keep = shift(@finalised);
    map { $junctions[$_] = undef } @finalised;
}

$answer = 1;
my $count = 3;
for my $jb ( sort { scalar @{$b->{finalised_circuit}} <=> scalar @{$a->{finalised_circuit}} } grep { defined $_ } @junctions) {
#   print scalar @{$jb->{finalised_circuit}} . $/;
    $answer *= scalar @{$jb->{finalised_circuit}};
    last unless --$count;
}
printf ("%s $/", $answer);
__DATA__
162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689