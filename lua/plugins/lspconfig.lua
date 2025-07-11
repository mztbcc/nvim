return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim', config = true },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        config = function()
            vim.diagnostic.config({
                signs = false,
                severity_sort = true,
                float = { border = 'rounded', source = 'if_many' },
                underline = { severity = vim.diagnostic.severity.ERROR },
                virtual_text = {
                    source = 'if_many',
                    spacing = 1,
                    format = function(diagnostic)
                        local diagnostic_message = {
                            [vim.diagnostic.severity.ERROR] = diagnostic.message,
                            [vim.diagnostic.severity.WARN] = diagnostic.message,
                            [vim.diagnostic.severity.INFO] = diagnostic.message,
                            [vim.diagnostic.severity.HINT] = diagnostic.message,
                        }
                        return diagnostic_message[diagnostic.severity]
                    end,
                },
            })

            -- custom LSP configs are define here
            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = { globals = { 'vim' } },
                            workspace = { checkThirdParty = false },
                            telemetry = { enable = false },
                        },
                    },
                },
                intelephense = {
                    init_options = {
                        globalStoragePath = os.getenv('HOME') .. '/.local/share/intelephense',
                    },
                },
                vuels = {
                    filetypes = { 'vue' },
                    init_options = {
                        config = {
                            vetur = {
                                validation = {
                                    template = true,
                                    script = true,
                                    style = true,
                                },
                            },
                        },
                    },
                },
            }
            local lspconfig = require('lspconfig')
            for server_name, server_config in pairs(servers) do
                lspconfig[server_name].setup(vim.tbl_deep_extend('force', {
                    capabilities = capabilities,
                }, server_config))
            end
        end,
    },
}
