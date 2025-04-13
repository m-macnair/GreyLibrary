#ABSTRACT: default config
use strict;
use warnings;
use Config::Any::Merge;
our $VERSION = 'v0.0.4';

##~ DIGEST : 00d4e1fc67f3e2a5a2a6ff6d5e5195c1

#Host specific configuration
my $ec = {};
if ( -e './etc/local/site_config.perl' ) {
	$ec = Config::Any::Merge->load_files( {files => ['./etc/local/site_config.perl'], use_ext => 1} );
}

return {
	name                      => 'GreyLibrary',
	'GreyLibrary::Model::GLM' => {
		host                 => 'localhost',
		driver               => 'mysql',
		port                 => '3306',
		db                   => 'gl2',
		user                 => 'gl2',
		pass                 => 'gl2',
		thumbnail_dir        => './root/srv/thumb/',
		mysql_auto_reconnect => 1,
	},
	thumbnail_dir => './root/srv/thumb/',

	%{$ec},
};
