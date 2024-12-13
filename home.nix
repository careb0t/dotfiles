{
  lib,
  pkgs,
  inputs,
  ...
}:

{
  # Import inputs from flake
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    inputs.nixcord.homeManagerModules.nixcord
    inputs.nixvim.homeManagerModules.nixvim
  ];

  home = {
    # User info
    username = "careb0t";
    homeDirectory = "/home/careb0t";

    # NixOS initial version DO NOT CHANGE THIS
    stateVersion = "24.05";

    # Environment variables
    sessionVariables = {

    };

    # Installed packages
    packages =
      let
        ad-strawberry-numix-icons = pkgs.callPackage ./icons.nix { };
      in
      [
        ad-strawberry-numix-icons # derivation for red icon pack
        pkgs.picom
        pkgs.ffmpeg
        pkgs.vivaldi
        pkgs.vivaldi-ffmpeg-codecs
        pkgs.firefox
        # pkgs.wezterm # installed with flake input
        pkgs.zsh
        pkgs.starship
        pkgs.fzf
        pkgs.bat
        pkgs.thefuck
        pkgs.tldr
        pkgs.duf
        pkgs.ripgrep
        pkgs.xclip
        pkgs.copyq
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
        pkgs.kdePackages.polkit-kde-agent-1
        pkgs.rofi
        pkgs.pulsemixer
        pkgs.zellij
        pkgs.flameshot
        pkgs.xfce.thunar
        pkgs.kate
        pkgs.vscode
        pkgs.xwallpaper
        pkgs.stremio
        # pkgs.steam # Steam must me installed at system level and enabled
        pkgs.lutris
        pkgs.deluge
        pkgs.nerd-fonts.iosevka-term
        pkgs.nerd-fonts.terminess-ttf
        pkgs.gimp
        pkgs.networkmanager
        pkgs.numix-cursor-theme
        pkgs.dconf
        pkgs.lxappearance
        pkgs.libsForQt5.qt5ct
        pkgs.libsForQt5.qtstyleplugin-kvantum
        pkgs.gparted
        pkgs.catnip
        # pkgs.deno # Use dev flake for deno and other runtimes
        pkgs.xorg.xkill
        pkgs.wine
        pkgs.unar
        pkgs.path-of-building
        pkgs.xdg-desktop-portal
        pkgs.lazygit
        pkgs.xivlauncher
        pkgs.exiftool
      ];
  };

  # Font configuration
  fonts.fontconfig = {
    enable = true;
  };

  # Flake templates
  nix.registry.devflakes.to = {
    type = "path";
    path = "${./devflakes}";
  };

  # Qtile configuration
  xdg.configFile."qtile".source = ./qtile;

  # wezterm configuration
  xdg.configFile."wezterm/wezterm.lua".source = ./wezterm/wezterm.lua;
  programs.wezterm.enable = true;

  # Starship configuration
  xdg.configFile."starship.toml".source = ./wezterm/starship.toml;

  # Yazi configuration
  xdg.configFile."yazi".source = ./yazi;

  # Zellij configuration
  # xdg.configFile."zellij".source = ./zellij;

  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    completionInit = "zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ls = "eza -a --icons";
      ll = "eza -l --icons";
      nix-rebuild = "sudo nixos-rebuild switch";
      hm-rebuild = "cd /home/careb0t/dotfiles && make";
      hm-update = "cd /home/careb0t/dotfiles && nix flake update && make";
      hm-clean = "cd /home/careb0t/dotfiles && make clean";
    };
    initExtra = ''
                                    pushdots() {
                                        cd /home/careb0t/dotfiles
                                        git add -A
                                        if [ "$1" != "" ]
                                        then
                                            git commit -m "$*"
                                        else
                                            git commit -m update
                                        fi
                                        git push
                                    }

                              			nix-dev() {
                                      nix flake init -t devflakes#$1
                              				if [ $? -ne 0 ]; then
            														echo The following templates are available: 
                  											for dir in /home/careb0t/dotfiles/devflakes/*/; do
                          								echo $(basename $dir)
                      									done
      																else
      																	direnv allow
                                			fi
                              			}

                                    eval "$(direnv hook zsh)"
    '';
    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";
    history.ignorePatterns = [
      "rm *"
      "pkill *"
      "cp *"
    ];
  };

  # Zsh tools
  programs.starship.enable = true;
  programs.zoxide.enable = true;

  # Zsh integration
  programs.wezterm.enableZshIntegration = true;
  programs.zoxide.enableZshIntegration = true;
  programs.thefuck.enableZshIntegration = true;
  programs.starship.enableZshIntegration = true;

  # Direnv configuration
  programs.direnv = {
    enable = true;
    silent = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # GUI theme configuration
  home.pointerCursor = {
    package = pkgs.numix-cursor-theme;
    name = "Numix-Cursor";
    gtk.enable = true;
  };
  gtk = {
    enable = true;
    theme = {
      name = "Graphite-pink-Dark";
      package = pkgs.graphite-gtk-theme.override {
        tweaks = [ "darker" ];
        themeVariants = [ "pink" ];
        colorVariants = [ "dark" ];
      };
    };
    iconTheme = {
      name = "AD-Strawberry-Numix";
      package = pkgs.callPackage ./icons.nix { };
    };
    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };
  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=GraphiteDark
    '';
    "Kvantum/Graphite".source = "${pkgs.graphite-kde-theme}/share/Kvantum/Graphite";
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
  xdg.configFile."Vencord/themes".source = ./Vencord/themes;
  programs.nixcord = {
    enable = true;
    discord.vencord.package = pkgs.vencord;
    config = {
      transparent = true;
      themeLinks = [ ];
      frameless = true;
      plugins = {
        alwaysTrust = {
          enable = true;
          domain = true;
          file = true;
        };
        biggerStreamPreview.enable = true;
        clearURLs.enable = true;
        fakeNitro.enable = true;
        favoriteEmojiFirst.enable = true;
        favoriteGifSearch.enable = true;
        fixCodeblockGap.enable = true;
        fixImagesQuality.enable = true;
        fixSpotifyEmbeds.enable = true;
        fixYoutubeEmbeds.enable = true;
        gameActivityToggle.enable = true;
        keepCurrentChannel.enable = true;
        messageClickActions.enable = true;
        messageLinkEmbeds.enable = true;
        noF1.enable = true;
        noTypingAnimation.enable = true;
        noUnblockToJump.enable = true;
        nsfwGateBypass.enable = true;
        onePingPerDM.enable = true;
        reverseImageSearch.enable = true;
        shikiCodeblocks.enable = true;
        showAllMessageButtons.enable = true;
        spotifyCrack.enable = true;
        unlockedAvatarZoom.enable = true;
        viewIcons.enable = true;
        youtubeAdblock.enable = true;
      };
    };
  };

  # Flameshot configuration
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        uiColor = "#DD9998";
        contrastUiColor = "#A06666";
        savePath = "/home/careb0t/Pictures/Screenshots";
        filenamePattern = "%B%e %Y at %I:%M";
      };
    };
  };

  # Nixvim configuration
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
    clipboard = {
      register = "unnamedplus";
      providers = {
        xclip.enable = true;
      };
    };
    colorschemes.base16 = {
      enable = true;
      colorscheme = "black-metal";
      settings = {
        telescope = true;
        telescope_borders = true;
      };
    };
    highlightOverride = {
      NeoTreeGitConflict = {
        fg = "#DD9998";
        bg = null;
        bold = true;
        italic = true;
      };
      NeoTreeGitUntracked = {
        fg = "#9F6666";
        bg = null;
        bold = false;
        italic = true;
      };
    };
    opts = {
      number = true;
      relativenumber = true;
      undodir = "./undo";
      undofile = true;
      fillchars = {
        eob = " ";
      };
      tabstop = 2;
      shiftwidth = 2;
      expandtab = false;
      wrap = false;
      laststatus = 3;
    };
    globals = {
      mapleader = " ";
      maplocalleader = "\\";
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>ft";
        action = ":Neotree filesystem reveal toggle<CR>";
        options = {
          silent = true;
          desc = "toggle neotree";
        };
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>gf";
        action = {
          __raw = ''
            function()
                require('conform').format({
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 500,
                })
            end
          '';
        };
        options = {
          silent = false;
          desc = "format file or range";
        };
      }
      {
        mode = [ "n" ];
        key = "<leader>gl";
        action = {
          __raw = ''
            function()
                require('lint').try_lint()
            end
          '';
        };
        options = {
          silent = false;
          desc = "lint current file";
        };
      }
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "s";
        action = {
          __raw = ''
            function()
                require('flash').jump()
            end
          '';
        };
        options = {
          silent = true;
          desc = "flash";
        };
      }
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "S";
        action = {
          __raw = ''
            function()
                require('flash').treesitter()
            end
          '';
        };
        options = {
          silent = true;
          desc = "flash - treesitter";
        };
      }
      {
        mode = [ "o" ];
        key = "r";
        action = {
          __raw = ''
            function()
                require('flash').remote()
            end
          '';
        };
        options = {
          silent = true;
          desc = "flash - remote";
        };
      }
      {
        mode = [
          "x"
          "o"
        ];
        key = "R";
        action = {
          __raw = ''
            function()
                require('flash').treesitter_search()
            end
          '';
        };
        options = {
          silent = true;
          desc = "flash - treesitter search";
        };
      }
      {
        mode = [ "n" ];
        key = "<c-s>";
        action = {
          __raw = ''
            function()
                require('flash').toggle()
            end
          '';
        };
        options = {
          silent = true;
          desc = "flash - toggle";
        };
      }
      {
        mode = [ "n" ];
        key = "K";
        action = {
          __raw = ''
            vim.lsp.buf.hover
          '';
        };
        options = {
          silent = false;
          desc = "lsp - hover";
        };
      }
      {
        mode = [ "n" ];
        key = "<leader>gd";
        action = {
          __raw = ''
            vim.lsp.buf.definition
          '';
        };
        options = {
          silent = false;
          desc = "lsp - definition";
        };
      }
      {
        mode = [ "n" ];
        key = "<leader>gr";
        action = {
          __raw = ''
            vim.lsp.buf.references
          '';
        };
        options = {
          silent = false;
          desc = "lsp - references";
        };
      }
      {
        mode = [ "n" ];
        key = "<leader>ca";
        action = {
          __raw = ''
            vim.lsp.buf.code_action
          '';
        };
        options = {
          silent = false;
          desc = "lsp - code action";
        };
      }
      {
        mode = [ "n" ];
        key = "<leader>ff";
        action = {
          __raw = ''
            require("telescope.builtin").find_files
          '';
        };
        options = {
          silent = false;
          desc = "telescope - find files";
        };
      }
      {
        mode = [ "n" ];
        key = "<leader>fg";
        action = {
          __raw = ''
            require("telescope.builtin").live_grep
          '';
        };
        options = {
          silent = false;
          desc = "telescope - live grep";
        };
      }
      {
        mode = [ "n" ];
        key = "<leader>fb";
        action = {
          __raw = ''
            require("telescope.builtin").buffers
          '';
        };
        options = {
          silent = false;
          desc = "telescope - find buffers";
        };
      }
      {
        mode = [ "n" ];
        key = "<leader>fh";
        action = {
          __raw = ''
            require("telescope.builtin").help_tags
          '';
        };
        options = {
          silent = false;
          desc = "telescope - help tags";
        };
      }
      {
        mode = [ "n" ];
        key = "<leader>u";
        action = "<cmd>Telescope undo<cr>";
        options = {
          silent = false;
          desc = "telescope - undo history";
        };
      }
    ];
    plugins = {
      dashboard = {
        enable = true;
        settings = {
          packages.enable = false;
          change_to_vcs_root = true;
          config = {
            footer = [
              "Работа – не волк, в лес не убежит"
            ];
            header = [
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣤⣤⣤⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣾⣿⣿⠿⠿⠿⠿⢿⣿⣿⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣶⣾⣿⣿⠀⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⠀⣿⣿⣷⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣾⣿⡿⠟⠛⠉⠉⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⠉⠉⠛⠻⢿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⡿⠋⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⠀⠀⠀⠀⠀⠙⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠃⠀⠀⣠⣶⣾⣿⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⣿⣷⣦⣄⠀⠀⠸⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⢀⣾⣿⡿⠛⠉⠀⣿⣿⡇⠀⠀⣀⣀⠀⠀⠀⠀⠀⣀⣀⠀⠀⢸⣿⣿⠀⠉⠛⢿⣿⣷⡀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣆⢸⣿⣿⠀⠀⠀⠀⣿⣿⡇⠀⢾⣿⣿⡇⠀⠀⠀⢾⣿⣿⡇⠀⢸⣿⣿⠀⠀⠀⠈⣿⣿⡇⣼⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣄⠀⠀⠀⣿⣿⡇⠀⠈⠙⠋⠀⠀⠀⠀⠈⠙⠋⠀⠀⢸⣿⣿⠀⠀⠀⣰⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣷⣶⣶⣿⣿⣿⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣿⣿⣿⣶⣶⣿⣿⣿⣿⡿⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠛⠛⠛⠛⠛⠛⠛⢻⣿⣿⠛⣿⣿⣿⢻⣿⣿⠛⠛⠛⠛⠛⠛⠛⠛⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⠀⢸⣿⣿⠀⣿⣿⣿⢸⣿⣿⠀⠀⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣈⣉⣉⣉⣉⡉⢹⣿⣿⠀⢸⣿⣿⠀⣿⣿⣿⢸⣿⣿⠀⠀⣿⣿⡏⢉⣉⣉⣉⣉⣁⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿⠀⢸⣿⣿⠀⣿⣿⣿⢸⣿⣿⠀⠀⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⢸⣿⣿⠀⢸⣿⣿⠀⣿⣿⣿⢸⣿⣿⠀⠀⣿⣿⡇⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⢸⣿⣿⠀⢸⣿⣿⠀⣿⣿⣿⢸⣿⣿⠀⠀⣿⣿⡇⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⢸⣿⣿⣄⣼⣿⣿⠀⣿⣿⣿⠸⣿⣿⣆⣠⣿⣿⡇⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣄⠻⢿⣿⣿⠿⢋⣴⣿⣿⣿⣦⡙⠿⣿⣿⡿⠛⣠⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣷⣶⣤⣴⣶⣿⣿⠿⠙⢿⣿⣿⣶⣦⣴⣶⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠻⠿⠿⠛⠋⠁⠀⠀⠀⠈⠙⠛⠿⠿⠛⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            ];
            mru = {
              limit = 10;
            };
            project = {
              enable = true;
            };
            shortcut = [
              {
                action = {
                  __raw = "function(path) vim.cmd('Telescope find_files') end";
                };
                desc = "Files";
                group = "Label";
                icon = " ";
                icon_hl = "@variable";
                key = "f";
              }
              {
                action = "Telescope app";
                desc = " Apps";
                group = "DiagnosticHint";
                key = "a";
              }
              {
                action = "Telescope dotfiles";
                desc = " dotfiles";
                group = "Number";
                key = "d";
              }
            ];
          };
          theme = "hyper";
        };
      };
      transparent = {
        enable = true;
        settings.extra_groups = [
          "StatusLine"
          "StatusLineNC"
          "NormalFloat"
          "NeoTreeCursorLine"
          "NeoTreeDimText"
          "NeoTreeDirectoryIcon"
          "NeoTreeDirectoryName"
          "NeoTreeDotfile"
          "NeoTreeFileIcon"
          "NeoTreeFileName"
          "NeoTreeFileNameOpene"
          "NeoTreeFilterTerm"
          "NeoTreeTitleBar"
          "NeoTreeGitAdded"
          "NeoTreeGitConflict"
          "NeoTreeGitDeleted"
          "NeoTreeGitIgnored"
          "NeoTreeGitModified"
          "NeoTreeGitUnstaged"
          "NeoTreeGitUntracked"
          "NeoTreeGitStaged"
          "NeoTreeHiddenByName"
          "NeoTreeIndentMarker"
          "NeoTreeExpander"
          "NeoTreeNormal"
          "NeoTreeNormalNC"
          "NeoTreeSignColumn"
          "NeoTreeStatusLine"
          "NeoTreeStatusLineNC"
          "NeoTreeVertSplit"
          "NeoTreeWinSeparator"
          "NeoTreeEndOfBuffer"
          "NeoTreeRootName"
          "NeoTreeSymbolicLinkTarget"
          "NeoTreeTitleBar"
          "NeoTreeWindowsHidden"
          "NeotreeCursorLine"
          "BufferLineTabClose"
          "BufferLineBufferSelected"
          "BufferLineFill"
          "BufferLineBackground"
          "BufferLineSeparator"
          "BufferLineIndicatorSelected"
          "TelescopeNormal"
          "TelescopePreviewNormal"
          "TelescopePromptNormal"
          "TelescopeResultsNormal"
        ];
        luaConfig.pre = ''
          require('transparent').clear_prefix('lualine')
        '';
      };
      nvim-autopairs = {
        enable = true;
      };
      neoscroll = {
        enable = true;
      };
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
          { name = "luasnip"; }
        ];
        settings = {
          mapping = {
            __raw = ''
              cmp.mapping.preset.insert({
                  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                  ['<C-f>'] = cmp.mapping.scroll_docs(4),
                  ['<C-Space>'] = cmp.mapping.complete(),
                  ['<C-e>'] = cmp.mapping.abort(),
                  ['<CR>'] = cmp.mapping.confirm({ select = true }),
                  ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'}),
                  ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'}),
              })
            '';
          };
          snippet = {
            expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          };
          window = {
            #                         __raw = ''
            #                             completion = cmp.config.window.bordered(),
            #                             documentation = cmp.config.window.bordered(),
            #                         '';
          };
        };
      };
      cmp_luasnip = {
        enable = true;
      };
      lspkind = {
        enable = true;
        cmp = {
          enable = true;
          maxWidth = 50;
          ellipsisChar = "...";
        };
        symbolMap = {
          #Copilot = " ";
        };
        extraOptions = {
          maxWidth = 50;
          ellipsisChar = "...";
        };
      };
      conform-nvim = {
        enable = true;
        luaConfig.pre = ''
          local slow_format_filetypes = {}
        '';
        settings = {
          formatters_by_ft = {
            bash = [
              "shellcheck"
              "shellharden"
              "shfmt"
            ];
            cpp = [ "clang_format" ];
            javascript = {
              __unkeyed-1 = "prettierd";
              timeout_ms = 2000;
              stop_after_first = true;
            };
            css = [
              "prettierd"
            ];
            html = [
              "prettierd"
            ];
            python = [
              "ruff"
            ];
            "_" = [
              "squeeze_blanks"
              "trim_whitespace"
              "trim_newlines"
            ];
          };
          format_on_save = # Lua
            ''
              function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                  return
              end

              if slow_format_filetypes[vim.bo[bufnr].filetype] then
                  return
              end

              local function on_format(err)
                  if err and err:match("timeout$") then
                  slow_format_filetypes[vim.bo[bufnr].filetype] = true
                  end
              end

              return { timeout_ms = 200, lsp_fallback = true }, on_format
              end
            '';
          format_after_save = # Lua
            ''
              function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                  return
              end

              if not slow_format_filetypes[vim.bo[bufnr].filetype] then
                  return
              end

              return { lsp_fallback = true }
              end
            '';
          log_level = "warn";
          notify_on_error = false;
          notify_no_formatters = false;
          formatters = {
            shellcheck = {
              command = lib.getExe pkgs.shellcheck;
            };
            shfmt = {
              command = lib.getExe pkgs.shfmt;
            };
            shellharden = {
              command = lib.getExe pkgs.shellharden;
            };
            squeeze_blanks = {
              command = lib.getExe' pkgs.coreutils "cat";
            };
          };
        };

      };
      floaterm = {
        enable = true;
        shell = "zsh";
        keymaps = {
          toggle = "<C-`>";
        };
      };
      lint = {
        enable = true;
        lintersByFt = {
          javascript = [ "eslint_d" ];
          typescript = [ "eslint_d" ];
          javascriptreact = [ "eslint_d" ];
          typescriptreact = [ "eslint_d" ];
          svelte = [ "eslint_d" ];
          python = [ "ruff" ];
          go = [ "golint" ];
        };
        autoCmd = {
          callback = {
            __raw = ''
              function()
                  require('lint').try_lint()
              end
            '';
          };
          event = [
            "BufWritePost"
            "InsertLeave"
            "BufEnter"
          ];
        };
        linters = {
          eslint_d = {
            args = [
              "--no-warn-ignored"
              "--format json"
            ];
          };
        };
      };
      flash = {
        enable = true;
        settings = {
          jump.nohlsearch = true;
          modes = {
            search.enabled = true;
          };
        };
      };
      image = {
        enable = true;
      };
      lsp = {
        enable = true;
        servers = {
          ts_ls.enable = true;
          vuels = {
            enable = true;
            package = pkgs.vue-language-server;
          };
          yamlls.enable = true;
          bashls.enable = true;
          jsonls.enable = true;
          sqls.enable = true;
          pyright.enable = true;
          ruff.enable = true;
          svelte.enable = true;
          eslint.enable = true;
          cssls.enable = true;
          nixd.enable = true;
          nil_ls.enable = true;
        };
      };
      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "base16";
            icons_enabled = true;
            always_divide_middle = true;
            disabled_filetypes = {
              statusline = [
                "neo-tree"
                "neotree"
                "Neotree"
                "Neo-tree"
                "alpha"
                "toggleterm"
                "Telescope"
              ];
              tabline = [ ];
              winbar = [ ];
            };
            ignore_focus = [
              "neo-tree"
              "neotree"
              "Neotree"
              "Neo-tree"
              "toggleterm"
            ];
            globalstatus = false;
            refresh = {
              statusline = 100;
              tabline = 100;
              winbar = 100;
            };
          };
          sections = {
            lualine_a = [
              "mode"
            ];
            lualine_b = [
              "branch"
              "diff"
              "diagnostics"
            ];
            lualine_c = [
              "filename"
            ];
            lualine_x = [
              "encoding"
              "fileformat"
              "filetype"
            ];
            lualine_y = [
              "progress"
            ];
            lualine_z = [
              "location"
            ];
          };
          tabline = { };
          winbar = { };
        };
      };
      neo-tree = {
        enable = true;
        closeIfLastWindow = true;
        popupBorderStyle = "single";
        window.position = "float";
        window.popup.position = "50%";
        filesystem = {
          filteredItems = {
            hideGitignored = true;
            hideDotfiles = false;
            hideByName = [
              ".github"
              ".gitignore"
              "package-lock.json"
            ];
            neverShow = [
              ".git"
            ];
          };
        };
        eventHandlers = {
          file_opened = ''
              				function(file_path)
                				--auto close
                				require("neo-tree").close_all()
              				end
            					'';
        };
      };
      nvim-surround = {
        enable = true;
      };
      telescope = {
        enable = true;
        extensions = {
          ui-select.enable = true;
          undo = {
            enable = true;
          };
        };
      };
      treesitter = {
        enable = true;
        settings = {
          auto_install = true;
          sync_install = false;
          highlight.enable = true;
          indent.enable = true;
        };
      };
      web-devicons.enable = true;
      which-key = {
        enable = true;
      };

      #nvim-ts-autotag
    };
    extraPackages = with pkgs; [
      # linters
      eslint_d
      golint
      ruff
      # formatters
      prettierd
      stylua
      gosimports
      gofumpt
      nixfmt-rfc-style
      shellcheck
      shellharden
      shfmt
    ];
  };
}
