# Terminal Setup Note

依照此篇筆記順序安裝設定即可。

## 安裝及設定 iTerm2

請先安裝 [iTerm2](https://iterm2.com/)

## 安裝 zsh

### 在 Ubuntu/Debian 安裝 zsh

```bash
# 更新 apt
sudo apt update

# 安裝 zsh
sudo apt install zsh

# 或者
sudo apt-get install zsh
```

### 在 macOS 安裝 zsh

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

### 設定 .zshrc

設定請參考這個檔案： [.zshrc_for_unix](https://raw.githubusercontent.com/saltchang/terminal-setup-note/main/terminal/zsh/.zshrc_for_xnix)

將其中的內容貼到 `~/.zshrc` 即可

## 安裝 oh-my-zsh

### 安裝需求

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

選一種可以使用的就好

## 安裝 powerlevel10k

### 搭配 oh-my-zsh 安裝

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
```

### 顏色配置

如果要修改 powerlevel10k 的顏色設定  
可使用[這個圖表](https://user-images.githubusercontent.com/704406/43988708-64c0fa52-9d4c-11e8-8cf9-c4d4b97a5200.png)當中的色碼來搭配 Powerlevel9k/10k 進行配置

如果沒有要修改配色則可以直接進行下一步驟

## 安裝字型

### FiraCode

VS Code 建議使用 FiraCode

- Ubuntu/Debian

```bash
sudo apt install fonts-firacode
```

- macOS

```bash
brew tap homebrew/cask-fonts
brew install --cask font-fira-code
```

### FiraCode with nerdfont

下載： [FuraCode](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraCode.zip)

### Menlo

iTerm 使用 Menlo

下載： [Menlo](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Meslo.zip)

### 其他 NerdFont

[下載連結](https://www.nerdfonts.com/font-downloads)

### 設定 iTerm2

1. 下載 [iTerm Profile](https://github.com/saltchang/terminal-setup-note/blob/main/terminal/iTerm/Salt_iTerm_Profile.json)
2. 打開 iTerm > Preferences > Profiles > Other Actions > Import JSON Profiles > 選擇剛剛下載的 `Salt_iTerm_Profile.json`
3. 匯入設定之後： Other Actions > Set as Default > Restart iTerm
4. 完成
