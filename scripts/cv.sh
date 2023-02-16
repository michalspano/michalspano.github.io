#!/bin/sh

: '
  Script to copy my CV to the cv folder of the personal website.
  Used in the **root directory** of the website: ./scripts/cv.sh
  Made via Posix shell
  '

SRC="$HOME/Personal/CV/main.pdf"
OUT="./cv/exp/cv.pdf"

__copy_cv() {
  cp "$SRC" "$OUT"
  echo "Copied CV to $OUT"
}

__copy_cv
