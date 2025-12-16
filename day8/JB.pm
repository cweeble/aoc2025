package JB;
use strict;
use Carp qw(croak);
sub new {
    my $class = shift;
    my $id = shift;
    my $x = shift;
    my $y = shift;
    my $z = shift;
    my @circuit;

    my $self = {
        id => $id,
        x => $x,
        y => $y,
        z => $z,
        circuit_with => \@circuit,
        finalised_circuit => [ $id ],
    };
    bless($self, $class);
    return $self;
}

sub calculate_distance {
    my $self = shift;
    my $other = shift;
    my $dx = $self->{x} - $other->{x};
    my $dy = $self->{y} - $other->{y};
    my $dz = $self->{z} - $other->{z};
    return sqrt($dx*$dx + $dy*$dy + $dz*$dz);
}

sub add_to_circuit {
    my $self = shift;
    my $other_jb = shift;
    my $internal = shift;
    push @{$self->{circuit_with}}, \$other_jb;
    $other_jb->add_to_circuit($self, 1) unless $internal;
}

sub finalise_circuit {
    my $self = shift;
    my %seen = ($self->{id} => 1);
    my @final_circuit = ( $self->{id} );
    my @queue;
    for my $jb_ref (@{ $self->{circuit_with} }) {
        my $jb = ${$jb_ref};
        next if ($seen{$jb->{id}}++);
        push @final_circuit, $jb->{id};
        push @queue, @{ $jb->{circuit_with} };
        while (my $next_jb_ref = shift @queue) {
            my $next_jb = ${ $next_jb_ref };
            next if ($seen{$next_jb->{id}}++);
            push @final_circuit, $next_jb->{id};
            push @queue, @{ $next_jb->{circuit_with} };
        }
    }
    $self->{finalised_circuit} = \@final_circuit;
}
1;