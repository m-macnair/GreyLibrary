#ABSTRACT: Role for changing path strings to apply to the catalyst environment
package GreyLibraryMoo::Role::CatalystPaths;
use strict;
use warnings;
use Moo::Role;
use Carp;
use Data::Dumper;
our $VERSION = 'v1.0.13';
##~ DIGEST : 16ef2d80b02425379566cf4c695864d3

sub filter_thumb_path {
	my ( $self, $path ) = @_;

	$path =~ s|./root/||;
	$path =~ s|/root/||;
	$path = "http://212.227.199.157:3000/$path";

	# 	$path ="/$path";
	return $path;

}

1;
