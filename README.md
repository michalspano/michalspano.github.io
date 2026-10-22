# michalspano.com

Source of <https://michalspano.com>: Markdown content turned into a static site
by a small [Hakyll](https://jaspervdj.be/hakyll/) program.

## Quick start

You need GHC 9.6 and `cabal` (e.g. via [GHCup](https://www.haskell.org/ghcup/)),
plus `make` and `perl` (both preinstalled on macOS and most Linux systems).

```sh
make deps    # once: fetches and compiles Hakyll and pandoc (takes a while)
make watch   # preview at http://127.0.0.1:8000, rebuilding on every save
```

All commands go through the Makefile:

| Command                     | What it does                                              |
| --------------------------- | --------------------------------------------------------- |
| `make` / `make build`       | Build the whole site into `_site/`                        |
| `make watch`                | Preview locally, rebuilding on change (`PORT=…` to change) |
| `make check`                | Build, then fail on broken internal links                 |
| `make post TITLE="…"`       | Start a new blog post                                     |
| `make lint`                 | Lint the Haskell sources with HLint                       |
| `make clean` / `distclean`  | Remove build output (`distclean` also the compiled code)  |
| `make deps` / `freeze`      | Compile / re-pin the Haskell dependencies                 |
| `make help`                 | List all targets                                          |

## Writing

All content is [Pandoc Markdown](https://pandoc.org/MANUAL.html#pandocs-markdown)
in `content/`. The file's location decides its URL:

| Source                                | URL                       |
| ------------------------------------- | ------------------------- |
| `content/index.md`, `content/404.md`  | `/`, `/404.html`          |
| `content/pages/teaching.md`           | `/teaching/`              |
| `content/posts/2023-03-15-my-post.md` | `/blog/2023/my-post/`     |
| `content/projects/dotfiles.md`        | `/projects/dotfiles/`     |
| `static/assets/docs/file.pdf`         | `/assets/docs/file.pdf`   |

`/blog/` and `/projects/` are generated lists. Anything under `static/` is
copied to the site root as is.

### A new post

```sh
make post TITLE="Types for the working programmer"
# Created content/posts/2026-10-22-types-for-the-working-programmer.md
```

Write the post, preview it with `make watch`, and commit. The date in the
file name is the publication date; rename the file to change it.

### Front matter

| Key           | Applies to | Meaning                                                      |
| ------------- | ---------- | ------------------------------------------------------------ |
| `title`       | all        | Page heading and browser title                               |
| `description` | all        | Search/link-preview summary; shown under the heading on pages |
| `tags`        | all        | Comma-separated keywords (`<meta name="keywords">`)          |
| `order`       | projects   | Position on `/projects/` (required)                          |
| `link`        | projects   | External URL; such projects are listed but get no page       |

### Markdown cheat sheet

````markdown
Inline $e^{i\pi} + 1 = 0$ and display math:

$$\sum_{k=1}^{n} k = \frac{n(n+1)}{2}$$

> A quotation.

[A link](https://example.com) and [another page](/teaching/).

![A captioned figure](/assets/images/photo.png)

![](/assets/images/icon.png){width=64 .float-right} An image floated next to text.

::: centered
A centred block.
:::

```{=html}
<iframe src="https://www.youtube.com/embed/…" width="560" height="315" allowfullscreen></iframe>
```
````

- **Math** is TeX, typeset by MathJax, which is loaded only on pages that use it.
- **Links** to other sites open in a new tab automatically.
- **Images** that are alone in a paragraph and have alt text become figures
  with a caption. All images are lazy-loaded.
- **Embeds**: plain HTML works inline; wrap anything with `<script>` tags or
  that Pandoc should leave untouched in a ` ```{=html} ` block.
- **Code**: fenced blocks with a language (` ```haskell `) are highlighted.
- Footnotes (`[^1]`), tables and definition lists work as well.
- Pandoc needs a **blank line before** lists and block quotes.
- Utility classes for use in Markdown: `.portrait`, `.float-right`, `.centered`.

## Changing the site

| To change…                                   | Edit                   |
| -------------------------------------------- | ---------------------- |
| Colours (light and dark)                     | `css/theme.css`        |
| Layout and typography                        | `css/base.css`         |
| Code highlighting                            | `css/syntax.css`       |
| Page structure (HTML)                        | `templates/`           |
| Title, navigation, social links, analytics   | `src/Site/Config.hs`   |
| URL scheme                                   | `src/Site/Routes.hs`   |
| Markdown options and document transforms     | `src/Site/Pandoc.hs`   |
| Variables available in templates             | `src/Site/Context.hs`  |
| What gets built from what                    | `src/Site/Rules.hs`    |

Stylesheets are bundled into one minified `/css/main.css`, in the order listed
in `src/Site/Rules.hs`; add new files there. After editing Haskell code, run
`make` or restart `make watch`: both recompile the generator and rebuild from
scratch.

### Templates

Templates use [Hakyll's syntax](https://jaspervdj.be/hakyll/reference/Hakyll-Web-Template.html):
`$title$`, `$if(…)$…$endif$`, `$for(…)$…$endfor$`, `$partial("…")$`.
Every page is rendered with its content template (`page.html`, `post.html`,
`blog.html`, `projects.html`), then wrapped in `default.html`, which pulls in
the partials (`head`, `header`, `footer`, `math`, `analytics`).

Available variables: front matter keys under their own names, plus `body`,
`url`, `date`/`date-iso` (posts), `href` (projects), `site-title`,
`site-description`, `site-author`, `site-root`, `navigation`, `socials`,
`build-year`, `build-date` and `math`.

## Project layout

```
content/      Markdown: index.md, 404.md, pages/, posts/, projects/
templates/    HTML templates and partials
css/          Stylesheets (theme, base, syntax)
js/           Scripts (dark-mode toggle)
static/       Copied verbatim to the site root (favicons, CNAME, assets/)
src/Site/     The generator: Config, Routes, Pandoc, Context, Rules
app/Main.hs   Entry point
scripts/      Helper scripts used by the Makefile
```

## Deployment

Every push and pull request is built by GitHub Actions
(`.github/workflows/deploy.yml`), which runs `make check`; pushes to `main` are
then published to GitHub Pages. This requires *Settings → Pages → Source* to
be set to **GitHub Actions**.

The CV at `/cv/` is published from the separate
[`cv`](https://github.com/michalspano/cv) repository.
