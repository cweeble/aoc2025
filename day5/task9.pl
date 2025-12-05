#!/usr/bin/perl
use strict;
sub thou {
    my $line = shift;
    return $line unless ($line =~ /\b\d{4,}\b/g);
	my ($pre, $num, $post) = ($`, $&, $');
	my @num = reverse( split(//, $num));
	my $i = 0;
	map {
		$i++;
		$i = 0 if ($i == 3);
		substr($_,0,0) = ',' if (!$i);
	} @num;
	$num = join('', reverse @num);
	$num =~ s/^,//;
	$line = join('', $pre, $num, $post);
	return $line;
}
open (IN, 'input_data') || warn "no input file!";
my $answer;
my %fresh;
my @keys;
my @noMatch;
while (<IN>) {
    chomp;
    next unless (/\d/);
    if (/^(\d+)-(\d+)$/) {
        $fresh{$1} = $2;
        push @keys, $1;
    }
    else {
        my $thou = thou($_);
        print "Searching for $thou $/";
        for my $min (@keys, "last") {
            if ($min eq "last") {
                print "  No match found for $thou %/";
                push @noMatch, $_;
                last;
            }
            my ($thou_min, $thou_max) = (thou($min), thou($fresh{$min}));
            print "  Comparing $thou to range ${thou_min} to ${thou_max} $/";
            print "      too low$/" and next if ($min > $_);
            print "      too high$/" and next if ($fresh{$min} < $_);
            print "      just right!";
            $answer++;
            print "      Count is now $answer $/";
            last;
        }
    }
}
$DB::single = 1;
print join($/, @noMatch);

printf ("%s $/", $answer);
__DATA__
3-5
10-14
16-20
12-18

1
5
8
11
17
32