{ pkgs, ... }: {
  imports = [
    ./modules/vcs/git.nix
    ./modules/cli/zellij.nix
    ./modules/terminal/ghostty.nix
    ./modules/prompt/starship.nix
    ./modules/history/atuin.nix
    ./modules/shells/nushell.nix
  ];

  home = {
    packages = with pkgs; [
      # net
      bind nmap inetutils

      # core
      openssl gnupg wget curl fd ripgrep eza
      nushell

      grc gh
      yt-dlp ffmpeg

      # dev
      docker-compose
      python3 uv
      go golangci-lint
    ];

    sessionPath = [
      "$HOME/go/bin"
      "$HOME/.local/bin"
      "/opt/homebrew/bin"
      "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
      "/etc/profiles/per-user/$USER/bin"
    ];

    sessionVariables = {
      GO111MODULE = "on";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
    file.".hushlogin".text = "";

    shell.enableNushellIntegration = true;
  };

  programs = {
    home-manager.enable = true;

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
      options = [ "--cmd j" ];
    };
    jq.enable = true;
    bat.enable = true;
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
    direnv = {
      enable = true;
      enableNushellIntegration = true;
    };

    go = {
      enable = true;
      env = {
        GOPATH = "$HOME/go";
        GOBIN = "$HOME/go/bin";
      };
    };

    fzf = {
      enable = true;
      defaultCommand =
        "fd --type f --hidden --follow --exclude .git --exclude .vim --exclude .cache --exclude vendor --exclude node_modules";
      defaultOptions = [
        "--border sharp"
        "--inline-info"
      ];
    };
  };
}
