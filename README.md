# dotfiles
```
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell && \
  git clone --separate-git-dir=$HOME/.dotfiles https://github.com/davidjenei/dotfiles tmpdotfiles && \
  rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/ && \
  rm -r tmpdotfiles
```

pip install --user "python-lsp-server[all]"
pip3 install --user 'pyls-isort'

# my tooling

TODO: document

* text editor - vim
* file outline: universal ctags + vim-vista
* linting: vim-lsp
* formatting: vim-lsp
* multiplexer: tmux
* shell: bash

# My vim config

Plugins:


Custom bindings:

* backspace: turn off search highlights
* ctrl+q: toggle vim-vista
* g+: vim-lsp
* ctrl+s: TODO: grep
* g+e: explorer


[src](https://www.anand-iyer.com/blog/2018/a-simpler-way-to-manage-your-dotfiles.html)
