package GreyLibrary::Model::SQLiteDB;
use Moose;
use namespace::autoclean;
extends 'Catalyst::Model::Adaptor';
__PACKAGE__->config( class => 'Moo::Class::GLDB' );

sub prepare_arguments {
	my ( $self, $c ) = @_;
	return $c->config->{'GreyLibrary::Model::SQLiteDB'};
}

__PACKAGE__->meta->make_immutable;

1;
