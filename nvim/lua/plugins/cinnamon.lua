return {
    {
        'declancm/cinnamon.nvim',
        version = '*',
        config = function()
            local cinnamon = require('cinnamon')
            cinnamon.setup({
                keymaps = {
                    basic = true,
                    extra = true,
                },
                options = {
                    mode = 'cursor',
                },
            })
        end,
    },
}
