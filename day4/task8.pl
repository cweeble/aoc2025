#!/usr/bin/perl
use strict;
open (IN, 'input_data') || warn "no input file!";
our %location;
my $answer;
my $row_num = -1;
our ($max_cols, $max_rows);
while (<IN>) {
    chomp;
    $row_num++;
    my @chars = split(//, $_);
    for my $col_num (0..$#chars) {
        my $char = $chars[$col_num];
        $location{ "$col_num:$row_num" } = $char;
    }
    $max_cols = $#chars if (!defined $max_cols || $max_cols < $#chars);
}
$max_rows = $row_num;

my $iterate = 1;
while ($iterate) {
    $iterate = 0;
    for my $pos (keys %location) {
        my ($x, $y) = split(/:/, $pos);
        next unless ($location{$pos} eq '@');
        my @neighbours = (
            N($x, $y), NE($x, $y), E($x, $y), SE($x, $y), 
            S($x, $y), SW($x, $y), W($x, $y), NW($x, $y)
        );
        my $count = scalar grep { defined $_ && $_ eq '@' } @neighbours;
        #   print "Location ${pos} has ${count} neighbours $/";
        if ($count < 4) {
            $iterate++;
            $answer++;
            $location{$pos} = 'X';
        }
    }
#   print "Iterations this roune: ${iterate} $/";
}


printf ("%s $/", $answer);

sub N {
    my ($x, $y) = @_;
    $y--;
    if ($y<0) { return undef; }
    return $location{"$x:$y"};
}
sub NE {
    my ($x, $y) = @_;
    $x++;
    $y--;
    if ($y<0) { return undef; }
    if ($x>$max_cols) { return undef; }
    return $location{"$x:$y"};
}
sub E {
    my ($x, $y) = @_;
    $x++;
    if ($x>$max_cols) { return undef; }
    return $location{"$x:$y"};
}
sub SE {
    my ($x, $y) = @_;
    $x++;
    $y++;
    if ($x>$max_cols) { return undef; }
    if ($y>$max_rows) { return undef; }
    return $location{"$x:$y"};
}
sub S {
    my ($x, $y) = @_;
    $y++;
    if ($y>$max_rows) { return undef; }
    return $location{"$x:$y"};
}
sub SW {
    my ($x, $y) = @_;
    $x--;
    $y++;
    if ($x<0) { return undef; }
    if ($y>$max_rows) { return undef; }
    return $location{"$x:$y"};
}
sub W {
    my ($x, $y) = @_;
    $x--;
    if ($x<0) { return undef; }
    return $location{"$x:$y"};
}
sub NW {
    my ($x, $y) = @_;
    $x--;
    $y--;
    if ($x<0) { return undef; }
    if ($y<0) { return undef; }
    return $location{"$x:$y"};
}

__DATA__
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
