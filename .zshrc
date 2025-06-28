# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'no'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '28'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'pc'

# Start tmux if not already in tmux.
# TODO: update integrated tmux to use a small subset of plugins and allow for popup window. Look at .tmux.conf
zstyle ':z4h:' start-tmux command tmux -f "$Z4H"/zsh4humans/tmux/tmux.conf -u new -A -D -t z4h

# Whether to move prompt to the bottom when zsh starts and on Ctrl+L.
zstyle ':z4h:' prompt-at-bottom 'yes'
# If you are using a two-line prompt with an empty line before it, add this for smoother rendering
# run sleep 1 to see difference, the prompt history doesn't shift up a line upon command completion, instead its upon command execution
POSTEDIT=$'\n\n\e[2A'

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'
zstyle ':z4h:' propagate-cwd yes

zstyle ':z4h:autosuggestions' forward-char partial-accept
zstyle ':z4h:autosuggestions' end-of-line  partial-accept

# TODO: Start switching over romkatv deps (stable) to ours (dev)
zstyle ':z4h:fzf' channel 'dev'

# TODO:teleportation should be configurable to allow for .config/zsh ZDOTDIR installation.
# As well as a non-conflicting method. Where a unique dir is made for the remote Z4H and ~/.zshenv ZDOTDIR is exported upon ssh.

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'
# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'

# fzf-tab
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix https://github.com/Aloxaf/fzf-tab/pull/413
zstyle ':completion:*' menu no
FZF_COLORS=(
  'fg:#d4be98,fg+:#d0d0d0,bg:#1e1e2e,bg+:#201616,'
  'hl:#ffc44e,hl+:#fabd2f,info:#7daea3,marker:#e78a4e,'
  'prompt:#d3869b,spinner:#89b482,pointer:#7daea3,header:#89b482,'
  'gutter:#282828,border:#928374,preview-fg:#d4be98,preview-bg:#1a1a26,'
  'label:#aeaeae,query:#d9d9d9'
)
FZF_BINDS=(
          'ctrl-v:become({_FTB_INIT_}vis "$realpath")' # Only read for fzf-tab
          'alt-j:preview-down'
          'alt-k:preview-up'
          'alt-J:preview-half-page-down'
          'alt-K:preview-half-page-up'
          'alt-u:half-page-up+refresh-preview'
          'alt-d:page-down+refresh-preview'
          'ctrl-p:toggle-preview'
          'ctrl-/:change-preview-window(right,70%|down,40%,border-horizontal|right)'
          'ctrl-s:jump'
          'ctrl-g:top'
          'tab:toggle-in'
          'btab:toggle-out'
          'alt-a:toggle-all'
          'alt-s:toggle-sort'
          'ctrl-v:become(vis {+1})' # everything else will use this
          )
zstyle ':z4h:*'     fzf-bindings ${(@)FZF_BINDS[2,-1]} 'ctrl-k:up' 'tab:repeat' 'ctrl-space:toggle' 'ctrl-a:beginning-of-line'
zstyle ':fzf-tab:*' fzf-bindings ${(@)FZF_BINDS[1,-2]}
zstyle ':fzf-tab:*' fzf-flags --color="${FZF_COLORS}" --highlight-line --preview-window='hidden:right:50%:wrap:cycle'
zstyle ':fzf-tab:*' switch-group 'ctrl-h' 'ctrl-l'
zstyle ':fzf-tab:*' continuous-trigger tab # TODO: fix https://github.com/Aloxaf/fzf-tab/issues/8 Z4H v3 used fzf-tab and it works
zstyle ':fzf-tab:*' print-query ''
zstyle ':fzf-tab:*' popup-smart-tab-bindings 'ctrl-g:top+down'
zstyle ':fzf-tab:*' accept-line enter
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup # TODO:fzf-tab should use Z4H -z4h-restore-screen in case of non-tmux environment
zstyle ':fzf-tab:*' popup-fit-preview yes
zstyle ':fzf-tab:*' popup-min-size 30 10 # w * h
zstyle ':fzf-tab:*' popup-pad 0 0
# z4h-fzf
zstyle ':z4h:fzf-complete' recurse-dirs 'yes'
zstyle ':z4h:*' fzf-flags --color="${FZF_COLORS}" --cycle --highlight-line

