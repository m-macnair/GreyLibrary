use strict;
use warnings;
use Test::More;

use Catalyst::Test 'GreyLibrary';
use GreyLibrary::Controller::User::WishList::Web;

ok( request( '/user/wishlist/web' )->is_success, 'Request should succeed' );
done_testing();
