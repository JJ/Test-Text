branches:
  except:
    - gh-pages
language: perl
perl:
  - "5.16"
before_install:
  - sudo apt-cache search libhunspell
  - sudo apt-get install libhunspell-1.3-0 libhunspell-dev
  - curl https://raw.githubusercontent.com/JJ/Test-Text/master/data/Spanish.aff -o Spanish.aff
  - curl https://raw.githubusercontent.com/SublimeText/Dictionaries/master/Spanish.dic -o Spanish.dic
  - curl https://raw.githubusercontent.com/JJ/Test-Text/master/files/just_check_es.t -o just_check.t
install: cpanm Test::Text TAP::Harness
script: perl -MTAP::Harness -e 'use utf8; my $harness = TAP::Harness->new( { verbosity => 0} ); die "FAIL" if  $harness->runtests( "just_check.t" )->failed;'

