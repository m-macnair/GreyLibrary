#ABSTRACT: coherent system to store arbitrary files as IDs
package Moo::ComplexRole::FileIDDB;
use strict;
use warnings;
use Moo::Role;
use Carp;
use Data::Dumper;

our $VERSION = 'v1.0.3';
##~ DIGEST : f8a2fd93b460140f3966102f4413850d

=head1 NAME
	Moo::Role::FileIDDB - CRUD for a db containing file paths 

=cut

with qw/
  Moo::GenericRole::FileSystem
  Moo::GenericRole::DB
  Moo::GenericRole::DB::Abstract
  Moo::GenericRole::DB::SQLite
  /;

ACCESSORS: {
	has get_suffix_sth => (
		is      => 'rw',
		lazy    => 1,
		default => sub {
			my ( $self ) = @_;
			return $self->dbh->prepare( "select * from suffix where suffix = ?" );
		}
	);

	has get_dir_sth => (
		is      => 'rw',
		lazy    => 1,
		default => sub {
			my ( $self ) = @_;
			return $self->dbh->prepare( "select * from directory where directory = ?" );
		}
	);

	has augment_directory_sub => (
		is   => 'rw',
		lazy => 1,
	);

	has get_path_sth => (
		is      => 'rw',
		lazy    => 1,
		default => sub {
			my ( $self ) = @_;
			return $self->dbh->prepare( "
				select * from files as f 
				join directory as d 
					on f.directory_id = d.rowid 
				join suffix as s 
					on f.suffix_id = s.rowid 
				where f.rowid = ? " );
		}
	);

}

sub get_file_id {
	my ( $self, $path, $p ) = @_;
	$p ||= {};

	#set source id from various places
	Carp::confess( 'Path not supplied' ) unless $path;

	$path = $self->abs_path( $path );

	#split, get ids for parts. it's worth mentioning not all files need a suffix
	my ( $file_name, $directory, $suffix ) = $self->file_parse( $path );

	my $directory_id = $self->get_directory_id( $directory );
	my $suffix_id;
	if ( $suffix ) {
		$suffix_id = $self->get_suffix_id( $suffix );
	}
	my $file_id = $self->find_name_id( $directory_id, $file_name, $suffix_id );
	unless ( $file_id ) {
		$self->insert(
			'files',
			{
				directory_id => $directory_id,
				suffix_id    => $suffix_id,
				file_name    => $file_name
			}
		);
		$file_id = $self->find_name_id( $directory_id, $file_name, $suffix_id );
		confess( "Created row not found for [$file_name]" ) unless $file_id;
	}
	return $file_id;

}

sub get_directory_id {
	my ( $self, $directory, $p ) = @_;
	$p ||= {};
	Carp::confess( 'Dir not supplied' ) unless $directory;

	my $id = $self->find_directory_id( $directory );
	unless ( $id ) {
		$self->insert( 'directory', {directory => $directory} );
		my $row = $self->select( 'directory', [qw/* rowid/], {directory => $directory} )->fetchrow_hashref;
		confess( "Created row not found for [$directory]" ) unless $row;
		return $row->{rowid};
	}

}

sub find_directory_id {
	my ( $self, $directory, $p ) = @_;
	$p ||= {};
	confess( 'Directory not supplied' ) unless $directory;
	$self->get_dir_sth->execute( $directory );
	my $row = $self->get_dir_sth->fetchrow_hashref();
	return $row->{rowid};

}

sub get_suffix_id {
	my ( $self, $suffix, $p ) = @_;
	$p ||= {};
	Carp::confess( 'Suffix not supplied' ) unless $suffix;

	my $id = $self->find_suffix_id( $suffix );
	unless ( $id ) {
		$self->insert( 'suffix', {suffix => $suffix} );
		my $row = $self->select( 'suffix', [qw/* rowid/], {suffix => $suffix} )->fetchrow_hashref;
		confess( "Created row not found for [$suffix]" ) unless $row;
		return $row->{rowid};
	}

}

sub find_suffix_id {
	my ( $self, $suffix, $p ) = @_;
	$p ||= {};
	confess( 'Dir not supplied' ) unless $suffix;
	$self->get_suffix_sth->execute( $suffix );
	my $row = $self->get_suffix_sth->fetchrow_hashref();
	return $row->{rowid};

}

sub find_name_id {
	my ( $self, $directory_id, $file_name, $suffix_id, $p ) = @_;
	$p ||= {};

	my $row = $self->select(
		'files',
		[qw/* rowid/],
		{
			directory_id => $directory_id,
			suffix_id    => $suffix_id,
			file_name    => $file_name
		}
	)->fetchrow_hashref();
	return $row->{rowid};
}

sub augment_directory {
	my ( $self, $path ) = @_;
	if ( defined( $self->augment_directory_sub ) ) {
		my $ref = $self->augment_directory_sub();
		$path = &$ref( $path );

	}
	return $path;

}

sub find_id_path {
	my ( $self, $file_id, $p ) = @_;
	$self->get_path_sth->execute( $file_id );
	my $row       = $self->get_path_sth->fetchrow_hashref();
	my $directory = $self->augment_directory( $row->{directory} );
	if ( wantarray ) {
		return ( "$directory$row->{file_name}$row->{suffix}", $row );
	}

	return "$directory$row->{file_name}$row->{suffix}";

}

sub generate_store_subject_md5 {
	my ( $self, $file_id ) = @_;
	my $row = $self->select(
		'subject_md5',
		[qw/*/],
		{
			subject_id => $file_id
		}
	)->fetchrow_hashref();
	if ( $row ) {
		return $row->{md5};
	} else {
		my $path       = $self->find_id_path( $file_id );
		my $md5_string = `md5sum "$path"`;
		( $md5_string ) = split( /\s+/, $md5_string );

		$self->insert(
			'subject_md5',
			{
				subject_id => $file_id,
				md5        => $md5_string
			}
		);
		return $md5_string;
	}
}

1;
