package GreyLibrary;
use strict;
use warnings;
our $VERSION = '0.07';
##~ DIGEST : f87836d051255bc78a055c84521e3662
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

use Catalyst qw/
  -Debug
  ConfigLoader
  Static::Simple
  Authentication
  Session
  Session::Store::FastMmap
  Session::State::Cookie
  /;

extends 'Catalyst';

__PACKAGE__->config(
	name => 'GreyLibrary',

	# Disable deprecated behavior needed by old applications
	disable_component_resolution_regex_fallback => 1,
	enable_catalyst_header                      => 0,       # Send X-Catalyst header
	encoding                                    => 'UTF-8', # Setup request decoding and response encoding
);

__PACKAGE__->config->{static}->{dirs} = [ 'srv', 'static' ];

__PACKAGE__->config(
	'Plugin::Authentication' => {
		default_realm => 'discord',
		realms        => {
			discord => {
				credential => {
					class => 'OAuth2',

					grant_uri    => 'https://discord.com/api/oauth2/grant',
					token_uri    => 'https://discord.com/api/oauth2/token',
					userinfo_uri => 'https://discord.com/api/users/@me',

					token_uri_method => 'POST',

					#should be defined in the site_config.perl file
					client_id     => '',
					client_secret => '',
					scope         => 'identify',


				},
				store => {
					class => 'Null',
				},
			},
		},
	},
	'Plugin::Session' => {
		flash_to_stash => 1,
		expires        => 3600,
		storage        => '/tmp/session',
	}
);

# Start the application
__PACKAGE__->setup();

=encoding utf8

=head1 NAME

GreyLibrary - Catalyst based application

=head1 SYNOPSIS

    script/greylibrary_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<GreyLibrary::Controller::Root>, L<Catalyst>

=head1 AUTHOR

m,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
