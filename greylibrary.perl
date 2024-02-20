
#ABSTRACT: default config 
use strict;
use warnings;

my $sqlite_path = '/home/m/git/GreyLibrary/db/path_db_template.sqlite';

return {
	name => 'GreyLibrary',
	'GreyLibrary::Model::SQLiteDB' => {
		sqlite_path => $sqlite_path,
	},
	sqlite_path => $sqlite_path,
	thumbnail_directory => '/home/m/Hobby/Hobby-Code/GreyLibrary/root/static/thumb/',
};

1;
