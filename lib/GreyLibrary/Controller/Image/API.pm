package GreyLibrary::Controller::Image::API;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

GreyLibrary::Controller::API::Image - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {
	my ( $self, $c ) = @_;

	$c->response->body( 'Matched GreyLibrary::Controller::API::Image in API::Image.' );
}

sub tag_file : Local : Args(2) {
	my ( $self, $c, $id, $tag ) = @_;

	if ( $c->session->{user_id} ) {
		my $res = $c->model( 'SQLiteDB' )->tag_subject_id( $tag, $id, {user_id => $c->session->{user_id}} );
		$c->response->body( 'tagged by user [' . $c->session->{user_id} . ']' );

	} else {
		die "nope";
	}

}

sub get_untagged : Local : CaptureArgs(1) {
	my ( $self, $c, $want ) = @_;
	$want ||= 1;
	my $stack = $c->forward( qw/GreyLibrary::Controller::Image get_untagged/ );

	my $find    = '/mnt/X0/gl/Mid/The Big Archive/';
	my $replace = 'http://212.227.199.157/tba/';
	for my $row ( @{$stack} ) {
		$row->{image_url} =~ s/$find/$replace/g;
	}
	require JSON;
	my $response_json = JSON::encode_json( $stack );
	use Data::Dumper;
	warn Dumper( $response_json );
	$c->response->body( $response_json );
}

=encoding utf8

=head1 AUTHOR

m,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
