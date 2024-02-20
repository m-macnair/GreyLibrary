#ABSTRACT: Use DBI::Abstract and SQLite for arbitrary working databases
package ScriptHelper;
our $VERSION = 'v1.1.4';
##~ DIGEST : a3d9ee99ae9bfdd979aaf70b047f3462
use Try::Tiny;
use Moo::Role;
use Carp;
with qw/

  Moo::GenericRole::ConfigAny
  Moo::GenericRole::DB
  Moo::GenericRole::DB::Abstract
  Moo::GenericRole::DB::SQLite
  Moo::GenericRole::DB::Working::AbstractSQLite
  /;

sub default_setup {
	my ( $self, $path, $opt ) = @_;
	$opt ||= {};
	my $conf = $self->config_file( '/home/m/git/GreyLibrary/greylibrary.perl' );
	$self->sqlite3_file_to_dbh( $conf->{sqlite_path} );

}
1;
