#ABSTRACT: default config
use strict;
use warnings;
use Config::Any::Merge;
our $VERSION = 'v0.0.2';

##~ DIGEST : 2c8b57bc0a4aa8e50c980e29da92fb1e

my $ec = {};
if ( -e './etc/local/site_config.perl' ) {
	$ec = Config::Any::Merge->load_files( {files => ['./etc/local/site_config.perl'], use_ext => 1} );
}

my $sqlite_path = "./db/working_db.sqlite";

return {
	name                      => 'GreyLibrary',
	'GreyLibrary::Model::GLM' => {
		db_file       => $sqlite_path,
		thumbnail_dir => './root/srv/thumb/',
	},
	sqlite_path   => $sqlite_path,
	thumbnail_dir => './root/srv/thumb/',
	db_file       => $sqlite_path,
	%{$ec},
};
