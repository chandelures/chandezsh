#!/bin/zsh

## params
app_name="chandezsh"
APP_PATH=`pwd`
REPO_URL="https://github.com/chandelures/chandezsh.vim"
ZPLUG_URL="https://github.com/zplug/zplug"
ZPLUG_HOME="$HOME/.zplug"

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

create_symlinks() {
    ln -sf "$APP_PATH/.zshrc" "$HOME/.zshrc"

    if [ $? -ne 0 ]; then
        msg "Create symbol link Failed!"
        exit 1
    fi

    msg "Create symbol link Successful!"
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

    install_plug_mgr

    create_symlinks

    msg "Done. Plese run source ~/.zshrc && zplug install manually and enjoy it!"
}

## update
update() {
    if program_not_exists 'git'; then
        msg "You don't have git"
        return
    fi

    git pull

    msg "Done."
}

## remove
remove() {
    read "input?Do you really want to remove the $app_name? [Y/n] "

    if [[ "$input" =~ ^[yY]$ ]] then
        rm -f $HOME/.zshrc
        rm -rf $HOME/.zplug
        msg "Done."
    elif [[ "$input" =~ ^[yY]$ ]] then
        msg "Canceled"
    else
        msg "Invalid input"
    fi
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
    msg ""
    msg "https://github.com/chandelures/chandezsh"
}

## main
main() {
    local OPTIND
    local OPTARG

    while getopts ihurp: OPT;
    do
        case $OPT in
            h)
                usage
                exit 0
                ;;
            i)
                install
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
