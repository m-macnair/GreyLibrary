#ABSTRACT: role for generating thumbnails and adding records about them
package GreyLibraryMoo::Role::Thumb;
use strict;
use warnings;
use Moo::Role;
use Carp;
use Data::Dumper;
use Try::Tiny;
our $VERSION = 'v1.0.9';
##~ DIGEST : debb2c318208c44fe82d7f7d1ab95dc4

with qw/
  GreyLibraryMoo::Role::Combine::DB
  /;

use Image::Magick;

ACCESSORS: {
	has thumbnail_dir => (
		is       => 'rw',
		required => 1
	);
}

#TODO: learn error handling
sub generate_thumbnail {
	my ( $self, $source_path, $target_path, $p ) = @_;
	$p ||= {};
	my $image = Image::Magick->new;

	# Read the input image file
	$image->Read( $source_path );

	# Scale down the image to create a thumbnail
	$image->Scale( geometry => $p->{geometry} || '400x400' );

	# Set the thumbnail image quality
	$image->Set( quality => $p->{quality} || 50 );

	# Write the thumbnail image to the output file
	$image->Write( $target_path );
	die "failed to write thumbnail for [$source_path] to [$target_path], not written (!?) " unless -e $target_path;
	return 1;
}

sub get_thumbnail_path_for_file_id {
	my ( $self, $file_id, $p ) = @_;
	$p ||= {};

	my $meta_row = $self->select( 'file_meta', qw{*}, {file_id => $file_id} )->fetchrow_hashref();
	if ( $meta_row->{is_thumbnail} ) {
		Carp::confess( "Attempted to get a thumbnail from an existing thumbnail" );
	}

	my $row = $self->select( 'preview_file', qw{*}, {original_id => $file_id} )->fetchrow_hashref();

	if ( $row->{preview_id} ) {
		my $r = $self->get_file_path_from_id( $row->{preview_id} );
		if ( wantarray() ) {
			return ( $r, {existing => 1} );
		}
		return $r;
	}

	#don't generate if we only want existing
	return undef if $p->{existing};

	my $source_path = $self->get_file_path_from_id( $file_id );
	Carp::confess( "Source path [$source_path] not found" ) unless -e $source_path;
	my $target_path = $self->{thumbnail_dir} . "/$file_id\_thumb.jpg";
	$target_path =~ s|//|/|g;
	try {
		$self->generate_thumbnail( $source_path, $target_path );
	} catch {
		Carp::confess( @_ );
	};
	my $thumb_id = $self->get_file_id( $target_path );
	$self->insert(
		'file_meta',
		{
			file_id      => $thumb_id,
			is_thumbnail => 1
		}
	);

	$self->insert( 'preview_file', {original_id => $file_id, preview_id => $thumb_id} );
	return $target_path;

}

1;
