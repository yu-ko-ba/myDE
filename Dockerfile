FROM ubuntu

ENV user_name myde
ENV user_home /home/${user_name}
ENV user_shell /usr/bin/fish

RUN export container_name="myDE"

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y less vim python3 fish git software-properties-common sudo language-pack-ja zip curl shellcheck gcc golint tidy flake8 clang python3-pip python3-venv npm clang-tools-8
RUN python3 -m pip install -U pip
RUN pip3 install -U neovim msgpack pynvim python-language-server
RUN add-apt-repository ppa:neovim-ppa/unstable -y
RUN apt-get update -y
RUN apt-get install neovim -y
RUN npm install npm@latest -g
RUN npm install -g bash-language-server typescript-language-server vim-language-server dockerfile-language-server-nodejs vscode-json-languageserver-bin

RUN useradd -m ${user_name}
RUN gpasswd -a ${user_name} sudo
RUN echo "root:password" |chpasswd
RUN echo "${user_name}:password" | chpasswd

# RUN chsh -s ${user_shell} ${user_name}

USER ${user_name}

WORKDIR ${user_home}

RUN mkdir -p ${user_home}/.local/bin
RUN mkdir ${user_home}/myCommands
RUN mkdir ${user_home}/work
RUN mkdir ${user_home}/omnisharp-lsp
RUN mkdir ${user_home}/eclipse-jdt-ls
RUN mkdir ${user_home}/kotlin-language-server

RUN curl -s https://get.sdkman.io | bash
RUN bash -c "source ${user_home}/.sdkman/bin/sdkman-init.sh; sdk install java; sdk install kotlin"

RUN git clone https://github.com/yu-ko-ba/dotfiles.git
WORKDIR ${user_home}/dotfiles
RUN bash deploy.sh

RUN nvim +PlugInstall +qa
RUN nvim -c "UpdateRemotePlugins" -c "qa"

WORKDIR ${user_home}/omnisharp-lsp
RUN ${user_home}/.local/share/nvim/plugged/vim-lsp-settings/installer/install-omnisharp-lsp.sh
RUN ln -s ${user_home}/omnisharp-lsp/run ${user_home}/myCommands/omnisharp-lsp

WORKDIR ${user_home}/eclipse-jdt-ls
RUN ${user_home}/.local/share/nvim/plugged/vim-lsp-settings/installer/install-eclipse-jdt-ls.sh
RUN ln -s ${user_home}/eclipse-jdt-ls/eclipse-jdt-ls ${user_home}/myCommands/eclipse-jdt-ls

WORKDIR ${user_home}/kotlin-language-server
RUN curl -L -o server.zip 'https://github.com/fwcd/kotlin-language-server/releases/download/0.5.2/server.zip'
RUN unzip server.zip
RUN rm server.zip
RUN ln -s ${user_home}/kotlin-language-server/server/bin/kotlin-language-server ${user_home}/myCommands/kotlin-language-server

WORKDIR ${user_home}/work

CMD ["/usr/bin/nvim"]
# CMD ["/usr/bin/fish"]
