#!/usr/bin/env zsh

# /-------------------------\ #
#<-[    dotfiles/.zshrc    ]->#
# \-------------------------/ #


# -[ configurations ]----------------------------------------- #
# /
# zsh
setopt autocd
setopt histignoredups
setopt menucomplete
setopt nolistbeep

# oh-my-zsh
COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# - desyncr/auto-ls
AUTO_LS_PATH=true
# NOTE: Pulled from aliases.
AUTO_LS_COMMANDS=("/usr/local/bin/exa --long --group-directories-first --all --group --git" git-status)
# \
# ------------------------------------------------------------ #


# -[ antigen ]------------------------------------------------ #
# /
source ~/antigen.zsh

# - usings
antigen use oh-my-zsh

# - plugins
antigen bundle git
antigen bundle bgnotify
antigen bundle copybuffer
antigen bundle cp
antigen bundle history
antigen bundle gulp
antigen bundle jsontools
antigen bundle git-flow
antigen bundle command-not-found
antigen bundle nyan

antigen bundle   lukechilds/zsh-nvm
antigen bundle    zsh-users/zsh-completions
antigen bundle    zsh-users/zsh-history-substring-search
antigen bundle    zsh-users/zsh-syntax-highlighting
antigen bundle      unixorn/autoupdate-antigen.zshplugin
antigen bundle   ascii-soup/zsh-url-highlighter
antigen bundle      Valodim/zsh-curl-completion
antigen bundle      desyncr/auto-ls
antigen bundle     mafredri/zsh-async
antigen bundle     caarlos0/open-pr kind:path
antigen bundle       ninrod/pass-zsh-completion
antigen bundle     micrenda/zsh-nohup

# - theme
#antigen bundle sindresorhus/pure
# antigen theme halfo/lambda-mod-zsh-theme
# antigen theme agnoster
antigen theme https://github.com/denysdovhan/spaceship-prompt spaceship

# - apply
antigen apply

# \
# ------------------------------------------------------------ #


# -[ bindings ]----------------------------------------------- #
# /
# <Shift+Tab> :: reverse menu select.
# bindkey -M menuselect '^[[Z' reverse-menu-complete
# \
# ------------------------------------------------------------ #

# -[ aliases ]------------------------------------------------ #
# /
e() {
    emacsclient -c "$@" &!
}
# \
# ------------------------------------------------------------ #


# -[ completions ]-------------------------------------------- #
# /
zstyle ':completion:*' insert-tab false
# \
# ------------------------------------------------------------ #


# -[ other ]-------------------------------------------------- #
# /

# \
# ------------------------------------------------------------ #

