# Dotfiles Setup

Instructions for getting a new Windows 11 machine set up.

## 1. Package Manager

Install [Chocolatey](https://chocolatey.org/install) or use **winget** (built into Windows 11 — no install needed).

## 2. Core Applications

```powershell
# Terminal multiplexer
winget install marlocarlo.psmux

# Neovim
winget install Neovim.Neovim

# Oh My Posh (prompt styling)
winget install JanDeDobbeleer.OhMyPosh

# Git
winget install Git.Git
```

## 3. CLI Tools

These are used in the PowerShell profile for fuzzy finding, file search, and grep.

```powershell
winget install junegunn.fzf
winget install sharkdp.fd
winget install BurntSushi.ripgrep.MSVC
```

## 4. PowerShell Modules

Open PowerShell and run:

```powershell
Install-Module PSReadLine -Force
Install-Module Terminal-Icons -Force
Install-Module posh-git -Force
Install-Module z -Force
Install-Module PSFzf -Force
```

## 5. Psmux Plugins

Plugins are managed by **ppm** (Psmux Plugin Manager). First install ppm, then use it to install the rest.

**Install ppm:**

```powershell
git clone https://github.com/psmux/psmux-plugins.git "$env:TEMP\psmux-plugins"
Copy-Item "$env:TEMP\psmux-plugins\ppm" "$env:USERPROFILE\.psmux\plugins\ppm" -Recurse
Remove-Item "$env:TEMP\psmux-plugins" -Recurse -Force
```

**Install plugins:**

Start a psmux session, then press `Prefix + I` (your prefix is `Ctrl+a`). ppm will read your `.tmux.conf` and install the declared plugins:

- `psmux-plugins/psmux-sensible` — sensible defaults
- `psmux-plugins/psmux-resurrect` — save and restore sessions
- `psmux-plugins/psmux-continuum` — automatic session saving

## 6. Nerd Font

Oh My Posh requires a Nerd Font to render prompt icons correctly. Install your preferred font from [nerdfonts.com](https://www.nerdfonts.com), then set it in Windows Terminal under **Settings > Profiles > Appearance > Font face**.

## 6. Windows Terminal

Install from the Microsoft Store if not already present:

```powershell
winget install Microsoft.WindowsTerminal
```
