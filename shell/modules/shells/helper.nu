export def dklocal [...args] {
  let mount_path = ($env.PWD)
  ^docker run --rm -it -v $"($mount_path)":/usr/workdir --workdir /usr/workdir ...$args
}

export def dkclean [] {
  let containers = (^docker "container" "ls" "-aq" | lines | where ($it | str length) > 0)
  if ($containers | length) == 0 {
    return
  }
  $containers | each { |id| ^docker "container" "rm" $id }
}

export def clean [] {
  ^nix-collect-garbage -d
  ^nix-store --gc
  ^nix store optimise
  ^nix-store --verify --check-contents
}

export def --wrapped psf [...rest] {
  ^ps aux | rg ...$rest
}

export def --wrapped lsf [...rest] {
  ^ls | rg ...$rest
}

export def gclean [] {
  ^git fetch -p
  ^git "for-each-ref" "refs/heads" "--format=%(refname:short) %(upstream:track)"
    | lines
    | where ($it | str contains "[gone]")
    | each { |line|
        let branch = ($line | str trim | split row " " | get 0)
        if $branch != "" {
          ^git "branch" "-D" $branch
        }
      }
}
