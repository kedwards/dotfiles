## 🗿 Overview

This [dotfiles](https://github.com/shunk031/dotfiles) repository is managed with [`chezmoi🏠`](https://www.chezmoi.io/), a great dotfiles manager.
The setup scripts are aimed for [MacOS](https://www.apple.com/jp/macos), [Ubuntu Desktop](https://ubuntu.com/desktop), and [Ubuntu Server](https://ubuntu.com/server). The first two (MacOS/Ubuntu Desktop) include settings for `client` machines and the latter one (Ubuntu Server) for `server` machines.



Dotfiles, managed with [Chezmoi](https://www.chezmoi.io/).

**IMPORTANT:** While many dotfile repositories are designed to be forked, mine are not. These are customized for my personal use and likely contain many things you won't need or want to use. Posting publicly so you can see how I manage my dotfiles and maybe get some ideas for how to manage your own.

The actual dotfiles exist under the [`home`](https://github.com/kedwards/dotfiles/tree/main/home) directory specified in the [`.chezmoiroot`](https://github.com/kedwards/dotfiles/blob/main/.chezmoiroot).
See [.chezmoiroot - chezmoi](https://www.chezmoi.io/reference/special-files-and-directories/chezmoiroot/) more detail on the setting.

## Install

-   [Chezmoi](https://www.chezmoi.io/)

**Ensure required software is installed before proceeding.** There are many ways to install Chezmoi. Check the [official documentation](https://www.chezmoi.io/install/) for the most up-to-date instructions. To install chezmoi and these dotfiles in a single command run the following:

## Testing

make docker

```bash
docker build -t chezmoi . --build-arg USERNAME="$(whoami)"
docker run -it -v "$(pwd):/home/$(whoami)/.local/share/chezmoi" chezmoi /bin/bash --login
```

## First Run

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply kedwards
```

## Daily Usage

After Chezmoi is installed, use the following commands.

```bash
# Initialize chezmoi configuration and apply the dotfiles (first run)
chezmoi init kedwards

# Check for common problems.
chezmoi doctor

# Update dotfiles from the source directory.
chezmoi apply

# Pull the latest changes from your remote repo and runs chezmoi apply.
chezmoi update
```
