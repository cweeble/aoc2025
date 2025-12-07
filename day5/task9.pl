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
my %item;
my %outOfRange;
my @isFresh;
my $i=0;
while (<IN>) {
    chomp;
    print ++$i . $/;
    next unless (/\d/);
    if (/^(\d+)-(\d+)$/) {
        my ($min, $max) = (int($1), int($2));
        if (exists $fresh{$min}) {
            next if ($fresh{$min} > $max);
        }
        $fresh{$min} = $max;
    }
    else {
        my $inp = int($_);
        my $thou = thou($inp);
        print "Searching for $thou length " . length($inp) . $/ ;
        print "  keys in range:" . scalar(keys %fresh) . $/;

        my %frCopy = %fresh;
        my @del = grep { $_ > $inp } keys %frCopy;
        delete @frCopy{@del};
        @del = grep { $frCopy{$_} < $inp } keys %frCopy;
        delete @frCopy{@del};

        $item{$inp}++;
#       $outOfRange{$inp}++;
        my $is_fresh = 0;
        for my $min (keys %fresh) {
            my $max = $fresh{$min};
            if ($inp >= $min && $inp <= $max) {
                $is_fresh = 1;
                last;
            }
        }
        if ($is_fresh) {
            $answer++;
            push @isFresh, $inp;
        } else {
            $outOfRange{$inp}++;
        }
    }
}

print $_. $/ for (@isFresh);
#print scalar keys( %outOfRange ) . " out of range $/";
$DB::single = 1;


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