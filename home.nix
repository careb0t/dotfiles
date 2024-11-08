{ lib, pkgs, pkgs-unstable, inputs, ... }:

{
    # Import inputs from flake
    imports = [
        inputs.nix-colors.homeManagerModules.default
        inputs.spicetify-nix.homeManagerModules.default
        inputs.nixcord.homeManagerModules.nixcord
    ];

    home = {
        # User info
        username = "careb0t";
        homeDirectory = "/home/careb0t";

        # NixOS version
        stateVersion = "24.05";

        # Installed packages
        packages = [
            pkgs.picom-pijulius
            pkgs.vivaldi
            pkgs.vivaldi-ffmpeg-codecs
            pkgs.firefox
            pkgs.wezterm
            pkgs.zsh
            pkgs.starship
            pkgs.fzf
            pkgs.bat
            pkgs.thefuck
            pkgs.tldr
            pkgs.duf
            pkgs.ripgrep
            pkgs.xclip
            pkgs.clipcat
            pkgs.zoxide
            pkgs.eza
            pkgs.yazi
            pkgs.btop
            pkgs.fastfetch
            pkgs.p7zip
            pkgs.xcolor
            pkgs.killall
            pkgs.dunst
            pkgs.ksuperkey
            pkgs.xorg.xsetroot
            pkgs.polkit
            pkgs.rofi
            pkgs.pulsemixer
            pkgs.zellij
            pkgs.flameshot
            pkgs.xfce.thunar
            pkgs.kate
            pkgs.neovim
            pkgs.vscode
            pkgs.xwallpaper
            pkgs.stremio
            pkgs.steam
            pkgs.lutris
            pkgs.deluge
            pkgs.nerdfonts
            pkgs.gimp
            pkgs.zafiro-icons
            pkgs.networkmanager
            pkgs.numix-cursor-theme
            (pkgs-unstable.discord.override {
                withOpenASAR = true;
                withVencord = true;
            })
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
            nix-rebuild = "sudo nixos-rebuild switch";
            hm-rebuild = "cd /home/careb0t/dotfiles && make";
            hm-clean = "cd /home/careb0t/dotfiles && make clean";
        };
        initExtra = ''
            pushdots() {
                git add -A
                if [ "$1" != "" ]
                then
                    git commit -m "$*"
                else
                    git commit -m update
                fi
                git push
            }
        '';
        history.size = 10000;
        history.ignoreAllDups = true;
        history.path = "$HOME/.zsh_history";
        history.ignorePatterns = ["rm *" "pkill *" "cp *"];
    };

    # Zsh tools
    programs.starship.enable = true;
    programs.zoxide.enable = true;

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
    gtk.cursorTheme = {
        package = pkgs.numix-cursor-theme;
        name = "numix-cursor-theme";
    };

    # Spicetify configuration
    programs.spicetify =
        let
            spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
        in
        {
            enable = true;
            enabledExtensions = with spicePkgs.extensions; [
                adblock
                shuffle
                addToQueueTop
                history
                volumePercentage
            ];
            theme = spicePkgs.themes.sleek;
            colorScheme = "coral";
        };

    # Discord + Vencord configuration
#     programs.nixcord = {
#       enable = true;
#       config = {
#         themeLinks = [];
#         frameless = true;
#         plugins = {
#             alwaysTrust = {
#                 enable = true;
#                 domain = true;
#                 file = true;
#             };
#             biggerStreamPreview.enable = true;
#             clearURLs.enable = true;
#             fakeNitro.enable = true;
#             favoriteEmojiFirst.enable = true;
#             favoriteGifSearch.enable = true;
#             fixCodeblockGap.enable = true;
#             fixImagesQuality.enable = true;
#             fixSpotifyEmbeds.enable = true;
#             fixYoutubeEmbeds.enable = true;
#             gameActivityToggle.enable = true;
#             keepCurrentChannel.enable = true;
#             messageClickActions.enable = true;
#             messageLinkEmbeds.enable = true;
#             noF1.enable = true;
#             noTypingAnimation.enable = true;
#             noUnblockToJump.enable = true;
#             nsfwGateBypass.enable = true;
#             onePingPerDM.enable = true;
#             reverseImageSearch.enable = true;
#             shikiCodeblocks.enable = true;
#             showAllMessageButtons.enable = true;
#             spotifyCrack.enable = true;
#             unlockedAvatarZoom.enable = true;
#             viewIcons.enable = true;
#             youtubeAdblock.enable = true;
#         };
#       };
#     };
}
