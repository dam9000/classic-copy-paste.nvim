# Classic Copy & Paste for Neovim

Get the classic copy & paste key bindings working as expected in Neovim
in all modes (normal, insert, visual, command). This covers the following
key combinations:

- Ctrl-Del          = Delete (without copying to clipboard)
- Shift-Del         = Cut
- Ctrl-Insert       = Copy
- Shift-Insert      = Paste
- Mouse selection   = Copy to X11 primary selection

While the above work fine in neovim gui frontends, in terminal mode the
ctrl-insert and shift-insert usually can't be intercepted.
So these additional key bindings are also defined:

- Alt-C             = Copy
- Alt-V             = Paste

This can be disabled with setup() option: `{ alt_cv = false }`

## Installation

Install the plugin with your preferred package manager, or copy & paste
the relevant keymaps from [classic-copy-paste.lua](lua/classic-copy-paste.lua) to your own `init.lua`

Example for [lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager:

```lua
{ 'dam9000/classic-copy-paste.nvim', },
```

Example with disabled alt-c, alt-v:

```lua
{ 'dam9000/classic-copy-paste.nvim', opts = { alt_cv = false } },
```

