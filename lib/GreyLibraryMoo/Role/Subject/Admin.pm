#ABSTRACT: General wrapper for subjects
package GreyLibraryMoo::Role::Subject::Admin;
use strict;
use warnings;
use Moo::Role;
use Carp;
use Data::Dumper;
use Try::Tiny;
our $VERSION = 'v1.0.9';
##~ DIGEST : 23510b3b13eabf844a7f9a52fe8aadd1

with qw/
  GreyLibraryMoo::Role::Combine::DB
  /;

sub set_subject_thumbnail {
	my ( $self, $subject_id, $thumbnail_file_id ) = @_;

}

1;
