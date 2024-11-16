return {
    "goolord/alpha-nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        math.randomseed(os.time())

        local function pick_color()
            local colors = { "String", "Identifier", "Keyword", "Number" }
            return colors[math.random(#colors)]
        end

        local function footer()
            local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
            local version = vim.version()
            local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

            return datetime .. nvim_version_info
        end

        local logo = {
            "            :h-                                  Nhy`               ",
            "           -mh.                           h.    `Ndho               ",
            "           hmh+                          oNm.   oNdhh               ",
            "          `Nmhd`                        /NNmd  /NNhhd               ",
            "          -NNhhy                      `hMNmmm`+NNdhhh               ",
            "          .NNmhhs              ```....`..-:/./mNdhhh+               ",
            "           mNNdhhh-     `.-::///+++////++//:--.`-/sd`               ",
            "           oNNNdhhdo..://++//++++++/+++//++///++/-.`                ",
            "      y.   `mNNNmhhhdy+/++++//+/////++//+++///++////-` `/oos:       ",
            " .    Nmy:  :NNNNmhhhhdy+/++/+++///:.....--:////+++///:.`:s+        ",
            " h-   dNmNmy oNNNNNdhhhhy:/+/+++/-         ---:/+++//++//.`         ",
            " hd+` -NNNy`./dNNNNNhhhh+-://///    -+oo:`  ::-:+////++///:`        ",
            " /Nmhs+oss-:++/dNNNmhho:--::///    /mmmmmo  ../-///++///////.       ",
            "  oNNdhhhhhhhs//osso/:---:::///    /yyyyso  ..o+-//////////:/.      ",
            "   /mNNNmdhhhh/://+///::://////     -:::- ..+sy+:////////::/:/.     ",
            "     /hNNNdhhs--:/+++////++/////.      ..-/yhhs-/////////::/::/`    ",
            "       .ooo+/-::::/+///////++++//-/ossyyhhhhs/:///////:::/::::/:    ",
            "       -///:::::::////++///+++/////:/+ooo+/::///////.::://::---+`   ",
            "       /////+//++++/////+////-..//////////::-:::--`.:///:---:::/:   ",
            "       //+++//++++++////+++///::--                 .::::-------::   ",
            "       :/++++///////////++++//////.                -:/:----::../-   ",
            "       -/++++//++///+//////////////               .::::---:::-.+`   ",
            "       `////////////////////////////:.            --::-----...-/    ",
            "        -///://////////////////////::::-..      :-:-:-..-::.`.+`    ",
            "         :/://///:///::://::://::::::/:::::::-:---::-.-....``/- -   ",
            "           ::::://::://::::::::::::::----------..-:....`.../- -+oo/ ",
            "            -/:::-:::::---://:-::-::::----::---.-.......`-/.      ``",
            "           s-`::--:::------:////----:---.-:::...-.....`./:          ",
            "          yMNy.`::-.--::..-dmmhhhs-..-.-.......`.....-/:`           ",
            "         oMNNNh. `-::--...:NNNdhhh/.--.`..``.......:/-              ",
            "        :dy+:`      .-::-..NNNhhd+``..`...````.-::-`                ",
            "                        .-:mNdhh:.......--::::-`                    ",
            "                           yNh/..------..`                          ",
            "                                                                    ",
        }

        dashboard.section.header.val = logo
        dashboard.section.header.opts.hl = pick_color()

        dashboard.section.buttons.val = {
            dashboard.button("<Leader>ff", "  File Explorer"),
            dashboard.button("<Leader>fo", "  Find File"),
            dashboard.button("<Leader>fw", "  Find Word"),
            dashboard.button("<Leader>ps", "  Update plugins"),
            dashboard.button("q", "  Quit", ":qa<cr>"),
        }

        dashboard.section.footer.val = footer()
        dashboard.section.footer.opts.hl = "Constant"

        alpha.setup(dashboard.opts)

        vim.cmd([[ autocmd FileType alpha setlocal nofoldenable ]])
    end,
}
