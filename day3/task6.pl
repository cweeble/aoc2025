#!/usr/bin/perl
use strict;
open (IN, 'input_data') || warn "no input file!";
my $answer;
while (my $line = <IN>) {
    my @highest;
    chomp($line);
    my @highest;
LOOP:
    for my $loop (reverse (0..11)) {
        my @sorted = sort { $b <=> $a } split(//, $line);
        $#sorted = $loop;
        for my $highest (@sorted) {
            next if (!defined $highest);
            my $line_copy = $line;
            if ($line_copy =~ s/.*?$highest(.{$loop,})/$1/) {
                $line = $line_copy;
                push @highest, $highest;
                $highest = undef;
                next LOOP;
            }
        }
    }
    my $result = join('', @highest);
    $answer += $result;
    print "$result : length " . length($result) . $/;
}

printf ("answer: %s $/", $answer);
__DATA__
987654321111111
811111111111119
234234234234278
818181911112111