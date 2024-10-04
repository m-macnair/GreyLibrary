#ABSTRACT: Role for changing path strings to apply to the catalyst environment
package GreyLibraryMoo::Role::CatalystPaths;
use strict;
use warnings;
use Moo::Role;
use Carp;
use Data::Dumper;
our $VERSION = 'v1.0.12';
##~ DIGEST : dbdd61aab628733be95e7cc50cc12c57

sub filter_thumb_path {
	my ( $self, $path ) = @_;

	$path =~ s|./root/||;
	$path =~ s|/root/||;

	return $path;

}

1;
