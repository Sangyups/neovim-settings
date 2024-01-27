-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------
keymap.set({ "i", "n", "x", "c", "v" }, "<C-c>", "<Esc>")

-- yank & paste
-- paste without yanking selected
keymap.set("x", "<S-p>", [["_dP]], { desc = "Paste without yanking selected" })
keymap.set({ "n", "x" }, "<S-y>", [["+y]], { desc = "Yank to system clipboard" })

-- navigation enhancement
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

keymap.set("n", "<S-Tab>", "<<", { desc = "Indent left" })
keymap.set("n", "<Tab>", ">>", { desc = "Indent right" })

-- substitute
vim.keymap.set("n", "<leader>saw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
keymap.set("n", "<C-a>", "ggVG", { desc = "Select all text in current buffer" }) -- select all

-- buffer navigation
keymap.set("n", "<leader>bn", "<cmd>bnext<CR>")
keymap.set("n", "<leader>bp", "<cmd>bprev<CR>")
-- delete all buffers but current
vim.cmd([[
  command! -nargs=0 Bda lua vim.api.nvim_command(':%bd | e#')
]])
