package GreyLibrary::Controller::Search;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

GreyLibrary::Controller::Search - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub string : Path : CaptureArgs(2) {
	my ( $self, $c, $page, $string ) = @_;

	$page ||= 1;
	my $results = 20;
	my $glm     = $c->model( 'GLM' );
	warn "searching for " . $string;
	my $subject_stack = $glm->search_tag_string( $string, $results, $page );

	my @result_stack;

	for ( @{$subject_stack} ) {
		push(
			@result_stack,
			{
				subject_id      => $_,
				thumb_file_path => $glm->filter_thumb_path( $glm->read_subject( $_ )->{thumb_file_path} )
			}
		);
	}

	$c->stash(
		{
			search_string => $string,
			search_page   => $page,
			gallery_data  => \@result_stack,
			template      => 'gallery.tt',
		}
	);

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
