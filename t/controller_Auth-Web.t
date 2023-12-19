use strict;
use warnings;
use Test::More;

use Catalyst::Test 'GreyLibrary';
use GreyLibrary::Controller::Auth::Web;

ok( request( '/auth/web' )->is_success, 'Request should succeed' );
done_testing();
