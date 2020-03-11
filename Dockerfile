FROM ubuntu

ENV user_name myde
ENV user_home /home/${user_name}
ENV user_shell /usr/bin/fish

# コンテナ内ってわかるようにする
ENV container_name myDE

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y less vim python3 fish git software-properties-common sudo language-pack-ja zip curl shellcheck gcc golint tidy flake8 clang python3-pip npm
RUN python3 -m pip install -U pip
RUN pip3 install -U python-language-server
RUN npm install npm@latest -g
RUN npm install -g bash-language-server typescript-language-server vim-language-server dockerfile-language-server-nodejs vscode-json-languageserver-bin
RUN add-apt-repository ppa:neovim-ppa/unstable -y
RUN apt-get update -y
RUN apt-get install neovim -y

RUN useradd -m ${user_name}
RUN gpasswd -a ${user_name} sudo
RUN echo "root:password" |chpasswd
RUN echo "${user_name}:password" | chpasswd

USER ${user_name}

WORKDIR ${user_home}

RUN mkdir -p ${user_home}/.local/bin
RUN mkdir ${user_home}/work
RUN mkdir ${user_home}/omnisharp-lsp
RUN mkdir ${user_home}/eclipse-jdt-ls
RUN mkdir ${user_home}/kotlin-language-server

RUN curl -s https://get.sdkman.io | bash
RUN bash -c "source ${user_home}/.sdkman/bin/sdkman-init.sh; sdk install java; sdk install kotlin"

RUN git clone https://github.com/yu-ko-ba/dotfiles.git
WORKDIR ${user_home}/dotfiles
RUN bash deploy.sh

# vimで起動時にコマンド実行する方法のメモも兼ねてる
RUN nvim +PlugInstall -c "qa"

WORKDIR ${user_home}/omnisharp-lsp
RUN ${user_home}/.local/share/nvim/plugged/vim-lsp-settings/installer/install-omnisharp-lsp.sh

WORKDIR ${user_home}/eclipse-jdt-ls
RUN ${user_home}/.local/share/nvim/plugged/vim-lsp-settings/installer/install-eclipse-jdt-ls.sh

WORKDIR ${user_home}/kotlin-language-server
RUN curl -L -o server.zip 'https://github.com/fwcd/kotlin-language-server/releases/download/0.5.2/server.zip'
RUN unzip server.zip
RUN rm server.zip

WORKDIR ${user_home}/work

ENTRYPOINT ["nvim"]
