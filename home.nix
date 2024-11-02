{ lib, pkgs, inputs, ... }:
{
    # Import inputs from flake
    imports = [
        inputs.nix-colors.homeManagerModules.default
    ];

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
            pulsemixer
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
            zafiro-icons
        ];
    };

    # Qtile configuration file
    xdg.configFile."qtile/config.py".source = ./qtile/config.py;

    # wezterm configuration file
    xdg.configFile."wezterm/wezterm.lua".source = ./wezterm/wezterm.lua;

    # Starship configuration file
    xdg.configFile."starship.toml".source = ./wezterm/starship.toml;

    # Zsh configuration
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        shellAliases = {
            ls = "eza -a";
            ll = "eza -l";
            nix-update = "sudo nixos-rebuild switch";
        };
        history.size = 10000;
        history.ignoreAllDups = true;
        history.path = "$HOME/.zsh_history";
        history.ignorePatterns = ["rm *" "pkill *" "cp *"];
    };

    # Zsh integration
    programs.wezterm.enableZshIntegration = true;
    programs.zoxide.enableZshIntegration = true;
    programs.thefuck.enableZshIntegration = true;
    programs.starship.enableZshIntegration = true;



    # Nix-colors colorscheme
    colorScheme = inputs.nix-colors.colorSchemes.black-metal;

    # GUI theme configuration
    gtk.iconTheme = {
        package = pkgs.zafiro-icons;
        name = "zafiro-icons";
    };
}
