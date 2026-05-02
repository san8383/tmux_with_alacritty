#!/bin/sh

set -eu

### ===== DETECT ROOT =====
if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
else
    SUDO="sudo"
fi

### ===== CONFIG =====
LOG_FILE="${HOME}/setup.log"
DRY_RUN=0
INSTALL_ALACRITTY=1
INSTALL_TMUX=1

### ===== COLORS =====
if [ -t 1 ]; then
    RED=$(printf '\033[31m')
    GREEN=$(printf '\033[32m')
    YELLOW=$(printf '\033[33m')
    BLUE=$(printf '\033[34m')
    RESET=$(printf '\033[0m')
else
    RED="" GREEN="" YELLOW="" BLUE="" RESET=""
fi

### ===== LOGGING =====
log() { printf "%s\n" "$1" | tee -a "$LOG_FILE"; }
info() { log "${BLUE}[*]${RESET} $1"; }
warn() { log "${YELLOW}[!]${RESET} $1"; }
error() { log "${RED}[x]${RESET} $1"; }
success() { log "${GREEN}[✓]${RESET} $1"; }

### ===== RUN WRAPPER =====
run() {
    if [ "$DRY_RUN" -eq 1 ]; then
        log "[dry-run] $*"
    else
        sh -c "$*"
    fi
}

### ===== ARG PARSING =====
for arg in "$@"; do
    case "$arg" in
        --no-alacritty)
            INSTALL_ALACRITTY=0
            ;;
        --dry-run)
            DRY_RUN=1
            ;;
        *)
            warn "Unknown option: $arg"
            ;;
    esac
done

### ===== PACKAGE MANAGER =====
detect_pm() {
    if command -v apt >/dev/null 2>&1; then echo "apt"
    elif command -v dnf >/dev/null 2>&1; then echo "dnf"
    elif command -v pacman >/dev/null 2>&1; then echo "pacman"
    elif command -v zypper >/dev/null 2>&1; then echo "zypper"
    elif command -v brew >/dev/null 2>&1; then echo "brew"
    else echo "unknown"
    fi
}

PM=$(detect_pm)

install_packages() {
    info "Using package manager: $PM"

    case "$PM" in
        apt)
            run "$SUDO apt update"
            [ "$INSTALL_TMUX" -eq 1 ] && run "$SUDO apt install -y tmux"
            [ "$INSTALL_ALACRITTY" -eq 1 ] && run "$SUDO apt install -y alacritty"
            run "$SUDO apt install -y git zsh zsh-autosuggestions zsh-syntax-highlighting"
            ;;
        dnf)
            [ "$INSTALL_TMUX" -eq 1 ] && run "$SUDO dnf install -y tmux"
            [ "$INSTALL_ALACRITTY" -eq 1 ] && run "$SUDO dnf install -y alacritty"
            run "$SUDO dnf install -y git zsh zsh-autosuggestions zsh-syntax-highlighting"
            ;;
        pacman)
            run "$SUDO pacman -Sy --noconfirm git zsh tmux zsh-autosuggestions zsh-syntax-highlighting"
            [ "$INSTALL_ALACRITTY" -eq 1 ] && run "$SUDO pacman -Sy --noconfirm alacritty"
            ;;
        zypper)
            run "$SUDO zypper install -y git zsh zsh-autosuggestions zsh-syntax-highlighting"
            [ "$INSTALL_TMUX" -eq 1 ] && run "$SUDO zypper install -y tmux"
            [ "$INSTALL_ALACRITTY" -eq 1 ] && run "$SUDO zypper install -y alacritty"
            ;;
        brew)
            run "brew install git zsh tmux zsh-autosuggestions zsh-syntax-highlighting"
            [ "$INSTALL_ALACRITTY" -eq 1 ] && run "brew install alacritty"
            ;;
        *)
            error "Unsupported package manager"
            exit 1
            ;;
    esac
}

### ===== BACKUP =====
backup_file() {
    FILE="$1"

    if [ -f "$FILE" ]; then
        TS=$(date +%Y%m%d_%H%M%S)
        BACKUP="${FILE}.bak.${TS}"

        warn "Backing up $FILE -> $BACKUP"
        run "mv \"$FILE\" \"$BACKUP\""
    fi
}

### ===== MAIN =====
info "Starting setup..."
info "Log: $LOG_FILE"

install_packages

info "Creating directories..."
run "mkdir -p \"$HOME/.config/alacritty\""
run "mkdir -p \"$HOME/.local/bin\""
run "mkdir -p \"$HOME/.tmux/plugins\""

info "Installing TPM..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    run "git clone https://github.com/tmux-plugins/tpm \"$HOME/.tmux/plugins/tpm\""
else
    warn "TPM already installed"
fi

info "Backing up configs..."
backup_file "$HOME/.zshrc"
backup_file "$HOME/.tmux.conf"

info "Copying configs..."
[ -f zshrc ] && run "cp zshrc \"$HOME/.zshrc\""
[ -f tmux.conf ] && run "cp tmux.conf \"$HOME/.tmux.conf\""

if [ "$INSTALL_ALACRITTY" -eq 1 ]; then
    [ -f alacritty.toml ] && run "cp alacritty.toml \"$HOME/.config/alacritty/alacritty.toml\""
fi

info "Installing helper script..."
if [ -f alacritty-with-tmux.sh ]; then
    run "cp alacritty-with-tmux.sh \"$HOME/.local/bin/alacritty-with-tmux\""
    run "chmod +x \"$HOME/.local/bin/alacritty-with-tmux\""
fi

info "Setting zsh as default shell..."

ZSH_PATH=$(command -v zsh || true)

if [ -n "$ZSH_PATH" ]; then
    if ! grep -q "$ZSH_PATH" /etc/shells 2>/dev/null; then
        run "echo \"$ZSH_PATH\" | $SUDO tee -a /etc/shells >/dev/null"
    fi

    CURRENT_SHELL=$(grep "^$USER:" /etc/passwd 2>/dev/null | cut -d: -f7 || echo "")

    if [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
        warn "Changing default shell to zsh (relogin required)"
        run "chsh -s \"$ZSH_PATH\""
    else
        warn "zsh already default shell"
    fi
else
    error "zsh not found"
fi

success "Setup completed!"
