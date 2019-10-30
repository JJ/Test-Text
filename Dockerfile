FROM ubuntu:16.04
LABEL version="1.0" maintainer="JJ Merelo <jjmerelo@GMail.com>" perl5version="5.22"

ADD data/* ./
ADD . .
RUN mkdir /test \
    && apt-get update \
    && apt-get install -y build-essential curl hunspell-en-us libtext-hunspell-perl myspell-es libencode-perl cpanminus libfile-slurp-tiny-perl libversion-perl\
    && curl https://raw.githubusercontent.com/SublimeText/Dictionaries/master/Spanish.dic -o Spanish.dic

RUN cpanm Test::More
RUN perl Makefile.PL && make install
RUN perl --version
VOLUME /test
WORKDIR /test

# Will run this
ENTRYPOINT prove
