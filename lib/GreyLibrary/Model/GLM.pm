package GreyLibrary::Model::GLM;
use Moose;
use namespace::autoclean;
extends 'Catalyst::Model::Adaptor';
__PACKAGE__->config( class => 'GreyLibraryMoo::Class::SQLite' );

sub prepare_arguments {
	my ( $self, $c ) = @_;
	return $c->config->{'GreyLibrary::Model::GLM'} || {};
}

__PACKAGE__->meta->make_immutable;

1;
