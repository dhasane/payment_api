FROM archlinux:latest

RUN pacman -Syu base-devel postgresql-libs which gnupg ruby --noconfirm

SHELL [ "/bin/bash", "-l", "-c" ]

RUN gem install bundler

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD . /usr/src/app
