# Keyboard & Workflow Analysis

## Executive Summary

**Keyboard verdict**: Keep using your regular keyboard. The Corne/Miryoku setup was causing cognitive overload for valid reasons.

**Nvim setup**: Complete! Ready to use with all your dev stack integrated.

**Next steps**: Start with simple nvim tasks, gradually increase usage as muscle memory builds.

---

## Corne Keyboard Analysis

### Your Miryoku Setup

**Layers (8 total):**
- **Base**: QWERTY with home row mods (A=GUI, S=Alt, D=Ctrl, F=Shift)
- **Nav**: Arrow keys, Home/End, Page Up/Down
- **Mouse**: Mouse emulation (redundant with real mouse)
- **Media**: Volume, playback, RGB, Bluetooth
- **Num**: Number pad layout
- **Sym**: Symbols ({}, [], (), etc.)
- **Fun**: Function keys (F1-F12)
- **Button**: Copy/Paste/Undo shortcuts

### Why It Caused Cognitive Load

**1. Home Row Mods Precision**
- Tap vs hold timing requires brain cycles
- TypeScript/Python work involves frequent typing pauses (thinking)
- Brain can't predict "will this be a tap or hold?"
- Leads to accidental modifiers or missed modifiers

**2. Symbol Layer Switching Hell**
- TypeScript: `{}, [], (), =>, ===, ?.` - all on layers
- Python: `def foo():` - colon on layer
- FastAPI: `@app.get("/api")` - symbols everywhere
- Every symbol = context switch = cognitive overhead

**3. Vim Motions vs VS Code Shortcuts**
- Corne optimized for vim (hjkl on base, minimal symbols)
- VS Code uses Cmd+shortcuts (Cmd+P, Cmd+Shift+P, etc.)
- Your VS Code keybindings: Cmd+E, Cmd+T, Cmd+K chains
- Corne home row mods conflict with these

**4. Layer Mental Model**
- 8 layers to remember
- "Where's @? Oh, Sym layer. Hold thumb, press key."
- "Wait, was that Num or Sym for `=`?"
- Mental stack overflow

### Why Regular Keyboard Works Better

**For VS Code users:**
- ✅ Direct access to all symbols (no layers)
- ✅ Cmd key is physical key (not home row mod)
- ✅ Muscle memory from years of typing
- ✅ Zero timing precision needed
- ✅ Brain focuses on code, not keyboard

**The trade-off:**
- Regular keyboard: Larger, hands move more
- Corne: Compact, hands stay in place
- **But**: Hand movement costs < cognitive load costs

### When Corne Works

Corne shines for:
- **Vim power users**: hjkl is life, symbols less frequent
- **Prose writers**: Letters/punctuation, minimal modifiers
- **After months of practice**: Muscle memory handles layers

You're not a vim user yet. You're a VS Code user learning vim.

---

## Current Workflow Analysis

### Tools & Stack

**Editor**: VS Code (primary)
- Heavy Copilot usage
- TypeScript/JavaScript focus
- Python FastAPI development
- Cmd-based keybindings

**Databases**: PostgreSQL, MongoDB, Redis
- No unified interface currently
- Separate GUI tools likely

**Terminal**: Alacritty + Tmux (primary) + Zellij (trial)
- Consistent Alt-based navigation
- Session management with sesh
- Monokai Pro theme everywhere

**Version Control**: Git + Lazygit
- Extensive git aliases
- Lazygit for visual operations

### Strengths

✅ **Cohesive aesthetics**: Monokai Pro everywhere
✅ **Modern tooling**: Starship, zoxide, eza, fzf, ripgrep
✅ **Session management**: Tmux + sesh works great
✅ **Git workflow**: Lazygit + aliases = efficient
✅ **Profile system**: Home/garda separation working well

### Gaps (Now Addressed)

❌ **No nvim config** → ✅ **Now have kickstart.nvim setup**
❌ **No unified DB tool** → ✅ **Now have vim-dadbod**
❌ **VS Code dependency** → ✅ **Nvim as alternative ready**

---

## Nvim Migration Strategy

### Phase 1: Foundation (Weeks 1-2)

**Goal**: Learn vim motions without pressure

```bash
# Daily practice
vimtutor              # 20 min/day

# Start with these files in nvim:
- Config files (.zshrc, .tmux.conf)
- Markdown (README.md, notes)
- Simple scripts (bash, python)
```

**Why these files:**
- Low stakes (no deadlines)
- Frequent edits (practice opportunity)
- Simple structure (easy navigation)

**Key motions to master:**
- `hjkl` - Navigation
- `i, a, o, O` - Insert mode
- `dd, yy, p` - Delete, yank, paste
- `w, b, e` - Word movement
- `0, $` - Line start/end
- `gg, G` - File start/end
- `/search` + `n` - Search
- `:w :q :wq` - Save/quit

