package WWW::Cloutree;

use 5.010;
use strict;
use warnings;

use base 'Class::Singleton';
use Digest::SHA1 qw(sha1_hex);
use HTTP::Request::Common;
use LWP::UserAgent;
use LWP::Protocol::https;
require JSON;
require Carp;

our $VERSION = '1.01';

=head1 NAME

WWW::Cloutree - Perl interface to Cloutree CDN

=head1 SYNOPSIS

Use this module for uploading files to https://cloutr.ee/

	use WWW::Cloutree;
	# Create a WWW::Cloutree instance
	my $cloutree = WWW::Cloutree->instance( { app_key => $opts{key}, app_secret => $opts{secret}, raw => 1 } );
	# Upload file and say raw server response (JSON)
	say $cloutree->upload_file({ file => $opts{file}, filename => $filename });

=head1 METHODS

=head2 upload_file

Upload file to CDN

=head3 parameters

	filename - filename,
	file     - file handler,

=cut

sub upload_file {
	my ( $self, $params ) = @_;

	Carp::croak("File is mandatory parameter") unless $params->{file};

	# ToDo: test sending big files
	open my $file, '<', $params->{file} or Carp::croak("Can't open file: $!");
	local $/ = undef;

	# ToDo: set time
	my $time    = '';
	my $request = POST $self->{url},
	  KEY => $self->{app_key},
	  CHECKSUM =>
	  sha1_hex( join( ':', $self->{app_key}, $time, $params->{filename}, $self->{app_secret} ) ),
	  FILENAME  => $params->{filename},
	  TIMESTAMP => $time,
	  Content   => <$file>;

	my $response = $self->{ua}->request($request);

	return unless $response->is_success;
	return $response->content if $self->{raw};
	return $self->{json}->decode( $response->content );
}

=head2 instance

Create a WWW::Cloutree singleton instance.

	my $cloutree = WWW::Cloutree->instance( { app_key => 'KEY', app_secret => 'SECRET' } );

=head3 parameters (* - mandatory)

	*app_key       - API key,
	*app_secret    - API secret,
	raw            - Option: return raw text from server (do not decode JSON),
	url            - URL of cloutree upload service (default https://cloutr.ee/upload)
	ua             - User Agent module (default LWP::UserAgent)
	json           - JSON module (default JSON)

=cut

sub _new_instance {
	my $class  = shift;
	my $self   = bless {}, $class;
	my $params = shift;

	$self->{app_key}    = $params->{app_key}    or Carp::croak("Specify app_key");
	$self->{app_secret} = $params->{app_secret} or Carp::croak("Specify app_secret");
	#ToDo: Disabling SSL checking (fix it)!
	$self->{ua}   = $params->{ua}   || LWP::UserAgent->new( ssl_opts => { verify_hostname => 0 } );
	$self->{json} = $params->{json} || JSON->new();
	$self->{url}  = $params->{url}  || 'https://cloutr.ee/upload';
	$self->{raw}  = $params->{raw};

	return $self;
}

=head1 AUTHOR

Alexander Babenko (foxcool@cpan.org)

=head1 SUPPORT

Github: https://github.com/Foxcool/Cloutree-Upload

Bugs & Issues: https://github.com/Foxcool/Cloutree-perl/issues


=cut

1;
