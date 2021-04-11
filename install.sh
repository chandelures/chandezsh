#!/bin/bash

## params
app_name="chandezsh"

REPO_URL="https://github.com/chandelures/chandezsh.vim"

ZPLUG_URL="https://github.com/zplug/zplug"

ZPLUG_HOME="$HOME/.zplug"

ZSHRC_URL="https://raw.githubusercontent.com/chandelures/chandezsh/master/.zshrc"

CURL="curl"

## basic function
msg() {
    echo "[info] $1"
}

err() {
    echo "[error] $1"
}

## tools
backup() {
    local backup_files=("$@")

    for backup_file in $backup_files;
    do
        [ -e "$backup_file" ] && mv -v "$backup_file" "$backup_file.bak";
    done
}

program_not_exists() {
    local ret='0'

    command -v $1 > /dev/null 2>&1 || { local ret='1'; }

    if [ "$ret" -ne 0 ]; then
        return 0
    fi

    return 1
}

programs_check() {
    local programs=("$@")

    for program in $programs;
    do
        if program_not_exists $program; then
            err "You don't have $program."
            exit 1
        fi
    done
}

process_check() {
    local status=$1
    local process_name=$2

    if [ $1 -ne 0 ]; then
        err "$process_name Failed!"
        exit 1
    fi

    msg "$process_name Successful"
}

download_zshrc() {
    $CURL -fLo "$HOME/.zshrc" "$ZSHRC_URL"

    process_check $? "Download zshrc"
}

install_plug_mgr() {
    git clone $ZPLUG_URL $ZPLUG_HOME

    process_check $? "Install plugin manager"
}

## install
install() {
    programs_check "curl" "zsh"

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
    programs_check "curl" "zsh"

    download_zshrc

    msg "Done."
}

## remove
remove() {
    read -r -p "Do you really want to remove the $app_name? [Y/n] " input

    case $input in
        [yY][eR][sS]|[yY])
            rm -rf $HOME/.zplug
            rm -rf $HOME/.zshrc
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

    while getopts ihurp: OPT;
    do
        case $OPT in
            p)
                export CURL="curl -x $OPTARG"
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
