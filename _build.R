#!/usr/bin/env Rscript
# Build du site : rend les .Rmd dans docs/ puis corrige les scories de rendu.
# Usage : Rscript _build.R

rmarkdown::render_site(encoding = "UTF-8")

# postcards insère header-attrs.js avec un chemin ABSOLU vers la bibliothèque R
# locale, qui serait un 404 une fois en ligne. On le repointe vers site_libs.
lib <- list.files("docs/site_libs", pattern = "^header-attrs", full.names = FALSE)
for (f in list.files("docs", pattern = "[.]html$", full.names = TRUE)) {
  x <- readLines(f, warn = FALSE, encoding = "UTF-8")
  if (!any(grepl("/Library/Frameworks|/usr/local/lib/R", x, fixed = FALSE))) next
  if (length(lib)) {
    x <- gsub('src="[^"]*/rmd/h/pandoc/header-attrs\\.js"',
              sprintf('src="site_libs/%s/header-attrs.js"', lib[1]), x)
  } else {
    x <- x[!grepl("header-attrs\\.js", x)]
  }
  writeLines(x, f, useBytes = TRUE)
  message("Chemin absolu corrigé dans ", f)
}

# distill ne génère pas de <link rel="canonical"> : on l'ajoute par page.
base <- "https://hoarauquentin.github.io/"
for (f in list.files("docs", pattern = "[.]html$", full.names = TRUE)) {
  x <- readLines(f, warn = FALSE, encoding = "UTF-8")
  if (any(grepl('rel="canonical"', x, fixed = TRUE))) next
  bn  <- basename(f)
  url <- if (bn == "index.html") base else paste0(base, bn)
  i <- grep("</head>", x, fixed = TRUE)[1]
  if (is.na(i)) next
  x <- append(x, sprintf('<link rel="canonical" href="%s">', url), after = i - 1)
  writeLines(x, f, useBytes = TRUE)
  message("Canonical ajouté dans ", bn)
}

# Garde-fou : plus aucun chemin machine ne doit subsister dans docs/
res <- suppressWarnings(system2("grep", c("-rl", "/Library/Frameworks", "docs"),
                                stdout = TRUE, stderr = FALSE))
if (length(res)) stop("Chemins absolus restants : ", paste(res, collapse = ", "))
message("Build OK — aucun chemin absolu dans docs/")
