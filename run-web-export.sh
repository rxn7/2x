#!/usr/bin/env bash

godot --headless --export-debug "Web" ./builds/web/index.html
npx local-web-server --https --cors.embedder-policy require-corp --cors.opener-policy same-origin --directory ./builds/web
xdg-open https://localhost:8000