use strict;
use warnings;
use Test::More;

use Catalyst::Test 'GreyLibrary';
use GreyLibrary::Controller::Image::Web;

ok( request( '/image/web' )->is_success, 'Request should succeed' );
done_testing();
