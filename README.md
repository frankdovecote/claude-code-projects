# ✻ Claude Code Projects

🇬🇧 **English** · 🇪🇸 [Español](README.es.md)

Pick a Claude Code project from your terminal and open it right away.

## ✨ Features

- **All your projects in one menu**, most recent first.
- **Last session** of each project: today, yesterday or the date.
- **Git status**: `✔ saved` if there are no changes, `▲ 3 unsaved` with the number of uncommitted changes, or `no git` if the folder is not a git repo.
- **Parent folder** of each project, so projects with the same name are easy to tell apart.
- **Type to filter** the list, with a counter of matches (`3/12`).
- **Open or resume**: `Enter` starts a new session, `Ctrl-R` resumes the last one.
- **Multilingual**: the language is picked automatically from your terminal, and new languages are easy to add.

## ⚙️ How it works

1. Reads the projects that Claude Code saves in `~/.claude.json`.
2. Gets the date of the last session from the modification date of the project's most recent session file in `~/.claude/projects/`.
3. Counts the changes inside each project's folder with `git status --porcelain`.
4. Shows everything in an [fzf](https://github.com/junegunn/fzf) menu.
5. When you pick a project, it goes into that folder and runs `claude` (or `claude --continue` with `Ctrl-R`).

> [!NOTE]
> The script only reads `~/.claude.json` and `~/.claude/projects/`. It never changes them.

## 📋 Requirements

- macOS or Linux/WSL
- zsh
- [fzf](https://github.com/junegunn/fzf) 0.66.0 or newer, and [jq](https://jqlang.github.io/jq/)
- [Claude Code](https://claude.com/claude-code) (the `claude` command)
- git (optional, only used for the git status)

```sh
brew install fzf jq        # macOS
sudo apt install fzf jq    # Debian / Ubuntu
```

> [!WARNING]
> The menu needs fzf 0.66.0 or newer, and the version in apt is often older. Check yours with `fzf --version`; if it is too old, install a newer one from the [fzf releases](https://github.com/junegunn/fzf/releases).

> [!IMPORTANT]
> You need a terminal with 24-bit color (truecolor), such as iTerm2, Ghostty, WezTerm or Kitty. Otherwise the colors will look wrong.

## 📦 Installation

```sh
curl -fsSL https://raw.githubusercontent.com/frankdovecote/claude-code-projects/main/install.sh | sh
```

It installs `claude-code-projects` in `~/.local/bin`, and warns you if a requirement is missing or if that folder is not in your `PATH`.

To use another folder, set `INSTALL_DIR` right before `sh` (not before `curl`):

```sh
curl -fsSL https://raw.githubusercontent.com/frankdovecote/claude-code-projects/main/install.sh | INSTALL_DIR=$HOME/bin sh
```

Or clone the repo and link the script, so `git pull` updates it:

```sh
git clone https://github.com/frankdovecote/claude-code-projects.git
mkdir -p ~/.local/bin
ln -s "$PWD/claude-code-projects/claude-code-projects.sh" ~/.local/bin/claude-code-projects
```

To uninstall, delete the file (use the folder you installed it in):

```sh
rm ~/.local/bin/claude-code-projects
```

## 🚀 Usage

```sh
claude-code-projects
```

> [!NOTE]
> Running it from a cloned repo without installing it? Use `./claude-code-projects.sh` instead.

| Key                     | Action                                        |
| ----------------------- | --------------------------------------------- |
| `Enter`                 | Open the project                              |
| `Ctrl-R`                | Resume the last session (`claude --continue`) |
| `↑` `↓` / `PgUp` `PgDn` | Move through the list                         |
| `Esc`                   | Quit                                          |

> [!TIP]
> For a shorter name, add an alias to your `~/.zshrc`:
>
> ```sh
> alias ccp="claude-code-projects"
> ```
>
> `claude-code-projects --version` shows the installed version.

### 🌍 Language

The script uses your terminal's language, or the system language on macOS. If that language isn't available, it uses English. To pick one yourself:

```sh
CLAUDE_CODE_PROJECTS_LANG=es claude-code-projects
```

From a cloned repo without installing, use `CLAUDE_CODE_PROJECTS_LANG=es ./claude-code-projects.sh`.

To add a language, copy the `i18n_en` table in the script, rename it with the two-letter code (for example `i18n_fr`) and translate the texts. Any text you leave out is shown in English.

## 📄 License

[MIT](LICENSE) © 2026 Frank Dovecote