# Clone additional Git repositories from GitHub.
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`.
z4h install sneethe/tldr
z4h install sneethe/zpy
z4h install sneethe/zsh-vim-mode
z4h install sneethe/vi-increment
z4h install sneethe/ex-commands
z4h install sneethe/zsh-autopair
z4h install sneethe/zce.zsh
z4h install sneethe/tpm
z4h install sneethe/fzf-tab # TODO: Look at Z4H v3 fzf-tab integration and post-install TODO: post-install for fzf-tab-module
z4h install sneethe/fzf-tab-source
z4h install sneethe/zsh-z
# TODO trial replacment of zsh-syntax-highlighting with fast-syntax-highlighting

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

ZSH_AUTOSUGGEST_STRATEGY="match_prev_cmd completion"

# Extend PATH.
path=($Z4H/{fzf/,}bin $path)

# Source additional local files if they exist.
z4h source ~/.env.zsh

# Use additional Git repositories pulled in with `z4h install`.
z4h load -c sneethe/zpy

# Enable <Esc>-prefixed bindings that should rarely conflict with NORMAL mode
VIM_MODE_ESC_PREFIXED_WANTED='^?^Hbdfhul.g'  # Default is '^?^Hbdf.g'
MODE_CURSOR_VIINS="#EBDBB2 blinking bar"
MODE_CURSOR_REPLACE="$MODE_CURSOR_VIINS #ff0000"
MODE_CURSOR_VICMD="#EBDBB2 block"
MODE_CURSOR_SEARCH="#ff00ff steady underline"
MODE_CURSOR_VISUAL="$MODE_CURSOR_VICMD steady bar"
MODE_CURSOR_VLINE="$MODE_CURSOR_VISUAL #00ffff"
z4h load -c sneethe/zsh-vim-mode
z4h load -c sneethe/vi-increment
z4h load -c sneethe/ex-commands
z4h load -c sneethe/zsh-autopair
z4h load -c sneethe/zce.zsh
z4h load -c sneethe/zsh-z
# fzf-tab is loaded fn/-z4h-init-zle:964
z4h load -c sneethe/fzf-tab-source

# Define key bindings.
() {
  local keymap
for keymap in viins vicmd; do
bindkey -M $keymap '^l'      z4h-clear-screen-soft-bottom   # ctrl+l
bindkey -M $keymap '^[^l'    z4h-clear-screen-hard-bottom   # ctrl+alt+l
bindkey -M $keymap '^[O'     z4h-cd-back    # cd into the previous directory
bindkey -M $keymap '^[I'     z4h-cd-forward # cd into the next directory
bindkey -M $keymap '^[H'     z4h-cd-up      # Alt+h    cd into the parent directory
bindkey -M $keymap '^[L'     z4h-cd-down    # Alt+l    cd into a child directory
bindkey -M $keymap '^[^H'   z4h-fzf-dir-history # fzf fuzzy search $(dirs)
bindkey -M $keymap '^[[A'    z4h-up-substring-local    # up        Move cursor one line up or fetch the previous command from LOCAL history.
bindkey -M $keymap '^[[B'    z4h-down-substring-local  # down      Move cursor one line down or fetch the next command from LOCAL history.
bindkey -M $keymap '^[[1;5A' z4h-up-prefix-global      # Ctrl+up   Move cursor one line up or fetch the previous command from GLOBAL history.
bindkey -M $keymap '^[[1;5B' z4h-down-prefix-global    # Ctrl+down Move cursor one line down or fetch the next command from GLOBAL history.
bindkey -M $keymap '^[^M'    run-help                  # Ctrl+Alt+H
bindkey -M $keymap '^P' zsh_tmux_prompt_jump_prev
bindkey -M $keymap '^N' zsh_tmux_prompt_jump_next
done
}
# If we do https://github.com/Aloxaf/fzf-tab/issues/65#issuecomment-1344970328 and https://github.com/intelfx/dotfiles/blob/master/.zshrc.d/fzf
# Doing nvim <tab><tab>.zshrc will insert our chosen file like: nvim chosen_file .zshrc   while with z4h-fzf-complete we just spam tab until cursor moves to last file arg and then we get completion menu
bindkey -M viins '\t\t'    z4h-fzf-complete # TODO: We should make z4h-fzf-complete, z4h-fzf-dir-history & z4h-cd-down use ftb-tmux-popup when inside tmux.

z4h bindkey undo Ctrl+/ Shift+Tab  # undo the last command line change
z4h bindkey redo Alt+/             # redo the last undone command line change
z4h bindkey z4h-autosuggest-accept Alt+M # Accept autosuggestion, and preserve cursor position
z4h bindkey z4h-accept-line Enter
z4h bindkey z4h-backward-kill-word  Ctrl+Backspace
z4h bindkey z4h-eof Ctrl+D

# Make transient prompt work consistently when closing an SSH connection?
z4h bindkey z4h-eof Ctrl+D
setopt ignore_eof

if [[ -n "$TMUX" ]]; then
  function zsh_tmux_prompt_jump_prev() {
    [[ -z "$NVIM" ]] || return
    tmux copy-mode \; send -X previous-prompt
  }
  function zsh_tmux_prompt_jump_next() {
    [[ -z "$NVIM" ]] || return
    tmux copy-mode \; send -X next-prompt
  }
  zle -N zsh_tmux_prompt_jump_prev
  zle -N zsh_tmux_prompt_jump_next
  bindkey -M vicmd '^P' zsh_tmux_prompt_jump_prev
  bindkey -M vicmd '^N' zsh_tmux_prompt_jump_next
  bindkey -M viins '^P' zsh_tmux_prompt_jump_prev
  bindkey -M viins '^N' zsh_tmux_prompt_jump_next
fi

# https://gist.github.com/CMCDragonkai/6084a504b6a7fee270670fc8f5887eb4
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line -w
  else
    zle self-insert
  fi
}
zle -N fancy-ctrl-z
z4h bindkey fancy-ctrl-z Ctrl+Z

if [[ -n "$TMUX" ]]; then
  function zsh_tmux_prompt_jump_prev() {
    [[ -z "$NVIM" ]] || return
    tmux copy-mode \; send -X previous-prompt
  }
  function zsh_tmux_prompt_jump_next() {
    [[ -z "$NVIM" ]] || return
    tmux copy-mode \; send -X next-prompt
  }
  zle -N zsh_tmux_prompt_jump_prev
  zle -N zsh_tmux_prompt_jump_next
  bindkey -M vicmd '^P' zsh_tmux_prompt_jump_prev
  bindkey -M vicmd '^N' zsh_tmux_prompt_jump_next
  bindkey -M viins '^P' zsh_tmux_prompt_jump_prev
  bindkey -M viins '^N' zsh_tmux_prompt_jump_next
fi
# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Export environment variables.
export GPG_TTY=$TTY
export FZF_DEFAULT_OPTS="--bind='${(j:,:)FZF_BINDS}' \
--preview-window='hidden:right:50%:wrap:cycle' \
--height=100 \
--info='inline' \
--highlight-line \
--cycle \
--multi \
--ansi  \
--color="${(j::)FZF_COLORS}" \
--tmux"

# Define aliases.
alias tree='tree -a -I .git'
alias clear=z4h-clear-screen-soft-bottom

# Add flags to existing aliases.
alias ls="${aliases[ls]:-ls} -A"

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
# setopt no_auto_menu  # require an extra TAB press to open the completion menu
