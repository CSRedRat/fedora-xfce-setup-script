#!/bin/bash

#==============================================================================
#
#         FILE: fedora-ultimate-setup-script.sh
#        USAGE: fedora-ultimate-setup-script.sh
#
#  DESCRIPTION: Post-installation setup script for Fedora 29/30/31 Workstation
#      WEBSITE: https://github.com/David-Else/fedora-ultimate-setup-script
#
# REQUIREMENTS: Fresh copy of Fedora 29/30 installed on your computer
#               https://dl.fedoraproject.org/pub/fedora/linux/releases/31/Workstation/x86_64/iso/
#       AUTHOR: David Else
#      COMPANY: https://www.elsewebdevelopment.com/
#      VERSION: 3.0
#
# Use 'phpcbf --standard=WordPress file.php' to autofix and format Wordpress code
# Use 'composer global show / outdated / update' to manage composer packages
#==============================================================================

BOLD=$(tput bold)
GREEN=$(tput setaf 2)
RESET=$(tput sgr0)

if [ "$(id -u)" = 0 ]; then
    echo "You're root! Use ./fedora-ultimate-setup-script.sh" && exit 1
fi

# >>>>>> start of user settings <<<<<<

#==============================================================================
# gnome desktop settings
#==============================================================================
idle_delay=1200
title_bar_buttons_on="true"
clock_show_date="true"
capslock_delete="true"
night_light="true"

#==============================================================================
# git settings
#==============================================================================
git_email='example@example.com'
git_user_name='example-name'

#==============================================================================
# php.ini settings *namesco default setting
#==============================================================================
upload_max_filesize=128M
post_max_size=128M
max_execution_time=60

# >>>>>> end of user settings <<<<<<

#==============================================================================
# display user settings
#==============================================================================
clear
cat <<EOL
${BOLD}Gnome settings${RESET}
${BOLD}-------------------${RESET}

Increase the delay before the desktop logs out: ${GREEN}$idle_delay${RESET} seconds
Add minimize, maximize and close buttons to windows: ${GREEN}$title_bar_buttons_on${RESET}
Display the date on the desktop: ${GREEN}$clock_show_date${RESET}
Change caps into a backspace for touch typing: ${GREEN}$capslock_delete${RESET}
Turn on night light: ${GREEN}$night_light${RESET}

${BOLD}Git settings${RESET}
${BOLD}-------------------${RESET}

Global email: ${GREEN}$git_email${RESET}
Global user name: ${GREEN}$git_user_name${RESET}

${BOLD}PHP settings${RESET} (only if PHP is installed)
${BOLD}-------------------${RESET}

upload_max_filesize: ${GREEN}$upload_max_filesize${RESET}
post_max_size: ${GREEN}$post_max_size${RESET}
max_execution_time: ${GREEN}$max_execution_time${RESET}

EOL
read -rp "Press enter to setup, or ctrl+c to quit"

#==============================================================================
# set host name
#==============================================================================
read -rp "What is this computer's name? [$HOSTNAME] " hostname
if [[ ! -z "$hostname" ]]; then
    hostnamectl set-hostname "$hostname"
fi

#==============================================================================
# setup software (if it is installed)
#==============================================================================
hash mpv 2>/dev/null &&
    #==========================================================================
    # MPV
    #==========================================================================
    {
        mkdir -p "$HOME/.config/mpv"
        cat >"$HOME/.config/mpv/mpv.conf" <<EOL
profile=gpu-hq
hwdec=auto
fullscreen=yes
EOL
    }

hash pnpm 2>/dev/null &&
    #==========================================================================
    # pnpm
    #==========================================================================
    {
        if ! grep -xq "export NPM_CHECK_INSTALLER=pnpm" "$HOME/.bash_profile"; then
            cat >>"$HOME/.bash_profile" <<'EOL'
export NPM_CHECK_INSTALLER=pnpm
EOL
        fi
    }

hash php 2>/dev/null &&
    #==========================================================================
    # PHP
    #==========================================================================
    {
        for key in upload_max_filesize post_max_size max_execution_time; do
            sudo sed -i "s/^\($key\).*/\1 = ${!key}/" /etc/php.ini
        done
    }

hash composer 2>/dev/null &&
    #==========================================================================
    # Composer
    #==========================================================================
    {
        if ! grep -xq 'PATH=$PATH:/home/$USERNAME/.config/composer/vendor/bin' "$HOME/.bash_profile"; then
            cat >>"$HOME/.bash_profile" <<'EOL'
PATH=$PATH:/home/$USERNAME/.config/composer/vendor/bin
EOL
        fi
    }

