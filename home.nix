{ lib, pkgs, ... }:
{
    # Allow unfree packages
    nixpkgs.config = {
        allowUnfree = true;
    };

    home = {
        # User info
        username = "careb0t";
        homeDirectory = "/home/careb0t";

        # NixOS version
        stateVersion = "24.05";

        # Installed packages
        packages = with pkgs; [
            vivaldi
            vivaldi-ffmpeg-codecs
            firefox
            wezterm
            zsh
            starship
            fzf
            bat
            thefuck
            tldr
            duf
            ripgrep
            xclip
            clipcat
            zoxide
            eza
            yazi
            btop
            fastfetch
            p7zip
            dunst
            ksuperkey
            xorg.xsetroot
            polkit
            rofi
            zellij
            flameshot
            xfce.thunar
            themechanger
            kate
            neovim
            vscode
            xwallpaper
            stremio
            steam
            lutris
            qbittorrent
            discord
            spotify
            nerdfonts
        ];
    };

    # Qtile configuration
    xdg.configFile."qtile/config.py".source = /home/careb0t/dotfiles/qtile/config.py;
}
