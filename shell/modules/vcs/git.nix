{ ... }: {
  programs.git = {
    enable = true;

    ignores = [
      # ide
      ".idea"
      ".vs"
      ".vsc"
      ".vscode"
      # npm
      "node_modules"
      "npm-debug.log"
      # python
      "__pycache__"
      "*.pyc"

      ".ipynb_checkpoints" # jupyter
      "__sapper__" # svelte
      ".DS_Store" # mac
      "kls_database.db" # kotlin lsp
    ];

    settings = {
      user = {
        name = "Alexander Kostin";
        email = "iheartapplejr@gmail.com";
        signingkey = "/Users/hazed/.ssh/id_ed25519.pub";
      };
      gpg.format = "ssh";
      commit.gpgsign = true;

      alias = {
        cm = "commit";
        ca = "commit --amend --no-edit";
        co = "checkout";
        si = "switch";
        cp = "cherry-pick";

        df = "diff";
        dh = "diff HEAD";

        pu = "pull";
        ps = "push";
        pf = "push --force-with-lease";

        st = "status -sb";
        fe = "fetch";
        gr = "grep -in";

        ri = "rebase - i";
        rc = "rebase --continue";

        # commit aliases
        feat = ''!f() { case "$1" in *:*) git commit -m "✨ feat(''${1%%:*}): ''${1#*: }";; *) git commit -m "✨ feat: $1";; esac; }; f'';
        fix = ''!f() { case "$1" in *:*) git commit -m "🐛 fix(''${1%%:*}): ''${1#*: }";; *) git commit -m "🐛 fix: $1";; esac; }; f'';
        docs = ''!f() { case "$1" in *:*) git commit -m "📚 docs(''${1%%:*}): ''${1#*: }";; *) git commit -m "📚 docs: $1";; esac; }; f'';
        refactor = ''!f() { case "$1" in *:*) git commit -m "♻️ refactor(''${1%%:*}): ''${1#*: }";; *) git commit -m "♻️ refactor: $1";; esac; }; f'';
        ci = ''!f() { case "$1" in *:*) git commit -m "👷 ci(''${1%%:*}): ''${1#*: }";; *) git commit -m "👷 ci: $1";; esac; }; f'';
        chore = ''!f() { case "$1" in *:*) git commit -m "🔧 chore(''${1%%:*}): ''${1#*: }";; *) git commit -m "🔧 chore: $1";; esac; }; f'';
      };

      init.defaultBranch = "main";
      pull = {
        ff = false;
        commit = false;
        rebase = true;
      };
      fetch = { prune = true; };
      push.autoSetupRemote = true;
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
    };
  };
}
