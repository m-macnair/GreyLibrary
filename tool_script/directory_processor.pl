#!/usr/bin/perl
# ABSTRACT:
our $VERSION = 'v0.0.4';

##~ DIGEST : 5466ef678dd3b82d17df2568257aad64

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
use Data::Dumper;

sub process {
	my ( $self, $path ) = @_;
	$self->default_setup();
	if ( -f $path ) {
		$self->process_file( $path );

	} elsif ( -d $path ) {
		$self->sub_on_find_files(
			sub {
				my ( $this_path ) = @_;
				$self->process_file( $this_path );
				return 1;
			},
			$path
		);

	}

}

sub process_file {
	my ( $self, $path ) = @_;
	my $id     = $self->get_file_id( $path );
	my $hashes = $self->get_hashes_for_file( $path );
	$self->set_file_id_extra( $id, $hashes );

}
1;

package main;

main( @ARGV );

sub main {
	my ( $path ) = @_;
	my $self = Obj->new();
	$self->process( $path );

}
