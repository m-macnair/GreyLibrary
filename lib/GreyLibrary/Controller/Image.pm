package GreyLibrary::Controller::Image;
use Moose;
use namespace::autoclean;

BEGIN {
	extends 'Catalyst::Controller';
}

sub get_untagged : Private : CaptureArgs(2) {
	my ( $self, $c, $want, $offset ) = @_;
	$want   ||= 1;
	$offset ||= 0;
	warn "want: $want";
	warn "offset: $offset";
	my $res = $c->model( 'SQLiteDB' )->query(
		q<
		select f.rowid 
		from files f
		join suffix s
			on f.suffix_id = s.rowid
		left join tag_map m
			on f.rowid = m.subject_id
		where 
			m.rowid is null
		and
			s.suffix = ".jpg"
		LIMIT ?
		OFFSET ?
	>, $want, $offset
	);
	my @response_stack;

	while ( my $row = $res->fetchrow_arrayref() ) {
		my $msg       = $c->model( 'SQLiteDB' )->find_id_path( $row->[0] );
		my $file_path = $msg;
		push(
			@response_stack,
			{
				ketsu_string => $file_path,
				image_url    => $msg,
				image_id     => $row->[0],
			}
		);
	}
	return \@response_stack;

}

sub search_string : Private : Args(2) {
	my ( $self, $c, $string, $want, $page ) = @_;
	my $results = $self->search_string( $string, $want, $page );
	return $results;
}

__PACKAGE__->meta->make_immutable;

1;
