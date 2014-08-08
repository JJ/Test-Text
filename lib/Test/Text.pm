package Test::Text;

use warnings;
use strict;
use Carp;
use File::Slurp 'read_file';
use Text::Hunspell;
use v5.14;

use version; our $VERSION = qv('0.1.0'); # Let's try a couple of languages

use base 'Test::Builder::Module';

my $CLASS = __PACKAGE__;
our $word_re = qr/([\w\'áéíóúÁÉÍÓÚñÑçÇ]+)/;

# Module implementation here
sub new {
  my $class = shift;
  my $dir = shift || croak "Need a directory with text" ;
  my $data_dir = shift || croak "No default spelling data directory\n";
  my $language = shift || "en_US"; # Defaults to English
  my @files = @_ ; # Use all appropriate files in dir by default
  if (!@files ) {
    @files = glob("$dir/*.md $dir/*.txt)");
  } else {
    @files = map( "$dir/$_", @files );
  }
  my $self = { 
	      _dir => $dir,
	      _data_dir => $data_dir,
	      _files => \@files
  };
  bless  $self, $class;

  # Speller declaration
  my $speller = Text::Hunspell->new(
				  "$data_dir/$language.aff",    # Hunspell affix file
				  "$data_dir/$language.dic"     # Hunspell dictionary file
				   );
  croak if !$speller;
  $self->{'_speller'} = $speller;
  $speller->add_dic("$dir/words.dic"); #word.dic should be in the text directory
  return $self;
}

sub dir {
    my $self = shift;
    return $self->{'_dir'};
}

sub files {
  my $self = shift;
  return $self->{'_files'};
}

sub check {
  my $self = shift;
  my $tb= $CLASS->builder;
  my $speller = $self->{'_speller'};
  for my $f ( @{$self->files}) {
    my $file_content= read_file($f);
    my @words = split /\s+/, $file_content;

    for my $w (@words) {
      my ($stripped_word) = ( $w =~ $word_re );
      next if !$stripped_word;
      $tb->ok( $speller->check( $stripped_word),  " $stripped_word");
    }
  }
}

sub done_testing {
  my $tb= $CLASS->builder;
  $tb->done_testing;
}

"All over, all out, all over and out"; # Magic circus phrase said at the end of the show

__END__

=head1 NAME

Test::Text - A module for testing text files.


=head1 VERSION

This document describes Test::Text version 0.1.0


=head1 SYNOPSIS

    use Test::Text;

    my $dir = "path/to/text_dir"; 
    my $data = "path/to/data_dir"; 

    my $tesxt = new Test::Text $text_dir, $dict_dir; # Defaults to English: en_US and all files

    $tesxt = new Test::Text $text_dir, $dict_dir, "en_US", $this_file, $that_file; # Tests only those files 

    $tesxt = new Test::Text $text_dir, $dict_dir, "es_ES"; # Uses alternate language 

    $testxt->check(); # spell-checks plain or markdown text in that dir or just passed

    
    $testxt->done_testing(); # all over and out


=head1 DESCRIPTION

This started as a spell and quality check for my novel, "Manuel the
Magnificent Mechanical Man". Eventually, it can be used for checking
any kind of markdown-formatted text, be it fiction or non-fiction. The first version included
as documentation, the novel itself (check it out at L<Text::Hoborg::Manuel> and also in the test
directory the markdown source. 

This module is a more general text-tester (that's a C<tesxter>) which can be used on any external set of texts.  
This all came from the idea that L<writing is like software development|https://medium.com/i-m-h-o/6d154a43719c>, which I'm using throughout. 

You will need to install Hunspell and any dictionary you will be using. By default, Hunspell only installs English and a few more (would be hard pressed to tell which ones)

=head1 INTERFACE

=head2 new $text_dir, $data_dir [, $language = 'en_US'] [,  @files]

Creates an object with the novel text inside.  There is no default for the dir since it is supposed to be external. If an array of files is given, only those are used and not all the files inside the directory; these files will be prepended the C<$text_dir> to get the whole path.

=head2 files

Returns the files it will be checking.

=head2 dir

Returns the dir the source files are in. Since this is managed from the
object, it is useful for other functions.

=head2 check

Check files. This is the only function you will have to call from from your test script.

=head2 done_testing

Called after all tests have been performed.

=head1 DEPENDENCIES

Test::Text requires L<Text::Hunspell> and the 
C<en_US> dictionnary for C<hunspell>, which you can install with
C<sudo apt-get install hunspell-en-us> , but since I found no way of expressing this
dependency within Makefile.PL, I have added it to the C<data> dir,
mainly. Latest version requires L<Test::Builder>.

=head1 Development and bugs

Development of this module is hosted at L<GitHub|http://github.com/JJ/Test-Text>. Use it for forking, bug reports, checking it out, whatever

=head1 SEE ALSO

L<Manuel, the Marvelous Mechanical Man|https://www.amazon.com/Manuel-Magnificent-Mechanical-Logical-Natural-History-ebook/dp/B00ED084BK/ref=as_li_ss_til?tag=perltutobyjjmere&linkCode=w01&linkId=4PA3TNKRGGBZKHOE&creativeASIN=B00ED084BK>, the novel that spawned all this, or the other way around. 



=head1 AUTHOR

JJ Merelo  C<< <jj@merelo.net> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2014, JJ Merelo C<< <jj@merelo.net> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
