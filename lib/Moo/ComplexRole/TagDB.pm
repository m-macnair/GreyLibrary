#ABSTRACT: coherent system to store tag strings against arbitrary subject ID values
package Moo::ComplexRole::TagDB;
use strict;
use warnings;
use Moo::Role;
use Carp;
use Data::Dumper;

our $VERSION = 'v1.0.7';
##~ DIGEST : 315a90f3b9fd088d5965b8e3db76dfde

=head1 NAME
	Moo::Role::FileIDDB - CRUD for a db containing file paths 

=cut

with qw/
  Moo::GenericRole::FileSystem
  Moo::GenericRole::DB
  Moo::GenericRole::DB::Abstract
  Moo::GenericRole::DB::SQLite
  /;

ACCESSORS: {
	has subject_table => (
		is      => 'rw',
		lazy    => 1,
		default => sub {
			return 'files';
		}
	);

	has subject_table_id => (
		is      => 'rw',
		lazy    => 1,
		default => sub {
			return 'rowid';
		}
	);

	has distinct_tag_sth => (
		is      => 'rw',
		lazy    => 1,
		default => sub {
			my ( $self ) = @_;
			return $self->dbh->prepare( 'select distinct(tag) from tag t join tag_map m on m.tag_id = t.rowid where m.subject_id = ? ' );
		}
	);

}

sub tag_subject_id {
	my ( $self, $tag_string, $subject_id, $p ) = @_;
	for my $tag ( split( ' ', $tag_string ) ) {
		$self->add_tag_to_subject_id( $tag, $subject_id, $p );
	}

}

sub set_tag_string_for_subject {
	my ( $self, $subject_id, $p ) = @_;
	$self->distinct_tag_sth->execute( $subject_id );
	my $tag_string;

	while ( my $row = $self->distinct_tag_sth->fetchrow_arrayref() ) {
		$tag_string .= "$row->[0] ";
	}
	$tag_string =~ s/^\s+|\s+$//g;

	#it's possible a subject doesn't have a tag string
	my ( $current_string, $row ) = $self->find_tag_string( $subject_id );

	if ( scalar( $row ) ) {

		$self->update(
			'tag_string',
			{
				tag_string => $tag_string
			},
			{subject_id => $subject_id}
		);
	} else {

		$self->insert(
			'tag_string',
			{
				tag_string => $tag_string,
				subject_id => $subject_id
			}
		);
	}

}

sub find_tag_string {
	my ( $self, $subject_id, $p ) = @_;
	my $row = $self->select( 'tag_string', [qw/* rowid/], {subject_id => $subject_id} )->fetchrow_hashref();
	if ( $row ) {
		if ( wantarray ) {
			return ( $row->{tag_string}, $row );
		}
		return $row->{tag_string};
	}
	return;

}

sub add_tag_to_subject_id {
	my ( $self, $tag, $subject_id, $p ) = @_;
	$p ||= {};
	unless ( $p->{no_lc} ) {
		$tag = lc( $tag );
	}

	unless ( $p->{no_snake} ) {
		$tag =~ s/ /_/g;
	}

	my $tag_id = $self->get_tag_id( $tag );
	my $params = {
		tag_id     => $tag_id,
		subject_id => $subject_id,
	};

	if ( $p->{user_id} ) {
		$params->{user_id} = $p->{user_id};
	}
	$self->insert( 'tag_map', $params );
	if ( $p->{want_id} ) {
		my $row = $self->select( 'tag_map', $params )->fetchrow_hashref;
		return $row->{rowid};
	}
}

sub get_tag_id {
	my ( $self, $tag, $p ) = @_;

	confess( 'Tag not supplied' ) unless $tag;
	my $tag_id = $self->find_tag_id( $tag );
	unless ( $tag_id ) {
		$self->insert( 'tag', {tag => $tag} );
		$tag_id = $self->find_tag_id( $tag );
	}
}

sub find_tag_id {
	my ( $self, $tag, $p ) = @_;

	confess( 'Tag not supplied' ) unless $tag;
	my $row = $self->select( 'tag', [qw/* rowid/], {tag => $tag} )->fetchrow_hashref;
	return $row->{rowid};
}

1;
