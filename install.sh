#!/bin/bash

## params
app_name="chandezsh"

APP_PATH=`pwd`

REPO_URL="https://github.com/chandelures/chandezsh.vim"

ZPLUG_URL="https://github.com/zplug/zplug"

ZPLUG_HOME="$HOME/.zplug"

ZSHRC_URL="https://raw.githubusercontent.com/chandelures/chandezsh/master/.zshrc"

## basic function
msg() {
    echo "$1"
}

## tools
backup() {
    local backup_files=("#@")

    for backup_file in $backup_files;
    do
        [ -e "$backup_file" ] && [ ! -L "$backup_file" ] && mv -v "$backup_file" "${backup_file}.bak";
    done
}

download_zshrc() {
    $curl -fLo "$HOME/.zshrc" "$ZSHRC_URL"

    if [ $? -ne 0 ]; then
        msg "Download zshrc Failed!"
        exit 1
    fi

    msg "Download zshrc Successful!"
}

program_not_exists() {
    local ret='0'

    command -v $1 > /dev/null 2>&1 || { local ret='1'; }

    if [ "$ret" -ne 0 ]; then
        return 0
    fi

    return 1
}

install_plug_mgr() {
    git clone $ZPLUG_URL $ZPLUG_HOME

    if [ $? -ne 0 ]; then
        msg "Install plugin manager Failed!"
        exit 1
    fi

    msg "Install plugin manager Successful!"
}

## install
install() {
    if program_not_exists 'git'; then
        msg "You don't have git."
        return
    fi

    if program_not_exists 'zsh'; then
        msg "You don't have zsh."
    fi

    if [ ! -e "$HOME/.oh-my-zsh" ]; then
        msg "You don't have oh-my-zsh."
    fi

    backup "$HOME/.zshrc"

    download_zshrc

    install_plug_mgr

    msg "Done."
}

## update
update() {
    if program_not_exists 'git'; then
        msg "You don't have git"
        return
    fi

    download_zshrc

    msg "Done."
}

## remove
remove() {
    read -r -p "Do you really want to remove the $app_name? [Y/n] " input

    case $input in
        [yY][eR][sS]|[yY])
            rm -rf $HOME/.zplug
            msg "Done."
            exit 0
            ;;
        [nN][oO]|[nN])
            msg "Canceled"
            exit 0
            ;;
        *)
            msg "Invalid input"
            exit 1
            ;;
    esac
}

## usage
usage() {
    msg "USAGE:"
    msg "    ./install.sh [parameter]"
    msg "PARAMETER:"
    msg "    -i        Install the $app_name"
    msg "    -u        Update the $app_name"
    msg "    -r        Remove the $app_name"
    msg "    -h        Display this message"
    msg "    -p        Proxy setting"
    msg ""
    msg $REPO_URL
}

## main
main() {
    local OPTIND
    local OPTARG

    local proxy_flag=""
    export curl="curl"

    while getopts ihurp: OPT;
    do
        case $OPT in
            p)
                export curl="curl -x $OPTARG"
                ;;
            h)
                usage
                exit 0
                ;;
            i)
                install 
                exit 0
                ;;
            u)
                update
                exit 0
                ;;
            r)
                remove
                exit 0
                ;;
            \?)
                usage
                exit 1
                ;;
        esac
    done
    install
}

main $@
