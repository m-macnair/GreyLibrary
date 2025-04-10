# ABSTRACT : Combine ./foreign/ DB modules into one role for consistency
package GreyLibraryMoo::Class::SQLite;
our $VERSION = 'v0.0.14';
##~ DIGEST : 2ef6bd093ad49aa7a297cacddcce118d
use Moo;

#not sure Thumb should be here
with qw/
  GreyLibraryMoo::Role::Combine::DB
  GreyLibraryMoo::Role::Subject::Access
  GreyLibraryMoo::Role::Subject::Admin
  GreyLibraryMoo::Role::Thumb
  Moo::GenericRole::FileSystem
  GreyLibraryMoo::Role::CatalystPaths
  /;

sub BUILD {
	my ( $self, $argv ) = @_;
	$self->sqlite3_file_to_dbh( $argv->{db_file} );

}
1;
