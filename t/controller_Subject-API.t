use strict;
use warnings;
use Test::More;

use Catalyst::Test 'GreyLibrary';
use GreyLibrary::Controller::Subject::API;

ok( request( '/subject/api' )->is_success, 'Request should succeed' );
done_testing();
