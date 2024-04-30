local api = vim.api

local function copyWithLineNum(config)
    -- Get start and end lines of visual selection
    local line1 = vim.fn.line('v')
    local line2 = vim.fn.line('.')
    local start_line = math.min(line1, line2)
    local end_line = math.max(line1, line2)

    -- Initialize text to copy
    local lines = {}

    -- Determine the width needed for line numbers
    local max_line_number = end_line
    local line_number_width = #tostring(max_line_number)

    -- Get separator from config or use default value
    local separator = config and config.separator or ':'

    -- Get the filetype of the buffer
    local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

    -- Determine the language identifier for Markdown code block
    local language_identifier = filetype and string.format('```%s', filetype) or '```'

    -- Get text with line numbers
    for i = start_line, end_line do
        -- Get the line from buffer
        local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
        -- Check if line is nil
        if line then
            -- Replace tabs with spaces according to &tabstop
            local tabstop = vim.api.nvim_get_option("tabstop")
            line = line:gsub("\t", string.rep(" ", tabstop))
            -- Format the line number with proper padding
            local padded_line_number = string.format('%' .. line_number_width .. 'd', i)
            if config and config.markdown_format then
                -- Format as Markdown code block
                line = string.format('%s%s%s', padded_line_number, separator, line)
            else
                line = string.format('%s%s%s %s', padded_line_number, separator, ' ', line)
            end
            table.insert(lines, line)
	end
    end

    -- Combine lines with newline character
    local text = table.concat(lines, '\n')

    -- Add Markdown code block formatting
    text = string.format('%s\n%s\n```', language_identifier, text)

    -- Copy to clipboard
    vim.fn.setreg('*', text)

    -- Unset visual mode
    api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, false, true), 'n', true)
end

return {
    copyWithLineNum = copyWithLineNum
}
