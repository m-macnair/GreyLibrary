# ABSTRACT : Combine ./foreign/ DB modules into one role for consistency
package GreyLibraryMoo::Role::Combine::DB;
our $VERSION = 'v0.0.11';
##~ DIGEST : 31a98b17225268a1f19163045ddeac2a
use Moo::Role;
with qw/
  Moo::GenericRole::DB
  Moo::GenericRole::DB::Abstract
  Moo::GenericRole::DB::SQLite
  Moo::Task::FileDB::Role::DB::AbstractSQLite
  Moo::Task::SubjectTagDB::Role::DB::AbstractSQLite
  /;
1;
