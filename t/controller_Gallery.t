use strict;
use warnings;
use Test::More;

use Catalyst::Test 'GreyLibrary';
use GreyLibrary::Controller::Gallery;

ok( request( '/gallery' )->is_success, 'Request should succeed' );
done_testing();
