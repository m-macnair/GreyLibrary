
use 5.006;
use strict;
use warnings;
use Test::More;
use Data::Dumper;
use Test::Exception;

my $module = $1   || 'Mojo::Discord::Auth';
use_ok( $module ) || BAIL_OUT "Failed to use $module : [$!]";
my $obj = Mojo::Discord::Auth->new(
	id      => 1293143804802760736,
	secret  => 'wkgr3RFDi5r_VXwkcN9wjtZahpGwWXxm',
	name    => 'GreyLibrary',
	url     => 'http://localhost:3000/landing',
	version => '0',
	scope   => 'identify',
	code    => '2HNz4EvoKIRw9dksgUfEUiQIjzuOl2',

	redirect_uri => 'http://localhost:3000/landing',
) || BAIL_OUT "Failed to construct role user module : [$!]";

diag Dumper( $obj->request_token );
ok( 1 );
done_testing();
