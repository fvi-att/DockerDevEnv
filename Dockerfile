FROM debian:jessie
MAINTAINER fvi@shimizu <jshimizujp@gmail.com>

#basic settings

RUN awk '$1 ~ "^deb" { $3 = $3 "-backports"; print; exit }' /etc/apt/sources.list > /etc/apt/sources.list.d/backports.list

RUN apt-get update
RUN apt-get install -y build-essential emacs24 vim git sudo wget net-tools expect ssh

#install latest python
RUN  cd /tmp && wget https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz -O Python.tgz && tar -xzf Python.tgz
RUN  cd /tmp/Python-2.7.10 && ./configure &&  make && make install && apt-get -y install python-dev


RUN cd ~/ && mkdir .emacs.d && mkdir .emacs.d/auto-install && wget http://www.emacswiki.org/emacs/download/auto-install.el -O ./.emacs.d/auto-install/auto-install.el
RUN cd ~/ && emacs --batch -Q -f batch-byte-compile ./.emacs.d/auto-install/auto-install.el
RUN cd ~/ && wget https://gist.githubusercontent.com/fvi-att/bf10262d17d445d3c921/raw/452ba722198984ef574868d5cf2b5442e84ec00b/gistfile1.el -O ./.emacs.d/init.el 
RUN cd ~/ && git clone https://github.com/hayamiz/twittering-mode.git && mv twittering-mode ./.emacs.d/twittering-mode-3.0.0

ADD install.el /root/install.el
RUN cd ~/ emacs --script install.el


CMD /bin/bash
