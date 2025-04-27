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

sub auto : Private {
	my ( $self, $c ) = @_;

	#$c->stash->{disable_view} = 1;

	#there's no explicit "do not render view" apparently, but if content is already set it will be left alone
	$c->response->body( '' );
	return 1;
}

sub tag_subject : Local : Args(2) {
	my ( $self, $c, $id, $tag ) = @_;

	if ( $c->user->{gl_data}->{id} ) {
		my $res = $c->model( 'GLM' )->single_tag_subject_as_user( $tag, $id, $c->user->{gl_data}->{id} );
		$c->response->body( 'tagged by user [' . $c->user->{gl_data}->{id} . ']' );

	} else {
		die "nope";
	}
}

sub wishlist_subject : Local : Args(1) {
	my ( $self, $c, $id ) = @_;

	if ( $c->user->{gl_data}->{id} ) {
		my $res = $c->model( 'GLM' )->add_subject_to_user_collection( $id, $c->user->{gl_data}->{id}, 'wishlist' );
		$c->response->body( $res->{id} );
	} else {
		die "nope";
	}
}

sub problem_subject : Local : Args(1) {
	my ( $self, $c, $id ) = @_;

	if ( $c->user->{gl_data}->{id} ) {
		my $res = $c->model( 'GLM' )->add_subject_to_user_collection( $id, 1, 'problem' );
		$c->response->body( $res->{id} );
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
