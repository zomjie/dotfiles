## Configure dev enviroment on Debian12.0
### Packages
```
sudo apt install batcat ripgrep
```
### Install Vim9.1
```
sudo apt install -y build-essential git libncursesw5-dev \
    python3-dev \
    liblua5.1-dev luajit \
    libperl-dev \
    ruby-dev
./configure \
    --with-features=huge \
    --enable-multibyte \
    --enable-python3interp=dynamic \
    --enable-luainterp \
    --enable-rubyinterp \
    --with-tlib=ncursesw \
    --prefix=/usr/local
```

### Install vim-nox zsh
```
sudo apt update
sudo apt upgrade
sudo apt automove vim
sudo apt install zsh
vim --version | grep python3
zsh --version
```
### Install oh-my-zsh and plugins for it
```
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
```

### FZF
```
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
```

### Vim-Plug
```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### ctags
```
sudo apt install autoconf automake pkg-config
git clone https://github.com/universal-ctags/ctags.git
cd ctags
./autogen.sh
./configure  # use --prefix=/where/you/want to override installation directory, defaults to /usr/local
make
make install # may require extra privileges depending on where to install
```

### undowarn.vim
```
mkdir -p ~/.vim/pack/my/start
ce $_
git clone https://github.com/arp242/undofile_warn.vim.git
```

### YCM
### *1) Install packages
```
sudo apt install build-essential cmake3 python3-dev
sudo apt install mono-complete openjdk-17-jdk openjdk-17-jre
```
### *2) Install go
```
wget https://go.dev/dl/go1.25.4.linux-amd64.tar.gz
tar -C ~/local/apps -zxf go1.25.4.linux-amd64.tar.gz
go install golang.org/dl/go1.24.8@latest
go install golang.org/x/tools/gopls@latest
```
```
# Configuration for go in ~/.zshrc
export GOROOT=$HOME/local/apps/go
export PATH="$GOROOT/bin:$PATH"
```
### *3) Install Node.js*
https://nodejs.org/en/download
### *4) Install YCM*
```
cd ~/.vim/pack/my/start
git clone https://github.com/ycm-core/YouCompleteMe.git
git submodule update --init --recursive
cd YouCompleteMe
python3 install.py --all
```
### *5) Configure LSP*
```
cd ~/.vim/pack/my/start
git clone https://github.com/ycm-core/lsp-examples
python3 ./install.py --enable-LANG1 --enable-LANG2 ...
```
Add the following line to the vimrc:
```
source /path/to/this/directory/vimrc.generated
```

### Custom Vim Plugins
```
https://github.com/zomjie/custom_vim_plugins
```
