package GreyLibrary::Controller::Subject::API;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

GreyLibrary::Controller::Subject::API - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub tag_subject : Local : Args(2) {
	my ( $self, $c, $id, $tag ) = @_;

	if ( $c->session->{user_id} ) {
		my $res = $c->model( 'GLM' )->single_tag_subject_as_user( $tag, $id, $c->session->{user_id} );
		$c->response->body( 'tagged by user [' . $c->session->{user_id} . ']' );

	} else {
		die "nope";
	}
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
