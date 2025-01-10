#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Helix Anywhere: With Selection
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🧬

# Documentation:
# @raycast.description Open a new temporary Alacritty window with an empty Helix buffer to compose text in.
# @raycast.author paulie
# @raycast.authorURL https://raycast.com/paulie

# This script is a simplified adaptation of the `vim-anywhere` project by
# Chris Knadler. REFERENCE: https://github.com/cknadler/vim-anywhere
#
# This script quickly opens an Alacritty window with a Helix buffer containing
# the currently selected text from another application for editing. After saving
# and quitting, the buffer is copied into the system clipboard for further
# usage.

# Save the currently-focused application to later switch back to it.
current_app=$(osascript -e 'tell application "System Events"' \
                         -e 'copy (name of application processes whose frontmost is true) to stdout' \
                         -e 'end tell')
# This file will hold the result text edited by Helix.
compose_file="/tmp/helix-anywhere.md"

# Use osascript to copy the current selection to the clipboard
osascript -e 'tell application "System Events" to keystroke "c" using command down'

# Wait a moment to ensure the clipboard has the copied text
sleep 0.25

# Pipes the clipboard contents to the compose file, optionally creating it if it
# doesn't exist.
pbpaste > "$compose_file"

# Edit the compose file with Helix.
alacritty -e /opt/homebrew/bin/nu -c "hx $compose_file"

# Copy the contents of the compose file into the system clipboard.
cat "$compose_file" | pbcopy

# Switch back to the previous application.
osascript -e "tell application \"$current_app\" to activate"
