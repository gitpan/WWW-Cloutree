use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME               => 'WWW::Cloutree',
	AUTHOR             => q{"Alexander Babenko" <"foxcool@cpan.org">},
	VERSION_FROM       => 'lib/WWW/Cloutree.pm',
	ABSTRACT_FROM      => 'lib/WWW/Cloutree.pm',
	LICENSE            => 'Artistic_2_0',
	PL_FILES           => {},
	MIN_PERL_VERSION   => 5.006,
	CONFIGURE_REQUIRES => {
		'ExtUtils::MakeMaker' => 0,
	},
	BUILD_REQUIRES => {
		'Test::More' => 0,
	},
	PREREQ_PM => {
		'Class::Singleton'      => 0,
		'Digest::SHA1'          => 0,
		'HTTP::Request::Common' => 0,
		'LWP::UserAgent'        => 0,
		'LWP::Protocol::https'  => 0,
		'JSON'                  => 0,
		'Carp'                  => 0,
	},
	META_MERGE => {
		resources => {
			repository => 'https://github.com/Foxcool/cloutree-perl',
		},
	},
	dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
	clean => { FILES    => 'WWW-Cloutree-*' },
);
