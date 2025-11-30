{ lib, ... }:
let
  mkCommitAlias = type: emoji: ''!f() { case "$1" in *:*) git commit -m "${emoji} ${type}(''${1%%:*}): ''${1#*: }";; *) git commit -m "${emoji} ${type}: $1";; esac; }; f'';
in
{
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

        ri = "rebase -i";
        rc = "rebase --continue";

        # commit aliases
        feat = mkCommitAlias "feat" "✨";
        fix = mkCommitAlias "fix" "🐛";
        docs = mkCommitAlias "docs" "📚";
        refactor = mkCommitAlias "refactor" "♻️";
        ci = mkCommitAlias "ci" "👷";
        chore = mkCommitAlias "chore" "🔧";
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
