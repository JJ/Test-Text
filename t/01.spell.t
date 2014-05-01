use lib qw( ../lib ); # -*- cperl -*- 

use Test::More;
use Test::Output;
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

my $text_dir = 'text';
if ( !-e $text_dir ) {
  $text_dir =  "../text";
}

my $tesxt = new Test::Text $text_dir, $dict_dir;

stdout_like( sub { $tesxt->check();}, qr/ok 154 - station/, "Checking spelling");


done_testing();

