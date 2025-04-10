# ABSTRACT : Combine ./foreign/ DB modules into one role for consistency
package GreyLibraryMoo::Role::Combine::DB::MariaDB;
our $VERSION = 'v0.0.4';
##~ DIGEST : 116002c9cb73e2f12b41c45321ea2e3e
use Moo::Role;

with qw/
  GreyLibraryMoo::Role::Combine::DB
  Moo::Task::SubjectTagDB::Role::DB::MariaDB
  /;

sub BUILD {
	my ( $self, $argv ) = @_;

}
1;
