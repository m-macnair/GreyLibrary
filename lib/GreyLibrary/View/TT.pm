package GreyLibrary::View::TT;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config(
	{
		INCLUDE_PATH => [ GreyLibrary->path_to( 'root', 'templates', 'site' ), GreyLibrary->path_to( 'root', 'templates', 'lib' ), GreyLibrary->path_to( 'root', 'templates', 'lib', 'catalyst_templates' ) ],

		PRE_PROCESS => 'config/main',
		WRAPPER     => 'site/gl_1.tt',

		# 	ERROR        => 'error.tt2',
		TIMER      => 0,
		render_die => 1,

		TEMPLATE_EXTENSION => '.tt',
	}
);

1;

