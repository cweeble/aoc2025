#!/usr/bin/perl
use strict;
open (IN, 'input_data') || warn "no input file!";
my $answer;
while (my $line = <IN>) {
    my @highest;
    chomp($line);
    for my $loop (1..2) {
        my @line = split(//, $line);
        my @sorted = sort { $b <=> $a } @line;
        my $highest = $sorted[0];
        if ($line !~ /$highest./) {
            if ($loop < 2) {
                $highest = $sorted[1];
            }
        }
        push @highest, $highest;
        $line =~ /$highest(.+)$/;
        $line = $1;
    }
    my $result = join('', @highest);
    $answer += $result;
    print "$result $/";
}

printf ("answer: %s $/", $answer);
__DATA__
987654321111111
811111111111119
234234234234278
818181911112111