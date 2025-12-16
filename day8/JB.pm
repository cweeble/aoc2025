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
    if ($other_jb->{id} < $self->{id}) {
        $other_jb->add_to_circuit($self);
        return;
    }
    push @{$self->{circuit_with}}, $other_jb->{id};
}
1;