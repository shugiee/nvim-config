local M = {}

-- Cache output per buffer
local buf_info = {}

-- Run your CLI when a buffer is opened
function M.on_buf_open(bufnr)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    -- Break if we've cached this buffer's AOR info
    if buf_info[bufnr] then
        return
    end
    vim.system({ "git", "aors", filename }, {}, function(obj)
        vim.schedule(function()
            if obj.code == 0 then
                local aor_name, aor_owner, aor_url = M.parse_aor_info(obj)
                -- Default each to an empty string, if it doesn't exist
                aor_name = aor_name or ""
                aor_owner = aor_owner or ""
                aor_url = aor_url or ""

                -- Show both AOR name and URL
                buf_info[bufnr] = "AOR: " .. aor_name .. " Owner: " .. aor_owner

                -- Store the URL as a global variable
                vim.g.aor_url = aor_url

                -- Force statusline redraw
                vim.api.nvim_command("redrawstatus")
            else
                buf_info[bufnr] = "[CLI Error]"
            end
        end)
    end)
end

-- Parse the AOR name and URL from the output
function M.parse_aor_info(obj)
    local lines = vim.split(obj.stdout, "\n", { plain = true, trimempty = true })
    local last_line = lines[#lines]
    local second_to_last_line = lines[#lines - 1]

    local name, owner = string.match(second_to_last_line, "AOR: (.*) %((.*)%)")
    local url = string.match(last_line, "(https://app.asana.com/[%w/]+)")

    return name, owner, url
end

-- Add info to statusline
function M.statusline_component()
    local bufnr = vim.api.nvim_get_current_buf()
    return buf_info[bufnr] and ("  " .. buf_info[bufnr]) or ""
end

-- Open the AOR URL in the browser
function M.open_aor_url()
    local aor_url = vim.g.aor_url
    if aor_url then
        vim.fn.system({ "open", aor_url })
    else
        print("No AOR URL found.")
    end
end

-- Use <leader>aor to open the AOR URL
vim.keymap.set("n", "<leader>aor", function()
    M.open_aor_url()
end, { desc = "Open AOR URL" })


return M
