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


#this catches everything on the controller and I MUST learn why
sub string : Path : Args(2) {
	my ( $self, $c, $string,$page  ) = @_;

	$page ||= 1;
	my $results = 20;
	warn "searching for " . $string;
	my $glm     = $c->model( 'GLM' );
	
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

	my $next_string = "/search/$string/" . ($page +1);
	warn "next string: $next_string";
	$c->stash(
		{
			next_string => $next_string,
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
