# Terminal 設定

## zsh

### 在不同系統安裝 zsh

- Ubuntu/Debian

```bash
# 更新 apt
sudo apt update

# 安裝 zsh
sudo apt install zsh
# 或者
sudo apt-get install zsh
```

- macOS

```bash
# 使用 brew 安裝 zsh
brew install zsh
```

### 將 zsh 設為預設的 shell

```bash
chsh -s $(which zsh)
```

接著重新啟動終端機  
你會看見初始的訊息

## oh-my-zsh

### 安裝需求

- `curl` 或 `wget`
- `git`

### 基本安裝

有兩種方法

- curl

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

- wget

```bash
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## powerlevel10k

### 搭配 oh-my-zsh 安裝

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
```

## 安裝字型

### FiraCode

- Ubuntu/Debian

```bash
sudo apt install fonts-firacode
```

- macOS

```bash
brew tap homebrew/cask-fonts
brew cask install font-fira-code
```

### 其他 NerdFont

[下載連結](https://www.nerdfonts.com/font-downloads)
