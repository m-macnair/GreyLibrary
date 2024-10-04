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
	my ( $self, $c, $string, $page ) = @_;

	$page ||= 0;

	# 	warn "searching for " . $string;
	my $glm       = $c->model( 'GLM' );
	my $tag_stack = $glm->tag_string_to_id_aref( lc( $string ) );
	use Data::Dumper;
	warn Dumper( $tag_stack );
	my $subject_stack = $glm->intersect_search_arref_subject_ids(
		$tag_stack,
		{
			page => $page
		}
	);

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

	my $next_string = "/search/$string/" . ( $page + 1 );
	warn "next string: $next_string";
	$c->stash(
		{
			next_string   => $next_string,
			search_string => $string,
			search_page   => $page,
			gallery_data  => \@result_stack,
			template      => 'gallery.tt',
		}
	);

}

sub form : Path : args(0) {
	my ( $self, $c ) = @_;
	if ( $c->request->method eq 'POST' ) {
		if ( $c->request->params->{search_string} ) {
			$c->res->redirect( $c->uri_for( "/search", $c->request->param( 'search_string' ), 1 ) );
		}
	}

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
