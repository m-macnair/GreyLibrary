package GreyLibrary::Controller::Image::Web;
use Moose;
use namespace::autoclean;

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

sub untagged : Local {
	my ( $self, $c ) = @_;
	my $stack = $c->forward( qw/GreyLibrary::Controller::Image get_untagged/ );

	$c->res->redirect( $c->uri_for( "/image/web/get_image_id/$stack->[0]->{image_id}" ) );
}

__PACKAGE__->meta->make_immutable;

1;
