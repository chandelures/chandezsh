# Chandezsh

Chandezsh is a personal zsh configuration. It obtains some themes and plugins make zsh easier to use. It also provide a script to install/update/remove the zsh configuration.

## Usage

### install

first you should install the zsh and oh-my-zsh, the way to install oh-my-zsh is

```shell
$ sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

then

```shell
$ git clone https://github.com/chandelures/chandezsh
$ cd chandezsh
$ ./install.zsh
$ source ~/.zshrc
$ zplug install
```

### update

```shell
$ ./isntall.zsh -u
$ zplug update
```

### Remove

```shell
$ ./install.zsh -r
```