### Phase 2: Real Work (Weeks 3-4)

**Goal**: Use nvim for actual dev work

```bash
# FastAPI route editing
v app/routes/users.py

# TypeScript functions
v src/utils/helpers.ts

# Git commits (already using nvim via git config)
git commit
```

**VS Code still for:**
- Large refactors (rename across files)
- Debugging (breakpoints, watches)
- Complex find/replace across project
- When you're stuck and need to ship fast

### Phase 3: Mastery (Month 2+)

**Goal**: Nvim as primary, VS Code as backup

**Advanced patterns:**
- Telescope fuzzy finding (`<leader>sf`, `<leader>sg`)
- LSP navigation (`grd`, `grr`, `grn`)
- Multi-cursor with visual block (`<C-v>`)
- Macros (`qa` record, `@a` replay)
- Text objects (`ci"`, `da(`, `viw`)

**Copilot integration:**
- Tab to accept (matches VS Code)
- `:Copilot disable` when learning motions
- `:Copilot enable` when productive coding

### Phase 4: Database Work

**vim-dadbod usage:**

```vim
# Open database UI
<leader>db

# Add connections (in nvim config or runtime)
:let g:db_postgres = 'postgresql://user:pass@localhost:5432/db'
:let g:db_mongo = 'mongodb://localhost:27017/db'
```

**Workflow:**
1. Open DBUI with `<leader>db`
2. Select connection
3. Write SQL query
4. Execute and see results
5. No more switching to separate DB GUI

---

## Tmux + Nvim Workflow

### Seamless Navigation

Already configured in both tmux and nvim:

```bash
<C-h>  # Move left (works across tmux panes and nvim windows)
<C-j>  # Move down
<C-k>  # Move up
<C-l>  # Move right
```

**Example session:**

```bash
# Window 1: Development
+-------------------+-------------------+
|                   |                   |
|  nvim app.py      |  npm run dev      |
|  (TypeScript LSP) |  (dev server)     |
|                   |                   |
+-------------------+-------------------+
|                   |
|  lazygit          |
|                   |
+-------------------+

# Window 2: Database
+-------------------+-------------------+
|                   |                   |
|  nvim (DBUI)      |  mongodb shell    |
|  PostgreSQL query |                   |
|                   |                   |
+-------------------+-------------------+

# Navigate with:
Alt+1        # Switch to window 1
Alt+2        # Switch to window 2
<C-h/j/k/l>  # Navigate panes/windows
```

### Session Management

```bash
# Create project session
ss              # sesh: select from sessions/zoxide dirs
sc              # sesh: connect to session named after pwd

# Within session
Alt+t           # New tmux window
Alt+n/p         # Next/previous window
Alt+s           # Session switcher
```

---

## Optimizations Applied

### 1. Nvim Configuration ✅

**What was added:**
- kickstart.nvim base (well-documented, beginner-friendly)
- Monokai Pro theme (Spectrum filter)
- LSPs: TypeScript, Python, Docker, YAML, JSON, HTML, CSS, Bash, Lua
- Formatters: prettier, black, isort, stylua
- GitHub Copilot (Tab to accept, matches VS Code)
- vim-dadbod + DBUI (PostgreSQL, MongoDB, Redis)
- vim-tmux-navigator (seamless pane switching)
- Telescope fuzzy finding
- Treesitter syntax highlighting
- Auto-completion with blink.cmp

**File location:**
- `~/.config/nvim/init.lua` (via chezmoi: `dot_config/nvim/init.lua`)
- `~/.config/nvim/README.md` (comprehensive guide)

### 2. Chezmoi Integration ✅

**What was added:**
- `run_once_before_install-nvim-dependencies.sh.tmpl`
  - Checks nvim version (needs 0.10+)
  - Verifies Node.js (for LSPs & Copilot)
  - Validates Python (for pyright)
  - Provides setup instructions

**On chezmoi apply:**
1. Script runs, checks dependencies
2. Nvim config deployed to `~/.config/nvim/`
3. First nvim launch auto-installs everything

### 3. Tool Coherence ✅

**Theme consistency:**
- ✅ Tmux: Monokai Pro Spectrum
- ✅ Zellij: Monokai Pro Spectrum
- ✅ Alacritty: (inherits from terminal)
- ✅ VS Code: Monokai Pro Spectrum
- ✅ Nvim: Monokai Pro Spectrum (new!)

**Font consistency:**
- ✅ Everywhere: JetBrainsMono Nerd Font

