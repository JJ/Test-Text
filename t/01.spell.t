use lib qw( ../lib ); # -*- cperl -*- 

use Test::More;
use File::Slurp 'read_file';

use Test::Text;

my $dict_dir;

if ( -e "/usr/share/hunspell/en_US.aff" ) {
  $dict_dir =  "/usr/share/hunspell";
} elsif  ( -e "data/en_US.aff" ) {
  $dict_dir = "data";
} else {
  $dict_dir = "../data";
}

my $text_dir = 'text/en';
if ( !-e $text_dir ) {
  $text_dir =  "../text/en";
}

my $tesxt = new Test::Text $text_dir, $dict_dir;

$tesxt->check();

$text_dir = 'text/es';
if ( !-e $text_dir ) {
  $text_dir =  "../text/es";
}

$tesxt = new Test::Text $text_dir, $dict_dir, 'es' ;

done_testing();

