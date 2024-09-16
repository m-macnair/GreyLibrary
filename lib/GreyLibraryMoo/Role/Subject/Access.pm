#ABSTRACT: General wrapper for subjects
package GreyLibraryMoo::Role::Subject::Access;
use strict;
use warnings;
use Moo::Role;
use Carp;
use Data::Dumper;
use Try::Tiny;
our $VERSION = 'v1.0.9';
##~ DIGEST : 454920b5dc70e1ad31b04c7afeb8c336

with qw/
  GreyLibraryMoo::Role::Combine::DB
  /;

#TODO: - determine single thumbnail
sub read_subject {
	my ( $self, $id ) = @_;

	#this is one case that a result set would have value I think

	my $subject_row = $self->query( 'select * from subject where id = ?', $id )->fetchrow_hashref();
	return {fail => 'subject not found'};
	my $files_rs = $self->query( 'select * from subject_files where subject_id = ?', $id );

}

1;
