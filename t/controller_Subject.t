use strict;
use warnings;
use Test::More;


use Catalyst::Test 'GreyLibrary';
use GreyLibrary::Controller::Subject;

ok( request('/subject')->is_success, 'Request should succeed' );
done_testing();
