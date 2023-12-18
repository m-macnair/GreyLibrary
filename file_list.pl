#!/usr/bin/perl
# ABSTRACT:
our $VERSION = 'v0.0.5';

##~ DIGEST : ea5f42e464730f05922066c41470613a

use strict;
use warnings;

package Obj;
use Moo;
use parent 'Moo::GenericRoleClass::CLI'; #provides  CLI, FileSystem, Common
with qw/

  Moo::ComplexRole::FileIDDB
  Moo::ComplexRole::TagDB

  /;
has _something => (
	is      => 'rw',
	lazy    => 1,
	default => sub { return }
);

sub process {
	my ( $self ) = @_;
	$self->_do_db();
	my $id = $self->get_file_id( '/home/m/Hobby/Hobby-Code/GreyLibrary/test.sqlite' );
	$self->tag_subject_id( "Funky Fresh Beats", $id );
	$self->set_tag_string_for_subject( $id );

}

sub _do_db {
	my ( $self, $res ) = @_;
	$res ||= {};
	if ( $res->{db_file} ) {
		$self->sqlite3_file_to_dbh( $res->{db_file} );
	} else {
		$self->sqlite3_file_to_dbh( '/home/m/Hobby/Hobby-Code/GreyLibrary/db/path_db.sqlite' );
	}
}

1;

package main;

main();

sub main {
	my $self = Obj->new();
	$self->get_config(
		[qw//],
		[
			qw/
			  in_file
			  out_file
			  db_def_file

			  /
		],
		{
			required => {},
			optional => {
				db_def_file => "JSON file containing database connection details",
				in_file     => "Path to input file",
				out_file    => "Explicit output file path",

			}
		}
	);
	$self->process();

}
