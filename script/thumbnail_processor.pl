#!/usr/bin/perl
# ABSTRACT:
our $VERSION = 'v0.0.3';

##~ DIGEST : e2c08a5ef9db9e8e14263e96e5dbe26d

BEGIN {
	push( @INC, "./lib/" );
	push( @INC, "../lib/" );
}

use strict;
use warnings;

package Obj;
use Moo;
use parent 'Moo::GenericRoleClass::CLI'; #provides  CLI, FileSystem, Common
with qw/
  ScriptHelper
  Moo::ComplexRole::FileIDDB
  Moo::ComplexRole::TagDB
  /;
use Image::Magick;

sub process {
	my ( $self, $file_id ) = @_;
	$self->default_setup();
	$self->augment_directory_sub(
		sub {
			my ( $path ) = @_;

			my $find    = '/mnt/X0/';
			my $replace = '/home/m/remote/X0/';
			$path =~ s|$find|$replace|;
			return $path;
		}
	);

	my $in_path = $self->find_id_path( $file_id );
	my $image   = Image::Magick->new;

	# Read the input image file
	$image->Read( $in_path );

	# Scale down the image to create a thumbnail
	$image->Scale( geometry => '300x300' );

	# Set the thumbnail image quality
	$image->Set( quality => 50 );

	my $out_path = "./$file_id\_thumb.jpg";

	# Write the thumbnail image to the output file
	$image->Write( $out_path );

	# Clean up resources
	#$image->Clear;

	# Print a success message
	print "Thumbnail image created: $out_path\n";

}
1;

package main;

main( @ARGV );

sub main {
	my ( $file_id ) = @_;
	my $self = Obj->new();
	$self->process( $file_id );

}

