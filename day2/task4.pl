#!/usr/bin/perl
use strict;
open (IN, 'input_data') || warn "no input file!";
my $answer;
my $line = <IN>;
chomp $line;
my @ranges = split(/,/, $line);
my @invalid_ids;
RANGE: foreach my $range (@ranges) {
    push (@invalid_ids, "$/Start of range: $range:");
    my ($start, $end) = split(/-/, $range);
    SEQ: foreach my $num ($start .. $end) {
        next SEQ unless ($num =~ /^(\d+)\1{1,}$/);

        push (@invalid_ids, $num);
        $answer += $num;
    }
}
printf ("%s $/", $answer);
#print join(',', @invalid_ids);
__DATA__
11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124