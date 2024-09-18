#!/usr/bin/perl
# ABSTRACT:
our $VERSION = 'v0.0.8';

##~ DIGEST : d8bfff96ad8f2fa425f54652eea0fdc8

use strict;
use warnings;

package Obj;
use Moo;
use parent 'Moo::GenericRoleClass::CLI'; #provides  CLI, FileSystem, Common
use GreyLibraryMoo::Class::SQLite;
use Try::Tiny;

sub setup {
	my ( $self, $p ) = @_;
	my $glm = GreyLibraryMoo::Class::SQLite->new( $p );
	$p ||= {};
	if ( $p->{db_file} ) {
		$glm->sqlite3_file_to_dbh( $p->{db_file} );
	} else {
		die "db_file not provided";
	}
	$self->{glm} = $glm;
}

#TODO: associate thumbnail with file
sub process {
	my ( $self ) = @_;

	$self->setup( $self->cfg() );
	my $glm         = $self->{glm};
	my $backlog_sth = $glm->query(
		q{
		select f.* from file f 
		inner join subject_files sf
			on f.id = sf.file_id
		left join preview_file pfo
			on f.id = pfo.original_id
		left join preview_file pfp
			on f.id = pfp.preview_id
		join file_type ft
			on f.file_type_id = ft.id 
		left join file_meta fm
			on fm.file_id = f.id
		where 
			pfp.preview_id is null
			and pfo.id is null
			and ft.class = "Image"
			and fm.no_preview is null
	}
	);
	while ( my $row = $backlog_sth->fetchrow_hashref() ) {
		print "Working on file [$row->{id}]$/";
		try {
			$glm->get_thumbnail_path_for_file_id( $row->{id} );
		} catch {
			print "Unhandled failure in thumbnail generation - marking $row->{id} for no preview$/";
			$glm->insert( 'file_meta', {file_id => $row->{id}, no_preview => 1} );
		}
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

