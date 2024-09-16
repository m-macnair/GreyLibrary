package GreyLibrary::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config( namespace => '' );

sub auto : Private {
	my ( $self, $c ) = @_;

	unless ( $c->session->{user_id} || index( $c->request->uri, '/auth/web' ) > 0 ) {
		$c->res->redirect( $c->uri_for( "/auth/web/" ) );
	}
}

=head2 default

Standard 404 error page

=cut

sub default : Path {
	my ( $self, $c ) = @_;
	$c->response->body( 'Page not found' );

	# 	$c->res->redirect( $c->uri_for( "/image/web/untagged" ) );
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') { }

=head1 AUTHOR

m,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
