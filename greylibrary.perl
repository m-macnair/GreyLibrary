
#ABSTRACT: default config 
use strict;
use warnings;
return {
	name => 'GreyLibrary',
	'GreyLibrary::Model::SQLiteDB' => {
		sqlite_path => "./db/path_db.sqlite"
	}
};

1;
