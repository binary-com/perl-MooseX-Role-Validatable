package MooX::Role::Validatable;

use strict;
use 5.008_005;
our $VERSION = '0.01';

use Moo::Role;
use MooX::Role::Validatable::Error;
use Types::Standard qw( Str Int Bool ArrayRef );

use Carp qw(confess);
use List::MoreUtils qw(any);

has [qw(_init_errors _validation_errors)] => (
    is       => 'ro',
    isa      => ArrayRef,
    init_arg => undef,
    default  => sub { return [] },
);

has validation_methods => (
    is   => 'lazy',
    isa  => ArrayRef[Str]
);

sub _build_validation_methods {
    my $self = shift;
    return [grep { $_ =~ /^_validate_/ } ($self->meta->get_all_method_names)];
}



no Moo::Role;

1;
__END__

=encoding utf-8

=head1 NAME

MooX::Role::Validatable - Role to add validation to a class

=head1 SYNOPSIS

    package MyClass;

    use Moo;
    with 'MooX::Role::Validatable';

    has 'attr1' => (is => 'lazy');

    sub _build_attr1 {
        my $self = shift;

        # Note initialization errors
        $self->add_errors( {
            message => 'Error: blabla',
            message_to_client => 'Something is wrong!'
        } ) if 'blabla';
    }

    sub _validate_some_other_errors { # _validate_*
        my $self = shift;

        my @errors;
        push @errors, {
            message => '...',
            message_to_client => '...',
        };

        return @errors;
    }

    ## use
    my $ex = MyClass->new();

    if (not $ex->initialized_correctly) {
        ...;    # We didn't even start with good data.
    }

    if (not $ex->confirm_validity) { # does not pass those _validate_*
        ...;
    }

=head1 DESCRIPTION

MooX::Role::Validatable is a Moo/Moose role which provides a standard way to add validation to a class.

=head1 METHODS

=head2 all_errors

An array of the errors currently noted.

=head2 validation_methods

A list of all validation methods available on this object.
This can be auto-generated from all methods which begin with
"_validate_" which is especially helpful in devleoping new validations.

You may wish to set this list directly on the object, if
you create and validate a lot of static objects.

=head1 AUTHOR

Binary.com E<lt>fayland@binary.comE<gt>

=head1 COPYRIGHT

Copyright 2014- Binary.com

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
