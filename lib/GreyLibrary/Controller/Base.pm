package GreyLibrary::Controller::Base;
use Moose;
use namespace::autoclean;
BEGIN { extends 'Catalyst::Controller'; }

sub auto : Private {
	my ( $self, $c ) = @_;

	unless ( $c->user ) {
		$c->response->redirect( $c->uri_for( '/auth/discord' ) );
		$c->detach;
	}

	return 1;
}

__PACKAGE__->meta->make_immutable;
1;
