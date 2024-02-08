#!/usr/bin/env bash

set -e

BUTLER_NAME="rxn7/2x"

rm -rf ./builds

mkdir -p ./builds/web
godot --headless --export-release "Web" ./builds/web/index.html && butler push ./builds/web "$BUTLER_NAME:html5"

mkdir -p ./builds/android
godot --headless --export-release "Android" ./builds/android/2x.apk && butler push ./builds/android/2x.apk "$BUTLER_NAME:android"

mkdir -p ./builds/linux
godot --headless --export-release "Linux" ./builds/linux/2x.x86_64 && butler push ./builds/linux "$BUTLER_NAME:linux"

mkdir -p ./builds/windows
godot --headless --export-release "Windows" ./builds/windows/2x.exe && butler push ./builds/windows "$BUTLER_NAME:windows"