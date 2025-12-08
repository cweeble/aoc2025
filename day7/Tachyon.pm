package Tachyon;
use strict;

sub new {
    my $class = shift;
    my $x = shift;
    my $y = shift;
    my $mapref = shift;
    my $max_x = shift;
    my $max_y = shift;
    my $self = {
        x => $x,
        y => $y,
        max_x => $max_x,
        max_y => $max_y,
        mapref => $mapref,
        stops => 0,
        num_splits => 0,
        spawn_child => undef,
    };

    if ($self->{mapref}->[$x][$y] eq '|') {
        $self->{stops} = $y;
    } elsif ($self->{mapref}->[$x][$y] eq '.') {
        $self->{mapref}->[$x][$y] = '|';
    }
    
    bless($self, $class);
}

sub moveSouth {
    my $self = shift;
    return if ($self->{stops});
    $self->{y}++;
    if ($self->{y} > $self->{max_y}) {
        $self->{stops} = $self->{y};
        return;
    }
    if ($self->{mapref}->[$self->{x}][$self->{y}] eq '^') {
        $self->{num_splits}++;
        $self->{mapref}->[$self->{x}][$self->{y}] = '%';
        $self->{spawn_child} = join(':', $self->{x}+1, $self->{y})
            unless ($self->{x}+1 > $self->{max_x});
        $self->{x}--;
        if ($self->{x} < 0) {
            $self->{stops} = $self->{y};
            return;
        }
        if ($self->{mapref}->[$self->{x}][$self->{y}] eq '|') {
            $self->{stops} = $self->{y};
        } elsif ($self->{mapref}->[$self->{x}][$self->{y}] eq '%') {
            $self->{stops} = $self->{y};
        } elsif ($self->{mapref}->[$self->{x}][$self->{y}] eq '.') {
            $self->{mapref}->[$self->{x}][$self->{y}] = '|';
        }
    } else {
        $self->{mapref}->[$self->{x}][$self->{y}] = '|';
    }
}

sub stop_spawning {
    my $self = shift;
    $self->{spawn_child} = undef;
}

sub set_max_y {
    my $self = shift;
    $self->{max_y} = shift;
}
1;