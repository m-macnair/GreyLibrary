package GreyLibrary::Controller::Subject::Collection;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

GreyLibrary::Controller::Subject::Collection - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : CaptureArgs(1) {
	my ( $self, $c, $page ) = @_;

	#todo make variable
	my $collection_string = 'wishlist';

	unless ( $c->user->{gl_data}->{id} ) {
		die "nope";
	}
	my $limit   = 20;
	my $offset  = $page ||= 1;
	my $user_id = $c->user->{gl_data}->{id};
	my $glm     = $c->model( 'GLM' );

	my $id            = $glm->get_user_collection_id( $user_id, $collection_string );
	my $sth           = $glm->query( 'select subject_id from subject_collection where collection_id =? limit ? offset ? ', $user_id, $limit, $offset );
	my $subject_stack = $glm->get_column_array( $sth );

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
	my $next_string;
	if ( scalar( @result_stack ) > $limit ) {
		$next_string = "/subject/collection/" . ( $page + 1 );
	}
	$c->stash(
		{
			next_string  => $next_string,
			search_page  => $page,
			gallery_data => \@result_stack,
			template     => 'gallery.tt',
		}
	);
}

__PACKAGE__->meta->make_immutable;

1;
