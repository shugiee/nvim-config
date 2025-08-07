local function set_theme(mode)
    if mode == "dark" then
        vim.o.background = "dark"
        vim.cmd("colorscheme catppuccin-mocha") -- replace with your dark theme
    else
        vim.o.background = "light"
        vim.cmd("colorscheme catppuccin-latte") -- replace with your light theme
    end
end

local function detect_os_theme()
    local uname = vim.loop.os_uname().sysname

    if uname == "Darwin" then
        -- macOS
        local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
        if handle then
            local result = handle:read("*a")
            handle:close()
            return result:match("Dark") and "dark" or "light"
        end
    elseif uname == "Linux" then
        -- Linux (GTK-based, e.g. GNOME, Cinnamon)
        local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null")
        if handle then
            local result = handle:read("*a")
            handle:close()
            return result:match("dark") and "dark" or "light"
        end

        -- Fallback: try GTK theme string
        handle = io.popen("gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null")
        if handle then
            local result = handle:read("*a")
            handle:close()
            return result:lower():match("dark") and "dark" or "light"
        end
    end

    -- Default fallback
    return "dark"
end

set_theme(detect_os_theme())

-- Old Color Schemes
-- vim.cmd.colorscheme('nordic')
-- vim.cmd.colorscheme('catppuccin')
-- vim.cmd.colorscheme('catppuccin-mocha')
-- vim.cmd.colorscheme('nord')
