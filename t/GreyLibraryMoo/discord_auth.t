
use 5.006;
use strict;
use warnings;
use Test::More;
use Data::Dumper;
use Test::Exception;

my $module = $1   || 'Mojo::Discord::Auth';
use_ok( $module ) || BAIL_OUT "Failed to use $module : [$!]";
my $obj = Mojo::Discord::Auth->new(
	id      =>,
	secret  => '',
	name    => 'GreyLibrary',
	url     => 'http://localhost:3000/landing',
	version => '0',
	scope   => 'identify',
	code    => '',

	redirect_uri => 'http://localhost:3000/landing',
) || BAIL_OUT "Failed to construct role user module : [$!]";

diag Dumper( $obj->request_token );
ok( 1 );
done_testing();
