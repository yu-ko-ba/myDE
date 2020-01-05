FROM ubuntu:18.04

ENV user_name yu-ko-ba
ENV user_home /home/${user_name}
ENV user_shell /usr/bin/fish

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y less vim neovim python3 fish git

RUN useradd -m ${user_name}
RUN gpasswd -a ${user_name} sudo
RUN echo "root:password" |chpasswd
RUN echo "${user_name}:password" | chpasswd

USER ${user_name}

WORKDIR ${user_home}

RUN git clone https://github.com/yu-ko-ba/dotfiles.git
RUN bash ${user_home}/dotfiles/deploy.sh

CMD ["/usr/bin/fish"]
