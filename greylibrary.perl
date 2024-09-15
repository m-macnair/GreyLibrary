#ABSTRACT: default config
use strict;
use warnings;

my $sqlite_path = "./db/working_db.sqlite";

return {
	name                           => 'GreyLibrary',
	'GreyLibrary::Model::SQLiteDB' => {
		sqlite_path => $sqlite_path,
	},
	sqlite_path   => $sqlite_path,
	thumbnail_dir => './srv/',
	db_file       => $sqlite_path,
	hostname      => 'alkonos',
};

1;
