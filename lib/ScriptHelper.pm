#ABSTRACT: Use DBI::Abstract and SQLite for arbitrary working databases
package ScriptHelper;
our $VERSION = 'v1.1.3';
##~ DIGEST : c7f0dc224cd953e342f7b9ad624de796
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
	my $conf = $self->config_file( '/home/m/Hobby/Hobby-Code/GreyLibrary/greylibrary.perl' );

	$self->sqlite3_file_to_dbh( $conf->{sqlite_path} );

}
1;
