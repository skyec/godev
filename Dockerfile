# Dockerfile for Go development
#
# Development can happen right in the container using vim (vim-go) making 
# it easy to get a working development environment for Go up and running.
# It is also possible to edit source outside the container and just use
# the container to build and run tests.
#
# Initially from: https://github.com/manishrjain/godev

FROM ubuntu:trusty
MAINTAINER Skye Cove <skye.cove@gmail.com>

RUN apt-get update && apt-get install -y --no-install-recommends \
 bzr \
 cmake \
 curl \
 g++ \
 git \
 make \
 man-db \
 mercurial \
 ncurses-dev \
 procps \
 python-dev \
 python-pip \
 ssh \
 sudo \
 tmux \
 unzip \
 vim \
 xz-utils \
 && rm -rf /var/lib/apt/lists/* \
 && pip install ipython \
 && git clone https://github.com/gmarik/Vundle.vim.git /root/.vim/bundle/Vundle.vim \
 && git clone https://github.com/Valloric/YouCompleteMe.git /root/.vim/bundle/YouCompleteMe \
 && cd /root/.vim/bundle/YouCompleteMe && git submodule update --init --recursive \
 && ./install.sh --clang-completer

COPY bashrc /root/.bashrc

ENV GOVERSION 1.7

RUN curl -O https://storage.googleapis.com/golang/go$GOVERSION.linux-amd64.tar.gz && tar -C /usr/local -xzf go$GOVERSION.linux-amd64.tar.gz

ENV GOPATH /go
ENV HOME /root
ENV PATH /go/bin:/usr/local/go/bin:$PATH

WORKDIR /go/src

RUN go version | grep $GOVERSION

COPY vimrc /root/.vimrc
RUN vim +PluginInstall  +qall
RUN vim +GoInstallBinaries +qall

CMD ["tmux", "-u2"]

# Assuming you have a $GOPATH established in the host environment, run Docker
# with: 
#
# ```
# $ docker run -itv $GOPATH/src:/go/src thisimage
# ```
# 
# You will then need to cd into your source directory to build your code.

