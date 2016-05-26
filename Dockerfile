FROM ubuntu:trusty
MAINTAINER "w0lker" <w0lker.tg@gmail.com>
ARG USER
ARG USER_ID
ARG GROUP_ID
ENV USER ${USER:-tangjun}
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}
ENV TERM xterm-256color

# update sources list 
RUN echo "deb http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse\n\
deb http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse\n\
deb http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse\n\
deb http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse\n\
deb http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse\n\
deb-src http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse\n\
deb-src http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse\n\
deb-src http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse\n\
deb-src http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse\n\
deb-src http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse"\
> /etc/apt/sources.list

RUN rm -rf /var/lib/apt/lists/* \
&& apt-get clean \
&& apt-get -y update \
&& apt-get -y install curl vim git \
&& apt-get clean

# add user
RUN groupadd --gid $GROUP_ID $USER
RUN useradd --gid $GROUP_ID --uid $USER_ID -m -s /bin/bash $USER
RUN chmod u+s /bin/ping
RUN sh -c "sed -i \"/^%sudo.*$/a\$USER  ALL=(ALL)  NOPASSWD: ALL\" /etc/sudoers"

WORKDIR /home/$USER
USER $USER

# git
RUN echo "PS1=\"\[\\e[0;36m\]\W \$ \[\\e[0m\]\"" >> .bashrc
RUN curl https://raw.githubusercontent.com/w0lker/conf_git/master/gitconfig -o .gitconfig
RUN curl https://raw.githubusercontent.com/w0lker/conf_git/master/gitignore_global -o .gitignore_global

# colors
RUN curl https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark -o .dircolors

# vim
RUN curl https://raw.githubusercontent.com/w0lker/conf_vim/master/vimrc -o .vimrc
RUN echo "alias vi='vim'" >> .bashrc

# clear
USER root
RUN rm -rf /home/$USER/* /root/* /*.log /tmp/*
USER $USER

CMD ["/usr/sbin/init"]
