#ABSTRACT: Role for doing discord authentication
package GreyLibraryMoo::Role::DiscordAuth;
use Moo::Role;
use Mojo::UserAgent;
use JSON;
use URI::Escape;
use Carp;

ACCESSORS: {
	for my $accessor (
		qw/
		client_id
		client_secret

		redirect_uri

		/
	  )
	{
		has(
			$accessor => (
				is       => 'rw',
				required => 1
			)
		);
	}

}

sub authenticate {
	my ( $self, $code ) = @_;

	# Setup the user agent
	my $ua = LWP::UserAgent->new;

	# Exchange code for access token
	$ua->default_header( 'Content-Type' => 'application/x-www-form-urlencoded' );
	#
	my $response = $ua->post(
		"https://discord.com/api/v10",
		{

			grant_type    => 'authorization_code',
			code          => $code,
			redirect_uri  => $self->redirect_uri(),
			client_id     => $self->client_id(),
			client_secret => $self->client_secret(),
		}
	);

	unless ( $response->is_success ) {
		croak "Failed to fetch access token: " . $response->status_line;
	}

	my $content      = decode_json( $response->decoded_content );
	my $access_token = $content->{access_token};
	unless ( $access_token ) {
		croak "No access token found in response";
	}

	# Use the access token to fetch user info
	my $user_response = $ua->get( 'https://discord.com/api/users/@me', 'Authorization' => "Bearer $access_token", );

	unless ( $user_response->is_success ) {
		croak "Failed to fetch user info: " . $user_response->status_line;
	}

	my $user_info = decode_json( $user_response->decoded_content );
	return $user_info; # Return user info like ID, username, etc.
}

#https://discord.com/oauth2/authorize?response_type=code&client_id=157730590492196864&scope=identify%20guilds.join&state=15773059ghq9183habn&redirect_uri=https%3A%2F%2Fnicememe.website&prompt=consent&integration_type=0
#4RY3Gi9bIeNfykSbZwxkMLLtSZ3FRO&state=test
1;
