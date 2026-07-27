-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
-- vim.g.maplocalleader = "\\"

local map = vim.keymap.set
local fn = vim.fn


-- Setup lazy.nvim
require("lazy").setup({
    -- automatically check for plugin updates
    checker = { enabled = true },
    { "nvim-lua/plenary.nvim" },
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        keys = {
            { '<leader>pf', function() require('telescope.builtin').find_files() end },
            { '<C-p>', function() require('telescope.builtin').git_files() end },
            {
                '<leader>ps',
                function()
                    require('telescope.builtin').grep_string({ search = vim.fn.input("Grep > ") })
                end,
            },
        },
        config = function()
            require('telescope').setup({
                defaults = {
                    file_sorter = require('telescope.sorters').get_fuzzy_file,
                    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
                    generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
                    file_ignore_patterns = {
                        'node_modules',
                        'dist',
                        '.git',
                    },
                },
                pickers = {
                    find_files = {
                        find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
                    },
                },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("nvim-treesitter.config").setup({
                ensure_installed = {
                    "javascript",
                    "typescript",
                    "rust",
                    "c",
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                    "markdown",
                    "markdown_inline",
                    "scala",
                    "graphql",
                    "html",
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = { "markdown", "markdown_inline" },
                },
                indent = { enable = true },
                auto_install = true,
            })
        end,
    },
    -- Icons for file explorer
    { "nvim-tree/nvim-web-devicons", opts = {} },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            {
                '<leader>a',
                function()
                    require('harpoon'):list():add()
                end,
            },
            {
                '<C-e>',
                function()
                    local harpoon = require('harpoon')
                    harpoon.ui:toggle_quick_menu(harpoon:list())
                end,
            },
            {
                '<C-h>',
                function()
                    require('harpoon'):list():select(1)
                end,
            },
            {
                '<C-j>',
                function()
                    require('harpoon'):list():select(2)
                end,
            },
            {
                '<C-k>',
                function()
                    require('harpoon'):list():select(3)
                end,
            },
            {
                '<C-l>',
                function()
                    require('harpoon'):list():select(4)
                end,
            },
        },
        config = function()
            local harpoon = require("harpoon")

            harpoon:setup({
                menu = {
                    width = vim.api.nvim_win_get_width(0) - 4,
                },
            })
        end,
    },
    {
        "mbbill/undotree",
        cmd = { "UndotreeToggle", "UndotreeShow", "UndotreeHide", "UndotreeFocus" },
        keys = {
            { '<leader>u', '<cmd>UndotreeToggle<CR>', silent = true },
        },
    },
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gwrite", "Gread", "GBrowse", "BCommits" },
        keys = {
            { '<leader>gs', '<cmd>Git<CR>', silent = true },
            { '<leader>gb', '<cmd>Git blame --date=relative<CR>', silent = true },
            { '<leader>bc', '<cmd>BCommits<CR>', silent = true },
        },
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-vsnip" },
            { "hrsh7th/vim-vsnip" }
        },
        opts = function()
            local cmp = require("cmp")
            local conf = {
                sources = {
                    { name = "nvim_lsp" },
                    { name = "vsnip" },
                },
                snippet = {
                    expand = function(args)
                        -- Comes from vsnip
                        fn["vsnip#anonymous"](args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    -- None of this made sense to me when first looking into this since there
                    -- is no vim docs, but you can't have select = true here _unless_ you are
                    -- also using the snippet stuff. So keep in mind that if you remove
                    -- snippets you need to remove this select
                    ["<CR>"] = cmp.mapping.confirm({ select = true })
                })
            }
            return conf
        end
    },
    { "hrsh7th/cmp-nvim-lsp" },
    { "github/copilot.vim", event = "InsertEnter" },
    { "folke/todo-comments.nvim", event = "VeryLazy", opts = {} },
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        opts = {
            window = {
                width = 200,
            },
        }
    },

    -- Add gutter signs for git
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        keys = {
            { '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>', silent = true },
        },
        config = function()
            require('gitsigns').setup({
                current_line_blame = true,
                current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
                signs = {
                    add          = { text = '│' },
                    change       = { text = '│' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                }
            })
        end
    },

    -- Split view in git
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
        requires = "nvim-lua/plenary.nvim",
        keys = {
            { '<leader>do', '<cmd>DiffviewOpen<CR>', silent = true },
            { '<leader>dc', '<cmd>DiffviewClose<CR>', silent = true },
            { '<leader>bd', '<cmd>DiffviewFileHistory<CR>', silent = true },
            { '<leader>bh', '<cmd>DiffviewFileHistory %<CR>', silent = true },
            { '<leader>dm', '<cmd>DiffviewOpen dev..HEAD<CR>', silent = true },
            {
                '<leader>gd',
                function()
                    local parent = vim.fn.system('gt parent'):gsub('\n', '')
                    vim.cmd('DiffviewOpen ' .. parent)
                end,
                silent = true,
            },
        },
        config = function()
            require('diffview').setup({
                enhanced_diff_hl = true,
                view = {
                    default = {
                        layout = "diff2_horizontal",
                        winbar_info = false,
                    },
                    merge_tool = {
                        layout = "diff3_mixed",
                        disable_diagnostics = true,
                        winbar_info = true,
                    },
                    file_history = {
                        layout = "diff2_horizontal",
                        winbar_info = false,
                    },
                },
                file_panel = {
                    listing_style = "list",
                    win_config = {
                        position = "left",
                        width = 60, -- Instead of width
                    },
                },
                signs = {
                    fold_closed = "",
                    fold_open = "",
                    done = "✓",
                },
                signs_placement = "left",
            })

            -- Diffview's merge winbar only shows hashes by default; add commit subjects.
            do
                local GitAdapter = require('diffview.vcs.adapters.git').GitAdapter
                local FileEntry = require('diffview.scene.file_entry').FileEntry
                local RevType = require('diffview.vcs.rev').RevType
                local Window = require('diffview.scene.window').Window
                local path = require('plenary.path')

                if not GitAdapter._jay_merge_subjects_patched then
                    GitAdapter._jay_merge_subjects_patched = true

                    local original_get_merge_context = GitAdapter.get_merge_context
                    GitAdapter.get_merge_context = function(self)
                        local ctx = original_get_merge_context(self)
                        if not ctx then
                            return ctx
                        end

                        local function add_subject(name, rev)
                            local out, code = self:exec_sync({ 'show', '-s', '--pretty=format:%s', rev, '--' }, self.ctx.toplevel)
                            if code == 0 and out[1] and out[1] ~= '' then
                                ctx[name].subject = out[1]
                            end
                        end

                        local theirs_rev
                        for _, rev in ipairs({ 'MERGE_HEAD', 'REBASE_HEAD', 'REVERT_HEAD', 'CHERRY_PICK_HEAD' }) do
                            if path:new(self.ctx.dir, rev):exists() then
                                theirs_rev = rev
                                break
                            end
                        end

                        add_subject('ours', 'HEAD')
                        if theirs_rev then
                            add_subject('theirs', theirs_rev)
                        end

                        if ctx.base and ctx.base.hash then
                            add_subject('base', ctx.base.hash)
                        end

                        return ctx
                    end
                end

                if not FileEntry._jay_merge_subjects_patched then
                    FileEntry._jay_merge_subjects_patched = true

                    local original_update_merge_context = FileEntry.update_merge_context
                    FileEntry.update_merge_context = function(self, ctx)
                        original_update_merge_context(self, ctx)

                        ctx = ctx or self.merge_ctx
                        if not ctx then
                            return
                        end

                        local layout = self.layout
                        local function format_winbar(label, info)
                            if not info then
                                return label
                            end

                            local parts = { label }

                            if info.subject and info.subject ~= '' then
                                table.insert(parts, info.subject)
                            end

                            if info.hash and info.hash ~= '' then
                                table.insert(parts, '(' .. info.hash:sub(1, 10) .. ')')
                            end

                            return ' ' .. table.concat(parts, ' ')
                        end

                        if layout.a then
                            layout.a.file.winbar = format_winbar('OURS (Current changes)', ctx.ours)
                        end

                        if layout.c then
                            layout.c.file.winbar = format_winbar('THEIRS (Incoming changes)', ctx.theirs)
                        end

                        if layout.d then
                            layout.d.file.winbar = format_winbar('BASE (Common ancestor)', ctx.base)
                        end
                    end
                end

                if not Window._jay_merge_subjects_patched then
                    Window._jay_merge_subjects_patched = true

                    local function git_show(adapter, rev)
                        local out, code = adapter:exec_sync({ 'show', '-s', '--pretty=format:%s%n%D%n%H', rev, '--' }, adapter.ctx.toplevel)
                        if code ~= 0 then
                            return nil
                        end

                        return {
                            subject = out[1],
                            ref_names = out[2],
                            hash = out[3],
                        }
                    end

                    local function get_theirs_rev(adapter)
                        for _, rev in ipairs({ 'MERGE_HEAD', 'REBASE_HEAD', 'REVERT_HEAD', 'CHERRY_PICK_HEAD' }) do
                            if path:new(adapter.ctx.dir, rev):exists() then
                                return rev
                            end
                        end
                    end

                    local function get_stage_info(file)
                        local adapter = file.adapter
                        local stage = file.rev.stage

                        if stage == 1 then
                            local theirs_rev = get_theirs_rev(adapter)
                            if not theirs_rev then
                                return 'BASE (Common ancestor)', nil
                            end

                            local base_hash = adapter:exec_sync({ 'merge-base', 'HEAD', theirs_rev }, adapter.ctx.toplevel)[1]
                            return 'BASE (Common ancestor)', base_hash and git_show(adapter, base_hash) or nil
                        end

                        if stage == 2 then
                            return 'OURS (Current changes)', git_show(adapter, 'HEAD')
                        end

                        if stage == 3 then
                            local theirs_rev = get_theirs_rev(adapter)
                            return 'THEIRS (Incoming changes)', theirs_rev and git_show(adapter, theirs_rev) or nil
                        end
                    end

                    local function format_winbar(label, info)
                        local parts = { label }

                        if info and info.subject and info.subject ~= '' then
                            table.insert(parts, info.subject)
                        end

                        local details = {}
                        if info and info.ref_names and info.ref_names ~= '' then
                            table.insert(details, info.ref_names)
                        end

                        if info and info.hash and info.hash ~= '' then
                            table.insert(details, info.hash:sub(1, 10))
                        end

                        if #details > 0 then
                            table.insert(parts, '(' .. table.concat(details, '; ') .. ')')
                        end

                        return ' ' .. table.concat(parts, ' ')
                    end

                    local original_post_open = Window.post_open
                    Window.post_open = function(self)
                        original_post_open(self)

                        if not (self:is_valid() and self.file and self:show_winbar_info()) then
                            return
                        end

                        if self.file.kind ~= 'conflicting' or self.file.rev.type ~= RevType.STAGE then
                            return
                        end

                        local label, info = get_stage_info(self.file)
                        if not label then
                            return
                        end

                        local winbar = format_winbar(label, info)
                        self.file.winbar = winbar
                        vim.wo[self.id].winbar = winbar
                    end
                end
            end
        end
    },

    -- Git blame
    { "rhysd/git-messenger.vim", cmd = { "GitMessenger" } },

    -- Color Themes
    { "AlexvZyl/nordic.nvim", lazy = true },
    { "catppuccin/nvim", priority = 1000 },

    -- fzf for fast file search
    {
        {
            "junegunn/fzf",
            build = "./install --bin", -- Ensures the fzf binary is installed
        },
        {
            "junegunn/fzf.vim",
            dependencies = { "junegunn/fzf" },
            config = function()
                -- Function to determine project root
                local function get_project_root()
                    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")
                    if vim.v.shell_error == 0 and #git_root > 0 then
                        return git_root[1]
                    else
                        return vim.fn.getcwd() -- Fallback to current working directory
                    end
                end

                -- Create a custom command 'RgExact' that takes arguments.
                vim.api.nvim_create_user_command("RgExactExcludingTests", function(opts)
                    local query = opts.args
                    if query == "" then
                        query = vim.fn.input("Rg (exact)> ")
                        if query == "" then return end
                    end

                    local root_dir = get_project_root()
                    local escaped_query = vim.fn.shellescape(query)
                    local escaped_root_dir = vim.fn.shellescape(root_dir)

                    local cmd = string.format(
                        "rg --fixed-strings --color=always --line-number --column --no-heading -P %s --glob '!**/*bazel*/**' --glob '!**/desktop/generated/**' --glob '!**/tmp/**' --glob '!node_modules' --glob '!**/.git/**' --glob '!**/*3rdparty*/**' --glob '!**/*.tools*/**' --glob '!**/*demo_files*/**' --glob '!**/*-lock*/**' --glob '!**/*metals*/**' --glob '!**/*_test*' --glob '!**/*.json' %s",
                        escaped_query, escaped_root_dir
                    )

                    vim.fn["fzf#vim#grep"](cmd, 1, vim.fn["fzf#vim#with_preview"](), opts.bang and 1 or 0)
                end, {
                    nargs = "*",
                    bang = true,
                    desc = "Search with ripgrep in exact (literal) mode from project root",
                }
                )

                -- Search for string match with regex (FZF with Ctrl-Q to send to quickfix)
                vim.api.nvim_create_user_command("Rg", function(opts)
                    local query = opts.args
                    if query == "" then
                        query = vim.fn.input("Rg >")
                        if query == "" then return end
                    end

                    local root_dir = get_project_root()
                    local escaped_query = vim.fn.shellescape(query)
                    local escaped_root_dir = vim.fn.shellescape(root_dir)

                    local cmd = string.format(
                        "rg --color=always --line-number --column --no-heading %s --glob '!**/*bazel*/**' --glob '!**/desktop/generated/**' --glob '!**/tmp/**' --glob '!node_modules' --glob '!**/.git/**' --glob '!**/*3rdparty*/**' --glob '!**/*.tools*/**' --glob '!**/*demo_files*/**' --glob '!**/*-lock*/**' --glob '!**/*metals*/**' %s",
                        escaped_query, escaped_root_dir
                    )

                    -- Add Ctrl-Q to send all results to quickfix using --expect
                    local spec = vim.fn["fzf#vim#with_preview"]()
                    spec.options = spec.options or {}
                    table.insert(spec.options, '--expect=ctrl-q')

                    -- Custom sink to handle quickfix population
                    spec['sink*'] = function(lines)
                        local key = table.remove(lines, 1)
                        if key == 'ctrl-q' then
                            -- Send all results to quickfix
                            local qf_cmd = string.format(
                                "rg --vimgrep %s --glob '!**/*bazel*/**' --glob '!**/desktop/generated/**' --glob '!**/tmp/**' --glob '!node_modules' --glob '!**/.git/**' --glob '!**/*3rdparty*/**' --glob '!**/*.tools*/**' --glob '!**/*demo_files*/**' --glob '!**/*-lock*/**' --glob '!**/*metals*/**' %s",
                                escaped_query, escaped_root_dir
                            )
                            vim.fn.setqflist({}, 'r')
                            vim.cmd('cexpr system("' .. qf_cmd:gsub('"', '\\"') .. '")')
                            vim.cmd('copen')
                        elseif #lines > 0 then
                            -- Parse the first selected line and open the file
                            local line = lines[1]
                            if line then
                                -- Parse format: filename:line:column:content
                                local parts = vim.split(line, ':')
                                if #parts >= 3 then
                                    local file = parts[1]
                                    local lnum = parts[2]
                                    local col = parts[3]
                                    vim.cmd('edit ' .. vim.fn.fnameescape(file))
                                    vim.fn.cursor(tonumber(lnum), tonumber(col))
                                end
                            end
                        end
                    end

                    vim.fn["fzf#vim#grep"](cmd, 1, spec, opts.bang and 1 or 0)
                end, {
                    nargs = "*",
                    bang = true,
                    desc = "Search with ripgrep (Ctrl-Q for quickfix)",
                }
                )

                -- Search for exact string match, case-insensitive (FZF with Ctrl-Q to send to quickfix)
                vim.api.nvim_create_user_command("RgIgnoreCaseFixedStrings", function(opts)
                    local query = opts.args
                    if query == "" then
                        query = vim.fn.input("Rg (ignore case)> ")
                        if query == "" then return end
                    end

                    local root_dir = get_project_root()
                    local escaped_query = vim.fn.shellescape(query)
                    local escaped_root_dir = vim.fn.shellescape(root_dir)

                    local cmd = string.format(
                        "rg --ignore-case --fixed-strings --color=always --line-number --column --no-heading %s --glob '!**/*bazel*/**' --glob '!**/desktop/generated/**' --glob '!**/tmp/**' --glob '!node_modules' --glob '!**/.git/**' --glob '!**/*3rdparty*/**' --glob '!**/*.tools*/**' --glob '!**/*demo_files*/**' --glob '!**/*-lock*/**' --glob '!**/*metals*/**' %s",
                        escaped_query, escaped_root_dir
                    )

                    -- Add Ctrl-Q to send all results to quickfix using --expect
                    local spec = vim.fn["fzf#vim#with_preview"]()
                    spec.options = spec.options or {}
                    table.insert(spec.options, '--expect=ctrl-q')

                    -- Custom sink to handle quickfix population
                    spec['sink*'] = function(lines)
                        local key = table.remove(lines, 1)
                        if key == 'ctrl-q' then
                            -- Send all results to quickfix
                            local qf_cmd = string.format(
                                "rg --vimgrep --ignore-case --fixed-strings %s --glob '!**/*bazel*/**' --glob '!**/desktop/generated/**' --glob '!**/tmp/**' --glob '!node_modules' --glob '!**/.git/**' --glob '!**/*3rdparty*/**' --glob '!**/*.tools*/**' --glob '!**/*demo_files*/**' --glob '!**/*-lock*/**' --glob '!**/*metals*/**' %s",
                                escaped_query, escaped_root_dir
                            )
                            vim.fn.setqflist({}, 'r')
                            vim.cmd('cexpr system("' .. qf_cmd:gsub('"', '\\"') .. '")')
                            vim.cmd('copen')
                        elseif #lines > 0 then
                            -- Parse the first selected line and open the file
                            local line = lines[1]
                            if line then
                                -- Parse format: filename:line:column:content
                                local parts = vim.split(line, ':')
                                if #parts >= 3 then
                                    local file = parts[1]
                                    local lnum = parts[2]
                                    local col = parts[3]
                                    vim.cmd('edit ' .. vim.fn.fnameescape(file))
                                    vim.fn.cursor(tonumber(lnum), tonumber(col))
                                end
                            end
                        end
                    end

                    vim.fn["fzf#vim#grep"](cmd, 1, spec, opts.bang and 1 or 0)
                end, {
                    nargs = "*",
                    bang = true,
                    desc = "Search with ripgrep (Ctrl-Q for quickfix)",
                }
                )

                -- Search for exact string match, case-insensitive, excluding test files (FZF with Ctrl-Q to send to quickfix)
                vim.api.nvim_create_user_command("RgIgnoreCaseFixedStringsExcludingTests", function(opts)
                    local query = opts.args
                    if query == "" then
                        query = vim.fn.input("Rg (ignore case and tests)> ")
                        if query == "" then return end
                    end

                    local root_dir = get_project_root()
                    local escaped_query = vim.fn.shellescape(query)
                    local escaped_root_dir = vim.fn.shellescape(root_dir)

                    local cmd = string.format(
                        "rg --ignore-case --fixed-strings --color=always --line-number --column --no-heading %s --glob '!**/*bazel*/**' --glob '!**/desktop/generated/**' --glob '!**/tmp/**' --glob '!node_modules' --glob '!**/.git/**' --glob '!**/*3rdparty*/**' --glob '!**/*.tools*/**' --glob '!**/*demo_files*/**' --glob '!**/*-lock*/**' --glob '!**/*metals*/**' --glob '!**/*_test*' --glob '!**/*.spec*' %s",
                        escaped_query, escaped_root_dir
                    )

                    -- Add Ctrl-Q to send all results to quickfix using --expect
                    local spec = vim.fn["fzf#vim#with_preview"]()
                    spec.options = spec.options or {}
                    table.insert(spec.options, '--expect=ctrl-q')

                    -- Custom sink to handle quickfix population
                    spec['sink*'] = function(lines)
                        local key = table.remove(lines, 1)
                        if key == 'ctrl-q' then
                            -- Send all results to quickfix
                            local qf_cmd = string.format(
                                "rg --vimgrep --ignore-case --fixed-strings %s --glob '!**/*bazel*/**' --glob '!**/desktop/generated/**' --glob '!**/tmp/**' --glob '!node_modules' --glob '!**/.git/**' --glob '!**/*3rdparty*/**' --glob '!**/*.tools*/**' --glob '!**/*demo_files*/**' --glob '!**/*-lock*/**' --glob '!**/*metals*/**' --glob '!**/*_test*' --glob '!**/*.spec*' %s",
                                escaped_query, escaped_root_dir
                            )
                            vim.fn.setqflist({}, 'r')
                            vim.cmd('cexpr system("' .. qf_cmd:gsub('"', '\\"') .. '")')
                            vim.cmd('copen')
                        elseif #lines > 0 then
                            -- Parse the first selected line and open the file
                            local line = lines[1]
                            if line then
                                -- Parse format: filename:line:column:content
                                local parts = vim.split(line, ':')
                                if #parts >= 3 then
                                    local file = parts[1]
                                    local lnum = parts[2]
                                    local col = parts[3]
                                    vim.cmd('edit ' .. vim.fn.fnameescape(file))
                                    vim.fn.cursor(tonumber(lnum), tonumber(col))
                                end
                            end
                        end
                    end

                    vim.fn["fzf#vim#grep"](cmd, 1, spec, opts.bang and 1 or 0)
                end, {
                    nargs = "*",
                    bang = true,
                    desc = "Search with ripgrep (Ctrl-Q for quickfix)",
                }
                )
            end
        }
    },

    -- Stuff for GraphQL
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason.nvim",           config = true },
            { "williamboman/mason-lspconfig.nvim", enabled = false },
        },
    },

    -- Formatting
    {
        {
            'stevearc/conform.nvim',
            event = { 'BufWritePre' },
            keys = {
                {
                    '<leader>f',
                    function()
                        require('conform').format({ async = true })
                    end,
                    desc = 'Format buffer',
                },
            },
            opts = {
                format_on_save = {
                    lsp_format = 'fallback',
                },
                formatters_by_ft = {
                    javascript = { 'prettier' },
                    typescript = { 'prettier' },
                    javascriptreact = { 'prettier' },
                    typescriptreact = { 'prettier' },
                    json = { 'jq' },
                    css = { 'prettier' },
                    yaml = { 'prettier' },
                    html = { 'prettier' },
                    markdown = { 'prettier' },
                    lua = { 'lsp' },
                },
            },
        }
    },
    {
        "chentoast/marks.nvim",
        event = "VeryLazy",
        opts = {},
    },

    -- Save sessions
    {
        'stevearc/resession.nvim',
        keys = {
            { '<leader>ss', function() require('resession').save() end },
            { '<leader>sl', function() require('resession').load() end },
            { '<leader>sd', function() require('resession').delete() end },
        },
        opts = {},
        config = function(_, opts)
            local resession = require('resession')
            resession.setup(opts)
        end,
    },

    {
        'numToStr/Comment.nvim',
        opts = {}
    },

    {
        'maxmx03/solarized.nvim',
        lazy = true,
    }
})
