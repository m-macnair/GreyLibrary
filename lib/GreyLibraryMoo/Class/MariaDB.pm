# ABSTRACT : The System - in MariaDB
package GreyLibraryMoo::Class::MariaDB;
our $VERSION = 'v0.0.2';
##~ DIGEST : 9d871e124e1a5addaa6a89f4cffefde6
use Moo;

#not sure Thumb should be here
with qw/
  GreyLibraryMoo::Role::Combine::DB::MariaDB
  GreyLibraryMoo::Role::Subject::Access
  GreyLibraryMoo::Role::Subject::Admin
  GreyLibraryMoo::Role::Thumb
  Moo::GenericRole::FileSystem
  Moo::GenericRole::Common::Core
  GreyLibraryMoo::Role::CatalystPaths
  /;

sub BUILD {
	my ( $self, $argv ) = @_;

	#TODO dbh ?
	# 	die "here";
	$self->set_dbh_from_def( $argv );
}
1;
