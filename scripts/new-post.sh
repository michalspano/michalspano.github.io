#!/bin/sh
# Create a new blog post: scripts/new-post.sh "Post title"
#
# The file is content/posts/<today>-<slug>.md; its name sets both the post's
# date and its URL, /blog/<year>/<slug>/.
set -eu

title=${1:-}
if [ -z "$title" ]; then
  echo 'usage: make post TITLE="Post title"' >&2
  exit 2
fi

# Strip diacritics (Ö -> O, Ď -> D, ...), then keep only [a-z0-9-].
slug=$(printf '%s' "$title" \
  | perl -CS -MUnicode::Normalize -pe '$_ = NFD($_); s/\pM//g' \
  | tr '[:upper:]' '[:lower:]' \
  | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')
if [ -z "$slug" ]; then
  echo "error: cannot derive a file name from \"$title\"" >&2
  exit 1
fi

file="content/posts/$(date +%Y-%m-%d)-$slug.md"
if [ -e "$file" ]; then
  echo "error: $file already exists" >&2
  exit 1
fi

# Escape backslashes and double quotes for a double-quoted YAML string.
yaml_title=$(printf '%s' "$title" | sed 's/\\/\\\\/g; s/"/\\"/g')

cat > "$file" <<EOF
---
title: "$yaml_title"
# description: One sentence for search engines and link previews.
# tags: comma, separated, keywords
---

Write the post here, in Pandoc Markdown.
EOF

echo "Created $file"
