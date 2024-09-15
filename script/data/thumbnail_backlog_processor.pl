#!/usr/bin/perl
# ABSTRACT:
our $VERSION = 'v0.0.6';

##~ DIGEST : 3c1e41bf448fa777accd13a423501db0

use strict;
use warnings;

package Obj;
use Moo;
use parent 'Moo::GenericRoleClass::CLI'; #provides  CLI, FileSystem, Common
with qw/
  GreyLibraryMoo::Role::Thumb
  /;

sub _do_db {
	my ( $self, $p ) = @_;
	$p ||= {};
	if ( $p->{db_file} ) {
		$self->sqlite3_file_to_dbh( $p->{db_file} );
	} else {
		die "db_file not provided";
	}
}

sub process {
	my ( $self ) = @_;
	$self->_do_db( $self->cfg() );
	my $backlog_sth = $self->query(
		q{
		select f.* from file f 
		left join preview_file pfo
			on f.id = pfo.original_id
		left join preview_file pfp
			on f.id = pfp.preview_id
		join file_type ft
			on f.file_type_id = ft.id 
		where 
			pfp.preview_id is null
			and pfo.id is null
			and ft.class = "Image"
	}
	);
	while ( my $row = $backlog_sth->fetchrow_hashref() ) {
		print "Working on file [$row->{id}]$/";
		$self->get_thumbnail_path_for_file_id( $row->{id} );
	}
}
1;

package main;

main();

sub main {
	my $self = Obj->new();
	$self->get_config(
		[
			qw/

			/
		],
		[
			qw/
			  db_file
			  /
		],
		{
			required => {
				db_file => "./working_db.sqlite in most cases",

			},
			optional => {}
		}
	);
	$self->process();

}

