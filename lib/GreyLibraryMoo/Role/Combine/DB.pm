# ABSTRACT : Combine ./foreign/ DB modules into one role for consistency
package GreyLibraryMoo::Role::Combine::DB;
our $VERSION = 'v0.0.12';
##~ DIGEST : 968e69005725edd96258eabce608c79c
use Moo::Role;
with qw/
  Moo::GenericRole::DB
  Moo::GenericRole::DB::Abstract
  Moo::GenericRole::DB::SQLite
  Moo::Task::FileDB::Role::DB::AbstractSQLite
  Moo::Task::SubjectTagDB::Role::DB::AbstractSQLite
  /;
1;
