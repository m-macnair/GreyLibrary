package GreyLibrary::Controller::Subject;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

GreyLibrary::Controller::Subject - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

#TODO: use GLM::Role::Subject

sub index : Path : Args(1) {
	my ( $self, $c, $subject_id ) = @_;
	my $glm     = $c->model( 'GLM' );
	my $subject = $glm->read_subject( $subject_id );

	if ( $subject->{fail} ) {
		$c->stash( {%{$subject}} );

	}

	my $thumb_path = $glm->filter_thumb_path( $subject->{thumb_file_path} );

	my ( $right, $mid, $left ) = $self->get_extended_tags();
	$c->stash(
		{
			subject_id   => $subject->{subject_id},
			subject_data => $subject,
			img_url      => $thumb_path,
			tags_right   => $right,
			tags_mid     => $mid,
			tags_left    => $left,
		}
	);
}

sub get_extended_tags : Private {
	my ( $self, $c ) = @_;

	my $right = [ "40k",        "SM",      "IG", "Imperial", "Bases" ];
	my $mid   = [ "WH Fantasy", "Terrain", "Xenos" ];
	my $left  = [ "Chaos",      "LOTR",    "Cosplay", "Gimick", "Sci-Fi", "Generic Fantasy", "Lewd" ];
	return ( $right, $mid, $left );
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
