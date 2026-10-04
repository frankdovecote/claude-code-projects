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
3. Cuenta los cambios de cada proyecto con `git status --porcelain`.
4. Lo muestra todo en un menú de [fzf](https://github.com/junegunn/fzf).
5. Al elegir un proyecto, entra en su carpeta y ejecuta `claude` (o `claude --continue` con `Ctrl-R`).

> [!NOTE]
> El script solo lee `~/.claude.json` y `~/.claude/projects/`. Nunca los modifica.

## 📋 Requisitos

- macOS o Linux/WSL
- zsh
- [fzf](https://github.com/junegunn/fzf) y [jq](https://jqlang.github.io/jq/)
- [Claude Code](https://claude.com/claude-code) (el comando `claude`)
- git (opcional, solo para el estado de git)

```sh
brew install fzf jq
```

> [!IMPORTANT]
> Necesitas una terminal con colores de 24 bits (truecolor), como iTerm2, Ghostty, WezTerm o Kitty. Si no, los colores se verán mal.

## 🚀 Uso

```sh
./claude-code-projects.sh
```

| Tecla                     | Acción                                         |
| ------------------------- | ---------------------------------------------- |
| `Enter`                   | Abrir el proyecto                              |
| `Ctrl-R`                  | Retomar la última sesión (`claude --continue`) |
| `↑` `↓` / `RePág` `AvPág` | Moverse por la lista                           |
| `Esc`                     | Salir                                          |

> [!TIP]
> Para lanzarlo desde cualquier sitio, añade un alias a tu `~/.zshrc`:
>
> ```sh
> alias ccp="/ruta/a/claude-code-projects.sh"
> ```

### 🌍 Idioma

El script usa el idioma de la terminal, o el del sistema en macOS. Si ese idioma no está disponible, sale en inglés. Para elegirlo tú:

```sh
CLAUDE_CODE_PROJECTS_LANG=en ./claude-code-projects.sh
```

Para añadir un idioma, copia la tabla `i18n_en` del script, cámbiale el nombre por el código de dos letras (por ejemplo `i18n_fr`) y traduce los textos. Los textos que no traduzcas salen en inglés.

## 📄 Licencia

[MIT](LICENSE) © 2026 Frank Dovecote
