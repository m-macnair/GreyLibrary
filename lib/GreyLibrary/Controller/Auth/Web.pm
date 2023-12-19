package GreyLibrary::Controller::Auth::Web;
use Moose;
use namespace::autoclean;

BEGIN {
	extends 'Catalyst::Controller::HTML::FormFu';
}

sub index : default : FormConfig("login.perl") {
	my ( $self, $c ) = @_;
	my $form = $c->stash->{form};
	if ( $form->submitted_and_valid() ) {
		if (
			$c->authenticate(
				{
					username => $form->param_value( 'user' ),
					password => $form->param_value( 'pass' )
				}
			)
		  )
		{
			$c->session( user_id => $c->user->get( 'id' ) );
			warn "login from user [" . $c->session->{user_id} . ']';
			$c->res->redirect( $c->uri_for( "/image/web/untagged" ) );
		} else {
			die "failed auth (!?)";
		}
	}
}

sub logout : Path {
	my ( $self, $c ) = @_;
	$c->delete_session();
	$c->res->redirect( $c->uri_for( "/auth/web/" ) );
}

__PACKAGE__->meta->make_immutable;

1;
