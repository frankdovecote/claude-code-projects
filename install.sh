#!/usr/bin/env sh
# [EN] Installer for claude-code-projects. Usage: curl -fsSL <url>/install.sh | sh
#      INSTALL_DIR changes the destination folder (default: ~/.local/bin).
# [ES] Instalador de claude-code-projects. Uso: curl -fsSL <url>/install.sh | sh
#      INSTALL_DIR cambia la carpeta de destino (por defecto: ~/.local/bin).
set -eu

url="https://github.com/frankdovecote/claude-code-projects/releases/latest/download/claude-code-projects.sh"
install_dir=${INSTALL_DIR:-$HOME/.local/bin}
# [EN] Expand a leading "~" (quoted, the shell does not do it) and drop trailing slashes
# [ES] Se expande un "~" inicial (entre comillas, el shell no lo hace) y se quitan las barras finales
case $install_dir in
  "~") install_dir=$HOME ;;
  "~/"*) install_dir=$HOME/${install_dir#"~/"} ;;
esac
while [ "$install_dir" != "/" ] && [ "${install_dir%/}" != "$install_dir" ]; do
  install_dir=${install_dir%/}
done
target="$install_dir/claude-code-projects"
fzf_min_version=0.66.0

# [EN] Temporary file for the download, always removed on exit
# [ES] Archivo temporal para la descarga, que siempre se borra al salir
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

# [EN] Download first: if it fails, nothing is installed
# [ES] Primero se descarga: si falla, no se instala nada
echo "Downloading claude-code-projects..."
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$url" -o "$tmp" || { echo "Error: download failed ($url)" >&2; exit 1; }
elif command -v wget >/dev/null 2>&1; then
  wget -qO "$tmp" "$url" || { echo "Error: download failed ($url)" >&2; exit 1; }
else
  echo "Error: curl or wget is needed to download the script" >&2
  exit 1
fi

# [EN] The file must be a script (starts with #!), not an empty file or an error page
# [ES] El archivo debe ser un script (empieza por #!), no un archivo vacío ni una página de error
case $(head -n 1 "$tmp") in
  "#!"*) ;;
  *) echo "Error: the downloaded file is not a script, nothing was installed" >&2; exit 1 ;;
esac

# [EN] Install as "claude-code-projects" (no .sh), creating the folder if needed
# [ES] Se instala como "claude-code-projects" (sin .sh), creando la carpeta si hace falta
if ! mkdir -p "$install_dir" 2>/dev/null || [ ! -w "$install_dir" ]; then
  echo "Error: cannot write to $install_dir. Use another folder (INSTALL_DIR=\$HOME/bin) or run with sudo" >&2
  exit 1
fi
cp "$tmp" "$target"
chmod 755 "$target"
echo "Installed: $target"

# [EN] version_ge A B: succeeds if version A is greater than or equal to version B (numbers only, like 0.66.0)
# [ES] version_ge A B: tiene éxito si la versión A es mayor o igual que la B (solo números, como 0.66.0)
version_ge() {
  a_rest=$1.0.0; b_rest=$2.0.0
  for _ in 1 2 3; do
    a=${a_rest%%.*}; a_rest=${a_rest#*.}
    b=${b_rest%%.*}; b_rest=${b_rest#*.}
    [ "$a" -gt "$b" ] && return 0
    [ "$a" -lt "$b" ] && return 1
  done
  return 0
}

# [EN] Install command to suggest: brew on macOS; on Linux the package manager found (apt by default)
# [ES] Comando de instalación que se sugiere: brew en macOS; en Linux el gestor de paquetes que haya (apt por defecto)
if [ "$(uname)" = "Darwin" ]; then
  install_cmd="brew install fzf jq"
elif command -v dnf >/dev/null 2>&1; then
  install_cmd="sudo dnf install fzf jq"
elif command -v pacman >/dev/null 2>&1; then
  install_cmd="sudo pacman -S fzf jq"
else
  install_cmd="sudo apt install fzf jq"
fi

# [EN] Missing or outdated dependencies only warn, they do not stop the installation
# [ES] Las dependencias que falten o estén anticuadas solo avisan, no paran la instalación
echo
command -v zsh >/dev/null 2>&1 || echo "Warning: zsh not found (the script needs it to run)"
command -v jq >/dev/null 2>&1 || echo "Warning: jq not found. Install: $install_cmd"
command -v claude >/dev/null 2>&1 || echo "Warning: Claude Code not found (command: claude)"
if ! command -v fzf >/dev/null 2>&1; then
  echo "Warning: fzf not found. Install: $install_cmd"
else
  fzf_version=$(fzf --version | cut -d' ' -f1)
  if ! version_ge "$fzf_version" "$fzf_min_version"; then
    echo "Warning: fzf $fzf_version is too old, version $fzf_min_version or newer is needed"
  fi
fi

# [EN] If the folder is not in the PATH, tell how to add it
# [ES] Si la carpeta no está en el PATH, se explica cómo añadirla
case ":$PATH:" in
  *":$install_dir:"*) ;;
  *)
    echo
    echo "$install_dir is not in your PATH. Add this line to ~/.zshrc:"
    echo "  export PATH=\"$install_dir:\$PATH\""
    ;;
esac
