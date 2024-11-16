{ config, lib, pkgs, unstable, inputs, ... }:
let
  helpers = config.lib.nixvim;
in
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

        # NixOS version
        stateVersion = "24.05";

        # Installed packages
        packages = let
            ad-strawberry-numix-icons = pkgs.callPackage ./icons.nix { };
        in [
            ad-strawberry-numix-icons # derivation for red icon pack
            pkgs.picom
            pkgs.vivaldi
            pkgs.vivaldi-ffmpeg-codecs
            pkgs.firefox
            pkgs.wezterm
            #pkgs.neovim
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
            pkgs.nerdfonts
            pkgs.gimp
            pkgs.networkmanager
            pkgs.numix-cursor-theme
            pkgs.dconf
            pkgs.lxappearance
            pkgs.libsForQt5.qt5ct
            pkgs.libsForQt5.qtstyleplugin-kvantum
            pkgs.gparted
            pkgs.catnip
            pkgs.deno
            pkgs.xorg.xkill
        ];
    };

    # Qtile configuration
    xdg.configFile."qtile/config.py".source = ./qtile/config.py;

    # wezterm configuration
    xdg.configFile."wezterm/wezterm.lua".source = ./wezterm/wezterm.lua;

    # Starship configuration
    xdg.configFile."starship.toml".source = ./wezterm/starship.toml;

    # Zellij configuration
    xdg.configFile."zellij".source = ./zellij;

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
                tweaks = ["darker"];
                themeVariants = ["pink"];
                colorVariants = ["dark"];
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
            };
        };
    };

    # Nixvim configuration
    programs.nixvim = {
        enable = true;
        defaultEditor = true;
        vimdiffAlias = true;
        clipboard.register = "xclip";
        colorschemes.base16 = {
            enable = true;
            colorscheme = "dracula";
        };
        opts = {
            number = true;
            relativenumber = true;
            undodir = "./undo";
            undofile = true;
            fillchars = {eob = " ";};
            tabstop = 4;
            shiftwidth = 4;
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
                key = "<leader>t";
                action = ":Neotree filesystem reveal left toggle<CR>";
                options = {
                    silent = true;
                    desc = "toggle neotree";
                };
            }
            {
                mode = [ "n" "v" ];
                key = "<leader>gf";
                action = {
                    __raw = ''
                        function()
                            conform.format({
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
                            lint.try_lint()
                        end
                    '';
                };
                options = {
                    silent = false;
                    desc = "lint current file";
                };
            }
            {
                mode = [ "n" "x" "o" ];
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
                mode = [ "n" "x" "o" ];
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
                mode = [ "x" "o" ];
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
                mode = [ "c" ];
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
        ];
        plugins = {
#             alpha = {
#                 enable = true;
#                 layout = [];
#             };
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
                    { name = "ultisnips"; }
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
                                ['<S-Tab>'] = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
                                ['<Tab>'] = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
                            })
                        '';
                    };
                    snippet = {
                        expand = "function(args) vim.fn['UltiSnips#Anon'](args.body) end";
                    };
                    window = {
#                         __raw = ''
#                             completion = cmp.config.window.bordered(),
#                             documentation = cmp.config.window.bordered(),
#                         '';
                    };
                };
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
                            __unkeyed-2 = "prettier";
                            timeout_ms = 2000;
                            stop_after_first = true;
                        };

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
                    event = ["BufWritePost" "InsertLeave" "BufEnter" ];
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
                        disabled_filetypes = {
                            __unkeyed-1 = "startify";
                            __unkeyed-2 = "neo-tree";
                            statusline = [
                                "dap-repl"
                            ];
                            winbar = [
                                "aerial"
                                "dap-repl"
                                "neotest-summary"
                            ];
                        };
                        globalstatus = true;
                    };
                    sections = {
                        lualine_a = [
                        "mode"
                        ];
                        lualine_b = [
                        "branch"
                        ];
                        lualine_c = [
                        "filename"
                        "diff"
                        ];
                        lualine_x = [
                        "diagnostics"
                        {
                            __unkeyed-1 = {
                            __raw = ''
                                function()
                                    local msg = ""
                                    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                                    local clients = vim.lsp.get_active_clients()
                                    if next(clients) == nil then
                                        return msg
                                    end
                                    for _, client in ipairs(clients) do
                                        local filetypes = client.config.filetypes
                                        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                                            return client.name
                                        end
                                    end
                                    return msg
                                end
                            '';
                            };
                            color = {
                            fg = "#ffffff";
                            };
                            icon = "";
                        }
                        "encoding"
                        "fileformat"
                        "filetype"
                        ];
                        lualine_y = [
                        {
                            __unkeyed-1 = "aerial";
                            colored = true;
                            cond = {
                            __raw = ''
                                function()
                                local buf_size_limit = 1024 * 1024
                                if vim.api.nvim_buf_get_offset(0, vim.api.nvim_buf_line_count(0)) > buf_size_limit then
                                    return false
                                end

                                return true
                                end
                            '';
                            };
                            dense = false;
                            dense_sep = ".";
                            depth = {
                            __raw = "nil";
                            };
                            sep = " ) ";
                        }
                        ];
                        lualine_z = [
                        {
                            __unkeyed-1 = "location";
                        }
                        ];
                    };
                    tabline = {
                        lualine_a = [
                        {
                            __unkeyed-1 = "buffers";
                            symbols = {
                            alternate_file = "";
                            };
                        }
                        ];
                        lualine_z = [
                        "tabs"
                        ];
                    };
                    winbar = {
                        lualine_c = [
                        {
                            __unkeyed-1 = "navic";
                        }
                        ];
                        lualine_x = [
                        {
                            __unkeyed-1 = "filename";
                            newfile_status = true;
                            path = 3;
                            shorting_target = 150;
                        }
                        ];
                    };
                };
            };
            neo-tree = {
                enable = true;
                window.width = 40;
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
            #set manual format key for conform
            #set manual lint key for lint
            #set flash keys
            #set lsp keys
            #set telescope + undo key
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
