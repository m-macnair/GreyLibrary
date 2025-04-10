package GreyLibrary::Controller::Gallery;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

GreyLibrary::Controller::Gallery - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {
	my ( $self, $c ) = @_;

	$c->response->body( 'Matched GreyLibrary::Controller::Gallery in Gallery.' );
}

=encoding utf8

=head1 AUTHOR

m,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
