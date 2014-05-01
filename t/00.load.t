use lib qw( ../lib ); # -*- cperl -*- 

use Test::More;
use File::Slurp 'read_file';


BEGIN {
use_ok( 'Test::Text' );
}

my $text_dir = 'text';
if ( !-e $text_dir ) {
  $text_dir =  "../text";
}

my $text = new Test::Text $text_dir, "/usr/share/hunspell/"; #dummy dir for now
is( $text->dir, $text_dir, "Text directory");
is( scalar( @{$text->files} ), 2, "Files");

$text = new Test::Text $text_dir, , "/usr/share/hunspell/", 'text.md';
is( scalar( @{$text->files} ), 1, "Files");

done_testing();

