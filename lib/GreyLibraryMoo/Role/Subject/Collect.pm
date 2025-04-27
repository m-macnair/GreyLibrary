#ABSTRACT: General wrapper for subjects
package GreyLibraryMoo::Role::Subject::Collect;
use strict;
use warnings;
use Moo::Role;
use Carp;
use Data::Dumper;
use Try::Tiny;
our $VERSION = 'v1.0.13';
##~ DIGEST : c1e6f7642cb493c3e1d41b9db9e5df4a

#TODO: - determine single thumbnail (?)
#read_subject - get everything relevant about a single conceptual subject

sub add_subject_to_user_collection {
	my ( $self, $subject_id, $user_id, $collection_string ) = @_;

	my $wishlist_id = $self->get_user_collection_id( $user_id, $collection_string );
	my $row         = $self->select_insert_href(
		'subject_collection',
		{
			collection_id => $wishlist_id,
			subject_id    => $subject_id,
		}
	);
	return $row;
}

sub get_user_collection_id {
	my ( $self, $user_id, $collection_string ) = @_;
	my $row = $self->select_insert_href(
		'collection',
		{
			user_id => $user_id,
			string  => $collection_string,
		}
	);

	return $row->{id};
}

1;
