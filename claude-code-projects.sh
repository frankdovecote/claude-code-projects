#!/usr/bin/env zsh

version="1.1.0"

# [EN] --version / -v: print the version and exit
# [ES] --version / -v: muestra la versión y sale
if [[ "$1" == (--version|-v) ]]; then
  echo "claude-code-projects $version"
  exit 0
fi

# [EN] One table per language (i18n_xx), looked up by the two-letter code; missing texts fall back to English.
#      {app} is replaced with "Claude Code", {n} with the number of changes, {cmd} with the install command,
#      {v} with the installed fzf version and {min} with the minimum one.
# [ES] Una tabla por idioma (i18n_xx), buscada por el código de dos letras; los textos que falten salen en inglés.
#      {app} se cambia por "Claude Code", {n} por el número de cambios, {cmd} por el comando de instalación,
#      {v} por la versión de fzf instalada y {min} por la mínima.
typeset -A i18n_en=(
  missing_deps    "Missing dependencies. Install: {cmd}"
  missing_claude  "Claude Code not found (command: claude)"
  old_fzf         "fzf {v} is too old, version {min} or newer is needed"
  no_config       "~/.claude.json not found"
  no_projects     "No saved Claude Code projects"
  title           "{app} Projects"
  open            "open"
  resume          "resume last session"
  quit            "quit"
  today           "today"
  yesterday       "yesterday"
  date_format     "%Y-%m-%d %H:%M"
  no_sessions     "no sessions"
  unsaved         "{n} unsaved"
  saved           "saved"
  no_git          "no git"
  goodbye         "See you soon!"
)

typeset -A i18n_es=(
  missing_deps    "Faltan dependencias. Instala: {cmd}"
  missing_claude  "No se encontró Claude Code (comando: claude)"
  old_fzf         "fzf {v} es demasiado antiguo, hace falta la versión {min} o posterior"
  no_config       "No se encontró ~/.claude.json"
  no_projects     "No hay proyectos guardados en Claude Code"
  title           "Proyectos {app}"
  open            "abrir"
  resume          "retomar última sesión"
  quit            "salir"
  today           "hoy"
  yesterday       "ayer"
  date_format     "%d/%m/%Y %H:%M"
  no_sessions     "sin sesiones"
  unsaved         "{n} sin guardar"
  saved           "guardado"
  no_git          "sin git"
  goodbye         "¡Hasta pronto!"
)

# [EN] Language: CLAUDE_CODE_PROJECTS_LANG (to force it), else the terminal's, and on macOS the system's
# [ES] Idioma: CLAUDE_CODE_PROJECTS_LANG (para forzarlo), si no el de la terminal, y en macOS el del sistema
lang=${CLAUDE_CODE_PROJECTS_LANG:-${LC_ALL:-${LC_MESSAGES:-$LANG}}}
[[ -z "$lang" && "$(uname)" == "Darwin" ]] && lang=$(defaults read -g AppleLocale 2>/dev/null)
lang=${${lang:0:2}:l}
(( ${+parameters[i18n_$lang]} )) || lang=en

# [EN] English texts, overridden by those of the chosen language
# [ES] Textos en inglés, sustituidos por los del idioma elegido
typeset -A t
t=("${(@kv)i18n_en}")
table=i18n_$lang; t+=("${(@kvP)table}")

# [EN] Install command for the missing-dependencies message: brew on macOS; on Linux the package manager found (apt by default)
# [ES] Comando de instalación para el aviso de dependencias: brew en macOS; en Linux el gestor de paquetes que haya (apt por defecto)
if [[ "$(uname)" == "Darwin" ]]; then
  install_cmd="brew install fzf jq"
elif command -v dnf &>/dev/null; then
  install_cmd="sudo dnf install fzf jq"
elif command -v pacman &>/dev/null; then
  install_cmd="sudo pacman -S fzf jq"
else
  install_cmd="sudo apt install fzf jq"
fi

if ! command -v fzf &>/dev/null || ! command -v jq &>/dev/null; then
  echo "❌ ${t[missing_deps]//\{cmd\}/$install_cmd}"
  exit 1
fi

# [EN] Claude Code is needed to open the projects
# [ES] Claude Code hace falta para abrir los proyectos
if ! command -v claude &>/dev/null; then
  echo "❌ $t[missing_claude]"
  exit 1
fi

