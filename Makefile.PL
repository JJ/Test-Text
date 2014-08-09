use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Test::Text',
    AUTHOR              => 'JJ Merelo <jj@merelo.net>',
    VERSION_FROM        => 'lib/Test/Text.pm',
    ABSTRACT_FROM       => 'lib/Test/Text.pm',
    LICENSE => 'gpl',
    PL_FILES            => {},
    PREREQ_PM => {
		  'Test::More' => 0,
		  'version'    => 0,
		  'File::Slurp' => 0,
		  'Text::Hunspell' => 2.08,
		  'Encode::Encoder' => 0,
		  'Test::Output' => 1.03,
		  'Test::Simple' => 1.0
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Test-Text-*' },
);
