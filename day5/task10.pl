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
    next unless (/\d/);
    if (/^(\d+)-(\d+)$/) {
        my ($min, $max) = (int($1), int($2));
        if (exists $fresh{$min}) {
            next if ($fresh{$min} > $max);
        }
        $fresh{$min} = $max;
    }
    else {
        last;
    }
}
my $iterate = 1;
while ($iterate) {
    $iterate = 0;
    FRESH: for my $min (keys %fresh) {
        my %newhash = %fresh;
        delete $newhash{$min};
        my $max = $fresh{$min};
        NEWHASH: for my $newHash_min (keys %newhash) {
            my $newHash_max = $newhash{$newHash_min};
            if (($newHash_min < $min) && $newHash_max >= $min) { # start of newhash covers fresh range.
                if ($newHash_max >= $max) { # whole of this newhash covers the fresh range - delete the fresh range
                    delete $fresh{$min};
                    $iterate = 1;
                    next FRESH;
                }
                # Earlier newhash min, bigger fresh max. Extend the newhash range to cover the fresh range
                # and delete the fresh range.
                $fresh{$newHash_min} = $max;
                delete $fresh{$min};
                $iterate = 1;
                next FRESH;
            }
            if (($newHash_min > $min) && ($newHash_max <= $max)) { # whole of newhash is inside fresh range - delete newhash
                delete $fresh{$newHash_min};
                next NEWHASH;
            }
            if (( $newHash_min > $min) && ($newHash_min <= $max) && ( $newHash_max > $max) ) { # newhash extends fresh range
                $fresh{$min} = $newHash_max;
                delete $fresh{$newHash_min};
                $iterate = 1;
                next FRESH;
            }
        }
    }
}

for my $min (keys %fresh) {
    my $max = $fresh{$min};
    my $count = $max - $min + 1;
    $answer += $count;
}
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