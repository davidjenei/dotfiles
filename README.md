# dotfiles
```
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/davidjenei/dotfiles tmpdotfiles && \
  rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/ && \
  rm -r tmpdotfiles
```
[src](https://www.anand-iyer.com/blog/2018/a-simpler-way-to-manage-your-dotfiles.html)
