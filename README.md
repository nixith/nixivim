# bunvim
My personal neovim config, adapted from [kickstart-nix](https://github.com/nix-community/kickstart-nix.nvim)

I like the idea of using more builtins and simple plugins, and of writing much of my own config.


Design choices:
1. Use lzn for everything. I let myself cheat last time and I avoided using it.
2. Prefer folke plugins (mainly snacks) for UI stuff, mini plugins for editing plugins. I don't need nearly as many as I think.
3. use neovim builtins if possible. This means `vim.lsp.config` instead of lsp-config (until it releases with the custom config)

To decide:
1. do I use ftplugin?? There are things I want to load immediately on filetype, but that means it lacks integration into lzn. LZN supports filetype loading, but there are things like setting options that I want to be per filetype.
  1. mix them. use ftplugin for vim commands and use lzn for filetype shenanigans. I like this one actually.
  2. LZN only. Associate keybinds with other things? I don't like this one as much.

IDEA:
~~load in a plugins/langs folder. This gets loaded at init time, lets me register/configure plugins at that time. FTPLUGIN can then call the explicit load call~~
language plugins go in ftplugin. That'll be my call, lzn is extra complication I don't need methinks.


IDEA:
instead of env vars, optionally load a file, then use a maybe style (if nil). Write arbitrary text to this file using nix for my plugin to check.


## other config

- [ ] verbose diagnostic display
- [ ] verbose fold line
## Plugins
### general
- [x] lz.n  TODO: move over to lze, I think I need some specific loading order for blink and markview
- [x] blink.cmp
- [ ] ~~fzf-lua~~ handled by snacks apparently?? It's worked well enough for me. Very responsive, one less plugin
- [x] snacks-nvim
- [x] mini.*
- [x] which-key
- [ ] oil
- [ ] format(conform) --TODO: add language support
- [ ] lint
- [ ] otter
- [ ] lualine
- [x] friendly-snippets
- [ ] dap
- [ ] ~~dap-ui~~ try [debugmaster](https://github.com/miroshQa/debugmaster.nvim), may prove less janky/frustrating
- [ ] neotest
- [ ] sessions

### lang
- [ ] python
- [ ] c
- [ ] rust
- [ ] java
- [ ] fish
- [ ] bash
- [ ] markdown (markview, it has typst support!)
- [ ] typst
- [ ] something for spellcheck?
