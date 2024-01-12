return {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    config = function()
        require('bqf').setup({
            filter = {
                fzf = {
                    extra_opts = {'--bind', 'ctrl-o:toggle-all', '--delimiter', '│'}
                }
            }
        })
    end
}
