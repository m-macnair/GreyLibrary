#ABSTRACT: General wrapper for subjects
package GreyLibraryMoo::Role::Subject::Admin;
use strict;
use warnings;
use Moo::Role;
use Carp;
use Data::Dumper;
use Try::Tiny;
our $VERSION = 'v1.0.10';
##~ DIGEST : 4b93d34a07da5a52f66caf1632762cc5

with qw/
  GreyLibraryMoo::Role::Combine::DB
  /;

sub tag_subject_id {
	my ( $self, $tag, $subject, $p ) = @_;

}

sub single_tag_subject_as_user {
	my ( $self, $tag, $subject_id, $user, $p ) = @_;
	$p ||= {};
	$tag = $self->process_single_tag_string( $tag );
	my $tag_id = $self->get_tag_id( $tag );

	my $res = $self->select( 'subject', qw/*/, {id => $subject_id} )->fetchrow_arrayref();
	unless ( $res ) {
		Carp::confess( "Subject id [$subject_id] did not return a row" );
	}

	my $params = {
		tag_id     => $tag_id,
		subject_id => $subject_id,
	};

	if ( $user ) {
		$params->{tagging_user_id} = $user;
	}

	#TODO: handle exists already
	$self->insert( 'subject_tag', $params );

}

1;
