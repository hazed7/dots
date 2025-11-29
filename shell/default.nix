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
    file."Library/Fonts/sketchybar-app-font.ttf".source = pkgs.fetchurl {
      url = "https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.28/sketchybar-app-font.ttf";
      sha256 = "1ppis4k4g35gc7zbfhlq9rk4jq92k3c620kw5r666rya38lf77p4";
    };

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
