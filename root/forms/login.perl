#ABSTRACT: default config
use strict;
use warnings;
my $indicator = 'submit';
return {
	indicator => $indicator,
	elements  => [
		{
			type        => 'Text',
			label       => 'User',
			name        => 'user',
			constraints => [ {type => 'Required'} ]
		},
		{
			type        => 'Password',
			label       => 'Password',
			name        => 'pass',
			constraints => [ {type => 'Required'} ]
		},

		{
			type  => 'Submit',
			name  => $indicator,
			value => 'login',
		},
	]
};

1;
