#!/bin/bash

## parameters
app_name="chandezsh"
APP_PATH=`pwd`
[ -z $REPO_URL ] && REPO_URL="https://github.com/chandelures/chandezsh.git"
[ -z $OH_MY_ZSH ] && OH_MY_ZSH="https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh"

ret=0

## basic tools

msg() {
    printf '%b\n' "$1" >&2
}

success() {
    local success_message="$1"

    if [ "$ret" -eq 0 ]; then
        msg "\033[32m[sucess] ${success_message}\033[0m"
    fi
}

error() {
    local error_message="$1"

    msg "\033[31m[error] ${error_message}\033[0m"
}

dir_exist() {
    local dir="$1"

    if [ ! $dir ]; then
        error "You do not have the $dir directory"
        exit 0
    fi
}

program_exists() {
    local ret='0'
    command -v $1 >/dev/null 2>&1 || { local ret='1'; }
    if [ "$ret" -ne 0 ]; then
        return 1
    fi
    return 0
}

program_must_exist() {
    local program="$1"

    program_exists $program
    if [ "$?" -ne 0 ]; then
        error "You must have '$program' installed to continue."
    fi
}

ln_if_exit() {
    local source_path="$1"
    local target_path="$2"
    
    if [ -e "$source_path" ]; then
        ln -sf "$source_path" "$target_path"
    else
        error "Failed to create the symlink between $source_path and $target_path"
        return 1
    fi
    ret="$?"
    success "The symlink between $source_path and $target_path has been create"
}

rm_if_exit() {
    local rm_file="$1"

    if [ -e "$rm_file" ]; then
        rm -rf "$rm_file"
    else
        msg "$rm_file is not exits"
    fi
    ret="$?"
    success "$rm_file has been deleted"
}

## install functions
backup() {
    local backup_files=("$@")
    for backup_file in $backup_files;
    do
        [ -e "$backup_file" ] && [ ! -L "$backup_file" ] && mv -v "$backup_file" "${backup_file}.bak";
    done
    ret="$?"
    success "Your original zsh configruation has been backed up!"
}

create_symlinks() {
    local source_path="$1"
    local target_path="$2"

    ln_if_exit "$source_path/.zshrc" "$target_path/.zshrc"

    ret="$?"
    success "Setting up all zsh configration symlinks."
}

## command functions

install() {
    msg "Start to install $app_name"

    program_must_exist "zsh"

    dir_exist "$HOME"
    dir_exist "$HOME/.oh-my-zsh"

    create_symlinks "$APP_PATH" \
                    "$HOME"

    ret="$?"

    if [ "$ret" -eq 0 ]; then
        success "Done!"
        success "Thanks for installing $app_name."
    else
        error "Failed to install $app_name"
    fi
}

upgrade() {
    if program_exists "git"; then
        git pull
    else
        error "git is not installed in this system"
    fi

    create_symlinks "$APP_PATH" \
                    "$HOME"

    ret="$?"

    if [ "$ret" -eq 0 ]; then
        success "Done!"
        success "Upgrade $app_name successfully"
    else
        error "Failed to upgrade $app_name"
    fi
}

remove() {
    read -r -p "Do you really want to remove the $app_name? [Y/n]" input
    
    case $input in
        [yY][eR][sS]|[yY])
            msg "Start to remove $app_name"
            rm_if_exit $HOME/.zshrc
            rm_if_exit $HOME/.oh-my-zsh
            echo
            msg "Thanks for using $app_name"
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

usage() {
    msg "  USAGE:"
    msg "    ./${app_name}.sh [parameter]"
    msg "  PARAMETER:"
    msg "    -i  or  --install        Install the $app_name"
    msg "    -u  or  --upgrade        Upgrade the $app_name"
    msg "    -r  or  --remove         Remove the $app_name"
    msg "    -h  or  --help           Display this message"
}

## main
function main(){
    local OPTIND
    local OPTARG
    while getopts iurh-: OPT;
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
                    upgrade)
                        upgrade
                        exit 0
                        ;;
                    remove)
                        remove
                        exit 0
                        ;;
                    \?)
                        usage
                        exit 0
                        ;;
                esac
                ;;
            o)
                set_oh_my_zsh
                exit 0
                ;;
            i)
                install
                exit 0
                ;;
            u)
                upgrade
                exit 0
                ;;
            h)
                usage
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
}

main $@
