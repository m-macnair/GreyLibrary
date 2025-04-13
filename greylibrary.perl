#ABSTRACT: default config
use strict;
use warnings;
use Config::Any::Merge;
our $VERSION = 'v0.0.4';

##~ DIGEST : 00d4e1fc67f3e2a5a2a6ff6d5e5195c1

#Host specific configuration
my $ec = {};

for my $file (qw/host_config.perl site_config.perl/){
	my $path = "./etc/local/$file";
	if ( -e  $path ) {
		my $this_config = Config::Any::Merge->load_files( {files => [$path ], use_ext => 1} );
		$ec = { %{$ec}, %{$this_config} };
	}
}


my $thumbnail_dir = $ec->{thumbnail_dir}  || './root/srv/thumb/' ;

return {
	name                      => 'GreyLibrary',
	'GreyLibrary::Model::GLM' => {
		host                 => 'localhost',
		driver               => 'mysql',
		port                 => '3306',
		db                   => 'gl2',
		user                 => 'gl2',
		pass                 => 'gl2',
		%{$ec->{db} || {}},
		
		thumbnail_dir        => $thumbnail_dir,
		mysql_auto_reconnect => 1,
	},
	'Plugin::Authentication' => {
			realms        => {
				discord => {
					credential => {
					client_id => '',
					client_secret => 
					
					}
					}
					}
	}
	
	thumbnail_dir => $thumbnail_dir,

	%{$ec},
};
