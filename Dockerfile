FROM ubuntu:18.04

ENV user_name yu-ko-ba
ENV user_home /home/${user_name}
ENV user_shell /usr/bin/fish

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y less vim neovim python3 fish

RUN useradd -m ${user_name}
RUN gpasswd -a ${user_name} sudo
RUN echo "${user_name}:password" | chpasswd

RUN sed -i.bak -e "#/${user_home}:/${user_home}:${user_shell}" /etc/passwd

USER ${user_name}

WORKDIR ${user_home}

CMD ["/usr/bin/fish"]