hash code 2>/dev/null &&
    #==========================================================================
    # Visual Studio Code
    #==========================================================================
    {
        cat >"$HOME/.config/Code/User/settings.json" <<'EOL'
// Place your settings in this file to overwrite the default settings
{
  // VS Code 1.39
  // General settings
  "editor.fontSize": 15,
  "editor.renderWhitespace": "boundary",
  "editor.dragAndDrop": false,
  "editor.formatOnSave": true,
  "editor.minimap.enabled": false,
  "editor.detectIndentation": false,
  "editor.tabSize": 2,
  "editor.codeActionsOnSave": {
    "source.organizeImports": true
  },
  "workbench.activityBar.visible": false,
  "workbench.tree.renderIndentGuides": "none",
  "workbench.list.keyboardNavigation": "filter",
  "window.menuBarVisibility": "hidden",
  "window.enableMenuBarMnemonics": false,
  "window.titleBarStyle": "custom",
  "zenMode.restore": true,
  "zenMode.centerLayout": false,
  "zenMode.fullScreen": false,
  "git.autofetch": true,
  "git.enableSmartCommit": true,
  "git.decorations.enabled": false,
  "terminal.integrated.env.linux": {"PS1": "$ "},
  "explorer.decorations.colors": false,
  "search.followSymlinks": false,
  "breadcrumbs.enabled": false,
  "markdown.preview.fontSize": 15,
  "terminal.integrated.fontSize": 15,
  // Privacy
  "telemetry.enableTelemetry": false,
  "extensions.showRecommendationsOnlyOnDemand": true,
  // Language settings
  "javascript.preferences.quoteStyle": "single",
  "typescript.updateImportsOnFileMove.enabled": "always",
  "files.exclude": {
    "**/*.js": {
      "when": "$(basename).ts"
    },
    "**/*.js.map": true
  },
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescriptreact]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[html]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[jsonc]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  // Shell Format extension
  "shellformat.flag": "-i 4",
  // Live Server extension
  "liveServer.settings.donotShowInfoMsg": true,
  "liveServer.settings.ChromeDebuggingAttachment": true,
  "liveServer.settings.AdvanceCustomBrowserCmdLine": "/usr/bin/chromium-browser --remote-debugging-port=9222",
  // Spellright extension
  "spellright.language": [
    "English (British)"
  ],
  "spellright.documentTypes": [
    "markdown",
    "latex",
    "plaintext"
  ],
  // Markdown Preview Enhanced extension
  "markdown-preview-enhanced.usePandocParser": true,
  // "typescript.referencesCodeLens.enabled": true,
  // "javascript.referencesCodeLens.enabled": true,
}
EOL

        cat >"$HOME/.config/Code/User/keybindings.json" <<'EOL'
// Place your key bindings in this file to overwrite the defaults
[
  // when in explorer view create new file there
  { "key": "ctrl+n",
    "command": "explorer.newFile",
    "when": "explorerViewletFocus" },
  // capslock delete
  {
    "key": "capslock",
    "command": "deleteLeft",
    "when": "textInputFocus && !editorReadonly"
  },
  // expand/shrink selection vim style
  {
    "key": "shift+alt+l",
    "command": "editor.action.smartSelect.expand",
    "when": "editorTextFocus"
  },
  {
    "key": "shift+alt+h",
    "command": "editor.action.smartSelect.shrink",
    "when": "editorTextFocus"
  },
  // navigate back forward position
  {
    "key": "alt+left",
    "command": "workbench.action.navigateBack"
  },
  {
    "key": "alt+right",
    "command": "workbench.action.navigateForward"
  },
  // terminal style jump back and forward over words
  {
    "key": "alt+b",
    "command": "cursorWordStartLeft",
    "when": "textInputFocus"
  },
  {
    "key": "alt+f",
    "command": "cursorWordEndRight",
    "when": "textInputFocus"
  },
  // terminal style delete back and forward over words
  {
    "key": "alt+capslock",
    "command": "deleteWordLeft",
    "when": "textInputFocus && !editorReadonly"
  },
  {
    "key": "alt+d",
    "command": "deleteWordRight",
    "when": "textInputFocus && !editorReadonly"
  },
  // Lists with vim style shortcuts
  {
    "key": "alt+j",
    "command": "list.focusDown",
    "when": "listFocus"
  },
  {
    "key": "alt+k",
    "command": "list.focusUp",
    "when": "listFocus"
  },
  // Autosuggest with vim style shortcuts
  {
    "key": "alt+j",
    "command": "selectNextSuggestion",
    "when": "editorTextFocus && suggestWidgetMultipleSuggestions && suggestWidgetVisible"
  },
  {
    "key": "alt+k",
    "command": "selectPrevSuggestion",
    "when": "editorTextFocus && suggestWidgetMultipleSuggestions && suggestWidgetVisible"
  },
  // Quick open with vim style shortcuts
  {
    "key": "alt+j",
    "command": "workbench.action.quickOpenSelectNext",
    "when": "!editorFocus"
  },
  {
    "key": "alt+k",
    "command": "workbench.action.quickOpenSelectPrevious",
    "when": "!editorFocus"
  },
  // Cursor movement with vim style shortcuts
  {
    "key": "alt+k",
    "command": "cursorUp",
    "when": "textInputFocus && !suggestWidgetVisible"
  },
  {
    "key": "alt+j",
    "command": "cursorDown",
    "when": "textInputFocus && !suggestWidgetVisible"
  },
  {
    "key": "alt+h",
    "command": "cursorLeft",
    "when": "textInputFocus && !suggestWidgetVisible"
  },
  {
    "key": "alt+l",
    "command": "cursorRight",
    "when": "textInputFocus && !suggestWidgetVisible"
  }
]
EOL
    }

