# ABSTRACT : Combine ./foreign/ DB modules into one role for consistency
package GreyLibraryMoo::Role::Combine::DB::MariaDB;
our $VERSION = 'v0.0.2';
##~ DIGEST : 053f9380e12b72d681fb3004cb000a10
use Moo::Role;

with qw/
  Moo::GenericRole::DB
  Moo::GenericRole::DB::Abstract
  Moo::GenericRole::DB::MariaMysql

  Moo::Task::SubjectTagDB::Role::Core
  Moo::Task::SubjectTagDB::Role::CacheWrappers::FastMmap
  /;

sub BUILD {
	my ( $self, $argv ) = @_;

}
1;
