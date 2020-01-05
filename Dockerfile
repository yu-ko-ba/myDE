FROM ubuntu:18.04

ENV user_name yu-ko-ba
ENV user_home /home/${user_name}
ENV user_shell /usr/bin/fish

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y less vim python3 fish git software-properties-common sudo language-pack-ja
RUN add-apt-repository ppa:neovim-ppa/stable -y
RUN apt-get update -y
RUN apt-get install neovim -y

RUN useradd -m ${user_name}
RUN gpasswd -a ${user_name} sudo
RUN echo "root:password" |chpasswd
RUN echo "${user_name}:password" | chpasswd

USER ${user_name}

WORKDIR ${user_home}

RUN mkdir ${user_home}/myCommands
RUN git clone https://github.com/yu-ko-ba/dotfiles.git
WORKDIR ${user_home}/dotfiles
RUN bash deploy.sh

WORKDIR ${user_home}
CMD ["/usr/bin/fish"]
