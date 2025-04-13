package GreyLibrary::Controller::Auth;
our $VERSION = 'v1.0.1';

##~ DIGEST : b288a0d8d132bae5198aab7f3723aa9c

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use Data::Dumper;
use JSON qw//;

sub discord : Path('/auth/discord/') : Args(0) {
	my ( $self, $c ) = @_;
	$c->user( {} ) unless $c->user();

	# Get the code from the URL
	my $code  = $c->req->param( 'code' );
	my $error = $c->req->param( 'error' ); # If there's an error in the response

	# If there was an error, show an error message
	if ( $error ) {
		$c->stash( error_msg => "Error: $error" );
		$c->res->redirect( '/' );
		return;
	}

	# If code is not provided, show an error
	unless ( $code ) {
		$c->stash( error_msg => "Error: No code received." );
		$c->res->redirect( '/' );
		return;
	}

	#TODO timeouts

	my $token;
	if ( $c->user() && defined( $c->user->{discord_meta}->{token} ) ) {
		$token = $c->user->{discord_meta}->{token};
	}

	#TODO make this work properly
	my $discord_obj = $c->get_auth_realm( 'discord' );
	$discord_obj->{credential}->ua->default_headers->header( 'User-Agent' => 'GreyLibrary (0.1,http://localhost:3000)' );
	unless ( $token ) {
		if ( $c->config->{force_token} ) {
			$token = $c->config->{force_token};
			warn "Forcing token";
		}
		unless ( $token ) {

			# Exchange the code for an access token
			my $token_response = $c->authenticate(
				{
					code         => $code,
					scope        => 'identify',
					redirect_uri => $c->config->{host_url} . '/auth/discord',
				}
			);
			$token = $token_response->token();
		}
	}
	if ( $c->user() && $c->user->{discord_data} ) {

	} else {
		if ( $token ) {

			my $url = $discord_obj->{config}->{credential}->{userinfo_uri};

			my $req = HTTP::Request->new( GET => $url );
			$req->header( 'Authorization' => "Bearer $token" );
			my $res = $discord_obj->{credential}->ua->request( $req );
			if ( $res->is_success ) {
				my $discord_data = JSON::decode_json( $res->decoded_content );
				SETUPVERIFY_ALLOWED: {
					my $sth = $c->model( 'GLM' )->select( 'user_to_discord', [qw/*/], {discord_name => $discord_data->{username}} );
					$sth->execute();
					if ( my $row = $sth->fetchrow_hashref() ) {
						if ( $row->{user_id} ) {

							$c->user()->{gl_data}->{id} = $row->{user_id};
						} else {
							my $user_row = $c->model( 'GLM' )->select_insert_href( 'users', {display => $discord_data->{global_name}} );
							$c->model( 'GLM' )->update( 'user_to_discord', {user_id => $user_row->{id}}, {discord_name => $discord_data->{username}} );
							$c->user()->{gl_data}->{id} = $user_row->{id};
							warn "new user $discord_data->{username}";
						}
					}
				}
				$c->user->{discord_data} = $discord_data;
				warn Dumper( $c->user->{discord_data} );
			} else {
				die "Unhandled response from discord";
			}
		} else {
			warn "Unable to retrieve/use Discord response token";
			$c->stash( error_msg => "Error: Unable to validate the code." );
		}
	}
}

sub landing : Args(0) {
	my ( $self, $c ) = @_;
	$c->authenticate( {} );
	my $user = $c->user();
	die Dumper( $user );
}

sub logout : Path('/logout') : Args(0) {
	my ( $self, $c ) = @_;
	$c->logout;
	$c->res->redirect( '/' );
}

__PACKAGE__->meta->make_immutable;
1;
z
