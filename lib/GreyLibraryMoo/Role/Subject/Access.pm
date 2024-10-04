#ABSTRACT: General wrapper for subjects
package GreyLibraryMoo::Role::Subject::Access;
use strict;
use warnings;
use Moo::Role;
use Carp;
use Data::Dumper;
use Try::Tiny;
our $VERSION = 'v1.0.11';
##~ DIGEST : f0ea1c01e9bcb5d9c023c0e37fbe31d7

with qw/
  GreyLibraryMoo::Role::Combine::DB
  /;

#TODO: - determine single thumbnail (?)
#read_subject - get everything relevant about a single conceptual subject
sub read_subject {
	my ( $self, $id ) = @_;

	#this is one case that a result set would have value I think
	my $subject_row = $self->select( 'subject', qw/*/, {id => $id} )->fetchrow_hashref();

	return {fail => "subject [$id] not found"} unless $subject_row;

	my $subject_file_row = $self->select( 'subject_files', qw/*/, {subject_id => $id, file_type => 'primary'} )->fetchrow_hashref();
	return {fail => "No files found for subject [$id] "} unless $subject_file_row;

	my $thumb_file_path = $self->get_thumbnail_path_for_file_id( $subject_file_row->{file_id}, {existing => 0} );
	return {fail => "Thumbnail file not found for subject [$id] file id [$subject_file_row->{file_id}] "} unless $thumb_file_path;

	#TODO: tags
	#TODO: groups
	#TODO: ???

	return {
		pass            => 1,
		subject_id      => $id,                   # this will legitimately change one day e.g. when aliased
		thumb_file_path => $thumb_file_path,
		string          => $subject_row->{string},
	};

}

1;
