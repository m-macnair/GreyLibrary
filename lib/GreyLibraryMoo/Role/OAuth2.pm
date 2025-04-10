#ABSTRACT: Role for using Net::OAuth2 which will eventually move to genericrole or similar
package GreyLibraryMoo::Role::OAuth2;
use strict;
use warnings;
use Moo::Role;
use Carp;
use Data::Dumper;
our $VERSION = 'v1.0.14';
##~ DIGEST : 2e3f152aa44eeb0e170aff2056f39ae7

use Net::OAuth2::Client;

ACCESSORS: {
	for my $accessor (
		qw/
		client_id
		client_secret
		site
		redirect_uri
		scope
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

	# 	has OAuth2Client => (
	# 		is => 'rw',
	# 		lazy => 1,
	# 		default => sub {
	# 			my ($self) = @_;
	#
	# 		}
	# 	);
}

sub get_webserver_profile {
	my ( $self, $state ) = @_;
	return Net::OAuth2::Profile::WebServer->new(
		client_id     => $self->client_id(),
		client_secret => $self->client_secret,
		site          => $self->site,
	);

}

#
# sub authenticate {
# 	my ($self,$state) = @_;
# # 	return Net::OAuth2::Profile::WebServer->new(
# # 		client_id     => $self->client_id(),
# # 		client_secret => $self->client_secret,
# # 		site          => $self->site,
# # 		redirect_uri  => $self->redirect_uri,
# # 		scope  => $self->scope,
# # 		'state' => 'test',
# # 		prompt => 'consent',
# # 		integration_type=> 0,
# # 	);
#
# }

1;

=HEAD

	Copy
	https://discord.com/oauth2/authorize?
	response_type=code&
	client_id=157730590492196864&
	scope=identify&
	state=15773059ghq9183habn&
	redirect_uri=https%3A%2F%2Fnicememe.website&
	prompt=consent&
	integration_type=0


https://discord.com/oauth/authorize?state=test&client_id=1293143804802760736&response_type=code&scope=identify&hd=&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Flanding
1;
