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
	my $glm         = $c->model( 'GLM' );
	my $subject_row = $glm->select( 'subject', qw/*/, {id => $subject_id} )->fetchrow_hashref();
	die "subject not found" unless $subject_row;
	my $subject_file_row = $glm->select( 'subject_files', qw/*/, {subject_id => $subject_id, file_type => 'primary'} )->fetchrow_hashref();
	die "subject file found" unless $subject_file_row;

	my $thumb_file_path = $glm->get_thumbnail_path_for_file_id( $subject_file_row->{file_id}, {existing => 1} );
	warn "thumb file path: [$thumb_file_path]";
	$thumb_file_path =~ s|./root/|/|;

	my ( $right, $mid, $left ) = $self->get_window_tags();
	$c->stash(
		{
			template => 'image/web/standard_image_view.tt',
			img_url  => $thumb_file_path,

			tags_right => $right,
			tags_mid   => $mid,
			tags_left  => $left,
			tags       => [ @$right, @$mid, @$left ]
		}
	);
}

sub get_window_tags : Private {
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
