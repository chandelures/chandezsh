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
$ bash -c "$(curl -L https://raw.githubusercontent.com/chandelures/chandevim/master/install.sh)"
$ source ~/.zshrc
$ zplug install
```

### update

```shell
$ bash -c "$(curl -L https://raw.githubusercontent.com/chandelures/chandevim/master/install.sh)" @ -u
$ zplug update
```

### Remove

```shell
$ bash -c "$(curl -L https://raw.githubusercontent.com/chandelures/chandevim/master/install.sh)" @ -r
```
