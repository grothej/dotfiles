# dotfiles
Repository for personal dotfiles

### requirements:
- gnu-stow (> v2.4.0)

These configs are maintained and applied with stow. All configurations are maintained in packages, which  
are defined in the root-dir. To create a sym link to the corresponding target directory of a package use:
```bash
stow [package]

# To create a symlink for tmux
stow tmux
```
The default cli-options are defined in the [.stowrc file](./.stowrc).

