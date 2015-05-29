package Log::Any::For::Std;

#
# Send output of STDERR to Log::Any
#

use 5.008001;
use strict;
use warnings;

use Log::Any '$log';

our $VERSION = '0.01';

#---

my $sig;

# Value assignment is needed for futher learning in the PRINT method where the message came from
$SIG{__DIE__} = sub { $sig = 'DIE' };
$SIG{__WARN__} = sub { $sig = 'WARN'; print STDERR @_ };

# We connect the descriptor STDERR with the current packet for interception of all error messages
tie *STDERR, __PACKAGE__;

# Redefinition of standard constructor for the connnected descriptor STDERR
sub TIEHANDLE {
    my $class = shift;

    bless {}, $class;
}

# Redefinition of standart method PRINT for the connected descriptor STDERR
sub PRINT {
    my ( $self, @msg ) = @_;

    chomp(@msg);

    # Current value in $@ says where the message came from
    if ( defined $sig and $sig eq 'DIE' ) {
        $log->emergency(@msg);
    }
    elsif ( defined $sig and $sig eq 'WARN' ) {
        $log->warning(@msg);
    }
    else {
        $log->notice(@msg);
    }

    # Reset to the default value
    undef $sig;
}

# Redefinition of standard methode BINMODE for the connected descriptor STDERR
# In fact this method makes no sense here but it has to be fulfiled for the backward compatibility
# with the modules that call this method for their own purposes
sub BINMODE { }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Log::Any::For::Std - Send output of STDERR to Log::Any

=cut
