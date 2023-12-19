#ABSTRACT: coherent system to store tag strings against arbitrary subject ID values
package Moo::Class::GLDB;
use strict;
use warnings;
use Moo;
use Carp;
use Data::Dumper;

our $VERSION = 'v1.0.6';
##~ DIGEST : 71c4507a6de34af331d195ab88e80176

with qw/
  Moo::ComplexRole::TagDB
  Moo::ComplexRole::FileIDDB
  /;

sub dbh {
	Moo::GenericRole::DB::SQLite::sqlite_dbh( @_ );
}

1;
