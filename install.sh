#!/usr/bin/env bash

# /--  runphilrun/dotfiles
#      UBUNTU CONFIG AUTOMATED INSTALLER

# inspired by   https://github.com/nate-wilkins/EvE.Ubuntu
#          and  https://github.com/nate-wilkins/dotfiles
#          used with permission

# //-- SETUP
# exit on failure.
set -e
export PATH="$PATH:$HOME/bin"

# //-- PARSE INPUTS
if    [[ $# -eq 0 ]]; then set -- "--help"; fi
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        start)
            shift
            ;;
        -u|--user)
            CONFIG_USER="$2"
            shift
            shift
            ;;
        -e|--email)
            CONFIG_EMAIL="$2"
            shift
            shift
            ;;
        -t|--task)
            CONFIG_TASK="$2"
            shift
            shift
            ;;
        --dotfiles-repo)
            CONFIG_DOTFILES_REPO="$2"
            shift
            shift
            ;;
       --tasks)
            echo "Tasks:                                                       "
            echo "  install-essential                                          "
            echo "  install-fonts                                              "
            echo "  install-dev                                                "
            echo "  install-editor                                             "
            echo "  install-shell                                              "
            echo "  install-browser                                            "
            echo "  install-social                                             "
            echo "  install-laptop                                             "
            echo "  install-other                                              "
            echo "                                                             "
            echo "  config-dotfiles                                            "
            echo "                                                             "
            exit 0
            ;;
       *)
            echo "Usage:                                                                   "
            echo "  sudo bash install.sh start                                             "
            echo "                                                                         "
            echo "Options:                                                                 "
            echo "  -u | --user            user in which you're installing for. (optional) "
            echo "  -e | --email           email to provide setup for. (optional)          "
            echo "  -t | --task [all]      execute a particular set of task(s).            "
            echo "       --dotfiles-repo   sets external dotfiles repo location.           "
            echo "       --tasks           lists all available tasks.                      "
            echo "                                                                         "
            echo "Example:                                                                 "
            echo "  sudo bash install.sh start                                             "
            echo "  sudo bash install.sh start --task install-essentials:config-dotfiles   "
            shift
            exit 1
            ;;
    esac
done

# script must be run as root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Unable to proceed. Script must be run as root."
    echo "  sudo bash install.sh"
    exit -2
fi

CONFIG_USER=${CONFIG_USER:=$(logname)} # Use logname by default
CONFIG_EMAIL=$EMAIL
CONFIG_TASK=${CONFIG_TASK:=all}
CONFIG_DOTFILES_REPO=${CONFIG_DOTFILES_REPO:=$0:A} # Use install.sh directory by default

echo " -------------------------------          "
echo "| AUTOMATED UBUNTU CONFIGURATOR |         "
echo " -------------------------------          "
echo "                                          "
echo "/-- options --/                           "
echo "user=$CONFIG_USER                         "
echo "dirname=$ROOT_DIR                         "
echo "--email=$CONFIG_EMAIL                     "
echo "--task=$CONFIG_TASK                       "
echo "--dotfiles-repo=$CONFIG_DOTFILES_REPO     "
echo "                                          "

# //-- SCRIPTED INSTALLATION FUNCTIONS
install_essentials() {
    echo "/-- essentials --/"
    echo "                  "
    echo "/- tools -/"
    apt-get install -y git
    apt-get install -y curl
    apt-get install -y wget
    apt-get install -y build-essential
    apt-get install -y cmake
    apt-get install -y xorg
    apt-get install -y python3
    echo "/- update -/"
    apt-get update -y
    apt-get upgrade -y
}

install_dev() {
    echo "/--    dev     --/"
    echo "                  "
    echo "/- python env -/"
    # pyenv                           manage default python version
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshenv
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshenv
    echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshenv
    source ~/.zshenv
    pyenv install 3.7.0
    pyenv global 3.7.0

    # pip                             python library manager
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python get-pip.py

    echo "/- latex env -/"
    apt-get install -y pandoc        # universal document converter
    install texlive                  # a fully featured LaTeX distribution
    install texlive-latex-extra --no-install-recommends # even more LaTeX packages
    install latexmk                  # build PDFs from .tex files

    echo "/- other tools -/"
    apt-get install -y git-flow      # git extensions
    apt-get install -y nmap          # network exploration tool
    apt-get install -y unclutter     # hide cursor when idle
}

