#!/usr/bin/perl
# ABSTRACT:
our $VERSION = 'v0.0.3';

##~ DIGEST : 5d8943bc11c20c663e5dc5548c4b28f9

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

sub process {
	my ( $self, $path ) = @_;
	$self->default_setup();
	if ( -f $path ) {
		my $id     = $self->get_file_id( $path );
		my $string = $self->generate_store_subject_md5( $id );
	} elsif ( -d $path ) {
		$self->sub_on_find_files(
			sub {
				my ( $this_path ) = @_;
				my $id            = $self->get_file_id( $this_path );
				my $string        = $self->generate_store_subject_md5( $id );
				print "$this_path : $id : $string$/";
				return 1;
			},
			$path
		);

	}

}
1;

package main;

main( @ARGV );

sub main {
	my ( $path ) = @_;
	my $self = Obj->new();
	$self->process( $path );

}