# [EN] The menu uses recent fzf options (--gutter needs 0.66.0), so older versions are rejected
# [ES] El menú usa opciones recientes de fzf (--gutter necesita la 0.66.0), así que se rechazan las anteriores
fzf_min_version=0.66.0
fzf_version=${${(s: :)"$(fzf --version)"}[1]}
autoload -Uz is-at-least
if ! is-at-least $fzf_min_version $fzf_version; then
  msg=${t[old_fzf]//\{v\}/$fzf_version}
  echo "❌ ${msg//\{min\}/$fzf_min_version}"
  exit 1
fi

if [[ ! -f ~/.claude.json ]]; then
  echo "❌ $t[no_config]"
  exit 1
fi

# [EN] date and stat take different options on macOS (BSD) and Linux/WSL (GNU)
#      file_mtime: modification date in seconds · format_time: seconds -> text in the given format
# [ES] date y stat tienen opciones distintas en macOS (BSD) y en Linux/WSL (GNU)
#      file_mtime: fecha de modificación en segundos · format_time: segundos -> texto con el formato dado
if [[ "$(uname)" == "Darwin" ]]; then
  file_mtime() { stat -f %m "$1" 2>/dev/null || echo 0 }
  format_time() { date -r "$1" "+$2" }
  yesterday_date() { date -v-1d +%Y%m%d }
else
  file_mtime() { stat -c %Y "$1" 2>/dev/null || echo 0 }
  format_time() { date -d "@$1" "+$2" }
  yesterday_date() { date -d yesterday +%Y%m%d }
fi

# [EN] Claude Code v2.1.288 dark theme colors (rgb, taken from its own code)
#      claude (orange, pointer) 215,119,87 · success (green) 78,186,101 · warning (yellow) 255,193,7
#      autoAccept (violet) 175,135,255 · inactive (text gray) 153,153,153 · promptBorder (line gray) 136,136,136
#      suggestion (search highlight) 177,185,249 · userMessageBackground (selection background) 55,55,55
# [ES] Colores del tema oscuro de Claude Code v2.1.288 (rgb, sacados de su propio código)
#      claude (naranja, flecha) 215,119,87 · success (verde) 78,186,101 · warning (amarillo) 255,193,7
#      autoAccept (violeta) 175,135,255 · inactive (gris del texto) 153,153,153 · promptBorder (gris de líneas) 136,136,136
#      suggestion (resaltado de búsqueda) 177,185,249 · userMessageBackground (fondo de selección) 55,55,55
fg() { printf '\e[38;2;%s;%s;%sm' "$@" }
orange=$(fg 215 119 87); white=$(fg 204 204 204); green=$(fg 78 186 101); yellow=$(fg 255 193 7)
violet=$(fg 175 135 255); gray=$(fg 153 153 153)
bold=$'\e[1m'; reset=$'\e[0m'; reset_fg=$'\e[39m'

# [EN] Colors for fzf (hex)
# [ES] Colores para fzf (hexadecimal)
fzf_orange='#D77757'; fzf_border='#888888'; fzf_highlight='#B1B9F9'; fzf_selection='#373737'

title=" ${orange}✻${reset} ${white}${t[title]//\{app\}/${reset}${bold}Claude Code${reset}${white}}${reset}"
# [EN] The same title without colors, to measure its width
# [ES] El mismo título sin colores, para medir su ancho
title_text=" ✻ ${t[title]//\{app\}/Claude Code}"
header="${green}Enter${reset} ${gray}${t[open]}${reset}${gray}  ·  ${reset}${yellow}Ctrl-R${reset} ${gray}${t[resume]}${reset}${gray}  ·  ${reset}${violet}Esc${reset} ${gray}${t[quit]}${reset}"

# [EN] Only folders that exist, with the date of their last session ("date<TAB>path"), most recent first.
#      The date is that of the most recently written session file (.jsonl), or 0 if there are none.
# [ES] Solo carpetas que existen, con la fecha de su última sesión ("fecha<TAB>ruta"), las más recientes primero.
#      La fecha es la del archivo de sesión (.jsonl) escrito más recientemente, o 0 si no hay ninguno.
local projects
projects=$(jq -r '.projects | keys[]' ~/.claude.json 2>/dev/null | while IFS= read -r project_path; do
  [[ -d "$project_path" ]] || continue
  sessions=( ~/.claude/projects/"${project_path//[^a-zA-Z0-9]/-}"/*.jsonl(N.om[1]) )
  mtime=$(file_mtime "${sessions[1]}")
  printf '%s\t%s\n' "$mtime" "$project_path"
done | sort -rn)

if [[ -z "$projects" ]]; then
  echo "❌ $t[no_projects]"
  exit 1
fi

today=$(date +%Y%m%d)
yesterday=$(yesterday_date)

# [EN] Width of the name column, so everything lines up
# [ES] Ancho de la columna del nombre, para que todo quede alineado
local name_width=0 mtime project_path
while IFS=$'\t' read -r mtime project_path; do
  (( ${#project_path:t} > name_width )) && name_width=${#project_path:t}
done <<< "$projects"

# [EN] Empty first line: fzf uses it as the list header, leaving a bottom margin under the projects
# [ES] Primera línea vacía: fzf la usa como cabecera de la lista y deja un margen inferior bajo los proyectos
local rows=$' \t \t \n'
local day last_session git_status changes color
while IFS=$'\t' read -r mtime project_path; do
  if (( mtime > 0 )); then
    day=$(format_time "$mtime" %Y%m%d)
    if [[ "$day" == "$today" ]]; then
      last_session="$t[today] $(format_time "$mtime" %H:%M)"
    elif [[ "$day" == "$yesterday" ]]; then
      last_session="$t[yesterday] $(format_time "$mtime" %H:%M)"
    else
      last_session="$(format_time "$mtime" "$t[date_format]")"
    fi
  else
    last_session="$t[no_sessions]"
  fi

  if git -C "$project_path" rev-parse --git-dir &>/dev/null; then
    changes=$(git -C "$project_path" status --porcelain -- . 2>/dev/null | wc -l | tr -d ' ')
    if (( changes > 0 )); then
      git_status="▲ ${t[unsaved]//\{n\}/$changes}"; color=$yellow
    else
      git_status="✔ $t[saved]"; color=$green
    fi
  else
    git_status="$t[no_git]"; color=$gray
  fi
  # [EN] Pad the uncolored text with spaces, so the columns line up
  # [ES] Se rellena con espacios el texto sin color, para que las columnas queden alineadas
  git_status="${color}${git_status}${reset_fg}${(l:$(( 18 - ${#git_status} )):: :)}"

  # [EN] "date<TAB>path<TAB>shown line": name · last session · git status · parent folder
  # [ES] "fecha<TAB>ruta<TAB>línea mostrada": nombre · última sesión · estado de git · carpeta padre
  rows+=$(printf '%s\t%s\t%-*s   %-16s   %s   %s' "$mtime" "$project_path" "$name_width" "${project_path:t}" "$last_session" "$git_status" "${gray}${${project_path:h}/#$HOME/~}${reset_fg}")$'\n'
done <<< "$projects"

# [EN] Title with the version on the right and a solid line below (cleared when the menu closes)
#      title_pad: spaces up to the version ("v" + right margin); without room, the version is not shown
# [ES] Título con la versión a la derecha y una línea continua debajo (se borra al cerrar el menú)
#      title_pad: espacios hasta la versión ("v" + margen derecho); si no cabe, no se muestra la versión
cols=$(tput cols)
title_pad=$(( cols - ${#title_text} - ${#version} - 2 ))
print
if (( title_pad > 0 )); then
  print -r -- "${title}${(l:$title_pad:: :)}${gray}v${version}${reset}"
else
  print -r -- "$title"
fi
print -r -- "${gray}${(l:$cols::─:)}${reset}"

local output
output=$(print -rn -- "$rows" | fzf \
  --ansi \
  --delimiter '\t' \
  --with-nth 3 \
  --expect ctrl-r \
  --tac \
  --header-lines 1 \
  --bind 'start:last' \
  --info inline-right \
  --no-separator \
  --highlight-line \
  --no-scrollbar \
  --input-border horizontal \
  --height ~60% \
  --min-height 6 \
  --header "$header" \
  --header-first \
  --prompt '❯ ' \
  --pointer '❯' \
  --gutter ' ' \
  --padding 1,0,0,0 \
  --color "prompt:$fzf_border,pointer:$fzf_orange,query:regular:-1,input-border:$fzf_border,hl:$fzf_highlight,hl+:$fzf_highlight,bg+:$fzf_selection,gutter:-1,info:$fzf_border")

# [EN] Clear the title (blank line + title + solid line)
# [ES] Borra el título (línea en blanco + título + línea continua)
printf '\e[3A\e[J'

if [[ -z "$output" ]]; then
  echo "👋 $t[goodbye]"
  exit 0
fi

key="${output%%$'\n'*}"
selection="${output#*$'\n'}"
project="${${selection#*$'\t'}%%$'\t'*}"

cd "$project" || exit 1

if [[ "$key" == "ctrl-r" ]]; then
  claude --continue
else
  claude
fi
