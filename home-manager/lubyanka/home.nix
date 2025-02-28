# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other home-manager modules here
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    inputs.nixcord.homeManagerModules.nixcord
    inputs.nixvim.homeManagerModules.nixvim
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
      # Enable ROCM support for AMD GPU
      rocmSupport = true;
    };
  };

  home = {
    username = "careb0t";
    homeDirectory = "/home/careb0t";

    # Environment variables
    sessionVariables = {
      TERM = "wezterm";
    };

    # Installed packages
    packages =
      let
        ad-strawberry-numix-icons = pkgs.callPackage ../icons.nix { };
      in
      [
        ad-strawberry-numix-icons # derivation for red icon pack
        pkgs.picom
        pkgs.gcc-unwrapped
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
        pkgs.xorg.xkill
        pkgs.wine
        pkgs.unar
        pkgs.path-of-building
        pkgs.xdg-desktop-portal
        pkgs.lazygit
        pkgs.xivlauncher
        pkgs.exiftool
        pkgs.p7zip-rar
        pkgs.piper
        pkgs.mangohud
        pkgs.feh
        pkgs.obs-studio
        pkgs.vlc
        pkgs.xdg-utils
        pkgs.protonup-qt
        pkgs.gamescope
      ];
  };

  # Font configuration
  fonts.fontconfig = {
    enable = true;
  };

  # Flake templates
  nix.registry.devflakes.to = {
    type = "path";
    path = "${../devflakes}";
  };

  # Qtile configuration
  xdg.configFile."qtile".source = ./qtile;

  # terminal configuration
  xdg.configFile."wezterm/wezterm.lua".source = ../wezterm/wezterm.lua;
  programs.wezterm.enable = true;

  # Starship configuration
  xdg.configFile."starship.toml".source = ../wezterm/starship.toml;

  # Yazi configuration
  xdg.configFile."yazi".source = ../yazi;

  # Zellij configuration
  xdg.configFile."zellij".source = ../zellij;

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
      nix-rebuild = "sudo nixos-rebuild switch --flake .#lubyanka";
      hm-rebuild = "home-manager switch --flake .#careb0t@lubyanka";
      hm-update = "nix flake update && home-manager switch --flake .#careb0t@lubyanka";
      hm-clean = "nix-garbage-collect -d";
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
                  											for dir in /home/careb0t/dotfiles/home-manager/devflakes/*/; do
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

  # Atuin configuration
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    daemon.enable = true;
    settings = {
      enter_accept = true;
    };
  };

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
      package = pkgs.callPackage ../icons.nix { };
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
        betterGenres
        beautifulLyrics
      ];
      theme = spicePkgs.themes.sleek;
      colorScheme = "coral";
    };

  # Discord + Vencord configuration
  xdg.configFile."Vencord/themes".source = ../Vencord/themes;
  programs.nixcord = {
    enable = true;
    discord.vencord.unstable = true;
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
        experiments.enable = true;
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
        noBlockedMessages.enable = true;
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

  # unclutter configuration
  services.unclutter = {
    enable = true;
    timeout = 2;
    extraOptions = [
      "noevent"
      "grab"
      "ignore-scrolling"
    ];
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

  # ollama configuration
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    environmentVariables = {
      OLLAMA_MODELS = "/ssd/ollama/models";
    };
  };

  # temporary fix for 'Unit tray.target not found' error on hm-rebuild
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
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
    #highlightOverride = {
    #  NeoTreeGitConflict = {
    #    fg = "#DD9998";
    #    bg = null;
    #    bold = true;
    #    italic = true;
    #  };
    #  NeoTreeGitUntracked = {
    #    fg = "#9F6666";
    #    bg = null;
    #    bold = false;
    #    italic = true;
    #  };
    #};
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
      #{
      #  mode = "n";
      #  key = "<leader>ft";
      #  action = ":Neotree filesystem reveal toggle<CR>";
      #  options = {
      #    silent = true;
      #    desc = "toggle neotree";
      #  };
      #}
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>lf";
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
        key = "<leader>ll";
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
        key = "<leader>lh";
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
        key = "<leader>ld";
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
        key = "<leader>lr";
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
        key = "<leader>la";
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
        key = "<leader>fu";
        action = "<cmd>Telescope undo<cr>";
        options = {
          silent = false;
          desc = "telescope - undo history";
        };
      }
      {
        mode = [ "n" ];
        key = "<leader>fn";
        action = "<cmd>Telescope notify<cr>";
        options = {
          silent = false;
          desc = "telescope - notify";
        };
      }
      {
        mode = [ "n" ];
        key = "<leader>fm";
        action = "<cmd>Telescope manix<cr>";
        options = {
          silent = false;
          desc = "telescope - Nix";
        };
      }
      {
        mode = [ "n" ];
        key = "<leader>fb";
        action = "<cmd>Telescope file_browser<cr>";
        options = {
          silent = false;
          desc = "telescope - file broswer";
        };
      }
      {
        mode = [ "i" ];
        key = "<C-CR>";
        action = {
          __raw = ''
            function()
              require("in-and-out").in_and_out()
            end
          '';
        };
        options = {
          silent = false;
          desc = "telescope - file broswer";
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
          #"NeoTreeCursorLine"
          #"NeoTreeDimText"
          #"NeoTreeDirectoryIcon"
          #"NeoTreeDirectoryName"
          #"NeoTreeDotfile"
          #"NeoTreeFileIcon"
          #"NeoTreeFileName"
          #"NeoTreeFileNameOpene"
          #"NeoTreeFilterTerm"
          #"NeoTreeTitleBar"
          #"NeoTreeGitAdded"
          #"NeoTreeGitConflict"
          #"NeoTreeGitDeleted"
          #"NeoTreeGitIgnored"
          #"NeoTreeGitModified"
          #"NeoTreeGitUnstaged"
          #"NeoTreeGitUntracked"
          #"NeoTreeGitStaged"
          #"NeoTreeHiddenByName"
          #"NeoTreeIndentMarker"
          #"NeoTreeExpander"
          #"NeoTreeNormal"
          #"NeoTreeNormalNC"
          #"NeoTreeSignColumn"
          #"NeoTreeStatusLine"
          #"NeoTreeStatusLineNC"
          #"NeoTreeVertSplit"
          #"NeoTreeWinSeparator"
          #"NeoTreeEndOfBuffer"
          #"NeoTreeRootName"
          #"NeoTreeSymbolicLinkTarget"
          #"NeoTreeTitleBar"
          #"NeoTreeWindowsHidden"
          #"NeotreeCursorLine"
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
      smear-cursor = {
        enable = true;
      };
      sleuth = {
        enable = true;
      };
      hardtime = {
        enable = true;
        settings = {
          disabled_keys = {
            "<Down>" = [
              ""
            ];
            "<Left>" = [
              ""
            ];
            "<Right>" = [
              ""
            ];
            "<Up>" = [
              ""
            ];
          };
        };
      };
      neocord = {
        enable = true;
      };
      nvim-lightbulb = {
        enable = true;
      };
      todo-comments = {
        enable = true;
      };
      notify = {
        enable = true;
        settings = {
          stages = "slide";
        };
      };
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "path"; }
          { name = "buffer"; }
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
      wilder = {
        enable = true;
        modes = [
          "?"
          "/"
          ":"
        ];
        pipeline = [
          ''
            wilder.branch(
              wilder.cmdline_pipeline({
                language = 'python',
                fuzzy = 1,
              }),
              wilder.python_search_pipeline({
                pattern = wilder.python_fuzzy_pattern(),
                sorter = wilder.python_difflib_sorter(),
                engine = 're',
              })
            )
          ''
        ];
        renderer = ''
          wilder.popupmenu_renderer({
            highlighter = wilder.basic_highlighter(),
            left = {' ', wilder.popupmenu_devicons()},
            right = {' ', wilder.popupmenu_scrollbar()},
          })
        '';
      };
      cmp_luasnip = {
        enable = true;
      };
      #blink-cmp = {
      #  enable = true;
      #  settings = {
      #    appearance = {
      #      use_nvim_cmp_as_default = false;
      #    };
      #    completion = {
      #      documentation = {
      #        auto_show = true;
      #      };
      #    };
      #    keymap = {
      #      preset = "super-tab";
      #    };
      #    signature = {
      #      enabled = true;
      #    };
      #    sources = {
      #      providers = {
      #        buffer = {
      #          score_offset = -7;
      #        };
      #      };
      #    };
      #  };
      #};
      #blink-compat = {
      #  enable = true;
      #};
      ts-autotag = {
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
      avante = {
        enable = true;
        package = pkgs.vimPlugins.avante-nvim;
        settings = {
          provider = "ollama";
          vendors = {
            ollama = {
              __inherited_from = "openai";
              endpoint = "http://127.0.0.1:11434/v1";
              model = "deepseek-coder-v2:16b";
            };
          };
          diff = {
            autojump = true;
            debug = false;
            list_opener = "copen";
          };
          highlights = {
            diff = {
              current = "DiffText";
              incoming = "DiffAdd";
            };
          };
          hints = {
            enabled = true;
          };
          mappings = {
            diff = {
              both = "cb";
              next = "]x";
              none = "c0";
              ours = "co";
              prev = "[x";
              theirs = "ct";
            };
          };
          windows = {
            sidebar_header = {
              align = "center";
              rounded = true;
            };
            width = 30;
            wrap = true;
          };
        };
      };
      render-markdown = {
        enable = true;
        settings = {
          file_types = [
            "Avante"
          ];
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
        settings = {
          shell = "zsh";
          keymap_toggle = "<C-`>";
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
                #"neo-tree"
                #"neotree"
                #"Neotree"
                #"Neo-tree"
                "alpha"
                "toggleterm"
                "Telescope"
                "Avante"
              ];
              tabline = [ ];
              winbar = [ ];
            };
            ignore_focus = [
              #"neo-tree"
              #"neotree"
              #"Neotree"
              #"Neo-tree"
              #"toggleterm"
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
      #neo-tree = {
      #  enable = true;
      #  closeIfLastWindow = true;
      #  popupBorderStyle = "single";
      #  window.position = "float";
      #  window.popup.position = "50%";
      #  filesystem = {
      #    filteredItems = {
      #      hideGitignored = true;
      #      hideDotfiles = false;
      #      hideByName = [
      #        ".github"
      #        ".gitignore"
      #        "package-lock.json"
      #      ];
      #      neverShow = [
      #        ".git"
      #      ];
      #    };
      #  };
      #  eventHandlers = {
      #    file_opened = ''
      #        				function(file_path)
      #          				--auto close
      #          				require("neo-tree").close_all()
      #        				end
      #      					'';
      #  };
      #};
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
          file-browser.enable = true;
          manix.enable = true;
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
    };
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "in-and-out";
        src = pkgs.fetchFromGitHub {
          owner = "ysmb-wtsg";
          repo = "in-and-out.nvim";
          rev = "ca02f04c0817e7712f0c9bde5016c36b80339413";
          hash = "sha256-ggaq3NOenNkzp4A8gNXjyRbbbLLQXmEXPhWU5lCWSqo=";
        };
      })
    ];
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

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
