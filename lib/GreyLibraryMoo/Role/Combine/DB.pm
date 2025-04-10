# ABSTRACT : Combine ./foreign/ DB modules into one role for consistency
package GreyLibraryMoo::Role::Combine::DB;
our $VERSION = 'v0.0.15';
##~ DIGEST : 98914239ab4a5964d3a046bb938f4e0c
use Moo::Role;
with qw/
  Moo::GenericRole::DB
  Moo::GenericRole::DB::Abstract
  Moo::GenericRole::DB::SQLite

  Moo::Task::FileDB::Role::DB

  Moo::Task::SubjectTagDB::Role::Core
  Moo::Task::SubjectTagDB::Role::DB
  Moo::Task::SubjectTagDB::Role::CacheWrappers::FastMmap
  /;
1;
