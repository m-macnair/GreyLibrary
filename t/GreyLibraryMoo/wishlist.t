#!perl 
use 5.006;
use strict;
use warnings;
use Test::More;
use Test::Exception;
use File::Slurp;
use File::Copy;
use Data::Dumper;
use Config::Any::Merge;

my $config = Config::Any::Merge->load_files(
	{
		files   => [ 'greylibrary.perl', ],
		use_ext => 1,
	}
);

my $test_id = time;
diag( "Using test id [$test_id]" );
my $module = $1   || 'GreyLibraryMoo::Class::MariaDB';
use_ok( $module ) || BAIL_OUT "Failed to use $module : [$!]";
dies_ok( sub { new( $module ) } ); #passed a test earlier w/o db init

my $self;
$self = new_ok( $module, [ {%{$config->{db}}, thumbnail_dir => $config->{thumbnail_dir}} ] );

ok( my $whislist_id = $self->get_user_collection_id( 1, 'wishlist' ) );

diag( "whislist for user 1: $whislist_id" );
ok( my $whislist_row = $self->add_subject_to_user_collection( 1, 1, 'wishlist' ) );
done_testing();
