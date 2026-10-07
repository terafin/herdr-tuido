#!/bin/sh
exec "${HERDR_BIN_PATH:-herdr}" plugin pane open --plugin herdr-tuido --entrypoint board \
  --placement split --direction right --focus
