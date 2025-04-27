package GreyLibrary::Controller::Root;
our $VERSION = 'v1.0.1';

##~ DIGEST : ea81b947163239271bc493482bc0550f
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config( namespace => '' );

sub default : Path {
	my ( $self, $c ) = @_;
	$c->stash( template => '' );
	$c->response->body( 'Denied.' );
}

sub auto : Private {
	my ( $self, $c ) = @_;

	# Allow unauthenticated users to reach the login page.  This
	# allows unauthenticated users to reach any action in the Login
	# controller.  To lock it down to a single action, we could use:
	#   if ($c->action eq $c->controller('Login')->action_for('index'))
	# to only allow unauthenticated access to the 'index' action we
	# added above.
	if (   $c->controller eq $c->controller( 'Auth' )
		|| $c->controller eq $c->controller( 'Root' ) )
	{
		return 1;
	}
	if ( !$c->user() ) {
		$c->log->debug( '***Root::auto User not found' );
		$c->response->redirect( '/' );
		$c->detach();
	} else {
		$c->log->debug( '***Root::auto User Found: ' . $c->user );
	}

	# User found, so return 1 to continue with processing after this 'auto'
	return 1;
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
