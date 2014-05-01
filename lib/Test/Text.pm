package Test::Text;

use warnings;
use strict;
use Carp;
use File::Slurp 'read_file';
use Text::Hunspell;

use version; our $VERSION = qv('0.0.3'); # First version elaborated from old one

# Module implementation here
sub new {
  my $class = shift;
  my $dir = shift || croak "Need a directory with text" ;
  my $data_dir = shift || croak "No default spelling data directory\n";
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
				  "$data_dir/en_US.aff",    # Hunspell affix file
				  "$data_dir/en_US.dic"     # Hunspell dictionary file
				   );
  croak if !$speller;
  $self->{'_speller'} = $speller;
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

sub text_file {
  my $self = shift;
  return $self->{'_text_file'};
}


"All over, all out, all over and out"; # Magic circus phrase said at the end of the show

__END__

=head1 NAME

Test::Text - A module for testing 


=head1 VERSION

This document describes Test::Text version 0.0.3


=head1 SYNOPSIS

    use Test::Text;
    
=head1 DESCRIPTION

This started as a spell and quality check for my novel, "Manuel the
Magnificent Mechanical Man". Eventually, it can be used for checking
any kind of markdown-formatted text, be it fiction or non-fiction. The first version included
as documentation, the novel itself (check it out at L<Text::Hoborg::Manuel> and also in the test
directory the markdown source. 

This module is a more general text-tester (that's a C<tesxter>) which can be used on any external set of texts. 

=head1 INTERFACE

=head2 new $dir [, @files]

Creates an object with the novel text inside.  There is no default for the dir since it's supposed to be external. If an array of files is given, only those are used and not all the files inside the directory.

=head2 files

Returns the files it's using

=head2 dir

Returns the dir the source file is in. Since this is managed from the
object, it is useful for other functions.


=head1 DEPENDENCIES

Test::Text requires L<Text::Hunspell> and the 
C<en_US> dictionnary for C<hunspell>, which you can install with
C<sudo apt-get install hunspell-en-us> , but since I found no way of expressing this
dependency within Makefile.PL, I have added it to the C<data> dir,
mainly

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
