{ pkgs, lib, config, ... }:
let
  mkInline = lib.hm.nushell.mkNushellInline;
  cfgDir = config.programs.nushell.configDir;
  helperRelDir =
    let
      homePrefix = "${config.home.homeDirectory}/";
    in
    if lib.hasPrefix homePrefix cfgDir then
      lib.removePrefix homePrefix cfgDir
    else
      cfgDir;
in {
  programs.nushell = {
    enable = true;
    package = pkgs.nushell;
    plugins = with pkgs.nushellPlugins; [ gstat ];

    shellAliases = {
      # builtins
      size = "^du -sh";
      cp = "^cp -i";
      mkdir = "^mkdir -p";
      df = "^df -h";
      free = "^free -h";
      du = "^du -sh";
      del = "^rm -rf";

      # listings with eza
      ll = "eza -l --group-directories-first --icons";
      la = "eza -a --group-directories-first --icons";
      lt = "eza --tree --group-directories-first --icons -I .git";
      le = "eza --group-directories-first --icons";

      # overrides
      cat = "bat";
      diff = "delta";
      ssh = "^env TERM=screen ssh";
      python = "python3";
      pip = "python3 -m pip";
      venv = "python3 -m venv";

      # tooling
      g = "git";
      d = "docker";
      dc = "docker-compose";
      py = "python";
      zl = "zellij";

      nf = "sudo darwin-rebuild switch --flake ~/nix#air";
      nsh = "nix-shell";
      nse = "nix search nixpkgs";
    };

    environmentVariables = {
      ENV_CONVERSIONS = {
        PATH = {
          from_string = mkInline "{|s| $s | split row (char esep) }";
          to_string = mkInline "{|v| $v | str join (char esep) }";
        };
      };
    };

    extraConfig = ''
      let default_paths = [
        "/opt/homebrew/bin"
        "/run/current-system/sw/bin"
        $"/etc/profiles/per-user/($env.USER)/bin"
        ($env.HOME | path join ".nix-profile/bin")
        ($env.HOME | path join ".local/bin")
      ]

      $env.PATH = (
        $env.PATH?
        | default []
        | append $default_paths
        | uniq
      )

      $env.config = {
        show_banner: false
        edit_mode: vi
        cursor_shape: {
          vi_insert: line
          vi_normal: block
        }
        table: {
          mode: rounded
        }
      }

      use helper.nu *
    '';
  };

  home.file."${helperRelDir}/helper.nu".source = ./helper.nu;
}
