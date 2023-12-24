#ABSTRACT: coherent system to store tag strings against arbitrary subject ID values
package Moo::Class::GLDB;
use strict;
use warnings;
use Moo;
use Carp;
use Data::Dumper;

our $VERSION = 'v1.0.7';
##~ DIGEST : 4fdd4a4f97f7ea4556f99a65fbc21d02

with qw/
  Moo::ComplexRole::TagDB
  Moo::ComplexRole::FileIDDB
  /;

sub dbh {
	Moo::GenericRole::DB::SQLite::sqlite_dbh( @_ );
}

sub search_string {
	my ( $self, $search_string, $want, $page ) = @_;
	$want ||= 10;
	$page ||= 1;

	my $offset = ( $want * ( $page - 1 ) );

	$offset = 0 if ( $offset < 0 );
	warn "want: $want, page : $page, offset : $offset - string: $search_string";
	my $file_search_sth = $self->dbh->prepare( "
		select f.rowid
			from files f
		join suffix s
			on f.suffix_id = s.rowid
		where 
			lower(file_name) like ? 
		and 
			s.suffix = '.jpg'
		limit ? 
		offset ? " ) or die $!;
	$file_search_sth->execute( '%' . lc( $search_string ) . '%', $want, $offset );
	return $file_search_sth->fetchall_arrayref();
}

1;
