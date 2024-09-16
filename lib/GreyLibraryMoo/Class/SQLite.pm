# ABSTRACT : Combine ./foreign/ DB modules into one role for consistency
package GreyLibraryMoo::Class::SQLite;
our $VERSION = 'v0.0.12';
##~ DIGEST : 4341d9ad7da5f8019bff601bc3656e9e
use Moo;

#not sure Thumb should be here
with qw/
  GreyLibraryMoo::Role::Combine::DB
  GreyLibraryMoo::Role::Subject::Access
  GreyLibraryMoo::Role::Thumb
  Moo::GenericRole::FileSystem
  /;

sub BUILD {
	my ( $self, $argv ) = @_;
	$self->sqlite3_file_to_dbh( $argv->{db_file} );

}
1;
