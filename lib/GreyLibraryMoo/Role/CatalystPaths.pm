#ABSTRACT: Role for changing path strings to apply to the catalyst environment
package GreyLibraryMoo::Role::CatalystPaths;
use strict;
use warnings;
use Moo::Role;
use Carp;
use Data::Dumper;
our $VERSION = 'v1.0.11';
##~ DIGEST : 3b0f6bc509fe1644b5916661ae8e5f30

sub filter_thumb_path {
	my ( $self, $path ) = @_;

	$path =~ s|./root/||;
	$path =~ s|/root/||;
	
	return $path;

}

1;
