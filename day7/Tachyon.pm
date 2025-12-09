package Tachyon;
use strict;
use Carp qw(croak);

sub new {
    my $class = shift;
    my $x = shift;
    my $y = shift;
    my $mapref = shift;
    my $max_x = shift;
    my $max_y = shift;
    my @history = ("$x:$y");
    my $self = {
        x => $x,
        y => $y,
        max_x => $max_x,
        max_y => $max_y,
        mapref => $mapref,
        stops => 0,
        num_splits => 0,
        spawn_child => undef,
        monitor => 0,
        history => \@history,
    };

    if (($self->{mapref}->[$x][$y] eq '|') or ($self->{mapref}->[$x][$y] eq '!')) {
        $self->{stops} = $y;
    } elsif ($self->{mapref}->[$x][$y] eq '.') {
        $self->{mapref}->[$x][$y] = $self->{monitor} ? '!' : '|';
    }
    
    bless($self, $class);
}

sub moveSouth {
    my $self = shift;
#   return if ($self->{stops});
    if ($self->{y}+1 > $self->{max_y}) {
        $self->{stops} = $self->{y};
        return;
    }
    $self->{y}++;
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
    }
    if (($self->{mapref}->[$self->{x}][$self->{y}] eq '|') or ($self->{mapref}->[$self->{x}][$self->{y}] eq '!')) {
        $self->{stops} = $self->{y};
    } elsif ($self->{mapref}->[$self->{x}][$self->{y}] eq '%') {
        $self->{stops} = $self->{y};
    } elsif ($self->{mapref}->[$self->{x}][$self->{y}] eq '.') {
        $self->{mapref}->[$self->{x}][$self->{y}] = $self->{monitor} ? '!' : '|';
    }
    else {
        croak "Tachyon hit invalid map character '" . $self->{mapref}->[$self->{x}][$self->{y}] 
            . "' at position [" . $self->{x} . ',' . $self->{y} . ']'
            . " history: " . join(' ', @{$self->{history}}) . $/;
    }
}

sub log_position {
    my $self = shift;
    my $location = ' ' . join(':', $self->{x}, $self->{y}) . ' ';
    push @{$self->{history}}, $location;
    my @visited = @{$_[0]};
    my $already_visited = $visited[$self->{x}][$self->{y}]++;
    $_[0] = \@visited;
    return $already_visited;
}

sub stop_spawning {
    my $self = shift;
    $self->{spawn_child} = undef;
}

sub set_max_y {
    my $self = shift;
    $self->{max_y} = shift;
}

sub enable_monitor {
    my $self = shift;
    $self->{monitor} = 1;
}
1;