FROM ubuntu:18.04

ENV user_name myde
ENV user_home /home/${user_name}
ENV user_shell /usr/bin/fish

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y less vim python3 fish git software-properties-common sudo language-pack-ja zip curl shellcheck gcc golint tidy flake8 clang python3-pip
RUN pip3 install -U neovim msgpack
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
RUN mkdir ${user_home}/work

RUN curl -s https://get.sdkman.io | bash
RUN bash -c "source ${user_home}/.sdkman/bin/sdkman-init.sh; sdk install java; sdk install kotlin"

RUN git clone https://github.com/yu-ko-ba/dotfiles.git
WORKDIR ${user_home}/dotfiles
RUN bash deploy.sh

RUN nvim -c UpdateRemotePlugins -c q

WORKDIR ${user_home}/work
CMD ["/usr/bin/nvim"]
