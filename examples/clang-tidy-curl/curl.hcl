# Public, cross-platform demo campaign: apply clang-tidy's
# readability-braces-around-statements fixes to curl's lib/vauth, one
# translation unit per review.
#
# `repo` is relative to this file, so the same config works on any host that
# keeps the curl fork checked out as a sibling of codemods-spec
# (e.g. ~/r/art/curl next to ~/r/art/codemods-spec).

codemod "curl-tidy-braces" {
  description = "clang-tidy readability-braces-around-statements over lib/vauth, one file at a time"

  repo        = "../../../curl"
  base_branch = "master"

  decomposition {
    type    = "glob"
    include = ["lib/vauth/*.c"]
    exclude = ["lib/vauth/digest.c"]
    kind    = "file"
  }

  run     = "./mods/clang-tidy-fix.sh"
  postmod = "./mods/build-and-test.sh"

  review {
    driver   = "github"
    repo     = "aozgaa/curl"
    push_url = "git@github.com:aozgaa/curl.git"
    title    = "[codemods] {codemod}: {unit}"
    body     = "Automated `clang-tidy -fix` (readability-braces-around-statements) over `{unit}`, applied and compile-verified by codemods."
  }

  notify {
    driver = "email"
    to     = ["aozgaa@gmail.com"]
    from   = "codemods@localhost"
    smtp   = "localhost:8025"
    on     = ["failed", "noop", "pr_open", "merged", "abandoned"]
  }
}
