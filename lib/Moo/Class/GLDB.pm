#ABSTRACT: coherent system to store tag strings against arbitrary subject ID values
package Moo::Class::GLDB;
use strict;
use warnings;
use Moo;
use Carp;
use Data::Dumper;

our $VERSION = 'v1.0.8';
##~ DIGEST : 554830f08845770639454721851a51ac

with qw/
  GreyLibraryMoo::Role::Combine::DB
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
