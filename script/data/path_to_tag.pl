#!/usr/bin/perl
# ABSTRACT: convert every subject's path to corresponding tags
our $VERSION = 'v0.0.8';

##~ DIGEST : 0855208b09dfddb4f5f28deebefbb814

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
		$self->sqlite3_file_to_dbh(
			$p->{db_file},
			{
				AutoCommit => 0
			}
		);
	} else {
		die "db_file not provided";
	}
}

sub process {
	my ( $self ) = @_;
	$self->_do_db( $self->cfg() );

	my @mask_strings = ( '/mnt/X1/gl/', 'Mid/' );

	my @single_tag_strings = ( 'The Big Archive', 'The New Archive', 'Welcome Boxes', );

	#Step 1; get all subjects we care about - note this is for the first pass
	my $sth = $self->query(
		q{
		select s.* from file f 
		join subject_files sf 
			on f.id = sf.file_id 
		join subject s 
			on sf.subject_id = s.id
		join preview_file pf
			on pf.original_id = f.id
		left join subject_tag st
			on s.id = st.subject_id 
		where st.id is null
		}
	);
	while ( my $this_row = $sth->fetchrow_hashref() ) {
		my @these_tags;

		my $working_string = $this_row->{string};
		for my $mask_string ( @mask_strings ) {
			$working_string =~ s/$mask_string//g;

		}
		for my $single_tag_string ( @single_tag_strings ) {
			if ( index( $working_string, $single_tag_string ) != 1 ) {
				push( @these_tags, $single_tag_string );
				$working_string =~ s/$single_tag_string//g;
			}
		}

		my @path_parts = split( '/', $working_string );
		my $file       = pop( @path_parts );
		use Data::Dumper;

		for ( @path_parts ) {

			my @path_tag_strings = split( m#[\s,-,\.]#, $_ );
			for my $tag ( @path_tag_strings ) {
				next if length( $tag ) <= 1;
				push( @these_tags, $tag );
			}
		}
		for my $file_tag ( split( m#[\s,-,\.,_]#, $file ) ) {
			next if length( $file_tag ) <= 1;
			push( @these_tags, $file_tag );
		}

		# 		for my $this_tag (@these_tags){
		# 			$self->get_tag_id($this_tag);
		# 		}
		# 		warn Dumper(@these_tags);
		my $res = $self->tag_this_subject_id( $this_row->{id}, \@these_tags );
		print "[$this_row->{id}] - $this_row->{string}]$/";
		$self->commit_maybe();
	}
	$self->commit_force();
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
			optional => {
				path_filter => 'string to filter out from subject paths',

			}
		}
	);
	$self->process();

}

