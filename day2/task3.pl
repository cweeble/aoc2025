#!/usr/bin/perl
use strict;
open (IN, 'input_data') || warn "no input file!";
my $answer;
my $line = <IN>;
chomp $line;
my @ranges = split(/,/, $line);
my @invalid_ids;
RANGE: foreach my $range (@ranges) {
    my ($start, $end) = split(/-/, $range);
    SEQ: foreach my $num ($start .. $end) {
        my $length = length($num);
        my $halfway = $length / 2;
        next SEQ if ($halfway != int($halfway));

        my ($num1, $num2) = (substr($num, 0, $halfway), substr($num, $halfway));
        next SEQ if ($num1 != $num2);
        push (@invalid_ids, $num);
        $answer += $num;
    }
}
printf ("%s $/", $answer);
__DATA__
11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124