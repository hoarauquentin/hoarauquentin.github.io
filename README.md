# hoarauquentin.github.io

Site personnel académique — [hoarauquentin.github.io](https://hoarauquentin.github.io/)

Construit avec [distill](https://rstudio.github.io/distill/) (pages internes) et
[postcards](https://github.com/seankross/postcards) (page d'accueil).

## Build

```sh
Rscript _build.R
```

Le script rend les `.Rmd` dans `docs/`, puis corrige deux limites des templates :
il repointe `header-attrs.js` (que postcards insère avec un chemin absolu vers la
bibliothèque R locale) vers `site_libs/`, et ajoute un `<link rel="canonical">` à
chaque page. Il échoue si un chemin absolu subsiste dans `docs/`.

Packages requis : `rmarkdown`, `distill`, `postcards`.

> **Note** : `renv.lock` est obsolète (il déclare R 4.0.4 et aucun package), donc
> `renv` bloque le build. Soit le régénérer (`renv::snapshot()` après installation
> des packages), soit retirer `renv` du projet et supprimer `.Rprofile`.

## Publication

GitHub Pages sert la branche `main`, dossier `/docs`. Un `git push` suffit :
il n'y a pas de workflow GitHub Actions (celui qui existait construisait un site
Jekyll depuis la racine, ce qui ne correspondait pas au déploiement réel).

## SEO

- `_header.html` : vérification Search Console, `robots`, `keywords` et le bloc
  JSON-LD `schema.org/Person` (ORCID, Google Scholar, EconomiX) injecté sur toutes
  les pages via `_site.yml`.
- `_header_home.html` : `description`, Open Graph et Twitter Card de la page
  d'accueil, que le template postcards ne génère pas.
- Les pages distill tirent leur `description` / Open Graph du champ `description:`
  de leur en-tête YAML : le laisser vide supprime la meta description.
- `robots.txt` et `.nojekyll` sont copiés dans `docs/` via la clé `include:` de
  `_site.yml`.