**Navigation patterns:**
- ✅ Tmux: Alt+hjkl, Alt+1-9, Alt+t/n/p
- ✅ Zellij: Alt+hjkl, Alt+1-9, Alt+t/n/p
- ✅ Nvim: <C-hjkl> (vim convention, doesn't conflict)

---

## Keyboard Recommendations

### Option 1: Keep Regular Keyboard (Recommended)

**Why:**
- Zero friction, works today
- Optimized for VS Code workflow
- No learning curve
- Save cognitive load for learning nvim

**When to reconsider Corne:**
- After 3+ months of daily nvim use
- When vim motions are muscle memory
- When you rarely need symbols (unlikely for dev)
- If you want ergonomics > productivity temporarily

### Option 2: Simplified Corne Config (Future)

If you want to retry Corne after mastering vim:

**Simplifications:**
1. **Remove home row mods** - Use dedicated modifier keys on thumbs
2. **Reduce to 3 layers** - Base, Symbol, Nav (no mouse, no media)
3. **Optimize for vim** - hjkl on base, common symbols on base
4. **Accept hand movement** - Not everything needs to be on layers

**Example simplified layout:**

```
Base Layer (Vim-optimized):
q  w  e  r  t        y  u  i  o  p
a  s  d  f  g        h  j  k  l  ;
z  x  c  v  b        n  m  ,  .  /
  ESC SPC TAB      RET BSP DEL

Thumbs:
Left: Esc, Space (Nav layer), Tab (Sym layer)
Right: Enter, Backspace, Delete

Sym Layer (Common symbols on home row):
!  @  #  $  %        ^  &  *  (  )
{  }  [  ]  =        -  _  +  |  \
~  `  <  >  ?        :  "  '  /  \
```

But honestly? Regular keyboard + nvim is the pragmatic choice.

---

## Next Actions

### Immediate (This Week)

1. ✅ Nvim config deployed (done!)
2. **Open nvim**: `nvim ~/.config/nvim/README.md`
3. **Run Tutor**: `:Tutor` (20 minutes)
4. **Auth Copilot**: `:Copilot setup`
5. **Check health**: `:checkhealth`

### Short-term (Next 2 Weeks)

- [ ] Edit 1 config file/day in nvim (low stakes practice)
- [ ] Run vimtutor 3x (muscle memory)
- [ ] Try nvim for git commits (already configured)
- [ ] Edit one FastAPI route in nvim
- [ ] Edit one TypeScript function in nvim

### Medium-term (Month 1-2)

- [ ] Use nvim for 50% of coding (simple tasks)
- [ ] Set up database connections in vim-dadbod
- [ ] Create custom keybindings (`:help vim.keymap.set()`)
- [ ] Add project-specific LSP settings if needed
- [ ] Decide: Keep tmux or switch to Zellij

### Long-term (Month 3+)

- [ ] Nvim as primary editor (80%+ of work)
- [ ] VS Code for complex refactors only
- [ ] Consider advanced plugins (harpoon, oil.nvim, etc.)
- [ ] Optional: Retry Corne with simplified config

---

## Success Metrics

**Week 1**: Can edit config files in nvim without frustration
**Week 2**: Can write simple function in nvim comfortably
**Week 4**: Can navigate codebase with Telescope + LSP
**Week 8**: Prefer nvim for focused coding work
**Week 12**: Only use VS Code for specific tasks (refactors, debugging)

---

## Resources

### Nvim Learning

- **Built-in**: `:Tutor` (best starting point)
- **Command line**: `vimtutor` (30 min interactive tutorial)
- **Video**: "Mastering the Vim Language" by Chris Toomey
- **Book**: "Practical Vim" by Drew Neil
- **Cheatsheet**: https://vim.rtorr.com/

### Kickstart.nvim

- **GitHub**: https://github.com/nvim-lua/kickstart.nvim
- **Video walkthrough**: TJ DeVries on YouTube
- **Your config**: `~/.config/nvim/init.lua` (read every line!)

### LSP & Plugins

- **LSP config**: `:help lspconfig`
- **Telescope**: `:help telescope.nvim`
- **Treesitter**: `:help nvim-treesitter`
- **lazy.nvim**: `:help lazy.nvim`

### Community

- **Reddit**: r/neovim
- **Discord**: Neovim Discord server
- **GitHub Discussions**: neovim/neovim discussions

---

## Final Thoughts

**On the Corne keyboard:**
- Not a failure - it's just the wrong tool for your current workflow
- You're a VS Code user transitioning to vim, not a vim power user
- Cognitive load matters more than hand movement
- Regular keyboard is the pragmatic choice

**On the nvim transition:**
- Start small, build gradually
- You have 3+ years of VS Code muscle memory to overcome
- That's okay! Parallel usage is fine
- Nvim isn't better, it's different (and potentially faster long-term)

**On your workflow:**
- Already well-optimized (tmux, zellij, tools, theme consistency)
- Nvim fills the missing piece (terminal-native editor)
- You now have a complete terminal-first development environment

**You're ready to start!** 🚀

```bash
nvim ~/.config/nvim/README.md
```
