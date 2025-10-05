# Profile Loading Order and Dependencies

This directory contains shell configuration files that are loaded automatically by `.bashrc` and `.zshrc`.

## Loading Order

Files are loaded in alphabetical order. The current order is optimal:

1. **aliases** - Basic aliases (no dependencies)
2. **aws** - AWS functions and completions (depends on mise for AWS CLI)
3. **fonts** - Font management functions (minimal dependencies)  
4. **functions** - Utility functions (depends on AWS CLI for some functions)
5. **git** - Git utilities and worktree management (no heavy dependencies)
6. **history** - Shell history configuration (minimal dependencies)
7. **_sysinit** - System initialization (provides mise, completions, heavy tools)

## Dependencies

- **_sysinit** must load last as it provides foundational tools (mise, completions)
- **aws** depends on mise-provided AWS CLI
- **functions** has some AWS dependencies
- All other files are relatively independent

## Performance Notes

- **_sysinit** is the heaviest file (~300ms) due to tool initialization
- Caching is implemented for repeated `eval` calls (fzf, kubectl, starship)
- Background downloads prevent blocking on network operations
- Files load conditionally based on tool availability

## Naming Convention

- Files without prefix load in alphabetical order
- **_sysinit** uses underscore prefix to load last
- Template files end with `.tmpl` in chezmoi source
- Executable files use `executable_` prefix in chezmoi source (currently only fonts)