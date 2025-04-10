# ABSTRACT : Combine ./foreign/ DB modules into one role for consistency
package GreyLibraryMoo::Role::Combine::DB::MariaDB;
our $VERSION = 'v0.0.3';
##~ DIGEST : bfcf77d2d26495e37ecdf954a9492bcb
use Moo::Role;

with qw/
  Moo::GenericRole::DB
  Moo::GenericRole::DB::Abstract
  Moo::GenericRole::DB::MariaMysql

  Moo::Task::SubjectTagDB::Role::Core
  Moo::Task::SubjectTagDB::Role::DB
  Moo::Task::SubjectTagDB::Role::CacheWrappers::FastMmap
  /;

sub BUILD {
	my ( $self, $argv ) = @_;

}
1;
