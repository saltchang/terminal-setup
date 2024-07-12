# Terminal Setup

Terminal setup for zsh in macOS, Linux, and Windows.

![Terminal Demo](./images/demo-terminal.png)

## Pre-requirements for macOS

### Install & Config iTerm

1. Install [iTerm2](https://iterm2.com/)
2. Open your iTerm > Settings > Profiles > Other Actions > Import JSON Profiles > Choose this [iTerm Profile](./terminal-config/iTerm/Salty_iTerm_Profile.json)
3. After you setup: Other Actions > Set as Default
4. Restart iTerm

*For Windows, see [Windows Section](#windows)*

## Auto Installation (Recommended)

1. To customize your own configs, you can fork this project before running the below installation script

2. Run the below to setup the terminal automatically:

    ```bash
    sudo curl -s https://raw.githubusercontent.com/saltchang/terminal-setup/main/auto-install.sh | bash
    ```

    It will setup the terminal by the below steps:

    1. Install homebrew, coreutils, python and pipx for macOS
    2. Install fonts: Meslo & Fira Code
    3. Install and setup zsh
    4. Clone this project into `$HOME/projects/personal/terminal-setup`
    5. Create a soft link from `$HOME/.zshrc` to the one in this project
    6. Create a soft link from `$HOME/.p10k.zsh` to the one in this project
    7. Create a soft link from `$HOME/.local/terminal-setup/bin` to the one in this project

3. After the installation, restart your terminal or run `source $HOME/.zshrc`, you should see the new face of the shell

## Manual Installation

### Customize Your Configs

To customize your own configs, you can fork this project before the below steps.

### Setup for macOS

#### Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Install Coreutils

```bash
brew install coreutils
```

#### Install Python & Pipx

```bash
brew install python
brew install pipx
```

### Install Nerd Fonts

Please install at least one of the below fonts for your terminal, [Menlo](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip) is recommended.

- [Menlo](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip)
- [FuraCode](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip)

See all [Nerd Fonts](https://www.nerdfonts.com/font-downloads).

#### FiraCode

Fira Code is recommended for your editor such as [VS Code](https://code.visualstudio.com).

##### macOS

```bash
brew tap homebrew/cask-fonts
brew install --cask font-fira-code
```

##### Ubuntu/Debian

```bash
sudo apt install fonts-firacode
```

### Clone This Project

It's recommended to put the project under `$HOME/projects/personal`:

```bash
mkdir -p $HOME/projects/personal
cd $HOME/projects/personal
```

Then clone this project (if you forked it, replace the URL with your own):

- use SSH

    ```bash
    git clone git@github.com:saltchang/terminal-setup.git
    ```

- use HTTPS

    ```bash
    git clone https://github.com/saltchang/terminal-setup.git
    ```

### Install zsh

#### macOS

*Since **Catalina**, macOS will use zsh as the default shell, so you should have zsh built-in in your system*

#### Ubuntu/Debian

```bash
sudo apt update && sudo apt -y install zsh
```

Then restart your terminal

### Setup the Shell

To setup the shell, just run the installation script:

```bash
cd terminal-setup

./install.sh
```

It will create a soft link from `~/.zshrc` to the one in this project, check `dotfiles/.zshrc`.

Now restart your terminal or run `source ~/.zshrc`, you should see the new face of the shell.

## Customize Your Shell

Run the below command to open your `.zshrc`:

```bash
edit-rc
```

Or use the shortcut to go to the `terminal-setup` repo:

```bash
go-rc-repo
```

The you can start to customize your shell.

## Color for powerlevel10k

If you would like to customize the color scheme of powerlevel10k, please see [This chart](https://user-images.githubusercontent.com/704406/43988708-64c0fa52-9d4c-11e8-8cf9-c4d4b97a5200.png).

## Windows

### Config Windows Terminal

1. Open your Windows Terminal > Settings > Open JSON file
2. Copy json configs from this [config file](./terminal-config/windows-terminal/windows-terminal-profile.json)
3. Paste the config to the Windows Terminal config json you just opened
4. Restart Windows Terminal

### Setup PowerShell

See [PowerShell Setup](./posh/README.md)
