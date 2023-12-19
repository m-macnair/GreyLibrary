use strict;
use warnings;
use Test::More;

use Catalyst::Test 'GreyLibrary';
use GreyLibrary::Controller::Image;

ok( request( '/image' )->is_success, 'Request should succeed' );
done_testing();
