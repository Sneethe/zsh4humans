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
zstyle ':z4h:' start-tmux command tmux -f "$Z4H"/zsh4humans/tmux/tmux.conf -u new -A -D -t z4h

# Whether to move prompt to the bottom when zsh starts and on Ctrl+L.
zstyle ':z4h:' prompt-at-bottom 'yes'

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'yes'
zstyle ':z4h:fzf-complete' fzf-bindings tab:repeat
zstyle ':z4h:*' fzf-bindings tab:repeat ctrl-k:up

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv'         enable 'no'
# Show "loading" and "unloading" notifications from direnv.
zstyle ':z4h:direnv:success' notify 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'

# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'

# Clone additional Git repositories from GitHub.
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`.
z4h install sneethe/tldr && ln -s "$Z4H"/sneethe/tldr/tldr $Z4H/bin 2>/dev/null
z4h install AndydeCleyre/zpy
z4h install softmoth/zsh-vim-mode
z4h install zsh-vi-more/vi-increment
# TODO trial replacment of zsh-syntax-highlighting with fast-syntax-highlighting

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

ZSH_AUTOSUGGEST_STRATEGY="match_prev_cmd completion"

# Extend PATH.
path=($Z4H/bin $path)

# Export environment variables.
export GPG_TTY=$TTY

# Source additional local files if they exist.
z4h source ~/.env.zsh

# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It does nothing useful.
# z4h source ohmyzsh/ohmyzsh/lib/diagnostics.zsh  # source an individual file
z4h load AndydeCleyre/zpy

# Enable <Esc>-prefixed bindings that should rarely conflict with NORMAL mode
VIM_MODE_ESC_PREFIXED_WANTED='^?^Hbdfhul.g'  # Default is '^?^Hbdf.g'
MODE_CURSOR_VIINS="#EBDBB2 blinking bar"
MODE_CURSOR_REPLACE="$MODE_CURSOR_VIINS #ff0000"
MODE_CURSOR_VICMD="#EBDBB2 block"
MODE_CURSOR_SEARCH="#ff00ff steady underline"
MODE_CURSOR_VISUAL="$MODE_CURSOR_VICMD steady bar"
MODE_CURSOR_VLINE="$MODE_CURSOR_VISUAL #00ffff"
z4h load softmoth/zsh-vim-mode
z4h load zsh-vi-more/vi-increment

# Define key bindings.
for keymap in viins vicmd; do
bindkey -M $keymap '^l'      z4h-clear-screen-soft-bottom   # ctrl+l
bindkey -M $keymap '^[^l'    z4h-clear-screen-hard-bottom   # ctrl+alt+l

bindkey -M $keymap '^[o' z4h-cd-back    # cd into the previous directory
bindkey -M $keymap '^[i' z4h-cd-forward # cd into the next directory
bindkey -M $keymap '^[h' z4h-cd-up      # Alt+h    cd into the parent directory
bindkey -M $keymap '^[l' z4h-cd-down    # Alt+l    cd into a child directory

bindkey -M $keymap '^[[A'    z4h-up-substring-local    # up        Move cursor one line up or fetch the previous command from LOCAL history.
bindkey -M $keymap '^[[B'    z4h-down-substring-local  # down      Move cursor one line down or fetch the next command from LOCAL history.
bindkey -M $keymap '^[[1;5A' z4h-up-prefix-global      # Ctrl+up   Move cursor one line up or fetch the previous command from GLOBAL history.
bindkey -M $keymap '^[[1;5B' z4h-down-prefix-global    # Ctrl+down Move cursor one line down or fetch the next command from GLOBAL history.
bindkey -M $keymap '^[^H'    run-help                  # Ctrl+Alt+H
done && unset keymap

# bindkey -M viins '^z' undo
# bindkey -M viins '^y' redo
z4h bindkey undo Ctrl+/ Shift+Tab  # undo the last command line change
z4h bindkey redo Alt+/             # redo the last undone command line change
z4h bindkey z4h-autosuggest-accept Alt+M # Accept autosuggestion, and preserve cursor position

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

# Define aliases.
alias tree='tree -a -I .git'

# Add flags to existing aliases.
alias ls="${aliases[ls]:-ls} -A"

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu
