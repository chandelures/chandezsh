#!/bin/zsh

## params
app_name="chandezsh"
APP_PATH=`pwd`
REPO_URL="https://github.com/chandelures/chandezsh.vim"

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
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh 
}

## install
install() {
    if program_not_exists 'curl'; then
        msg "You don't have curl."
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

    if [ ! -e "$HOME/.zplug" ]; then
        msg "Install plug manager failed"
    fi

    create_symlinks
}

## remove
remove() {
    read "input?Do you really want to remove the $app_name? [Y/n]"

    if [[ "$input" =~ ^[yY]$ ]] then
        rm -f $HOME/.zshrc
        rm -rf $HOME/.zplug
    elif [[ "$input" =~ ^[yY]$ ]] then
        msg "Canceled"
    else
        msg "Invalid input"
    fi
}

## main
main() {
    local OPTIND
    local OPTARG
    while getopts ihur-: OPT;
    do
        case $OPT in
            -)
                case $OPTARG in
                    help)
                        usage
                        exit 0
                        ;;
                    install)
                        install
                        exit 0
                        ;;
                    remove)
                        remove
                        exit 0
                        ;;
                    *)
                        usage
                        exit 1
                        ;;
                esac
                ;;
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
