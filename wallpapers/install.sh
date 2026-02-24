#!/usr/bin/env bash

# Master script to copy wallpapers from all sources
# This script allows you to run all wallpaper copy scripts or select specific ones

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to install required wallpaper packages
install_wallpaper_packages() {
    echo "Checking/installing wallpaper packages..."
    local packages=(
        "archlinux-wallpaper"
        "gnome-backgrounds"
        "plasma-workspace-wallpapers"
    )

    if sudo pacman -S --needed "${packages[@]}"; then
        echo "Wallpaper packages installed/verified successfully."
        return 0
    else
        echo "Warning: Failed to install some wallpaper packages." >&2
        echo "You may need to install them manually:" >&2
        echo "  sudo pacman -S archlinux-wallpaper gnome-backgrounds plasma-workspace-wallpapers" >&2
        return 1
    fi
}

# Available scripts with descriptions
declare -A SCRIPTS=(
    ["1"]="all:Run all scripts"
    ["2"]="arch.sh:Arch Linux wallpapers"
    ["3"]="gnome.sh:GNOME wallpapers (requires ImageMagick)"
    ["4"]="kde.sh:KDE Plasma wallpapers by resolution"
    ["5"]="third-party.sh:Third-party wallpapers (download from URLs)"
    ["q"]="quit:Exit"
)

# Function to run a single script
run_script() {
    local script="$1"
    local script_path="$SCRIPT_DIR/$script"

    if [[ ! -f "$script_path" ]]; then
        echo "Error: Script '$script' not found at '$script_path'" >&2
        return 1
    fi

    if [[ ! -x "$script_path" ]]; then
        echo "Error: Script '$script' is not executable" >&2
        return 1
    fi

    echo ""
    echo "========================================"
    echo "Running: $script"
    echo "========================================"
    "$script_path"
    local exit_code=$?
    echo "========================================"
    echo "Completed: $script (exit code: $exit_code)"
    echo "========================================"
    echo ""

    return $exit_code
}

# Function to run all scripts
run_all() {
    echo "Running all wallpaper copy scripts..."
    local failed=0

    run_script "arch.sh" || failed=$((failed + 1))
    run_script "gnome.sh" || failed=$((failed + 1))
    run_script "kde.sh" || failed=$((failed + 1))
    run_script "third-party.sh" || failed=$((failed + 1))

    if [[ $failed -eq 0 ]]; then
        echo "All scripts completed successfully!"
        return 0
    else
        echo "Warning: $failed script(s) failed or were skipped" >&2
        return 1
    fi
}

# Function to show interactive menu
show_menu() {
    echo ""
    echo "Wallpaper Copy Scripts"
    echo "======================"
    echo ""
    echo "Select scripts to run:"
    echo "  1 - Run all scripts (default)"
    echo "  2 - Arch Linux wallpapers"
    echo "  3 - GNOME wallpapers"
    echo "  4 - KDE Plasma wallpapers"
    echo "  5 - Third-party wallpapers (download from URLs)"
    echo "  q - Quit"
    echo ""
}

# Main logic
main() {
    # Install wallpaper packages first
    install_wallpaper_packages

    # If arguments provided, run specified scripts
    if [[ $# -gt 0 ]]; then
        case "$1" in
            1|all|a)
                run_all
                ;;
            2|archlinux|arch)
                run_script "arch.sh"
                ;;
            3|gnome)
                run_script "gnome.sh"
                ;;
            4|kde)
                run_script "kde.sh"
                ;;
            5|third-party|third)
                run_script "third-party.sh"
                ;;
            *)
                echo "Unknown option: $1" >&2
                echo "Usage: $0 [1|2|3|4|5|all|archlinux|gnome|kde|third-party]" >&2
                echo "   Or run without arguments for interactive menu" >&2
                exit 1
                ;;
        esac
        return $?
    fi

    # Interactive mode
    show_menu
    read -rp "Enter selection: " choice
    choice="${choice:-1}"

    case "$choice" in
        1|all|a)
            run_all
            ;;
        2|archlinux|arch)
            run_script "arch.sh"
            ;;
        3|gnome)
            run_script "gnome.sh"
            ;;
        4|kde)
            run_script "kde.sh"
            ;;
        5|third-party|third)
            run_script "third-party.sh"
            ;;
        q|quit|exit)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid selection: '$choice'" >&2
            exit 1
            ;;
    esac
}

main "$@"
