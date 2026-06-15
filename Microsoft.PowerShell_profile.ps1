# ===========================================================================
# PATH — refresh from registry so winget installs are always available
# ===========================================================================

$_machinePath = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine')
$_userPath    = [System.Environment]::GetEnvironmentVariable('PATH', 'User')
$env:PATH     = "$_userPath;$_machinePath"
Remove-Variable _machinePath, _userPath

# ===========================================================================
# PSReadLine — load the updated version BEFORE oh-my-posh so its init script
# sees the newer API (oh-my-posh queries PSReadLine key handlers at startup)
# ===========================================================================

if (Get-Module -ListAvailable -Name PSReadLine | Where-Object { $_.Version -ge '2.2' }) {
    Import-Module -Name PSReadLine -MinimumVersion 2.2 -ErrorAction SilentlyContinue
}

# ===========================================================================
# Oh My Posh
# ===========================================================================

if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config "$HOME\.config\oh-my-posh\theme.omp.json" | Invoke-Expression
}

# ===========================================================================
# Modules (skip gracefully if not installed)
# ===========================================================================

foreach ($mod in @('Terminal-Icons', 'posh-git', 'z', 'PSFzf')) {
    if (Get-Module -ListAvailable -Name $mod -ErrorAction SilentlyContinue) {
        Import-Module -Name $mod -ErrorAction SilentlyContinue
    }
}

# ===========================================================================
# PSReadLine — key bindings and appearance
# ===========================================================================

# Up/down arrow searches history by prefix
Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PSReadLineOption -EditMode Windows

# Inline prediction list (requires PSReadLine 2.2+)
$psrlVersion = (Get-Module PSReadLine).Version
if ($psrlVersion -ge '2.2') {
    try {
        Set-PSReadLineOption -PredictionSource HistoryAndPlugin
        Set-PSReadLineOption -PredictionViewStyle ListView
    } catch { }
}

# Syntax colors
$colors = @{
    Command   = '#82aaff'
    Parameter = '#c3e88d'
    Operator  = '#89ddff'
    Variable  = '#c099ff'
    String    = '#c3e88d'
    Number    = '#ff9e64'
    Type      = '#ffc777'
    Comment   = '#636da6'
}
# InlinePrediction was added in PSReadLine 2.2
if ($psrlVersion -ge '2.2') {
    $colors['InlinePrediction'] = '#636da6'
}
try { Set-PSReadLineOption -Colors $colors } catch { }
Remove-Variable colors, psrlVersion

# ===========================================================================
# PSFzf key bindings (only if module loaded)
# ===========================================================================

if (Get-Command Set-PsFzfOption -ErrorAction SilentlyContinue) {
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

# ===========================================================================
# fzf — fuzzy finder settings
# ===========================================================================

$env:FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'
$env:FZF_CTRL_T_COMMAND  = $env:FZF_DEFAULT_COMMAND
$env:FZF_ALT_C_COMMAND   = 'fd --type d --hidden --follow --exclude .git'
$env:FZF_DEFAULT_OPTS    = '--height 40% --layout=reverse --border ' +
    '--color=bg+:#2f334d,bg:#1e2030,spinner:#c3e88d,hl:#82aaff ' +
    '--color=fg:#c8d3f5,header:#82aaff,info:#ffc777,pointer:#c3e88d ' +
    '--color=marker:#c3e88d,fg+:#c8d3f5,prompt:#82aaff,hl+:#82aaff'

# ===========================================================================
# Environment
# ===========================================================================

$env:EDITOR = 'nvim'
$env:VISUAL = 'nvim'

# ===========================================================================
# Aliases — Navigation
# ===========================================================================

function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }
function ~ { Set-Location $HOME }

# ===========================================================================
# Aliases — Listing
# ===========================================================================

function ll { Get-ChildItem -Force @args }
function la { Get-ChildItem -Force -Hidden @args }

# ===========================================================================
# Aliases — Editor
# ===========================================================================

Set-Alias -Name vi  -Value nvim -Force -Option AllScope
Set-Alias -Name vim -Value nvim -Force -Option AllScope
function nv  { nvim @args }

function nve {
    nvim . +Neotree
}

function nvf {
    $file = fzf --preview 'cat {}'
    if ($file) { nvim $file }
}

# ===========================================================================
# Aliases — Git
# ===========================================================================

function gs   { git status @args }
function ga   { git add @args }
function gc   { git commit @args }
function gp   { git push @args }
function gl   { git pull @args }
function gd   { git diff @args }
function gco  { git checkout @args }
function gb   { git branch @args }
function gst  { git stash @args }
function glog { git log --oneline --graph --decorate @args }

function gfco {
    $branch = git branch --all |
        Where-Object { $_ -notmatch 'HEAD' } |
        ForEach-Object { $_ -replace 'remotes/origin/', '' } |
        Sort-Object -Unique |
        fzf --prompt 'Branch> '
    if ($branch) { git checkout $branch.Trim() }
}

# ===========================================================================
# Aliases — tmux
# ===========================================================================

function ta  { tmux attach -t @args }
function tn  { tmux new -s @args }
function tl  { tmux list-sessions }
function tk  { tmux kill-session -t @args }
function tka { tmux kill-server }

function tm {
    tmux new-session -A -s main
}

function ts {
    $sessions = tmux list-sessions -F '#S' 2>$null
    if (-not $sessions) { Write-Host 'No tmux sessions'; return }
    $target = $sessions | fzf --prompt 'Session> '
    if ($target) {
        if ($env:TMUX) { tmux switch-client -t $target }
        else           { tmux attach -t $target }
    }
}

# ===========================================================================
# Aliases — System
# ===========================================================================

function c     { Clear-Host }
function which { Get-Command @args | Select-Object -ExpandProperty Source }

function reload {
    . $PROFILE
    Write-Host 'Profile reloaded.' -ForegroundColor Green
}

function profile { nvim $PROFILE }
function nvimrc  { nvim "$env:LOCALAPPDATA\nvim\init.lua" }
function tmuxrc  { nvim $HOME\.tmux.conf }

# ===========================================================================
# Functions — Utilities
# ===========================================================================

function mkcd {
    param([string]$Path)
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
    Set-Location $Path
}

function fcd {
    $dir = fd --type d --hidden --follow --exclude .git |
           fzf --preview 'dir {}'
    if ($dir) { Set-Location $dir }
}

function grep {
    param(
        [string]$Pattern,
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Paths
    )
    if ($Paths) { rg $Pattern @Paths }
    else        { $input | rg $Pattern }
}
