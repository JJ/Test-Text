use lib qw( ../lib ); # -*- cperl -*- 

use Test::More;
use Test::Text;

my $dict_dir;

if ( -e "/usr/share/hunspell/en_US.aff" ) {
  $dict_dir =  "/usr/share/hunspell";
} elsif  ( -e "data/en_US.aff" ) {
  $dict_dir = "data";
} else {
  $dict_dir = "../data";
}

diag "Using $dict_dir for dictionnaries";

my $text_dir = 'text/en';
if ( !-e $text_dir ) {
  $text_dir =  "../text/en";
}

diag "Using $text_dir for text";

my $tesxt = new Test::Text $text_dir, $dict_dir;
isa_ok( $tesxt, "Test::Text");

$tesxt->check();

just_check( $text_dir, $dict_dir); # procedural interface, exported by default
diag "Done English tests";

$text_dir = 'text/es';
if ( !-e $text_dir ) {
  $text_dir =  "../text/es";
}

$tesxt = new Test::Text $text_dir, $dict_dir, 'es' ;
isa_ok( $tesxt, "Test::Text");
$tesxt->check();

diag "Done Spanish tests";

done_testing();

