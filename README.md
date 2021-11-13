# Terminal Setup Note

My terminal setup note for WSL, macOS, and Windows

## Install Terminal

### macOS

* [iTerm2](https://iterm2.com/)

#### Config iTerm

1. Download the [iTerm Profile](https://github.com/saltchang/terminal-setup-note/blob/main/terminal/iTerm/Salt_iTerm_Profile.json)
2. Open your iTerm > Preferences > Profiles > Other Actions > Import JSON Profiles > Choose the one you just downloaded: `Salt_iTerm_Profile.json`
3. After you setup: Other Actions > Set as Default > Restart iTerm
4. Done

## Install zsh

### Ubuntu/Debian

```bash
sudo apt update && sudo apt -y install zsh
```

### macOS

```bash
# Use Homebrew
brew install zsh
```

### Change zsh to your default shell

```bash
chsh -s $(which zsh)

# Then restart your terminal
```

## Setup shell profile

Please copy the content in [.zshrc_example](https://github.com/saltchang/terminal-setup-note/blob/main/terminal/zsh/.zshrc_example), and paste into your `~/.zshrc`.

If you have no `.zshrc` in your home directory, please create one: `touch ~/.zshrc`

Or use the below command to quickly create one from the source:

```bash
curl -L https://raw.githubusercontent.com/saltchang/terminal-setup-note/main/terminal/zsh/.zshrc_example -o $HOME/.zshrc
```

Change the content in `.zshrc` to customize your shell.

Now restart your terminal, and enjoy.

### Color for powerlevel10k

If you would like to customize the color scheme of powerlevel10k, please see [This chart](https://user-images.githubusercontent.com/704406/43988708-64c0fa52-9d4c-11e8-8cf9-c4d4b97a5200.png)

## Font

### FiraCode

#### Ubuntu/Debian

```bash
sudo apt install fonts-firacode
```

#### macOS

```bash
brew tap homebrew/cask-fonts
brew install --cask font-fira-code
```

### Other NerdFont

* [FuraCode](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip)
* [SourceCodePro](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/SourceCodePro.zip)
* [Menlo](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip)
* [Other](https://www.nerdfonts.com/font-downloads)

## Shortcut

### Install Go

You can use the folloing command to install [Go Language](https://golang.org/) quickly:

```bash
bash <(curl -s https://raw.githubusercontent.com/saltchang/terminal-setup-note/main/scripts/install-go.sh)
```
