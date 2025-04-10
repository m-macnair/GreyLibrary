#ABSTRACT: Role for changing path strings to apply to the catalyst environment
package GreyLibraryMoo::Role::CatalystPaths;
use strict;
use warnings;
use Moo::Role;
use Carp;
use Data::Dumper;
our $VERSION = 'v1.0.14';
##~ DIGEST : 4efcb007e0057e84dd6197d51c04847a

sub filter_thumb_path {
	my ( $self, $path ) = @_;

	$path =~ s|./root/||;
	$path =~ s|/root/||;

	# 	$path = "http://212.227.199.157:3000/$path";

	# 	$path ="/$path";
	return $path;

}

1;
