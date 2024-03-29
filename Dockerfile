FROM ubuntu:latest
LABEL version="1.0.1" maintainer="JJ Merelo <jjmerelo@GMail.com>" perl5version="5.22"

RUN mkdir /home/install
WORKDIR /home/install
ADD data/ data/
ADD lib/ lib/
ADD text/ text/
ADD t/ t/
ADD cpanfile Makefile.PL ./
RUN mkdir /test \
    && apt-get update \
    && apt-get install -y build-essential curl hunspell-en-us libtext-hunspell-perl myspell-es libencode-perl cpanminus libfile-slurp-tiny-perl libversion-perl


RUN perl --version
RUN cpanm Test::More
RUN cpanm . -v
VOLUME /test
WORKDIR /test

# Will run this
ENTRYPOINT cp /home/install/data/*.dic /home/install/data/*.aff /test &&  prove -I/usr/lib -c
