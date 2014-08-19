Test::Text
=========
[![Build Status](https://travis-ci.org/JJ/Test-Text.svg?branch=master)](https://travis-ci.org/JJ/Test-Text)

Objective
---

A module for testing and doing metrics on normal text. As in books or
novels.  

We're not there yet, but for the time being it is a pretty
good spelling checker that can be used *on the cloud* in continuous
integration literary environments. 

who is this module for?
---

People who write fiction or non-fiction using simple text, Markdown or
similar formats. You don't need to know Perl or continuous integration
or nothing more techie than clicking here and there and saving
files. You probably do, but it's not really needed for using it. 

what is this for?
---

Saves you time by checking spelling automatically. Also measures
progress by telling you how many words you have written so far and in
total.

how can I use it?
---

1. Save the files you want to be tested to a single directory called `text`, using
`.markdown`, `.txt` or `.md` extensions. That directory will also hold
the `words.dic` where you will save real words that are not included
in the general dictionary. That's your personal dictionary, for short.

2. Sign up for [Travis CI](http://travis-ci.org). You can use your
GitHub account. Choose the repo where your text is and enable it.

3. Create a `.travis.yml` configuration file in the home directory of
your repo. There are a couple of examples (English and Spanish) in
this repo. You can also copy and paste this

```
branches:
  except:
    - gh-pages
language: perl
perl:
  - "5.16"
before_install:
  - sudo apt-get install libhunspell-1.3-0 libhunspell-dev
  - curl https://raw.githubusercontent.com/JJ/Test-Text/master/files/just_check_en.t -o just_check.t
install: cpanm Test::Text TAP::Harness
script: perl -MTAP::Harness -e 'use utf8; my $harness =
TAP::Harness->new( { verbosity => 0} ); die "FAIL" if $harness->runtests( "just_check.t" )->failed;'
```

and save it to that file.

That's it. Every time you `push`, your text files will be checked and
it will return the words that it does not know about. You can them fix
them or enter them in your `words.dic` file, with this format

```
3
OneWord
AnotherWord
FooBar
```

Simple enough, ain't it?

it does not work!
---

You can raise [an issue](https://github.com/JJ/Test-Text/issues)
requesting help. 
