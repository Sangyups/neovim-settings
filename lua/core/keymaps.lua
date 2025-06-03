-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness
local opts = { silent = true }

---------------------
-- General Keymaps -------------------
keymap.set({ "i", "n", "x", "c", "v" }, "<C-c>", "<Esc>")
keymap.set({ "i", "n", "x", "c", "v" }, "<C-ㅊ>", "<Esc>")
vim.cmd([[command! W w]])
vim.cmd([[command! Q q]])
vim.cmd([[command! Qa qa]])
vim.cmd([[command! Wq wq]])
vim.cmd([[command! Wqa wqa]])

-- yank & paste
-- paste without yanking selected
keymap.set("x", "<S-p>", [["_dP]], { desc = "Paste without yanking selected" })
keymap.set({ "n", "x" }, "<S-y>", [["+y]], { desc = "Yank to system clipboard" })
keymap.set("n", "<S-y><S-y>", ":%y+<CR>", { desc = "Yank all in current buffer to system clipboard" })

-- navigation enhancement
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzz")
keymap.set("n", "N", "Nzz")

keymap.set({ "x" }, "il", "g_o^o", { noremap = true, silent = true })
keymap.set({ "o" }, "il", ":normal vil<CR>", { noremap = true, silent = true })
keymap.set("o", "_", "^", { noremap = true })

keymap.set("v", "∆", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "˚", ":m '<-2<CR>gv=gv", opts)
keymap.set("n", "∆", ":m +1<CR>==", opts)
keymap.set("n", "˚", ":m -2<CR>==", opts)

keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- substitute
keymap.set(
    "n",
    "<leader>siwa",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Substitute word in a buffer" }
)
keymap.set(
    "n",
    "<leader>siwl",
    [[:s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Substitute word in a line" }
)

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
keymap.set("n", "<leader>bp", "<cmd>bprev<CR>")
keymap.set("n", "<leader>bn", "<cmd>bnext<CR>")
keymap.set("n", "˙", "<cmd>bprev<CR>")
keymap.set("n", "¬", "<cmd>bnext<CR>")

-- delete all buffers but current
vim.cmd([[
  command! -nargs=0 Bda lua vim.api.nvim_command(':%bd | e# | bd#')
]])
