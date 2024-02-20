#!/usr/bin/perl
# ABSTRACT:
our $VERSION = 'v0.0.4';

##~ DIGEST : 3c6583e49ab39e26a39fcd6e61e0204a

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
	die $self->{sqlite_path};

}

1;

package main;

main( @ARGV );

sub main {
	my ( $path ) = @_;
	my $self = Obj->new();
	$self->process( $path );

}
