# ABSTRACT : Combine ./foreign/ DB modules into one role for consistency
package GreyLibraryMoo::Class::SQLite;
our $VERSION = 'v0.0.13';
##~ DIGEST : a953eca68dc4c00ba4555fc24f2af1e8
use Moo;

#not sure Thumb should be here
with qw/
  GreyLibraryMoo::Role::Combine::DB
  GreyLibraryMoo::Role::Subject::Access
  GreyLibraryMoo::Role::Subject::Admin
  GreyLibraryMoo::Role::Thumb
  Moo::GenericRole::FileSystem
  /;

sub BUILD {
	my ( $self, $argv ) = @_;
	$self->sqlite3_file_to_dbh( $argv->{db_file} );

}
1;
