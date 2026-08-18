# Personal Hugo website

A small personal website built with [Hugo](https://gohugo.io/) and pinned with Nix.

## Work locally

With Nix installed:

```sh
nix develop
hugo server --buildDrafts
```

Open the address Hugo prints (normally `http://localhost:1313`). Build the production site with:

```sh
nix build .#website
```

The generated website is available through the `result` symlink.

## Personalize it

Update the name and social links in `hugo.toml`, then edit the pages under `content/`. Posts live in `content/posts/`.

## Publications

Keep your publications in `assets/bib/publications.bib`. Generate Hugo's data after editing it:

```sh
nix run .#bibman-gen
```

The command uses [Bibman](https://codeberg.org/KMIJPH/bibman) to extract the BibTeX metadata and prints the generated JSON to standard output. `nix build .#website` captures it in `HUGO_PUBLICATIONS_JSON` before running Hugo, without creating an intermediate file. `nix develop` exports the same variable so the publications page also works with `hugo server`; re-enter the development shell after changing the BibTeX file.

## Styles and colour schemes

Hugo compiles and fingerprints `assets/scss/site.scss` on every build. Edit `assets/scss/_tokens.scss` to change the light and dark colour schemes without touching layout rules. The site follows the visitor's operating-system preference by default; the navigation switch lets them choose and remembers that choice in their browser.

## Publish with GitHub Pages

1. Create a GitHub repository and push this project to its `main` branch.
2. In the repository, open **Settings → Pages** and set the publishing source to **GitHub Actions**.
3. Push to `main`; `.github/workflows/deploy.yml` builds the site with Nix and deploys it.

For a user site, name the repository `<your-github-username>.github.io`. Project repositories also work because the site uses relative links.
