package GreyLibrary::Controller::Image::Web;
use Moose;
use namespace::autoclean;
use Image::Magick;
BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

GreyLibrary::Controller::Web::Image - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {
	my ( $self, $c ) = @_;

}

sub get_image_id : Local : Args(1) {
	my ( $self, $c, $image_id ) = @_;
	my $msg = $c->model( 'SQLiteDB' )->find_id_path( $image_id );
	$msg ||= "[$image_id] not found";
	my $find      = '/mnt/X0/gl/Mid/The Big Archive/';
	my $file_path = $msg;
	my $replace   = 'http://212.227.199.157/tba/';
	$msg =~ s|$find|$replace|g;

	my $right = [ "40k",        "SM",      "IG", "Imperial", "Bases" ];
	my $mid   = [ "WH Fantasy", "Terrain", "Xenos" ];
	my $left  = [ "Chaos",      "LOTR",    "Cosplay", "Gimick", "Sci-Fi", "Generic Fantasy", "Lewd" ];

	$c->stash(
		{
			template     => 'image/web/standard_image_view.tt',
			ketsu_string => $file_path,
			img_url      => $msg,
			image_id     => $image_id,
			tags_right   => $right,
			tags_mid     => $mid,
			tags_left    => $left,
			tags         => [ @$right, @$mid, @$left ]
		}
	);
}

sub get_thumb_id : Local : Args(1) {
	my ( $self, $c, $image_id ) = @_;
	my $thumb_path = $c->config()->{thumbnail_directory} . "$image_id\_thumb.jpg";
	my $m          = $c->model( 'SQLiteDB' );

	$m->augment_directory_sub(
		sub {
			my ( $path ) = @_;

			my $find    = '/mnt/X0/';
			my $replace = '/home/m/remote/X0/';
			$path =~ s|$find|$replace|;
			return $path;
		}
	);

	warn "checking [$thumb_path]";
	unless ( -e $thumb_path ) {

		my $in_path = $m->find_id_path( $image_id );
		die "Path [$in_path] not found" unless -e $in_path;
		warn "thumbing [$in_path]";

		my $image = Image::Magick->new;

		#this is required for it to run under catalyst
		open( IMAGE, '<', $in_path );
		$image->Read( file => \*IMAGE );
		close( IMAGE );

		$image->Scale( geometry => '300x300' );
		$image->Set( quality => 50 );

		open( IMAGE_OUT, '>', $thumb_path ) or die "can't write : $!";
		$image->Write( file => \*IMAGE, filename => $thumb_path );

	}
	$c->res->redirect( $c->uri_for( "/static/thumb/$image_id\_thumb.jpg" ) );

}

sub gallery : Local : CaptureArgs(1) {
	my ( $self, $c, $list_ids ) = @_;

	$list_ids ||= $c->session->{gallery_ids};
	use Data::Dumper;
	$c->stash(
		{
			gallery_ids   => $list_ids,
			get_thumb_url => $c->uri_for( qw/ get_thumb_id/ ) . '/',
		}
	);
}

sub untagged_gallery : Local {
	my ( $self, $c ) = @_;
	my $stack = $c->forward( qw/GreyLibrary::Controller::Image get_untagged /, [5] );
	my @other_stack;
	for my $row ( @{$stack} ) {
		push( @other_stack, $row->{image_id} );
	}
	$c->session(
		{
			gallery_ids => \@other_stack
		}
	);

	$c->res->redirect( $c->uri_for( "/image/web/gallery" ) );
}

sub search_gallery : Local : CaptureArgs(1) {
	my ( $self, $c, $page ) = @_;
	$page ||= 1;
	my $results = 20;
	my $m       = $c->model( 'SQLiteDB' );
	warn "searching for " . $c->session->{search_string};
	my $stack = $m->search_string( $c->session->{search_string}, $results, $page );

	my @other_stack;
	for my $row ( @{$stack} ) {
		push( @other_stack, $row->[0] );
	}
	warn Dumper( [ $stack, \@other_stack ] );
	$c->stash(
		{
			gallery_ids   => \@other_stack,
			search_page   => $page,
			get_thumb_url => $c->uri_for( qw/ get_thumb_id/ ) . '/',
		}
	);

}

sub untagged : Local {
	my ( $self, $c, $skip ) = @_;
	my $stack = $c->forward( qw/GreyLibrary::Controller::Image get_untagged/, [$skip] );

	$c->res->redirect( $c->uri_for( "/image/web/get_image_id/$stack->[0]->{image_id}" ) );
}

sub search_string_form : Local {
	my ( $self, $c ) = @_;

	if ( my $string = $c->request->params->{search_string} ) {
		$c->session(
			{
				search_string => $string,
				search_page   => 1,
			}
		);

		$c->res->redirect( $c->uri_for( "/image/web/search_gallery" ) );
	} else {

		$c->res->redirect( $c->uri_for( "/image/web/untagged" ) );
	}
}

__PACKAGE__->meta->make_immutable;

1;
