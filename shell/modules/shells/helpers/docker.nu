export def local [...args] {
  let mount_path = ($env.PWD)
  ^docker run --rm -it -v $"($mount_path)":/usr/workdir --workdir /usr/workdir ...$args
}

export def clean [] {
  let containers = (^docker "container" "ls" "-aq" | lines | where ($it | str length) > 0)
  if ($containers | length) == 0 {
    print "No containers to clean"
    return
  }
  $containers | each { |id| ^docker "container" "rm" $id }
}
