package GreyLibrary;
use strict;
use warnings;
our $VERSION = '0.04';
##~ DIGEST : ffca55702b2ff7cf7d00582678d63d88
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
	enable_catalyst_header                      => 1,       # Send X-Catalyst header
	encoding                                    => 'UTF-8', # Setup request decoding and response encoding
);

__PACKAGE__->config->{static}->{dirs} = [ 'static', ];

__PACKAGE__->config(
	'Plugin::Authentication' => {
		default => {
			credential => {
				class          => 'Password',
				password_field => 'password',
				password_type  => 'clear'
			},
			store => {
				class => 'Minimal',
				users => {
					'm' => {
						id       => 1,
						password => "test",
					},
				}
			}
		}
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
