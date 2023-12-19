use strict;
use warnings;
use Test::More;

use Catalyst::Test 'GreyLibrary';
use GreyLibrary::Controller::Web::Image;

ok( request( '/web/image' )->is_success, 'Request should succeed' );
done_testing();
