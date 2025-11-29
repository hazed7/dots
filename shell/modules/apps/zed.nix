{ pkgs, lib, ... }:
let
  zedApp = "${pkgs.zed-editor}/Applications/Zed.app";
  zedCli = pkgs.writeShellApplication {
    name = "zed";
    text = ''
      managed_app="$HOME/Applications/Home Manager Apps/Zed.app"
      app_path="$managed_app"

      if [ ! -x "$app_path/Contents/MacOS/cli" ]; then
        app_path="${zedApp}"
      fi

      exec "$app_path/Contents/MacOS/cli" "$@"
    '';
  };
  settings = {
    icon_theme = "Soft Charmed Icons";
    edit_predictions = {
      enabled_in_text_threads = false;
    };
    show_edit_predictions = false;
    auto_update = false;
    telemetry = {
      diagnostics = false;
      metrics = false;
    };
    ui_font_size = 16;
    buffer_font_size = 15;
    theme = {
      mode = "system";
      light = "Ayu Light";
      dark = "Oxocarbon Dark (Variant I)";
    };
  };

  keymap = [
    {
      context = "Workspace";
      bindings = { };
    }
    {
      context = "Editor && vim_mode == insert";
      bindings = { };
    }
    {
      bindings."cmd-alt-c" = [
        "agent::NewExternalAgentThread"
        { agent = "codex"; }
      ];
    }
  ];

  extensions = [ "nix" "charmed-icons" "oxocarbon" ];
in {
  home.packages = [ pkgs.zed-editor zedCli ];

  home.file.".config/zed/settings.json".text = builtins.toJSON settings;
  home.file.".config/zed/keymap.json".text = builtins.toJSON keymap;

  home.activation.installZedExtensions =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      managed_app="$HOME/Applications/Home Manager Apps/Zed.app"
      app_path="$managed_app"

      if [ ! -x "$app_path/Contents/MacOS/cli" ]; then
        app_path="${zedApp}"
      fi

      cli_path="$app_path/Contents/MacOS/cli"

      for extension in ${lib.concatStringsSep " " extensions}; do
        "$cli_path" \
          --install-extension "$extension" >/dev/null 2>&1 || true
      done
    '';
}