"$HOME/.config/composer/vendor/bin/phpcs" --config-set installed_paths ~/.config/composer/vendor/wp-coding-standards/wpcs
"$HOME/.config/composer/vendor/bin/phpcs" --config-set default_standard PSR12
"$HOME/.config/composer/vendor/bin/phpcs" --config-show

#==============================================================================
# setup gnome desktop gsettings
#==============================================================================
echo "${BOLD}Setting up Gnome desktop gsettings...${RESET}"

gsettings set org.gnome.desktop.session \
    idle-delay $idle_delay
gsettings set org.gnome.shell.extensions.auto-move-windows \
    application-list "['org.gnome.Nautilus.desktop:2', 'org.gnome.Terminal.desktop:3', 'code.desktop:1', 'firefox.desktop:1']"
gsettings set org.gnome.shell enabled-extensions \
    "['pomodoro@arun.codito.in', 'auto-move-windows@gnome-shell-extensions.gcampax.github.com']"

if [[ "${title_bar_buttons_on}" == "true" ]]; then
    gsettings set org.gnome.desktop.wm.preferences \
        button-layout 'appmenu:minimize,maximize,close'
fi

if [[ "${clock_show_date}" == "true" ]]; then
    gsettings set org.gnome.desktop.interface \
        clock-show-date true
fi

if [[ "${capslock_delete}" == "true" ]]; then
    gsettings set org.gnome.desktop.input-sources \
        xkb-options "['caps:backspace', 'terminate:ctrl_alt_bksp']"
fi

if [[ "${night_light}" == "true" ]]; then
    gsettings set org.gnome.settings-daemon.plugins.color \
        night-light-enabled true
fi

#==============================================================================
# setup pulse audio with the best sound quality possible
#
# *pacmd list-sinks | grep sample and see bit-depth available for interface
# *pulseaudio --dump-re-sample-methods and see re-sampling available
#
# *MAKE SURE your interface can handle s32le 32bit rather than the default 16bit
#==============================================================================
echo "${BOLD}Setting up Pulse Audio...${RESET}"
sudo sed -i "s/; default-sample-format = s16le/default-sample-format = s32le/g" /etc/pulse/daemon.conf
sudo sed -i "s/; resample-method = speex-float-1/resample-method = speex-float-10/g" /etc/pulse/daemon.conf
sudo sed -i "s/; avoid-resampling = false/avoid-resampling = true/g" /etc/pulse/daemon.conf

#==============================================================================
# setup jack audio for real time use
#==============================================================================
sudo usermod -a -G jackuser "$USERNAME" # Add current user to jackuser group
sudo tee /etc/security/limits.d/95-jack.conf <<EOL
# Default limits for users of jack-audio-connection-kit

@jackuser - rtprio 98
@jackuser - memlock unlimited

@pulse-rt - rtprio 20
@pulse-rt - nice -20
EOL

#==============================================================================
# setup git user name and email if none exist
#==============================================================================
if [[ -z $(git config --get user.name) ]]; then
    git config --global user.name $git_user_name
    echo "No global git user name was set, I have set it to ${BOLD}$git_user_name${RESET}"
fi

if [[ -z $(git config --get user.email) ]]; then
    git config --global user.email $git_email
    echo "No global git email was set, I have set it to ${BOLD}$git_email${RESET}"
fi

#==============================================================================================
# turn on subpixel rendering for fonts without fontconfig support
#==============================================================================================
if ! grep -xq "Xft.lcdfilter: lcddefault" "$HOME/.Xresources"; then
    echo "Xft.lcdfilter: lcddefault" >>"$HOME/.Xresources"
fi

#==============================================================================================
# improve ls and tree commands output
#==============================================================================================
cat >>"$HOME/.bashrc" <<EOL
alias ls="ls -ltha --color --group-directories-first" # l=long listing format, t=sort by modification time (newest first), h=human readable sizes, a=print hidden files
alias tree="tree -Catr --noreport --dirsfirst --filelimit 100" # -C=colorization on, a=print hidden files, t=sort by modification time, r=reversed sort by time (newest first)
EOL

#==============================================================================================
# increase the amount of inotify watchers
#==============================================================================================
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

touch $HOME/Templates/empty-file # so you can create new documents from nautilus

cat <<EOL
  ===================================================
  Please reboot (or things may not work as expected)
  ===================================================
EOL
