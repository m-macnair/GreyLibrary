#!/usr/bin/perl
# ABSTRACT:
our $VERSION = 'v0.0.4';

##~ DIGEST : 580d0d99cf9bc92e5cb7b45e5ca22e5e

use strict;
use warnings;

package Obj;
use Moo;
use parent 'Moo::GenericRoleClass::CLI'; #provides  CLI, FileSystem, Common
with qw/
  GreyLibraryMoo::Role::Thumb
  /;

sub process {
	my ( $self, $in, $out ) = @_;
	print $self->generate_thumbnail( $in, $out );
}
1;

package main;

main( @ARGV );

sub main {
	my ( $in, $out ) = @_;
	my $self = Obj->new();
	$self->process( $in, $out );

}

