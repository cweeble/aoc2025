package Circuits;
use strict;
use Carp qw(croak);
sub new {
    my $class = shift;
    my $id = shift;
    my @junctions = @_;
    my $self = {
        id => $id,
        junctions => \@junctions,
    };
    bless($self, $class);
    return $self;
}

sub build_circuit {
    my $self = shift;
    my $junctions_ref = shift;
    my $circuits_ref = shift;

    my %circuit_junctions;
    my $jb_id = $self->{id};
    my $jb = $junctions_ref->[$jb_id];
    return if (! @{ $jb->{circuit_with} });

    my @circuit_junctions = @{ $jb->{circuit_with} };

    while my $other_id = shift @circuit_junctions {
        next if ($circuit_junctions{$other_id}++);
        my $other_jb = $junctions_ref->[$other_id];
        push @circuit_junctions, @{ $other_jb->{circuit_with} };
        $junctions_ref->[$other_id] = undef;
    }
}
1;