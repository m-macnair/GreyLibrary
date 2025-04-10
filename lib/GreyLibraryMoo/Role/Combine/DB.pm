# ABSTRACT : Combine ./foreign/ DB modules into one role for consistency
package GreyLibraryMoo::Role::Combine::DB;
our $VERSION = 'v0.0.14';
##~ DIGEST : c12853d8557a63e21c1b3c680487c7a1
use Moo::Role;
with qw/
  Moo::GenericRole::DB
  Moo::GenericRole::DB::Abstract
  Moo::GenericRole::DB::SQLite
  Moo::Task::FileDB::Role::DB::AbstractSQLite
  Moo::Task::SubjectTagDB::Role::DB::AbstractSQLite
  Moo::Task::SubjectTagDB::Role::Core
  Moo::Task::SubjectTagDB::Role::CacheWrappers::FastMmap
  /;
1;
