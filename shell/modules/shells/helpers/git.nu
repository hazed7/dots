export def clean [] {
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
