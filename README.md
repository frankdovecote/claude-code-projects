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
3. Counts the changes in each project with `git status --porcelain`.
4. Shows everything in an [fzf](https://github.com/junegunn/fzf) menu.
5. When you pick a project, it goes into that folder and runs `claude` (or `claude --continue` with `Ctrl-R`).

> [!NOTE]
> The script only reads `~/.claude.json` and `~/.claude/projects/`. It never changes them.

## 📋 Requirements

- macOS or Linux/WSL
- zsh
- [fzf](https://github.com/junegunn/fzf) and [jq](https://jqlang.github.io/jq/)
- [Claude Code](https://claude.com/claude-code) (the `claude` command)
- git (optional, only used for the git status)

```sh
brew install fzf jq
```

> [!IMPORTANT]
> You need a terminal with 24-bit color (truecolor), such as iTerm2, Ghostty, WezTerm or Kitty. Otherwise the colors will look wrong.

## 🚀 Usage

```sh
./claude-code-projects.sh
```

| Key                     | Action                                        |
| ----------------------- | --------------------------------------------- |
| `Enter`                 | Open the project                              |
| `Ctrl-R`                | Resume the last session (`claude --continue`) |
| `↑` `↓` / `PgUp` `PgDn` | Move through the list                         |
| `Esc`                   | Quit                                          |

> [!TIP]
> To run it from anywhere, add an alias to your `~/.zshrc`:
>
> ```sh
> alias ccp="/path/to/claude-code-projects.sh"
> ```

### 🌍 Language

The script uses your terminal's language, or the system language on macOS. If that language isn't available, it uses English. To pick one yourself:

```sh
CLAUDE_CODE_PROJECTS_LANG=es ./claude-code-projects.sh
```

To add a language, copy the `i18n_en` table in the script, rename it with the two-letter code (for example `i18n_fr`) and translate the texts. Any text you leave out is shown in English.

## 📄 License

[MIT](LICENSE) © 2026 Frank Dovecote
