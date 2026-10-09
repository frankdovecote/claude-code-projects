# ✻ Claude Code Projects

🇬🇧 [English](README.md) · 🇪🇸 **Español**

Elige un proyecto de Claude Code desde la terminal y ábrelo al momento.

## ✨ Funcionalidad

- **Todos tus proyectos en un menú**, los más recientes primero.
- **Última sesión** de cada proyecto: hoy, ayer o la fecha.
- **Estado de git**: `✔ guardado` si no hay cambios, `▲ 3 sin guardar` con el número de cambios sin hacer commit, o `sin git` si la carpeta no es un repo de git.
- **Carpeta padre** de cada proyecto, para distinguir proyectos con el mismo nombre.
- **Escribe para filtrar** la lista, con un contador de coincidencias (`3/12`).
- **Abrir o retomar**: `Enter` empieza una sesión nueva y `Ctrl-R` retoma la última.
- **Multilingüe**: el idioma se elige solo según tu terminal, y es fácil añadir idiomas nuevos.

## ⚙️ Cómo funciona

1. Lee los proyectos que Claude Code guarda en `~/.claude.json`.
2. Saca la fecha de la última sesión de la fecha de modificación del archivo de sesión más reciente del proyecto en `~/.claude/projects/`.
3. Cuenta los cambios dentro de la carpeta de cada proyecto con `git status --porcelain`.
4. Lo muestra todo en un menú de [fzf](https://github.com/junegunn/fzf).
5. Al elegir un proyecto, entra en su carpeta y ejecuta `claude` (o `claude --continue` con `Ctrl-R`).

> [!NOTE]
> El script solo lee `~/.claude.json` y `~/.claude/projects/`. Nunca los modifica.

## 📋 Requisitos

- macOS o Linux/WSL
- zsh
- [fzf](https://github.com/junegunn/fzf) 0.66.0 o posterior, y [jq](https://jqlang.github.io/jq/)
- [Claude Code](https://claude.com/claude-code) (el comando `claude`)
- git (opcional, solo para el estado de git)

```sh
brew install fzf jq        # macOS
sudo apt install fzf jq    # Debian / Ubuntu
```

> [!WARNING]
> El menú necesita fzf 0.66.0 o posterior, y la versión de apt suele ser más antigua. Comprueba la tuya con `fzf --version`; si es demasiado antigua, instala una más nueva desde las [releases de fzf](https://github.com/junegunn/fzf/releases).

> [!IMPORTANT]
> Necesitas una terminal con colores de 24 bits (truecolor), como iTerm2, Ghostty, WezTerm o Kitty. Si no, los colores se verán mal.

## 📦 Instalación

```sh
curl -fsSL https://raw.githubusercontent.com/frankdovecote/claude-code-projects/main/install.sh | sh
```

Instala `claude-code-projects` en `~/.local/bin`, y te avisa si falta algún requisito o si esa carpeta no está en tu `PATH`.

Para usar otra carpeta, pon `INSTALL_DIR` justo antes de `sh` (no antes de `curl`):

```sh
curl -fsSL https://raw.githubusercontent.com/frankdovecote/claude-code-projects/main/install.sh | INSTALL_DIR=$HOME/bin sh
```

O clona el repo y enlaza el script, para que `git pull` lo actualice:

```sh
git clone https://github.com/frankdovecote/claude-code-projects.git
mkdir -p ~/.local/bin
ln -s "$PWD/claude-code-projects/claude-code-projects.sh" ~/.local/bin/claude-code-projects
```

Para desinstalar, borra el archivo (usa la carpeta donde lo instalaste):

```sh
rm ~/.local/bin/claude-code-projects
```

## 🚀 Uso

```sh
claude-code-projects
```

> [!NOTE]
> ¿Lo ejecutas desde un repo clonado sin instalarlo? Usa `./claude-code-projects.sh`.

| Tecla                     | Acción                                         |
| ------------------------- | ---------------------------------------------- |
| `Enter`                   | Abrir el proyecto                              |
| `Ctrl-R`                  | Retomar la última sesión (`claude --continue`) |
| `↑` `↓` / `RePág` `AvPág` | Moverse por la lista                           |
| `Esc`                     | Salir                                          |

> [!TIP]
> Para un nombre más corto, añade un alias a tu `~/.zshrc`:
>
> ```sh
> alias ccp="claude-code-projects"
> ```
>
> `claude-code-projects --version` muestra la versión instalada.

### 🌍 Idioma

El script usa el idioma de la terminal, o el del sistema en macOS. Si ese idioma no está disponible, sale en inglés. Para elegirlo tú:

```sh
CLAUDE_CODE_PROJECTS_LANG=en claude-code-projects
```

Desde un repo clonado sin instalarlo, usa `CLAUDE_CODE_PROJECTS_LANG=en ./claude-code-projects.sh`.

Para añadir un idioma, copia la tabla `i18n_en` del script, cámbiale el nombre por el código de dos letras (por ejemplo `i18n_fr`) y traduce los textos. Los textos que no traduzcas salen en inglés.

## 📄 Licencia

[MIT](LICENSE) © 2026 Frank Dovecote