install_fonts() {
    echo "/--    fonts   --/"
    echo "                  "

    echo "/- powerline -/"
    apt-get install -y fonts-powerline # rich fonts for powerline, zsh

    echo "/- source code pro -/"
    [ -d /usr/share/fonts/opentype ] || mkdir -p /usr/share/fonts/opentype
    [ -d /usr/share/fonts/opentype/scp ] && rm -r /usr/share/fonts/opentype/scp
    git clone --depth 1 --branch release https://github.com/adobe-fonts/source-code-pro.git /usr/share/fonts/opentype/scp

    echo "/- hack -/"
    [ -d /usr/local/src/hack ] && rm -r /usr/local/src/hack
    git clone https://github.com/source-foundry/hack /usr/local/src/hack
    [ -d /usr/share/fonts/hack ] && rm -r /usr/share/fonts/hack
    mkdir -p /usr/share/fonts/hack
    cp /usr/local/src/hack/build/ttf/* /usr/local/share/fonts/

    echo "/- reload fonts -/"
    fc-cache -f -v
}

install_shell() {
    echo "/--    shell   --/"
    echo "                  "
    apt-get install -y xclip         # command line copy and paste

    echo "/- exa -/"                 # beautiful replacemnet to ls
    wget -0 /tmp/exa.zip "https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip"
    [ -f /usr/local/src/exa-linux-x86_64 ] && rm -f /usr/local/src/exa-linux-x86_64
    unzip /tmp/exa.zip -d /usr/local/src/
    [ -f /usr/local/bin/exa ] && rm -f /usr/local/bin/exa
    ln -s /usr/local/src/exa-linux-x86_64 /usr/local/bin/exa
    chown $CONFIG_USER:$CONFIG_USER /usr/local/bin/exa
    chmod +x /usr/local/bin/exa

    echo "/- zsh -/"
    apt-get install -y zsh           # shell designed for interactive use
    apt-get install -y zsh-antigen   # plugin manager for zsh
    [ -f /home/$CONFIG_USER/antigen.zsh ] && rm -f /home/$CONFIG_USER/antigen.zsh
    ln -s /usr/share/zsh-antigen/antigen.zsh /home/$CONFIG_USER/antigen.zsh
    chsh -s `which zsh`              # set zsh to main shell
}

install_editor() {
    echo "/--   editor   --/"
    echo "                  "

    echo "/- emacs -/"
    add-apt-repository ppa:kelleyk/emacs
    apt-get update
    apt-get install -y emacs26        # extensible, customizable, free/libre text editor.

    # configure emacs to run as a server for lightning fast load times
    [ -f "/etc/systemd/system/emacs.service" ] && rm -f "/etc/systemd/system/emacs.service"
    cp -p "$ROOT_DIR/systemd/emacs.service" "/etc/systemd/system/emacs.service"
    systemctl --user disable emacs.service && systemctl --user enable emacs.service
    systemctl --user start emacs.service && echo "  emacs server started"

    echo "/- spacemacs -/"           # emacs with vi bindings plus lots of useful plugins
    [ -d "/home/$CONFIG_USER/.emacs.d" ] && rm -rf "/home/$CONFIG_USER/.emacs.d"
    runuser -l $CONFIG_USER -c "git clone https://github.com/syl20bnr/spacemacs /home/$CONFIG_USER/.emacs.d"
    # apply dotfile
    echo "delete this after spacemacs dotfile is setup!"
}

install_browser() {
    echo "/--  browser --/"
    echo "                "
    # chrome                       fast and syncs account, bookmarks, extensions, and settings across all devices
    wget -O /tmp/chrome.deb        "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    dpkg -i /tmp/chrome.deb || apt-get install -f -y
}

install_social() {
    echo "/--  browser --/"
    echo "                "
    # slack                        efficient workplace chat
    wget -0 /tmp/slack.deb         "https://"
    dpkg -i /tmp/slack.deb || apt-get install -f -y

    # discord                      voice and text chat
    wget -0 /tmp/discord.deb       "https://discordapp.com/api/download?platform=linux&format=deb"
    dpkg -i /tmp/discord.deb || apt-get install -f -y

}

install_laptop() {
    echo "/--  laptop  --/"
    echo "                "

    # libinput-gestures            mac-like gestures for workspaces
    gpasswd -a $USER input # add the user as a member of the input group to have permission to access the touchpad
    sudo apt-get install xdotool wmctrl libinput-tools # install prerequisites
    git clone https://github.com/bulletmark/libinput-gestures.git /user/local/src/libinput-gestures
    /user/local/src/libinput-gestures/libinput-gestures-setup install
    libinput-gestures-setup autostart
    libinput-gestures-setup start
}

install_other() {
    echo "/--   other   --/"
    echo "                 "

    echo "/- music -/"
    snap install spotify           # subscription based unlimited music streaming
}
