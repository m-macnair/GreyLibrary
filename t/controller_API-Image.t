use strict;
use warnings;
use Test::More;

use Catalyst::Test 'GreyLibrary';
use GreyLibrary::Controller::API::Image;

ok( request( '/api/image' )->is_success, 'Request should succeed' );
done_testing();
