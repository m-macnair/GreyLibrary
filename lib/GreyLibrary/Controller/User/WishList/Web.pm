package GreyLibrary::Controller::User::WishList::Web;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

GreyLibrary::Controller::User::WishList::Web - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Default : Args(0) {
	my ( $self, $c ) = @_;
	my $row_sth = $c->model( 'SQLiteDB' )->query(
		q<
		select f.rowid 
		from files f
		join suffix s
			on f.suffix_id = s.rowid
		join tag_map m
			on f.rowid = m.subject_id
		join tag t
			on m.tag_id = t.rowid
		where 
			m.user_id =? 
		and 
			t.tag = ?
	>, $c->session->{user_id}, 'want'
	);
	$c->stash(
		{
			template       => 'user/wishlist/index.tt',
			wish_list_rows => $row_sth->fetchall_arrayref()
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
