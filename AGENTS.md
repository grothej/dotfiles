# AGENTS.md

This file provides guidance to agents when working with code in this repository.

## Overview

Personal dotfiles repository managed with [GNU Stow](https://www.gnu.org/software/stow/) (>= v2.4.0). Each top-level directory is a stow "package" (bashrc, ghostty, git, k9s, nvim, opencode, tmux, yamlfmt, yamllint, zsh).

## Neovim Config Architecture

The nvim package (`nvim/dot-config/nvim/`) is the most complex config:

- **init.lua**: Sets leader to space, loads core modules, bootstraps lazy.nvim plugin manager
- **lua/options.lua, keymaps.lua, autocommands.lua**: Core vim settings loaded before plugins
- **lua/plugins/**: Plugin specs auto-imported by lazy.nvim via `{ import = 'plugins' }`
- **lua/plugins/lsp/**: LSP configs split per language (java.lua, lua.lua, yaml.lua) with shared setup in init.lua
- **ftplugin/**: Filetype-specific overrides (java.lua, yaml.lua)

Plugin manager is **lazy.nvim** with lock file at `lazy-lock.json`.

## Conventions

- Files that should become dotfiles use the `dot-` prefix (e.g., `dot-zshrc` becomes `.zshrc`, `dot-config` becomes `.config`)
- Each package mirrors the home directory structure it targets
