#!/usr/bin/env perl

use feature 'say';

use WWW::Cloutree;
use Getopt::Long;
use Pod::Usage;
use File::Basename;

GetOptions(
	"file|f=s"   => \$opts{file},
	"key|k=s"    => \$opts{key},
	"secret|s=s" => \$opts{secret},
);

pod2usage if $opts{help} or !$opts{file};

my $cloutree = WWW::Cloutree->instance( { app_key => $opts{key}, app_secret => $opts{secret}, raw => 1 } );
my $filename = fileparse( $opts{file} );
say $cloutree->upload_file({ file => $opts{file}, filename => $filename });

__END__

=head1 NAME

cloutree_upload.pl - Upload file to cloutree

=head1 SYNOPSIS

cloutree_upload.pl --file (or -f) file

	Options:
	-f|--file               Path to file
	-k|--key                App key
	-s|--secret             App secret

=head1 DESCRIPTION

Upload your files to cloutree service

=head1 AUTHOR

Alexander Babenko  C<< <foxcool333@gmail.com> >>
