use strict;
use warnings;
use Test::More;

use Catalyst::Test 'GreyLibrary';
use GreyLibrary::Controller::Image::API;

ok( request( '/image/api' )->is_success, 'Request should succeed' );
done_testing();
