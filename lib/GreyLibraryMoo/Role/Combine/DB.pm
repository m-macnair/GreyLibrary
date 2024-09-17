# ABSTRACT : Combine ./foreign/ DB modules into one role for consistency
package GreyLibraryMoo::Role::Combine::DB;
our $VERSION = 'v0.0.13';
##~ DIGEST : 20ad04f46a5e39e247b0e9bdd5703f3f
use Moo::Role;
with qw/
  Moo::GenericRole::DB
  Moo::GenericRole::DB::Abstract
  Moo::GenericRole::DB::SQLite
  Moo::Task::FileDB::Role::DB::AbstractSQLite
  Moo::Task::SubjectTagDB::Role::DB::AbstractSQLite
  Moo::Task::SubjectTagDB::Role::Core
  /;
1;
