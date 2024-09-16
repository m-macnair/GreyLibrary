#!/usr/bin/perl
# ABSTRACT: generate the db entries to associate files with corresponding subjects - this is the first step in a two stage process where the second one prunes them down
our $VERSION = 'v0.0.7';

##~ DIGEST : 475b23af23578e728927c521af67126a

use strict;
use warnings;

package Obj;
use Moo;
use parent 'Moo::GenericRoleClass::CLI'; #provides  CLI, FileSystem, Common
with qw/
  GreyLibraryMoo::Role::Subject::Admin
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

	#Step 1; get all files that are not associated with a subject
	my $backlog_sth = $self->query(
		q{
		select f.* from file f 
		left join subject_files sf
			on f.id = sf.file_id
		where sf.id is null
	}
	);
	my $pf = $self->cfg()->{path_filter};
	while ( my $file_row = $backlog_sth->fetchrow_hashref() ) {
		my $path = $self->get_file_path_from_id( $file_row->{id} );
		if ( $pf ) {
			$path =~ s/$pf//;
		}
		print "Working on [$path]$/";
		my $existing = $self->read_subject_id( $path );
		if ( $existing ) {
			print "[$path] is already a subject, skipping $/";
			next;
		} else {
			my $subject_id = $self->get_subject_id( $path );
			print "Assigned subject_id [$subject_id] to [$path]$/";
			$self->insert(
				'subject_files',
				{
					subject_id => $subject_id,
					file_id    => $file_row->{id},
					file_type  => 'primary'
				}
			);
			print "Assigned file_id [$file_row->{id}] to subject_id [$subject_id]$/";
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
			  path_filter
			  /
		],
		{
			required => {
				db_file => "./working_db.sqlite in most cases",

			},
			optional => {
				path_filter => 'string to filter out from subject paths',

			}
		}
	);
	$self->process();

}

