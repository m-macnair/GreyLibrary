#!/usr/bin/perl
# ABSTRACT:
our $VERSION = 'v0.0.3';

##~ DIGEST : 60aad6d9e2fe1abe944f3a50b404ced1

BEGIN {
	push( @INC, "./lib/" );
	push( @INC, "../lib/" );
}

use strict;
use warnings;

package Obj;
use Moo;
use parent qw/
  Moo::Class::GLDB
  Moo::GenericRoleClass::CLI
  /; #provides  CLI, FileSystem, Common
with qw/
  ScriptHelper
  Moo::ComplexRole::FileIDDB
  Moo::ComplexRole::TagDB
  /;

sub process {
	my ( $self, $string, $page, $want ) = @_;
	die "nothing to search for" unless $string;
	$self->default_setup();
	my $results = $self->search_string( $string, $want, $page );
	print Dumper( $results );
}
1;

package main;

main( @ARGV );

sub main {
	my ( $string, $opt ) = @_;
	my $self = Obj->new();
	$self->process( $string, $opt );

}
