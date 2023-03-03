local recently_closed_buffers = {}

-- Open the most recently closed buffer.
local function open_recently_closed_buffer()
	local last_buf = recently_closed_buffers[#recently_closed_buffers]
	if last_buf ~= nil and vim.api.nvim_buf_is_valid(last_buf) then
		vim.api.nvim_set_current_buf(last_buf)
		table.remove(recently_closed_buffers, #recently_closed_buffers)
	end
end

-- Save a buffer to the recently closed list when it's deleted.
local function close_buffer_with_save(bufnr)
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_option(bufnr, "buftype") ~= "nofile" and
		vim.api.nvim_buf_get_option(bufnr, "modifiable") then
		if vim.api.nvim_buf_get_option(bufnr, "modified") then
			vim.api.nvim_command("w")
		end
		table.insert(recently_closed_buffers, bufnr)
	end
end

-- Define the plugin commands and autocommands.
vim.cmd([[
  command! RecentlyClosedBuffer lua open_recently_closed_buffer()
  augroup RecentlyClosedBuffers
    autocmd!
    autocmd BufDelete * lua close_buffer_with_save(vim.fn.bufnr())
  augroup END
]])
